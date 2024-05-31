close all
clear
clc

tic

%% Loading Data

if isfile('testAnimated.gif')
    delete('testAnimated.gif')
    disp('Deleted the file!')
end

addpath('../_common')

trimmed_data = load("../../raw-echogram/20181231_044516.mat","wiener2_modified");
trimmed_data = trimmed_data.wiener2_modified;

% Dynamical Systems Test

full_list = {'Jerk','MarkovAcceleration','WienerAcceleration','WhiteAcceleration', ...
    'SingerAcceleration','SingerJerk'};

list = full_list; % ([2,5,6]);
list_colors = [rand(1,length(list)); rand(1,length(list)); rand(1,length(list))];

trim_vals = [0 700]; % [50 250]; % [100 250];

% Note: not using anms data will split data directly from the echogram
% all_data = load ("../../raw-echogram/20181231_044516.mat");
% data = all_data.wiener2_modified;

% Note: using the anms data you must include the trimmed_data as the
% echogram
all_data = load('anms_detection.mat','detection');
data = all_data.detection;

x_lim = size(data,2);  % trim x dimensions

%% Parfor loop

parfor k = 1:length(list)
    [model{k},est{k},meas{k}] = detection_and_tracking(data,x_lim,trim_vals,list{k}, trimmed_data,[k, length(list)]);
end

%% Saving Results
    
s.models = model;
s.ests = est;
s.meas = meas;

structfilename = 'struct-' + string(datetime('now','Format','MM-dd-yy-HH-mm')) + '.mat';

save(structfilename,'s');

%% Plotting

close all;

% figure(1)
% imagesc(trimmed_data)
% colormap(1-gray)
% hold on
% 
% for k = 1:length(list_colors)
%     plot(0,0,'Color',list_colors(:,k))
% end
% 
% for k = 1:length(list)
%     plot_results_together(model{k},meas{k},est{k},list_colors(:,k));
% end
% 
% legend(list)

figure(2)

for k = 1:length(list)
    model{k}.subplot = 1;
    plot_results(model{k},meas{k},est{k},trimmed_data,[0;0;0]);
end

% for k = 1:length(list)
%     figure(k+2)
%     model{k}.subplot = 0;
%     plot_results(model{k},meas{k},est{k},trimmed_data,[0;0;0]);
% end

toc
