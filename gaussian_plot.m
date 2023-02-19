x = [-2,-1,0,1,2];
mu = 0;
sigma = 1;
p = normcdf(x,mu,sigma);
color_all = ['#2ca02c','#9467bd','#ff7f0e','#d62728','#bcbd22','#3585bc'];
n=10000;
Nbins=100;
data = randn(n,1);
h = histogram(data,'Normalization','pdf');
Nbins = h.NumBins;
edges = h.BinEdges; 
x = zeros(1,Nbins);
for counter=1:Nbins
    midPointShift = abs(edges(counter)-edges(counter+1))/2;
    x(counter) = edges(counter)+midPointShift;
end
h.FaceColor = '#3585bc';
h.EdgeColor = '#3585bc';
hold on;
set(gca,'ytick',[])
vline(max(data), '--','color',hex2rgb('#9467bd'),'linewidth',2)
% Optional: Label the line:
text(max(data),0.3,' Max \rightarrow','color','#9467bd',...
   'horiz','right','vert','top','FontSize', 80) % pin text to top left corner
vline(min(data), '--','color',hex2rgb('#2ca02c'),'linewidth',2)
text(min(data),0.3,'\leftarrow Min ','color','#2ca02c',...
   'horiz','left','vert','top','FontSize', 80) % pin text to top left corner
x = [-5:0.01:5];
y = normpdf(x,0,1);
plot(x,y,'LineWidth',1.5,'Color','#d62728');
set(gca,'FontSize',50)
hold off;
figure;
h = histogram(2*(max(data)-data)/(max(data)-min(data))-1,'Normalization','pdf');
Nbins = h.NumBins;
edges = h.BinEdges; 
x = zeros(1,Nbins);
for counter=1:Nbins
    midPointShift = abs(edges(counter)-edges(counter+1))/2;
    x(counter) = edges(counter)+midPointShift;
end
h.FaceColor = '#3585bc';
h.EdgeColor = '#3585bc';
set(gca,'ytick',[])
set(gca,'FontSize',50)