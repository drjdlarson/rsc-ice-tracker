%% compare_results.m 

% Author: Dawson Pierce

clear; close all; clc;

%% Import data

% struct-06-14-24-14-21

addpath("Structs\low hypothesis\")

addpath("Plotting\")

files = dir('Structs\low hypothesis\');
file_names = {files(~[files.isdir]).name};

for k = 1:length(file_names)
    sim{k} = load(file_names{k});
end

trimmed_data = load("../../raw-echogram/20181231_044516.mat","wiener2_modified").wiener2_modified;

% truth = load('truth-07-08-24-12-24-28.mat').s;

%% Plot each on different subplots

track_length_min = 700;

% figure(1)
% imagesc(trimmed_data)
% colormap(1-gray)

for i = 1:length(sim)

    model = sim{i}.s.models;
    meas = sim{i}.s.meas;
    est = sim{i}.s.ests;

    % legend_list = cell(length(model),1);

    % for k = 1:length(model)
    %     legend_list{k} = model{k}.name;
    % end

    figure("Name",file_names{i}); % 'anms val: ' + string(sim{i}.s.anms_val)
    % figure(i)
    % imagesc(trimmed_data)
    % colormap(1-gray)
    
    if length(model) ~= 1
    for k = 1:length(model)
        model{k}.subplot = 1;
        plot_results(model{k},meas{k},est{k},trimmed_data,[0;0;0],track_length_min);
        % plot_truth(truth);
        % ylim([150 300])
    end
    else
        plot_results(model,meas,est,trimmed_data,[0;0;0],track_length_min);
        % plot_truth(truth);
    end

    % legend(legend_list)

end