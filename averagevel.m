% RJF 24 OCT 2022

function [pre_avg_v,stim_avg_v,post_avg_v] = averagevel(data)
pre_avg_v = []
post_avg_v = []
stim_avg_v = []

flies = length(data);
for i = 1:flies;
    vel = data(i).v;
    sz = size(vel);    
    pre = vel(1000:1499,:);
    stim = vel(1500:1999,:);
    post = vel(2000:2499,:);
    pre_avg_fly = mean(mean(pre));
    stim_avg_fly = mean(mean(stim));
    post_avg_fly = mean(mean(post));
    pre_avg_v(1,i) = pre_avg_fly;
    stim_avg_v(1,i) = stim_avg_fly;
    post_avg_v(1,i) = post_avg_fly;
end;









