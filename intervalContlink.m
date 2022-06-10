clear 
close all
clc



load 14SunJunStatsMomPwrLow obs fn linFreq PCo PDe PnCo PnDe

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

%Divide the day into four intervals
t=[obs.t];
dayt=(hour(t)+minute(t)/60);
ind_morning=find((dayt>2.55)&(dayt<=8.17));
ind_daytime=find((dayt>8.17)&(dayt<=19.40));
ind_evening=find((dayt>19.40)&(dayt<24));
ind_nighttime=find((dayt>=0)&(dayt<=2.55));

P_morning=P(ind_morning,:);
P_daytime=P(ind_daytime,:);
P_evening=P(ind_evening,:);
P_nighttime=P(ind_nighttime,:);
Pn_morning=Pn(ind_morning,:);
Pn_daytime=Pn(ind_daytime,:);
Pn_evening=Pn(ind_evening,:);
Pn_nighttime=Pn(ind_nighttime,:);

PCo_morning=PCo(ind_morning,:);
PCo_daytime=PCo(ind_daytime,:);
PCo_evening=PCo(ind_evening,:);
PCo_nighttime=PCo(ind_nighttime,:);
PnCo_morning=PnCo(ind_morning,:);
PnCo_daytime=PnCo(ind_daytime,:);
PnCo_evening=PnCo(ind_evening,:);
PnCo_nighttime=PnCo(ind_nighttime,:);


PDe_morning=PDe(ind_morning,:);
PDe_daytime=PDe(ind_daytime,:);
PDe_evening=PDe(ind_evening,:);
PDe_nighttime=PDe(ind_nighttime,:);
PnDe_morning=PnDe(ind_morning,:);
PnDe_daytime=PnDe(ind_daytime,:);
PnDe_evening=PnDe(ind_evening,:);
PnDe_nighttime=PnDe(ind_nighttime,:);


PUn_morning=PUn(ind_morning,:);
PUn_daytime=PUn(ind_daytime,:);
PUn_evening=PUn(ind_evening,:);
PUn_nighttime=PUn(ind_nighttime,:);
PnUn_morning=PnUn(ind_morning,:);
PnUn_daytime=PnUn(ind_daytime,:);
PnUn_evening=PnUn(ind_evening,:);
PnUn_nighttime=PnUn(ind_nighttime,:);

disp("Start")


Z_morning=linkage(log(P_morning),'ward','euclidean','savememory','on');
Z_daytime=linkage(log(P_daytime),'ward','euclidean','savememory','on');
Z_evening=linkage(log(P_evening),'ward','euclidean','savememory','on');
Z_nighttime=linkage(log(P_nighttime),'ward','euclidean','savememory','on');
Zn_morning=linkage(log(Pn_morning),'ward','euclidean','savememory','on');
Zn_daytime=linkage(log(Pn_daytime),'ward','euclidean','savememory','on');
Zn_evening=linkage(log(Pn_evening),'ward','euclidean','savememory','on');
Zn_nighttime=linkage(log(Pn_nighttime),'ward','euclidean','savememory','on');
disp("Both")

ZCo_morning=linkage(log(PCo_morning),'ward','euclidean','savememory','on');
ZCo_daytime=linkage(log(PCo_daytime),'ward','euclidean','savememory','on');
ZCo_evening=linkage(log(PCo_evening),'ward','euclidean','savememory','on');
ZCo_nighttime=linkage(log(PCo_nighttime),'ward','euclidean','savememory','on');
ZnCo_morning=linkage(log(PnCo_morning),'ward','euclidean','savememory','on');
ZnCo_daytime=linkage(log(PnCo_daytime),'ward','euclidean','savememory','on');
ZnCo_evening=linkage(log(PnCo_evening),'ward','euclidean','savememory','on');
ZnCo_nighttime=linkage(log(PnCo_nighttime),'ward','euclidean','savememory','on');
disp("Co")

ZDe_morning=linkage(log(PDe_morning),'ward','euclidean','savememory','on');
ZDe_daytime=linkage(log(PDe_daytime),'ward','euclidean','savememory','on');
ZDe_evening=linkage(log(PDe_evening),'ward','euclidean','savememory','on');
ZDe_nighttime=linkage(log(PDe_nighttime),'ward','euclidean','savememory','on');
ZnDe_morning=linkage(log(PnDe_morning),'ward','euclidean','savememory','on');
ZnDe_daytime=linkage(log(PnDe_daytime),'ward','euclidean','savememory','on');
ZnDe_evening=linkage(log(PnDe_evening),'ward','euclidean','savememory','on');
ZnDe_nighttime=linkage(log(PnDe_nighttime),'ward','euclidean','savememory','on');
disp("De")

