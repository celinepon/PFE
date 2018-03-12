% Cette fonction permet de rechercher dans un signal (signalA), un autre
% signal contenant possiblement des artefacts (signalB). Elle crée un nouveau
% fichiercontenant la portion du signalA correspondante.

function interface_correlation_signaux_Biopac_VisuResp
close all
clear all
clc
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

%% Cree l'interface utilsateur
scrn_size = get(0, 'ScreenSize');
xmiddle = scrn_size(3) / 2;
ymiddle = scrn_size(4) / 2;
sizex = 1250;
sizey = 850;
%%%%%%%%%%%%%%%%
f = figure( ...
    'Name', 'Fenetrage des signaux VisuResp et Biopac', ...
    'Visible', 'on', ...
    'Position', [xmiddle - (sizex / 2), ymiddle - (sizey / 2), sizex, sizey], ...
    'NumberTitle', 'Off' ...
    );

widthsignal = 810;
heightsignal = 380;


%%%%%%%%%%%%%%%%%%%%%% Panels
% panel des signaux du Biopac
psignalB = uipanel( ...
    'Parent', f, ...
    'Title', 'Signal Biopac (signal B)', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 465, widthsignal, heightsignal] ...
    );
% panel du signal thoracique du Biopac
psignalBthorax = uipanel( ...
    'Parent', psignalB, ...
    'Title', 'Signal Thorax', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 185, 800, 180] ...
    );
% panel du signal abdominal du Biopac
psignalBabdo = uipanel( ...
    'Parent', psignalB, ...
    'Title', 'Signal Abdomen', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 5, 800, 180] ...
    );
% panel des signaux du VisuResp
psignalA = uipanel( ...
    'Parent', f, ...
    'Title', 'Signal VisuResp (signal A)', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 80, widthsignal, heightsignal] ...
    );
% panel du signal thoracique du VisuResp
psignalAthorax = uipanel( ...
    'Parent', psignalA, ...
    'Title', 'Signal Thorax', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 185, 800, 180] ...
    );
% panel du signal abdominal du VisuResp
psignalAabdo = uipanel( ...
    'Parent', psignalA, ...
    'Title', 'Signal Abdomen', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 5, 800, 180] ...
    );
% panel du répertoire
prepertoire = uipanel( ...
    'Parent', f, ...
    'Title', 'Repertoire', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [850, 370, 350, 480] ...
    );

% panel des boutons de correlation
pcorrelation = uipanel( ...
    'Parent', f, ...
    'Title', 'Correlation', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 10, widthsignal, 70] ...
    );
% panel des coefficients de correlation
pvaleur = uipanel( ...
    'Parent', f, ...
    'Title', 'Valeurs', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [815, 10, 430, 350] ...
    );

%%%%%%%%%%%%%%%%%%%%% Axes des grapghes

%Graphe du signal B thorax
axe_signal_B_Thorax = axes( ...
    'Parent', psignalBthorax, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [30, 25, 700, 130] ...
    );
%temps_B_thorax = 
uicontrol('Parent',psignalBthorax,'Style','text','FontSize',8,'String','temps (s)','Position',[735 14 60 25]);


%Graphe du signal B abdomen
axe_signal_B_Abdo = axes( ...
    'Parent', psignalBabdo, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [30, 25, 700, 130] ...
    );
%temps_B_abdo = 
uicontrol('Parent',psignalBabdo,'Style','text','FontSize',8,'String','temps (s)','Position',[735 14 60 25]);


%Graphe du signal A thorax
axe_signal_A_Thorax = axes( ...
    'Parent', psignalAthorax, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Tag','Tho',...
    'Position', [30, 25, 700, 130] ...
    );
%temps_A_thorax = 
uicontrol('Parent',psignalAthorax,'Style','text','FontSize',8,'String','temps (s)','Position',[735 14 60 25]);

%Graphe du signal A abdomen
axe_signal_A_Abdo = axes( ...
    'Parent', psignalAabdo, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'Tag','Abd',...
    'XTick', [], ...
    'Position', [30, 25, 700, 130] ...
    );

%temps_A_abdo = 
uicontrol(...
    'Parent',psignalAabdo,...
    'Style','text',...
    'FontSize',8,...
    'String','temps (s)',...
    'Position',[735 14 60 25]);

% Graphe des coefficients de correlation
axe_corr = axes( ...
    'Parent', pvaleur , ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Tag','Cor',...
    'NextPlot','add',...
    'Position', [40, 40, 380, 260] ...
    );

%temps_corr = 
uicontrol(...
    'Parent',pvaleur,...
    'Style','text',...
    'FontSize',8,...
    'String','1-pvalue',...
    'Position',[350 6 50 13]);

%%%%%%%%%%%%%%%%%%%%% Boutons

%affiche les fichiers presents dans le dossier selectionne

listedossier = uicontrol(...
    'Parent',prepertoire,...
    'Style','listbox',...
    'Position',[23 160 300 240],...
    'Callback',{@filelist_callback});

% selectionne le dossier des fichiers Biopac
%selectdossierBiopac = 
uicontrol(...
    'Parent',prepertoire,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Selectionner un dossier Biopac',...
    'Position',[50 415 250 40],...
    'ToolTipString', 'Selectionnez un dossier contenant des fichiers .mat sortant du Biopac',...
    'Callback',{@selectdir_callback});
