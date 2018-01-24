close all 
clear all
clc

%% Ouvrir ficher .txt LabChart
filename_L = 'Fichiers_TXT/C2_17_05_2016.txt';
delimiterIn_L = '\t';
headerlinesIn_L= 5;

fichierLabChart= importdata(filename_L,delimiterIn_L,headerlinesIn_L);
thorax_L=fichierLabChart.data(1:length(fichierLabChart.data),1);
abdomen_L=fichierLabChart.data(1:length(fichierLabChart.data),2);
volume_L=fichierLabChart.data(1:length(fichierLabChart.data),3);
debit_L=fichierLabChart.data(1:length(fichierLabChart.data),4);
longueur_signal_L=length(thorax_L);

%affichage
freq_L=20000;
t_L=0:1/freq_L:(longueur_signal_L/freq_L)-1/freq_L;
plot(t_L,thorax_L')

%% Ouvrir fichier .rcg VisuResp
filename_C= 'Fichiers_TXT/C2_17_05_2016.rcg';
delimiterIn_C = '\t';
headerlinesIn_C = 38;

fichierComplet=importdata(filename_C,delimiterIn_C,headerlinesIn_C);
thorax_C=fichierComplet.data(1:length(fichierComplet.data),1);
abdomen_C=fichierComplet.data(1:length(fichierComplet.data),2);
volume_C=fichierComplet.data(1:length(fichierComplet.data),11);
debit_C=fichierComplet.data(1:length(fichierComplet.data),12);
longueur_signal_C=length(thorax_C);

%affichage
freq_C=40;
t_C=0:1/freq_C:(longueur_signal_C/freq_C)-1/freq_C;
figure;
plot(t_C,thorax_C')

%sur-echantillonnage


