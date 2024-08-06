function X= gen_newstate_fn(model,Xd,V,k)

if ~isnumeric(V)
    if strcmp(V,'noise')
        V= model.B*randn(size(model.B,2),size(Xd,2));
    elseif strcmp(V,'noiseless')
        V= zeros(size(model.B,1),size(Xd,2));
    end
end

if isempty(Xd)
    X= [];
elseif k ~= 1 %modify below here for user specified transition model
    X= zeros(size(Xd));

    if size(model.ref,1) == 2
        d1 = abs(Xd - model.ref(1,k-1));
        d2 = abs(Xd - model.ref(2,k-1));
        p1 = model.ref(1,k)/ model.ref(1,k-1);
        p2 = model.ref(2,k)/ model.ref(2,k-1);
        X = Xd * ( d2 * p1 + d1 * p2 ) / (d1 + d2);
    else
        X = Xd * model.ref(k) / model.ref(k-1);
    end
else
    X = Xd;
end