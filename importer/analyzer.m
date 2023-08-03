
function results = analyzer (data)

% results = analyzer (data)
%
%   data -> Structure array with flies' data.
%
% Function that calls a series of standard analysis functions. It is just a
% shortcut function.
tic


removers = []; results = data;

for fly = 1:length(data) % Iterates through flies
    % filtering (data, velFilt, freqFilt, alignFilt, borderFilt)
    %       velFilt = removes trials with less movement than 25 mm
    %       freqfilt = filters X and Y coordinates below 2.5 Hz, and Theta below 2 Hz
    %       alignFilt = aligns data to ONSET (1) or to OFFSET (2)
    %       borderFilt = removes 3 mm around the arena, to exclude trajectories along the borders
    [results(fly).xfilt, results(fly).yfilt, results(fly).thetafilt] = filtering (results(fly),1,1,1,0);
    
    % Checks that there is still some data remaining after filtering and reports
    if isempty(results(fly).xfilt)
        removers = [removers, fly];
        display(['Fly #', num2str(fly), ' discarded after filtering for lack of activity']);
        continue
    end
end

results(removers) = []; % Removes flies that were left without data due to lack of activity
toc

results = a_vels (results); toc
results = a_thetahist (results); toc












    
    
    
    
    
    
    
    
