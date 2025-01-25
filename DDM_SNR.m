function DDM_SNR(processedData)

    % Initialize the drift variable
    numTrials = height(processedData);
    drift = zeros(1, numTrials);
    initial_state = 0; % Start drift at zero
    drift(1) = initial_state;
    
    % Normalize Response for drift calculations
    normalizedResponse = processedData.Response; % Copy original response
    normalizedResponse(normalizedResponse == 2) = -1; % Right -> -1 (toward bottom boundary)
    normalizedResponse(normalizedResponse == 1) = 1;  % Left -> +1 (toward top boundary)
    
    % Normalize SNR (assuming SNR is in processedData.SNR)
    SNR = processedData.SNR;
    
    % Loop through trials and calculate drift
    for t = 2:numTrials
        if ~isnan(normalizedResponse(t)) && ~isnan(processedData.PrevOutcome(t)) && ~isnan(SNR(t))
            % Adjust drift based on outcome and SNR
            if processedData.PrevOutcome(t) == 1 % Correct
                drift(t) = drift(t-1) + SNR(t) * normalizedResponse(t); % Positive drift scaled by SNR
            elseif processedData.PrevOutcome(t) == 0 % Incorrect
                drift(t) = drift(t-1) - SNR(t) * normalizedResponse(t); % Negative drift scaled by SNR
            end
        else
            drift(t) = drift(t-1); % No change if any value is NaN
        end
    end
    
    % Normalize drift to range [-1, 1] for better scaling
    drift = drift / max(abs(drift));
    
    % Plot the drift-diffusion model
    figure;
    plot(1:numTrials, drift, '-k', 'LineWidth', 3); % Drift line
    hold on;
    
    % Plot markers for responses
    for t = 1:numTrials
        if processedData.Response(t) == 1 % Left response
            marker_color = [230, 159, 0] / 255; % Orange for left
            if processedData.PrevOutcome(t) == 1 % Correct
                marker = 'o'; % Circle for correct
            else
                marker = '^'; % Triangle for incorrect
            end
        elseif processedData.Response(t) == 2 % Right response
            marker_color = [0, 114, 178] / 255; % Blue for right
            if processedData.PrevOutcome(t) == 1 % Correct
                marker = 'o'; % Circle for correct
            else
                marker = '^'; % Triangle for incorrect
            end
        else
            continue; % Skip if response is invalid
        end

        % Plot marker
        plot(t, drift(t), marker, 'MarkerSize', 12, 'MarkerFaceColor', marker_color, 'MarkerEdgeColor', 'k');
    end

    % Add horizontal dashed lines for boundaries
    yline(1, '--k', 'Left Boundary', 'LabelHorizontalAlignment', 'left', 'LineWidth', 2);
    yline(-1, '--k', 'Right Boundary', 'LabelHorizontalAlignment', 'left', 'LineWidth', 2);
    
    % Add horizontal dashed line for the initial state
    yline(0, '--k', ' ', 'LabelHorizontalAlignment', 'left', 'LineWidth', 2);
    
    % Customize plot
    xlabel('Trial', 'FontSize', 14, 'FontWeight', 'bold');
    ylabel('Drift State (Normalized)', 'FontSize', 14, 'FontWeight', 'bold');
    title('Drift-Diffusion Model with SNR', 'FontSize', 16, 'FontWeight', 'bold');
    xlim([1 numTrials]);
    ylim([-1.1, 1.1]); % Adjust y-axis for normalized drift
    grid on;
    
    % Add dummy plots for legend entries
    h1 = plot(nan, nan, 'o', 'MarkerSize', 12, 'MarkerFaceColor', [230, 159, 0] / 255, 'MarkerEdgeColor', 'k'); % Correct Left
    h2 = plot(nan, nan, 'o', 'MarkerSize', 12, 'MarkerFaceColor', [0, 114, 178] / 255, 'MarkerEdgeColor', 'k'); % Correct Right
    h3 = plot(nan, nan, '^', 'MarkerSize', 12, 'MarkerFaceColor', [230, 159, 0] / 255, 'MarkerEdgeColor', 'k'); % Incorrect Left
    h4 = plot(nan, nan, '^', 'MarkerSize', 12, 'MarkerFaceColor', [0, 114, 178] / 255, 'MarkerEdgeColor', 'k'); % Incorrect Right
    
    % Add legend
    legend([h1, h2, h3, h4], ...
           {'Correct Left (Orange Circle)', ...
            'Correct Right (Blue Circle)', ...
            'Incorrect Left (Orange Triangle)', ...
            'Incorrect Right (Blue Triangle)'}, ...
           'Location', 'best', 'FontSize', 12);

    hold off;
end
