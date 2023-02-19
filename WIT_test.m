tic
method_test = 1;
% fun = {@f1,@f2,@f3,@f4,@f5};
fun = {@f1};
f_number = length(fun);
M_Type_I = zeros(method_test,f_number);
M_Type_II = zeros(method_test,f_number);
t = 100;
for j = 1:f_number
    f = fun{j}
    for Times = 1:t
        n = 1000;
%         S = betarnd(0.2,0.4,n,7);
%         S = rand(n,7)-1/2;
%         S = chi2rnd(1,n,7);
        S = laplacernd(0,1,n,7);
%         S = exprnd(0.5,n,7);
        S = S./(max(S)-min(S));
        S = S - mean(S);
        s1 = S(:,1);
        s2 = S(:,2);
        s3 = S(:,3);
        s4 = S(:,4);
        s5 = S(:,5);
        s6 = S(:,6);
        s7 = S(:,7);
        
        X = f(s1 + s2) + (s3 + s4);
        Y = f(s6 - s7) + s5;
        M_Type_I(1,j) = M_Type_I(1,j) + 1 - WIT_spline(X,Y,[]);
%         M_Type_I(2,j) = M_Type_I(2,j) + 1 - KCIT(X,Y,[]);
%         M_Type_I(3,j) = M_Type_I(3,j) + 1 - HSCIT(X,Y,[]);
%         M_Type_I(4,j) = M_Type_I(4,j) + 1 - FRCIT(X,Y,[]);
%         M_Type_I(6,j) = M_Type_I(6,j) + 1 - RDCCIT(X,Y,[]);
%         M_Type_I(2,j) = M_Type_I(2,j) + 1 - SCIT(X,Y,[]);
%         M_Type_I(1,j) = M_Type_I(1,j) + 1 - Darling(X,Y,[]);
        
        X = f(s1 + s2) + (s3 + s4);
        Y = f(s1 - s2) + s5;
        M_Type_II(1,j) = M_Type_II(1,j) + WIT_spline(X,Y,[]);
%         M_Type_II(2,j) = M_Type_II(2,j) + KCIT(X,Y,[]);
%         M_Type_II(3,j) = M_Type_II(3,j) + HSCIT(X,Y,[]);
%         M_Type_II(4,j) = M_Type_II(4,j) + FRCIT(X,Y,[]);
%         M_Type_II(6,j) = M_Type_II(6,j) + RDCCIT(X,Y,[]);
%         M_Type_II(1,j) = M_Type_II(1,j) + Darling(X,Y,[]);
%         M_Type_II(2,j) = M_Type_II(2,j) + SCIT(X,Y,[]);
        
        [M_Type_I(:,j)/Times M_Type_II(:,j)/Times]
    end
    [M_Type_I M_Type_II]/t
end
toc


function [x_out] = f1(x)
    x_out = x;
end
function [x_out] = f2(x)
    x_out = sin(x);
end
function [x_out] = f3(x)
    x_out = exp(-abs(x));
end
function [x_out] = f4(x)
    x_out = log(x.^2);
end
function [x_out] = f5(x)
    x_out = x.^2;
end
function [X]=laplacernd(mu,b,n,m)
    U = rand(n,m)-1/2;
    X = mu-b.*sign(U).*log(1-2.*abs(U));
end
