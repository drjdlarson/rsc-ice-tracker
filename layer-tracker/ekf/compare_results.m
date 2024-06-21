%% compare_results.m 

% Author: Dawson Pierce

clear; close all; clc;

%% Import data

% struct-06-14-24-14-21

addpath("Structs\")
files = dir('Structs\');
file_names = {files(~[files.isdir]).name};

for k = 1:length(file_names)
    sim{k} = load(file_names{k});
end

trimmed_data = load("../../raw-echogram/20181231_044516.mat","wiener2_modified");
trimmed_data = trimmed_data.wiener2_modified;

%% Plot each on different subplots

track_length_min = 700;

% figure(1)
% imagesc(trimmed_data)
% colormap(1-gray)

for i = 1:length(sim)

    model = sim{i}.s.models;
    meas = sim{i}.s.meas;
    est = sim{i}.s.ests;

    legend_list = cell(length(model),1);

    for k = 1:length(model)
        legend_list{k} = model{k}.name;
    end

    figure("Name",'anms val: ' + string(sim{i}.s.anms_val))
    % imagesc(trimmed_data)
    % colormap(1-gray)
    
    for k = 1:length(model)
        model{k}.subplot = 1;
        plot_results(model{k},meas{k},est{k},trimmed_data,[0;0;0],track_length_min);
    end

    % legend(legend_list)

end