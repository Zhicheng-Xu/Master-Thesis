clear

load linkAllLowres Z ZCo ZDe ZUn Zn ZnCo ZnDe ZnUn

figure
loglog(flipud(ZCo(:,3)),'LineWidth',2)
hold on
loglog(flipud(ZDe(:,3)),'LineWidth',2)
loglog(flipud(Z(:,3)),'LineWidth',2)
loglog(flipud(ZUn(:,3)),'LineWidth',2)
loglog(flipud(ZnCo(:,3)),'LineWidth',2)
loglog(flipud(ZnDe(:,3)),'LineWidth',2)
loglog(flipud(Zn(:,3)),'LineWidth',2)
loglog(flipud(ZnUn(:,3)),'LineWidth',2)
set(gca,'FontSize',20,'LineWidth',2)
legend({'Copol','Depol','Both','Unpol','NoiseCopol','NoiseDepol','NoiseBoth','NoiseUnpol'})


curveCopol=flipud(ZCo(:,3))./flipud(ZnCo(:,3));

curveDepol=flipud(ZDe(:,3))./flipud(ZnDe(:,3));

curveUnpol=flipud(ZUn(:,3))./flipud(ZnUn(:,3));

curveBoth=flipud(Z(:,3))./flipud(Zn(:,3));

figure
loglog(curveCopol,'LineWidth',2)
hold on
loglog(curveDepol,'LineWidth',2)
loglog(curveBoth,'LineWidth',2)
loglog(curveUnpol,'LineWidth',2)
set(gca,'FontSize',20,'LineWidth',2)
legend({'Copol','Depol','Both','Unpol'})
% save('curves.mat','curveCopol','curveDepol','curveUnpol','curveLowsubset','curveBoth')