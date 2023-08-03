%% RJF 24 OCT 2022


function [pre_avg_curv, stim_avg_pcurv, post_avg_pcurv] = averagecurve(data)
pre_avg_curv = []
post_avg_pcurv = []
stim_avg_pcurv = []

flies = length(data);
for i = 1:flies;
    curv = data(i).curvature;
    sz = size(curv);    
    pre = curv(1000:1499,:);
    stim = curv(1500:1999,:);
    post = curv(2000:2499,:);
    pre_avg_fly = mean(mean(pre, 'omitnan'), 'omitnan');
    stim_avg_fly = mean(mean(stim,'omitnan'), 'omitnan');
    post_avg_fly = mean(mean(post, 'omitnan'), 'omitnan');
    pre_avg_curv(1,i) = pre_avg_fly;
    stim_avg_pcurv(1,i) = stim_avg_fly;
    post_avg_pcurv(1,i) = post_avg_fly;
end;









