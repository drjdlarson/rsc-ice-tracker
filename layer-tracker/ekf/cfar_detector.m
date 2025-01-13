close all
clear
clc

load ("../../raw-echogram/20181231_044516.mat");

ascope_ind = 500;

data  = detrend_data;

% CFAR parameters
scaling_factor = 1.2;
training_cell_width = 10;
guard_cell_width = 10;

%% Pre allocate
detection = cell(1, size(data,2));

for kk = 1:size(data,2)
    [detection{1,kk}, ~] = cfar_1D(data(:,kk)+10, guard_cell_width, ...
        training_cell_width, scaling_factor); % Shift data up 100 to deal with negative
end


figure()
imagesc(data)
colormap (1-gray)
hold on 
for kk = 1:size(data,2)
    x = kk * ones(size(detection{1,kk}));
    scatter(x, detection{1,kk},'r.')
end