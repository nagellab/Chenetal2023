function out = a_vels (resdata)

% out = a_vels (resdata)
%
%   resdata -> Structure array with flies' data.
%
% Calculates the velocities (linear and angular) of the flies.


out = resdata;

% Checks if it's necessary to filter the trajectories
siono = isfield(out,'xfilt');

% Iterates through each fly
for fly = 1:length(out)
       
    % FILTERS IF IT'S NECESSARY
    %if siono == 0
    % filtering (data, velFilt, freqFilt, alignFilt, borderFilt)
    %       velFilt = removes trials with less movement than 25 mm
    %       freqfilt = filters X and Y coordinates below 2.5 Hz, and Theta below 2 Hz
    %       alignFilt = aligns data to ONSET (1) or to OFFSET (2)
    %       borderFilt = removes 3 mm around the arena, to exclude trajectories along the borders
        [out(fly).xfilt, out(fly).yfilt, out(fly).thetafilt] = filtering (out(fly),1,1,1,0);
    %end
    
    % Preallocates/resets variables to make sure it overwrites
    ntrials = size(out(fly).xfilt,2); nrows = size(out(fly).xfilt,1);
    out(fly).uthetafilt = zeros(nrows,ntrials); out(fly).deltamm = zeros(nrows-1,ntrials); 
    out(fly).v = zeros(nrows-1,ntrials);
    out(fly).vy = zeros(nrows-1,ntrials); out(fly).vx = zeros(nrows-1,ntrials);
    out(fly).angv = zeros(nrows-1,ntrials);
    out(fly).pmove = zeros(nrows-1,ntrials); out(fly).vmove = zeros(nrows-1,ntrials);
    out(fly).pturn = zeros(nrows-1,ntrials); out(fly).angvturn = zeros(nrows-1,ntrials);
    out(fly).curvature = zeros(nrows-1,ntrials);
    out(fly).unfiltcurvature = zeros(nrows-1,ntrials);
    
    % Unwraps the orientations
    out(fly).uthetafilt = unwrap(out(fly).thetafilt * (pi/180)) * (180/pi);
    
    % Calculates the distance moved in each frame (in mm)
    out(fly).deltamm = hypot(diff(out(fly).yfilt,1,1),diff(out(fly).xfilt,1,1)); % * cfactor;
    
    % Calculates radial and angular velocities
    out(fly).v = out(fly).deltamm ./0.02; % Radial velocity in mm/s
    out(fly).vy = diff(out(fly).yfilt,1,1) ./0.02; % * cfactor; % Upwind velocity in mm/s
    out(fly).vx = diff(out(fly).xfilt,1,1) ./0.02; % * cfactor; % Crosswind velocity in mm/s
    out(fly).angv = abs(diff(out(fly).uthetafilt)) ./0.02; % Angular velocity in degrees/s
    
    % Calculates thresholded movement and turning
    out(fly).pmove = double(out(fly).v > 1); % Finds where flies move faster than 1 mm/s
    pstop = out(fly).v < 1; % Finds where flies move slower than 1 mm/s
    out(fly).vmove = out(fly).v; out(fly).vmove(pstop) = NaN; % Ground speed thresholded over 1 mm/s
    out(fly).vymove = out(fly).vy; out(fly).vymove(pstop) = NaN; % Upwind velocity thresholded over 1 mm/s
    
     % Finds where flies turn faster than 10 deg/s
    %pstop = out(fly).angv < 10; % Finds where flies moving less than 1mm/s
    out(fly).angvturn = out(fly).angv; out(fly).angvturn(pstop) = NaN; 
    
    out(fly).curvature = out(fly).angvturn ./ out(fly).vmove; % Thresholded angular velocity OVER thresholded ground speed
    %out(fly).unfiltcurvature = out(fly).angv ./ out(fly).v; 
    out(fly).pturn = double(out(fly).curvature > 20);
    out(fly).unfiltcurvature = out(fly).angv ./ out(fly).vmove;
end
    
    
    
    