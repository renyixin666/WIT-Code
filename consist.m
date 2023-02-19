tic
method_test = 1;
fun = {@f5};
f_number = length(fun);
t = 100;
testn = [20000];
result = zeros(4,length(testn));

f = fun{1};
for i = 1:length(testn)
    n = testn(i);
    M_Type_I1 = 0;
    M_Type_II1 = 0;
    M_Type_I2 = 0;
    M_Type_II2 = 0;
    for Times = 1:t
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
        M_Type_I1 = M_Type_I1 + 1 - WIT_spline(X,Y,[]);
        M_Type_I2 = M_Type_I2 + 1 - RDCCIT(X,Y,[]);
        
        X = f(s1 + s2) + (s3 + s4);
        Y = f(s1 - s2) + s5;
        M_Type_II1 = M_Type_II1 + WIT_spline(X,Y,[]);
        M_Type_II2= M_Type_II2 + RDCCIT(X,Y,[]);

        [M_Type_I1/Times M_Type_II1/Times;M_Type_I2/Times M_Type_II2/Times]
    end
    result(:,i) = [M_Type_I1/t;M_Type_II1/t;M_Type_I2/t;M_Type_II2/t]
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
