function out = normE (sample, liminf,limsup)

si = size(sample);

if ~isempty(si(si==1));
    x=min(min(sample));
    y=max(max(sample));
    out = liminf+(sample-x).*(limsup-liminf)./(y-x);
    clear x y si sample
elseif isempty(si(si==1))
    x=min(min(sample));
    y=max(max(sample));
    for i = 1:size(sample,2)
        sample(:,i) = liminf+(sample(:,i)-x).*(limsup-liminf)./(y-x);
    end
    out = sample;
    clear si x y i sample
end

end