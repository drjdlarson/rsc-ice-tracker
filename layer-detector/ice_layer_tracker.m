close all;
clear;
clc;

load ("../raw-echogram/20181231_044516.mat");

data  = wiener2_modified;

bed_data = track_bed(data, 0.5, 70);
ascope_idx = 34;

detection = cell(1,size(data,2));
for k = 1:size(data,2)
    [~,peak_loc] = findpeaks(data(:,k));
    above_bed_idx = peak_loc < bed_data(2,k) - 10;
    above_bed_loc = peak_loc(above_bed_idx);

    % Only save detection toward the top for initial testing
    trim_idx = peak_loc < 700;
    time_bed_loc = peak_loc(trim_idx);

    detection{1,k} = time_bed_loc';

    
end


figure(1)
imagesc(data)
colormap (1-gray)
hold on 
plot (bed_data(1,:), bed_data(2,:),'r', LineWidth=1.5)
%xline(ascope_idx,'g')
for k = 1:10:size(data,2)
    x = k*ones(size(detection{1,k},1),1);
    y = detection{1,k}(:,:);
    scatter(x, y, 'r.');
end

figure(2)
plot (data(:,ascope_idx),'LineWidth',1.5)

figure(3)
imagesc(data)
colormap (1-gray)
hold on 
plot (bed_data(1,:), bed_data(2,:),'r', LineWidth=3)
%xline(ascope_idx,'g')

