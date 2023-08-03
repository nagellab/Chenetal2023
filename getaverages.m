% RJF 24 OCT 2022


function [T] = getaverages(data)

[angvel_pre, angvel_stim, angvel_post] =averageangvel(data);
[pmove_pre, pmove_stim, pmove_post] = averagepmove(data);
[upwind_pre, upwind_stim, upwind_post] = averageupwindvel(data);
[vel_pre, vel_stim, vel_post] = averagevel(data);
[pturn_pre, pturn_stim, pturn_post] = averagepturn(data);
[curve_pre,curve_stim,curve_post] = averagecurve(data);

T = table (angvel_pre', angvel_stim', angvel_post',pmove_pre', pmove_stim', pmove_post',upwind_pre', upwind_stim', upwind_post',vel_pre', vel_stim', vel_post',pturn_pre', pturn_stim', pturn_post',curve_pre',curve_stim',curve_post', 'VariableNames',{'Angular Velocity Pre', 'Angular Velocity Stimulus', 'Angular Velocity Post','Pmove Pre','Pmove Stim','Pmove Post','Upwind Pre', 'Upwind stim', 'Upwind Post','Vel Pre', 'Vel Stimulus', 'Vel Post', 'Pturn pre', 'Pturn stim', 'Pturn post', 'Curv pre', 'Curv stim', 'Curv, post'})
