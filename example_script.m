%% Sample Script
close all; clear; clc;

load('Motion1_VisOnly.mat')
rawData = data_output;

processedData = preprocessData(rawData);
processedData = processedData(processedData.Stimulus ~= 0, :);

%visualizeDescriptiveAnalysis(processedData);
DDM(processedData);

% Example Data
%data.SNR = rand(100, 1); % Random SNR values
%data.Response = rand(100, 1) < 0.5 + 0.3 * data.SNR; % Synthetic responses

% Test Function
%fitBayesianModel(data);
