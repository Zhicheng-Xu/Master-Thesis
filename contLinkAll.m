clear all
close all
clc

load 14SunJunStatsMomPwrLow obs fn linFreq PCo PDe PnCo PnDe

%find subset of longer transit time
ind=find([obs.dt]*2000>80);
obs=obs(ind);
PCo=PCo(ind,:);
PDe=PDe(ind,:);
PnCo=PnCo(ind,:);
PnDe=PnDe(ind,:);

finc=2:(length(linFreq)-1);

PCo=PCo(:,finc);
PnCo=PnCo(:,finc);
linFreq=linFreq(finc);
PDe=PDe(:,finc);
PnDe=PnDe(:,finc);

%Both: concatenation
P=[PCo PDe];
Pn=[PnCo PnDe];

%Unpol: sum
PUn=[PCo+PDe];
PnUn=[PnCo+PnDe];


ZCo=linkage(log(PCo),'ward','euclidean','savememory','on');
ZnCo=linkage(log(PnCo),'ward','euclidean','savememory','on');
disp('co')
ZDe=linkage(log(PDe),'ward','euclidean','savememory','on');
ZnDe=linkage(log(PnDe),'ward','euclidean','savememory','on');
disp('de')
Z=linkage(log(P),'ward','euclidean','savememory','on');
Zn=linkage(log(Pn),'ward','euclidean','savememory','on');
disp('both')
ZUn=linkage(log(PUn),'ward','euclidean','savememory','on');
ZnUn=linkage(log(PnUn),'ward','euclidean','savememory','on');
disp('un')


save linkAllLowsubsetSNR  '-v7.3'






