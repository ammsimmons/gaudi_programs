# The LuckLab Psychtoolbox Guide


## Installation and Matlab path
When using Psychtoolbox, be wary of running it from the default install path. Someone else installing a new version could interfere with your experiment.

To avoid this, please run from a version-specific path, like:

>  /Users/Shared/toolboxes/PTB_VERSION_NUMBER/Psychtoolbox

To make this easier, we have a function to verify the path and PTB version. Before running any Psychtoolbox code, please run ```ptb_path_check(desired_path)```. For instance, to run Psychtoolbox v3.0.1.2, copy the correct install path to the shared folder, then, in your experiment code, run:

```matlab
ptb_path_check('/Users/Shared/toolboxes/PTB_3012/Psychtoolbox')
```

This will add this PTB path to your Matlab path, so that only that declared version of Psychtoolbox is used. Any other Psychtoolbox references are cleared from your Matlab path. This version information is then also in your experimental code for posterity

The Matlab function ```ptb_path_check``` can be found [here](https://github.com/lucklab/erplab-programming-references/tree/master/Psychtoolbox) (right-click on ptb_path_check.m, save-as).

Ask Andrew if you have any problem with Psychtoolbox paths or installations.
