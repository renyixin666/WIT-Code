function [ind] = HSCIT(x,y,z)
n = length(x);
if ~isempty(z)
    M = (eye(size(x,1))-z*((z'*z)^-1)*z');
    res1 = M*x;
    res2 = M*y;
    ind = HSCI(res1,res2);
else
    ind = HSCI(x,y);
end


