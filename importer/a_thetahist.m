
function out = a_thetahist (data, opt_periods)

tic
out = data; % Copies input data to change and return it as output
%out=rmfield(out,'prethetahist');
%out=rmfield(out,'posthetahist');
%out=rmfield(out,'durthetahist');
%out=rmfield(out,'orientbins');
edges = 0:10:360; % Defines the bins to distribute the orientation values

% Takes periods of time if given
if nargin == 2
    pe = opt_periods;
end


for i = 1:length(out) % Iterates through each fly in the data
    
    [~,~,thetafilt] = filtering(out(i),1,1,1,1); % Filters out arena borders
    
    % Defines periods if they are not given
    stind = find(out(i).stimulus(:,1) == 1);
    if nargin == 1
        stind = find(out(i).stimulus(:,1) == 1);
        if ~isempty(stind)
            pe = [1, stind(1),stind(1), stind(end),stind(end), size(thetafilt,1)]; % Periods that take all data
        elseif isempty(stind)
            pe = [1, size(thetafilt,1)]; % Period that takes all data
        end
    end
    
    % Iterates through each trial and collects orientation histograms
    for trial = 1:size(thetafilt,2)
        
        vector = thetafilt(:,trial); % Takes orientations vector of the current trial
        
        if ~isempty(stind) % In case there is a stimulus
            nanes = length(find(isnan(vector(pe(1):pe(2)))==1)); % Calculates the amount of NaN values to not count them in the normalization
            %out(i).prethetahist(:,trial) =[];
            out(i).prethetahist(:,trial)=hist(vector(pe(1):pe(2)),edges)'./(pe(2)-pe(1)+1-nanes); % Counts and normalizes
            nanes = length(find(isnan(vector(pe(3):pe(4)))==1));
            %out(i).durthetahist(:,trial) = [];
            out(i).durthetahist(:,trial)=hist(vector(pe(3):pe(4)),edges)'./(pe(4)-pe(3)+1-nanes);
            nanes = length(find(isnan(vector(pe(5):pe(6)))==1));
            %out(i).posthetahist(:,trial) = [];
            out(i).posthetahist(:,trial)=hist(vector(pe(5):pe(6)),edges)'./(pe(6)-pe(5)+1-nanes);
        elseif isempty(stind) % In case there is NO stimulus
            if (numel(pe)-1) == 1 % With only one period
                nanes = length(find(isnan(vector(pe(1):pe(2)))==1));
                out(i).thetahist(:,trial) = hist(vector(pe(1):pe(2)),edges)'./(pe(2)-pe(1)+1-nanes);
            elseif (numel(pe)-1) == 3 % With three periods 
                nanes = length(find(isnan(vector(pe(1):pe(2)))==1));
                out(i).prethetahist(:,trial) = hist(vector(pe(1):pe(2)),edges)'./(pe(2)-pe(1)+1-nanes);
                nanes = length(find(isnan(vector(pe(2):pe(3)))==1));
                out(i).durthetahist(:,trial) = hist(vector(pe(2):pe(3)),edges)'./(pe(3)-pe(2)+1-nanes);
                nanes = length(find(isnan(vector(pe(3):pe(4)))==1));
                out(i).posthetahist(:,trial) = hist(vector(pe(3):pe(4)),edges)'./(pe(4)-pe(3)+1-nanes);
            end
        end
    end
    
    % Saves the bins info in radians
    out(i).orientbins = edges' * (pi/180);
    
end
toc
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
