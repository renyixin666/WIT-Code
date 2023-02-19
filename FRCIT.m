function [ind] = FRCIT(x,y,z)
if ~isempty(z)
    M = (eye(size(x,1))-z*((z'*z)^-1)*z');
    res1 = M*x;
    res2 = M*y;
%     indpcc = PaCoT(res1,res2,[]);
%     if indpcc
%         ind = indpcc;
%     else
        ind = indTestByKurtosis(res1,res2);
%     end
else
%     indpcc = PaCoT(x,y,[]);
%     if indpcc
%         ind = indpcc;
%     else
        ind = indTestByKurtosis(x,y);
%     end
end
end

function [ind] = indTestByKurtosis(x,y)
t = 10;
D = [];
H = -1:0.1:1;
for h = H
    D = [D,kurtosis( h*x + y)];
end
C = [];
for i = 1:t
    A = bootrsp(x,1);
    B = bootrsp(y,1);
%     A = x(randperm(length(x)));
%     B = y(randperm(length(y)));
    TempD = [];
    for h = H
        TempD = [TempD,kurtosis( h*A + B)];
    end
    C = [C;TempD];
end

E = 0;
for k = 1:t
    E = E + C(k,:);
end
E = E/t;

DistCE = [];
for k = 1:t
    tempE = E';
    tempCk = C(k,:)';
    F1 = corr(tempE(1:floor(length(H)/2)+1,:),tempCk(1:floor(length(H)/2)+1,:),'type','Pearson');
    F2 = corr(tempE(floor(length(H)/2)+2:length(H),:),tempCk(floor(length(H)/2)+2:length(H),:),'type','Pearson');
    DistCE = [DistCE,(F1+F2)/2];
end
[DistCE,id] = sort(DistCE);
worstId = 1;
F = C(id(worstId),:);
tempE = E';
tempCk = D';
F1 = corr(tempE(1:floor(length(H)/2)+1,:),tempCk(1:floor(length(H)/2)+1,:),'type','Pearson');
F2 = corr(tempE(floor(length(H)/2)+2:length(H),:),tempCk(floor(length(H)/2)+2:length(H),:),'type','Pearson');
DistDE = (F1+F2)/2;
Score = [[max(DistCE),min(DistCE),DistCE(worstId),DistDE]];

if Score(4) > DistCE(worstId) % || Score(4) > 0.99
% if Score(4) > DistCE(worstId) && Score(4) > 0.95
    ind = true;
else
    ind = false;
end
end

function[out]=bootrsp(in,B)
%   out=bootrsp(in,B)
%    
%   Bootstrap  resampling  procedure. 
%
%     Inputs:
%        in - input data 
%         B - number of bootstrap resamples (default B=1)        
%     Outputs:
%       out - B bootstrap resamples of the input data  
%
%   For a vector input data of size [N,1], the  resampling 
%   procedure produces a matrix of size [N,B] with columns 
%   being resamples of the input vector.
%
%   For a matrix input data of size  [N,M], the resampling
%   procedure produces a 3D matrix of  size  [N,M,B]  with 
%   out(:,:,i), i = 1,...,B, being a resample of the input 
%   matrix.
%
%   Example:
%
%   out=bootrsp(randn(10,1),10);

%  Created by A. M. Zoubir and D. R. Iskander
%  May 1998
%
%  References:
% 
%  Efron, B.and Tibshirani, R.  An Introduction to the Bootstrap.
%               Chapman and Hall, 1993.
%
%  Zoubir, A.M. Bootstrap: Theory and Applications. Proceedings 
%               of the SPIE 1993 Conference on Advanced  Signal 
%               Processing Algorithms, Architectures and Imple-
%               mentations. pp. 216-235, San Diego, July  1993.
%
%  Zoubir, A.M. and Boashash, B. The Bootstrap and Its Application
%               in Signal Processing. IEEE Signal Processing Magazine, 
%               Vol. 15, No. 1, pp. 55-76, 1998.

if (exist('B')~=1), B=1;  end;
if (exist('in')~=1), error('Provide input data'); end;

s=size(in);     
if length(s)>2, 
  error('Input data can be a vector or a 2D matrix only'); 
end;
if min(s)==1,  
  out=in(ceil(max(s)*rand(max(s),B)));    
else         
  out=in(ceil(s(1)*s(2)*rand(s(1),s(2),B))); 
end
end
