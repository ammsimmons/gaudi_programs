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


if numel(old_ptb_path) == 0
    % if old path is empty, then just add the new desired path
    
    disp('PTB not found in path. Adding desired path.')
    addpath(genpath(desired_ptb_path))  % genpath adds subfolders too
    
    % Check PTB again, to check that is is now in path
    check_ptb_path = which('PsychtoolboxVersion.m');
    if numel(check_ptb_path) == 0  % path still empty, even after adding desired path
        disp('PTB does not seem to be in old path or in the desired path.')
        disp('Ensure PTB is installed in the desired shared location and try again')
    else
        disp('Desired PTB added to path')
        current_ptb = PsychtoolboxVersion
    end
        
    
    
    
elseif old_ptb_path == desired_ptb_path
    disp('Desired PTB version currently in path')
    current_ptb = PsychtoolboxVersion
    
else
    
    disp('Removing old PTB from path')
    oldpath = path;
    
    %do some stuff to clear trace of old PTB path
    rmpath(genpath(old_ptb_path));
    
    
    disp('Adding desired PTB path')
    addpath(genpath(desired_ptb_path))
    current_ptb = PsychtoolboxVersion
    
end

