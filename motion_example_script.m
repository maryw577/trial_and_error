%% Motion example script

close all; clear; clc;

load(['Motion2_VisOnly.mat'], 'data_output');
rawData = data_output;

processedData = preprocessData(rawData);
processedData = processedData(processedData.Stimulus ~= 0, :);

data = table2array(processedData);

% Extract the first four columns (Stimulus, SNR, Response, RT)
core_data = data(:, 1:4);

% Define the conditions
prev_stimulus_left = data(:, 5) == 1;
prev_stimulus_right = data(:, 5) == 2;

prev_response_left = data(:, 7) == 1;
prev_response_right = data(:, 7) == 2;

prev_outcome_correct = data(:, 8) == 1;
prev_outcome_incorrect = data(:, 8) == 0;

% Create matrices based on conditions
% By previous stimulus
matrix_prev_stim_left = core_data(prev_stimulus_left, :);
matrix_prev_stim_right = core_data(prev_stimulus_right, :);

right_var = 1;
left_var = 2;
catch_var = 0;
chosen_threshold = 0.72;
compare_plot = 0;
vel_stair = 0;

figure;
save_name = 'stair';
for i = 1:2
    if i == 1
        matrix_prev_stim_right(matrix_prev_stim_right(:, 1) == 0, 1) = 3; 
        [right_vs_left, right_group, left_group] = direction_plotter(matrix_prev_stim_right);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(matrix_prev_stim_right, right_vs_left);
        [fig, p_values, ci, threshold, xData, yData, x, p, sz, right_std_gaussian, right_mdl] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name, vel_stair);    
        scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', [0, 114, 178]/255, 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 4, 'Color', [0, 114, 178]/255, 'DisplayName', 'Right Prior Stimulus');
        hold on
    end
    if i == 2
        matrix_prev_stim_left(matrix_prev_stim_left(:, 1) == 0, 1) = 3; 
        [right_vs_left, right_group, left_group] = direction_plotter(matrix_prev_stim_left);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(matrix_prev_stim_left, right_vs_left);
        [fig, p_values, ci, threshold, xData, yData, x, p, sz, left_std_gaussian, left_mdl] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name, vel_stair);    
        scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', [230, 159, 0]/255, 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 4, 'Color', [230, 159, 0]/255, 'DisplayName', 'Left Prior Stimulus');
    end
end

% Set figure properties
title('');
legend('Location', 'NorthWest');
xlabel('Coherence ((-)Leftward, (+)Rightward)');
ylabel('Proportion Rightward Response');
xlim([-0.5 0.5])
ylim([0 1])
xticks([-0.5 0 0.5])
yticks([0 0.2 0.4 0.6 0.8 1.0])
beautifyplot;
unmatlabifyplot(0);
% Set the axes to take up the full monitor screen
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
right_sens = round(1/right_std_gaussian, 2);
left_sens = round(1/left_std_gaussian, 2);
text(0.05,0.2,sprintf("Left Prior Stimulus \n Sensitivity: ") + right_sens, 'FontWeight', 'bold', 'FontSize', 18, 'FontName', 'Times New Roman')
text(0.05,0.10,sprintf("Right Prior Stimulus \n Sensitivity: ") + left_sens, 'FontWeight', 'bold', 'FontSize', 18, 'FontName', 'Times New Roman')

% By previous response
matrix_prev_resp_left = core_data(prev_response_left, :);
matrix_prev_resp_right = core_data(prev_response_right, :);

figure;
save_name = 'stair';
for i = 1:2
    if i == 1
        matrix_prev_resp_right(matrix_prev_resp_right(:, 1) == 0, 1) = 3; 
        [right_vs_left, right_group, left_group] = direction_plotter(matrix_prev_resp_right);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(matrix_prev_resp_right, right_vs_left);
        [fig, p_values, ci, threshold, xData, yData, x, p, sz, right_std_gaussian, right_mdl] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name, vel_stair);    
        scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', [0, 114, 178]/255, 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 4, 'Color', [0, 114, 178]/255, 'DisplayName', 'Right Prior Response');
        hold on
    end
    if i == 2
        matrix_prev_resp_left(matrix_prev_resp_left(:, 1) == 0, 1) = 3; 
        [right_vs_left, right_group, left_group] = direction_plotter(matrix_prev_resp_left);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(matrix_prev_resp_left, right_vs_left);
        [fig, p_values, ci, threshold, xData, yData, x, p, sz, left_std_gaussian, left_mdl] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name, vel_stair);    
        scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', [230, 159, 0]/255, 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 4, 'Color', [230, 159, 0]/255, 'DisplayName', 'Left Prior Response');
    end
