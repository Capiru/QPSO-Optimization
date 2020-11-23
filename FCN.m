%........................................................................................      
function [F,iflag]=FCN(X,iflag)
    F=0;
    load('FrqNats.mat','FrqNatsAvg')
    Frq=[6,9,13];
    Freq=callansys(X,Frq);
    for i=1:length(Frq)
        F=F+((Freq(i)-FrqNatsAvg(i,1))/FrqNatsAvg(i,1))^2;
    end
    %disp(F)
end
