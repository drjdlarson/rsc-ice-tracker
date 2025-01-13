close all
clear
clc

load ("../../raw-echogram/20181231_044516.mat");

ascope_ind = 500;

data  = wiener2_modified;

skip = 1;

% CFAR parameters
scaling_factor = 1.1;
training_cell_width = 5;
guard_cell_width = 1;

%% Pre allocate
detection = cell(1, size(data,2));

for kk = 1:skip:size(data,2)
    [detection{1,kk}, ~] = cfar_1D(data(:,kk)+10, guard_cell_width, ...
        training_cell_width, scaling_factor); % Shift data up 100 to deal with negative
end

% [detection{1,ascope_ind}, threshold] = cfar_1D(data(:,ascope_ind)+50, guard_cell_width, ...
%          training_cell_width, scaling_factor); % Shift data up 100 to deal with negative

% x = ascope_ind * ones(size(detection{1,ascope_ind}));

figure()
imagesc(data)
colormap (1-gray)
hold on 
% scatter(x, detection{1,ascope_ind},'r.')
for kk = 1:skip:size(data,2)
    x = kk * ones(size(detection{1,kk}));
    scatter(x, detection{1,kk},'r.')
end

% figure()
% plot (data(:,ascope_ind)+50)
% hold on
% plot (threshold)