%selectionne le ficher VisuResp
%selectfichierVisurep = 
uicontrol(...
    'Parent',prepertoire,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Selectionner un fichier Visuresp',...
    'Position',[50 85 250 30],...
    'ToolTipString', 'Selectionnez un fichier de type .rcg sortant de Visuresp',...
    'Callback',{@selectfile_callback});
% charge le signal Biopac selectionne dans le repertoire
OK = uicontrol(...
    'Parent',prepertoire,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','OK',...
    'Position',[50 125 250 30],...
    'ToolTipString', 'Selectionnez un dossier contenant des fichiers .mat sortant du Biopac',...
    'enable','off',...
    'Callback',{@afficherGraph});
% convertit le fichier Visuresp (.rcg) en fichier .mat
convertir = uicontrol(...
    'Parent',prepertoire,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Conversion en .mat',...
    'Position',[50 10 250 30],...
    'ToolTipString', 'Convertit le fichier Visuresp (.rcg) en fichier .mat',...
    'enable','off',...
    'Callback',{@conversion_rcg2mat});

% affiche le chemin du fichier visuresp selectionne
cheminfichierVisuresp = uicontrol(...
    'Parent',prepertoire,...
    'Style','text',...
    'FontSize',12,...
    'String',' ',...
    'Position',...
    [10 50 330 27],...
    'BackgroundColor','w');
% lance la recherche du maximum des coefficients de correlation
lancercorrelation = uicontrol(...
    'Parent',pcorrelation,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Trouver correlation',...
    'Position',[100 10 180 40],...
    'enable','off',...
    'Callback',{@calcul_correlation});
% valide et extrait la fenetre du signal du VisuResp correspondant au
% signal Biopac
valider = uicontrol(...
    'Parent',pcorrelation,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Extraire',...
    'Position',[500 10 100 40],...
    'enable','off',...
    'ToolTipString', 'Validation de la correspondance entre les sequences Visuresp et Biopac',...
    'Callback',{@valider_correlation}); 
%affiche la valeur maximum du coefficient de correlation des signaux
%thoraciques
%corr_thorax_text =
uicontrol(...
    'Parent',pvaleur,...
    'Style','text',...
    'FontSize',9,...
    'String','Correlation Thorax :',...
    'Position',[2 305 110 25]);

corr_thorax_valeur = uicontrol(...
    'Parent',pvaleur,...
    'Style','text',...
    'FontSize',9,...
    'String','',...
    'Position',[120 305 50 25]);
%affiche la valeur maximum du coefficient de correlation des signaux
%abdominaux
%corr_abdo_text = 
uicontrol(...
    'Parent',pvaleur,...
    'Style','text',...
    'FontSize',9,...
    'String','Correlation Abdominal :',...
    'Position',[180 305 150 25]);

corr_abdo_valeur = uicontrol(...
    'Parent',pvaleur,...
    'Style','text',...
    'String','',...
    'FontSize',9,...
    'Position',[330 305 50 25]);

% zone de texte concernant la frequence d'echantillonnage des signaux
% Biopac
freqLab = uicontrol(...
    'Parent',psignalBthorax,...
    'Style','edit',...
    'FontSize',9,...
    'String','1',...
    'Position',[735 100 60 25],...
    'Callback',{@afficherGraph});

%freqechB =
uicontrol(...
    'Parent',psignalBthorax,...
    'Style','text',...
    'FontSize',9,...
    'String','Fech (Hz) : ',...
    'Position',[735 125 60 25]);
% zone de texte concernant la frequence d'echantillonnage des signaux
% VisuResp
freqVisu = uicontrol(...
    'Parent',psignalAthorax,...
    'Style','edit',...
    'FontSize',9,...
    'String','40',...
    'Position',[735 100 60 25],...
    'Callback',{@afficherVisurep});

