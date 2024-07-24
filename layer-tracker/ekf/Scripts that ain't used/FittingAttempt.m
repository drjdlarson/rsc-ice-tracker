clear; close all

full_tracks = load('fitting-data.mat').s.full_tracks{2};
data = load ("../../raw-echogram/20181231_044516.mat").wiener2_modified;

for k = 1:length(full_tracks)
means(k) = mean(full_tracks{k}(2,3:end-3));
end

[means_sorted, idx] = sort(means);
ref_layer = full_tracks{idx(end-1)};
ref_layer2 = full_tracks{idx(1)};

for k = 1:length(means_sorted)
potential_function{k}(1:3) = full_tracks{k}(2,3);
    for kk = 4:length(ref_layer(2,:))
        potential_function{k}(kk) = ref_layer(2,kk)/ ref_layer(2,kk-1) * potential_function{k}(kk-1);
    end
end

figure; 
for k = 1:length(means_sorted)
plot(full_tracks{k}(1,:),(full_tracks{k}(2,:) - potential_function{k}),'--'); hold on
end
title('Error')
legend(string(means))

% figure
% imagesc(data); colormap(1-gray)
% hold on
% for k = 1:length(means_sorted)
% plot(full_tracks{k}(1,:),full_tracks{k}(2,:),'k','LineWidth',1.2); hold on
% end
% for k = 1:length(means_sorted)
% plot(ref_layer(1,:),potential_function{k},'r--','LineWidth',1.2); hold on
% end

% plot(ref_layer(1,:),ref_layer(2,:),'g','LineWidth',0.8)

%% Two layers of reference

for k = 1:length(means_sorted)
    potential_function2{k}(1:3) = full_tracks{k}(2,3);
    for kk = 4:length(ref_layer(2,:))
        d1 = abs(potential_function2{k}(kk-1) - ref_layer(2,kk-1));
        d2 = abs(potential_function2{k}(kk-1) - ref_layer2(2,kk-1));
        p1 = ref_layer(2,kk)/ ref_layer(2,kk-1);
        p2 = ref_layer2(2,kk)/ ref_layer2(2,kk-1);
        potential_function2{k}(kk) = ( d2 * p1 + d1 * p2 ) / (d1 + d2) * potential_function2{k}(kk-1);
    end
end

figure; 
for k = 1:length(means_sorted)
    if k == idx(end)
        continue
    else
        plot(full_tracks{k}(1,:),(full_tracks{k}(2,:) - potential_function2{k}),'r--'); hold on
    end
end
title('Error')

% figure
% imagesc(data); colormap(1-gray)
% hold on
% for k = 1:length(means_sorted)
% plot(full_tracks{k}(1,:),full_tracks{k}(2,:),'k','LineWidth',1.2); hold on
% end
% for k = 1:length(means_sorted)
% plot(ref_layer(1,:),potential_function2{k},'r--','LineWidth',1.2); hold on
% end
% 
% plot(ref_layer(1,:),ref_layer(2,:),'g','LineWidth',0.8)
% plot(ref_layer2(1,:),ref_layer2(2,:),'g','LineWidth',0.8)

%% Squared weights

for k = 1:length(means_sorted)
    potential_function3{k}(1:3) = full_tracks{k}(2,3);
    for kk = 4:length(ref_layer(2,:))
        d1 = abs(potential_function3{k}(kk-1) - ref_layer(2,kk-1));
        d2 = abs(potential_function3{k}(kk-1) - ref_layer2(2,kk-1));
        p1 = ref_layer(2,kk)/ ref_layer(2,kk-1);
        p2 = ref_layer2(2,kk)/ ref_layer2(2,kk-1);
        potential_function3{k}(kk) = ( d2^2 * p1 + d1^2 * p2 ) / (d1^2 + d2^2) * potential_function3{k}(kk-1);
    end
end

for k = 1:length(means_sorted)
    if k == idx(end)
        continue
    else
        plot(full_tracks{k}(1,:),(full_tracks{k}(2,:) - potential_function3{k}),'b--'); hold on
    end
end

%% Cubed weights

for k = 1:length(means_sorted)
    potential_function4{k}(1:3) = full_tracks{k}(2,3);
    for kk = 4:length(ref_layer(2,:))
        d1 = abs(potential_function4{k}(kk-1) - ref_layer(2,kk-1));
        d2 = abs(potential_function4{k}(kk-1) - ref_layer2(2,kk-1));
        p1 = ref_layer(2,kk)/ ref_layer(2,kk-1);
        p2 = ref_layer2(2,kk)/ ref_layer2(2,kk-1);
        potential_function4{k}(kk) = ( d2^3 * p1 + d1^3 * p2 ) / (d1^3 + d2^3) * potential_function4{k}(kk-1);
    end
end

for k = 1:length(means_sorted)
    if k == idx(end)
        continue
    else
        plot(full_tracks{k}(1,:),(full_tracks{k}(2,:) - potential_function4{k}),'g--'); hold on
    end
end

%% Plotting all

figure
imagesc(data); colormap(1-gray)
hold on
for k = 1:length(means_sorted)
plot(full_tracks{k}(1,:),full_tracks{k}(2,:),'k','LineWidth',1.2); hold on
end
for k = 1:length(means_sorted)
    if k == idx(end)
        continue
    else
        plot(ref_layer(1,:),potential_function2{k},'r--','LineWidth',1.2); hold on
    end
end
for k = 1:length(means_sorted)
    if k == idx(end)
        continue
    else
        plot(ref_layer(1,:),potential_function3{k},'b--','LineWidth',1.2); hold on
    end
end
for k = 1:length(means_sorted)
    if k == idx(end)
        continue
    else
        plot(ref_layer(1,:),potential_function4{k},'g--','LineWidth',1.2); hold on
    end
end

plot(ref_layer(1,:),ref_layer(2,:),'m','LineWidth',0.8)
plot(ref_layer2(1,:),ref_layer2(2,:),'m','LineWidth',0.8)
