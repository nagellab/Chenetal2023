% RJF 24 OCT 2022


function [pre_avg_angv, stim_avg_angv, post_avg_angv] = averageangvel(data)
pre_avg_angv = []
post_avg_angv = []
stim_avg_angv = []

flies = length(data);
for i = 1:flies;
    angv = data(i).angv;
    sz = size(angv);    
    pre = angv(1000:1499,:);
    stim = angv(1500:1999,:);
    post = angv(2000:2499,:);
    pre_avg_fly = mean(mean(pre));
    stim_avg_fly = mean(mean(stim));
    post_avg_fly = mean(mean(post));
    pre_avg_angv(1,i) = pre_avg_fly;
    stim_avg_angv(1,i) = stim_avg_fly;
    post_avg_angv(1,i) = post_avg_fly;
end;









