function[Score]= ScoreSkeleton(Cskeleton,skeleton)
R = sum(sum(skeleton.*Cskeleton))/sum(sum(skeleton));
if sum(sum(Cskeleton)) == 0
    P =0;
else
    P = 2*sum(sum(skeleton.*Cskeleton))/sum(sum(Cskeleton));
end
if R+P == 0
    Score = [R,P,0];
else
    Score = [R,P,2*R*P/(R+P)];
end
end