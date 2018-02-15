% Cette fonction permet de rechercher dans un signal (signalA), un autre
% signal contenant possiblement des artefacts (signalB). Elle crée un nouveau
% fichiercontenant la portion du signalA correspondante.

function correlation_signaux_Biopac_VisuResp(signalB,signalA,freqB,freqA)
% DONNNEES ENTREE
% signalB = vecteur colonne de valeurs
% signalA = vecteur colonne de valeurs, de taille superieure a la taille du
% signalB
% freqB = frequence d'echantillonnage du signalB
% freqA = frequence d'echantillonnage du signalA
%
% DONNNEES SORTIES
% creation d'un nouveau fichier 'nom_du_signalB_Visuresp'.mat, a la même
% localisation que le fichier du signalB. Ce nouveau fichier contiendra la
% portion du signalA correspondante au signalB, a la frequence
% d'echantillonnage du signalB

% METHODE
% 1ere partie: calcul du coefficient de correlation entre le signalB et le
% signalA, en utilisant une fenetre glissante de la taille du signalB, se
% decalant d'un pas de 10 pourcent de la taille du signalB. La fenetre
% fournissant le maximum de correlation sera utilisee dans la partie 2.
% 2e partie: calcul du coefficient de correlation, point par point, entre le signalB et le
% signalA, en utilisant la fenetre precedemment detectee +/- 10 pourcent de
% la taille du signalB. Le maximum du coefficient de correlation permet
% d'etablir la fenetre optimale du signalA correspondant au signalB
% 3e partie: creation d'un graphe de chacun des coefficents de correlation obtenus
% dans la partie 1, en fonction des 1-pvalue associer. La selection d'un de ces points
% entraine le changement de fenetrage du signalA affiche.

h = waitbar(0,'Please wait...');
handles.chemin_nom_signalB='R:\vsld\2018-pfe-polytech-TIS5\c2_0005_RIP_Fe100Hz.mat';
handles.chemin_nom_signalA='R:\vsld\2018-pfe-polytech-TIS5\C2_17_05_2016_SSET.mat';
handles.signalB=importdata(handles.chemin_nom_signalB);
handles.signalA=importdata(handles.chemin_nom_signalA);
handles.signalB=handles.signalB.ABDd;
handles.signalA=handles.signalA.ABD;


handles.freqB=100;
handles.freqA=40;
handles.coeff=0;
handles.fenetre=0;
handles.pval=-1;
handles.t_B=0:1/handles.freqB:(length(handles.signalB)/handles.freqB-1/handles.freqB);
handles.t_A=0:1/handles.freqA:(length(handles.signalA)/handles.freqA-1/handles.freqA);
handles.numero=1;

%sous-echantillonnage
handles.t_B2=0:1/handles.freqA:(length(handles.signalB)/handles.freqB-1/handles.freqB);
handles.signalB_sous= interp1(handles.t_B,handles.signalB,handles.t_B2,'spline');

%calcul 1ere fenetre (pas de 5 pourcent)
handles.pas=floor(0.05*length(handles.signalB_sous));
ind=1;
for k=1:handles.pas:length(handles.signalA)-length(handles.signalB_sous)-1
    [val,p]=corrcoef(handles.signalB_sous,handles.signalA(k:length(handles.signalB_sous)+k-1));
    handles.coeff(ind)=val(1,2);
    handles.pval(ind)=1-p(1,2);
    ind=ind+1;
end
waitbar(0.3)

%calcul 2e handles.fenetre (point par point) sur la fenetre
%trouvee precedemment, + ou - le pas.
indice=find(handles.coeff==max(handles.coeff));
handles.coefficient_correlation=max(handles.coeff);
if indice==1
    debut_fen_inter=1;
    fin_fen_inter=length(handles.signalB_sous);
elseif indice==2
    debut_fen_inter=handles.pas;
    fin_fen_inter=handles.pas+length(handles.signalB_sous);
