close all
clear all
clc

%% Ouvrir ficher .txt LabChart

filename_L = '../txt/c2_0005_RIP_Fe100Hz.mat';
delimiterIn_L = '\t';
headerlinesIn_L= 5;

fichierLabChart= importdata(filename_L,delimiterIn_L,headerlinesIn_L);
thorax_L=fichierLabChart.THOd(1:length(fichierLabChart.THOd));
abdomen_L=fichierLabChart.ABDd(1:length(fichierLabChart.THOd));
volume_L=fichierLabChart.VolRecBrut(1:length(fichierLabChart.THOd));
debit_L=fichierLabChart.DebRec(1:length(fichierLabChart.THOd));
longueur_signal_L=length(thorax_L);

%affichage

freq_L=100;
t_L=0:1/freq_L:(longueur_signal_L/freq_L-1/freq_L);
% plot(t_L,thorax_L')

%% Ouvrir fichier .rcg VisuResp
filename_C= '../txt/C2_17_05_2016_SSET.mat';
delimiterIn_C = '\t';
headerlinesIn_C = 38;

fichierComplet=importdata(filename_C,delimiterIn_C,headerlinesIn_C);
thorax_C=fichierComplet.THO(1:length(fichierComplet.THO));
abdomen_C=fichierComplet.ABD(1:length(fichierComplet.THO));
volume_C=fichierComplet.VolRecBrut(1:length(fichierComplet.THO));
debit_C=fichierComplet.DebRec(1:length(fichierComplet.THO));
longueur_signal_C=length(thorax_C);

%affichage
freq_C=40;
t_C=0:1/freq_C:(longueur_signal_C/freq_C)-1/freq_C;
% figure;
%plot(t_C,thorax_C')

%% Solution 1 pour echantillonnage
%sur-echantillonnage

x = t_C;
v =thorax_C;
freq_test=100;
t_L2=0:1/freq_test:(longueur_signal_C/freq_C-1/freq_C);
xq =t_L2;
thorax_C2='';
methode={'nearest';'next';'previous';'linear';'spline';'pchip'};
for i=1:6
%     figure
    thorax_C2{i}= interp1(x,v,xq,methode{i});
    % plot(x,v,'o',xq,vq1,':.');
%     xlim([0 (longueur_signal_C/freq_C)-1/freq_C]);
%     title('(Default) Linear Interpolation');
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
for i=1:6
    thorax_C2_temp= thorax_C2{i}';
    r_thorax=0;
    r_abdo='';
    
    for k=2:length(thorax_C2_temp)-length(thorax_L)-2
        if(max(xcorr(thorax_L,thorax_C2_temp(k-1:length(thorax_L+k-1))))>r_thorax)
        r_thorax=max(xcorr(thorax_L,thorax_C2_temp(k-1:length(thorax_L+k-1))))
        end
%       if(max(xcorr(abdo_L,abdo_C2_temp(k-1:length(thorax_L+k-1))))>r_abdo)
%         r_thorax=max(xcorr(thorax_L,thorax_C2_temp(k-1:length(thorax_L+k-1))))
%         end
k
    end
    
    [val_thorax,ind_thorax]=max(r_thorax)
    fenetre_thorax=ind_thorax:ind_thorax+length(thorax_L);
    
%     [val_abdo,ind_abdo]=max(r_abdo);
%     fenetre_abdo=ind_abdo:ind_abdo+length(abdomen_L);
end
