function [F,G]= ekf_predict_mat(model,mu_old,k)

if k ~= 1
    if size(model.ref,1) == 2
        d1 = abs(mu_old - model.ref(2,k-1));
        d2 = abs(mu_old - model.ref(1,k-1));
        p1 = model.ref(2,k)/ model.ref(2,k-1);
        p2 = model.ref(1,k)/ model.ref(1,k-1);
        F = ( d2 * p1 + d1 * p2 ) / (d1 + d2);
    else
        F = model.ref(k) / model.ref(k-1);
    end
else
    F = 1;
end

G = model.B2;
end
    

    