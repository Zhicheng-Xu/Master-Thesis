clear all
close all
clc

dfn=dir('F:\thesis\Stensoffa 2020 eval\Moments\*.mat')
ddn='Lowres\'

%Calculate all the .mat files in the folder
for df=1:length(dfn)
    df

    %load([ddn dfn '.mat'])
    load([dfn(1).folder '\' dfn(df).name])

    nBins=40; %resolution
    lowerLim=fs/nBins; %lower boundary
    upperLim=fs/2; %higher boundary

    linFreq=linspace(lowerLim,upperLim,nBins+1);
    %linFreq=(linFreq(1:(end-1))+linFreq(2:end))/2; % bin centers
%     logFreq=logspace(log10(lowerLim),log10(upperLim),nBins+1);
    %logFreq=(logFreq(1:(end-1))+logFreq(2:end))/2; % bin centers

    window=normpdf(0:nBins,nBins/2,nBins/(4*sqrt(2*log(2))));

    inc=[];

    for k=1:length(obs)

        if obs(k).dsamp>nBins
            %Calculate modulation power
            PCo=spectrogram(obs(k).bsCo,window,nBins-1,linFreq,fs);
            PCo=abs(PCo);
            PCo=mean(PCo,2);

            PDe=spectrogram(obs(k).bsDe,window,nBins-1,linFreq,fs);
            PDe=abs(PDe);
            PDe=mean(PDe,2);

            PnCo=spectrogram(obs(k).noiseCo,window,nBins-1,linFreq,fs);
            PnCo=abs(PnCo);
            PnCo=mean(PnCo,2);

            PnDe=spectrogram(obs(k).noiseDe,window,nBins-1,linFreq,fs);
            PnDe=abs(PnDe);
            PnDe=mean(PnDe,2);


            obs(k).PCo=PCo;
            obs(k).PDe=PDe;

            obs(k).PnCo=PnCo;
            obs(k).PnDe=PnDe;


            inc=[inc k];
        else
            obs(k).PCo=[];
            obs(k).PDe=[];
            obs(k).PnCo=[];
            obs(k).PnDe=[];


        end

        clc
        disp([num2str(round(100*k/length(obs))) '% done.'])

    end
    obs=obs(inc);
    
    clear PCo PDe PnCo PnDe
    %Normalization
    for k=1:length(obs)
    PCo(k,:)=obs(k).PCo'/sum(obs(k).PCo'+obs(k).PDe');
    PDe(k,:)=obs(k).PDe'/sum(obs(k).PCo'+obs(k).PDe');
    PnCo(k,:)=obs(k).PnCo'/sum(obs(k).PnCo'+obs(k).PnDe');
    PnDe(k,:)=obs(k).PnDe'/sum(obs(k).PnCo'+obs(k).PnDe');
    end

    save([ddn dfn(df).name],'-v7.3')
end