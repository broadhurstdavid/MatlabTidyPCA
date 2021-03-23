function [DataTable,PeakTable] = load_dataXL(filename,DataSheet,PeakSheet)

% This function loads and validates the DataFile and PeakFile DataFile:
% Metabolite IDs must start with 'M' ... best to use M1 M2 M3 M4 etc. 
% Remaining columns are assumed to be user specific meta data and are ignored. 
% Peak File: The first columns should contain the Peak Label matching the DataFile (M1 M2 .. )
% The remaining columns can contain anything you like. Statistics will be added to this "table"
%
% zeroflag = 1 -> replace zeros with Nans

if exist(filename,'file') ~= 2
    error(['Filename: ',filename,' does not exist']);
end

[~,~,ext] = fileparts(filename); 
if ~strcmp(ext,'.xlsx') && ~strcmp(ext,'.xls')
    error(['Filename: ',filename,' should be a .xlsx file']);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD PEAK FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

display(['Loading DataSheet: ',PeakSheet]);

PeakTable = readtable(filename,'Sheet',PeakSheet);
peak_list = PeakTable.Name;


peaks = unique(peak_list);
if numel(peaks) ~= numel(peak_list)
    error(['All Peak Names in ',PeakSheet,' should be unique']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD DATA FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

display(['Loading PeakSheet: ',DataSheet]);

DataTable = readtable(filename,'Sheet',DataSheet);
list = DataTable.Properties.VariableNames;
temp = intersect(peak_list,list);

if numel(temp) ~= numel(peak_list)
    error(['The Peak Names in ',DataSheet,' should exactly match the Peak Names in ',PeakSheet,' ( M1, M2 etc. ) Remember that all Peak Names should be unique']);
end

DataTable = standardizeMissing(DataTable,{NaN,-99,'','.','NA','N/A'});

r = size(DataTable,1);
c = length(peak_list);
display(['TOTAL SAMPLES: ',num2str(r),' TOTAL PEAKS: ',num2str(c)]);
disp('Done!');


end

