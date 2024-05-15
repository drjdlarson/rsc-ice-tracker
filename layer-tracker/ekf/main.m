close all
clear
clc

if isfile('testAnimated.gif')
    delete('testAnimated.gif')
    disp('Deleted the file!')
end

addpath('../_common')

trimmed_data = load("../../raw-echogram/20181231_044516.mat","wiener2_modified");
trimmed_data = trimmed_data.wiener2_modified;

% Dynamical Systems Test

full_list = {'Jerk','MarkovAcceleration','WienerAcceleration','WhiteJerk','WhiteAcceleration', ...
    'SingerAcceleration','SingerJerk'};

list = full_list;

trim_vals = [100 250];

% Note: not using anms data will split data directly from the echogram
% all_data = load ("../../raw-echogram/20181231_044516.mat");
% data = all_data.wiener2_modified;
% detection_and_tracking(data,trim_vals,list{1}, trimmed_data)

% Note: using the anms data you must include the trimmed_data as the
% echogram
all_data = load('anms_detection.mat','detection');
data = all_data.detection;

x_lim = 500;  % trim x dimensions

parfor k = 1:length(list)
    [model{k},est{k},meas{k}] = detection_and_tracking(data,x_lim,trim_vals,list{k}, trimmed_data,[k, length(list)]);
end

flag = 0;
flag2 = 0;

max_num_rows = 3;
figure(2)
for k = 1:length(list)
    model{k}.max_num = max_num_rows;

    if k > max_num_rows && flag == 0
        figure(3)
        flag = 1;
    elseif k > 2 * max_num_rows && flag2 == 0
        figure(4)
        flag2 = 1;
    end

    if flag == 1 && flag2 ~= 1
        model{k}.num = model{k}.num - max_num_rows;
    end

    if flag2 == 1
        model{k}.num = model{k}.num - 2 * max_num_rows;
    end

    plot_results(model{k},meas{k},est{k},trimmed_data);
end
