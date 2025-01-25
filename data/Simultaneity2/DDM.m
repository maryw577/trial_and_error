function DDM(processedData)

    % Initialize the drift variable
    numTrials = height(processedData);
    drift = zeros(1, numTrials);
    initial_state = 0; % Start drift at zero
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
            if processedData.PrevOutcome(t) == 1
                if processedData.Response(t) == 1 % Left response
                    drift(t) = drift(t-1) + correctLeftWeight * normalizedResponse(t);
                elseif processedData.Response(t) == 2 % Right response
                    drift(t) = drift(t-1) + correctRightWeight * normalizedResponse(t);
                end
            % Incorrect responses
            elseif processedData.PrevOutcome(t) == 0
                if processedData.Response(t) == 1 % Left response
                    drift(t) = drift(t-1) - incorrectLeftWeight * normalizedResponse(t);
                elseif processedData.Response(t) == 2 % Right response
                    drift(t) = drift(t-1) - incorrectRightWeight * normalizedResponse(t);
                end
            end
        else
            drift(t) = drift(t-1); % No change if PrevOutcome or Response is NaN
        end
    
        % Centralize drift
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
        elseif processedData.Response(t) == 1 % Left response
            marker_color = [1, 0.5, 0.5]; % Red for left
        else
            continue; % Skip if response is invalid
        end
        
        if processedData.PrevOutcome(t) == 1 % Correct
            marker = 'o'; % Circle for correct
        elseif processedData.PrevOutcome(t) == 0 % Incorrect
            marker = '^'; % Triangle for incorrect
        else
            continue; % Skip if outcome is NaN or invalid
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
    
    % Add legend
    legend({'Drift State', 'Correct R', 'Correct L', 'Incorrect R', 'Incorrect L'}, 'Location', 'best');
    
    % Display weights for verification
    disp(['Correct Left Weight: ', num2str(correctLeftWeight)]);
    disp(['Correct Right Weight: ', num2str(correctRightWeight)]);
    disp(['Incorrect Left Weight: ', num2str(incorrectLeftWeight)]);
    disp(['Incorrect Right Weight: ', num2str(incorrectRightWeight)]);
    
    
    % Prepare data for DDM fitting
    RT = processedData.RT; % Response times
    Outcome = processedData.PrevOutcome; % 1 = Correct, 0 = Incorrect
    StimulusDirection = normalizedResponse; % Drift direction (-1 = Left, 1 = Right)
    
    % Exclude NaN entries
    validIndices = ~isnan(RT) & ~isnan(Outcome) & ~isnan(StimulusDirection);
    RT = RT(validIndices);
    Outcome = Outcome(validIndices);
    StimulusDirection = StimulusDirection(validIndices);
    
    % Define DDM likelihood function
    ddm_likelihood = @(params) -sum(log( ...
        ddm_pdf(RT, Outcome, StimulusDirection, params(1), params(2), params(3))));
    
    % Initial guesses for [drift rate (v), boundary separation (a), non-decision time (t0)]
    initialParams = [0.1, 1, 0.2]; 
    
    % Parameter bounds
    lb = [0, 0.1, 0.1]; % Lower bounds
    ub = [Inf, 5, 1]; % Upper bounds
    
    % Optimize parameters using fmincon
    options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'interior-point');
    [fitParams, negLogLikelihood] = fmincon(ddm_likelihood, initialParams, [], [], [], [], lb, ub, [], options);
    
    % Display fitted parameters
    disp('Fitted Parameters:');
    disp(['Drift Rate (v): ', num2str(fitParams(1))]);
    disp(['Boundary Separation (a): ', num2str(fitParams(2))]);
    disp(['Non-Decision Time (t0): ', num2str(fitParams(3))]);
    
    
    %% Step 2: Fit Drift-Diffusion Model (DDM)
    
    % Prepare data for DDM fitting
    RT = processedData.RT; % Response times
    Outcome = processedData.PrevOutcome; % 1 = Correct, 0 = Incorrect
    normalizedResponse = processedData.Response; % Copy original response
    normalizedResponse(normalizedResponse == 2) = 1;  % Right -> +1
    normalizedResponse(normalizedResponse == 1) = -1; % Left -> -1
    StimulusDirection = normalizedResponse; % Drift direction (-1 = Left, 1 = Right)
    
    % Exclude NaN entries
    validIndices = ~isnan(RT) & ~isnan(Outcome) & ~isnan(StimulusDirection);
    RT = RT(validIndices);
    Outcome = Outcome(validIndices);
    StimulusDirection = StimulusDirection(validIndices);
    
    % Define DDM likelihood function
    ddm_likelihood = @(params) -sum(log( ...
        ddm_pdf(RT, Outcome, StimulusDirection, params(1), params(2), params(3))));
    
    % Initial guesses for [drift rate (v), boundary separation (a), non-decision time (t0)]
    initialParams = [0.1, 1, 0.2]; 
    
    % Parameter bounds
    lb = [0, 0.1, 0.1]; % Lower bounds
    ub = [Inf, 5, 1]; % Upper bounds
    
    % Optimize parameters using fmincon
    options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'interior-point');
    [fitParams, negLogLikelihood] = fmincon(ddm_likelihood, initialParams, [], [], [], [], lb, ub, [], options);
    
    % Display fitted parameters
    disp('Fitted Parameters:');
    disp(['Drift Rate (v): ', num2str(fitParams(1))]);
    disp(['Boundary Separation (a): ', num2str(fitParams(2))]);
    disp(['Non-Decision Time (t0): ', num2str(fitParams(3))]);
    
    %% Step 3: Visualize Fitted Parameters (Optional)
    % Simulate decision-making using fitted parameters and compare with observed data.
    % Example visualization can be added here.
    
    %% Helper Function: DDM PDF
    function p = ddm_pdf(RT, Outcome, StimulusDirection, v, a, t0)
        % Compute the DDM probability density for each trial
        % Inputs:
        % RT - Response times
        % Outcome - Correct (1) or Incorrect (0)
        % StimulusDirection - Drift bias (-1 or +1)
        % v - Drift rate
        % a - Boundary separation
        % t0 - Non-decision time
    
        % Adjust RT for non-decision time
        RT = max(RT - t0, eps);
    
        % Compute drift-diffusion PDF (approximation)
        drift = StimulusDirection .* v;
        evidenceTerm = -(drift .* a) ./ RT; % Drift influence on boundary crossing
        p = abs(drift) .* exp(evidenceTerm) ./ (RT .^ 1.5); % Drift-diffusion likelihood
    end
end