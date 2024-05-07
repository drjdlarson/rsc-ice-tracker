function model= gen_model

% basic parameters
% model.x_dim= 5;   %dimension of state vector
% model.z_dim= 2;   %dimension of observation vector
% model.v_dim= 3;   %dimension of process noise
% model.w_dim= 2;   %dimension of observation noise

% % Snow tracker params
model.x_dim= 2;   %dimension of state vector
model.z_dim= 1;   %dimension of observation vector
model.v_dim= 1;   %dimension of process noise
model.w_dim= 1;   %dimension of observation noise

% dynamical model parameters (CT model)
% state transformation given by gen_newstate_fn, transition matrix is N/A in non-linear case
% model.T= 1;                         %sampling period
% model.sigma_vel= 5;
% model.sigma_turn= (pi/180);   %std. of turn rate variation (rad/s)
% model.bt= model.sigma_vel*[ (model.T^2)/2; model.T ];
% model.B2= [ model.bt zeros(2,2); zeros(2,1) model.bt zeros(2,1); zeros(1,2) model.T*model.sigma_turn ];
% model.B= eye(model.v_dim);
% model.Q= model.B*model.B';

% % Snow tracking specific model
model.T = 1;
%%
model.sigma_range = 0.5; % How much we allow layer to traverse
%%

% Main model
model.F = [1 pi/180; 0 1];
model.B = model.sigma_range * eye(model.v_dim);
model.Q= model.B*model.B';
model.B2 = [1/2; model.T];

% For Observation
model.H = [1,0];

% survival/death parameters
model.P_S= 0.999;
model.Q_S= 1-model.P_S;

% birth parameters (LMB birth model, single component only)
model.T_birth= 1;         %no. of LMB birth terms
model.L_birth= zeros(model.T_birth,1);                                          %no of Gaussians in each LMB birth term
model.r_birth= zeros(model.T_birth,1);                                          %prob of birth for each LMB birth term
model.w_birth= cell(model.T_birth,1);                                           %weights of GM for each LMB birth term
model.m_birth= cell(model.T_birth,1);                                           %means of GM for each LMB birth term
model.B_birth= cell(model.T_birth,1);                                           %std of GM for each LMB birth term
model.P_birth= cell(model.T_birth,1);                                           %cov of GM for each LMB birth term

model.L_birth(1)=1;                                                             %no of Gaussians in birth term 1
model.r_birth(1)=.25;                                                          %prob of birth
model.w_birth{1}(1,1)= 1;                                                       %weight of Gaussians - must be column_vector
model.m_birth{1}(:,1)= [350; 0];                                 %mean of Gaussians
model.B_birth{1}(:,:,1)= diag([400, 2]);                  %std of Gaussians
model.P_birth{1}(:,:,1)= model.B_birth{1}(:,:,1)*model.B_birth{1}(:,:,1)';      %cov of Gaussians

% Generate T_birth number of birth terms uniformly space along the range
% bound
% model.birth_bound = [0 700];
% birth_mean = linspace(model.birth_bound(1), model.birth_bound(2), model.T_birth);
% birth_P = (birth_mean(2) - birth_mean(1)) / 2;
% 
% for ii = 1:model.T_birth
%     model.L_birth(ii)=1;                                                             %no of Gaussians in birth term 1
%     model.r_birth(ii)=0.1;                                                          %prob of birth
%     model.w_birth{ii}(1,1)= 1;                                                       %weight of Gaussians - must be column_vector
%     model.m_birth{ii}(:,1)= birth_mean(ii);                                 %mean of Gaussians
%     model.B_birth{ii}(:,:,1)= diag(birth_P);                  %std of Gaussians
%     model.P_birth{ii}(:,:,1)= model.B_birth{1}(:,:,1)*model.B_birth{1}(:,:,1)';      %cov of Gaussians
% end

% observation model parameters (noisy range only)
% measurement transformation given by gen_observation_fn, observation matrix is N/A in non-linear case
model.D= diag([0.05]);                     %std for range noise
model.R= model.D*model.D';              %covariance for observation noise

% detection parameters
model.P_D= 0.97;   %probability of detection in measurements
model.Q_D= 1-model.P_D; %probability of missed detection in measurements

% clutter parameters
model.lambda_c= 8;                             %poisson average rate of uniform clutter (per scan)
model.range_c= [0 700];          %uniform clutter on r/theta
model.pdf_c= 1/prod(model.range_c(:,2)-model.range_c(:,1)); %uniform clutter density
end



