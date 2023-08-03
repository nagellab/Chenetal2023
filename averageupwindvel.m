% RJF 24 OCT 2022


function [pre_avg_vup, stim_avg_vup, post_avg_vup] = averageupwindvel(data)
pre_avg_vup = []
post_avg_vup = []
stim_avg_vup = []

flies = length(data);
for i = 1:flies;
    vup = data(i).vy;
    sz = size(vup);    
    pre = vup(1000:1499,:);
    stim = vup(1500:1999,:);
    post = vup(2000:2499,:);
    pre_avg_fly = mean(mean(pre));
    stim_avg_fly = mean(mean(stim));
    post_avg_fly = mean(mean(post));
    pre_avg_vup(1,i) = pre_avg_fly;
    stim_avg_vup(1,i) = stim_avg_fly;
    post_avg_vup(1,i) = post_avg_fly;
end;









