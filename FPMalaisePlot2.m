
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

