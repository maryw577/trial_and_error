%% Sample Script

cd('/Users/a.tiesman/Documents/Research/Human_AV_Motion/data')
load('RDKHoop_stairVis_17_26_01_22.mat')
cd('/Users/a.tiesman/Documents/Research/trial_and_error')
rawData = data_output;

processedData = preprocessData(rawData);

visualizeDescriptiveAnalysis(processedData);

% Example Data
data.SNR = rand(100, 1); % Random SNR values
data.Response = rand(100, 1) < 0.5 + 0.3 * data.SNR; % Synthetic responses

% Test Function
fitBayesianModel(data);
