close all
clear
clc

tic

%% Initial file management



if isfile('testAnimated.gif')
    delete('testAnimated.gif')
    disp('Deleted the file!')
end 

addpath('../_common')

addpath('FastPassTracker\')

addpath('Plotting\')

%% Load and preprocess data 

trimmed_data = load("../../raw-echogram/20181231_044516.mat","wiener2_modified").wiener2_modified;
trim_vals = [0 700];

% Note: not using anms data will split data directly from the echogram
all_data = load ("../../raw-echogram/20181231_044516.mat");
data = all_data.wiener2_modified;

close all;

anms_surpression_cutoff = 30;
supressed_detections = anms_detection(data(:,:),trim_vals,anms_surpression_cutoff);

%% Parfor loop

[model,est,meas] = tracking_supressed_detections(supressed_detections,trim_vals,'SingerAcceleration', trimmed_data);

time_run = toc;

fprintf('Tracker took %f seconds to run. \n',time_run)
fprintf('Tracker took %f minutes to run. \n',time_run/60)
fprintf('Tracker took %f hours to run. \n',time_run/3600)

%% Plotting

track_length_min = 0.98 * size(data,2); 

figure;
output_tracks = plot_results(model,meas,est,trimmed_data,[0;0;0],track_length_min);

ylim(trim_vals)
xlim([0,length(supressed_detections)])

drawnow; 

%% Saving Results
    
s.models = model;
s.ests = est;
s.meas = meas;
s.anms_val = anms_surpression_cutoff;
s.full_tracks = output_tracks;

structfilename = 'Structs/struct-' + string(datetime('now','Format','MM-dd-yy-HH-mm-ss')) + '.mat';

save(structfilename,'s');

rmpath('FastPassTracker\')