elseif indice==length(handles.coeff)
    debut_fen_inter=(indice-2)*handles.pas;
    fin_fen_inter=handles.signalA(end);
else
    debut_fen_inter=(indice-2)*handles.pas;
    fin_fen_inter=(indice)*handles.pas+length(handles.signalB_sous);
end

handles.coeff_fin=0;
ind=1;
waitbar(0.5)
for k=debut_fen_inter:1:fin_fen_inter-length(handles.signalB_sous)
    
    val=corrcoef(handles.signalB_sous,handles.signalA(k:length(handles.signalB_sous)+k-1));
    handles.coeff_fin(ind)=val(1,2);
    
    ind=ind+1;
    
end

waitbar(1)
indice_fin=find(handles.coeff_fin==max(handles.coeff_fin));
handles.coefficient_correlation=max(handles.coeff_fin);

% Affichage des 2 signaux superposés
debut_fen=debut_fen_inter+indice_fin(1)-1;
fin_fen=debut_fen+length(handles.signalB_sous);
handles.fenetre=[debut_fen/handles.freqA fin_fen/handles.freqA-1/handles.freqA];
handles.signalA_norm=(handles.signalA-(min(handles.signalA)))/(max(handles.signalA)-min(handles.signalA));
handles.signalB_norm=(handles.signalB_sous-(min(handles.signalB_sous)))/(max(handles.signalB_sous)-min(handles.signalB_sous));
temps_handles.fenetre=handles.fenetre(1,1):1/handles.freqA:handles.fenetre(1,2);
temps_handles.fenetreA=max(find(handles.t_A<handles.fenetre(1,1))):1:max(find(handles.t_A<handles.fenetre(1,2)));
handles.f=figure('Name', ['Coefficient de correlation: ', num2str(handles.coefficient_correlation)], 'Position', [50,100, 800,500]);
plot(temps_handles.fenetre,handles.signalA_norm(temps_handles.fenetreA),'b');
hold on
plot(temps_handles.fenetre, handles.signalB_norm,'r');
close(h);
uicontrol( ...
    'Parent', handles.f, ...
    'Style', 'text', ...
    'FontSize', 10, ...
    'String', ['Coefficient de correlation : ',num2str(handles.coefficient_correlation)], ...
    'Position',[250, 470, 300, 25] ...
    );
uicontrol( ...
    'Parent', handles.f, ...
    'Style', 'pushbutton', ...
    'FontSize', 10, ...
    'String', 'Extraire', ...
    'Position', [350, 5, 80, 25], ...
    'Callback', {@valider_correlation,handles} ...
    );

% Affichage des valeurs des coefficients de correlation en fonction des
% 1-pvalue
ind_aff=find(handles.coeff>0.5*max(handles.coeff));
figure('Name','Coefficients/1-pvalue');
handles.scatter_corr_Select = scatter(handles.pval(indice),handles.coeff(indice),'g','filled', 'Marker', 'o','MarkerFaceAlpha', 1, 'MarkerEdgeColor', [0, 0, 0],'Visible','on','buttondownfcn',{@button_down_function,handles});
hold on
scatter(handles.pval(ind_aff),handles.coeff(ind_aff),'r','filled', 'Marker', 'o','MarkerFaceAlpha', 0.5, 'MarkerEdgeColor', [1, 1, 1], 'Tag','Correlation','buttondownfcn',{@button_down_function,handles});
end

%% Selection de valeurs de coefficients de correlation dur le graphe, et changement de l'affichage de la superposition des signaux
function button_down_function(obj,~,handles)
if get(obj, 'Tag')=='Correlation'
    ps = get(gca, 'CurrentPoint');
    indice=find(handles.coeff<ps(1,2)+0.005&handles.coeff>ps(1,2)-0.005);
    if ~isempty(indice)
        indice=indice(1);
        selection_point(indice,handles);
        r_select=handles.coeff(indice);
        pval_select=handles.pval(indice);
        set(handles.scatter_corr_Select,'XData',pval_select,'YData',r_select);
    end
