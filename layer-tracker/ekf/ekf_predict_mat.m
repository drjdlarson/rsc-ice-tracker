function [F,G]= ekf_predict_mat(model,mu_old)

F = model.F;

G = model.B2;
end
    

    