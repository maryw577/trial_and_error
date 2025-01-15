function processedData = preprocessData(rawData)
    % Extract columns
    stimulus = rawData(:, 1);
    SNR = rawData(:, 2);
    response = rawData(:, 3);
    RT = rawData(:, 4);

    % Compute derived columns
    prevStimulus = [NaN; stimulus(1:end-1)];
    prevSNR = [NaN; SNR(1:end-1)];
    prevResponse = [NaN; response(1:end-1)];
    correct = (stimulus == response); % Correct or incorrect
    prevOutcome = [NaN; correct(1:end-1)];

    % Combine into a table
    processedData = table(stimulus, SNR, response, RT, ...
                          prevStimulus, prevSNR, prevResponse, prevOutcome, ...
                          'VariableNames', {'Stimulus', 'SNR', 'Response', 'RT', ...
                                            'PrevStimulus', 'PrevSNR', 'PrevResponse', 'PrevOutcome'});
end