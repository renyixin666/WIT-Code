function [ind] = ReCIT(x,y,z)
if ~isempty(z)
    M = (eye(size(x,1))-z*((z'*z)^-1)*z');
    res1 = M*x;
    res2 = M*y;
    ind = KCIT(res1,res2,[]);
else
    ind = KCIT(x,y,[]);
end


