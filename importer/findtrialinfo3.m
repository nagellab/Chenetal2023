
function out = findtrialinfo3 (path)
%% wind light and odour together
% out = findtrialinfo (path)
%
%   path -> Absolute path of a file.
%
% This function gathers the experimental details of the given trial,
% looking for information both in the name of the file and in the
% accompanying info .txt file that usually goes with binary data files.
% IMPORTANT: The route to this info file is set by default. To change it
% modify the code.

% Info default path
% infopath = '/Users/efren/Data/'; % Modify if necessary

% Splits the name and takes the useful info
pathsplit = strsplit(path,'\'); % Splits the path
filename = pathsplit{end}; % Takes the last part
filenamesplit = strsplit(filename,'_'); % Splits the subparts of the name

%Stores the info
out.date = filenamesplit{end-2};
out.experiment = filenamesplit{end-1};
out.timestamp = filenamesplit{end};
out.genotype = 'information missing';
out.conditions = 'information missing';
if strcmp(filenamesplit{3},'X')
    out.mode = lower(strcat(filenamesplit{1},filenamesplit{2},filenamesplit{4})); %reduce to one if data without two stimuli types
else
    out.mode = lower(strcat(filenamesplit{1},filenamesplit{2},filenamesplit{3}));
end
% nflies = strsplit(filenamesplit{4},'n'); nflies = nflies{end};
% out.nflies = str2num(nflies);
%make two modes - calculate previous mode 
% Looks for the rest of the info
infofile = ['info_',out.date,'_',out.experiment,'.txt']; % Constructs the name of the corresponding info file

% Constructs the path to the folder where the trial is
pathsplit(end) = []; pathsplit(1) = []; % Removes unnecessary parts of the initial path
infopath = '\';
for i = 1:length(pathsplit)
    infopath = [infopath,pathsplit{i},'\'];
end

% Opens the file and takes the rest of the info
fid = fopen([infopath,infofile]);
if fid < 3 % In case it doesn't find the info file, it reports
    display('Info file could not be found. Some information will be missing')
else
    garbage = fgetl(fid);
    garbage = fgetl(fid); %another? if the genotype ends up wrong add another
    out.genotype = fgetl(fid);
    out.conditions = fgetl(fid);
%     out.nflies = fgetl(fid);
%     out.nflies = str2num(out.nflies);
end

fclose(fid); % Closes the file

clear pathsplit filename filenamesplit infofile infopath fid garbage

end