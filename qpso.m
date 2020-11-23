clc;clear;close all;%rng('default');
file2=fopen('result.txt','w');
fprintf('Sequential Assynchronous Particle Swarm Optimization\n');
fprintf(      '   k     gbest      meanfit    stdfit        cv         norm        nfunc       Penal      xgbest\n');
fprintf(file2,'   k     gbest      meanfit    stdfit        cv         norm        nfunc       Penal      xgbest\n');
%-----------Specific Problem Parameters----------
%Minimum searching space for each design variable
varproj=6;
xmin=[0.99*ones(1,varproj)]; %Valor mínimo do espaço de procura
xmax=[1.01*ones(1,varproj)];%Valor máximo do espaço de procura
xmin(1,1)=0.95;
xmax(1,1)=1.05;
xmin(1,2)=0.98;
xmax(1,2)=1.02;
xmin(1,3)=0.85;
xmax(1,3)=1.15;
xmin(1,4)=0.95;
xmax(1,4)=1.05;
xmin(1,5)=0.95;
xmax(1,5)=1.0;
xmin(1,6)=0.75;
xmax(1,6)=1.05;


CA=@FCN;       %Função objetivo
m=length(xmax); %Dimensão do problema
n=2;            %Número de partículas
omegamax=1.1;   %Valor do momento para velocidade
omegamin=0.1;
tol=1.0E-6;     %Tolerância para as iterações
nmax=2;         %Número máximo de iterações
%% Inicio da otimização
gbest=zeros(1,nmax);pen=zeros(1,n);lbest=zeros(1,n);x=zeros(n,m);v=zeros(n,m);
xgbest=zeros(nmax,m);xnew=zeros(n,m);vnew=zeros(n,m);fit=zeros(1,n);
meanfit=zeros(1,nmax);stdfit=zeros(1,nmax);xlbest=zeros(n,m);
k=1;gbest(1)=1E+30;pena=0.0d+00;
%rng(1); %Initialize the same random number sequence
% x=repmat(xmin,n,1)+(repmat((xmax-xmin),n,1).*rand(n,m));
x=repmat(xmin,n,1)+(repmat((xmax-xmin),n,1).*lhsdesign(n,m));
for i=1:n
    [lbest(i), pen(i)]= CA(x(i,:),0);
    xlbest(i,:)=x(i,:);fit(i)=lbest(i);
    if (lbest(i)<gbest(k)), gbest(k)=lbest(i);xgbest(k,:)=x(i,:);pena=pen(i); end
end
nfunc=n; 
xgbestold=xgbest(k,:);gbestold=gbest(k);
meanfit(k)=mean(fit);stdfit(k)=std(fit);cv=abs(stdfit(k)/meanfit(k));
norm=sqrt(sum((xgbest(k,:)-xgbestold).^2));
if (mod(k,1)==0),fprintf(      '%5i %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e ',k,gbest(k),meanfit(k),stdfit(k),cv,norm,nfunc,pena,xgbest(k,:)), end ;fprintf('\n');              
                fprintf(file2,'%5i %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e ',k,gbest(k),meanfit(k),stdfit(k),cv,norm,nfunc,pena,xgbest(k,:))       ;fprintf(file2,'\n');
iflag=0; scale=abs(xmax-xmin);  
figure;
while (iflag==0)
    mbest = sum(xlbest(1:n,:)) / n;  % mean of xlbest
    k=k+1;gbest(k)=gbestold;xgbest(k,:)=xgbestold;
    omega = (omegamin - omegamax)*(k / nmax) + omegamax;
    for i=1:n
         mbest = sum(xlbest(1:n,:)) / n;  % mean of xlbest
        fi1=rand(1,m);fi2=rand(1,m);u=rand(1,m);
        P=fi1.*x(i,:) + (1-fi1).*xgbest(k,:);
        L=omega*abs(mbest-xlbest(i,:)); 
        if rand > 0.5, xnew(i,:) = P - L.*log(1./u);
        else         , xnew(i,:) = P + L.*log(1./u);end
        xnew(i,:)=max(min(xnew(i,:),xmax),xmin);
        [fit(i), pen(i)]= CA(xnew(i,:),0);
        if (fit(i)<lbest(i)), lbest(i)=fit(i);xlbest(i,:)=xnew(i,:);end
        if (fit(i)<gbest(k)), gbest(k)=fit(i);xgbest(k,:)=xnew(i,:);pena=pen(i);end
    end
    nfunc=nfunc+n;
    %Evaluate mean value and standard deviation for Objective Function
    meanfit(k)=mean(fit);stdfit(k)=std(fit);cv=abs(stdfit(k)/meanfit(k));
    norm=sqrt(sum((xgbest(k,:)-xgbestold).^2));xgbestold=xgbest(k,:);gbestold=gbest(k); x=xnew;
    if ((norm <tol && cv < tol) || (k>=nmax)) iflag=1;  end
    if (mod(k,1)==0)  fprintf(      '%5i %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e ',k,gbest(k),meanfit(k),stdfit(k),cv,norm,nfunc,pena,xgbest(k,:)), end ;  fprintf('\n');
                      fprintf(file2,'%5i %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e ',k,gbest(k),meanfit(k),stdfit(k),cv,norm,nfunc,pena,xgbest(k,:))      ;  fprintf(file2,'\n');
%     %Plot results along iterations
%     [~,~]=CA(xgbest(k,:),0);
%     if mod(k,5)==0
%         [fitt, I]=sort(fit);xt=x(I,:);
%         h1=subplot(1,4,1); loglog(k,gbest(k),'+k');grid on;drawnow;hold on;xlabel('Iteração');ylabel('Função Objetivo');        
%         h2=subplot(1,4,2); loglog(k,cv,'+k');drawnow;grid on;hold on;xlabel('Iteração');ylabel('CV');
%         h3=subplot(1,4,3); cla; plot(xt);drawnow;grid on;hold on;xlabel('particula');ylabel('Design variable');
%         h4=subplot(1,4,4); cla; semilogy(fitt);drawnow;grid on;hold on;xlabel('particula');ylabel('Função Objetivo');
%     end    
    subplot(2,1,1);plot(repmat(1:k,m,1)',xgbest(:,1:m));title('Best estimates');xlabel('Generations');ylabel('Design variables');legend('show');
    subplot(2,1,2);plot(1:k,gbest(:) ,'-k');title('Fitness');xlabel('Generations');ylabel('Objective Function');drawnow;
end
fprintf ('xgbest\n');fprintf(' %+10.4e',xgbest(k,:));fprintf('\n');
fprintf('gbest\n');fprintf('%+10.4e',gbest(1,:));fprintf('\n');

fprintf (file2,'xgbest\n');fprintf(file2,' %+12.6e',xgbest(k,:));fprintf(file2,'\n');
fprintf(file2,'gbest\n');fprintf(file2,'%+10.4e',gbest(k));fprintf('\n');
[~,~]=CA(xgbest(k,:),0);
fclose(file2);
