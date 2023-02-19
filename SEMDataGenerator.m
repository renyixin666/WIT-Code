function data=SEMDataGenerator(skeleton,nSample, noiseType, noiseRatio,n1,n2)
% skeleton = sortskeleton(skeleton);
skeleton = skeleton';
[dim, dim2]=size(skeleton);
if (dim ~= dim2)
    disp('The skeleton is not square!\n');
    return;
end
data=zeros(nSample, dim);
for i=1:dim
    parentIdx=find(skeleton(i,:)==true);
    if strcmp(noiseType, 'uniform')
        noise=mapstd(rand(1, nSample))';
    end
    if isempty(parentIdx)
        data(:, i) = noise*noiseRatio;
    else
%         weight=ones(length(parentIdx),1)/length(parentIdx);
        weight = ones(length(parentIdx),1)/length(parentIdx);
        if length(parentIdx) == 2
            weight(1) = n1;
            weight(2) = n2;
        end
        data(:, i) = data (:, parentIdx) * weight+ noise*noiseRatio;
        data(:, i) = mapstd(data(:, i)')';
    end
end