ZUn_morning=linkage(log(PUn_morning),'ward','euclidean','savememory','on');
ZUn_daytime=linkage(log(PUn_daytime),'ward','euclidean','savememory','on');
ZUn_evening=linkage(log(PUn_evening),'ward','euclidean','savememory','on');
ZUn_nighttime=linkage(log(PUn_nighttime),'ward','euclidean','savememory','on');
ZnUn_morning=linkage(log(PnUn_morning),'ward','euclidean','savememory','on');
ZnUn_daytime=linkage(log(PnUn_daytime),'ward','euclidean','savememory','on');
ZnUn_evening=linkage(log(PnUn_evening),'ward','euclidean','savememory','on');
ZnUn_nighttime=linkage(log(PnUn_nighttime),'ward','euclidean','savememory','on');
disp("Un")


morningCo=flipud(ZCo_morning(:,3))./flipud(ZnCo_morning(:,3));
daytimeCo=flipud(ZCo_daytime(:,3))./flipud(ZnCo_daytime(:,3));
eveningCo=flipud(ZCo_evening(:,3))./flipud(ZnCo_evening(:,3));
nighttimeCo=flipud(ZCo_nighttime(:,3))./flipud(ZnCo_nighttime(:,3));


morningDe=flipud(ZDe_morning(:,3))./flipud(ZnDe_morning(:,3));
daytimeDe=flipud(ZDe_daytime(:,3))./flipud(ZnDe_daytime(:,3));
eveningDe=flipud(ZDe_evening(:,3))./flipud(ZnDe_evening(:,3));
nighttimeDe=flipud(ZDe_nighttime(:,3))./flipud(ZnDe_nighttime(:,3));


morningUn=flipud(ZUn_morning(:,3))./flipud(ZnUn_morning(:,3));
daytimeUn=flipud(ZUn_daytime(:,3))./flipud(ZnUn_daytime(:,3));
eveningUn=flipud(ZUn_evening(:,3))./flipud(ZnUn_evening(:,3));
nighttimeUn=flipud(ZUn_nighttime(:,3))./flipud(ZnUn_nighttime(:,3));


morning=flipud(Z_morning(:,3))./flipud(Zn_morning(:,3));
daytime=flipud(Z_daytime(:,3))./flipud(Zn_daytime(:,3));
evening=flipud(Z_evening(:,3))./flipud(Zn_evening(:,3));
nighttime=flipud(Z_nighttime(:,3))./flipud(Zn_nighttime(:,3));

LowPass = fittype('a/(1+(log(n)/log(b))^c)+d','coefficients',{'a' 'b' 'c' 'd'} ,'independent','n')

n=(1:length(Z_morning))';
W=1./sqrt(n);
[BothFit BothGoF]=fit(n,morning,LowPass,'StartPoint', [max(morning) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
[CoFit CoGoF]=fit(n,morningCo,LowPass,'StartPoint', [max(morningCo) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
[DeFit DeGoF]=fit(n,morningDe,LowPass,'StartPoint', [max(morningDe) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
[UnFit UnGoF]=fit(n,morningUn,LowPass,'StartPoint', [max(morningUn) 20 5 1],'Weight',W,'Lower',[1 1 1 1])

n=(1:length(Z_daytime))';
W=1./sqrt(n);
[BothFit BothGoF]=fit(n,daytime,LowPass,'StartPoint', [max(daytime) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
[CoFit CoGoF]=fit(n,daytimeCo,LowPass,'StartPoint', [max(daytimeCo) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
[DeFit DeGoF]=fit(n,daytimeDe,LowPass,'StartPoint', [max(daytimeDe) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
[UnFit UnGoF]=fit(n,daytimeUn,LowPass,'StartPoint', [max(daytimeUn) 20 5 1],'Weight',W,'Lower',[1 1 1 1])

n=(1:length(Z_evening))';
W=1./sqrt(n);
[BothFit BothGoF]=fit(n,evening,LowPass,'StartPoint', [max(evening) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
[CoFit CoGoF]=fit(n,eveningCo,LowPass,'StartPoint', [max(eveningCo) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
[DeFit DeGoF]=fit(n,eveningDe,LowPass,'StartPoint', [max(eveningDe) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
[UnFit UnGoF]=fit(n,eveningUn,LowPass,'StartPoint', [max(eveningUn) 20 5 1],'Weight',W,'Lower',[1 1 1 1])

n=(1:length(Z_nighttime))';
W=1./sqrt(n);
[BothFit BothGoF]=fit(n,nighttime,LowPass,'StartPoint', [max(nighttime) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
[CoFit CoGoF]=fit(n,nighttimeCo,LowPass,'StartPoint', [max(nighttimeCo) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
[DeFit DeGoF]=fit(n,nighttimeDe,LowPass,'StartPoint', [max(nighttimeDe) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
[UnFit UnGoF]=fit(n,nighttimeUn,LowPass,'StartPoint', [max(nighttimeUn) 20 5 1],'Weight',W,'Lower',[1 1 1 1])


save intervalLinkLowres



