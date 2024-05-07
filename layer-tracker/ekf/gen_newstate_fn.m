function X= gen_newstate_fn(model,Xd,V)

%nonlinear state space equation (CT model)

if ~isnumeric(V)
    if strcmp(V,'noise')
        V= model.B*randn(size(model.B,2),size(Xd,2));
    elseif strcmp(V,'noiseless')
        V= zeros(size(model.B,1),size(Xd,2));
    end
end

if isempty(Xd)
    X= [];
else %modify below here for user specified transition model
    X= zeros(size(Xd));
    %-- add scaled noise
    % Xd = [x; x_dot]
    X = model.F * Xd + model.B2*V;
end