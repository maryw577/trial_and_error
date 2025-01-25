function fitBayesianModel(data)
    % Fit model using custom Bayesian script
    params_posterior = fitBayesianModelp(data);

    % Display results
    disp('Posterior Estimates:');
    disp(['Intercept (Param 1): ', num2str(params_posterior(1))]);
    disp(['Sensitivity (Param 2): ', num2str(params_posterior(2))]);

    % Visualize posterior (optional)
    figure;
    histogram(params_posterior, 'Normalization', 'pdf');
    xlabel('Parameter Value'); ylabel('Density');
    title('Posterior Distributions');
end

function params_posterior = fitBayesianModelp(data)
    % Priors
    prior_mu = 0; % Mean of prior
    prior_sigma = 1; % Standard deviation of prior

    % Likelihood function
    likelihood = @(params, x, y) normpdf(y, params(1) + params(2) * x, 1);

    % Grid search for posterior estimation
    param1_range = linspace(-2, 2, 100); % Intercept range
    param2_range = linspace(-2, 2, 100); % Slope range
    [p1_grid, p2_grid] = meshgrid(param1_range, param2_range);
    posterior = zeros(size(p1_grid));

    for i = 1:numel(p1_grid)
        % Evaluate the likelihood and prior
        prior = normpdf(p1_grid(i), prior_mu, prior_sigma) * ...
                normpdf(p2_grid(i), prior_mu, prior_sigma);
        likelihood_value = prod(likelihood([p1_grid(i), p2_grid(i)], data.SNR, data.Response));
        posterior(i) = likelihood_value * prior;
    end

    % Normalize posterior
    posterior = posterior / sum(posterior(:));

    % Sample from posterior (for simplicity, return MAP estimate here)
    [~, max_idx] = max(posterior(:));
    params_posterior = [p1_grid(max_idx), p2_grid(max_idx)];
end
