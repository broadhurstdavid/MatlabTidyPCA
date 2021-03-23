function [DataX,PeakX] = ShrinkTables2021(Data,Peak,keep)

if ~isa(keep,'logical') || length(keep)~=height(Peak)
    error("'keep' must be a 'logical' vector length = height(PeakTable)'");
end

PeakX = Peak(keep,:);

DataX = Data;
list = setdiff(Peak.Name,PeakX.Name);
DataX(:,list) = [];
display(['TOTAL SAMPLES: ',num2str(height(DataX)),' TOTAL PEAKS: ',num2str(height(PeakX))]);

end

