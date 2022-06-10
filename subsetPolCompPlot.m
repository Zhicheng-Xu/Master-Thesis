% 
% close all
% clear all
% 
% load linkAllLowsubsetSNR Z Zn ZCo ZnCo ZDe ZnDe ZUn ZnUn


SNRBoth=flipud(Z(:,3))./flipud(Zn(:,3));
SNRCo=flipud(ZCo(:,3))%./flipud(ZnCo(:,3));
SNRDe=flipud(ZDe(:,3))%./flipud(ZnDe(:,3));
SNRUn=flipud(ZUn(:,3))%./flipud(ZnUn(:,3));


n=(1:length(Z))';

figure
semilogx(SNRCo)
hold on
semilogx(SNRDe)
semilogx(SNRBoth)
semilogx(SNRUn)


%semilogx([1 length(Z)],[2 2],'k')

lbl={'Copol' 'Depol' 'Both' 'Unpol'};
legend(lbl)
xlabel('Number of pairs')
ylabel('Signal-to-noise Ratio')

nCo=find(SNRCo>2);
nCo(end)
nDe=find(SNRDe>2);
nDe(end)
nBoth=find(SNRBoth>2);
nBoth(end)
nUn=find(SNRUn>2);
nUn(end)


LowPass = fittype('a/(1+(log(n)/log(b))^c)+d','coefficients',{'a' 'b' 'c' 'd'} ,'independent','n')

W=1./sqrt(n);
[BothFit BothGoF]=fit(n,SNRBoth,LowPass,'StartPoint', [max(SNRBoth) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
[CoFit CoGoF]=fit(n,SNRCo,LowPass,'StartPoint', [max(SNRCo) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
[DeFit DeGoF]=fit(n,SNRDe,LowPass,'StartPoint', [max(SNRDe) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
[UnFit UnGoF]=fit(n,SNRUn,LowPass,'StartPoint', [max(SNRUn) 20 5 1],'Weight',W,'Lower',[1 1 1 1])


species(1)=CoFit.b;
species(2)=DeFit.b;
species(3)=BothFit.b;
species(4)=UnFit.b;

CI(:,:,1)=confint(CoFit);
CI(:,:,2)=confint(DeFit);
CI(:,:,3)=confint(BothFit);
CI(:,:,4)=confint(UnFit);

CI=permute(CI,[3 1 2]);


figure
errorbar(1:length(lbl),species,CI(:,1,2)'-species,CI(:,1,2)'-species,'o');
axis([0 length(lbl)+1 0 max(species)*1.2])

set(gca,'XTick',1:length(lbl),'XTickLabel',lbl)
title(['Low resolution \Delta80Hz, \Deltat>50 ms, N: ' num2str(length(ZCo))])
ylabel('Half Number of Clusters')
grid on





