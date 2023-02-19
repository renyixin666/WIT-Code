function [ind] = SCIT(x,y,z)
n = length(x);
k = 50; % num of counterparts
if ~isempty(z)
    M = (eye(size(x,1))-z*((z'*z)^-1)*z');
    sumYX = mean(exp(-2*(M*(y - x)).^2));
else
    M = 0;
    sumYX = mean(exp(-2*((y - x)).^2));
end
sumYZ = zeros(1,k);
for i = 1:k
    if M == 0
        sumYZ(i) = mean(exp(-2*(x-y(randperm(n))).^2));
    else
        sumYZ(i) = mean(exp(-2*(M*x-M(randperm(n),:)*y).^2));
    end
end
if sumYX > max(sumYZ) || sumYX < min(sumYZ)
    ind = 0;
else
    ind = 1;
end
end
