%% RJF 24 OCT 2022


function [pre_avg_pturn, stim_avg_pturn, post_avg_pturn] = averagepturn(data)
pre_avg_pturn = []
post_avg_pturn = []
stim_avg_pturn = []

flies = length(data);
for i = 1:flies;
    pturn = data(i).pturn;
    sz = size(pturn);    
    pre = pturn(1000:1499,:);
    stim = pturn(1500:1999,:);
    post = pturn(2000:2499,:);
    pre_avg_fly = mean(mean(pre));
    stim_avg_fly = mean(mean(stim));
    post_avg_fly = mean(mean(post));
    pre_avg_pturn(1,i) = pre_avg_fly;
    stim_avg_pturn(1,i) = stim_avg_fly;
    post_avg_pturn(1,i) = post_avg_fly;
end;









