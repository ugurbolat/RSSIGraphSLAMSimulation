function [ string_array, numeric_array ] = parseBT( filename )

% same as parseWifi!!!!

%% Initialize variables.
delimiter = ',';
startRow = 1;

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end

raw = [raw(:,1:5), raw(:,7:end)];

numeric_array = NaN; % *ones(size(raw));
% string_array = cell(size(raw));
string_array = {};
last_header = {};
last_header_row = 0;
numHeader = 0;

isOK = false;

for i = 1:size(raw,1)
    
    for j = 1:size(raw,2)
        
        numeric_val = str2num(raw{i,j});
        
        % Deger string ise
        if isempty(numeric_val) && ~isempty(raw{i,j})
            if isempty(string_array)
                string_array{1, 1} = raw{i,j};
            else
                isOK = false;
                for m = 1:size(string_array,2)
                    if strcmp(string_array{1, m}, raw{i, j})
                        isOK = true;
                        break;
                    end
                end
                if isOK == false
                    string_array = [string_array raw{i, j}];
                end
            end
            
            if last_header_row ~= i
                numHeader = numHeader + 1;
                last_header = {};
                last_header_row = i;
                last_header = [last_header raw{i, j}];
            else
                last_header = [last_header raw{i, j}];
            end
            
        elseif ~isempty(numeric_val) % Deger sayi ise
            for m = 1:size(string_array,2)
                
                if strcmp(string_array{1,m},last_header{1,j})
                    %                     if strcmp(last_header{1,j}, 'F5:01:88:73:80:AB(Adafruit Bluefruit LE)') || ...
                    %                             strcmp(last_header{1,j}, '24:0A:C4:00:98:A0(ESP-BLE-HELLO)') || ...
                    %                             strcmp(last_header{1,j}, 'E9:D4:77:A3:2B:B5(Adafruit BLE Friend 2BB5)') || ...
                    %                             strcmp(last_header{1,j}, 'FC:A2:46:3D:2C:8A(Adafruit Bluefruit LE)') || ...
                    %                             strcmp(last_header{1,j}, 'Coor X') || ...
                    %                             strcmp(last_header{1,j}, 'Coor Y') || ...
                    %                             strcmp(last_header{1,j}, 'Floor') || ...
                    %                             strcmp(last_header{1,j}, 'Ref Label') || ...
                    %                             strcmp(last_header{1,j}, 'CURRENT TIME NANOSECONDS') || ...
                    %                             strcmp(last_header{1,j}, 'CURRENT TIME STRING')
                    numeric_array(i-numHeader,m) = numeric_val;
                    %                     end
                    %                     else
                    %                         numeric_array(i-numHeader,m) = numeric_val;
                    %                     end
                    break;
                end
                
            end
            
        end
    end
    
end

for i = 1:length(numeric_array(:,1))
    for j = 1:length(numeric_array(1,:))
        if numeric_array(i,j) == 0
            numeric_array(i,j) = NaN;
        end
    end
end

% only_with_our_beacons_indices = [];
% for j=1:size(string_array,2)
%     if strcmp(string_array{1,j}, 'F5:01:88:73:80:AB(Adafruit Bluefruit LE)') || ...
%             strcmp(string_array{1,j}, '24:0A:C4:00:98:A0(ESP-BLE-HELLO)') || ...
%             strcmp(string_array{1,j}, 'E9:D4:77:A3:2B:B5(Adafruit BLE Friend 2BB5)') || ...
%             strcmp(string_array{1,j}, 'FC:A2:46:3D:2C:8A(Adafruit Bluefruit LE)') || ...
%             strcmp(string_array{1,j}, 'Coor X') || ...
%             strcmp(string_array{1,j}, 'Coor Y') || ...
%             strcmp(string_array{1,j}, 'Floor') || ...
%             strcmp(string_array{1,j}, 'Ref Label') || ...
%             strcmp(string_array{1,j}, 'CURRENT TIME NANOSECONDS') || ...
%             strcmp(string_array{1,j}, 'CURRENT TIME STRING')
%         only_with_our_beacons_indices = [ only_with_our_beacons_indices, j];
%         
%     end
% end


only_with_our_beacons_indices = zeros(length(string_array),1);
matches1 = strfind(string_array,'Coor X');
matches2 = strfind(string_array,'Coor Y');
matches3 = strfind(string_array,'Floor');
matches4 = strfind(string_array,'Ref Label');
matches5 = strfind(string_array,'CURRENT TIME NANOSECONDS');
matches6 = strfind(string_array,'CURRENT TIME STRING');
matches7 = strfind(string_array,'Adafruit');
matches8 = strfind(string_array,'ESP');

all_matches = [];
all_matches = [all_matches, find(~cellfun(@isempty,matches1))];
all_matches = [all_matches, find(~cellfun(@isempty,matches2))];
all_matches = [all_matches, find(~cellfun(@isempty,matches3))];
all_matches = [all_matches, find(~cellfun(@isempty,matches4))];
all_matches = [all_matches, find(~cellfun(@isempty,matches5))];
all_matches = [all_matches, find(~cellfun(@isempty,matches6))];
all_matches = [all_matches, find(~cellfun(@isempty,matches7))];
all_matches = [all_matches, find(~cellfun(@isempty,matches8))];

only_with_our_beacons_indices = sort(all_matches);

string_array = string_array(:,only_with_our_beacons_indices);
numeric_array = numeric_array(:,only_with_our_beacons_indices);


end

