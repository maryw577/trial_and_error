function processedAVdata = preprocessAVdata(rawData, mod)
    % Extract columns based on the new assignments
    if strcmp(mod, "A")
        stimulus = rawData(:, 1);
        SNR = rawData(:, 2);
    elseif strcmp(mod, "V")
        stimulus = rawData(:, 3);
        SNR = rawData(:, 4);
    elseif strcmp(mod, "AV")
        stimulus = rawData(:, [1, 3]);
        SNR = rawData(:, [2, 4]);
    else
        error("Invalid modality specified. Use 'A', 'V', or 'AV'.");
    end

    % Extract other columns
    response = rawData(:, 5); % Response
    RT = rawData(:, 6);       % Reaction Time

    % Compute derived columns
    prevStimulus = [NaN(1, size(stimulus, 2)); stimulus(1:end-1, :)];
    prevSNR = [NaN(1, size(SNR, 2)); SNR(1:end-1, :)];
    prevResponse = [NaN; response(1:end-1)];
    correct = (stimulus(:, 1) == response); % Correct or incorrect using column 1 of stimulus
    prevOutcome = [NaN; correct(1:end-1)];

    % Combine into a table
    processedAVdata = table(stimulus, SNR, response, RT, ...
                          prevStimulus, prevSNR, prevResponse, prevOutcome, ...
                          'VariableNames', {'Stimulus', 'SNR', 'Response', 'RT', ...
                                            'PrevStimulus', 'PrevSNR', 'PrevResponse', 'PrevOutcome'});
end
