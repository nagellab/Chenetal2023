
function out = openbindata3 (path)

%% THIS VERSION IS FOR LIGHT WIND AND ODOUR -> USE VERSION TWO FOR JUST WIND AND ODOUR

% out = openbindata (path);
%
%   path -> Absolute path of the file to open.
%
% This function opens and reads the contents of binary files containing
% behavioral data from the Walking Arena. It separates the different
% information in fields of the output structure.
%
% IMPORTANT: It assumes the are 4 flies in the file. If you use a different
% number of flies, change the code.

% Number of flies
nflies = 4; % CHANGE THIS NUMBER IN CASE THERE ARE MORE OR LESS FLIES

% Looks for and extracts the experimental information of the trial
out = findtrialinfo3(path);

% Proceeds and opens the file and gets the actual data
fid = fopen(path);

% Controls in case the file doesn't exist
if fid < 3
    display('The path does not correspond to an existing file')
    out = [];
    return
end

file = fread(fid,inf,'double','ieee-be.l64'); % Reads the contents of the file
fclose(fid); % Closes the file

space = 6 + nflies*3; % Calculates the number of rows that each iteration uses

% Saves the data in the output structure
out.time = file(2:space:end);
out.stimulus = file(3:space:end);
out.stimuluswind = file(4:space:end);
out.stimuluslight = file(5:space:end);
out.analog = file(6:space:end);
for i = 1:nflies
    try
    out.x(:,i) = file(3*i+4:space:end);
    catch
        %disp('help');
    end
    out.y(:,i) = file(3*i+5:space:end);
    try
    out.theta(:,i) = file(3*i+6:space:end);
    catch
        disp('');
    end
end

clear file nflies fid space

end