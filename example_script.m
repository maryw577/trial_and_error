%% Sample Script

load('Motion1_VisOnly.mat')
rawData = data_output;

processedData = preprocessData(rawData);

visualizeDescriptiveAnalysis(processedData);

% Example Data
data.SNR = rand(100, 1); % Random SNR values
data.Response = rand(100, 1) < 0.5 + 0.3 * data.SNR; % Synthetic responses

% Test Function
fitBayesianModel(data);
