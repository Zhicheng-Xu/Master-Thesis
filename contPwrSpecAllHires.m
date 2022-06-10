clear all
close all
clc

dfn=dir('F:\thesis\Stensoffa 2020 eval\Moments\*.mat')
ddn='HiresLog\'

fs=2000;
nBins=80;
lowerLim=fs/nBins;
upperLim=fs/2;

% linFreq=linspace(lowerLim,upperLim,nBins+1);
%linFreq=(linFreq(1:(end-1))+linFreq(2:end))/2; % bin centers
logFreq=logspace(log10(lowerLim),log10(upperLim),nBins+1);
%logFreq=(logFreq(1:(end-1))+logFreq(2:end))/2; % bin centers

window=normpdf(0:nBins,nBins/2,nBins/(4*sqrt(2*log(2))));



for f=7:7
    
    
load([dfn(f).folder '\' dfn(f).name])


inc=[];

for k=1:length(obs)
    
    if obs(k).dsamp>nBins
    
        PCo=pwelch(obs(k).bsCo,window,nBins-1,logFreq,fs,'power');      
        PDe=pwelch(obs(k).bsDe,window,nBins-1,logFreq,fs,'power');
     
        PnCo=pwelch(obs(k).noiseCo,window,nBins-1,logFreq,fs,'power');      
        PnDe=pwelch(obs(k).noiseDe,window,nBins-1,logFreq,fs,'power');
  
%         PsCo=pwelch(randn(obs(k).dsamp,1)+1,window,nBins-1,logFreq,fs,'power');
%         PsDe=pwelch(randn(obs(k).dsamp,1)+1,window,nBins-1,logFreq,fs,'power');
%         
        obs(k).PCo=PCo;
        obs(k).PDe=PDe;        
        obs(k).PnCo=PnCo;
        obs(k).PnDe=PnDe;
        
%         obs(k).PsCo=PsCo;
%         obs(k).PsDe=PsDe;
        
        inc=[inc k];
    else
        obs(k).PCo=[];
        obs(k).PDe=[];
        obs(k).PnCo=[];
        obs(k).PnDe=[];
        
%         obs(k).PsCo=[];
%         obs(k).PsDe=[];
%         
       
    end
    
    clc
    disp([num2str(round(100*k/length(obs))) '% done.'])
    
end
obs=obs(inc);

clear PCo PDe PnCo PnDe %PsCo PsDe
for k=1:length(obs)
PCo(k,:)=obs(k).PCo'/sum(obs(k).PCo'+obs(k).PDe');
PDe(k,:)=obs(k).PDe'/sum(obs(k).PCo'+obs(k).PDe');
PnCo(k,:)=obs(k).PnCo'/sum(obs(k).PnCo'+obs(k).PnDe');
PnDe(k,:)=obs(k).PnDe'/sum(obs(k).PnCo'+obs(k).PnDe');

% PsCo(k,:)=obs(k).PsCo'/sum(obs(k).PsCo'+obs(k).PsDe');
% PsDe(k,:)=obs(k).PsDe'/sum(obs(k).PsCo'+obs(k).PsDe');


end

% save([dfn(f).folder '\' dfn(f).name(1:(end-4)) 'Pwr.mat'],'-v7.3')
save([ddn dfn(f).name],'-v7.3')
end
