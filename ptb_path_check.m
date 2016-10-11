function current_ptb = ptb_path_check(desired_ptb_path)


% PTB check
% Provide a path to load PsychToolBox (PTB) from.
% The old path to PTB will be removed from the Matlab PATH,
% and this new path will be added instead.
%
% axs 2016

if nargin == 0
    disp('Desired PTB path not set. Trying a default.')
    
    if isunix
        desired_ptb_path = '/Users/Shared/toolboxes/PTB_3012/Psychtoolbox';
    else
        desired_ptb_path = 'C:\Shared\toolboxes\PTB_3012\Psychtoolbox';
    end
end

% your path to the Psychtoolbox folder, ending in '/Psychtoolbox'




old_ptb_path = which('PsychtoolboxVersion.m');
old_ptb_path = old_ptb_path(1:end-33); % to PTB folder

try
    % test to see if PTB is actually in the desired path
    assert(exist(desired_ptb_path,'dir') == 7)
    assert(exist([desired_ptb_path '/SetupPsychtoolbox.m'],'file') == 2)
    
catch ME
    text = ['WARNING - Psychtoolbox was not found in the requested folder of ' desired_ptb_path];
    disp(text)
    text = 'Please check the path and the contents of that folder and try again. Specify path including the Psychtoolbox.';
    disp(text)
    text = 'Please press enter to continue';
    usr_press = input(text,'s');
    return
end



if strcmpi(old_ptb_path,desired_ptb_path)
    % if the old path matches the desired path
    disp('Desired PTB version currently in path')
    current_ptb = PsychtoolboxVersion
    
    
    
    
    
    
else
    % if paths don't match
    
    
    
    text = [' Psychtoolbox is currently set to ' old_ptb_path];
    disp(text)
    text = ['rather than the requested path of ' desired_ptb_path];
    disp(text)
    text = 'At the following prompts, please enter ''yes'' twice, hit enter, and wait for the PTB path change to complete';
    disp(text)
    text = 'This is only needed once for each PTB path change.';
    disp(text)
    text = 'Please press enter to continue';
    usr_press = input(text,'s');
    
    
    % save current path, run PTB setup to organise path
    old_wd = pwd;
    cd(desired_ptb_path)
    SetupPsychtoolbox
    cd(old_wd)

    current_ptb = PsychtoolboxVersion
    
end



% also check that PsychJava is in the Java class path
found_pjava = 0;
jpath = javaclasspath('-all');
for i=1:numel(jpath)
    [j1 java_entries{i}] = fileparts(jpath{i});
    if strcmpi(java_entries{i}, 'PsychJava')
        found_pjava = 1;
    end
end

try assert(found_pjava == 1)
    
catch
    display('WARNING - PsychJava not in classpath. Ensure Psychtoolbox is correctly installed, and your have write access to Matlab java classpath (MATLAB/R2014a/toolbox/local/classpath.txt) on installing PTB.');
end
