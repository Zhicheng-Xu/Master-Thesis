## BINP52 Master's degree project 60 credits
#### Insect Diversity Estimation in Entomological Lidar ####
This thesis work aims to develop a method to estimate insect diversity of the data recorded from the Stensoffa campaign. Hierarchical clustering was applied to the data set to group the observations based on both waveforms recorded by the lidar or modulation power spectra obtained from waveforms. To estimate the number of clusters, we proposed an analytical model to fit an excess linkage based on the linkages of signals and noises. We also compared this method to the L method that found the knee point of the curve. To investigate the influence of the instrument complexity, we evaluated the benefit of polarization band features of the instrument to improve specificity. Furthermore, we applied the analytical model to different time intervals to investigate the relationship between the number of observations and the estimated number of clusters. In addition, we developed an approach to measure pairwise similarity for the waveforms and compared this to the phase insensitive modulation power spectra.  

#### MATLAB Implement
This work was conducted with MATLAB Version 9.8 and Statistics and Machine Learning Toolbox Version 11.7 (R2020a).  

Run "ShannonIndex.m" to generate examples of Shannon index.  

    clear all
    close all

    X = rand(200000,3);
    Z = linkage(X,'ward');

    % 10 clusters in total
    NoC=10;

    T(1:100000)=1;
    T(100001:150000)=2;
    T(150001:175000)=3;
    T(175001:185000)=4;
    T(185001:190000)=5;
    T(190001:194000)=6;
    T(194001:197000)=7;
    T(197001:198000)=8;
    T(198001:199500)=9;
    T(199501:200000)=10;
    RGB=colormap('jet');
    RGB=interp1(1:length(RGB),RGB,(1:NoC)*length(RGB)/NoC);

    % Calculate Shannon index
    SI=0;

    for c=1:NoC;
        ind=find(T==c);

        L=length(ind); % abundance of p

        p=L/length(T); % total abundance
        SI=SI-p*log(p);

        N(c)=length(ind);
    end



    figure
    subplot(1,2,1)
    [h IDX pla]=dendrogram(Z,NoC);%
    set(h,'LineWidth',2,'Color','k')

    clusterNo='C'+string(1:NoC);


    ax=axis;
    set(gca,'XTickLabel',clusterNo,'LineWidth',2,'FontWeight','bold')
    ylabel('Spectral distance','FontWeight','bold','FontSize',16)
    box on
    hold on
    for c=1:NoC;
        ms=0.2*sqrt(N(c));
        plot(c,ax(3)+0.2,'o','Markersize',ms,'MarkerEdgeColor','none','MarkerFaceColor',RGB(c,:));
    end

    T(1:20000)=1;
    T(20001:40000)=2;
    T(40001:60000)=3;
    T(60001:80000)=4;
    T(80001:100000)=5;
    T(100001:120000)=6;
    T(120001:140000)=7;
    T(140001:160000)=8;
    T(160001:180000)=9;
    T(180001:200000)=10;
    RGB=colormap('jet');
    RGB=interp1(1:length(RGB),RGB,(1:NoC)*length(RGB)/NoC);

    SI=0;

    for c=1:NoC;
        ind=find(T==c);

        L=length(ind);

        p=L/length(T);
        SI=SI-p*log(p);

        N(c)=length(ind);


    end


    subplot(1,2,2)
    [h IDX pla]=dendrogram(Z,NoC);%
    set(h,'LineWidth',2,'Color','k')

    clusterNo='C'+string(1:NoC);


    ax=axis;
    set(gca,'XTickLabel',clusterNo,'LineWidth',2,'FontWeight','bold')
    ylabel('Spectral distance','FontWeight','bold','FontSize',16)
    box on
    hold on
    for c=1:NoC;
        ms=0.2*sqrt(N(c));
        plot(c,ax(3)+0.2,'o','Markersize',ms,'MarkerEdgeColor','none','MarkerFaceColor',RGB(c,:));
    end

The insect observations were saved in a .mat file. The variable 'observation' is a structure array that includes the information of recorded insects, such as transit time, waveform, recorded time, instrument noise, etc. The most important function is 'spectrogram' which converts the waveforms to modulation power. Run "contPwrSpecAllLores.m" to calculate power spectra for low resolution. (similar for high resolution and subset of low resolution)  

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

After the power spectra were calculated, Run "contLinkAll.m" to calculate the linkage between the observations based on their power spectra. The linkage showed the distances between the observations and helped to hierarchical clustering.  

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

