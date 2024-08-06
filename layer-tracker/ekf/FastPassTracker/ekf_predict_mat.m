function [F,G]= ekf_predict_mat(model,mu_old,k)

F = model.F;

G = model.B2;
end
    

    