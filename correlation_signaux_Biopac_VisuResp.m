function newSignal = correlation_signaux_Biopac_VisuResp(signalB,signalA,freqB,freqA)
close all

% Cette fonction permet de rechercher dans un signal (signalA), un autre
% signal contenant possiblement des artefacts (signalB). Elle retourne
% la portion de signal (prise sur signalA) correspondante.
h = waitbar(0,'Please wait...');
signalB=importdata('C:\Users\pc mystere\Documents\data\2016-HOOMIJ\BIOPAC\C2\c2_0005_RIP_Fe100Hz.mat');
signalA=importdata('C:\Users\pc mystere\Documents\data\2016-HOOMIJ\VISURESP\C2_17_05_2016_SSET.mat');
signalB=signalB.ABDd;
signalA=signalA.ABD;

freqB=100;
freqA=40

coeff=0;
fenetre=0;
debut_fen=0;
pval=-1;
t_B=0:1/freqB:(length(signalB)/freqB-1/freqB);
t_A=0:1/freqA:(length(signalA)/freqA-1/freqA);

%sous-echantillonnage

t_B2=0:1/freqA:(length(signalB)/freqB-1/freqB);
signalB_sous= interp1(t_B,signalB,t_B2,'spline');

%calcul 1ere fenetre (pas de 5 pourcent)
pas=floor(0.05*length(signalB_sous));
ind=1;

for k=1:pas:length(signalA)-length(signalB_sous)-1
    
    [val,p]=corrcoef(signalB_sous,signalA(k:length(signalB_sous)+k-1));
    coeff(ind)=val(1,2);
    pval(ind)=1-p(1,2);
    
    ind=ind+1;
    
end
waitbar(0.3)

%calcul 2e fenetre (point par point) sur la fenetre
%trouvee precedemment, + ou - le pas.

indice=find(coeff==max(coeff));
coefficient_correlation=max(coeff);
if indice==1
    debut_fen_inter=1;
    fin_fen_inter=length(signalB_sous);
elseif indice==2
    debut_fen_inter=pas;
    fin_fen_inter=pas+length(signalB_sous);
elseif indice==length(coeff)
    debut_fen_inter=(indice-2)*pas;
    fin_fen_inter=signalA(end);
else
    debut_fen_inter=(indice-2)*pas;
    fin_fen_inter=(indice)*pas+length(signalB_sous);
end

coeff_fin=0;
ind=1;
waitbar(0.5)
for k=debut_fen_inter:1:fin_fen_inter
    
    val=corrcoef(signalB_sous,signalA(k:length(signalB_sous)+k-1));
    coeff_fin(ind)=val(1,2);
    
    ind=ind+1;
    
end

waitbar(1)


indice=find(coeff_fin==max(coeff_fin));
coefficient_correlation=max(coeff_fin)
debut_fen=debut_fen_inter+indice(1)-1;
fin_fen=debut_fen+length(signalB_sous);
fenetre=[debut_fen/freqA fin_fen/freqA-1/freqA];

signalA_norm=(signalA-(min(signalA)))/(max(signalA)-min(signalA));
signalB_norm=(signalB_sous-(min(signalB_sous)))/(max(signalB_sous)-min(signalB_sous));
temps_fenetre=fenetre(1,1):1/freqA:fenetre(1,2);
temps_fenetreA=max(find(t_A<fenetre(1,1))):1:max(find(t_A<fenetre(1,2)));
f=figure;
img=plot(temps_fenetre,signalA_norm(temps_fenetreA),'b');
hold on
plot(temps_fenetre, signalB_norm,'r');

close(h);
f2=figure;
scatter_corr= scatter(pval,coeff,'r','filled', 'Marker', 'o','MarkerFaceAlpha', 0.5, 'MarkerEdgeColor', [1, 1, 1], 'Tag','Correlation','buttondownfcn','button_down_function(obj,coeff)');
% scatter_corr_Select = scatter(0,0,'black','filled', 'Marker', 'o', 'MarkerEdgeColor', [0, 0, 0], 'Parent', f2,'Visible','off','buttondownfcn',{@button_down_function});


end

function button_down_function(obj,coeff)
if get(obj, 'Tag')=='Correlation'
            ps = get(gca, 'CurrentPoint');
             end
end

