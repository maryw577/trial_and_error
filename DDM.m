function DDM(processedData)

    % Initialize the drift variable
    numTrials = height(processedData);
    drift = zeros(1, numTrials);
    initial_state = 0;
    drift(1) = initial_state;
    
    % Normalize Response for drift calculations
    normalizedResponse = processedData.Response; % Copy original response
    normalizedResponse(normalizedResponse == 2) = 1;  % Right -> +1
    normalizedResponse(normalizedResponse == 1) = -1; % Left -> -1
    
    % Count occurrences for weights
    correctLeftCount = sum(processedData.Response == 1 & processedData.PrevOutcome == 1);
    correctRightCount = sum(processedData.Response == 2 & processedData.PrevOutcome == 1);
    incorrectLeftCount = sum(processedData.Response == 1 & processedData.PrevOutcome == 0);
    incorrectRightCount = sum(processedData.Response == 2 & processedData.PrevOutcome == 0);
    
    % Compute weights
    correctLeftWeight = 1 / (correctLeftCount / numTrials);
    correctRightWeight = 1 / (correctRightCount / numTrials);
    incorrectLeftWeight = 1 / (incorrectLeftCount / numTrials);
    incorrectRightWeight = 1 / (incorrectRightCount / numTrials);
    
% Loop through trials and calculate drift
    for t = 2:numTrials
        if ~isnan(normalizedResponse(t)) && ~isnan(processedData.PrevOutcome(t))
            % Correct responses
            if processedData.PrevOutcome(t) == 1 % Correct
                drift(t) = drift(t-1) + 1; % Always add for correct
            elseif processedData.PrevOutcome(t) == 0 % Incorrect
                drift(t) = drift(t-1) - 1; % Always subtract for incorrect
            end
        else
            drift(t) = drift(t-1); % No change if PrevOutcome or Response is NaN
        end
    
        % Centralize drift (optional)
        drift(t) = drift(t) - 0.01 * drift(t-1);
    end
    
    % Normalize drift to range [-1, 1] for better scaling
    drift = drift / max(abs(drift));
    
    % Plot the drift-diffusion model
    figure;
    plot(1:numTrials, drift, '-k', 'LineWidth', 2); % Drift line
    hold on;
    
    % Plot markers for responses using original response values
    for t = 1:numTrials
        % Determine marker color and shape based on original Response
        if processedData.Response(t) == 2 % Right response
            marker_color = [0, 0.5, 1]; % Blue for right
            if processedData.PrevOutcome(t) == 1 % Correct
                marker = 'o'; % Circle for correct
            else
                marker = '^'; % Triangle for incorrect
            end
        elseif processedData.Response(t) == 1 % Left response
            marker_color = [1, 0.5, 0.5]; % Red for left
            if processedData.PrevOutcome(t) == 1 % Correct
                marker = 'o'; % Circle for correct
            else
                marker = '^'; % Triangle for incorrect
            end
        else
            continue; % Skip if response is invalid
        end
        
        % Plot marker
        plot(t, drift(t), marker, 'MarkerSize', 8, 'MarkerFaceColor', marker_color, 'MarkerEdgeColor', 'k');
    end

    
    % Add horizontal dashed line for the initial state
    yline(0, '--k', 'LineWidth', 1);
    
    % Customize plot
    xlabel('Trial');
    ylabel('Drift State (Normalized)');
    title('Drift-Diffusion Model (Adjusted for Imbalances)');
    xlim([1 numTrials]);
    ylim([-1.1, 1.1]); % Adjust y-axis for normalized drift
    grid on;
    
    % Add dummy plots for legend entries
    h1 = plot(nan, nan, 'o', 'MarkerSize', 8, 'MarkerFaceColor', [0, 0.5, 1], 'MarkerEdgeColor', 'k'); % Correct Right
    h2 = plot(nan, nan, 'o', 'MarkerSize', 8, 'MarkerFaceColor', [1, 0.5, 0.5], 'MarkerEdgeColor', 'k'); % Correct Left
    h3 = plot(nan, nan, '^', 'MarkerSize', 8, 'MarkerFaceColor', [0, 0.5, 1], 'MarkerEdgeColor', 'k'); % Incorrect Right
    h4 = plot(nan, nan, '^', 'MarkerSize', 8, 'MarkerFaceColor', [1, 0.5, 0.5], 'MarkerEdgeColor', 'k'); % Incorrect Left
    
    % Add legend
    legend([h1, h2, h3, h4], ...
           {'Correct Right (Blue Circle)', ...
            'Correct Left (Red Circle)', ...
            'Incorrect Right (Blue Triangle)', ...
            'Incorrect Left (Red Triangle)'}, ...
           'Location', 'best');

    % Display weights for verification
    disp(['Correct Left Weight: ', num2str(correctLeftWeight)]);
    disp(['Correct Right Weight: ', num2str(correctRightWeight)]);
    disp(['Incorrect Left Weight: ', num2str(incorrectLeftWeight)]);
    disp(['Incorrect Right Weight: ', num2str(incorrectRightWeight)]);
    
end