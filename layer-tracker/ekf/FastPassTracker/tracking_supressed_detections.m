function [model,est,meas] = tracking_supressed_detections(detection,trim_val,model_name, trimmed_data,non_surpressed_detections)

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

model= gen_model(model_name,trim_val,non_surpressed_detections);

est=   run_filter(model,meas, trimmed_data);

end