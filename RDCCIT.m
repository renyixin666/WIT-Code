function [ind] = RDCCIT(x,y,z)
    x = x - mean(x);
    y = y - mean(y);
    z = z - mean(z);

    if ~isempty(z)
        M = (eye(size(x,1))-z*((z'*z)^-1)*z');
        res1 = M*x;
        res2 = M*y;
        XY = [res1,res2];
        p = double(py.rdc.rdcmain(py.numpy.array(XY)));
        ind = p>0.04;
    else
        XY = [x y];
        p = double(py.rdc.rdcmain(py.numpy.array(XY)));
        ind = p>0.04;
    end
end