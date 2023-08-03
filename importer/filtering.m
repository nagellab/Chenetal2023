
function [xfilt, yfilt, thetafilt, stimulusfilt] = filtering (data, velFilt, freqFilt, alignFilt, borderFilt)

% out = filtering (data)
%
%   data -> Structure array containing behavioral data from flies.
%
% This function does all the preprocessing to a just imported set of
% behavioral data from flies, returning X, Y and THETA matrices.
% The preprocessing may be adjusted changing the code of each step below.



for fly = 1:length(data) % Iterates through each fly
    
    
    % Sets the initial values as the raw data
    xfilt = data(fly).x; yfilt = data(fly).y; thetafilt = data(fly).theta;
    stimulusfilt = data(fly).stimulus;
    
    
    
    
    
    
    
    % (0) FILTERS X AND Y COORDINATES, AND THETA ORIENTATION VECTORS
    % --------------------------------------------------------------------
    
    if freqFilt == 1
        
        % Filters coordinates X and Y
        [b, a] = butter(2,2.5/25); % Designs a band-pass filter
        xfilt = filtfilt(b,a,xfilt); % Filters
        yfilt = filtfilt(b,a,yfilt);
        
        % Filters Theta orientations 
        [b, a] = butter(2,2.5/25,'low'); % Low-pass filter below 2 Hz is designed
        thetafilt = filtfilt(b,a,(180/pi) * unwrap(thetafilt * (pi/180))); % Filters
        
        clear a b
        
    end % ~
    
    
    
    
    
    
    
    
    
    
    % (1) SELECTS TRIALS BASED ON MINIMUM MOVEMENT (25 mm)
    % --------------------------------------------------------------------
    
    if velFilt == 1
        
        % Determines the pixel-to-mm conversion factor depending on which arena design was used
        % fecha = str2double(data(fly).date); % Detects the date of the experiment
        % if fecha >= 160622 % Dates for ARENA 4D
        %     cfactor = 0.137;
        % elseif fecha < 160622 % Dates for ARENA 4C
        %     cfactor = 0.1322;
        % end
        % Calculates velocity
        del = hypot(diff(yfilt,1,1),diff(xfilt,1,1)); % * cfactor; % distance moved
        v = del ./0.02; % velocity
        ix = [];
        for i = 1:size(xfilt,2)
            %     if nanmean(v(:,i)) < 1 % excludes if average velocity is below 1 mm/s
            %         ix = [ix, i];
            %     end
            if nansum(del(:,i)) < 25 % excludes if total distance moved is below 25 mm
                ix = [ix, i];
            end
        end
        % Eliminates the non-moving trials
        xfilt(:,ix) = []; yfilt(:,ix) = []; thetafilt(:,ix) = []; stimulusfilt(:,ix) = [];
        % If there are no data left, it ends the run
        if isempty(xfilt)
            %     display([data(fly).fly, ' from ', data(fly).date, ', ', data(fly).experiment,...
            %         ' discarded for lack of activity']);
            xfilt = []; yfilt = []; thetafilt = [];
            return
        end
        
    end % ~
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    % (2) ALIGNS DATA TO REAL ODOR ONSET or OFFSET
    % --------------------------------------------------------------------
    
    if alignFilt == 1 && ... % Aligns to odor ONSET
            ~isempty(find(data(fly).stimulus(:,1) > 0.2)) % This step is only carried out if there is a stimulus
        
        % SETS DEFAULT CALIBRATION VALUES DEPENDING ON THE RIG USED
        % They need to be adjusted according to the arena and camera settings.
        % They will be different for each rig and each setup.
        
        % fecha = str2double(data(fly).date); % Detects the date of the experiment
        
        % Selects the arenas borders and odor dynamics depending on the arena used
        % (dates of the experiments)
        
        % if fecha > 160622 % Dates for ARENA 4D
        %
        %     miny = 10; % (pixels) Lowest position possibly adopted by the flies [REVIEWED FEB 15TH 2017]
        %     maxy = 1020; % (pixels) Highest position possibly adopted by the flies [REVIEWED FEB 15TH 2017]
        %     mindelay = 15; % (samples) Delay until the odor is released to the arena [REVIEWED FEB 15TH 2017]
        %                    % Calculated as time to exceed the baseline plus two standard deviations
        %     maxdelay = 63; % (samples) Delay until the odor reaches the end of the arena [REVIEWED FEB 15TH 2017]
        %                    % Calculated as time to exceed the baseline plus two standard deviations
        %     % ------       ----------     --------     --------     --------
        % %     % Parameters for lower wind (approx. 4 cm/s)
        % %     miny = 10; % (pixels) Lowest position possibly adopted by the flies
        % %     maxy = 1020; % (pixels) Highest position possibly adopted by the flies
        % %     mindelay = 18; % (samples) Delay until the odor is released to the arena
        % %     maxdelay = 125; % (samples) Delay until the odor reaches the end of the arena
        %     % -----------------------------------------
        % else
        %     miny = 10; % (pixels) Lowest position possibly adopted by the flies [REVIEWED FEB 15TH 2017]
        %     maxy = 1020; % (pixels) Highest position possibly adopted by the flies [REVIEWED FEB 15TH 2017]
        %     mindelay = 15; % (samples) Delay until the odor is released to the arena [REVIEWED FEB 15TH 2017]
        %                    % Calculated as time to exceed the baseline plus two standard deviations
        %     maxdelay = 63; % (samples) Delay until the odor reaches the end of the arena [REVIEWED FEB 15TH 2017]
        %                    % Calculated as time to exceed the baseline plus two standard deviations
        % end
        
        % Sets the references
        miny = 0; % (pixels) Lowest position possibly adopted by the flies [REVIEWED FEB 15TH 2017]
        maxy = 140; % (pixels) Highest position possibly adopted by the flies [REVIEWED FEB 15TH 2017]
        mindelay = 15; % (samples) Delay until the odor is released to the arena [REVIEWED FEB 15TH 2017]
        % Calculated as time to exceed the baseline plus two standard deviations
        %mindelay=45 ; %mco
        
        maxdelay = 63; % (samples) Delay until the odor reaches the end of the arena [REVIEWED FEB 15TH 2017]
        % Calculated as time to exceed the baseline plus two standard deviations
        %maxdelay=103 ; %mco
        
        % Calculates the ratios to correct the data
        sizey = maxy-miny; % (pixels) Total possible distance
        idelay = (maxdelay-mindelay) / sizey; % (samples per pixel) Amount of samples to offset per pixel of distance relative to the odor source
        % -----------------------------------------
        
        % Creates blank NaN matrices for the output
        x = zeros(size(xfilt,1),size(xfilt,2)); x(x==0) = NaN;
        y = zeros(size(yfilt,1),size(yfilt,2)); y(y==0) = NaN;
        theta = zeros(size(thetafilt,1),size(thetafilt,2)); theta(theta==0) = NaN;
        
        for trial = 1:size(xfilt,2) % Iterates through each trial
            
            stim = find(data(fly).stimulus(:,trial)>0.2); % Detects the stimulus timing
            position = round(yfilt(stim(1),trial)); % Catches the Y position at the odor onset
            offset = mindelay + (round((maxy - position) * idelay)); % Calculates the amount of frames to be offset
            
            % Moves the data to its correct position
            x(1:numel(xfilt(offset:end,trial)),trial) = xfilt(offset:end,trial);
            y(1:numel(yfilt(offset:end,trial)),trial) = yfilt(offset:end,trial);
   
                theta(1:numel(thetafilt(offset:end,trial)),trial) = thetafilt(offset:end,trial);


        end
        
        xfilt = x; yfilt = y; thetafilt = theta; % Replaces the variables
        clear x y theta fecha miny maxy mindelay maxdelay sizey idelay trial stim position offset
        
        
        
        % ..........       .............         .............       ..............
        
        
        % ALIGNMENT TO OFFSET TIME
    elseif alignFilt == 2 && ... % Aligns to odor ONSET
            ~isempty(find(data(fly).stimulus(:,1) > 0.2)) % This step is only carried out if there is a stimulus
        
        
        % % Selects the arenas borders and odor dynamics depending on the arena used
        % % (dates of the experiments)
        % if fecha > 160622 % Dates for ARENA 4D
        %     miny = 10; % (pixels) Lowest position possibly adopted by the flies [REVIEWED FEB 15 2017]
        %     maxy = 1020; % (pixels) Highest position possibly adopted by the flies [REVIEWED FEB 15 2017]
        %     mindelay = 22; % (samples) Delay until the odor is released to the arena [REVIEWED MAR 14TH 2017]
        %                    % Calculated as time to exceed the baseline plus two standard deviations
        %     maxdelay = 73; % (samples) Delay until the odor reaches the end of the arena [REVIEWED MAR 14TH 2017]
        %                    % Calculated as time to exceed the baseline plus two standard deviations
        % else
        %     miny = 10; % (pixels) Lowest position possibly adopted by the flies [REVIEWED FEB 15 2017]
        %     maxy = 1020; % (pixels) Highest position possibly adopted by the flies [REVIEWED FEB 15 2017]
             mindelay = 22; % (samples) Delay until the odor is released to the arena [REVIEWED MAR 14 2017]
        %                    % Calculated as time to exceed the baseline plus two standard deviations
             maxdelay = 73; % (samples) Delay until the odor reaches the end of the arena [REVIEWED MAR 14 2017]
        %                    % Calculated as time to exceed the baseline plus two standard deviations
        % end
        
        % Selects the arenas borders and odor dynamics
        miny = 0; % (pixels) Lowest position possibly adopted by the flies [REVIEWED FEB 15 2017]
        maxy = 140; % (pixels) Highest position possibly adopted by the flies [REVIEWED FEB 15 2017]
        %mindelay = 22; % (samples) Delay until the odor is released to the arena [REVIEWED MAR 14TH 2017]
        % Calculated as time to exceed the baseline plus two standard deviations
        %maxdelay = 73; % (samples) Delay until the odor reaches the end of the arena [REVIEWED MAR 14TH 2017]
        % Calculated as time to exceed the baseline plus two standard deviations
        
        % Calculates the ratios to correct the data
        sizey = maxy-miny; % (pixels) Total possible distance
        idelay = (maxdelay-mindelay) / sizey; % (samples per pixel) Amount of samples to offset per pixel of distance relative to the odor source
        % -----------------------------------------
        
        % Creates blank NaN matrices for the output
        x = zeros(size(xfilt,1),size(xfilt,2)); x(x==0) = NaN;
        y = zeros(size(yfilt,1),size(yfilt,2)); y(y==0) = NaN;
        theta = zeros(size(thetafilt,1),size(thetafilt,2)); theta(theta==0) = NaN;
        
        for trial = 1:size(xfilt,2) % Iterates through each trial
            stim = find(data(fly).stimulus(:,trial)==1); % Detects the stimulus timing
            position = round(yfilt(stim(1),trial)); % Catches the Y position at the odor onset
            offset = mindelay + (round((maxy - position) * idelay)); % Calculates the amount of frames to be offset
            % Moves the data to its correct position
            x(1:numel(xfilt(offset:end,trial)),trial) = xfilt(offset:end,trial);
            y(1:numel(yfilt(offset:end,trial)),trial) = yfilt(offset:end,trial);
            theta(1:numel(thetafilt(offset:end,trial)),trial) = thetafilt(offset:end,trial);
        end
        
        xfilt = x; yfilt = y; thetafilt = theta; % Replaces the variables
        clear x y theta fecha miny maxy mindelay maxdelay sizey idelay trial stim position offset
        
        
    end % ~
    
    
    
    
    
    
    
    
    
    
    
    % (3) REMOVES BORDERS OF THE ARENAS
    % --------------------------------------------------------------------
    
    if borderFilt == 1
        
        % % Determines the pixel-to-mm conversion factor depending on which arena design was used
        % fecha = str2double(data(fly).date); % Detects the date of the experiment
        % if fecha >= 160622 % Dates for ARENA 4D
        %     cfactor = 0.137;
        % elseif fecha < 160622 % Dates for ARENA 4C
        %     cfactor = 0.1322;
        % end
        
        % info = strsplit(data(fly).genotype,','); % Separates the pieces of information in the 'genotype' field
        % info = strrep(info{end}, ' ', ''); % Eliminates any spaces in the last piece of info
        
        % distance = 3; % mm to remove from the borders of the arena
        % margin = round(distance / cfactor); % pixels to remove from the borders of the arena
        
        % if strcmp(info,'Rig1') % If the last piece of info is 'Rig1'
        %     limys = [10 + margin, 1030 - margin];
        %     limxs = [10 + margin, 306 - margin];
        % elseif strcmp(info,'Rig2') % If the last piece of info is 'Rig2'
        %     limys = [5 + margin, 1008 - margin];
        %     limxs = [5 + margin, 303 - margin];
        % else
        %     limys = [10 + margin, 1020 - margin];
        %     limxs = [10 + margin, 303 - margin];
        % end
        
        margin = 3; % mm to remove from the borders of the arena
        limys = [0 + margin, 140 - margin];
        limxs = [0 + margin, 39.5 - margin];
        
        
        % Creates a matrix indicating which points to remove
        outs = yfilt < limys(1);
        outs(yfilt > limys(2)) = 1;
        outs(xfilt < limxs(1)) = 1;
        outs(xfilt > limxs(2)) = 1;
        
        % Removes the borders from the data
        xfilt(outs) = NaN;
        yfilt(outs) = NaN;
        thetafilt(outs) = NaN;
        
        clear fecha cfactor info distance margin limys limxs outs
        
        
    end % ~
    
    
    
    
    
    thetafilt = wrapTo360(thetafilt); % Wraps to 0-360 interval
    
    
    
    
    % CHECKS FOR TRIALS THAT WERE ELIMINATED ALTOGETHER (i.e. for borders)
    % xxx = [];
    % for i = 1:size(xfilt,2);
    %     nanes = isnan(xfilt(:,i));
    %     if length(find(nanes==1)) == length(xfilt(:,i))
    %         xxx = [xxx, i];
    %     end
    % end
    % xfilt(:,xxx) = []; yfilt(:,xxx) = []; thetafilt(:,xxx) = [];
    
    
    
    
    
    % If there are more than one fly, it accumulates the results
    if length(data) > 1
        out(fly).xfilt = xfilt;
        out(fly).yfilt = yfilt;
        out(fly).thetafilt = thetafilt;
    end
    
end

% If there are more than one fly, a single structure with the results goes
% to the output variable 'xfilt'
if fly > 1
    xfilt = out;
    clear out
end










