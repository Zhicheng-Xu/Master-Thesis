clear all
close all

X = rand(200000,3);
Z = linkage(X,'ward');

% 10 clusters in total
NoC=10;

T(1:100000)=1;
T(100001:150000)=2;
T(150001:175000)=3;
T(175001:185000)=4;
T(185001:190000)=5;
T(190001:194000)=6;
T(194001:197000)=7;
T(197001:198000)=8;
T(198001:199500)=9;
T(199501:200000)=10;
RGB=colormap('jet');
RGB=interp1(1:length(RGB),RGB,(1:NoC)*length(RGB)/NoC);

% Calculate Shannon index
SI=0;

for c=1:NoC;
    ind=find(T==c);
    
    L=length(ind); % abundance of p
    
    p=L/length(T); % total abundance
    SI=SI-p*log(p);
    
    N(c)=length(ind);
end



figure
subplot(1,2,1)
[h IDX pla]=dendrogram(Z,NoC);%
set(h,'LineWidth',2,'Color','k')

clusterNo='C'+string(1:NoC);


ax=axis;
set(gca,'XTickLabel',clusterNo,'LineWidth',2,'FontWeight','bold')
ylabel('Spectral distance','FontWeight','bold','FontSize',16)
box on
hold on
for c=1:NoC;
    ms=0.2*sqrt(N(c));
    plot(c,ax(3)+0.2,'o','Markersize',ms,'MarkerEdgeColor','none','MarkerFaceColor',RGB(c,:));
end

T(1:20000)=1;
T(20001:40000)=2;
T(40001:60000)=3;
T(60001:80000)=4;
T(80001:100000)=5;
T(100001:120000)=6;
T(120001:140000)=7;
T(140001:160000)=8;
T(160001:180000)=9;
T(180001:200000)=10;
RGB=colormap('jet');
RGB=interp1(1:length(RGB),RGB,(1:NoC)*length(RGB)/NoC);

SI=0;

for c=1:NoC;
    ind=find(T==c);
    
    L=length(ind);
    
    p=L/length(T);
    SI=SI-p*log(p);
    
    N(c)=length(ind);

    
end


subplot(1,2,2)
[h IDX pla]=dendrogram(Z,NoC);%
set(h,'LineWidth',2,'Color','k')

clusterNo='C'+string(1:NoC);


ax=axis;
set(gca,'XTickLabel',clusterNo,'LineWidth',2,'FontWeight','bold')
ylabel('Spectral distance','FontWeight','bold','FontSize',16)
box on
hold on
for c=1:NoC;
    ms=0.2*sqrt(N(c));
    plot(c,ax(3)+0.2,'o','Markersize',ms,'MarkerEdgeColor','none','MarkerFaceColor',RGB(c,:));
end