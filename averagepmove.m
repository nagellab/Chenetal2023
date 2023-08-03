%% RJF 24 OCT 2022


function [pre_avg_pmove, stim_avg_pmove, post_avg_pmove] = averagepmove(data)
pre_avg_pmove = []
post_avg_pmove = []
stim_avg_pmove = []

flies = length(data);
for i = 1:flies;
    pmove = data(i).pmove;
    sz = size(pmove);    
    pre = pmove(1000:1499,:);
    stim = pmove(1500:1999,:);
    post = pmove(2000:2499,:);
    pre_avg_fly = mean(mean(pre));
    stim_avg_fly = mean(mean(stim));
    post_avg_fly = mean(mean(post));
    pre_avg_pmove(1,i) = pre_avg_fly;
    stim_avg_pmove(1,i) = stim_avg_fly;
    post_avg_pmove(1,i) = post_avg_fly;
end;









