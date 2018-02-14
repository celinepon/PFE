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
widthsignal = 810;
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

% Trouver corrÃƒÆ’Ã‚Â©lation
pcorrelation = uipanel( ...
    'Parent', f, ...
    'Title', 'Correlation', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [5, 10, widthsignal, 70] ...
    );
% valeurs de corrÃƒÆ’Ã‚Â©lation obtenues
pvaleur = uipanel( ...
    'Parent', f, ...
    'Title', 'Valeurs', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [815, 10, 430, 350] ...
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
    'Tag','Tho',...
    'Position', [30, 25, 700, 130] ...
    );
temps_A_thorax = uicontrol('Parent',psignalAthorax,'Style','text','FontSize',8,'String','temps (s)','Position',[735 14 60 25]);

%Graph signal A abdomen
axe_signal_A_Abdo = axes( ...
    'Parent', psignalAabdo, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'Tag','Abd',...
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
    'Tag','Cor',...
    'NextPlot','add',...
    'Position', [40, 40, 380, 260] ...
    );

temps_corr = uicontrol(...
    'Parent',pvaleur,...
    'Style','text',...
    'FontSize',8,...
    'String','1-pvalue',...
    'Position',[350 6 50 13]);
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
    'Position',[100 10 180 40],...
    'enable','off',...
    'Callback',{@calcul_correlation}); %appeler fonction correlation

valider = uicontrol(...
    'Parent',pcorrelation,...
    'Style','pushbutton',...
    'FontSize',9,...
    'String','Extraire',...
    'Position',[500 10 100 40],...
    'enable','off',...
    'ToolTipString', 'Validation de la correspondance entre les sequences Visuresp et Biopac',...
    'Callback',{@valider_correlation}); %appeler fonction pour changer les fichiers Biopac par Visurep

