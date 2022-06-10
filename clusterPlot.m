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
