function [model,est,meas] = detection_and_tracking(data,x_lim,trim_val,model_name, trimmed_data, varagin)
%% Importing data

subplot_params = 0;

if nargin == 6
    subplot_params = varagin;
end

if x_lim == 0
    x_lim = size(data,2);
end

if isa(data,'cell')
    detection = cell(1,x_lim);
    for k = 1:x_lim
        % Only save detection toward the top for initial testing
        trim_idx = (data{k} < trim_val(2))&(data{k} > trim_val(1));
        trim_bed_loc = data{k}(trim_idx);
    
        detection{1,k} = trim_bed_loc';
    
    end
else
    bed_data = track_bed(data, 0.5, 70);
    
    detection = cell(1,x_lim);
    for k = 1:x_lim
        [~,peak_loc] = findpeaks(data(:,k),"NPeaks",150,'SortStr','descend');
        above_bed_idx = peak_loc < bed_data(2,k) - 10;
        
        % Only save detection toward the top for initial testing
        trim_idx = (peak_loc < trim_val(2))&(peak_loc > trim_val(1));
        trim_bed_loc = peak_loc(trim_idx);
    
        detection{1,k} = trim_bed_loc';
    
    end
end

% figure(3)
% imagesc(data)
% colormap (1-gray)
% hold on 
% plot (bed_data(1,:), bed_data(2,:),'r', LineWidth=1.5)
% for k = 1:10:size(data,2)
%     x = k*ones(size(detection{1,k},1),1);
%     y = detection{1,k}(:,:);
%     scatter(x, y, 'r.');
% end

%% Now, Layer Tracking

layer_detection = detection;

detection_idx = 1:1:size(layer_detection,2);
meas_cell = cell(1,size(detection_idx,2));
meas_map = zeros(1,size(detection_idx,2));
k = 1;

for i = detection_idx
    meas_cell{1,k} = layer_detection{1,i};
    meas_map(1,k) = i;
    k = k+1;
end

meas.K = size(meas_cell,2);
meas.Z = meas_cell;
meas.meas_map = meas_map;

if subplot_params == 0
    model= gen_model(model_name,trim_val);
else
    model= gen_model(model_name,trim_val,subplot_params);
end

est=   run_filter(model,meas, trimmed_data);

%% Tuan's Function

    function layer_data = track_bed(data, range_cutoff, filter_window_ratio)
        cut_off_range_idx = round(size(data,1) * range_cutoff);
    
        data(1:cut_off_range_idx,:) = [];
    
        layer_data = [];
        for i = 1:size(data,2)
            cur_ascope = data(:,i);
            detrend_ascope = detrend(cur_ascope,3);
    
    
            [peak_val, peak_loc] = findpeaks(detrend_ascope);
            [~,max_loc] = max(peak_val);
            
            layer_data = horzcat(layer_data, [i; peak_loc(max_loc)]);
        end
        layer_data(2,:) = movmean(layer_data(2,:), size(layer_data,2)/filter_window_ratio);
        layer_data(2,:) = layer_data(2,:) + cut_off_range_idx;
    end
end