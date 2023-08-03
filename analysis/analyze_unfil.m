function [averages traces] = analyze_unfil(data)

data_unfil = computegait_nofil(data);
averages = getaverages(data_unfil);
traces = gettraces_jk(data_unfil); 

