clear

load MergedPwr obs
t=[obs.t];
inc=find((t>datenum(2020,6,10,0,0,0)).*(t<datenum(2020,6,11,0,0,0)));
fs=2000;
t=t(inc);
obs1=obs(inc);

tbin=linspace(0,24,48);
dayt=(hour(t)+minute(t)/60);

ind=find([obs1.dt]*fs>40);
figure
subplot(2,3,1)
yyaxis left
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','b')

ind=find([obs1.dt]*fs>80);
hold on
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','r')

ind=find([obs1.dt]*fs>160);
%figure
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','y')
axis tight
ylim([0 0.4])
set(gca,'FontSize',20,'LineWidth',2)


t=[obs.t];
inc=find((t>datenum(2020,6,11,0,0,0)).*(t<datenum(2020,6,12,0,0,0)));
fs=2000;
t=t(inc);
obs1=obs(inc);

tbin=linspace(0,24,48);
dayt=(hour(t)+minute(t)/60);

ind=find([obs1.dt]*fs>40);
subplot(2,3,2)
yyaxis left
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','b')

ind=find([obs1.dt]*fs>80);
hold on
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','r')

ind=find([obs1.dt]*fs>160);
%figure
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','y')
axis tight
ylim([0 0.4])
set(gca,'FontSize',20,'LineWidth',2)

t=[obs.t];
inc=find((t>datenum(2020,6,12,0,0,0)).*(t<datenum(2020,6,13,0,0,0)));
fs=2000;
t=t(inc);
obs1=obs(inc);

tbin=linspace(0,24,48);
dayt=(hour(t)+minute(t)/60);

ind=find([obs1.dt]*fs>40);
subplot(2,3,3)
yyaxis left
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','b')

ind=find([obs1.dt]*fs>80);
hold on
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','r')

ind=find([obs1.dt]*fs>160);
%figure
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','y')
axis tight
ylim([0 0.4])
set(gca,'FontSize',20,'LineWidth',2)

t=[obs.t];
inc=find((t>datenum(2020,6,13,0,0,0)).*(t<datenum(2020,6,14,0,0,0)));
fs=2000;
t=t(inc);
obs1=obs(inc);

tbin=linspace(0,24,48);
dayt=(hour(t)+minute(t)/60);

ind=find([obs1.dt]*fs>40);
subplot(2,3,4)
yyaxis left
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','b')

ind=find([obs1.dt]*fs>80);
hold on
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','r')

ind=find([obs1.dt]*fs>160);
%figure
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','y')
axis tight
ylim([0 0.4])
set(gca,'FontSize',20,'LineWidth',2)


t=[obs.t];
inc=find((t>datenum(2020,6,14,0,0,0)).*(t<datenum(2020,6,15,0,0,0)));
fs=2000;
t=t(inc);
obs1=obs(inc);

tbin=linspace(0,24,48);
dayt=(hour(t)+minute(t)/60);

ind=find([obs1.dt]*fs>40);
subplot(2,3,5)
yyaxis left
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','b')

ind=find([obs1.dt]*fs>80);
hold on
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','r')

ind=find([obs1.dt]*fs>160);
%figure
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','y')
axis tight
ylim([0 0.4])
set(gca,'FontSize',20,'LineWidth',2)


t=[obs.t];
inc=find((t>datenum(2020,6,15,0,0,0)).*(t<datenum(2020,6,16,0,0,0)));
fs=2000;
t=t(inc);
obs1=obs(inc);

tbin=linspace(0,24,48);
dayt=(hour(t)+minute(t)/60);

ind=find([obs1.dt]*fs>40);
subplot(2,3,6)
yyaxis left
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','b')

ind=find([obs1.dt]*fs>80);
hold on
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','r')

ind=find([obs1.dt]*fs>160);
%figure
plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','y')
axis tight
ylim([0 0.4])
set(gca,'FontSize',20,'LineWidth',2)


subplot(2,3,1)
yyaxis right
ylim([5 26])
ind=find(VarName1==datetime(2020,6,10));
ind=[ind;ind(24)+1];
t1=0:24;
temp1=VarName3(ind);
plot(t1,temp1,'LineWidth',2)


% subplot(2,3,2)
% yyaxis right
% ylim([5 26])
% ind=find(VarName1==datetime(2020,6,11));
% t1=time(ind)*24;
% temp1=Temp(ind);
% plot(t1,temp1,'LineWidth',2)

subplot(2,3,2)
yyaxis right
ylim([5 26])
ind=find(VarName1==datetime(2020,6,11));
ind=[ind;ind(24)+1];
t1=0:24;
temp1=VarName3(ind);
plot(t1,temp1,'LineWidth',2)

subplot(2,3,3)
yyaxis right
ylim([5 26])
ind=find(VarName1==datetime(2020,6,12));
ind=[ind;ind(24)+1];
t1=0:24;
temp1=VarName3(ind);
plot(t1,temp1,'LineWidth',2)

subplot(2,3,4)
yyaxis right
ylim([5 26])
ind=find(VarName1==datetime(2020,6,13));
ind=[ind;ind(24)+1];
t1=0:24;
temp1=VarName3(ind);
plot(t1,temp1,'LineWidth',2)

subplot(2,3,5)
yyaxis right
ylim([5 26])
ind=find(VarName1==datetime(2020,6,14));
ind=[ind;ind(24)+1];
t1=0:24;
temp1=VarName3(ind);
plot(t1,temp1,'LineWidth',2)

subplot(2,3,6)
yyaxis right
ylim([5 26])
ind=find(VarName1==datetime(2020,6,15));
ind=[ind;ind(24)+1];
t1=0:24;
temp1=VarName3(ind);
plot(t1,temp1,'LineWidth',2)