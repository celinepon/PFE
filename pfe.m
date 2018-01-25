close all 
clear all
clc

%% Ouvrir ficher .txt LabChart

filename_L = '../C2_17_05_2016.txt';
delimiterIn_L = '\t';
headerlinesIn_L= 5;

fichierLabChart= importdata(filename_L,delimiterIn_L,headerlinesIn_L);
thorax_L=fichierLabChart.data(1:length(fichierLabChart.data),1);
abdomen_L=fichierLabChart.data(1:length(fichierLabChart.data),2);
volume_L=fichierLabChart.data(1:length(fichierLabChart.data),3);
debit_L=fichierLabChart.data(1:length(fichierLabChart.data),4);
longueur_signal_L=length(thorax_L);

%affichage

freq_L=40;
t_L=0:1/freq_L:(longueur_signal_L/freq_L-1/freq_L);
plot(t_L,thorax_L')

 %% Ouvrir fichier .rcg VisuResp
% filename_C= 'Fichiers_TXT/C2_17_05_2016.rcg';
% delimiterIn_C = '\t';
% headerlinesIn_C = 38;
% 
% fichierComplet=importdata(filename_C,delimiterIn_C,headerlinesIn_C);
% thorax_C=fichierComplet.data(1:length(fichierComplet.data),1);
% abdomen_C=fichierComplet.data(1:length(fichierComplet.data),2);
% volume_C=fichierComplet.data(1:length(fichierComplet.data),11);
% debit_C=fichierComplet.data(1:length(fichierComplet.data),12);
% longueur_signal_C=length(thorax_C);
% 
% %affichage
% freq_C=40;
% t_C=0:1/freq_C:(longueur_signal_C/freq_C)-1/freq_C;
% figure;
% plot(t_C,thorax_C')

%% Solution 1 pour echantillonnage
%sur-echantillonnage

x = t_L; 
v =thorax_L;
freq_test=40;
t_L2=0:1/2000:(longueur_signal_L/freq_test-1/freq_test);
xq =t_L2;

methode={'nearest';'next';'previous';'linear';'spline';'pchip'};
for i=1:6
figure
vq1 = interp1(x,v,xq,methode{i});
plot(x,v,'o',xq,vq1,':.');
xlim([0 (longueur_signal_L/freq_L)-1/freq_L]);
title('(Default) Linear Interpolation');
end

%% Solution 2 pour echantillonnage--> bloque le PC

%reconstruction du signal par interpolation avec la fonction sinus cardinal
% h = waitbar(0, 'Wait please ...');
% s=sinc(xq)
% waitbar(1)
% figure
% res= conv(v,s)
% plot(xq,res);
% longueur_signal_L=length(res);

% %re-echantillonnage
% freq_L=20000;
% res=res(0:1/freq_L:end);
% t=0:1/freq_L:(longueur_signal_L/freq_L)-1/freq_L;
% figure;
% plot(res)

%% Intercorrélation

for k=1:length(signalA)-length(signalB)-1
    r(k)=xcorr(signalB,signalA(k:length(signal(B)+k)));
end

[val,ind]=max(r);
fenetre=ind:ind+length(signalB);

