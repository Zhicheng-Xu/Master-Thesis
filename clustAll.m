clear all
close all

load linkAllLowsubset Z PCo linFreq PDe
NoC=55;

T = cluster(Z,'maxclust',NoC);

RGB=colormap('jet');
RGB=interp1(1:length(RGB),RGB,(1:NoC)*length(RGB)/NoC);


for c=1:NoC;
    ind=find(T==c);
    L=length(ind);
    N(c)=length(ind);

    %For Copol.
    PCosort=sort(PCo(ind,:));
    
    centroidHiCo(c,:)=PCosort(ceil(L/4),:);
    centroidLoCo(c,:)=PCosort(ceil(L*3/4),:);
    centroidCo(c,:)=PCosort(ceil(L/2),:);

    %For Depol.
    PDesort=sort(PDe(ind,:));
    
    centroidHiDe(c,:)=PDesort(ceil(L/4),:);
    centroidLoDe(c,:)=PDesort(ceil(L*3/4),:);
    centroidDe(c,:)=PDesort(ceil(L/2),:);
   
    
end



figure
Dc=pdist(log(centroidCo),'euclidean');
Zc=linkage(log(centroidCo),'ward','euclidean','savememory','on');
reord=optimalleaforder(Zc,Dc);
[h IDX pla]=dendrogram(Zc,NoC,'reorder',reord);%
set(h,'LineWidth',2,'Color','k')


N=N(reord);
clusterNo='C'+string(1:NoC);
centroidHiCo=centroidHiCo(reord,:);
centroidLoCo=centroidLoCo(reord,:);
centroidCo=centroidCo(reord,:);
centroidHiDe=centroidHiDe(reord,:);
centroidLoDe=centroidLoDe(reord,:);
centroidDe=centroidDe(reord,:);

ax=axis;
set(gca,'XTickLabel',clusterNo,'LineWidth',2,'FontWeight','bold')
ylabel('Spectral distance','FontWeight','bold','FontSize',16)
box on
hold on
for c=1:NoC;
    ms=0.2*sqrt(N(c));
    plot(c,ax(3)+0.2,'o','Markersize',ms,'MarkerEdgeColor','none','MarkerFaceColor',RGB(c,:));
end



for c=1:NoC;
    ind=find(T==reord(c));
    Tnew(ind)=c;
end
    T=Tnew;
    clear Tnew
    
figure
[ha,pos]=tight_subplot(6,5,[0.05 0.01],[0.05 0.05],[0.05 0.01]);
for c=1:30
    axes(ha(c));
    
    semilogy(linFreq,centroidCo(c,:),'color',RGB(c,:),'LineWidth',3)
    hold on
    semilogy(linFreq,centroidHiCo(c,:),'color',[1 1 1]/2)
    semilogy(linFreq,centroidLoCo(c,:),'color',[1 1 1]/2)
    
    semilogy(linFreq,centroidDe(c,:),'color',RGB(c,:),'LineWidth',3,'LineStyle','--')
    semilogy(linFreq,centroidHiDe(c,:),'color',[1 1 1]/2,'LineStyle','--')
    semilogy(linFreq,centroidLoDe(c,:),'color',[1 1 1]/2,'LineStyle','--')
    axis tight
    title(['C' num2str(c) ' :' num2str(N(c))])
    set(gca,'FontSize',10,'LineWidth',2)

end
linkaxes(ha,'x');
linkaxes(ha,'y');

axes(ha(1)); ylabel('Power (a.u.)')
axes(ha(6)); ylabel('Power (a.u.)')
axes(ha(11)); ylabel('Power (a.u.)')
axes(ha(16)); ylabel('Power (a.u.)')
axes(ha(21)); ylabel('Power (a.u.)')
axes(ha(26)); ylabel('Power (a.u.)')

axes(ha(26)); xlabel('Frequency (Hz)')
axes(ha(27)); xlabel('Frequency (Hz)')
axes(ha(28)); xlabel('Frequency (Hz)')
axes(ha(29)); xlabel('Frequency (Hz)')
axes(ha(30)); xlabel('Frequency (Hz)')

figure
[ha,pos]=tight_subplot(5,5,[0.05 0.01],[0.07 0.05],[0.05 0.01]);
for c=31:NoC

    axes(ha(c-30));
    semilogy(linFreq,centroidCo(c,:),'color',RGB(c,:),'LineWidth',3)
    hold on
    semilogy(linFreq,centroidHiCo(c,:),'color',[1 1 1]/2)
    semilogy(linFreq,centroidLoCo(c,:),'color',[1 1 1]/2)
    
    semilogy(linFreq,centroidDe(c,:),'color',RGB(c,:),'LineWidth',3,'LineStyle','--')
    semilogy(linFreq,centroidHiDe(c,:),'color',[1 1 1]/2,'LineStyle','--')
    semilogy(linFreq,centroidLoDe(c,:),'color',[1 1 1]/2,'LineStyle','--')
    axis tight
    title(['C' num2str(c) ' :' num2str(N(c))])
    set(gca,'FontSize',10,'LineWidth',2)

end
linkaxes(ha,'x');
linkaxes(ha,'y');

axes(ha(1)); ylabel('Power (a.u.)')
axes(ha(6)); ylabel('Power (a.u.)')
axes(ha(11)); ylabel('Power (a.u.)')
axes(ha(16)); ylabel('Power (a.u.)')
axes(ha(21)); ylabel('Power (a.u.)')

axes(ha(21)); xlabel('Frequency (Hz)')
axes(ha(22)); xlabel('Frequency (Hz)')
axes(ha(23)); xlabel('Frequency (Hz)')
axes(ha(24)); xlabel('Frequency (Hz)')
axes(ha(25)); xlabel('Frequency (Hz)')
