function interface
clear all
close all
clc

%% Create GUI structure
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

%%%%%%%%%%%%%%%%%
%               %
%   Panel for   %
%    signals    %
%               %
%%%%%%%%%%%%%%%%%

% variabe used to place the panel that will display the 4 waves
widthsignal = 825;
heightsignal = 380;


%%%%%%%%%%%%%%%%%%%%%% Panels
psignalB = uipanel( ...
    'Parent', f, ...
    'Title', 'Signal Biopac (signal B)', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 465, widthsignal, heightsignal] ...
    );
psignalBthorax = uipanel( ...
    'Parent', psignalB, ...
    'Title', 'Signal Thorax', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 185, 800, 180] ...
    );
psignalBabdo = uipanel( ...
    'Parent', psignalB, ...
    'Title', 'Signal Abdomen', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 5, 800, 180] ...
    );

psignalA = uipanel( ...
    'Parent', f, ...
    'Title', 'Signal VisuResp (signal A)', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 80, widthsignal, heightsignal] ...
    );

psignalAthorax = uipanel( ...
    'Parent', psignalA, ...
    'Title', 'Signal Thorax', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 185, 800, 180] ...
    );
psignalAabdo = uipanel( ...
    'Parent', psignalA, ...
    'Title', 'Signal Abdomen', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 5, 800, 180] ...
    );

%Panel Repertoire des fichiers
prepertoire = uipanel( ...
    'Parent', f, ...
    'Title', 'Repertoire', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [850, 370, 350, 480] ...
    );

% Trouver corrÃƒÂ©lation
pcorrelation = uipanel( ...
    'Parent', f, ...
    'Title', 'Correlation', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 10, 825, 70] ...
    );
% valeurs de corrÃƒÂ©lation obtenues
pvaleur = uipanel( ...
    'Parent', f, ...
    'Title', 'Valeurs', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [850, 10, 350, 350] ...
    );

%%%%%%%%%%%%%%%%%%%%% Axes des grapghes

%Graph signal B thorax
axe_signal_B_Thorax = axes( ...
    'Parent', psignalBthorax, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [30, 25, 700, 130] ...
    );
temps_B_thorax = uicontrol('Parent',psignalBthorax,'Style','text','FontSize',8,'String','temps (s)','Position',[735 14 60 25]);


%Graph signal B abdomen
axe_signal_B_Abdo = axes( ...
    'Parent', psignalBabdo, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [30, 25, 700, 130] ...
    );
temps_B_abdo = uicontrol('Parent',psignalBabdo,'Style','text','FontSize',8,'String','temps (s)','Position',[735 14 60 25]);


%Graph signal A thorax
axe_signal_A_Thorax = axes( ...
    'Parent', psignalAthorax, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [30, 25, 700, 130] ...
    );
temps_A_thorax = uicontrol('Parent',psignalAthorax,'Style','text','FontSize',8,'String','temps (s)','Position',[735 14 60 25]);

%Graph signal A abdomen
axe_signal_A_Abdo = axes( ...
    'Parent', psignalAabdo, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [30, 25, 700, 130] ...
    );

temps_A_abdo = uicontrol(...
    'Parent',psignalAabdo,...
    'Style','text',...
    'FontSize',8,...
    'String','temps (s)',...
    'Position',[735 14 60 25]);

% Graphe correlation
axe_corr = axes( ...
    'Parent', pvaleur , ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [30, 90, 290, 130] ...
    );

temps_corr = uicontrol(...
    'Parent',pvaleur,...
    'Style','text',...
    'FontSize',8,...
    'String','temps (s)',...
    'Position',[290 65 60 25]);
%%%%%%%%%%%%%%%%%%%%% Buttons

%affiche les fichiers presents dans le dossier selectionne

listedossier = uicontrol(...
    'Parent',prepertoire,...
    'Style','listbox',...
    'String','fichier',...
    'Position',[23 160 300 240],...
    'Callback',{@filelist_callback});