function selection_point(indice,~)
         h = waitbar(0,'Please wait...');
         
            indice=find(coeff<ps(1,2)+0.001&coeff>ps(1,2)-0.001);
            if ~isempty(indice)
            indice=indice(1);
            selection_point(indice,0);
            r_select=coeff(indice);
            pval_select=pval(indice)
            set(scatter_corr_Select,'XData',pval_select,'YData',r_select,'Visible','on','MarkerFaceColor','r','LineWidth',1)
         
        temps_fenetre_tho=-1;
        fenetre_tho=-1;
        fenetre_abdo=-1;
        temps_fenetre_abdo=-1;
        if indice==1
            debut_fen_inter=1;
            fin_fen_inter=length(thorax_L_sous);
        elseif indice==2
            debut_fen_inter=pas;
            fin_fen_inter=pas+length(thorax_L_sous);
        elseif indice==length(r_abdo)
              debut_fen_inter=(indice-2)*pas;
                  fin_fen_inter=thorax_C(end);
        else
            debut_fen_inter=(indice-2)*pas;
            fin_fen_inter=(indice)*pas+length(thorax_L_sous);
        end
        waitbar(0.3)
        r_thorax_fin=0;
        r_abdo_fin=0;
        ind=1;
       fin_fen_inter
       length(thorax_L_sous)
        length(thorax_C)
        for k=debut_fen_inter:1:fin_fen_inter
            val=corrcoef(thorax_L_sous,thorax_C(k:length(thorax_L_sous)+k-1));
            r_thorax_fin(ind)=val(1,2);
            val=corrcoef(abdomen_L_sous,abdomen_C(k:length(abdomen_L_sous)+k-1));
            r_abdo_fin(ind)=val(1,2);
            
            ind=ind+1;
        end
        
        indice_tho =find(r_thorax_fin==max(r_thorax_fin));
        max_tho=max(r_thorax_fin);
        debut_fen_tho=debut_fen_inter+indice_tho(1)-1;
        fin_fen_tho=debut_fen_tho+length(thorax_L_sous);
        fenetre_tho=[debut_fen_tho/freq_C fin_fen_tho/freq_C-1/freq_C];
        waitbar(0.5)
        indice_abdo =find(r_abdo_fin==max(r_abdo_fin));
        max_abdo= max(r_abdo_fin);
        debut_fen_abdo=debut_fen_inter+indice_abdo(1)-1;
        fin_fen_abdo=debut_fen_abdo+length(abdomen_L_sous);
        fenetre_abdo=[debut_fen_abdo/freq_C fin_fen_abdo/freq_C-1/freq_C];
        
        if max(r_thorax_fin)<max(r_abdo_fin)
            debut_fen_tho=debut_fen_abdo;
            fin_fen_tho=fin_fen_abdo;
            fenetre_tho=fenetre_abdo;
            
        else
            debut_fen_abdo=debut_fen_tho;
            fin_fen_abdo=fin_fen_tho;
            fenetre_abdo=fenetre_tho;
            
        end
        waitbar(1)
       
        temps_fenetre_tho=fenetre_tho(1,1):1/freq_C:fenetre_tho(1,2);
        temps_fenetre_abdo=fenetre_abdo(1,1):1/freq_C:fenetre_abdo(1,2);
        
        set(line_signalA_Thorax_super, 'XData',temps_fenetre_tho, 'YData', (thorax_L_sous-(min(thorax_L_sous)))/(max(thorax_L_sous)-min(thorax_L_sous)))
        set(line_signalA_Abdo_super, 'XData', temps_fenetre_abdo, 'YData', (abdomen_L_sous-(min(abdomen_L_sous)))/(max(abdomen_L_sous)-min(abdomen_L_sous)))
        set(line_signalA_Thorax, 'XData', t_C, 'YData', (thorax_C-(min(thorax_C)))/(max(thorax_C)-min(thorax_C)))
        set(line_signalA_Abdo, 'XData', t_C, 'YData', (abdomen_C-(min(abdomen_C)))/(max(abdomen_C)-min(abdomen_C)))
        set(axe_signal_A_Thorax, 'XLim', fenetre_tho)
        set(axe_signal_A_Abdo, 'XLim', fenetre_abdo)
        set(corr_abdo_valeur,'String',round(max_abdo,4))
        set(corr_thorax_valeur,'String',round(max_tho,4))
        intercorr_calculee=1;
        close(h)
    end