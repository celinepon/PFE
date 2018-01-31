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

% Trouver corrélation 
pcorrelation = uipanel( ...
    'Parent', f, ...
    'Title', 'Correlation', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 10, 825, 70] ...
    );
% valeurs de corrélation obtenues 
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
    'FontSize',12,...
    'String','OK',...
    'Position',[110 120 150 40],...
    'ToolTipString', 'Selectionnez un dossier contenant des fichiers .mat sortant du Biopac',...
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
'Callback',{@null}); %appeler fonction correlation

suivant = uicontrol(...
    'Parent',pcorrelation,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Suivant',...
    'Position',[480 10 100 40],...
    'ToolTipString', 'Permet de faire apparaitre la portion du signal Visurep possèdant un coefficient de corrélation plus faible',...
    'Callback',{@null}); %appeler fonction pour avoir la corrélation suivante

precedent = uicontrol(...
    'Parent',pcorrelation,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Precedent',...
    'Position',[280 10 100 40],...
    'ToolTipString', 'Permet de faire apparaitre la portion du signal Visuresp possèdant un coefficient de corrélation plus élevé',...
    'Callback',{@null}); %appeler fonction pour avoir correlation précédente

valider = uicontrol(...
    'Parent',pcorrelation,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Valider',...
    'Position',[680 10 100 40],...
    'ToolTipString', 'Validation de la correspondance entre les séquences Visuresp et Biopac',...
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
    'String',' ',...
    'Position',[735 100 60 25]);

freqechB = uicontrol(...
    'Parent',psignalBthorax,...
    'Style','text',...
    'FontSize',9,...
    'String','Fech : ',...
    'Position',[735 125 60 25]);

freqVisu = uicontrol(...
    'Parent',psignalAthorax,...
    'Style','edit',...
    'FontSize',9,...
    'String',' ',...
    'Position',[735 100 60 25]);

freqechA = uicontrol(...
    'Parent',psignalAthorax,...
    'Style','text',...
    'FontSize',9,...
    'String','Fech : ',...
    'Position',[735 125 60 25]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lines
%Affichage des données sur les différents graphiques. 
%Initialisation des lignes pour afficher les données sur les graphiques 
line_signalA_Thorax = line(0, 0, 'Color', 'blue', 'LineWidth', 1, 'Parent', axe_signal_A_Thorax);
line_signalA_Abdo= line(0, 0, 'Color', 'red', 'LineWidth', 1, 'Parent', axe_signal_A_Abdo);
line_signalB_Thorax = line(0, 0, 'Color', 'blue', 'LineWidth', 1, 'Parent', axe_signal_B_Thorax);
line_signalB_Abdo = line(0, 0, 'Color', 'red', 'LineWidth', 1, 'Parent', axe_signal_B_Abdo);

line_corr_Thorax = line(0, 0, 'Color', 'blue', 'LineWidth', 1, 'Parent', axe_corr);
line_corr_Abdo = line(0, 0, 'Color', 'red', 'LineWidth', 1, 'Parent', axe_corr);


handles.dir='';
handles.file_list='';
handles.filename='';


%fonctions appelees dans le code precedent 

%% Liste contenant tous les fichiers du repertorie
    function filelist_callback(source,eventdata)
        str = get(source, 'String');
        val = get(source,'Value');
        file = char(str(val));
        handles.filename = file;
    end

%% Selection du dossier contenant les enregistrements Biopac
function selectdir_callback(source,eventdata)
    dir_name = uigetdir;
    if dir_name ~= 0
        handles.dir = dir_name;
        search_name = [dir_name,'/*.txt']; %attention au format du fichier ! à changer en .mat pour lire les vraies donnees
        files = struct2cell(dir(search_name));
        handles.file_list = files(1,:)'
        set(listedossier,'String', handles.file_list)
        handles.filename = char(handles.file_list(1));
    end
end

%% Selection du fichier contenant l'enregistrement continu de Visuresp
function selectfile_callback(source,eventdata)
    [file_name, pathName] = uigetfile;
    if file_name ~= 0
         file = file_name;
         chemin = strcat(pathName,file_name);
         set(cheminfichierVisuresp,'String', file)
         delimiterIn_C = '\t';
         headerlinesIn_C = 38;

         fichierComplet=importdata(chemin,delimiterIn_C,headerlinesIn_C);
         thorax_C=fichierComplet.data(1:length(fichierComplet.data),1);
         abdomen_C=fichierComplet.data(1:length(fichierComplet.data),2);
         longueur_signal_C=length(thorax_C);
       
         %affichage
         freq_C=40; %a changer si sur-echantillonnage du signal
         t_C=0:1/freq_C:(longueur_signal_C/freq_C)-1/freq_C;
         mintemps = min(t_C)
         maxtemps = max(t_C)
         set(line_signalA_Thorax, 'XData',  t_C, 'YData', thorax_C)
         set(line_signalA_Abdo, 'XData',  t_C, 'YData', abdomen_C)
         set(axe_signal_A_Thorax,'XLim', [min(t_C), max(t_C)])
         set(axe_signal_A_Abdo,'XLim', [min(t_C), max(t_C)]) 


    end
end

%permet d'afficher sur les graphiques les enregistrements du signal b
%(biopac) en appuyant sur Ok 
function afficherGraph(source, eventdata)
    filename_L = [handles.dir, '\', handles.filename];
    delimiterIn_L = '\t';
    headerlinesIn_L= 5;
    fichierLabChart= importdata(filename_L,delimiterIn_L,headerlinesIn_L);
    thorax_L=fichierLabChart.data(1:length(fichierLabChart.data),1);
    abdomen_L=fichierLabChart.data(1:length(fichierLabChart.data),2);
    longueur_signal_L=length(thorax_L);

    %affichage
    freq_L=20000;
    t_L=0:1/freq_L:(longueur_signal_L/freq_L-1/freq_L);
    
    set(line_signalB_Thorax, 'XData',  t_L, 'YData', thorax_L)
    set(line_signalB_Abdo, 'XData',  t_L, 'YData',abdomen_L)
    set(axe_signal_B_Thorax,'XLim', [min(t_L), max(t_L)])
    set(axe_signal_B_Abdo,'XLim', [min(t_L), max(t_L)])

end 


end 

