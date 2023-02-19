function [ind] = Darling(x,y,z)
if ~isempty(z)
    M = (eye(size(x,1))-z*((z'*z)^-1)*z');
    res1 = M*x;
    res2 = M*y;
    ind = py.darling.main_darling(res1,res2);
else
    ind = py.darling.main_darling(x,y);
end


