%% Sample Script
close all; clear; clc;

% Specify file name
fileName = 'Motion1_AV_cueA.mat';
load(fileName);
rawData = data_output;

% Determine modality from file name
if contains(fileName, '_cueA')
    mod = "A";
elseif contains(fileName, '_cueV')
    mod = "V";
elseif contains(fileName, '_cueAV')
    mod = "AV";
elseif contains(fileName, '_nocue')
    mod = "N";
else
    error('Could not determine modality from file name');
end

processedAVdata = preprocessAVdata(rawData, mod);

if strcmp(mod, "A") || strcmp(mod, "V")
    processedAVdata = processedAVdata(processedAVdata.Stimulus ~= 0, :); % Filter for single column Stimulus
elseif strcmp(mod, "AV")
    processedAVdata = processedAVdata(all(processedAVdata.Stimulus ~= 0, 2), :); % Filter for two-column Stimulus
elseif strcmp(mod, "N")
    processedAVdata.Stimulus = []; % No Stimulus for nocue
end

processedAVdata = processedAVdata(~isnan(processedAVdata.RT), :);

%visualizeDescriptiveAnalysis(processedData);
%DDM_SNR(processedData);

% Initialize the drift variable
numTrials = height(processedAVdata);
drift = zeros(1, numTrials); % Initialize drift state
initial_state = 0; % Start drift at zero
drift(1) = initial_state;

% Normalize Response for drift calculations
normalizedResponse = processedAVdata.Response; % Copy original response
normalizedResponse(normalizedResponse == 2) = -1; % Right -> -1 (toward bottom boundary)
normalizedResponse(normalizedResponse == 1) = 1;  % Left -> +1 (toward top boundary)

% Loop through trials and calculate drift
for t = 2:numTrials
    if ~isnan(normalizedResponse(t)) && ~isnan(processedAVdata.PrevOutcome(t))
        if processedAVdata.PrevOutcome(t) == 1 % Correct
            drift(t) = drift(t-1) + normalizedResponse(t); % Positive drift
        elseif processedAVdata.PrevOutcome(t) == 0 % Incorrect
            drift(t) = drift(t-1) - normalizedResponse(t); % Negative drift
        end
    else
        drift(t) = drift(t-1); % No change if PrevOutcome or Response is NaN
    end
end

verifyRTDriftCorrelation(processedAVdata, drift);

%averageDriftState = mean(drift);
%disp(['Average Drift State: ', num2str(averageDriftState)]);

% Example Data
%data.SNR = rand(100, 1); % Random SNR values
%data.Response = rand(100, 1) < 0.5 + 0.3 * data.SNR; % Synthetic responses

% Test Function
%fitBayesianModel(data);