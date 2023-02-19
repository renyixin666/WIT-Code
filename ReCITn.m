function [ind] = ReCITn(x,y,z)
n = length(x);
if ~isempty(z)
    xf = fit_gpr(z,x,cov,hyp,Ncg);
    res1 = xf-x;
    yf = fit_gpr(z,y,cov,hyp,Ncg);
    res2 = yf-y;
    ind = KCIT(res1,res2,[]);
else
    ind = KCIT(x,y,[]);
end


