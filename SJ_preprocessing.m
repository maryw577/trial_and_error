% Reset variables to ensure a clean re-run
clear; 
clc; 

filename = '/Users/ansle/Documents/GitHub/trial_and_error/data/Simultaneity1/201_Day1_SJTraining_Clean.xlsx'; 
data = readtable(filename);

% Select the first column 
SOAs = data{:, 1}; 

% Initialize numeric output array
numeric_data = zeros(height(data), 1); 

% Iterate through each entry in the data
for i = 1:height(data)
    entry = SOAs{i}; 
    if endsWith(entry, 'AV') % Negative values for 'AV'
        numeric_data(i) = -str2double(entry(4:end-2));
    elseif endsWith(entry, 'VA') % Positive values for 'VA'
        numeric_data(i) = str2double(entry(4:end-2));
    elseif strcmp(entry, 'Sync') % Zero for 'Sync'
        numeric_data(i) = 0;
    end
end

% Ensure numeric_data is a column vector
numeric_data = numeric_data(:); 

% Create a copy of the original table
data2 = data;
data2.(data.Properties.VariableNames{1}) = numeric_data;

% Create a new array with the specified column order
stimulus = data2.CRESP; 
SNR = data2.Procedure_Trial_; 
response = data2.RESP; 
RT = data2.RT; 
rawData = [stimulus, SNR, response, RT];

% Run preprocessing code
processedData = preprocessData(rawData);
disp(processedData);