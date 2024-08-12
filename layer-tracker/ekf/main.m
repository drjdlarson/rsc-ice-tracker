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
addpath('Plotting\')

%% Load and preprocess data 

addpath('FastPassTracker\')

trimmed_data = load("../../raw-echogram/20181231_044516.mat","wiener2_modified").wiener2_modified;
trim_vals = [0 700];

% Note: not using anms data will split data directly from the echogram
all_data = load ("../../raw-echogram/20181231_044516.mat");
data = all_data.wiener2_modified;

anms_surpression_cutoff = 30;
[supressed_detections,non_surpressed_detections] = anms_detection(data(:,:),trim_vals,anms_surpression_cutoff);

figure(1)
subplot(1,2,1); ylim(trim_vals)
subplot(1,2,2); ylim(trim_vals)

%% Run Tracker 

[model,est,meas] = tracking_supressed_detections(supressed_detections,trim_vals,'SingerAcceleration', trimmed_data,non_surpressed_detections);

time_run = toc;

fprintf('Tracker took %f seconds to run. \n',time_run)
fprintf('Tracker took %f minutes to run. \n',time_run/60)
fprintf('Tracker took %f hours to run. \n',time_run/3600)

%% Plotting

track_length_min = 0.98 * size(data,2); 

figure(2);
output_tracks = plot_results(model,meas,est,trimmed_data,[0;0;0],track_length_min);

ylim(trim_vals)
xlim([0,length(supressed_detections)])

drawnow; 

%% Data Parsing for Layer Informed Tracker

rmpath("FastPassTracker\")
addpath('LayerInformedTracker\')

avg = zeros(1,length(output_tracks));

for k = 1:length(output_tracks)
    avg(k) = mean(output_tracks{k}(2,:));
end

[avg_sorted, idx] = sort(avg);

ref_layers = cell(1);

for k = 1:length(idx)
    ref_layers{k} = output_tracks{idx(k)};
end

new_detections = cell(length(ref_layers) + 1,1);
new_detections_suppressnt = cell(length(ref_layers) + 1,1);
second_pass_models = cell(length(ref_layers)+1,1);

anms_tuning_param = 40;

for k = 1:length(ref_layers)+1
    if k == 1 
        [new_detections{k},new_detections_suppressnt{k}] = anms_detection(data,trim_vals(1) * ones(2,length(ref_layers{k})),ref_layers{k});
        second_pass_models{k} = gen_model([trim_vals(1) ref_layers{k}(2,2)],new_detections_suppressnt{k},0,ref_layers{k}(2,:));

    elseif k == length(ref_layers)+1
        [new_detections{k},new_detections_suppressnt{k}] = anms_detection(data,ref_layers{k-1},trim_vals(2) * ones(2,length(ref_layers{k-1})));
        second_pass_models{k} = gen_model([ref_layers{k-1}(2,2) trim_vals(2)],new_detections_suppressnt{k},0,ref_layers{k-1}(2,:));

    else
        [new_detections{k},new_detections_suppressnt{k}] = anms_detection(data,ref_layers{k-1},ref_layers{k});
        second_pass_models{k} = gen_model([ref_layers{k-1}(2,2) ref_layers{k}(2,2)],new_detections_suppressnt{k},ref_layers{k}(2,:),ref_layers{k-1}(2,:));

    end
end

% [detection] = anms_detection(data,top_ref,bottom_ref,anms_surpression_cutoff)]

figure;
imagesc(data); hold on
colormap (1-gray)
for kk = 1:length(ref_layers)+1
    for k = 1:1:size(data,2)
        % x = k*ones(size(new_detections_suppressnt{kk}{1,k},2),1);
        % y = new_detections_suppressnt{kk}{1,k}(:,:);
        % scatter(x, y, 'g.');
        x = k*ones(size(new_detections{kk}{1,k},2),1);
        y = new_detections{kk}{1,k}(:,:);
        scatter(x, y, 'r.');
    end
    if kk ~= length(ref_layers)+1
        plot(ref_layers{kk}(1,:),ref_layers{kk}(2,:),'k','LineWidth',1);
    end
end
title('Amns Detections','With Reference Layers')

ylim(trim_vals)

drawnow; 

% Meas creation

second_meas = cell(1);

for kk = 1:length(ref_layers)+1
    detection_idx = 1:1:size(new_detections{kk},2);
    meas_cell = cell(1,size(detection_idx,2));
    meas_map = zeros(1,size(detection_idx,2));
    k = 1;
    
    for i = detection_idx
        meas_cell{1,k} = new_detections{kk}{i};
        meas_map(1,k) = i;
        k = k+1;
    end
    
    second_meas_temp.K = size(meas_cell,2);
    second_meas_temp.Z = meas_cell;
    second_meas_temp.meas_map = meas_map;
    second_meas{kk} = second_meas_temp;
end

%% Layer Informed Tracker start

parfor k = 1:length(ref_layers)+1
    second_est{k} = run_filter(second_pass_models{k},second_meas{k});
end

%% Plot the rest

figure(2);

% for kk = 1:length(ref_layers)+1
%     for k = 1:1:size(data,2)
%         % x = k*ones(size(new_detections_suppressnt{kk}{1,k},2),1);
%         % y = new_detections_suppressnt{kk}{1,k}(:,:);
%         % scatter(x, y, 'g.');
%         x = k*ones(size(new_detections{kk}{1,k},2),1);
%         y = new_detections{kk}{1,k}(:,:);
%         scatter(x, y, 'b.');
%     end
% end


for k = 1:length(second_pass_models)
    second_output_tracks{k} = plot_results_together(second_pass_models{k},second_meas{k},second_est{k}, track_length_min);
end

ylim(trim_vals)
title('Full Tracks','Includes Reference (Black) and Layer Informed (Red)')

rmpath('LayerInformedTracker\')

second_time_run = toc;

fprintf('Timer has been on for %f seconds. \n',second_time_run)
fprintf('Timer has been on for %f minutes. \n',second_time_run/60)
fprintf('Timer has been on for %f hours. \n',second_time_run/3600)

for kk = 1:length(ref_layers)+1
    if kk ~= length(ref_layers)+1
        plot(ref_layers{kk}(1,:),ref_layers{kk}(2,:),'k','LineWidth',1);
    end
end

%% Append layer informed tracks with first pass

iter = length(output_tracks)+1;
for k = 1:length(second_output_tracks)
    for kk = 1:length(second_output_tracks{k})
        if ~isempty(second_output_tracks{k}{kk})
            output_tracks{iter} = second_output_tracks{k}{kk};
            iter = iter + 1;
        end
    end
end

% Plot just to check logic
figure; 
imagesc(data); colormap(1 -gray); hold on
for k = 1:length(output_tracks)
    plot(output_tracks{k}(1,:),output_tracks{k}(2,:),'r')
end
title('All tracks, appended into a single structure')

ylim(trim_vals)

%% Saving Results
    
s.models = model;
s.ests = est;
s.meas = meas;
s.models2 = second_pass_models;
s.ests2 = second_est;
s.meas2 = second_meas;
s.anms_val = anms_surpression_cutoff;
s.full_tracks = output_tracks;
s.full_tracks2 = second_output_tracks;

structfilename = 'Structs/struct-' + string(datetime('now','Format','MM-dd-yy-HH-mm-ss')) + '.mat';

save(structfilename,'s');
