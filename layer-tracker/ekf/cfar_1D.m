function [detections, threshold] = cfar_1D(data, guard_width, train_width, gain)
    pad = guard_width + train_width;
    threshold = data;
    
    [peaks_data, peak_loc] = findpeaks(data);
    for ii = pad+1:size(data,1)- (pad + 1)
        leading_cell = data(ii-pad:ii-train_width);
        lagging_cell = data(ii+train_width:ii+pad);
        avg_power = mean([leading_cell; lagging_cell]);
        threshold(ii) = avg_power * gain;
    end
    
    % Find bed which is max 
    [~,bed_loc] = max(data);

    [peaks_data, peak_loc] = findpeaks(data);
    
    thres_at_peaks = threshold(peak_loc);
    detections = peak_loc(peaks_data > thres_at_peaks); % Get detection above threshold
    detections(detections > bed_loc) = [];   % Remove detection below bed
    detections = vertcat(detections, bed_loc); % Add bed

end