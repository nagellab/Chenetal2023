%gettraces with a jackknife method for calcualting the error except for the
%curvature which is complicated by the NaN values. This was calculated with
%std and 'omitnan' as was done in Efren's original code.

%RJF 26 APRIL 2023

function [plots] = gettraces_jk(data)

flies = length(data);

vel_avg = [];
vel_sem = [];
pmove_avg = [];
pmove_sem = [];
pturn_avg = [];
pturn_sem = [];
angv_avg = [];
angv_sem = [];
upwind_avg = [];
upwind_sem = [];
curv_avg = [];
curv_sem = [];

for i = 1:flies
    avg_vel__fly = mean(data(i).v,2);
    vel_avg = [vel_avg avg_vel__fly];
    vel_sem = [vel_sem calcerror(data(i).v)];

    avg_pmove_fly = mean(data(i).pmove,2);
    pmove_avg = [pmove_avg avg_pmove_fly];
    pmove_sem = [pmove_sem calcerror(data(i).pmove)];

    avg_pturn_fly = mean(data(i).pturn, 2);
    pturn_avg = [pturn_avg avg_pturn_fly];
    pturn_sem = [pturn_sem calcerror(data(i).pturn)];

    avg_angv_fly = mean(data(i).angv,2);
    angv_avg = [angv_avg avg_angv_fly];
    angv_sem = [angv_sem calcerror(data(i).angv)];

    avg_upwind_fly = mean(data(i).vy,2);
    upwind_avg = [upwind_avg avg_upwind_fly];
    upwind_sem = [upwind_sem calcerror(data(i).vy)];

    curv_avg = [curv_avg mean(data(i).curvature,2,"omitnan")];
    
end

sz = size(vel_sem);

curv_sem = std(curv_avg', 'omitnan')/sqrt(sz(2));

size(curv_sem)

vel_avg = mean(vel_avg,2);
pmove_avg = mean(pmove_avg, 2);
pturn_avg = mean(pturn_avg,2);
angv_avg = mean(angv_avg,2);
upwind_avg = mean(upwind_avg,2);
curv_avg = mean(curv_avg,2,"omitnan");




vel_sem = rssq(vel_sem,2)/sz(2);
pmove_sem = rssq(pmove_sem,2)/sz(2);
pturn_sem = rssq(pturn_sem,2)/sz(2);
angv_sem = rssq(angv_sem,2)/sz(2);
upwind_sem = rssq(upwind_sem,2)/sz(2);


size(vel_sem)


plots = table(vel_avg,vel_sem, pmove_avg,pmove_sem, pturn_avg, pturn_sem,angv_avg, angv_sem, upwind_avg, upwind_sem, curv_avg, curv_sem', 'VariableNames',{'Vel Avg','Vel Sem', 'Prob of Move Avg', 'Prob of Move SEM', 'Prob of Turn Avg','Prob of Turn SEM', 'Angular Velocity Avg', 'Angular Velocity SEM','Upwind Velocity Avg', 'Upwind Velocity SEM', 'Curvature Avg', 'Curvature SEM'});

