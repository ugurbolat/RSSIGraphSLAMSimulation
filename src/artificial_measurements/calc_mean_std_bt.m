function [ coordinates, ref_removed_wifi, meanData, stdData, refPoints_mean, refPoints_total, timestamp ] = calcMeanStdWifi( data )

coordinates = data(:,1:3);
ref_removed_wifi = data(:,6:end);
timestamp = data(:,5);

% refPoints_total = data(:,1:2);
% refPoints_mean = data(1,1:2);
refPoints_total = data(:,4);
refPoints_mean = data(1,4);
dummy_data = [];
meanData = [];
stdData = [];

for i = 1:size(data,1)
    
%     if refPoints_mean(end,1) ~= data(i,1) || refPoints_mean(end,2) ~= data(i,2)
%         refPoints_mean = [refPoints_mean; data(i,1:2)];
%         meanData = [meanData; nanmean(dummy_data)];
%         stdData = [stdData; nanstd(dummy_data)];
%         dummy_data = data(i,3:end);
%     elseif i == size(data,1)
%         dummy_data = [dummy_data; data(i,3:end)];
%         meanData = [meanData; nanmean(dummy_data)];
%         stdData = [stdData; nanstd(dummy_data)];
%         dummy_data = [];
%     else
%         dummy_data = [dummy_data; data(i,3:end)];
%     end

    % switching to the following reference point
    if refPoints_mean(end,1) ~= data(i,4)
        refPoints_mean = [refPoints_mean; data(i,4)];
        meanData = [meanData; nanmean(dummy_data)];
        stdData = [stdData; nanstd(dummy_data)];
        dummy_data = data(i,6:end);
    elseif i == size(data,1)
        dummy_data = [dummy_data; data(i,6:end)];
        meanData = [meanData; nanmean(dummy_data)];
        stdData = [stdData; nanstd(dummy_data)];
        dummy_data = [];
    else
        dummy_data = [dummy_data; data(i,6:end)];
    end
    
end

stdData = stdData(:,1:end);
meanData = meanData(:,1:end);

