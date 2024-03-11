close all;
clear;
clc;

load 20181231_044516.mat;

bed_data = track_bed(lee_enhanced, 0.5, 100);
ascope_idx = 34;

detection = cell(1,size(lee_enhanced,2));
for k = 1:size(lee_enhanced,2)
    [~,peak_loc] = findpeaks(lee_enhanced(:,k));
    above_bed_idx = peak_loc < bed_data(2,k) - 10;
    detection{1,k} = peak_loc(above_bed_idx);
end


figure(1)
imagesc(lee_enhanced)
colormap (1-gray)
hold on 
plot (bed_data(1,:), bed_data(2,:),'r', LineWidth=1.5)
xline(ascope_idx,'g')
for k = 1:5:size(lee_enhanced,2)
    x = k*ones(size(detection{1,k},1),1);
    y = detection{1,k}(:,:);
    scatter(x, y, 'r.');
end

figure(2)
plot (lee_enhanced(:,ascope_idx),'LineWidth',1.5)

