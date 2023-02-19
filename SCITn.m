function [ind] = SCITn(x,y,z)
if ~isempty(z)
    M = (eye(size(x,1))-z*((z'*z)^-1)*z');
    res1 = M*x;
    res2 = M*y;
    ind = py.nitff.main_nitff(res1,res2);
else
    ind = py.nitff.main_nitff(x,y);
end


