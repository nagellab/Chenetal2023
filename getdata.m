%This function will import and analyze the data for the wind tunnel data in
%Chen et al 2023. Make sure to change directory for the importer code to
%the location with the raw data. 

function [WT_5day_averages, WT_5day_traces, Tre1KO_5day_averages, Tre1KO_5day_traces, WT_30day_averages, WT_30day_traces, Tre1KO_30day_averages, Tre1KO_30day_traces] = getdata()

WT_5day = importer('230403', 3, '230403', 4, '230403', 5, '230403', 6, '230403', 9, '230403', 10, '230403', 15, '230403', 16, '230410', 1, '230410', 4);
Tre1KO_5day = importer('230402', 1, '230403', 2, '230403', 7, '230403', 8, '230403', 11, '230403', 12, '230403', 13, '230403', 14, '230410', 2, '230410', 3);

WT_30day = importer('230420', 15, '230420',16, '230420',21, '230420',22, '230420',23, '230420',24, '230420',25, '230420',26, '230423',11,'230423',12);
Tre1KO_30day = importer('230420',17,'230420',18,'230420',19,'230420',20, '230423', 13, '230423', 14, '230423', 15, '230423', 16, '230423', 17, '230423', 18);

[WT_5day_averages, WT_5day_traces] = analyze_unfil(WT_5day.res10salwaysonblank);

[Tre1KO_5day_averages, Tre1KO_5day_traces] = analyze_unfil(Tre1KO_5day.res10salwaysonblank);

[WT_30day_averages, WT_30day_traces] = analyze_unfil(WT_30day.res10salwaysonblank);

[Tre1KO_30day_averages, Tre1KO_30day_traces] = analyze_unfil(Tre1KO_30day.res10salwaysonblank);

