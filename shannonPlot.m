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