end

    function selection_point(indice,handles)
        h = waitbar(0,'Please wait...');
        temps_handles.fenetre=-1;
        handles.fenetre=-1;
        handles.numero=handles.numero+1;
        
        %calcul du cefficient de correlation sur la handles.fenetre correspondant
        %au coefficient selectionne
        if indice==1
            debut_fen_inter=1;
            fin_fen_inter=length(handles.signalB_sous);
        elseif indice==2
            debut_fen_inter=handles.pas;
            fin_fen_inter=handles.pas+length(handles.signalB_sous);
        elseif indice==length(handles.coeff)
            debut_fen_inter=(indice-2)*handles.pas;
            fin_fen_inter=handles.signalA(:);
        else
            debut_fen_inter=(indice-2)*handles.pas;
            fin_fen_inter=(indice)*handles.pas+length(handles.signalB_sous);
        end
        waitbar(0.3)
        handles.coeff=0;
        ind=1;
        for k=debut_fen_inter:1:fin_fen_inter-length(handles.signalB_sous)
            val=corrcoef(handles.signalB_sous,handles.signalA(k:length(handles.signalB_sous)+k-1));
            handles.coeff_fin(ind)=val(1,2);
            ind=ind+1;
        end
        indice=find(handles.coeff_fin==max(handles.coeff_fin));
        handles.coefficient_correlation=max(handles.coeff_fin);
        
        % Affichage des 2 signaux superposés
        debut_fen=debut_fen_inter+indice(1)-1;
        fin_fen=debut_fen+length(handles.signalB_sous);
        handles.fenetre=[debut_fen/handles.freqA fin_fen/handles.freqA-1/handles.freqA];
        waitbar(0.5)
        temps_handles.fenetreA=max(find(handles.t_A<handles.fenetre(1,1))):1:max(find(handles.t_A<handles.fenetre(1,2)));
        temps_handles.fenetre=handles.fenetre(1,1):1/handles.freqA:handles.fenetre(1,2);
        fig(handles.numero)=figure('Name', ['Coefficient de correlation: ', num2str(handles.coefficient_correlation)], 'Position', [50,100, 800,500]);
        plot(temps_handles.fenetre,handles.signalA_norm(temps_handles.fenetreA),'b');
        hold on
        plot(temps_handles.fenetre, handles.signalB_norm,'r');
        uicontrol( ...
            'Parent', fig(handles.numero), ...
            'Style', 'text', ...
            'FontSize', 10, ...
            'String', ['Coefficient de correlation : ', num2str(handles.coefficient_correlation)], ...
            'Position', [250, 470, 300, 25] ...
            );
        uicontrol( ...
            'Parent', fig(handles.numero), ...
            'Style', 'pushbutton', ...
            'FontSize', 10, ...
            'String', 'Extraire', ...
            'Position', [350, 5, 80, 25], ...
            'Callback',{@valider_correlation,handles} ...
            );
        waitbar(1)
        close(h)
    end
end

%% Valider la correlation et extraire le signal VisuResp correspondant

function valider_correlation(obj,~,handles)

t_L2=handles.fenetre(1)*handles.freqA:handles.freqA/handles.freqB:handles.fenetre(2)*handles.freqA;
signalB_sur= interp1(handles.fenetre(1)*handles.freqA:1:handles.fenetre(2)*handles.freqA,handles.signalA(handles.fenetre(1)*handles.freqA:1:handles.fenetre(2)*handles.freqA),t_L2,'spline');
save([handles.chemin_nom_signalB(1:end-4),'_VisuResp.mat'], 'signalB_sur')
h = questdlg('Le signal de Biopac a été remplacé avec succès. Voulez-vous fermer les fenetres?','Success');
if strcmp(h,'Yes')
close all
end
end