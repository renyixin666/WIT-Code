function [skeleton] = PC_sklearn(data,maxCset,Alg)
n = size(data,2);
skeleton = ones(n,n);
for c = 1:n
    skeleton(c,c) = 0;
end
for i = 1:n-1
    for j = i+1:n
        continFlag = 1;
        for k = 0:maxCset
            if skeleton(i,j) == 1 && continFlag == 1
                if k == 0
                    ind = Alg(data(:,i),data(:,j),[]);
                    if ind
                        skeleton(i,j) = 0;
                        skeleton(j,i) = 0;
                    end
                else
                    p1 = find(skeleton(i,:)==1);
                    p2 = find(skeleton(j,:)==1);
                    p3 = find(skeleton(:,i)==1)';
                    p4 = find(skeleton(:,j)==1)';
                    p = unique(setdiff([p1,p2,p3,p4],[i,j]));
                    if length(p) >= k
                        csetM = nchoosek(p,k);
                    else
                        break
                    end
                    len_csetM = size(csetM,1);
                    for t = 1:len_csetM
                        ind = Alg(data(:,i),data(:,j),data(:,csetM(t,:)));
                        if ind
                            skeleton(i,j) = 0;
                            skeleton(j,i) = 0;
                            continFlag = 0;
                            break
                        end
                    end
                end
            end
        end
    end
end