Run "loresPolCompPlot.m" to apply the analytical model to the excess linkages for low resolution. (similar for high resolution and subset of low resolution)  


    close all
    clear all

    load linkAllLowres Z Zn ZCo ZnCo ZDe ZnDe ZUn ZnUn

    % Calculate excess linkage
    SNRBoth=flipud(Z(:,3))./flipud(Zn(:,3));
    SNRCo=flipud(ZCo(:,3))./flipud(ZnCo(:,3));
    SNRDe=flipud(ZDe(:,3))./flipud(ZnDe(:,3));
    SNRUn=flipud(ZUn(:,3))./flipud(ZnUn(:,3));


    n=(1:length(Z))';

    figure
    semilogx(SNRCo)
    hold on
    semilogx(SNRDe)
    semilogx(SNRBoth)
    semilogx(SNRUn)


    semilogx([1 length(Z)],[2 2],'k')


    % Build analytical model
    LowPass = fittype('a/(1+(log(n)/log(b))^c)+d','coefficients',{'a' 'b' 'c' 'd'} ,'independent','n')

    W=1./sqrt(n);
    [BothFit BothGoF]=fit(n,SNRBoth,LowPass,'StartPoint', [max(SNRBoth) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
    [CoFit CoGoF]=fit(n,SNRCo,LowPass,'StartPoint', [max(SNRCo) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
    [DeFit DeGoF]=fit(n,SNRDe,LowPass,'StartPoint', [max(SNRDe) 20 5 1],'Weight',W,'Lower',[1 1 1 1])
    [UnFit UnGoF]=fit(n,SNRUn,LowPass,'StartPoint', [max(SNRUn) 20 5 1],'Weight',W,'Lower',[1 1 1 1])


    lbl={'Copol' 'Depol' 'Both' 'Unpol'};

    legend(lbl)
    xlabel('Number of pairs')
    ylabel('Signal-to-noise Ratio')

    % plot confidence interval
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
    title(['Low resolution \Delta80Hz, \Deltat>25 ms, N: ' num2str(length(ZCo))])
    ylabel('Half Number of Clusters')
    grid on


Run "findKneePoint.m" to apply the L method to find the "knee point" of the curve.  

    clear
    close all
    load linkAllHighSNR ZCo ZDe Z ZUn

    figure
    semilogx(flipud(ZCo(:,3)))
    hold on
    semilogx(flipud(ZDe(:,3)))
    semilogx(flipud(Z(:,3)))
    semilogx(flipud(ZUn(:,3)))

    figure
    curveCo=semilogx(flipud(ZCo(:,3)));
    hold on
    % Connect the first and last point as a reference line
    plot([curveCo.XData(1),curveCo.XData(end)],[curveCo.YData(1),curveCo.YData(end)])
    % Calculate the distance from each point to the line
    for x=1:length(curveCo.XData)
        distance(x)=point_to_line(log(curveCo.XData(x)),curveCo.YData(x),log(curveCo.XData(1)),curveCo.YData(1),log(curveCo.XData(end)),curveCo.YData(end));
    end
    % Find the maximum distance
    [maxDist, idx] = max(distance);
    idx


    figure
    curveDe=semilogx(flipud(ZDe(:,3)));
    hold on
    plot([curveDe.XData(1),curveDe.XData(end)],[curveDe.YData(1),curveDe.YData(end)])
    for x=1:length(curveDe.XData)
        distance(x)=point_to_line(log(curveDe.XData(x)),curveDe.YData(x),log(curveDe.XData(1)),curveDe.YData(1),log(curveDe.XData(end)),curveDe.YData(end));
    end
    [maxDist, idx] = max(distance);
    idx

    figure
    curve=semilogx(flipud(Z(:,3)));
    hold on
    plot([curve.XData(1),curve.XData(end)],[curve.YData(1),curve.YData(end)])
    for x=1:length(curve.XData)
        distance(x)=point_to_line(log(curve.XData(x)),curve.YData(x),log(curve.XData(1)),curve.YData(1),log(curve.XData(end)),curve.YData(end));
    end
    [maxDist, idx] = max(distance);
    idx

    figure
    curveUn=semilogx(flipud(ZUn(:,3)));
    hold on
    plot([curveUn.XData(1),curveUn.XData(end)],[curveUn.YData(1),curveUn.YData(end)])
    for x=1:length(curveUn.XData)
        distance(x)=point_to_line(log(curveUn.XData(x)),curveUn.YData(x),log(curveUn.XData(1)),curveUn.YData(1),log(curveUn.XData(end)),curveUn.YData(end));
    end
    [maxDist, idx] = max(distance);
    idx

The function "point_to_line" used above:

    function dist=point_to_line(x3, y3, x1, y1, x2, y2)
        a=(y2-y1)/(x2-x1);
        b=-1;
        c=y1-a*x1;
        dist=abs(a*x3+b*y3+c)/sqrt(a^2+b^2);
    end

Run "intervalContlink.m" to calculate linkages for the four intervals in the day.

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

Run "timeCompare.m" to plot insect diurnal activity patterns with temperature.

    clear

    load MergedPwr obs
    t=[obs.t];
    inc=find((t>datenum(2020,6,10,0,0,0)).*(t<datenum(2020,6,11,0,0,0)));
    fs=2000;
    t=t(inc);
    obs1=obs(inc);

    tbin=linspace(0,24,48);
    dayt=(hour(t)+minute(t)/60);

    %transit time longer than 25ms
    ind=find([obs1.dt]*fs>40);
    figure
    subplot(2,3,1)
    yyaxis left
    plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','b')

    %transit time longer than 50ms
    ind=find([obs1.dt]*fs>80);
    hold on
    plot(tbin,hist(dayt(ind),tbin)/length(ind),'LineWidth',2,'Color','r')

    %transit time longer than 100ms
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

Run "dilu.m" to select a dilution of the waveforms and calculate pairwise similarity.  

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

"supercorr.m" is to calculate pairwise similarity for waveform used above:

    function [dist lag gain] = supercorr(A,B)

    L1=length(A);
    L2=length(B);

    if L1>L2;   
        % B is short;
        K=zeros(length(A),1);

        for ind0=1:(1+length(A)-length(B));
            ind=ind0:(ind0-1+length(B));
            K(ind0)=dot(B,A(ind))/(norm(B)*norm(A(ind))); % cosine similarity
        end
        [cs ind0]=max(K);
        if cs==0&&ind0~=1
            ind=ind0-1:(ind0-2+length(B));
        else
            ind=ind0:(ind0-1+length(B));
        end
        gain=1/(B\A(ind));
        lag=-(ind0-1);

    else
    % A is short;

    K=zeros(length(B),1);

    for ind0=1:(1+length(B)-length(A));
       ind=ind0:(ind0-1+length(A));
       K(ind0)=dot(A,B(ind))/(norm(A)*norm(B(ind))); % cosine similarity
    end

        [cs ind0]=max(K);
        if cs==0&&ind0~=1
            ind=ind0-1:(ind0-2+length(A));
        else
            ind=ind0:(ind0-1+length(A));
        end
        gain=A\B(ind);    
        lag=ind0-1;

    end


    dist=1-cs;

Run "waveformDelayPlot.m" to apply hierarchical clustering to waveform distance matrix and plot centroid waveforms.  

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

Run "clusterAll.m" to group power spectra into 55 clusters and plot centroid power spectra.  s

    clear all
    close all

    load linkAllLowsubset Z PCo linFreq PDe
    NoC=55;

    T = cluster(Z,'maxclust',NoC);

    RGB=colormap('jet');
    RGB=interp1(1:length(RGB),RGB,(1:NoC)*length(RGB)/NoC);


    for c=1:NoC;
        ind=find(T==c);
        L=length(ind);
        N(c)=length(ind);

        %For Copol.
        PCosort=sort(PCo(ind,:));

        centroidHiCo(c,:)=PCosort(ceil(L/4),:);
        centroidLoCo(c,:)=PCosort(ceil(L*3/4),:);
        centroidCo(c,:)=PCosort(ceil(L/2),:);

        %For Depol.
        PDesort=sort(PDe(ind,:));

        centroidHiDe(c,:)=PDesort(ceil(L/4),:);
        centroidLoDe(c,:)=PDesort(ceil(L*3/4),:);
        centroidDe(c,:)=PDesort(ceil(L/2),:);


    end



    figure
    Dc=pdist(log(centroidCo),'euclidean');
    Zc=linkage(log(centroidCo),'ward','euclidean','savememory','on');
    reord=optimalleaforder(Zc,Dc);
    [h IDX pla]=dendrogram(Zc,NoC,'reorder',reord);%
    set(h,'LineWidth',2,'Color','k')


    N=N(reord);
    clusterNo='C'+string(1:NoC);
    centroidHiCo=centroidHiCo(reord,:);
    centroidLoCo=centroidLoCo(reord,:);
    centroidCo=centroidCo(reord,:);
    centroidHiDe=centroidHiDe(reord,:);
    centroidLoDe=centroidLoDe(reord,:);
    centroidDe=centroidDe(reord,:);

    ax=axis;
    set(gca,'XTickLabel',clusterNo,'LineWidth',2,'FontWeight','bold')
    ylabel('Spectral distance','FontWeight','bold','FontSize',16)
    box on
    hold on
    for c=1:NoC;
        ms=0.2*sqrt(N(c));
        plot(c,ax(3)+0.2,'o','Markersize',ms,'MarkerEdgeColor','none','MarkerFaceColor',RGB(c,:));
    end



    for c=1:NoC;
        ind=find(T==reord(c));
        Tnew(ind)=c;
    end
        T=Tnew;
        clear Tnew

    figure
    [ha,pos]=tight_subplot(6,5,[0.05 0.01],[0.05 0.05],[0.05 0.01]);
    for c=1:30
        axes(ha(c));

        semilogy(linFreq,centroidCo(c,:),'color',RGB(c,:),'LineWidth',3)
        hold on
        semilogy(linFreq,centroidHiCo(c,:),'color',[1 1 1]/2)
        semilogy(linFreq,centroidLoCo(c,:),'color',[1 1 1]/2)

        semilogy(linFreq,centroidDe(c,:),'color',RGB(c,:),'LineWidth',3,'LineStyle','--')
        semilogy(linFreq,centroidHiDe(c,:),'color',[1 1 1]/2,'LineStyle','--')
        semilogy(linFreq,centroidLoDe(c,:),'color',[1 1 1]/2,'LineStyle','--')
        axis tight
        title(['C' num2str(c) ' :' num2str(N(c))])
        set(gca,'FontSize',10,'LineWidth',2)

    end
    linkaxes(ha,'x');
    linkaxes(ha,'y');

    axes(ha(1)); ylabel('Power (a.u.)')
    axes(ha(6)); ylabel('Power (a.u.)')
    axes(ha(11)); ylabel('Power (a.u.)')
    axes(ha(16)); ylabel('Power (a.u.)')
    axes(ha(21)); ylabel('Power (a.u.)')
    axes(ha(26)); ylabel('Power (a.u.)')

    axes(ha(26)); xlabel('Frequency (Hz)')
    axes(ha(27)); xlabel('Frequency (Hz)')
    axes(ha(28)); xlabel('Frequency (Hz)')
    axes(ha(29)); xlabel('Frequency (Hz)')
    axes(ha(30)); xlabel('Frequency (Hz)')

    figure
    [ha,pos]=tight_subplot(5,5,[0.05 0.01],[0.07 0.05],[0.05 0.01]);
    for c=31:NoC

        axes(ha(c-30));
        semilogy(linFreq,centroidCo(c,:),'color',RGB(c,:),'LineWidth',3)
        hold on
        semilogy(linFreq,centroidHiCo(c,:),'color',[1 1 1]/2)
        semilogy(linFreq,centroidLoCo(c,:),'color',[1 1 1]/2)

        semilogy(linFreq,centroidDe(c,:),'color',RGB(c,:),'LineWidth',3,'LineStyle','--')
        semilogy(linFreq,centroidHiDe(c,:),'color',[1 1 1]/2,'LineStyle','--')
        semilogy(linFreq,centroidLoDe(c,:),'color',[1 1 1]/2,'LineStyle','--')
        axis tight
        title(['C' num2str(c) ' :' num2str(N(c))])
        set(gca,'FontSize',10,'LineWidth',2)

    end
    linkaxes(ha,'x');
    linkaxes(ha,'y');

    axes(ha(1)); ylabel('Power (a.u.)')
    axes(ha(6)); ylabel('Power (a.u.)')
    axes(ha(11)); ylabel('Power (a.u.)')
    axes(ha(16)); ylabel('Power (a.u.)')
    axes(ha(21)); ylabel('Power (a.u.)')

    axes(ha(21)); xlabel('Frequency (Hz)')
    axes(ha(22)); xlabel('Frequency (Hz)')
    axes(ha(23)); xlabel('Frequency (Hz)')
    axes(ha(24)); xlabel('Frequency (Hz)')
    axes(ha(25)); xlabel('Frequency (Hz)')

Run "linkageCompare.m" to compare linkages for different polarization configurations.  

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

Run "shannonPlot.m" to calculate Shannon indices for different polarization configurations.   

    clear all
    close all
    %
    load linkAllLowsubset ZCo ZDe Z ZUn

    NoC=55;
    T = cluster(ZCo,'maxclust',NoC);
    SI=0;

    for c=1:NoC;
        ind=find(T==c);

        L=length(ind);

        p=L/length(T);
        SI=SI-p*log(p);

        N(c)=length(ind);


    end
    SI

    T = cluster(ZDe,'maxclust',NoC);
    SI=0;

    for c=1:NoC;
        ind=find(T==c);

        L=length(ind);

        p=L/length(T);
        SI=SI-p*log(p);

        N(c)=length(ind);


    end
    SI

    T = cluster(Z,'maxclust',NoC);
    SI=0;

    for c=1:NoC;
        ind=find(T==c);

        L=length(ind);

        p=L/length(T);
        SI=SI-p*log(p);

        N(c)=length(ind);


    end
    SI

    T = cluster(ZUn,'maxclust',NoC);
    SI=0;

    for c=1:NoC;
        ind=find(T==c);

        L=length(ind)

        p=L/length(T);
        SI=SI-p*log(p);

        N(c)=length(ind);


    end
    SI

Run "clusterPlot.m" to plot correlation between number of signals and number of clusters.

    numbersLow=[2878 6303 25372 59486 94039];
    classLow=[10 6 16 33 31];
    numbersHigh=[807 865 8261 22600 32533];
    classHigh=[4 5 24 38 39];
    classSub=[12 18 37 52 56];

    figure
    xlim([0 100000])
    semilogx(numbersLow,classLow,'linestyle','--','LineWidth',2,'Color','r','Marker','+');
    hold on
    semilogx(numbersHigh,classHigh,'linestyle','--','LineWidth',2,'Color','b','Marker','o');
    semilogx(numbersHigh,classSub,'linestyle','--','LineWidth',2,'Color','g','Marker','di');
    set(gca,'FontSize',20,'LineWidth',2)

Run "FPMalaisePlot2.m" to plot the results of Malaise traps data.  


    clear all
    close all

    [NUM,TXT,RAW]=xlsread('FP_Malaise_traps.xlsx');


    Site=TXT(2:end,1);
    Week=TXT(2:end,2);
    Ord=upper(TXT(2:end,3));
    Fam=upper(TXT(2:end,5));
    Counts=NUM;

    siteLbl=unique(Site);
    weekLbl=unique(Week);
    famLbl=unique(Fam);
    ordLbl=unique(Ord);

    for s=1:length(siteLbl);

        for w=1:length(weekLbl);

            for f=1:length(famLbl)      

                inc=find(strcmpi(Site,siteLbl(s)).*strcmpi(Week,weekLbl(w)).*strcmpi(Fam,famLbl(f)));

                P(s,w,f)=sum(Counts(inc));


                if length(inc)

                [pp ind]=sort(squeeze(P(s,w,:)),'descend');
                pp=pp(1:(find(pp==0,1,'first')-1));
                ff=(1:length(pp))';


                regr=[ff.^0 log(ff.^1)];
                th=regr\log(pp);
                Slope(s,w)=th(2);
                Bias(s,w)=exp(th(1));


                pphat{s,w}=exp(regr*th);
                R2(s,w)=corr(pp,pphat{s,w});

                F{s,w}=famLbl(ind);

                end

            end
        end
    end

    Ptot=sum(P,3);
    Rich=sum(P>0,3);


    s=5;
    w=27;

    loglog(pphat{s,w},'r','linewidth',2)
    hold on
    s=5;
    w=27;
    loglog(sort(squeeze(P(s,w,:)),'descend'),'*b','linewidth',2)
    title([siteLbl{s} ' ' weekLbl{w}])
    axis([0.9 100 0.5 1000])
    set(gca, 'Linewidth',2,'FontSize',16)
    xlabel('Family (index)')
    ylabel('Abundance per family (#)')


    figure

    loglog(Ptot(:),Rich(:),'*')
    axis([0.5 2000 0.8 100])
    set(gca, 'Linewidth',2,'FontSize',16)
    xlabel('Number of catches (#)')
    ylabel('Number of families (#)')
    hold on
    pp=1:500;
    loglog(pp,55*(1-exp(-0.0088*pp)))


    figure

    loglog(Ptot(:),Rich(:),'*','linewidth',2)
    hold on
    pp=log(1:2000);
    R=5.2
    a=1.55;
    N=2.9
    loglog(exp(pp),exp(R*((pp/N).^a./(1+(pp/N).^a))),'r','linewidth',2)

    axis([0.9 2000 0.8 100])
    grid on
    set(gca, 'Linewidth',2,'FontSize',16)
    xlabel('Number of catches (#)')
    ylabel('Number of families (#)')
