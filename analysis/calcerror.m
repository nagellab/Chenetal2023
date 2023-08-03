function [jackstat_error] = calcerror(x)

% Calculate the error of behavior traces when calculating the mean
% This is set to caclulate the standard deviation for the mean (@mean)


sz_a = size(x);

if sz_a(2) > 2


    jackstat = jackknife(@mean, x'); %calculate the jackknife means

    sz = size(jackstat); %number of values


    jackstat_mean = mean(jackstat);
    error = 0;
    jackstat_error = [];

    for i = 1:sz(2)
        for j = 1:sz(1)
            error = error + (jackstat(j,i)-jackstat_mean(1,i))^2;
        end
        error = sqrt(error*(sz(1)-1)/sz(1));
        jackstat_error(i) = error;
        error = 0;
    end

    jackstat_error = jackstat_error';


else 
    jackstat_error = [];
end


