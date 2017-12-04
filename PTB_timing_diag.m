% Screen test for PTB, with timing indicator and diagnostic info
% axs Dec17


if isunix
    ptb_path_here = '/Users/Shared/toolboxes/PTB_3014/Psychtoolbox';
else
    ptb_path_here = 'C:\Shared\toolboxes\PTB_3014/Psychtoolbox';
end

ptb_path_check(ptb_path_here);


sca;
PsychDefaultSetup(2);

screens = Screen('Screens');
screenNumber = max(screens);

sc_white = WhiteIndex(screenNumber);
sc_black = BlackIndex(screenNumber);
gry = [0.5 0.5 0.5];
drk_gry = [0.3 0.3 0.3];

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, drk_gry);

[screenXpixels, screenYpixels] = Screen('WindowSize', window);

Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

Screen('TextSize', window, 30);

% The avaliable keys to press
escapeKey = KbName('ESCAPE');

[xCenter, yCenter] = RectCenter(windowRect);
backX = round(0.95*screenXpixels);
backY = round(0.95*screenYpixels);

back_rect = [0 0 backX backY];
center_back = CenterRectOnPointd(back_rect, xCenter, yCenter);




waitframes = 1;


% setup timing stripe indicators
% A stripe across the screen, made of dots in cells
nDotsPerStripe = 60*10;  % 10x 60 frames?
stripeLen = center_back(3)-center_back(1);
cellLen = floor(stripeLen / nDotsPerStripe);
cellH = 2;

n_runs = 1000;
vbls = zeros(n_runs,1);
vbl_diffs = zeros(n_runs,1);
vbls_so_far = 0;

cell_colours = zeros(n_runs,3);
cell_colours(:,2) = 1;

missed_frames = zeros(n_runs,1);


% iterators
j=1;
stripej = 1;



Screen('FillRect', window,gry,center_back)

% sync setup
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
vbl0 = Screen('Flip', window);
vbl_last = vbl0;
vbl_last_diff = 0;

exit_now = false;
while (exit_now == false)
    
    % Check button presses, handle them
    [keyIsDown,secs, keyCode] = KbCheck;
    
    if keyCode(escapeKey)
        exit_now = true;
    end
    
    Screen('FillRect', window,gry,center_back)
    
    % Prepare a string of some diagnostic info, print text to screen
    if j > 1
        vbls_so_far = vbl_diffs(1:j);
        vbl_mean_so_far = round(mean(vbls_so_far)*1000,2);
        
        diag_titles = 'Frame number: \nAverage frame time (ms):';
        DrawFormattedText(window, diag_titles, 0.7*screenXpixels, 100, [0 0 0]);
        diag_info = [num2str(j) '\n' num2str(vbl_mean_so_far)];
        DrawFormattedText(window, diag_info, 0.7*screenXpixels+400, 100, [0 0 0]);
        
        % set colours to indicate frame issues
        if vbl_last_diff > ifi*1.2
            % missed a frame
            missed_frames(j) = vbl_last_diff;
            cell_colours(j,:) = [1 0 0];
        end
    end
    
    % setup locs for this dot
    cell0X = center_back(1);
    cell0Y = center_back(2);
    this_cell = [cell0X+j*cellLen-cellLen cell0Y+stripej*cellH+1-cellH+1 0 0];
    this_cell(3) = this_cell(1) + cellLen;
    this_cell(4) = this_cell(2) + cellH;
    allcells(j).cell = this_cell;
    
    
    % Draw all the rectangle cells, each in the apporpriate colour
    for i = 1:j
        
        Screen('FillRect', window,cell_colours(i,:),allcells(i).cell)
    end
    
    % Test with a multi-ifi pause
    testpause = 1;
    if testpause
        not_even_hundred = mod(j,100);
        if not_even_hundred == 0
            pause(ifi*1.5);
        end
    end
    
    
    
    
    vbl_here = Screen('Flip', window, 0); % wait for next vlb and flip
    % if on time, this should be the immediate next vbl, missing no frames
    
    vbls(j) = vbl_here - vbl0;
    vbl_last_diff = vbls(j) - vbl_last;
    vbl_diffs(j) = vbl_last_diff;
    vbl_last = vbls(j);
    vbl_diffs(1) = ifi;
    
    % update loop / frame counter
    j=j+1;
    if j > nDotsPerStripe
        exit_now = true;
    end
    
    
end

disp(diag_titles)
disp(diag_info)
%sca;