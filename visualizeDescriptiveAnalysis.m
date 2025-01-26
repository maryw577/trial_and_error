function visualizeDescriptiveAnalysis(data, X)
    % Ensure table has all necessary variables
    if ~all(ismember({'PrevOutcome', 'Response', 'Stimulus', 'SNR', 'RT'}, data.Properties.VariableNames))
        error('Table does not contain required variables: PrevOutcome, Response, Stimulus, SNR, RT.');
    end

    % Add computed variable for correctness
    data.Correct = data.Response == data.Stimulus;

    % Filter out rows with missing values
    data = rmmissing(data);

    % Adjust for "n - X" trial
    if X > 1
        % Shift the relevant columns for X trials back
        data.PrevOutcome = circshift(data.PrevOutcome, X); % Shift PrevOutcome by X
        data.PrevResponse = circshift(data.Response, X); % Shift Response by X
        data.PrevStimulus = circshift(data.Stimulus, X); % Shift Stimulus by X
        % Remove the first X rows as they do not have valid trial history
        data = data(X+1:end, :);
    end

    % Define color scheme
    color1 = [230, 159, 0] / 255; % Orange
    color2 = [0, 114, 178] / 255; % Blue
    %Calculate Standard Deviation
    sdacc=std(data.Correct)
    % Plot Accuracy
    figure;
    sequentialAcc = groupsummary(data, {'PrevOutcome'}, 'mean', 'Correct');
    sdAcc = std(data.Correct); % Compute standard deviation
    bar(sequentialAcc.PrevOutcome, sequentialAcc.mean_Correct, 'FaceColor', color1);
    hold on;
<<<<<<< Updated upstream
    % Plot the error bars, set color to black, and adjust thickness
    er = errorbar(sequentialAcc.PrevOutcome, sequentialAcc.mean_Correct, sdacc, sdacc, 'k'); % 'k' sets the color to black
    set(er, 'LineStyle', 'none', 'LineWidth', 2); % Thicker error bars
    hold off;
    % Customize text properties with larger sizes
    xlabel('Previous Outcome', 'FontSize', 18, 'FontWeight', 'bold'); % Larger font for x-axis label
    ylabel('Proportion Correct', 'FontSize', 18, 'FontWeight', 'bold'); % Larger font for y-axis label
    title('Sequential Effects on Accuracy', 'FontSize', 20, 'FontWeight', 'bold'); % Larger font for title
    set(gca, 'FontSize', 16); % Larger font size for tick labels
    % ylim([0 1.0]); % Uncomment if necessary
    
     % Plot RT with thicker error bars
    figure;
    sequentialRT = groupsummary(data, {'PrevOutcome'}, {'mean', 'std'}, 'RT'); % Calculate mean and std
    mean_RT = sequentialRT.mean_RT; % Extract mean RT
    sdRT = sequentialRT.std_RT; % Extract standard deviation of RT
    
    % Create bar plot
    bar(sequentialRT.PrevOutcome, mean_RT, 'FaceColor', color2);
    hold on;
    
    % Add error bars with thicker lines
    er = errorbar(sequentialRT.PrevOutcome, mean_RT, sdRT, sdRT, 'k'); % 'k' for black error bars
    set(er, 'LineStyle', 'none', 'LineWidth', 3); % Thicker error bars (LineWidth = 3)
    
    hold off;
    
    % Customize labels and title
    xlabel('Previous Outcome', 'FontSize', 18, 'FontWeight', 'bold'); % Larger, bold x-axis label
    ylabel('Mean Reaction Time (ms)', 'FontSize', 18, 'FontWeight', 'bold'); % Larger, bold y-axis label
    title('Sequential Effects on Reaction Times', 'FontSize', 20, 'FontWeight', 'bold'); % Larger, bold title
    set(gca, 'FontSize', 16); % Larger font for tick labels

=======
    % Plot error bars
    er = errorbar(sequentialAcc.PrevOutcome, sequentialAcc.mean_Correct, sdAcc, sdAcc, 'k'); % 'k' for black
    set(er, 'LineStyle', 'none', 'LineWidth', 2);
    hold off;
    % Customize labels and title
    xlabel(['Outcome (n - ' num2str(X) ')'], 'FontSize', 18, 'FontWeight', 'bold');
    ylabel('Proportion Correct', 'FontSize', 18, 'FontWeight', 'bold');
    title('Sequential Effects on Accuracy', 'FontSize', 20, 'FontWeight', 'bold');
    set(gca, 'FontSize', 16);

    % Plot RT
    figure;
    sequentialRT = groupsummary(data, {'PrevOutcome'}, {'mean', 'std'}, 'RT');
    mean_RT = sequentialRT.mean_RT;
    sdRT = sequentialRT.std_RT;
    bar(sequentialRT.PrevOutcome, mean_RT, 'FaceColor', color2);
    hold on;
    % Add error bars
    er = errorbar(sequentialRT.PrevOutcome, mean_RT, sdRT, sdRT, 'k');
    set(er, 'LineStyle', 'none', 'LineWidth', 3);
    hold off;
    % Customize labels and title
    xlabel(['Outcome (n - ' num2str(X) ')'], 'FontSize', 18, 'FontWeight', 'bold');
    ylabel('Mean Reaction Time (ms)', 'FontSize', 18, 'FontWeight', 'bold');
    title('Sequential Effects on Reaction Times', 'FontSize', 20, 'FontWeight', 'bold');
    set(gca, 'FontSize', 16);
>>>>>>> Stashed changes

    % Plot RT as a function of SNR and trial history
    figure;
    uniquePrevOutcomes = unique(data.PrevOutcome);
    hold on;
    for i = 1:length(uniquePrevOutcomes)
<<<<<<< Updated upstream
    % Filter data by PrevOutcome
     outcome = uniquePrevOutcomes(i);
    subset = data(data.PrevOutcome == outcome, :);
    
=======
        outcome = uniquePrevOutcomes(i);
        subset = data(data.PrevOutcome == outcome, :);

>>>>>>> Stashed changes
        % Scatter plot for each outcome
        if outcome == 1
            scatter(subset.SNR, subset.RT, 40, 'filled', 'MarkerFaceColor', color1);
        else
            scatter(subset.SNR, subset.RT, 40, 'filled', 'MarkerFaceColor', color2);
        end
    end
    hold off;
<<<<<<< Updated upstream
    
    % Customize text properties with larger sizes
    xlabel('SNR', 'FontSize', 18, 'FontWeight', 'bold'); % Larger, bold x-axis label
    ylabel('Reaction Time (s)', 'FontSize', 18, 'FontWeight', 'bold'); % Larger, bold y-axis label
    title('Reaction Time by SNR and Trial History', 'FontSize', 20, 'FontWeight', 'bold'); % Larger, bold title
    legend({'Correct Previous Trial', 'Incorrect Previous Trial'}, 'Location', 'best', 'FontSize', 14); % Larger font size for legend
    set(gca, 'FontSize', 16); % Larger font size for tick labels
=======
    % Customize labels and title
    xlabel('SNR', 'FontSize', 18, 'FontWeight', 'bold');
    ylabel('Reaction Time (s)', 'FontSize', 18, 'FontWeight', 'bold');
    title(['Reaction Time by SNR and Trial History (n - ' num2str(X) ')'], 'FontSize', 20, 'FontWeight', 'bold');
    legend({'Correct Previous Trial', 'Incorrect Previous Trial'}, 'Location', 'best', 'FontSize', 14);
    set(gca, 'FontSize', 16);
end
>>>>>>> Stashed changes
