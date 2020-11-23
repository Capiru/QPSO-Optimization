function [FreqR]=callansys(X,Frq)
%----------------------------------------------------------------
%Matlab Script to use Ansys in batch mode and retrieve solutions
%----------------------------------------------------------------
%mass=0;Freq=0;stres=0;strain=0;
%Prepare the input file to be processed by Ansys
%Ansyspath='C:\Program Files\ANSYS Inc\v140\ansys\bin\winx64\';
% Importancia=csvread('DescX.csv');
Importancia=[13,17,2,4,5,15,14,1,7,8,3,12,16,34,21,19,11,24,9,10,35,26,25,65,36,18,33,44,30,41,6,32,64,71,27,20,54,31,66,43,42,45,46,38,22,56,73,51,28,53,52,29,62,63,55,72,23,61,68,48,58,39,40,69,60,59,70,37,47,49,50,57,67];
XX=ones(1,length(Importancia));
XX(Importancia(1:length(X)))=X;

DIR=strcat(pwd,'/');
if strcmp(computer,'GLNXA64');
    ansys_root='/usr/local/ansys_inc/';
    if exist(ansys_root,'dir')==7;
        cd(ansys_root);
        Mstr=dir;
        ansys_ver=Mstr(end).name;
        ansys_bin=strcat('ansys',ansys_ver(2:end));
        ansys_path=strcat(ansys_root,ansys_ver,'/ansys/bin/');
        cd(DIR)
        filepath=strcat(pwd,'/');
    end
elseif strcmp(computer,'PCWIN64');
    ansys_root='C:\Program Files\ANSYS Inc\';
    if exist(ansys_root,'dir')==7;
        cd(ansys_root);
        Mstr=dir;
        ansys_ver=Mstr(end).name;
        ansys_bin=strcat('ansys',ansys_ver(2:end));
        ansys_path=strcat(ansys_root,ansys_ver,'\ansys\bin\winx64\');
        cd(DIR)
        filepath=strcat(pwd,'\');
    end
else
    error('whadafu## OS u`re using, bro!')
end
InputFile='inp.txt';
OutputFile='out.txt';
TemplateFile='TemplateScriptAnsys.txt';
file1=strcat(filepath,InputFile);    %Name and path of the 'input file'
file2=strcat(filepath,TemplateFile); %Name and path of the 'template file'
file3=strcat(filepath,OutputFile);   %Name and path of the 'output file'
%-------------------------------------------------------------------------
%Open 'input file' for ansys as 'write only'
f1=fopen(file1,'w');  
%Open 'template file' ansys file as 'read only'
f2=fopen(file2,'r'); 
%Open output file as a new one to output the ansys solution
%-------------------------------------------------------------------------
%Read 'template file' line by line and store all in a string cell array
%-------------------------------------------------------------------------
% %VARIAVEIS PROBLEMATICAS
% XX(17)=1;
% XX(1)=1;
% XX(2)=1;
% XX(16)=1;
% XX(3)=1;
% XX(5)=1;
% XX(4)=1;
% XX(7)=1;
% XX(12)=1;
% XX(13)=1;
% XX(14)=1;
% XX(8)=1;
%%
i=0;
tline=cell(1000);
while ~feof(f2) 
    i=i+1;
    l=fgetl(f2);
    if ischar(l);
        tline{i}=l;
    end
end
Index=[9,10,11,12,14,15,18,22,30,31,34,37,38,41,42,43,44,48,49,50,53,54,55,60,61,62,63,64,65,66,67,68,69,72,73,74,75,76,77,78,79,80,81,83,84,85,86,87,88,89,90,91,92,94,95,96,97,98,99,100,101,102,103,105,106,107,108,109,110,111,112,113,114];
jj=1;
for i=1:length(tline) %Write on 'input file', new modified lines from template
    AUX=ismember(i,Index);
       if (AUX==1)
            [valor, posicao]=max(isspace(tline{i}));
            tnew=[tline{i}(1:posicao),'*',num2str(XX(jj)),' \n'];
            tnew=tnew(find(~isspace(tnew)));
            fprintf(f1,tnew);
            jj=jj+1;
       else
            fprintf(f1,'%s \n',char(tline{i}));
       end
end
fclose(f1);fclose(f2); %Close all files 
%-------------------------------------------------------------------------
%Call Ansys in batch mode by system command
%-------------------------------------------------------------------------
if strcmp(computer,'GLNXA64');
   launch_cmd=['bash ',ansys_path,ansys_bin,' -p -b -i ',...
       file1,' -np 4 -o ',file3];
   [status, result]=unix(launch_cmd);
elseif strcmp(computer,'PCWIN64');
    launch_cmd=horzcat('"',ansys_path,ansys_bin,'"',' -p -b -i',' "',file1,'"',' -o',' "',file3,'"');
    [status, result]=dos(launch_cmd);
end
% text=horzcat('"','C:\Program Files\ANSYS Inc\v140\ansys\bin\winx64\ansys140','"',' -np 4 -b -i',' "',file1,'"',' -o',' "',file3,'"');
% [status, result]=dos(text);
%[status, result]=system(horzcat('"',Ansyspath,'ansys110','"',' -np 2 -b -i ','"',file1,'"',' -o ','"',file3,'"'));
%! "C:\Program Files\ANSYS Inc\v110\ANSYS\bin\intel\ansys110" -np 2 -b -i "C:\Program Files\ANSYS Inc\v110\ANSYS\bin\intel\inp.txt" -o "C:\Program Files\ANSYS Inc\v110\ANSYS\bin\intel\out.txt"
%[status, result]=system(horzcat('"',Ansyspath,'ansys54','"',' -m 64 -b -i ',file1,' -o ',file3));
if status~=0
    fprintf('*********Problem runing Ansys************ \n');
end
%-------------------------------------------------------------------------
%Retrieve results from the 'output file'
%-------------------------------------------------------------------------
%******************Natural Frequencies Information

f3=fopen(file3,'r');  %Open output file
i=0;
while ~feof(f3) 
    i=i+1;
    l=fgetl(f3);
    if ischar(l);
        %..................................................................
        k=strfind(l,'  ***** FREQUENCIES FROM SUBSPACE ITERATION *****'); %Find where the heading string is located
        if k>0
            for j=1:4   %read some lines ahead
                l=fgetl(f3);
            end
            j=0;
            while -1 %Read lines that contains mode frequency and values
                j=j+1;
                l=fgetl(f3);
                if (~isempty(l)&&(length(l)>2))
                    A=sscanf(l,'%f  %f');
                    Freq(A(1))=A(2);             
                else
                    break;
                end 
            end            
        end
        %..................................................................
    end
end
fclose(f3); %Close file3
% disp(Freq)
t=size(Frq);
FreqR=zeros(t);
FreqR(:)=Freq(Frq(1:length(Frq)));
%disp(FreqR)
return
