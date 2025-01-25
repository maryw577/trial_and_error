function visualizeDescriptiveAnalysis(data)
    % Ensure table has all necessary variables
    if ~all(ismember({'PrevOutcome', 'Response', 'Stimulus'}, data.Properties.VariableNames))
        error('Table does not contain required variables: PrevOutcome, Response, Stimulus.');
    end

    % Add computed variable for correctness
    data.Correct = data.Response == data.Stimulus;

    % Filter out rows with missing values
    data = rmmissing(data);

    % Plot Accuracy
    sequentialAcc = groupsummary(data, {'PrevOutcome'}, 'mean', 'Correct');
    bar(sequentialAcc.PrevOutcome, sequentialAcc.mean_Correct);
    xlabel('Previous Outcome'); ylabel('Proportion Correct');
    title('Sequential Effects on Accuracy');
    ylim([0 1.0]);

    % Plot RT
    figure;
    sequentialRT = groupsummary(data, {'PrevOutcome'}, 'mean', 'RT');
    bar(sequentialRT.PrevOutcome, sequentialRT.mean_RT);
    xlabel('Previous Outcome'); ylabel('Mean Reaction Time (ms)');
    title('Sequential Effects on Reaction Times');

    % Plot RT as a function of SNR and trial history
    figure;
    scatter(data.SNR, data.RT, 20, data.PrevOutcome, 'filled');
    xlabel('SNR'); ylabel('Reaction Time (s)');
    title('Reaction Time by SNR and Trial History');
    colorbar; colormap cool;
end