selectdossierBiopac = uicontrol(...
    'Parent',prepertoire,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Selectionner un dossier Biopac',...
    'Position',[50 415 250 40],...
    'ToolTipString', 'Selectionnez un dossier contenant des fichiers .mat sortant du Biopac',...
    'Callback',{@selectdir_callback});

selectfichierVisurep = uicontrol(...
    'Parent',prepertoire,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Selectionner un fichier Visuresp',...
    'Position',[53 50 250 40],...
    'ToolTipString', 'Selectionnez un fichier de type .rcg sortant de Visuresp',...
    'Callback',{@selectfile_callback});

OK = uicontrol(...
    'Parent',prepertoire,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','OK',...
    'Position',[110 110 150 40],...
    'ToolTipString', 'Selectionnez un dossier contenant des fichiers .mat sortant du Biopac',...
    'enable','off',...
    'Callback',{@afficherGraph});

cheminfichierVisuresp = uicontrol(...
    'Parent',prepertoire,...
    'Style','text',...
    'FontSize',12,...
    'String',' ',...
    'Position',...
    [10 13 330 27],...
    'BackgroundColor','w');

lancercorrelation = uicontrol(...
    'Parent',pcorrelation,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Trouver correlation',...
    'Position',[20 10 180 40],...
    'enable','off',...
    'Callback',{@calcul_correlation}); %appeler fonction correlation

suivant = uicontrol(...
    'Parent',pcorrelation,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Suivant',...
    'Position',[480 10 100 40],...
    'enable','off',...
    'ToolTipString', 'Permet de faire apparaitre la portion du signal Visurep possedant un coefficient de correlation plus faible',...
    'Callback',{@null}); %appeler fonction pour avoir la correlation suivante


precedent = uicontrol(...
    'Parent',pcorrelation,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Precedent',...
    'Position',[280 10 100 40],...
    'enable','off',...
    'ToolTipString', 'Permet de faire apparaitre la portion du signal Visuresp possedant un coefficient de correlation plus eleve',...
    'Callback',{@null}); %appeler fonction pour avoir correlation precedente


valider = uicontrol(...
    'Parent',pcorrelation,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Valider',...
    'Position',[680 10 100 40],...
    'enable','off',...
    'ToolTipString', 'Validation de la correspondance entre les sequences Visuresp et Biopac',...
    'Callback',{@null}); %appeler fonction pour changer les fichiers Biopac par Visurep

corr_thorax_text = uicontrol(...
    'Parent',pvaleur,...
    'Style','text',...
    'FontSize',9,...
    'String','Correlation Thorax :',...
    'Position',[5 305 140 25]);

corr_thorax_valeur = uicontrol(...
    'Parent',pvaleur,...
    'Style','text',...
    'FontSize',9,...
    'String',' ',...
    'Position',[150 305 120 25]);

corr_abdo_text = uicontrol(...
    'Parent',pvaleur,...
    'Style','text',...
    'FontSize',9,...
    'String','Correlation Abdominal :',...
    'Position',[3 255 170 25]);

corr_abdo_valeur = uicontrol(...
    'Parent',pvaleur,...
    'Style','text',...
    'FontSize',9,...
    'String',' ',...
    'Position',[180 255 120 25]);


freqLab = uicontrol(...
    'Parent',psignalBthorax,...
    'Style','edit',...
    'FontSize',9,...
    'String','20000',...
    'Position',[735 100 60 25],...
    'Callback',{@afficherGraph});

freqechB = uicontrol(...
    'Parent',psignalBthorax,...
    'Style','text',...
    'FontSize',9,...
    'String','Fech (Hz) : ',...
    'Position',[735 125 60 25]);
%

freqVisu = uicontrol(...
    'Parent',psignalAthorax,...
    'Style','edit',...
    'FontSize',9,...
    'String','40',...
    'Position',[735 100 60 25],...
    'Callback',{@afficherVisurep});