%freqechA = 
uicontrol(...
    'Parent',psignalAthorax,...
    'Style','text',...
    'FontSize',9,...
    'String','Fech (Hz) : ',...
    'Position',[735 125 60 25]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lines


%Affichage des donnees sur les differents graphiques.
%Initialisation des lignes pour afficher les donnees sur les graphiques

orange=[255 128 0]/255;
bleu_clair=[51 203 255]/255;
line_signalA_Thorax = line(0, 0, 'Color', 'blue', 'LineWidth', 1, 'Parent', axe_signal_A_Thorax);
line_signalA_Abdo= line(0, 0, 'Color', 'red', 'LineWidth', 1, 'Parent', axe_signal_A_Abdo);
line_signalB_Thorax = line(0, 0, 'Color', bleu_clair, 'LineWidth', 1, 'Parent', axe_signal_B_Thorax);
line_signalB_Abdo = line(0, 0, 'Color', orange, 'LineWidth', 1, 'Parent', axe_signal_B_Abdo);
line_signalA_Thorax_super = line(0, 0, 'Color', bleu_clair, 'LineWidth', 1, 'Parent', axe_signal_A_Thorax);
line_signalA_Abdo_super= line(0, 0, 'Color', orange, 'LineWidth', 1, 'Parent', axe_signal_A_Abdo);


scatter_corr_Abdo = scatter(0,0,'r','filled', 'Marker', 'o','MarkerFaceAlpha', 0.5, 'MarkerEdgeColor', [1, 1, 1], 'Parent', axe_corr,'Tag','CoA','Visible','off','buttondownfcn',{@button_down_function});
scatter_corr_Thorax = scatter(0,0,'b','filled', 'Marker', 'o','MarkerFaceAlpha',0.5, 'MarkerEdgeColor', [1, 1, 1], 'Parent', axe_corr,'Tag','CoT','Visible','off','buttondownfcn',{@button_down_function});
scatter_corr_Select = scatter(0,0,'black','filled', 'Marker', 'o', 'MarkerEdgeColor', [0, 0, 0], 'Parent', axe_corr,'Visible','off','Tag','CoA','buttondownfcn',{@button_down_function});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialisation des variables
handles.dir='';
handles.file_list='';
handles.chemin='';
handles.filename='';
handles.grabbed=-1;
handles.xlim_tho=-1;
handles.xlim_abdo=-1;
handles.fichierLabChart=-1;
handles.thorax_L=-1;
handles.thorax_C=-1;
handles.abdomen_L=-1;
handles.abdomen_C=-1;
handles.volume_C=-1;
handles.debit_C=-1;
fenetre_tho=-1;
fenetre_abdo=-1;
temps_fenetre_tho=-1;
temps_fenetre_abdo=-1;
r_thorax(:)=-1;
r_abdo(:)=-1;
t_C=-1;
t_L=-1;
freq_C='';
freq_L='';
decal=-1;
decal2=-1;
handles.thorax_L_sous=-1;
handles.abdomen_L_sous=-1;
intercorr_calculee=0;
r_thorax(1)=-1;
fenetre_corr_x=-1;
fenetre_corr_y=-1;
pval_tho(1)=-1;
r_abdo(1)=-1;
pval_abdo(1)=-1;
pas=-1;
maxi_pval=-1;
maxi_val=-1;


set([axe_signal_A_Thorax, axe_signal_A_Abdo,axe_corr], 'buttondownfcn', {@button_down_function});
set(f, 'WindowButtonUpFcn', {@button_up_function});
set(f, 'WindowButtonMotionFcn', {@button_motion_function});


%% Drag and Drop des signaux superposes lors de l'intercorrelation

%fonction declenche lors d'un clic (bouton enfonce) sur les graohe du
%visuresp, le graphe des coefficients de correlation et sur les points des
%coefficients de correlation, apres calcul de la correlation.
    function button_down_function(obj, ~)
        if get(obj,'Tag')=='Tho'&intercorr_calculee
            handles.grabbed=1;
            ps = get(gca, 'CurrentPoint');
            decal=ps(1,1);
        elseif get(obj, 'Tag')=='Abd'&intercorr_calculee
            handles.grabbed=2;
            ps = get(gca, 'CurrentPoint');
            decal=ps(1,1);
        elseif get(obj, 'Tag')=='CoA'&intercorr_calculee
            handles.grabbed=3;
            ps = get(gca, 'CurrentPoint');
            indice=find(r_abdo<ps(1,2)+0.001&r_abdo>ps(1,2)-0.001);
            if ~isempty(indice)
                indice=indice(1);
                selection_point(indice,0);
                r_select=r_abdo(indice);
                pval_select=pval_abdo(indice);
                set(scatter_corr_Select,'XData',pval_select,'YData',r_select,'Visible','on','MarkerFaceColor','r','LineWidth',1)
            end
        elseif get(obj, 'Tag')=='CoT'&intercorr_calculee
            handles.grabbed=3;
            ps = get(gca,'CurrentPoint');
            indice=find(r_thorax<ps(1,2)+0.001&r_thorax>ps(1,2)-0.001);
            if ~isempty(indice)
                indice=indice(1);
                selection_point(indice,0);
                set(scatter_corr_Select,'XData',pval_tho(indice),'YData',r_thorax(indice),'Visible','on','MarkerFaceColor','b','LineWidth',1)
            end
        elseif get(obj, 'Tag')=='Cor'&intercorr_calculee
            handles.grabbed=4;
            ps = get(gca, 'CurrentPoint');
            decal2(1,1)=ps(1,1);
            decal2(1,2)=ps(1,2);
        end
    end

%fonction declenche lors du deplacement de la souris, en clic enfonce, qui
%va deplacer l'axe des graphes du visuresp ou l'axe du graphe des
%coefficent de correlation, selon l'objet selectionne
    function button_motion_function(~, ~)
        if handles.grabbed==-1 |handles.grabbed==3
        elseif handles.grabbed==2 | handles.grabbed==1
            ps = get(gca, 'CurrentPoint');
            fenetre_tho=fenetre_tho-((ps(1,1)-decal)*15)/freq_C;
            fenetre_abdo=fenetre_tho;
            temps_fenetre_tho=fenetre_tho(1,1):1/freq_C:fenetre_tho(1,2);
            temps_fenetre_abdo=temps_fenetre_tho;
            
            set(axe_signal_A_Thorax,'XLim',fenetre_tho)
            set(axe_signal_A_Abdo,'XLim',fenetre_abdo)
            set(line_signalA_Thorax_super, 'XData',temps_fenetre_tho, 'YData', (handles.thorax_L_sous-(min(handles.thorax_L_sous)))/(max(handles.thorax_L_sous)-min(handles.thorax_L_sous)))
            set(line_signalA_Abdo_super, 'XData',temps_fenetre_abdo, 'YData', (handles.abdomen_L_sous-(min(handles.abdomen_L_sous)))/(max(handles.abdomen_L_sous)-min(handles.abdomen_L_sous)))
            decal=ps(1,1);
        elseif handles.grabbed==4
            ps = get(gca, 'CurrentPoint');
            fenetre_corr_x=fenetre_corr_x-((ps(1,1)-decal2(1,1)));
            fenetre_corr_y=fenetre_corr_y-((ps(1,2)-decal2(1,2)));
            set(axe_corr,'XLim',fenetre_corr_x,'YLim',fenetre_corr_y)
            decal2(1,1)=ps(1,1);
            decal2(1,2)=ps(1,2);
        end
    end
%fonction declenche a la fin d'un clic (bouton releve)
    function button_up_function(~, ~)
        handles.grabbed=-1;
    end

%% Liste contenant tous les fichiers du repertorie
    function filelist_callback(source,~)
        str = get(source, 'String');
        val = get(source,'Value');
        file = char(str(val));
        handles.filename = file;
    end

%% Selection du dossier contenant les enregistrements Biopac
    function selectdir_callback(~,~)
        dir_name = uigetdir('','Selectionner un dossier de fichier .mat ou .rcg');
        if dir_name ~= 0
            handles.dir = dir_name;
            search_name = [dir_name,'/*.mat'];
            search_name2=[dir_name,'/*.rcg'] ;
            files = struct2cell(dir(search_name));
            files2=struct2cell(dir(search_name2));
            handles.file_list = [files(1,:),files2(1,:)]';
            if length(handles.file_list)~=0
                set(listedossier,'String', handles.file_list);
                handles.filename = char(handles.file_list(1));
                set(OK,'Enable','on')
            else
                msgbox('Le dossier selectionne ne contient pas de fichier .mat ou .rcg', 'Title', 'help')
            end
        end
        intercorr_calculee=0;
    end

%% Selection du fichier contenant l'enregistrement continu de Visuresp
    function selectfile_callback(~,~)
        [file_name, pathName] = uigetfile({'*.*';'*.mat';'*.rcg'},'Selectionner un fichier VisuResp .mat ou .rcg');
        handles.thorax_C=-1;
        handles.abdomen_C=-1;
        if file_name ~= 0
            file = file_name;
            handles.chemin = strcat(pathName,file_name);
            set(cheminfichierVisuresp,'String', file)
            [~, ~, extension] = fileparts(file);
            if extension == '.mat'
                fichierComplet=importdata(handles.chemin);
                if isfield(fichierComplet,'THO')
                    handles.thorax_C=fichierComplet.THO(1:length(fichierComplet.THO));
                    handles.abdomen_C=fichierComplet.ABD(1:length(fichierComplet.ABD));
                elseif isfield(fichierComplet,'data')
                    handles.thorax_C=fichierComplet.data(1:length(fichierComplet.data),3);
                    handles.abdomen_C=fichierComplet.data(1:length(fichierComplet.data),4);
                else
                    msgbox('Le contenu de ce fichier .mat n"est pas structure de facon adequate (data.data) ', 'Title', 'help')
                end
            elseif extension == '.rcg'
                delimiterIn_C = '\t';
                headerlinesIn_C = 38;
                fichierComplet=importdata(handles.chemin,delimiterIn_C,headerlinesIn_C);
                handles.thorax_C=fichierComplet.data(1:length(fichierComplet.data),1);
                handles.abdomen_C=fichierComplet.data(1:length(fichierComplet.data),2);
                handles.volume_C=fichierComplet.data(1:length(fichierComplet.data),11);
                handles.debit_C=fichierComplet.data(1:length(fichierComplet.data),12);
            else
                msgbox('Le format de fichier n"est pas supportee, utiliser des fichiers .mat ou .rcg', 'Title', 'help')
            end
            longueur_signal_C=length(handles.thorax_C);
            %affichage
            freq_C=40; %a changer si sur-echantillonnage du signal
            t_C=0:1/freq_C:(longueur_signal_C/freq_C)-1/freq_C;
            set(line_signalA_Thorax, 'XData',  t_C, 'YData', handles.thorax_C)
            set(line_signalA_Abdo, 'XData',  t_C, 'YData', handles.abdomen_C)
            set(axe_signal_A_Thorax,'XLim', [min(t_C), max(t_C)])
            set(axe_signal_A_Abdo,'XLim', [min(t_C), max(t_C)])
            set(line_signalA_Thorax_super, 'Visible','off')
            set(line_signalA_Abdo_super,  'Visible','off')
            axe_signal_A_Thorax.XAxis.TickValuesMode ='auto';
            axe_signal_A_Abdo.XAxis.TickValuesMode ='auto';
            axe_signal_A_Thorax.YAxis.TickValuesMode ='auto';
            axe_signal_A_Abdo.YAxis.TickValuesMode ='auto';
            set(convertir,'enable','on')
        end
        if length(handles.thorax_L)>2 & length(handles.thorax_C)>2
            set(lancercorrelation,'enable','on');
        end
        intercorr_calculee=0;
    end

%% Affichage des signaux
%permet d'afficher sur les graphiques les enregistrements du signal b
%(biopac) en appuyant sur Ok
    function afficherGraph(~, ~)
        handles.thorax_L=-1;
        handles.abdomen_L=-1;
        filename_L = [handles.dir, '\', handles.filename];
        handles.fichierLabChart= importdata(filename_L);
        [~, ~, extension] = fileparts(handles.filename);
        if extension == '.mat'
            handles.fichierLabChart=importdata(filename_L);
            if isfield(handles.fichierLabChart,'THOd')
                handles.thorax_L=handles.fichierLabChart.THOd(1:length(handles.fichierLabChart.THOd));
                handles.abdomen_L=handles.fichierLabChart.ABDd(1:length(handles.fichierLabChart.ABDd));
            elseif isfield(handles.fichierLabChart,'data')
                handles.thorax_L=handles.fichierLabChart.data(1:length(handles.fichierLabChart.data),3);
                handles.abdomen_L=handles.fichierLabChart.data(1:length(handles.fichierLabChart.data),4);
            else
                msgbox('Le contenu de ce fichier .mat n"est pas structure de facon adequate (data.data) ', 'Title', 'help')
            end
        elseif extension == '.rcg'
            delimiterIn_C = '\t';
            headerlinesIn_C = 38;
            handles.fichierLabChart=importdata(filename_L,delimiterIn_C,headerlinesIn_C);
            handles.thorax_L=handles.fichierLabChart.data(1:length(handles.fichierLabChart.data),1);
            handles.abdomen_L=handles.fichierLabChart.data(1:length(handles.fichierLabChart.data),2);
        else
            msgbox('Le format de fichier n"est pas supporte, utiliser des fichiers .mat ou .rcg', 'Title', 'help')
        end
        longueur_signal_L=length(handles.thorax_L);
        
        %affichage
        freq_L=str2double(get(freqLab,'string'));
        t_L=0:1/freq_L:(longueur_signal_L/freq_L-1/freq_L);
        set(line_signalB_Thorax, 'XData',  t_L, 'YData', handles.thorax_L)
        set(line_signalB_Abdo, 'XData',  t_L, 'YData',handles.abdomen_L)
        set(line_signalA_Abdo_super,'Visible','off')
        set(line_signalA_Thorax_super,'Visible','off')
        set(axe_signal_B_Thorax,'XLim', [min(t_L), max(t_L)])
        set(axe_signal_B_Abdo,'XLim', [min(t_L), max(t_L)])
        axe_signal_B_Thorax.XAxis.TickValuesMode ='auto';
        axe_signal_B_Abdo.XAxis.TickValuesMode ='auto';
        axe_signal_B_Thorax.YAxis.TickValuesMode ='auto';
        axe_signal_B_Abdo.YAxis.TickValuesMode ='auto';
        set(valider,'enable','off');
        if length(handles.thorax_C)>2
            set(axe_signal_A_Thorax,'XLim', [min(t_C), max(t_C)])
            set(axe_signal_A_Abdo,'XLim', [min(t_C), max(t_C)])
        end
        if  length(handles.thorax_L)>2 & length(handles.thorax_C)>2
            set(lancercorrelation,'enable','on');
        end
    end

%permet d'afficher sur les graphiques les enregistrements du signal A
%(visresp) en appuyant modifiant la Fech
    function afficherVisurep(~, ~)
        longueur_signal_C=length(handles.thorax_C);
        %affichage
        freq_C=str2double(get(freqVisu,'string'))
        t_C=0:1/freq_C:(longueur_signal_C/freq_C)-1/freq_C;
        set(line_signalA_Thorax, 'XData',  t_C, 'YData', handles.thorax_C)
        set(line_signalA_Abdo, 'XData',  t_C, 'YData', handles.abdomen_C)
        set(axe_signal_A_Thorax,'XLim', [min(t_C), max(t_C)])
        set(axe_signal_A_Abdo,'XLim', [min(t_C), max(t_C)])
        set(valider,'enable','off');
        if length(handles.thorax_L)>2 & length(handles.thorax_C)>2
            set(lancercorrelation,'enable','on');
        end
    end

%% Calcul des coefficients de correlation

    function calcul_correlation(~,~)
        if get(freqLab,'String')=='1'
            msgbox('La frequence des fichiers Biopac est incorrecte.', 'Title', 'help')
        else
            h = waitbar(0,'Please wait...');
            r_thorax=0;
            r_abdo=0;
            val='';
            fenetre_tho=0;
            fenetre_abdo=0;
            debut_fen_tho=0;
            debut_fen_abdo=0;
            pval_tho=-1;
            pval_abdo=-1;
            
            %sur-echantillonnage
            freq_surech=freq_C;
            length(handles.thorax_L)
            t_L2=0:1/freq_surech:(length(handles.thorax_L)/freq_L-1/freq_L);
            handles.thorax_L_sous= interp1(t_L,handles.thorax_L,t_L2,'spline');
            handles.abdomen_L_sous= interp1(t_L,handles.abdomen_L,t_L2,'spline');
            length(handles.thorax_L_sous)
            %calcul 1ere fenetre (pas de 5 pourcent)
            pas=floor(0.05*length(handles.thorax_L_sous));
            ind=1;
            for k=1:pas:length(handles.thorax_C)-length(handles.thorax_L_sous)-1
                [val,p]=corrcoef(handles.thorax_L_sous,handles.thorax_C(k:length(handles.thorax_L_sous)+k-1));
                r_thorax(ind)=val(1,2);
                pval_tho(ind)=1-p(1,2);
                [val,p]=corrcoef(handles.abdomen_L_sous,handles.abdomen_C(k:length(handles.abdomen_L_sous)+k-1));
                r_abdo(ind)=val(1,2);
                pval_abdo(ind)=1-p(1,2);
                ind=ind+1;
            end
            waitbar(0.3)
            
            %calcul 2e fenetre (point par point) sur la fenetre
            %trouvee precedemment, + ou - le pas.
            indice_tho =find(r_thorax==max(r_thorax));
            maxi_val=max(max(r_abdo),max(r_thorax));
            maxi_pval=max(max(pval_abdo),max(pval_tho));
            indice_abdo =find(r_abdo==max(r_abdo));
            if indice_tho==1
                debut_fen_inter_tho=1;
                fin_fen_inter_tho=length(handles.thorax_L_sous);
            elseif indice_tho==2
                debut_fen_inter_tho=pas;
                fin_fen_inter_tho=pas+length(handles.thorax_L_sous);
            elseif indice_tho==length(r_abdo)
                debut_fen_inter_tho=(indice_tho-2)*pas;
                fin_fen_inter_tho=handles.thorax_C(end);
            else
                debut_fen_inter_tho=(indice_tho-2)*pas;
                fin_fen_inter_tho=debut_fen_inter_tho+length(handles.thorax_L_sous)+pas;
            end
            if indice_abdo==1
                debut_fen_inter_abdo=1;
                fin_fen_inter_abdo=length(handles.abdomen_L_sous);
            elseif indice_abdo==2
                debut_fen_inter_abdo=pas;
                fin_fen_inter_abdo=pas+length(handles.abdomen_L_sous);
            elseif indice_abdo==length(r_abdo)
                debut_fen_inter_abdo=(indice_abdo-2)*pas;
                fin_fen_inter_abdo=handles.thorax_C(end);
            else
                debut_fen_inter_abdo=(indice_abdo-2)*pas;
                fin_fen_inter_abdo=debut_fen_inter_abdo+pas+length(handles.abdomen_L_sous);
            end
            r_thorax_fin=0;
            r_abdo_fin=0;
            ind=1;
            waitbar(0.5)
            for k=debut_fen_inter_tho:1:fin_fen_inter_tho-length(handles.thorax_L_sous)
                val=corrcoef(handles.thorax_L_sous,handles.thorax_C(k:length(handles.thorax_L_sous)+k-1));
                r_thorax_fin(ind)=val(1,2);
                ind=ind+1;
            end
            ind=1;
            for k=debut_fen_inter_abdo:1:fin_fen_inter_abdo-length(handles.abdomen_L_sous)
                val=corrcoef(handles.abdomen_L_sous,handles.abdomen_C(k:length(handles.abdomen_L_sous)+k-1));
                r_abdo_fin(ind)=val(1,2);
                ind=ind+1;
            end
            waitbar(1)
            
            % selection de la fenetre presentant le maximum de correlation
            indice_tho_fin =find(r_thorax_fin==max(r_thorax_fin));
            debut_fen_tho=debut_fen_inter_tho+indice_tho_fin(1)-1;
            fin_fen_tho=debut_fen_tho+length(handles.thorax_L_sous);
            fenetre_tho=[debut_fen_tho/freq_C fin_fen_tho/freq_C-1/freq_C];
            indice_abdo_fin =find(r_abdo_fin==max(r_abdo_fin));
            debut_fen_abdo=debut_fen_inter_abdo+indice_abdo_fin(1)-1;
            fin_fen_abdo=debut_fen_abdo+length(handles.abdomen_L_sous);
            fenetre_abdo=[debut_fen_abdo/freq_C fin_fen_abdo/freq_C-1/freq_C];
            a=-1;
            if max(r_thorax_fin)<max(r_abdo_fin)
                a=1;
                fenetre_tho=fenetre_abdo;
                ind=1;
                for k=debut_fen_inter_abdo:1:fin_fen_inter_abdo-length(handles.thorax_L_sous)
                    val=corrcoef(handles.thorax_L_sous,handles.thorax_C(k:length(handles.thorax_L_sous)+k-1));
                    r_thorax_fin(ind)=val(1,2);
                    ind=ind+1;
                end
            else
                a=2;
                fenetre_abdo=fenetre_tho;
                ind=1;
                for k=debut_fen_inter_tho:1:fin_fen_inter_tho-length(handles.thorax_L_sous)
                    val=corrcoef(handles.abdomen_L_sous,handles.abdomen_C(k:length(handles.abdomen_L_sous)+k-1));
                    r_abdo_fin(ind)=val(1,2);
                    ind=ind+1;
                end
            end
            
            % affichage des signaux Biopacet VisuResp superposes sur la
            % fenetre adequate
            temps_fenetre_tho=fenetre_tho(1,1):1/freq_C:fenetre_tho(1,2);
            temps_fenetre_abdo=fenetre_abdo(1,1):1/freq_C:fenetre_abdo(1,2);
            set(line_signalA_Thorax_super, 'XData',temps_fenetre_tho, 'YData', (handles.thorax_L_sous-(min(handles.thorax_L_sous)))/(max(handles.thorax_L_sous)-min(handles.thorax_L_sous)),'Visible','on')
            set(line_signalA_Abdo_super, 'XData', temps_fenetre_abdo, 'YData', (handles.abdomen_L_sous-(min(handles.abdomen_L_sous)))/(max(handles.abdomen_L_sous)-min(handles.abdomen_L_sous)),'Visible','on')
            set(line_signalA_Thorax, 'XData', t_C, 'YData', (handles.thorax_C-(min(handles.thorax_C)))/(max(handles.thorax_C)-min(handles.thorax_C)))
            set(line_signalA_Abdo, 'XData', t_C, 'YData', (handles.abdomen_C-(min(handles.abdomen_C)))/(max(handles.abdomen_C)-min(handles.abdomen_C)))
            set(axe_signal_A_Thorax, 'XLim', fenetre_tho)
            set(axe_signal_A_Abdo, 'XLim', fenetre_abdo)
            set(valider,'enable','on');
            set(corr_abdo_valeur,'String',round(max(r_abdo_fin),4))
            set(corr_thorax_valeur,'String',round(max(r_thorax_fin),4))
            intercorr_calculee=1;
            
            % affichage du graphe des coefficients de correlation en fonction de la 1-pvaleur
            set(scatter_corr_Abdo,'XData',pval_abdo,'YData',r_abdo,'Visible','on')
            set(scatter_corr_Thorax,'XData',pval_tho,'YData',r_thorax,'Visible','on')
            set(scatter_corr_Select,'XData',pval_tho,'YData',r_thorax,'Visible','off')
            fenetre_corr_x=[0.99*abs(maxi_pval) abs(maxi_pval)*1.01];
            fenetre_corr_y=[0.8*maxi_val maxi_val*1.01];
            set(axe_corr,'XLim',fenetre_corr_x,'YLim',fenetre_corr_y)
            if a==1
                set(scatter_corr_Select,'XData',pval_abdo(indice_abdo),'YData',r_abdo(indice_abdo),'Visible','on','MarkerFaceColor','r','LineWidth',1)
            else
                set(scatter_corr_Select,'XData',pval_tho(indice_tho),'YData',r_thorax(indice_tho),'Visible','on','MarkerFaceColor','b','LineWidth',1)
            end
            axe_corr.XAxis.TickValuesMode ='auto';
            axe_corr.YAxis.TickValuesMode ='auto';
            close(h);
        end
    end

% Changement de fenetre de superposition des signaux Biopac et Visuresp
% en fonction du point (coefficient-pvalue) selectionne

    function selection_point(indice,~)
        h = waitbar(0,'Please wait...');
        % calcul de la fenetre associe au point
        temps_fenetre_tho=-1;
        fenetre_tho=-1;
        fenetre_abdo=-1;
        temps_fenetre_abdo=-1;
        if indice==1
            debut_fen_inter=1;
            fin_fen_inter=length(handles.thorax_L_sous);
        elseif indice==2
            debut_fen_inter=pas;
            fin_fen_inter=pas+length(handles.thorax_L_sous);
        elseif indice==length(r_abdo)
            debut_fen_inter=(indice-2)*pas;
            fin_fen_inter=handles.thorax_C(end);
        else
            debut_fen_inter=(indice-2)*pas;
            fin_fen_inter=(indice)*pas+length(handles.thorax_L_sous);
        end
        waitbar(0.3)
        r_thorax_fin=0;
        r_abdo_fin=0;
        ind=1;
        
        %calcul des maximums des coefficients de correlation des signaux abdominaux
        %et thoaciques dans cette fenetre
        for k=debut_fen_inter:1:fin_fen_inter-length(handles.thorax_L_sous)
            val=corrcoef(handles.thorax_L_sous,handles.thorax_C(k:length(handles.thorax_L_sous)+k-1));
            r_thorax_fin(ind)=val(1,2);
            val=corrcoef(handles.abdomen_L_sous,handles.abdomen_C(k:length(handles.abdomen_L_sous)+k-1));
            r_abdo_fin(ind)=val(1,2);
            ind=ind+1;
        end
        
        % calcul de la fenetre presentant le maximum du coefficient de
        % correlation
        indice_tho =find(r_thorax_fin==max(r_thorax_fin));
        max_tho=max(r_thorax_fin);
        debut_fen_tho=debut_fen_inter+indice_tho(1)-1;
        fin_fen_tho=debut_fen_tho+length(handles.thorax_L_sous);
        fenetre_tho=[debut_fen_tho/freq_C fin_fen_tho/freq_C-1/freq_C];
        waitbar(0.5)
        indice_abdo =find(r_abdo_fin==max(r_abdo_fin));
        max_abdo= max(r_abdo_fin);
        debut_fen_abdo=debut_fen_inter+indice_abdo(1)-1;
        fin_fen_abdo=debut_fen_abdo+length(handles.abdomen_L_sous);
        fenetre_abdo=[debut_fen_abdo/freq_C fin_fen_abdo/freq_C-1/freq_C];
        if max(r_thorax_fin)<max(r_abdo_fin)
            fenetre_tho=fenetre_abdo;
        else
            fenetre_abdo=fenetre_tho;
        end
        waitbar(1)
        fenetre_tho*freq_C
        % affichage des signaux Biopacet VisuResp superposes sur la
        % fenetre adequate
        temps_fenetre_tho=fenetre_tho(1,1):1/freq_C:fenetre_tho(1,2);
        temps_fenetre_abdo=fenetre_abdo(1,1):1/freq_C:fenetre_abdo(1,2);
        set(line_signalA_Thorax_super, 'XData',temps_fenetre_tho, 'YData', (handles.thorax_L_sous-(min(handles.thorax_L_sous)))/(max(handles.thorax_L_sous)-min(handles.thorax_L_sous)))
        set(line_signalA_Abdo_super, 'XData', temps_fenetre_abdo, 'YData', (handles.abdomen_L_sous-(min(handles.abdomen_L_sous)))/(max(handles.abdomen_L_sous)-min(handles.abdomen_L_sous)))
        set(line_signalA_Thorax, 'XData', t_C, 'YData', (handles.thorax_C-(min(handles.thorax_C)))/(max(handles.thorax_C)-min(handles.thorax_C)))
        set(line_signalA_Abdo, 'XData', t_C, 'YData', (handles.abdomen_C-(min(handles.abdomen_C)))/(max(handles.abdomen_C)-min(handles.abdomen_C)))
        set(axe_signal_A_Thorax, 'XLim', fenetre_tho)
        set(axe_signal_A_Abdo, 'XLim', fenetre_abdo)
        set(corr_abdo_valeur,'String',round(max_abdo,4))
        set(corr_thorax_valeur,'String',round(max_tho,4))
        intercorr_calculee=1;
        close(h)
    end

%% Valider et exporter la zone correpondant au Biopac dans le VisuResp
    function valider_correlation(~,~)
        h = waitbar(0,'Please wait...');
        % sur-echantillonnage de la zone VisuResp selectionnee
        t_L2=fenetre_tho(1)*freq_C:freq_C/freq_L:fenetre_tho(2)*freq_C;
        handles.thorax_L_sur= interp1(fenetre_tho(1)*freq_C:1:fenetre_tho(2)*freq_C,handles.thorax_C(fenetre_tho(1)*freq_C:1:fenetre_tho(2)*freq_C),t_L2,'spline');
        abdo_L_sur= interp1(fenetre_tho(1)*freq_C:1:fenetre_tho(2)*freq_C,handles.abdomen_C(fenetre_tho(1)*freq_C:1:fenetre_tho(2)*freq_C),t_L2,'spline');
        [~, ~, extension] = fileparts(handles.filename);
        waitbar(0.5)
        %creation de la structure du nouveau fichier
        if extension == '.mat'
            if isfield(handles.fichierLabChart,'data')
                fichier.hdr=handles.fichierLabChart.hdr;
                fichier.markers=handles.fichierLabChart.markers;
                fichier.data(1:length(handles.thorax_L_sur),3)=handles.thorax_L_sur;
                fichier.data(1:length(abdo_L_sur),2)=abdo_L_sur;
            else
                fichier.ABDd=abdo_L_sur;
                fichier.THOd=handles.thorax_L_sur;
            end
        else extension== '.rcg'
            fichier.data(l:length(handles.thorax_L_sur),1)=handles.thorax_L_sur;
            fichier.data(l:length(abdo_L_sur),2)=abdo_L_sur;
            fichier.delimiterIn_C=handles.fichierLabChart.delimiterIn_C;
            fichier.headerlinesIn_C=handles.fichierLabChart.headerlinesIn_C;
        end
        waitbar(0.8)
        % creation du nouveau fichier
        s=fichier;
        [file,path] = uiputfile('*.mat','Save As');
        save([path,'\',file], '-struct', 's')
        close(h)
        msgbox('Le signal de Biopac a ete remplace avec succes', 'Title', 'help')
    end

%% Conversion des fichiers .rcg en .mat
function conversion_rcg2mat(~,~)
nom_fichier=handles.chemin(1:end-4);
fig1=figure('position',[800 500 300 300]);

% creation de l'interface de selection des donnees a convertir
uicontrol(...
    'Parent',fig1,...
    'Style','text',...
    'FontSize',10,...
    'String','Sélectionnez les données que vous souhaitez convertir :',...
    'Position',...
    [0 260 280 40]);

thorax_box=uicontrol('style','checkbox','string','Thorax','FontSize',12, 'Position',[50 210 250 30]);
abdomen_box=uicontrol('style','checkbox','string','Abdomen','FontSize',12, 'Position',[50 170 250 30]);
volume_box=uicontrol('style','checkbox','string','Volume','FontSize',12, 'Position',[50 130 250 30]);
debit_box=uicontrol('style','checkbox','string','Debit','FontSize',12, 'Position',[50 90 250 30]);

uicontrol(...
    'Parent',fig1,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Conversion en .mat',...
    'Position',[30 20 120 30],...
    'ToolTipString', 'Convertit le fichier Visuresp (.rcg) en fichier .mat',...
    'enable','on',...
    'Callback',{@conversion2});
uicontrol(...
    'Parent',fig1,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Annuler',...
    'Position',[170 20 80 30],...
    'ToolTipString', 'Convertit le fichier Visuresp (.rcg) en fichier .mat',...
    'enable','on',...
    'Callback',{@annuler});

    function annuler(~,~)
        close
    end

    function conversion2 (~,~)    
        THO=handles.thorax_C;
        ABD=handles.abdomen_C;
        VolRecBrut=handles.volume_C;
        DebRec=handles.debit_C;
        if get(thorax_box,'Value')==1
            THO=handles.thorax_C;  else THO=0; end
        if get(abdomen_box,'Value')==1
            ABD=handles.abdomen_C;  else ABD=0; end
        if get(volume_box,'Value')==1
            VolRecBrut=handles.volume_C;  else VolRecBrut=0; end
        if get(debit_box,'Value')==1
            DebRec=handles.debit_C;  else DebRec=0; end
        
        if THO==0&ABD==0&VolRecBrut==0&DebRec==0
                msgbox('Aucune donnée n a ete selectionnee', 'Title', 'help')
        else
        nom_fichier=handles.chemin(1:end-4);
        save([nom_fichier,'.mat'],'THO','ABD','VolRecBrut','DebRec')
        close
        msgbox('Le signal a ete convertit avec succes', 'Title', 'help')
        end
    end
end
end