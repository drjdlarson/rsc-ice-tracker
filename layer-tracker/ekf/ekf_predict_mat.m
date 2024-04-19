function [F,G]= ekf_predict_mat(model,mu_old)

F = 1;

G = model.B2;
end
    

    