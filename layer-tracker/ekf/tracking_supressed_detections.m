function [model,est,meas] = tracking_supressed_detections(detection,trim_val,model_name, trimmed_data, varagin)

subplot_params = 0;

if nargin == 5
    subplot_params = varagin;
end

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

end