freqechA = uicontrol(...
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

line_corr_Thorax = line(0, 0, 'Color', 'blue', 'LineWidth', 1, 'Parent', axe_corr);
line_corr_Abdo = line(0, 0, 'Color', 'red', 'LineWidth', 1, 'Parent', axe_corr);


handles.dir='';
handles.file_list='';
handles.filename='';
thorax_L=-1;
thorax_C=-1;
abdomen_L=-1;
abdomen_C=-1;
fenetre_thorax=-1;
fenetre_abdo=-1;
r_thorax(:)=-1;
r_abdo(:)=-1;

freq_C='';
freq_L='';
%fonctions appelees dans le code precedent

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
            set(listedossier,'String', handles.file_list);
            handles.filename = char(handles.file_list(1));
            set(OK,'Enable','on')
        end
    end

%% Selection du fichier contenant l'enregistrement continu de Visuresp

    function selectfile_callback(~,~)
        [file_name, pathName] = uigetfile({'*.*';'*.mat';'*.rcg'},'Selectionner un fichier VisuResp .mat ou .rcg');
        thorax_C=-1;
        abdomen_C=-1;
        if file_name ~= 0
            file = file_name;
            chemin = strcat(pathName,file_name);
            set(cheminfichierVisuresp,'String', file)
            
            [~, ~, extension] = fileparts(file);
            if extension == '.mat'
                fichierComplet=importdata(chemin);
                if isfield(fichierComplet,'THO')
                    thorax_C=fichierComplet.THO(1:length(fichierComplet.THO));
                    abdomen_C=fichierComplet.ABD(1:length(fichierComplet.ABD));
                elseif isfield(fichierComplet,'data')
                    thorax_C=fichierComplet.data(1:length(fichierComplet.data),3);
                    abdomen_C=fichierComplet.data(1:length(fichierComplet.data),4);
                else
                    msgbox('Le contenu de ce fichier .mat n"est pas structure de façon adequate (data.data) ', 'Title', 'help')
                end
            elseif extension == '.rcg'
                delimiterIn_C = '\t';
                headerlinesIn_C = 38;
                fichierComplet=importdata(chemin,delimiterIn_C,headerlinesIn_C);
                thorax_C=fichierComplet.data(1:length(fichierComplet.data),1);
                abdomen_C=fichierComplet.data(1:length(fichierComplet.data),2);
                
            else
                msgbox('Le format de fichier n"est pas supportee, utiliser des fichiers .mat ou .rcg', 'Title', 'help')
            end
            longueur_signal_C=length(thorax_C);
            
            %affichage
            freq_C=40; %a changer si sur-echantillonnage du signal
            t_C=0:1/freq_C:(longueur_signal_C/freq_C)-1/freq_C;
            set(line_signalA_Thorax, 'XData',  t_C, 'YData', thorax_C)
            set(line_signalA_Abdo, 'XData',  t_C, 'YData', abdomen_C)
            set(axe_signal_A_Thorax,'XLim', [min(t_C), max(t_C)])
            set(axe_signal_A_Abdo,'XLim', [min(t_C), max(t_C)])
            
            axe_signal_A_Thorax.XAxis.TickValuesMode ='auto';
            axe_signal_A_Abdo.XAxis.TickValuesMode ='auto';
            axe_signal_A_Thorax.YAxis.TickValuesMode ='auto';
            axe_signal_A_Abdo.YAxis.TickValuesMode ='auto';
            
        end
        if length(thorax_L)>2 & length(thorax_C)>2
            set(lancercorrelation,'enable','on');
        end
    end


%permet d'afficher sur les graphiques les enregistrements du signal b
%(biopac) en appuyant sur Ok
    function afficherGraph(~, ~)
        thorax_L=-1;
        abdomen_L=-1;
        
        filename_L = [handles.dir, '\', handles.filename];
        fichierLabChart= importdata(filename_L);
        
        [~, ~, extension] = fileparts(handles.filename);
        if extension == '.mat'
            fichierLabChart=importdata(filename_L);
            if isfield(fichierLabChart,'THOd')
                thorax_L=fichierLabChart.THOd(1:length(fichierLabChart.THOd));
                abdomen_L=fichierLabChart.ABDd(1:length(fichierLabChart.ABDd));
            elseif isfield(fichierLabChart,'data')
                thorax_L=fichierLabChart.data(1:length(fichierLabChart.data),3);
                abdomen_L=fichierLabChart.data(1:length(fichierLabChart.data),4);
            else
                msgbox('Le contenu de ce fichier .mat n"est pas structure de façon adequate (data.data) ', 'Title', 'help')
            end
        elseif extension == '.rcg'
            delimiterIn_C = '\t';
            headerlinesIn_C = 38;
            fichierLabChart=importdata(filename_L,delimiterIn_C,headerlinesIn_C);
            thorax_L=fichierLabChart.data(1:length(fichierLabChart.data),1);
            abdomen_L=fichierLabChart.data(1:length(fichierLabChart.data),2);
            
        else
            msgbox('Le format de fichier n"est pas supporté, utiliser des fichiers .mat ou .rcg', 'Title', 'help')
        end
        longueur_signal_L=length(thorax_L);
        
        %affichage
        
        freq_L=str2num(get(freqLab,'string'))
        
        t_L=0:1/freq_L:(longueur_signal_L/freq_L-1/freq_L);
        
        set(line_signalB_Thorax, 'XData',  t_L, 'YData', thorax_L)
        set(line_signalB_Abdo, 'XData',  t_L, 'YData',abdomen_L)
        set(axe_signal_B_Thorax,'XLim', [min(t_L), max(t_L)])
        set(axe_signal_B_Abdo,'XLim', [min(t_L), max(t_L)])
        axe_signal_B_Thorax.XAxis.TickValuesMode ='auto';
        axe_signal_B_Abdo.XAxis.TickValuesMode ='auto';
        axe_signal_B_Thorax.YAxis.TickValuesMode ='auto';
        axe_signal_B_Abdo.YAxis.TickValuesMode ='auto';
        
        if  length(thorax_L)>2 & length(thorax_C)>2
            set(lancercorrelation,'enable','on');
        end
        
    end

%permet d'afficher sur les graphiques les enregistrements du signal A
%(visresp) en appuyant modifiant la Fech
    function afficherVisurep(source, eventdata)
        longueur_signal_C=length(thorax_C);
        
        %affichage
        freq_C=str2num(get(freqVisu,'string'))
        t_C=0:1/freq_C:(longueur_signal_C/freq_C)-1/freq_C;
        %          mintemps = min(t_C)
        %          maxtemps = max(t_C)
        set(line_signalA_Thorax, 'XData',  t_C, 'YData', thorax_C)
        set(line_signalA_Abdo, 'XData',  t_C, 'YData', abdomen_C)
        set(axe_signal_A_Thorax,'XLim', [min(t_C), max(t_C)])
        set(axe_signal_A_Abdo,'XLim', [min(t_C), max(t_C)])
        if length(thorax_L)>2 & length(thorax_C)>2
            set(lancercorrelation,'enable','on');
        end
    end

%% Intercorrelation

    function calcul_correlation(source,eventdata)
        
        r_thorax_zone1='';
        r_abdo_zone1='';
        r_thorax_zone2='';
        r_abdo_zone2='';
        r_thorax_zone3='';
        r_abdo_zone3='';
        r_thorax=0;
        r_abdo=0;
        tempo='';
        fenetre_tho=0;
        fenetre_abdo=0;
        debut_fen_tho=0;
        debut_fen_abdo=0;
        
        %sous-echantillonnage
        thorax_L_sous=thorax_L(1:floor((1/freq_C)*freq_L):length(thorax_L));
        abdomen_L_sous=abdomen_L(1:floor((1/freq_C)*freq_L):length(abdomen_L));
        
        %calcul 1ere intercorrelation (pas de 10 pourcent)
        pas=floor(0.1*length(thorax_L_sous));
        ind=1;
 
        
        for k=1:pas:length(thorax_C)-length(thorax_L_sous)-1
            
%             tempo=xcorr(thorax_L_sous,thorax_C(k:length(thorax_L_sous)+k-1));
%             r_thorax(ind)=max(tempo);
%             tempo=xcorr(abdomen_L_sous,abdomen_C(k:length(abdomen_L_sous)+k-1));
%             r_abdo(ind)=max(tempo);
 tempo=cov(thorax_L_sous,thorax_C(k:length(thorax_L_sous)+k-1))/(std(thorax_L_sous)*std(thorax_C(k:length(thorax_L_sous)+k-1)));
 r_thorax(ind)=tempo(1,2);
tempo=cov(abdomen_L_sous,abdomen_C(k:length(abdomen_L_sous)+k-1))/(std(abdomen_L_sous)*std(abdomen_C(k:length(abdomen_L_sous)+k-1)));
            r_abdo(ind)=tempo(1,2);
            ind=ind+1;
            
        end
 
        figure;
        
        plot(r_thorax,'b')
        hold on
        plot(r_abdo,'r')
        
        
        %calcul 2e intercorrelation (point par point) sur la fenetre
        %trouvee precedemment, + ou - le pas.

%         indice_tho =find(r_thorax==max(abs(r_thorax)))
%         indice_abdo =find(r_abdo==max(abs(r_abdo)))
        indice_tho =find(r_thorax==max(r_thorax))
        indice_abdo =find(r_abdo==max(r_abdo))
        max(r_thorax)
        max(r_abdo)
        debut_fen_inter_tho=(indice_tho-2)*pas;
        fin_fen_inter_tho=debut_fen_inter_tho+length(thorax_L_sous);
        debut_fen_inter_abdo=(indice_abdo-2)*pas;
        fin_fen_inter_abdo=debut_fen_inter_abdo+length(abdomen_L_sous);
        
        r_thorax_fin=0;
        r_abdo_fin=0;
        ind=1;
        
        for k=debut_fen_inter_tho:1:fin_fen_inter_tho
            
%             tempo=xcorr(thorax_L_sous,thorax_C(k:length(thorax_L_sous)+k-1));
tempo=cov(thorax_L_sous,thorax_C(k:length(thorax_L_sous)+k-1))/(std(thorax_L_sous)*std(thorax_C(k:length(thorax_L_sous)+k-1)));
r_thorax_fin(ind)=tempo(1,2);
%             r_thorax_fin(ind)=max(tempo);
            ind=ind+1;
            
        end
        
        ind=1;
        for k=debut_fen_inter_abdo:1:fin_fen_inter_abdo
%             tempo=xcorr(abdomen_L_sous,abdomen_C(k:length(abdomen_L_sous)+k-1));
         tempo=cov(abdomen_L_sous,abdomen_C(k:length(abdomen_L_sous)+k-1))/(std(abdomen_L_sous)*std(abdomen_C(k:length(abdomen_L_sous)+k-1)));
            r_abdo_fin(ind)=tempo(1,2);
%             r_abdo_fin(ind)=max(tempo);
            ind=ind+1;
        end
        
        figure;
        plot(r_thorax_fin,'b')
        hold on
        plot(r_abdo_fin,'r')
        
        
        indice_tho =find(r_thorax_fin==max(abs(r_thorax_fin)));
        debut_fen_tho=debut_fen_inter_tho+indice_tho(1);
        fin_fen_tho=debut_fen_tho+length(thorax_L_sous);
        fenetre_tho=[debut_fen_tho/freq_C fin_fen_tho/freq_C-1/freq_C]
        
        indice_abdo =find(r_abdo_fin==max(abs(r_abdo_fin)))
        debut_fen_abdo=debut_fen_inter_abdo+indice_abdo(1);
        fin_fen_abdo=debut_fen_abdo+length(abdomen_L_sous);
        fenetre_abdo=[debut_fen_abdo/freq_C fin_fen_abdo/freq_C-1/freq_C]
        
        
        %             fenetre=[debut_fen/freq_C fin_fen/freq_C]
        %         %selection des 3 zones de donnees dans le fichier LabChart, qui
        %         %seront intercorrelees avec le signal VisuResp
        %         thoL_zone1=thorax_L_sous(1:length(thorax_L_sous)/6);
        %         length(thorax_L_sous);
        %         round((length(thorax_L_sous)*5)/12,0);
        %         round((length(thorax_L_sous)*7)/12,0);
        %         thoL_zone2=thorax_L_sous((length(thorax_L_sous)*5)/12:(length(thorax_L_sous)*7)/12);
        %         thoL_zone3=thorax_L_sous((length(thorax_L_sous)*5)/6:length(thorax_L_sous));
        %
        %         abdoL_zone1=abdomen_L_sous(1:length(abdomen_L_sous)/6);
        %         abdoL_zone2=abdomen_L_sous((length(abdomen_L_sous)*5)/12:(length(abdomen_L_sous)*7)/12);
        %         abdoL_zone3=abdomen_L_sous((length(abdomen_L_sous)*5)/6:length(abdomen_L_sous));
        %
        %         %intercorrelation des 3 zones selectionnes avec le signal de
        %         %visuresp
        %         for k=1:length(thorax_C)-length(thorax_L_sous)-1
        %             r_thorax_zone1{k}=xcorr(thoL_zone1,thorax_C(k:length(thoL_zone1+k)));
        %             r_abdo_zone1{k}=xcorr(abdoL_zone1,abdomen_C(k:length(abdoL_zone1+k)));
        %
        %             r_thorax_zone2{k}=xcorr(thoL_zone2,thorax_C(k:length(thoL_zone2+k)));
        %             r_abdo_zone2{k}=xcorr(abdoL_zone2,abdomen_C(k:length(abdoL_zone2+k)));
        %
        %             r_thorax_zone3{k}=xcorr(thoL_zone3,thorax_C(k:length(thoL_zone3+k)));
        %             r_abdo_zone3{k}=xcorr(abdoL_zone3,abdomen_C(k:length(abdoL_zone3+k)));
        %
        %
        %             if k==1
        %                 inter_tho_zone1=r_thorax_zone1{1};
        %                 inter_abdo_zone1=r_abdo_zone1{1};
        %
        %                 inter_tho_zone2=r_thorax_zone2{1};
        %                 inter_abdo_zone2=r_abdo_zone2{1};
        %
        %                 inter_tho_zone3=r_thorax_zone3{1};
        %                 inter_abdo_zone3=r_abdo_zone3{1};
        %
        %             else
        %                 inter_tho_zone1(end+1)=r_thorax_zone1{k}(end);
        %                 inter_abdo_zone1(end+1)=r_abdo_zone1{k}(end);
        %
        %                 inter_tho_zone2(end+1)=r_thorax_zone2{k}(end);
        %                 inter_abdo_zone2(end+1)=r_abdo_zone2{k}(end);
        %
        %                 inter_tho_zone3(end+1)=r_thorax_zone3{k}(end);
        %                 inter_abdo_zone3(end+1)=r_abdo_zone3{k}(end);
        %             end
        %         end
        %
        %         %max des correlations pour le thorax
        %         [val_thorax1,ind_thorax1]=max(inter_tho_zone1) %max(r_thorax) a ete remplace par inter_tho_zoneX car cest dans cette variable qu'on enregistre les nouveaux points de correlation
        %         [val_thorax2,ind_thorax2]=max(inter_tho_zone2)
        %         [val_thorax3,ind_thorax3]=max(inter_tho_zone3)
        %
        %         fenetre_tho_zone1=ind_thorax1:ind_thorax1+length(thoL_zone1);
        %         fenetre_tho_zone2=ind_thorax2:ind_thorax2+length(thoL_zone2);
        %         fenetre_tho_zone3=ind_thorax3:ind_thorax3+length(thoL_zone3);
        %
        %         set(corr_thorax_valeur,'String',val_thorax1) %a modifier en fonction de quelle valeur de corr on veut afficher : moy des 3 corr ?
        %         %         set(axe_signal_A_Thorax,'Xlim',fenetre_thorax)
        %
        %
        %         %max des correlations pour l'abdomen
        %         [val_abdo1,ind_abdo1]=max(inter_abdo_zone1)
        %         [val_abdo2,ind_abdo2]=max(inter_abdo_zone2)
        %         [val_abdo3,ind_abdo3]=max(inter_abdo_zone3)
        %
        %         fenetre_abdo_zone1=ind_abdo1:ind_abdo+length(abdoL_zone1);
        %         fenetre_abdo_zone2=ind_abdo2:ind_abdo1+length(abdoL_zone2);
        %         fenetre_abdo_zone3=ind_abdo3:ind_abdo3+length(abdoL_zone3);
        %
        %         set(corr_abdo_valeur,'String',val_abdo1) %a modifier en fonction de quelle valeur de corr on veut afficher : moy des 3 corr ?
        %
        %         %calcul des distance entre les max de correlation
        %         dist_tho_zone1_2= ind_thorax2-ind_thorax1;
        %         dist_tho_zone1_3= ind_thorax3-ind_thorax1;
        %         dist_tho_zone2_3= ind_thorax3-ind_thorax2;
        %
        %         dist_abdo_zone1_2= ind_abdo2-ind_abdo1;
        %         dist_abdo_zone1_3= ind_abdo3-ind_abdo1;
        %         dist_abdo_zone2_3= ind_abdo3-ind_abdo2;
        %         a=0;
        %         i=0;
        %         while a==0 && i<5;
        %             if dist_tho_zone1_2 > (((length(thorax_L_sous)*5)/12)*1.02) && dist_tho_zone1_2 < (((length(thorax_L_sous)*5)/12)*0.98) || dist_tho_zone2_3 > (((length(thorax_L_sous)*5)/12)*1.02) && dist_tho_zone1_2 < (((length(thorax_L_sous)*5)/12)*0.98) || dist_tho_zone1_3 > (((length(thorax_L_sous)*5)/6)*1.02) && dist_tho_zone1_2 < (((length(thorax_L_sous)*5)/6)*0.98) || dist_abdo_zone1_2 > (((length(abdomen_L_sous)*5)/12)*1.02) && dist_abdo_zone1_2 < (((length(abdomen_L_sous)*5)/12)*0.98)|| dist_abdo_zone2_3 > (((length(abdomen_L_sous)*5)/12)*1.02) && dist_abdo_zone1_2 < (((length(abdomen_L_sous)*5)/12)*0.98) || dist_abdo_zone1_3 > (((length(abdomen_L_sous)*5)/6)*1.02) && dist_abdo_zone1_2 < (((length(abdomen_L_sous)*5)/6)*0.98)
        %                 [val_thorax2,ind_thorax2]=max(inter_tho_zone2([1:ind_thorax2-1, ind_thorax2+1:end]))
        %                 [val_thorax3,ind_thorax3]=max(inter_tho_zone3([1:ind_thorax1-1, ind_thorax1+1:end]))
        %
        %                 [val_abdo2,ind_abdo2]=max(inter_abdo_zone2([1:ind_abdo2-1, ind_abdo2+1:end]))
        %                 [val_abdo3,ind_abdo3]=max(inter_abdo_zone3([1:ind_abdo1-1, ind_abdo1+1:end]))
        %
        %                 i=i+1;
        %
        %             else
        %                 a=1;
        %                 if ~(dist_tho_zone1_2 > (((length(thorax_L_sous)*5)/12)*1.02) && dist_tho_zone1_2 < (((length(thorax_L_sous)*5)/12)*0.98))
        %                     fenetre = dist_tho_zone1_2(1):length(thorax_L_sous);
        %                 end
        %                 if ~(dist_tho_zone2_3 > (((length(thorax_L_sous)*5)/12)*1.02) && dist_tho_zone1_2 < (((length(thorax_L_sous)*5)/12)*0.98))
        %                     fenetre = dist_tho_zone2_3(end)+length(thoL_zone3)-length(thorax_L_sous):dist_tho_zone2_3(end)+length(thoL_zone3);
        %                 end
        %                 if ~(dist_tho_zone1_3 > (((length(thorax_L_sous)*5)/6)*1.02) && dist_tho_zone1_2 < (((length(thorax_L_sous)*5)/6)*0.98))
        %                     fenetre = dist_tho_zone1_3(1):length(thorax_L_sous);
        %                 end
        %                 if ~(dist_abdo_zone1_2 > (((length(abdomen_L_sous)*5)/12)*1.02) && dist_abdo_zone1_2 < (((length(abdomen_L_sous)*5)/12)*0.98))
        %                     fenetre = dist_abdo_zone1_2(1):length(abdomen_L_sous);
        %                 end
        %                 if ~(dist_abdo_zone2_3 > (((length(abdomen_L_sous)*5)/12)*1.02) && dist_abdo_zone1_2 < (((length(abdomen_L_sous)*5)/12)*0.98))
        %                     fenetre = dist_abdo_zone2_3(end)+length(abdoL_zone3)-length(abdomen_L_sous):dist_tho_zone2_3(end)+length(abdoL_zone3);
        %                 end
        %                 if ~(dist_abdo_zone1_3 > (((length(abdomen_L_sous)*5)/6)*1.02) && dist_abdo_zone1_2 < (((length(abdomen_L_sous)*5)/6)*0.98))
        %                     fenetre = dist_abdo_zone1_3(1):length(abdomen_L_sous);
        %                 end
        %
        %             end
        %         end

        abdo_data_norm=(abdomen_C-(min(abdomen_C)))/(max(abdomen_C)-min(abdomen_C));
        tho_data_norm=(thorax_C-(min(thorax_C)))/(max(thorax_C)-min(thorax_C));
        temps_fenetre_tho=debut_fen_tho/freq_C:1/freq_C:fin_fen_tho/freq_C-1/freq_C;
        temps_fenetre_abdo=debut_fen_abdo/freq_C:1/freq_C:fin_fen_abdo/freq_C-1/freq_C;
     
        set(line_signalA_Thorax_super, 'XData',temps_fenetre_tho, 'YData', (thorax_L_sous-(min(thorax_L_sous)))/(max(thorax_L_sous)-min(thorax_L_sous)))
        set(line_signalA_Abdo_super, 'XData', temps_fenetre_abdo, 'YData', (abdomen_L_sous-(min(abdomen_L_sous)))/(max(abdomen_L_sous)-min(abdomen_L_sous)))
        set(line_signalA_Thorax, 'XData', temps_fenetre_tho, 'YData', tho_data_norm(debut_fen_tho:1:fin_fen_tho-1))
        set(line_signalA_Abdo, 'XData', temps_fenetre_abdo, 'YData', abdo_data_norm(debut_fen_abdo:1:fin_fen_abdo-1))
        
        set(axe_signal_A_Thorax, 'XLim', fenetre_tho)
        set(axe_signal_A_Abdo, 'XLim', fenetre_abdo )

        
        set(suivant,'enable','on');
        set(precedent,'enable','on');
        set(valider,'enable','on');
    end

end

