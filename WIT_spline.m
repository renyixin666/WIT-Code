function [ind] = WIT_spline(x,y,z)
    x = x - mean(x);
    y = y - mean(y);
    z = z - mean(z);

    if ~isempty(z)
        M = (eye(size(x,1))-z*((z'*z)^-1)*z');
        res1 = M*x;
        res2 = M*y;
        res1 = (max(res1)-res1)/(max(res1)-min(res1))*2-1;
        res2 = (max(res2)-res2)/(max(res2)-min(res2))*2-1;
        ind = WBIT_spline(res1,res2);
    else
        x = (max(x)-x)/(max(x)-min(x))*2-1;
        y = (max(y)-y)/(max(y)-min(y))*2-1;
        ind = WBIT_spline(x,y);
    end
end

function [ind] = WBIT_spline(X,Y) 
    B = 500;
    permutation_test = [];
    for i=1:B
        p = randperm(length(X));
        Xp = X(p,1);
        permutation_test = [permutation_test abs(ind_test(Xp,Y))];
    end
    wavelet_test = abs(ind_test(X,Y));
    p_value = sum(permutation_test>wavelet_test)/B;
    ind = p_value > 0.04;
end

function [nX] = wave_kernel(X)
    n = length(X);
    nl = 2;%[0-5]
    result_X = zeros(n,2^(nl)+nl+1);
    result_X(:,1) = X;
    for k = [-1,0,1]
        result_X(:,k+3) = linear_spline_phi(X,k);
    end
    nlevels = nl-1;
    count = 4;
    for level = 0:nlevels-1
        for k = -2^level: 2^level
            count = count + 1;
            result_X(:,count) = linear_spline_psi(X,level,k);
        end
    end
    nX = result_X;
end

function [psi_X] = linear_spline_psi(X,level,k) 
    value = (2^level)*X-k;
    idx1 = (value>=-1) & (value<-1/2);
    idx2 = (value>=-1/2) & (value<1/2);
    idx3 = (value>=-1/2) & (value<=1);
    psi_X = zeros(size(value));
    psi_X(idx1) = 2*value(idx1)+2;
    psi_X(idx2) = -2*value(idx2);
    psi_X(idx3) = 2*value(idx3)-2;
end

function [phi_X] = linear_spline_phi(X,k) 
    value = X-k;
    idx1 = (value>=0) & (value<=1);
    idx2 = (value>=-1) & (value<0);
    phi_X = zeros(size(value));
    phi_X(idx1) = 1-value(idx1);
    phi_X(idx2) = 1+value(idx2);
end


function [corr_max] = corr_abs_max(X,Y)
    kappa = 0.1;
    sx = size(X);
    k = sx(2);
    corr_max = 0;
    for j = 1:k
        x = repmat(X(:, j), 1, k);
        y = Y;
        c = max(abs(corr_rho(x,y,kappa)));
        if c>corr_max
            corr_max = c;
        end
    end
end

function [result] = ind_test(X,Y)
    wx = wave_kernel(X);
    wy = wave_kernel(Y);
    result = corr_abs_max(wx,wy);
end

function [c] = corr_rho(x,y,kappa)
    n = length(x);
    xc = x - mean(x, 1);
    yc = y - mean(y, 1);
    xy = conj(xc) .* yc;
    cxy = sum(xy, 1);
    xx = conj(xc) .* xc;
    cxx = sum(xx, 1);
    yy = conj(yc) .* yc;
    cyy = sum(yy, 1);
    if cxx>0.00001 & cyy>0.00001
        c = (cxy/(n*(n-1))) ./ sqrt(cxx/(n-1)) ./ sqrt(cyy/(n-1));
    else
        c = (cxy/(n*(n-1))) ./ sqrt(cxx/(n-1)+kappa) ./ sqrt(cyy/(n-1)+kappa);
    end
end
