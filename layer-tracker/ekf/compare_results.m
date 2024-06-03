%% compare_results.m 

% Author: Dawson Pierce

clear; close all; clc;

%% Import data

% sim{1} = load("struct-05-24-24-15.mat");
% sim{2} = load("struct-05-24-24-16.mat");
% sim{3} = load("struct-05-24-24-20-51.mat");
% sim{4} = load("struct-05-24-24-23-40.mat");
% sim{5} = load("struct-05-25-24-01-46.mat");
% sim{6} = load("struct-05-25-24-15-50.mat");
% sim{7} = load("struct-05-25-24-18-43.mat");
sim{1} = load("struct-05-25-24-20-27.mat"); % really good for long tracks
sim{2} = load("struct-05-28-24-13-16.mat"); 
sim{3} = load("struct-05-28-24-15-16.mat"); 
sim{4} = load("struct-05-28-24-17-00.mat"); 
% sim{12} = load("struct-05-29-24-14-42.mat"); 
% sim{13} = load("struct-05-29-24-22-12.mat"); 

trimmed_data = load("../../raw-echogram/20181231_044516.mat","wiener2_modified");
trimmed_data = trimmed_data.wiener2_modified;

%% Plot each on different subplots

for i = 1:length(sim)

    model = sim{i}.s.models;
    meas = sim{i}.s.meas;
    est = sim{i}.s.ests;

    figure(i)
    
    for k = 1:length(model)
        model{k}.subplot = 1;
        plot_results(model{k},meas{k},est{k},trimmed_data,[0;0;0]);
    end
end