corr_thorax_text = uicontrol(...
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

corr_abdo_text = uicontrol(...
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


freqLab = uicontrol(...
    'Parent',psignalBthorax,...
    'Style','edit',...
    'FontSize',9,...
    'String','1',...
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


scatter_corr_Abdo = scatter(0,0,'r','filled', 'Marker', 'o','MarkerFaceAlpha', 0.5, 'MarkerEdgeColor', [1, 1, 1], 'Parent', axe_corr,'Tag','CoA','Visible','off','buttondownfcn',{@button_down_function});
scatter_corr_Thorax = scatter(0,0,'b','filled', 'Marker', 'o','MarkerFaceAlpha',0.5, 'MarkerEdgeColor', [1, 1, 1], 'Parent', axe_corr,'Tag','CoT','Visible','off','buttondownfcn',{@button_down_function});
scatter_corr_Select = scatter(0,0,'black','filled', 'Marker', 'o', 'MarkerEdgeColor', [0, 0, 0], 'Parent', axe_corr,'Visible','off','buttondownfcn',{@button_down_function});

set([axe_signal_A_Thorax, axe_signal_A_Abdo,axe_corr], 'buttondownfcn', {@button_down_function});
set(f, 'WindowButtonUpFcn', {@button_up_function});
set(f, 'WindowButtonMotionFcn', {@button_motion_function});

handles.dir='';
handles.file_list='';
handles.filename='';
handles.grabbed=-1;
handles.xlim_tho=-1;
handles.xlim_abdo=-1;
fichierLabChart=-1;
thorax_L=-1;
thorax_C=-1;
abdomen_L=-1;
abdomen_C=-1;
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
thorax_L_sous=-1;
abdomen_L_sous=-1;
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

%fonctions appelees dans le code precedent
%% Drag and Drop des signaux superposés lors de l'intercorrelation

    function button_down_function(obj, ~)
        if get(obj, 'Tag')=='Tho'&intercorr_calculee
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

    function button_motion_function(obj, ~)
        % Update movie screen marker location
        
        if handles.grabbed==-1 |handles.grabbed==3
        elseif handles.grabbed==2 | handles.grabbed==1
            ps = get(gca, 'CurrentPoint');
            fenetre_tho=fenetre_tho-((ps(1,1)-decal)*15)/freq_C;
            fenetre_abdo=fenetre_tho;
            temps_fenetre_tho=fenetre_tho(1,1):1/freq_C:fenetre_tho(1,2);
            temps_fenetre_abdo=temps_fenetre_tho;
            
            set(axe_signal_A_Thorax,'XLim',fenetre_tho)
            set(axe_signal_A_Abdo,'XLim',fenetre_abdo)
            set(line_signalA_Thorax_super, 'XData',temps_fenetre_tho, 'YData', (thorax_L_sous-(min(thorax_L_sous)))/(max(thorax_L_sous)-min(thorax_L_sous)))
            set(line_signalA_Abdo_super, 'XData',temps_fenetre_abdo, 'YData', (abdomen_L_sous-(min(abdomen_L_sous)))/(max(abdomen_L_sous)-min(abdomen_L_sous)))
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
            set(listedossier,'String', handles.file_list);
            handles.filename = char(handles.file_list(1));
            set(OK,'Enable','on')
        end
        intercorr_calculee=0;
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
                    msgbox('Le contenu de ce fichier .mat n"est pas structure de facon adequate (data.data) ', 'Title', 'help')
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
            set(line_signalA_Thorax_super, 'Visible','off')
            set(line_signalA_Abdo_super,  'Visible','off')
            axe_signal_A_Thorax.XAxis.TickValuesMode ='auto';
            axe_signal_A_Abdo.XAxis.TickValuesMode ='auto';
            axe_signal_A_Thorax.YAxis.TickValuesMode ='auto';
            axe_signal_A_Abdo.YAxis.TickValuesMode ='auto';
            
        end
        if length(thorax_L)>2 & length(thorax_C)>2
            set(lancercorrelation,'enable','on');
        end
        intercorr_calculee=0;
    end

%% Affichage des signaux

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
                msgbox('Le contenu de ce fichier .mat n"est pas structure de faÃ§on adequate (data.data) ', 'Title', 'help')
            end
        elseif extension == '.rcg'
            delimiterIn_C = '\t';
            headerlinesIn_C = 38;
            fichierLabChart=importdata(filename_L,delimiterIn_C,headerlinesIn_C);
            thorax_L=fichierLabChart.data(1:length(fichierLabChart.data),1);
            abdomen_L=fichierLabChart.data(1:length(fichierLabChart.data),2);
            
        else
            msgbox('Le format de fichier n"est pas supporte, utiliser des fichiers .mat ou .rcg', 'Title', 'help')
        end
        longueur_signal_L=length(thorax_L);
        
        %affichage
        
        freq_L=str2num(get(freqLab,'string'));
        
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
       
if get(freqLab,'String')=='1'
     msgbox('La fréquence des fichiers Biopac est incorrecte.', 'Title', 'help')
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
        %sous-echantillonnage

        freq_surech=freq_C;
        t_L2=0:1/freq_surech:(length(thorax_L)/freq_L-1/freq_L);
        
        thorax_L_sous= interp1(t_L,thorax_L,t_L2,'spline');
        abdomen_L_sous= interp1(t_L,abdomen_L,t_L2,'spline');
        

        %calcul 1ere fenetre (pas de 5 pourcent)
        pas=floor(0.05*length(thorax_L_sous));
        ind=1;
     
        for k=1:pas:length(thorax_C)-length(thorax_L_sous)-1

            [val,p]=corrcoef(thorax_L_sous,thorax_C(k:length(thorax_L_sous)+k-1));
            r_thorax(ind)=val(1,2);
            pval_tho(ind)=1-p(1,2);
            
            [val,p]=corrcoef(abdomen_L_sous,abdomen_C(k:length(abdomen_L_sous)+k-1));
            r_abdo(ind)=val(1,2);
            pval_abdo(ind)=1-p(1,2);
            
            ind=ind+1;
            
        end
        waitbar(0.3)

        %calcul 2e fenetre (point par point) sur la fenetre
        %trouvee precedemment, + ou - le pas.
        
        indice_tho =find(r_thorax==max(r_thorax));
        maxi_val=max(max(r_abdo),max(r_thorax));
        max_tho=max(r_thorax);
        max_abdo=max(r_abdo);
        maxi_pval=max(max(pval_abdo),max(pval_tho));
        indice_abdo =find(r_abdo==max(r_abdo));
        if indice_tho==1
            debut_fen_inter_tho=1;
            fin_fen_inter_tho=length(thorax_L_sous);
        elseif indice_tho==2
            debut_fen_inter_tho=pas;
            fin_fen_inter_tho=pas+length(thorax_L_sous);
        elseif indice_tho==length(r_abdo)
            debut_fen_inter_tho=(indice_tho-2)*pas;
            fin_fen_inter_tho=thorax_C(end);
        else
            debut_fen_inter_tho=(indice_tho-2)*pas;
            fin_fen_inter_tho=(indice_tho)*pas+length(thorax_L_sous);
        end
        if indice_abdo==1
            debut_fen_inter_abdo=1;
            fin_fen_inter_abdo=length(abdomen_L_sous);
        elseif indice_abdo==2
            debut_fen_inter_abdo=pas;
            fin_fen_inter_abdo=pas+length(abdomen_L_sous);
        elseif indice_abdo==length(r_abdo)
            debut_fen_inter_abdo=(indice_abdo-2)*pas;
            fin_fen_inter_abdo=thorax_C(end);
        else
            debut_fen_inter_abdo=(indice_abdo-2)*pas;
            fin_fen_inter_abdo=(indice_abdo)*pas+length(abdomen_L_sous);
        end
        r_thorax_fin=0;
        r_abdo_fin=0;
        ind=1;
        waitbar(0.5)
        for k=debut_fen_inter_tho:1:fin_fen_inter_tho
            val=corrcoef(thorax_L_sous,thorax_C(k:length(thorax_L_sous)+k-1));
            r_thorax_fin(ind)=val(1,2);
            
            ind=ind+1;
        end
        
        ind=1;
        for k=debut_fen_inter_abdo:1:fin_fen_inter_abdo
            val=corrcoef(abdomen_L_sous,abdomen_C(k:length(abdomen_L_sous)+k-1));
            r_abdo_fin(ind)=val(1,2);
            
            ind=ind+1;
        end
        waitbar(1)
        
        indice_tho_fin =find(r_thorax_fin==max(r_thorax_fin));
  
        debut_fen_tho=debut_fen_inter_tho+indice_tho_fin(1)-1;
        fin_fen_tho=debut_fen_tho+length(thorax_L_sous);
        fenetre_tho=[debut_fen_tho/freq_C fin_fen_tho/freq_C-1/freq_C];
        indice_abdo_fin =find(r_abdo_fin==max(r_abdo_fin));
       
        debut_fen_abdo=debut_fen_inter_abdo+indice_abdo_fin(1)-1;
        fin_fen_abdo=debut_fen_abdo+length(abdomen_L_sous);
        fenetre_abdo=[debut_fen_abdo/freq_C fin_fen_abdo/freq_C-1/freq_C];
        a=-1;
        if max(r_thorax_fin)<max(r_abdo_fin)
            a=1;
            debut_fen_tho=debut_fen_abdo;
            fin_fen_tho=fin_fen_abdo;
            fenetre_tho=fenetre_abdo;  
        ind=1;
        for k=debut_fen_inter_abdo:1:fin_fen_inter_abdo
            val=corrcoef(thorax_L_sous,thorax_C(k:length(thorax_L_sous)+k-1));
            r_thorax_fin(ind)=val(1,2);
            
            ind=ind+1;
        end
        
        else
            a=2;
            debut_fen_abdo=debut_fen_tho;
            fin_fen_abdo=fin_fen_tho;
            fenetre_abdo=fenetre_tho;
              ind=1;
        for k=debut_fen_inter_tho:1:fin_fen_inter_tho
            val=corrcoef(abdomen_L_sous,abdomen_C(k:length(abdomen_L_sous)+k-1));
            r_abdo_fin(ind)=val(1,2);
            
            ind=ind+1;
        end
        end
        
        temps_fenetre_tho=fenetre_tho(1,1):1/freq_C:fenetre_tho(1,2);
        temps_fenetre_abdo=fenetre_abdo(1,1):1/freq_C:fenetre_abdo(1,2);
        
        set(line_signalA_Thorax_super, 'XData',temps_fenetre_tho, 'YData', (thorax_L_sous-(min(thorax_L_sous)))/(max(thorax_L_sous)-min(thorax_L_sous)),'Visible','on')
        set(line_signalA_Abdo_super, 'XData', temps_fenetre_abdo, 'YData', (abdomen_L_sous-(min(abdomen_L_sous)))/(max(abdomen_L_sous)-min(abdomen_L_sous)),'Visible','on')
        set(line_signalA_Thorax, 'XData', t_C, 'YData', (thorax_C-(min(thorax_C)))/(max(thorax_C)-min(thorax_C)))
        set(line_signalA_Abdo, 'XData', t_C, 'YData', (abdomen_C-(min(abdomen_C)))/(max(abdomen_C)-min(abdomen_C)))
        
        set(axe_signal_A_Thorax, 'XLim', fenetre_tho)
        set(axe_signal_A_Abdo, 'XLim', fenetre_abdo)
    

        set(valider,'enable','on');
        set(corr_abdo_valeur,'String',round(max(r_abdo_fin),4))
        set(corr_thorax_valeur,'String',round(max(r_thorax_fin),4))
        intercorr_calculee=1;
        
        
        set(scatter_corr_Abdo,'XData',pval_abdo,'YData',r_abdo,'Visible','on')
        set(scatter_corr_Thorax,'XData',pval_tho,'YData',r_thorax,'Visible','on')
        set(scatter_corr_Select,'XData',pval_tho,'YData',r_thorax,'Visible','off')
        fenetre_corr_x=[0.99*maxi_pval maxi_pval*1.01];
        fenetre_corr_y=[0.8*maxi_val maxi_val*1.01];
        set(axe_corr,'XLim',fenetre_corr_x,'YLim',fenetre_corr_y)
        if a==1
            set(scatter_corr_Select,'XData',pval_abdo(indice_abdo),'YData',r_abdo(indice_abdo),'Visible','on','MarkerFaceColor','r','LineWidth',1)
        else
            set(scatter_corr_Select,'XData',pval_tho(indice_tho),'YData',r_thorax(indice_tho),'Visible','on','MarkerFaceColor','b','LineWidth',1)
        end
        
        axe_corr.XAxis.TickValuesMode ='auto';
        close(h);
    end
    end
% Changement de fenetre en fonction du point (coefficient-pvalue)
% sélectionné

    function selection_point(indice,~)
         h = waitbar(0,'Please wait...');
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

%Valider et exporter la zone correpondant au Biopac dans le VisuResp

    function valider_correlation(~,~)
    
        t_L2=fenetre_tho(1)*freq_C:1:fenetre_tho(2)*freq_C;
        thorax_L_sur= interp1(fenetre_tho(1)*freq_C:1:fenetre_tho(2)*freq_C,thorax_C(fenetre_tho(1)*freq_C:1:fenetre_tho(2)*freq_C),t_L2,'spline');
        abdo_L_sur= interp1(fenetre_tho(1)*freq_C:1:fenetre_tho(2)*freq_C,abdomen_C(fenetre_tho(1)*freq_C:1:fenetre_tho(2)*freq_C),t_L2,'spline');
        
        [~, ~, extension] = fileparts(handles.filename);
        
        if extension == '.mat'
            fichier.ABDd=abdo_L_sur;
            fichier.THOd=thorax_L_sur;
        else extension=='.rcg'
            fichier.data(l:length(thorax_L_sur),1)=thorax_L_sur;
            fichier.data(l:length(abdo_L_sur),2)=abdo_L_sur;
            fichier.delimiterIn_C=fichierLabChart.delimiterIn_C;
            fichier.headerlinesIn_C=fichierLabChart.headerlinesIn_C;
        end
        s=fichier;
        save([handles.dir,'\',handles.filename,'_VisuResp'], '-struct', 's')
         msgbox('Le signal de Biopac a été remplacé avec succès', 'Title', 'help')
    end
end