end

% Set figure properties
title('');
legend('Location', 'NorthWest');
xlabel('Coherence ((-)Leftward, (+)Rightward)');
ylabel('Proportion Rightward Response');
xlim([-0.5 0.5])
ylim([0 1])
xticks([-0.5 0 0.5])
yticks([0 0.2 0.4 0.6 0.8 1.0])
beautifyplot;
unmatlabifyplot(0);
% Set the axes to take up the full monitor screen
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
right_sens = round(1/right_std_gaussian, 2);
left_sens = round(1/left_std_gaussian, 2);
text(0.05,0.2,sprintf("Left Prior Response \n Sensitivity: ") + right_sens, 'FontWeight', 'bold', 'FontSize', 18, 'FontName', 'Times New Roman')
text(0.05,0.10,sprintf("Right Prior Response \n Sensitivity: ") + left_sens, 'FontWeight', 'bold', 'FontSize', 18, 'FontName', 'Times New Roman')

% By previous outcome
matrix_prev_outcome_correct = core_data(prev_outcome_correct, :);
matrix_prev_outcome_incorrect = core_data(prev_outcome_incorrect, :);

figure;
save_name = 'stair';
for i = 1:2
    if i == 1
        matrix_prev_outcome_correct(matrix_prev_outcome_correct(:, 1) == 0, 1) = 3; 
        [right_vs_left, right_group, left_group] = direction_plotter(matrix_prev_outcome_correct);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(matrix_prev_outcome_correct, right_vs_left);
        [fig, p_values, ci, threshold, xData, yData, x, p, sz, correct_std_gaussian, correct_mdl] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name, vel_stair);    
        scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', [0, 114, 178]/255, 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 4, 'Color', [0, 114, 178]/255, 'DisplayName', 'Correct Prior Trial');
        hold on
    end
    if i == 2
        matrix_prev_outcome_incorrect(matrix_prev_outcome_incorrect(:, 1) == 0, 1) = 3; 
        [right_vs_left, right_group, left_group] = direction_plotter(matrix_prev_outcome_incorrect);
        rightward_prob = unisensory_rightward_prob_calc(right_vs_left, right_group, left_group, right_var, left_var);
        [total_coh_frequency, left_coh_vals, right_coh_vals, coherence_lvls, coherence_counts, coherence_frequency] = frequency_plotter(matrix_prev_outcome_incorrect, right_vs_left);
        [fig, p_values, ci, threshold, xData, yData, x, p, sz, incorrect_std_gaussian, incorrect_mdl] = normCDF_plotter(coherence_lvls, ...
        rightward_prob, chosen_threshold, left_coh_vals, right_coh_vals, ...
        coherence_frequency, compare_plot, save_name, vel_stair);    
        scatter(xData, yData, sz, 'LineWidth', 2, 'MarkerEdgeColor', [230, 159, 0]/255, 'HandleVisibility', 'off');
        hold on
        plot(x, p, 'LineWidth', 4, 'Color', [230, 159, 0]/255, 'DisplayName', 'Incorrect Prior Trial');
    end
end

% Set figure properties
title('');
legend('Location', 'NorthWest');
xlabel('Coherence ((-)Leftward, (+)Rightward)');
ylabel('Proportion Rightward Response');
xlim([-0.5 0.5])
ylim([0 1])
xticks([-0.5 0 0.5])
yticks([0 0.2 0.4 0.6 0.8 1.0])
beautifyplot;
unmatlabifyplot(0);
% Set the axes to take up the full monitor screen
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
correct_sens = round(1/correct_std_gaussian, 2);
incorrect_sens = round(1/incorrect_std_gaussian, 2);
text(0.05,0.2,sprintf("Incorrect Prior Trial \n Sensitivity: ") + correct_sens, 'FontWeight', 'bold', 'FontSize', 18, 'FontName', 'Times New Roman')
text(0.05,0.10,sprintf("Correct Prior Trial \n Sensitivity: ") + incorrect_sens, 'FontWeight', 'bold', 'FontSize', 18, 'FontName', 'Times New Roman')




%visualizeDescriptiveAnalysis(processedData);