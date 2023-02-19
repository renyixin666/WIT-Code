clc;
clear;
addpath('.\dataset');addpath('.\hsicAlg');addpath('.\kcitAlg');
tic;
nsamples = 500;
n = 5; % dimension
m = 5; % num of methods
h = [0.5,0.8,1,1.2,1.5];
%-------------Score Matrix: s1 ~ type I error, s2 ~ type II error
M_Type_all = zeros(m*length(h),n+1);
for Times = 1:500 % 1000 times
    TimeIs = Times
    %-------------data generating Case II
    for k = 1:length(h)
        z  =rand(nsamples,n)-0.5;
        ny = randn(nsamples,1);
        nx = randn(nsamples,1);
        
        y = 0;
        x = 0;
        for t = 1:n
            x = x + z(:,t);
            y = y + z(:,t);
        end
        
            Y = h(k).*y./n + ny; 
            X = h(k).*x./n + nx;
            %-------------Type I error
            conset = z;
            

              M_Type_all(k,1) = M_Type_all(k,1) +  1 - WIT_spline(X,Y,conset);
              M_Type_all(k+length(h),1) = M_Type_all(k+length(h),1) +  1 - ReCIT(X,Y,conset);
              M_Type_all(k+2*length(h),1) = M_Type_all(k+2*length(h),1) +  1 - HSCIT(X,Y,conset);
              M_Type_all(k+3*length(h),1) = M_Type_all(k+3*length(h),1) +  1 - RDCCIT(X,Y,conset);
              M_Type_all(k+4*length(h),1) = M_Type_all(k+4*length(h),1) +  1 - SCIT(X,Y,conset);

            %--------------Type II error ----------------------
        for i=1:n 
                randID = 1:i-1;
                Num = i;
                if i == 1
                    conset = [];
                else
                    conset = z(:,randID(1:i-1));
                end
            M_Type_all(k,Num+1) = M_Type_all(k,Num+1) +  WIT_spline(X,Y,conset);
            M_Type_all(k+length(h),Num+1) = M_Type_all(k+length(h),Num+1) +  ReCIT(X,Y,conset);
            M_Type_all(k+2*length(h),Num+1) = M_Type_all(k+2*length(h),Num+1) +  HSCIT(X,Y,conset);
            M_Type_all(k+3*length(h),Num+1) = M_Type_all(k+3*length(h),Num+1) +  RDCCIT(X,Y,conset);
            M_Type_all(k+4*length(h),Num+1) = M_Type_all(k+4*length(h),Num+1) +  SCIT(X,Y,conset);
        end
    end
    %-------------Results
    Type_All = M_Type_all/Times
    toc
end
toc;