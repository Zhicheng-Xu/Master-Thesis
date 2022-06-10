clear
load waveformDilu Z Zn lag gain obs


lag=squareform(lag);
gain=squareform(gain);

NoC=55;
T=cluster(Z,'maxclust',NoC);
RGB=colormap('jet');
RGB=interp1(1:length(RGB),RGB,(1:NoC)*length(RGB)/NoC);

for c=1:NoC
    ind=find(T==c);
    %find the longest waveform in the cluster
    L(c)=length(obs(ind(1)).bsCo);
    indL(c)=ind(1);
    for i=2:length(ind)
        if length(obs(ind(i)).bsCo) > L(c)
            L(c)=length(obs(ind(i)).bsCo);
            indL(c)=ind(i);
        end
    end
    
    %align every other waveform to the longest one
    waveAssemble=NaN(length(ind),L(c));
    for i=1:length(ind)
        delay=abs(lag(indL(c),ind(i)));
        waveAssemble(i,delay+1:delay+length(obs(ind(i)).bsCo))=obs(ind(i)).bsCo;
    end
    
    %plot the centroid, higher bound, and lower bound waveform
    N(c)=length(ind);
    for i=1:L(c)
        temp=quantile(waveAssemble(:,i),[.25, .5, .75]);
        centroidHi(c,i)=temp(3);
        centroidLo(c,i)=temp(1);
        centroid(c,i)=temp(2);
    end
end




clusterNo='C'+string(1:NoC);



    
figure
[ha,pos]=tight_subplot(6,5,[0.05 0.01],[0.05 0.05],[0.05 0.01]);
for c=1:30
    
    axes(ha(c));
    
    plot(centroid(c,1:L(c)),'color',RGB(c,:),'LineWidth',3)
    hold on
    
    plot(centroidHi(c,1:L(c)),'color',[1 1 1]/2)
    plot(centroidLo(c,1:L(c)),'color',[1 1 1]/2)
    axis tight
    title(['C' num2str(c) ' :' num2str(N(c))])
    set(gca,'FontSize',10,'LineWidth',2)
end

axes(ha(1)); ylabel('Intensity (12 bits)')
axes(ha(6)); ylabel('Intensity (12 bits)')
axes(ha(11)); ylabel('Intensity (12 bits)')
axes(ha(16)); ylabel('Intensity (12 bits)')
axes(ha(21)); ylabel('Intensity (12 bits)')
axes(ha(26)); ylabel('Intensity (12 bits)')

axes(ha(26)); xlabel('Time (ms)')
axes(ha(27)); xlabel('Time (ms)')
axes(ha(28)); xlabel('Time (ms)')
axes(ha(29)); xlabel('Time (ms)')
axes(ha(30)); xlabel('Time (ms)')

figure
[ha,pos]=tight_subplot(5,5,[0.05 0.01],[0.07 0.05],[0.05 0.01]);
for c=31:NoC

    axes(ha(c-30));
    
    plot(centroid(c,1:L(c)),'color',RGB(c,:),'LineWidth',3)
    hold on
    
    plot(centroidHi(c,1:L(c)),'color',[1 1 1]/2)
    plot(centroidLo(c,1:L(c)),'color',[1 1 1]/2)
    axis tight
    title(['C' num2str(c) ' :' num2str(N(c))])
    set(gca,'FontSize',10,'LineWidth',2)
end

axes(ha(1)); ylabel('Intensity (12 bits)')
axes(ha(6)); ylabel('Intensity (12 bits)')
axes(ha(11)); ylabel('Intensity (12 bits)')
axes(ha(16)); ylabel('Intensity (12 bits)')
axes(ha(21)); ylabel('Intensity (12 bits)')

axes(ha(21)); xlabel('Time (ms)')
axes(ha(22)); xlabel('Time (ms)')
axes(ha(23)); xlabel('Time (ms)')
axes(ha(24)); xlabel('Time (ms)')
axes(ha(25)); xlabel('Time (ms)')

