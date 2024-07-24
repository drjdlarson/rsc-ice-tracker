% This is the demo script for the (joint prediction and update) implementation of the Generalized Labeled Multi-Bernoulli filter proposed in
% B.-T. Vo, and B.-N. Vo, "An Efficient Implementation of the Generalized Labeled Multi-Bernoulli Filter," IEEE Trans. Signal Processing, Vol. 65, No. 8, pp. 1975-1987, 2017.
% http://ba-ngu.vo-au.com/vo/VVH_FastGLMB_TSP17.pdf
% corresponding to the (separate prediction and update) implementation proposed in
% B.-N. Vo, B.-T. Vo, and D. Phung, "Labeled Random Finite Sets and the Bayes Multi-Target Tracking Filter," IEEE Trans. Signal Processing, Vol. 62, No. 24, pp. 6554-6567, 2014
% http://ba-ngu.vo-au.com/vo/VVP_GLMB_TSP14.pdf
% of the original filter proposed in
% B.-T. Vo, and B.-N. Vo, "Labeled Random Finite Sets and Multi-Object Conjugate Priors," IEEE Trans. Signal Processing, Vol. 61, No. 13, pp. 3460-3475, 2013.
% http://ba-ngu.vo-au.com/vo/VV_Conjugate_TSP13.pdf
%
% ---BibTeX entry
% @ARTICLE{GLMB3,
% author={B.-N. Vo and B.-T. Vo and H. Hung},
% journal={IEEE Transactions on Signal Processing},
% title={An Efficient Implementation of the Generalized Labeled Multi-Bernoulli Filter},
% year={2017},
% month={Apr}
% volume={65},
% number={8},
% pages={1975-1987}}
%
% @ARTICLE{GLMB2,
% author={B.-T. Vo and B.-N. Vo and D. Phung},
% journal={IEEE Transactions on Signal Processing},
% title={Labeled Random Finite Sets and the Bayes Multi-Target Tracking Filter},
% year={2014},
% month={Dec}
% volume={62},
% number={24},
% pages={6554-6567}}
%
% @ARTICLE{GLMB1,
% author={B.-T. Vo and B.-N. Vo
% journal={IEEE Transactions on Signal Processing},
% title={Labeled Random Finite Sets and Multi-Object Conjugate Priors},
% year={2013},
% month={Jul}
% volume={61},
% number={13},
% pages={3460-3475}}
%---
close all
clear
clc

if isfile('testAnimated.gif')
    delete('testAnimated.gif')
    disp('Deleted the file!')
end

addpath('../_common')

% Load in detection data
%% For snow
% layer_detection = load("layer_detection.mat",'layer_detection');
% layer_detection = layer_detection.layer_detection;
% trimmed_data = load("trimmed_data.mat","Data");
% trimmed_data = trimmed_data.Data;

%% For ice
layer_detection = load("anms_detection.mat",'detection');
layer_detection = layer_detection.detection;
trimmed_data = load("../../raw-echogram/20181231_044516.mat","wiener2_modified");
trimmed_data = trimmed_data.wiener2_modified;

%%
detection_idx = 1:1:size(layer_detection,2);
%detection_idx = 1:1:100;
% Convert current detection to match with Vo's measurement data
meas_cell = cell(1,size(detection_idx,2));
meas_map = zeros(1,size(detection_idx,2));
k = 1;
for i = detection_idx
    meas_cell{1,k} = layer_detection{1,i}';
    meas_map(1,k) = i;
    k = k+1;
end


%layer_detection = layer_detection{1,detection_idx};
meas.K = size(meas_cell,2);
meas.Z = meas_cell;
meas.meas_map = meas_map;

model= gen_model;
est=   run_filter(model,meas, trimmed_data);
handles= plot_results(model,meas,est,trimmed_data);


