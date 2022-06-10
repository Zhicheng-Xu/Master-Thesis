clear all
close all
clc

dfn='sessionStatsSun14Jun'

load([dfn '.mat'])


fs=2000;
nBins=40;
lowerLim=fs/nBins;
upperLim=fs/2;

linFreq=linspace(lowerLim,upperLim,nBins+1);
%linFreq=(linFreq(1:(end-1))+linFreq(2:end))/2; % bin centers
%logFreq=logspace(log10(lowerLim),log10(upperLim),nBins+1);
%logFreq=(logFreq(1:(end-1))+logFreq(2:end))/2; % bin centers

window=normpdf(0:nBins,nBins/2,nBins/(4*sqrt(2*log(2))));

inc=[];
t=[];

for k=1:length(obs)
    
   
    if length(obs(k).bsCo)>nBins
        obs(k).bsTS=obs(k).bsCo+obs(k).bsDe;
        obs(k).noiseTS=obs(k).noiseCo+obs(k).noiseDe;
    
        [sObsLinCo,fObs,tObs]=spectrogram(obs(k).bsCo,window,round(0.8*nBins),linFreq,fs);
        sObsLinCo=abs(sObsLinCo);
        sObsLinCo=mean(sObsLinCo,2);

        [sObsLogCo,fObs,tObs]=spectrogram(obs(k).bsCo,window,round(0.8*nBins),logFreq,fs);
        sObsLogCo=abs(sObsLogCo);
        sObsLogCo=mean(sObsLogCo,2);

        [sNoiseLinCo,fNoise,tNoise]=spectrogram(obs(k).noiseCo,window,round(0.8*nBins),linFreq,fs);
        sNoiseLinCo=abs(sNoiseLinCo);
        sNoiseLinCo=mean(sNoiseLinCo,2);

        [sNoiseLogCo,fNoise,tNoise]=spectrogram(obs(k).noiseCo,window,round(0.8*nBins),logFreq,fs);
        sNoiseLogCo=abs(sNoiseLogCo);
        sNoiseLogCo=mean(sNoiseLogCo,2);

        obs(k).bsSpecLinCo=sObsLinCo;
        obs(k).bsSpecLogCo=sObsLogCo;
        obs(k).noiseSpecLinCo=sNoiseLinCo;
        obs(k).noiseSpecLogCo=sNoiseLogCo;
        
        
        
        
        
        
        
        [sObsLinDe,fObs,tObs]=spectrogram(obs(k).bsDe,window,round(0.8*nBins),linFreq,fs);
        sObsLinDe=abs(sObsLinDe);
        sObsLinDe=mean(sObsLinDe,2);

        [sObsLogDe,fObs,tObs]=spectrogram(obs(k).bsDe,window,round(0.8*nBins),logFreq,fs);
        sObsLogDe=abs(sObsLogDe);
        sObsLogDe=mean(sObsLogDe,2);

        [sNoiseLinDe,fNoise,tNoise]=spectrogram(obs(k).noiseDe,window,round(0.8*nBins),linFreq,fs);
        sNoiseLinDe=abs(sNoiseLinDe);
        sNoiseLinDe=mean(sNoiseLinDe,2);

        [sNoiseLogDe,fNoise,tNoise]=spectrogram(obs(k).noiseDe,window,round(0.8*nBins),logFreq,fs);
        sNoiseLogDe=abs(sNoiseLogDe);
        sNoiseLogDe=mean(sNoiseLogDe,2);

        obs(k).bsSpecLinDe=sObsLinDe;
        obs(k).bsSpecLogDe=sObsLogDe;
        obs(k).noiseSpecLinDe=sNoiseLinDe;
        obs(k).noiseSpecLogDe=sNoiseLogDe;
        
        
        
        inc=[inc k];
        t=[t obs(k).t];
    else
        obs(k).bsSpecLinCo=[];
        obs(k).bsSpecLogCo=[];
        obs(k).noiseSpecLinCo=[];
        obs(k).noiseSpecLogCo=[];
        
        obs(k).bsSpecLinDe=[];
        obs(k).bsSpecLogDe=[];
        obs(k).noiseSpecLinDe=[];
        obs(k).noiseSpecLogDe=[];
        
    end
    
    clc
    disp([num2str(round(100*k/length(obs))) '% done.'])
    
end
obs=obs(inc);


save([dfn 'ContSpec.mat'],'-v7.3')
