clear

load linkAllLowres PCo obs PnCo
ind=1:1000:140169;
PCo_dilu=PCo(ind,:);

PnCo_dilu=PnCo(ind,:);
obs_dilu=obs(ind);
dist_PCo=[];
dist_PDe=[];
dist_P=[];
dist_PnCo=[];
dist_PnDe=[];
dist_Pn=[];
dist_obs=[];
dist_obsPn=[];

for i=1:length(ind)
    for j=1:length(ind)       
        %Power spectra
        %insect-insect
        [dist_PCo(i,j),lag]=supercorr(PCo_dilu(i,:),PCo_dilu(j,:));
        %noise-noise
        [dist_PnCo(i,j),lag]=supercorr(PnCo_dilu(i,:),PnCo_dilu(j,:));
        %insect-noise
        [dist_PinCo(i,j),lag]=supercorr(PCo_dilu(i,:),PnCo_dilu(j,:));

        %Waveform
        %insect-insect
        [dist_obs(i,j),lag]=supercorr(obs_dilu(i).bsCo',obs_dilu(j).bsCo');
        %noise-noise
        [dist_obsPn(i,j),lag]=supercorr(obs_dilu(i).noiseCo',obs_dilu(j).noiseCo');
        %insect-noise
        [dist_obsPin(i,j),lag]=supercorr(obs_dilu(i).bsCo',obs_dilu(j).noiseCo');
    end
end
%reshape square matrix to column vector
dist_PCo=dist_PCo-diag(diag(dist_PCo));
dist_PCo=squareform(dist_PCo);
dist_PnCo=dist_PnCo-diag(diag(dist_PnCo));
dist_PnCo=squareform(dist_PnCo);
dist_obs=dist_obs-diag(diag(dist_obs));
dist_obs=squareform(dist_obs);
dist_obsPn=dist_obsPn-diag(diag(dist_obsPn));
dist_obsPn=squareform(dist_obsPn);
dist_PinCo=dist_PinCo(:);
dist_obsPin=dist_obsPin(:);

%similarity=1-cosine_distance
simPCo=1-dist_PCo';
simPnCo=1-dist_PnCo';
simPinCo=1-dist_PinCo;

simWCo=1-dist_obs';
simWnCo=1-dist_obsPn';
simWinCo=1-dist_obsPin;

PsimBins=linspace(0,1,31);
WsimBins=linspace(0,1,29);

simBins{1}=PsimBins;
simBins{2}=WsimBins;

HsimP=hist3([simPCo simWCo ],simBins);
HsimPn=hist3([simPnCo simWnCo ],simBins);
HsimPin=hist3([simPinCo simWinCo],simBins);

subplot(1,3,1)
contourf(WsimBins,PsimBins,log10(HsimP))
colormap jet
set(gca,'Xscale','lin','Yscale','lin')
axis([0 1 0 1])
ylabel('Cosine similarity (power spectra)','Fontsize',18,'Fontweight','bold')
xlabel('Cosine similarity (waveform)','Fontsize',18,'Fontweight','bold')

set(gca,'Linewidth',2,'Fontsize',16)
grid on
hold on
plot([0 1],[0 1],'k','LineWidth',2)
legend({'Insect-Insect' 'Diagonal'},'location','southeast')

subplot(1,3,2)
contourf(WsimBins,PsimBins,log10(HsimPn))
colormap jet
set(gca,'Xscale','lin','Yscale','lin')
axis([0 1 0 1])
ylabel('Cosine similarity (power spectra)','Fontsize',18,'Fontweight','bold')
xlabel('Cosine similarity (waveform)','Fontsize',18,'Fontweight','bold')

set(gca,'Linewidth',2,'Fontsize',16)
grid on
hold on
plot([0 1],[0 1],'k','LineWidth',2)
legend({'Noise-noise' 'Diagonal'},'location','southeast')

subplot(1,3,3)
contourf(WsimBins,PsimBins,log10(HsimPin))
set(gca,'Xscale','lin','Yscale','lin')
axis([0 1 0 1])
ylabel('Cosine similarity (power spectra)','Fontsize',18,'Fontweight','bold')
xlabel('Cosine similarity (waveform)','Fontsize',18,'Fontweight','bold')
colormap jet
hc=colorbar('Ticks',[0 1 2 3],'Ticklabels',{'10^0' '10^1' '10^2' '10^3'})
hc.Label.String='Pairs(#)'
hc.Label.String='Pairs(#)'


set(gca,'Linewidth',2,'Fontsize',16)
grid on
hold on
plot([0 1],[0 1],'k','LineWidth',2)
legend({'Insect-noise' 'Diagonal'},'location','southeast')

