
function out = normaxy (data)

% [x,y] = normaxy (data)
%
%   x, y -> Normalized X and Y coordinates
%
%   data -> Structure array containing a field 'x' and another field 'y',
%           both containing raw coordinates in pixels.
%
% This function takes a structure array containing behavioral data from
% flies, separates each behavioral rig and converts all X and Y
% coordinates to the real size of the arenas (39.5x140 mm as of March 31st
% of 2017). This saves further conversion and allows a better overlap of
% the different trajectories, and thus more precise analyses of flies'
% positions.



% Identifies and separates each rig's data --------------------------
rig = zeros(length(data),1);
for i = 1:length(data) % Iterates through each fly
    info = strsplit(data(i).genotype,','); % Separates the pieces of information in the 'genotype' field
    riginfo = strrep(info{end}, ' ', ''); % Eliminates any spaces in the last piece of info
    riginfo = lower(riginfo); % Makes the string only lowercase
    if strcmp(riginfo,'rig1') % If the last piece of info is 'rig1'
        rig(i) = 1;
    elseif strcmp(riginfo,'rig2') % If the last piece of info is 'rig2'
        rig(i) = 2;
    else
        rig(i) = 3;
    end
end

if ~isempty(find(rig==1))
    x1 = horzcat(data(find(rig==1)).x);
    y1 = horzcat(data(find(rig==1)).y);        
end
if ~isempty(find(rig==2))
    x2 = horzcat(data(find(rig==2)).x);
    y2 = horzcat(data(find(rig==2)).y);
end
if ~isempty(find(rig==3))
    x3 = horzcat(data(find(rig==3)).x);
    y3 = horzcat(data(find(rig==3)).y);
end



% Checks if there are enough data ----------------------------------------
% IDEA %%%%%%%%% If there are not enough data, it could make an estimation
% based on the average maximum and minumum from all rigs, and use that as a
% reference to normalize.
if ~isempty(find(rig==1))
subplot(1,3,1);
plot(downsample(x1,10),downsample(y1,10));
title('RIG 1');
end
if ~isempty(find(rig==2))
subplot(1,3,2);
plot(downsample(x2,10),downsample(y2,10));
title('RIG 2')
end
if ~isempty(find(rig==3))
subplot(1,3,3);
plot(downsample(x3,10),downsample(y3,10));
title('RIG 3')
end

decision = input('ARE THERE ENOUGH TRAJECTORIES? (0 if NO; anything otherwise): ');
if decision == 0
    return
end
close;


% Normalizes --------------------------------------------------------------
% mx1 = nanmax(nanmax(x1));
% my1 = nanmax(nanmax(y1));
% mx2 = nanmax(nanmax(x2));
% my2 = nanmax(nanmax(y2));

if ~isempty(find(rig==1))
x1 = normE(x1,0,39.5);
y1 = normE(y1,0,140);
end
if ~isempty(find(rig==2))
x2 = normE(x2,0,39.5);
y2 = normE(y2,0,140);
end
if ~isempty(find(rig==3))
x3 = normE(x3,0,39.5);
y3 = normE(y3,0,140);
end


% Re-locates the coordinates to their original places ---------------------
out = data;
if ~isempty(find(rig==1))
is = find(rig==1); % Finds which flies belong to Rig1
for i = 1:numel(is) % Iterates through each Rig1 fly
    mosca = is(i); % Takes the current fly's position in the original data structure
    ntrials = size(data(mosca).x,2); % Calculates the amount of trials that there are from that fly
    % Substitutes the corresponding normalized coordinates for the originals
    out(mosca).x = x1(:,1:ntrials);
    out(mosca).y = y1(:,1:ntrials);
    % Eliminates those coordinates already returned from the normalized pool
    x1(:,1:ntrials) = [];
    y1(:,1:ntrials) = [];
end
end
% REPEATS THE SAME OPERATION JUST DONE, BUT FOR RIG2
if ~isempty(find(rig==2))
is = find(rig==2); % Finds which flies belong to Rig2
for i = 1:numel(is) % Iterates through each Rig2 fly
    mosca = is(i); % Takes the current fly's position in the original data structure
    ntrials = size(data(mosca).x,2); % Calculates the amount of trials that there are from that fly
    % Substitutes the corresponding normalized coordinates for the originals
    out(mosca).x = x2(:,1:ntrials);
    out(mosca).y = y2(:,1:ntrials);
    % Eliminates those coordinates already returned from the normalized pool
    x2(:,1:ntrials) = [];
    y2(:,1:ntrials) = [];
end
end
if ~isempty(find(rig==3))
% REPEATS THE SAME OPERATION JUST DONE, BUT FOR RIG3
is = find(rig==3); % Finds which flies belong to Rig3
for i = 1:numel(is) % Iterates through each Rig3 fly
    mosca = is(i); % Takes the current fly's position in the original data structure
    ntrials = size(data(mosca).x,2); % Calculates the amount of trials that there are from that fly
    % Substitutes the corresponding normalized coordinates for the originals
    out(mosca).x = x3(:,1:ntrials);
    out(mosca).y = y3(:,1:ntrials);
    % Eliminates those coordinates already returned from the normalized pool
    x3(:,1:ntrials) = [];
    y3(:,1:ntrials) = [];
end
end

    














