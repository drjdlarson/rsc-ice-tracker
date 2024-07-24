function plot_truth(truth)

for k = 1:length(truth)
    plot(truth{k}.x_final,truth{k}.y_final,'g--','LineWidth',1.2)
end

end