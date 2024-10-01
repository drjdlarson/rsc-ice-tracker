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
addpath("F:\dbpierce")

trimmed_data = load("20181231_044516.mat","wiener2_modified").wiener2_modified;

% Dynamical Systems Test

full_list = {'Velocity','WhiteAcceleration','WienerAcceleration','Jerk', ...
    'SingerAcceleration'};

list = full_list; % ([2,5,6]);
list_colors = [rand(1,length(list)); rand(1,length(list)); rand(1,length(list))];

trim_vals = [0 800]; % [50 250]; % [100 250];

% Note: not using anms data will split data directly from the echogram
all_data = load ("20181231_044516.mat");
data = all_data.wiener2_modified;

% Note: using the anms data you must include the trimmed_data as the
% echogram
% all_data = load('anms_detection.mat','detection');
% data = all_data.detection;

x_lim = 100; % size(data,2)];  % trim x dimension
% 
% for anms_surpression_cutoff = 31:3:43
% 
close all;

anms_surpression_cutoff = 30;

supressed_detections = anms_detection(data(:,:),trim_vals,anms_surpression_cutoff);

%% Parfor loop
 % tracking_supressed_detections(detection,trim_val,model_name, trimmed_data, varagin)
parfor k = 1:length(list)
    [model{k},est{k},meas{k}] = tracking_supressed_detections(supressed_detections,trim_vals,list{k}, trimmed_data,[k, length(list)]);
end 

%% Plotting

track_length_min = 700; % 700;

% close all;
% 
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
%     plot_results_together(model{k},meas{k},est{k},trimmed_data,list_colors(:,k),track_length_min);
% end
% 
% legend(list)

% figure(2)

for k = 1:length(list)
    % figure
    model{k}.subplot = 1;
    output_tracks{k} = plot_results(model{k},meas{k},est{k},trimmed_data,[0;0;0],track_length_min);
end

% for k = 1:length(list)
%     figure(k+2)
%     model{k}.subplot = 0;
%     plot_results(model{k},meas{k},est{k},trimmed_data,[0;0;0]);
% end

toc

%% Saving Results
    
s.models = model;
s.ests = est;
s.meas = meas;
s.anms_val = anms_surpression_cutoff;
s.full_tracks = output_tracks;

structfilename = 'Structs/struct-' + string(datetime('now','Format','MM-dd-yy-HH-mm-ss')) + '.mat';

save(structfilename,'s');

% end
