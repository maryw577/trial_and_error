function visualizeDescriptiveAnalysis(data)
    % Ensure table has all necessary variables
    if ~all(ismember({'PrevOutcome', 'Response', 'Stimulus', 'SNR', 'RT'}, data.Properties.VariableNames))
        error('Table does not contain required variables: PrevOutcome, Response, Stimulus, SNR, RT.');
    end

    % Add computed variable for correctness
    data.Correct = data.Response == data.Stimulus;

    % Filter out rows with missing values
    data = rmmissing(data);

    % Define color scheme
    color1 = [230, 159, 0] / 255; % Orange
    color2 = [0, 114, 178] / 255; % Blue

    % Plot Accuracy
    figure;
    sequentialAcc = groupsummary(data, {'PrevOutcome'}, 'mean', 'Correct');
    bar(sequentialAcc.PrevOutcome, sequentialAcc.mean_Correct, 'FaceColor', color1);
    xlabel('Previous Outcome'); ylabel('Proportion Correct');
    title('Sequential Effects on Accuracy');
    ylim([0 1.0]);

    % Plot RT
    figure;
    sequentialRT = groupsummary(data, {'PrevOutcome'}, 'mean', 'RT');
    bar(sequentialRT.PrevOutcome, sequentialRT.mean_RT, 'FaceColor', color2);
    xlabel('Previous Outcome'); ylabel('Mean Reaction Time (ms)');
    title('Sequential Effects on Reaction Times');

    % Plot RT as a function of SNR and trial history
    figure;
    uniquePrevOutcomes = unique(data.PrevOutcome); % Get unique PrevOutcome values
    hold on;
    for i = 1:length(uniquePrevOutcomes)
        % Filter data by PrevOutcome
        outcome = uniquePrevOutcomes(i);
        subset = data(data.PrevOutcome == outcome, :);

        % Scatter plot for each outcome
        if outcome == 1
            scatter(subset.SNR, subset.RT, 40, 'filled', 'MarkerFaceColor', color1);
        else
            scatter(subset.SNR, subset.RT, 40, 'filled', 'MarkerFaceColor', color2);
        end
    end
    hold off;
    xlabel('SNR'); ylabel('Reaction Time (s)');
    title('Reaction Time by SNR and Trial History');
    legend({'Correct Previous Trial', 'Incorrect Previous Trial'}, 'Location', 'best');
end
