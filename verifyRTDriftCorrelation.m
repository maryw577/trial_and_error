function verifyRTDriftCorrelation(processedData, drift)

    % Ensure drift is normalized to [-1, 1]
    drift = drift / max(abs(drift)); 
    
    % Calculate distance to the nearest boundary (absolute value)
    distanceToBoundary = 1 - abs(drift); % Distance from drift state to boundary (±1)
    
    % Get reaction times (RT)
    RT = processedData.RT;

    % Debug sizes to confirm consistency
    disp(['Size of RT: ', num2str(length(RT))]);
    disp(['Size of drift: ', num2str(length(drift))]);

    % Ensure sizes of RT and distanceToBoundary match
    if length(RT) ~= length(distanceToBoundary)
        error('Size mismatch: RT and distanceToBoundary must have the same length.');
    end

    % Correlation analysis
    [r, p] = corr(distanceToBoundary', RT, 'Type', 'Pearson'); % Pearson correlation
    
    % Display results
    disp(['Correlation between Distance to Boundary and Reaction Time: r = ', num2str(r)]);
    disp(['p-value: ', num2str(p)]);
    
    % Plot scatter plot with regression line
    figure;
    scatter(distanceToBoundary, RT, 50, 'filled', 'MarkerFaceColor', [0.3, 0.6, 0.9]); % Blue markers
    hold on;
    % Fit and plot regression line
    fitCoeffs = polyfit(distanceToBoundary, RT, 1); % Linear fit
    plot(distanceToBoundary, polyval(fitCoeffs, distanceToBoundary), '-k', 'LineWidth', 2); % Regression line
    hold off;
    
    % Customize plot
    xlabel('Distance to Boundary', 'FontSize', 14, 'FontWeight', 'bold');
    ylabel('Reaction Time (ms)', 'FontSize', 14, 'FontWeight', 'bold');
    title('Correlation Between Distance to Boundary and Reaction Time', 'FontSize', 16, 'FontWeight', 'bold');
    grid on;
    
    % Display equation on the plot
    equationText = ['RT = ', num2str(fitCoeffs(1), '%.2f'), ' * Distance + ', num2str(fitCoeffs(2), '%.2f')];
    text(0.1, max(RT) * 0.9, equationText, 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');

end
