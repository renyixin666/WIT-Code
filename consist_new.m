tic
method_test = 1;
% fun = {@f1,@f2,@f3,@f4,@f5};
fun = {@f5};
f_number = length(fun);
t = 500;
B_list = [100,200,300,400,500];
testn = [500,1000,1500,2000,2500];
result = zeros(2*f_number,length(testn));
result_all = zeros(length(B_list)*2*f_number,length(testn));
for b=1:length(B_list)
    B = B_list(b);
for f_i=1:f_number
    f = fun{f_i};
    for i = 1:length(testn)
        n = testn(i);
        M_Type_I1 = 0;
        M_Type_II1 = 0;
        M_Type_I2 = 0;
        M_Type_II2 = 0;
        for Times = 1:t
%             S = betarnd(0.2,0.4,n,7);
%             S = rand(n,7)-1/2;
%             S = chi2rnd(1,n,7);
            S = laplacernd(0,1,n,7);
%             S = exprnd(0.5,n,7);
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
            M_Type_I1 = M_Type_I1 + 1 - WIT_spline(X,Y,[],B);

            X = f(s1 + s2) + (s3 + s4);
            Y = f(s1 - s2) + s5;
            M_Type_II1 = M_Type_II1 + WIT_spline(X,Y,[],B);
        end
        result(2*f_i-1:2*f_i,i) = [M_Type_I1/t;M_Type_II1/t];
    end
end
    result_all(2*b-1:2*b,:)=result
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