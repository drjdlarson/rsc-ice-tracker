function layer_data = track_bed(data, range_cutoff, filter_window_ratio)
    cut_off_range_idx = round(size(data,1) * range_cutoff);

    data(1:cut_off_range_idx,:) = [];

    layer_data = [];
    for i = 1:size(data,2)
        cur_ascope = data(:,i);
        detrend_ascope = detrend(cur_ascope,3);


        [peak_val, peak_loc] = findpeaks(detrend_ascope);
        [max_val,max_loc] = max(peak_val);
        
        layer_data = horzcat(layer_data, [i; peak_loc(max_loc)]);
    end
    layer_data(2,:) = movmean(layer_data(2,:), size(layer_data,2)/filter_window_ratio);
    layer_data(2,:) = layer_data(2,:) + cut_off_range_idx;
end