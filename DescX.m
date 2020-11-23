function [X]=DescX(n,m,o)
    %n-numero de parãmetros a serem ordenados em termos de importância
    %m-  0=>sem impressão dos nomes das n variáveis  1=> imprime o nome destas variáveis
    %o-  0=> usa todas as frequências para definir a prioridade, ~=0 usa as que estão definidas internamente no programa, no caso 3,6, e 10
    Sens=csvread('MatrizSensibilidade.csv',2,0);
    Tam=size(Sens,2); 
    if o==0
        Sens=sqrt(sum(Sens.^2,1));
        [C,X]=sort(Sens,'descend');
    else
        f1=3;
        f2=6;
        f3=10;
        Aux=ones(3,Tam);
        Aux(1,:)=Aux(1,:).*Sens(f1,:);
        Aux(2,:)=Aux(2,:).*Sens(f2,:);
        Aux(3,:)=Aux(3,:).*Sens(f3,:);
        Aux=sqrt(sum(Aux.^2,1));
        [C,X]=sort(Aux,'descend');
    end
    
    Nomes={'aux1' , 'RaioBoca','pos1','pos2','AltTampo','EspCaixa','LargCurvaInferior','LargCintura','EspTravej','DistTravejCintura','AltSuporteCaixa','LargPonte','AltPonte','AltEnrij','EspEnrij','OffsetEnrij','DistEnrij','LargBraco','AltBraco','EspBraco','LargMao','AltMao','EspMao','AEspTamp','AEspFaixa','AEspFundo','AEspEscala','AEspBraco','AEspMao','AEspPonte','AEspSuporteCaixa','AEspEnrij','AEspTravej','CastDens','CastEX','CastEY','CastEZ','CastPRxy','CastPRyz','CastPRxz','CastGxy','CastGyz','CastGxz','PauFDens','PauFEX','PauEY','PauEZ','PauPRxy','PauPRyz','PauPRxz','PauGxy','PauGyz','PauGxz','CedroDens','CedroEX','CedroEy','CedroEz','CedoPRxy','CedroPRyz','CedroPRxz','CedroGxy','CedroGyz','CedroGxz','BalsaDens','BalsaEX','BalsaEy','BalsaEZ','BalsaPRxy','BalsaPRyz','BalsaPRxz','BalsaGxy','BalsaGyz','BalsaGxz'};
    if m~=0
        for i=1:n
            disp(Nomes(X(1,i)))
        end
    end
    csvwrite('DescX.csv',X);
end

%     j=1;
%     while j~=0
%         j=0;
%         for k=1:(Tam-1)
%             if V3(2,k)<V3(2,k+1)
%                 aux=V3(:,k+1);
%                 V3(:,k+1)=V3(:,k);
%                 V3(:,k)=aux;
%                 j=j+1;
%             end
%         end
%     end
%      
%     for i=1:n
%         if V1(2,i)<=V2(2,i)
%             if V2(2,i)<=V3(2,i)
%                 X(1,i)=V3(1,i);
%             else X(1,i)=V2(1,i);
%             end
%         else if V1(2,i)>=V3(2,i)
%                 X(1,i)=V1(1,i);
%             end
%         end
%     end
%
% a=rand(3,10);
% sqrt(sum(a.^2,1))
% [c,I]=sort(b)