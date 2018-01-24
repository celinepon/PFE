function rhythm_voltage_calcium(directory, filename, handles)

%%%%%%%%%%%%%%%%%%%%%%%
%                     %
%   Optical Calcium   %
%       Analyse       %
%                     %
%%%%%%%%%%%%%%%%%%%%%%%


%% Create GUI structure
scrn_size = get(0, 'ScreenSize');
xmiddle = scrn_size(3) / 2;
ymiddle = scrn_size(4) / 2;
sizex = 1250;
sizey = 850;

if handles.version == 1
    f = figure( ...
        'Name', filename, ...
        'Visible', 'on', ...
        'Position', [xmiddle - (sizex / 2), ymiddle - (sizey / 2), sizex, sizey], ...
        'NumberTitle', 'Off' ...
        );
else
    
    f = figure( ...
        'Name', strcat(filename(1, :), '...............', filename(2, :)), ...
        'Visible', 'on', ...
        'Position', [xmiddle - (sizex / 2), ymiddle - (sizey / 2), sizex, sizey], ...
        'NumberTitle', 'Off' ...
        );
end

%% Create all the panel inside the figure

%%%%%%%%%%%%%%%%%
%               %
%   Panel for   %
%     movie     %
%               %
%%%%%%%%%%%%%%%%%

pmovies = uipanel( ...
    'Parent', f, ...
    'Title', 'Movies', ...
    'Fontsize', 9, ...
    'Units', 'Pixels', ...
    'Position', [0, 455, 825, 400] ...
    );


% Movie Screen for Optical Data_1 and Calcium Data_1

handles.movie_scrn_1 = axes( ...
    'Parent', pmovies, ...
    'tag', 'movie_scrn1', ...
    'Units', 'Pixels', ...
    'YTick', [], ...
    'XTick', [], ...
    'NextPlot', 'add', ...
    'Position', [25, 30, 355, 355] ...
    );

handles.movie_scrn_2 = axes( ...
    'Parent', pmovies, ...
    'tag', 'movie_scrn2', ...
    'Units', 'Pixels', ...
    'YTick', [], ...
    'XTick', [], ...
    'NextPlot', 'add', ...
    'Position', [415, 30, 355, 355] ...
    );

% Movie Slider for Controling Current Frame
movie_slider = uicontrol( ...
    'Parent', pmovies, ...
    'Style', 'slider', ...
    'String', 'test', ...
    'Position', [10, 5, 220, 20], ...
    'SliderStep', [.001, .01], ...
    'ToolTipString', 'Move the scroll bar to select the video time', ...
    'Callback', {@movieslider_callback} ...
    );

addlistener(movie_slider, 'ContinuousValueChange', @movieslider_callback);

% Video Control Buttons and Optical Action Potential Display
play_stop_button = uicontrol( ...
    'Parent', pmovies, ...
    'Style', 'pushbutton', ...
    'Fontsize', 9, ...
    'String', 'Play', ...
    'Position', [235, 3, 60, 25], ...
    'ToolTipString', 'Play and Pause the movies', ...
    'Callback', {@play_stop_button_callback} ...
    );

% dispwave_button_1 =
uicontrol( ...
    'Parent', pmovies, ...
    'Style', 'pushbutton', ...
    'Fontsize', 9, ...
    'String', 'Display Wave', ...
    'Position', [320, 3, 90, 25], ...
    'ToolTipString', 'Click and Select a pixel on the desired screen', ...
    'Callback', {@dispwave_button_callback} ...
    );


% expmov_button   =
uicontrol( ...
    'Parent', pmovies, ...
    'Style', 'pushbutton', ...
    'Fontsize', 9, ...
    'String', 'Export', ...
    'Position', [710, 3, 60, 25], ...
    'ToolTipString', 'Export a video of the activation map of the first screen', ...
    'Callback', {@expmov_button_callback} ...
    );
%frequency



%%%%%%%%%%%%%%%%%
%               %
%   Panel for   %
%    signals    %
%               %
%%%%%%%%%%%%%%%%%

% variabe used to place the panel that will display the 4 waves
xstartsignal = 0;
ystartsignal = 0;
widthsignal = 825;
heightsignal = 455;

% creation of the panel that display the 4 waves and the information
% relative to the signal such as the starting time, ending time and he
% exportation
psignal = uipanel( ...
    'Parent', f, ...
    'Title', 'Signal display', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [xstartsignal, ystartsignal, widthsignal, heightsignal] ...
    );

% starttimemap_text =
uicontrol( ...
    'Parent', psignal, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'Fontsize', 9, ...
    'String', 'Start time (sec) :', ...
    'ToolTipString', 'Abscissa start time', ...
    'Position', [270, 415, 105, 15] ...
    );

starttimemap_edit = uicontrol( ...
    'Parent', psignal, ...
    'Style', 'edit', ...
    'Fontsize', 9, ...
    'Position', [370, 410, 60, 20], ...
    'ToolTipString', 'Enter the start time of the zoom', ...
    'Callback', {@time_edit_callback} ...
    );

% endtimemap_text   =
uicontrol( ...
    'Parent', psignal, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'Fontsize', 9, ...
    'String', 'End time (sec) :', ...
    'ToolTipString', 'Abscissa end time', ...
    'Position', [450, 415, 105, 15] ...
    );

endtimemap_edit = uicontrol( ...
    'Parent', psignal, ...
    'Style', 'edit', ...
    'Fontsize', 9, ...
    'Position', [550, 410, 60, 20], ...
    'ToolTipString', 'Enter the end time of the zoom', ...
    'Callback', {@time_edit_callback} ...
    );

% button sweep bar
% sweepbar_button   =
uicontrol( ...
    'Parent', psignal, ...
    'Style', 'pushbutton', ...
    'Fontsize', 9, ...
    'String', 'Time bar', ...
    'Position', [170, 410, 80, 20], ...
    'ToolTipString', 'Click and drag the displayed time to select the working interval', ...
    'Callback', {@timebar_button_callback} ...
    );

% button exportation
% expwave_button    =
uicontrol( ...
    'Parent', psignal, ...
    'Style', 'pushbutton', ...
    'FontSize', 9, ...
    'String', 'Export Signals', ...
    'Position', [700, 410, 100, 30], ...
    'ToolTipString', 'Export the displayed signals on a new figure', ...
    'Callback', {@expwave_button_callback} ...
    );

%combobox for choicing the analog signal
if handles.version == 1
    analog_popup = uicontrol( ...
        'Parent', psignal, ...
        'Style', 'popupmenu', ...
        'FontSize', 8, ...
        'String', {'None', 'Analog 1', 'Analog 2'}, ...
        'Position', [80, 412, 85, 20], ...
        'ToolTipString', 'Select the desired signal to display', ...
        'Callback', {@scrn_popup_callback} ...
        );
else
    analog_popup = uicontrol( ...
        'Parent', psignal, ...
        'Style', 'popupmenu', ...
        'FontSize', 8, ...
        'String', {'None', 'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'}, ...
        'Position', [80, 412, 85, 20], ...
        'ToolTipString', 'Select the desired signal to display', ...
        'Callback', {@scrn_popup_callback} ...
        );
end

% signal screen
%analog signal
handles.axe_signal_scrn_1_ana = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [40, 325, 230, 70] ...
    );

handles.axe_signal_scrn_2_ana = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [310, 325, 230, 70] ...
    );

handles.axe_signal_scrn_3_ana = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [580, 325, 230, 70] ...
    );

%optical signal 1
handles.axe_signal_scrn_1_1 = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [40, 225, 230, 70] ...
    );

handles.axe_signal_scrn_2_1 = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [310, 225, 230, 70] ...
    );

handles.axe_signal_scrn_3_1 = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [580, 225, 230, 70] ...
    );

%Calcium signal
handles.axe_signal_scrn_1_2 = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [40, 125, 230, 70] ...
    );

handles.axe_signal_scrn_2_2 = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [310, 125, 230, 70] ...
    );

handles.axe_signal_scrn_3_2 = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'XTick', [], ...
    'Position', [580, 125, 230, 70] ...
    );

% 2 signals analog & Calcium
handles.axe_signal_scrn_1_3 = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'Position', [40, 28, 230, 70] ...
    );

handles.axe_signal_scrn_2_3 = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'Position', [310, 28, 230, 70] ...
    );

handles.axe_signal_scrn_3_3 = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'FontSize', 8, ...
    'Color', 'w', ...
    'Position', [580, 28, 230, 70] ...
    );


% xlabel_text1 =
uicontrol( ...
    'Parent', psignal, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 8, ...
    'String', 'Potential', ...
    'Position', [2, 298, 50, 15] ...
    );
if handles.version == 1
    %     xlabel_text2 =
    uicontrol( ...
        'Parent', psignal, ...
        'Style', 'text', ...
        'HorizontalAlignment', 'left', ...
        'FontSize', 8, ...
        'String', 'Analog', ...
        'Position', [0, 400, 50, 15] ...
        );
else
    %     xlabel_text2 =
    uicontrol( ...
        'Parent', psignal, ...
        'Style', 'text', ...
        'HorizontalAlignment', 'left', ...
        'FontSize', 8, ...
        'String', 'Channels', ...
        'Position', [0, 400, 50, 15] ...
        );
end

% xlabel_text3 =
uicontrol( ...
    'Parent', psignal, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 8, ...
    'String', 'Calcium', ...
    'Position', [0, 200, 50, 15] ...
    );

% xlabel_text4 =
uicontrol( ...
    'Parent', psignal, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 8, ...
    'String', 'Fusion', ...
    'Position', [2, 100, 50, 15] ...
    );


%%%%%%%%%%%%%%%%%
%               %
%    Channels   %
%    Screens    %
%               %
%%%%%%%%%%%%%%%%%

% Create Button Group and buttons
channels_screens = uibuttongroup( ...
    'Parent', f, ...
    'Units', 'Pixels', ...
    'Title', 'Channels Screens', ...
    'Fontsize', 9, ...
    'Position', [825, 255, 425, 600] ...
    );

% xlabel_text      =
uicontrol( ...
    'Parent', channels_screens, ...
    'Style', 'text', ...
    'Fontsize', 9, ...
    'String', 'Time (sec)', ...
    'Position', [170, 12, 80, 20] ...
    );

% Create Channels Screens
handles.axe_channel_scrn_1 = axes( ...
    'Parent', channels_screens, ...
    'Units', 'Pixels', ...
    'Color', 'w', ...
    'Position', [35, 475, 380, 80] ...
    );

handles.axe_channel_scrn_2 = axes( ...
    'Parent', channels_screens, ...
    'Units', 'Pixels', ...
    'Color', 'w', ...
    'Position', [35, 340, 380, 80] ...
    );

handles.axe_channel_scrn_3 = axes( ...
    'Parent', channels_screens, ...
    'Units', 'Pixels', ...
    'Color', 'w', ...
    'Position', [35, 205, 380, 80] ...
    );

handles.axe_channel_scrn_4 = axes( ...
    'Parent', channels_screens, ...
    'Units', 'Pixels', ...
    'Color', 'w', ...
    'Position', [35, 70, 380, 80] ...
    );

if handles.version == 1
    scrn_popup_choice = {'None', 'Analog 1', 'Analog 2', 'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4', 'Channel 5', 'Channel 6'};
else
    scrn_popup_choice = {'None', 'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
end

scrn1_popup = uicontrol( ...
    'Parent', channels_screens, ...
    'Style', 'popupmenu', ...
    'FontSize', 8, ...
    'String', scrn_popup_choice, ...
    'Position', [300, 575, 100, 8], ...
    'ToolTipString', 'Select the desired signal to display', ...
    'Callback', {@scrn_popup_callback} ...
    );

scrn2_popup = uicontrol( ...
    'Parent', channels_screens, ...
    'Style', 'popupmenu', ...
    'FontSize', 8, ...
    'String', scrn_popup_choice, ...
    'Position', [300, 440, 100, 8], ...
    'ToolTipString', 'Select the desired signal to display', ...
    'Callback', {@scrn_popup_callback} ...
    );

scrn3_popup = uicontrol( ...
    'Parent', channels_screens, ...
    'Style', 'popupmenu', ...
    'FontSize', 8, ...
    'String', scrn_popup_choice, ...
    'Position', [300, 305, 100, 8], ...
    'ToolTipString', 'Select the desired signal to display', ...
    'Callback', {@scrn_popup_callback} ...
    );

scrn4_popup = uicontrol( ...
    'Parent', channels_screens, ...
    'Style', 'popupmenu', ...
    'FontSize', 8, ...
    'String', scrn_popup_choice, ...
    'Position', [300, 170, 100, 8], ...
    'ToolTipString', 'Select the desired signal to display', ...
    'Callback', {@scrn_popup_callback} ...
    );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                       %
%    Sweep Bar Display for Optical Action Potentials    %
%                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%====================%
%     SWEEP BARS     %
%====================%

%create sweep bars for playing signal
handles.sweep_axes_1 = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'Layer', 'top', ...
    'NextPlot', 'replacechildren', ...
    'Visible', 'off', ...
    'Position', [40, 28, 230, heightsignal - 80] ...
    );


handles.sweep_axes_2 = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'Layer', 'top', ...
    'NextPlot', 'replacechildren', ...
    'Visible', 'off', ...
    'Position', [310, 28, 230, heightsignal - 82] ...
    );

handles.sweep_axes_3 = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'Layer', 'top', ...
    'NextPlot', 'replacechildren', ...
    'Visible', 'off', ...
    'Position', [580, 28, 230, heightsignal - 82] ...
    );

handles.sweep_axes_channels_screens = axes( ...
    'Parent', channels_screens, ...
    'Units', 'Pixels', ...
    'Layer', 'top', ...
    'NextPlot', 'replacechildren', ...
    'Visible', 'off', ...
    'Position', [35, 70, 380, 482] ...
    );

handles.sweep_bar_1 = line( ...
    'YData', [0, 1], ...
    'Visible', 'off', ...
    'Parent', handles.sweep_axes_1 ...
    );

handles.sweep_bar_2 = line( ...
    'YData', [0, 1], ...
    'Visible', 'off', ...
    'Parent', handles.sweep_axes_2 ...
    );

handles.sweep_bar_3 = line( ...
    'YData', [0, 1], ...
    'Visible', 'off', ...
    'Parent', handles.sweep_axes_3 ...
    );

handles.sweep_bar_start_channels = line( ...
    'YData', [0, 1], ...
    'Visible', 'off', ...
    'Parent', handles.sweep_axes_channels_screens ...
    );

%===================%
%     TIME BARS     %
%===================%

%create axes for time bars
handles.time_bar_1 = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'Layer', 'top', ...
    'NextPlot', 'replacechildren', ...
    'Visible', 'off', ...
    'Position', [40, 28, 230, heightsignal - 82] ...
    );

handles.time_bar_2 = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'Layer', 'top', ...
    'NextPlot', 'replacechildren', ...
    'Visible', 'off', ...
    'Position', [310, 28, 230, heightsignal - 82] ...
    );

handles.time_bar_3 = axes( ...
    'Parent', psignal, ...
    'Units', 'Pixels', ...
    'Layer', 'top', ...
    'NextPlot', 'replacechildren', ...
    'Visible', 'off', ...
    'Position', [580, 28, 230, heightsignal - 82] ...
    );

handles.time_bar_channels = axes( ...
    'Parent', channels_screens, ...
    'Units', 'Pixels', ...
    'Layer', 'top', ...
    'NextPlot', 'replacechildren', ...
    'Visible', 'off', ...
    'Position', [35, 70, 380, 482] ...
    );

%create time bars begining
handles.bar_start_1 = line( ...
    'YData', [0, 1], ...
    'Visible', 'off', ...
    'Parent', handles.time_bar_1 ...
    );

handles.bar_start_2 = line( ...
    'YData', [0, 1], ...
    'Visible', 'off', ...
    'Parent', handles.time_bar_2 ...
    );

handles.bar_start_3 = line( ...
    'YData', [0, 1], ...
    'Visible', 'off', ...
    'Parent', handles.time_bar_3 ...
    );

handles.bar_start_channels = line( ...
    'YData', [0, 1], ...
    'Visible', 'off', ...
    'Parent', handles.time_bar_channels ...
    );


%create time bars ending
handles.bar_end_1 = line( ...
    'YData', [0, 1], ...
    'Visible', 'off', ...
    'Parent', handles.time_bar_1 ...
    );

handles.bar_end_2 = line( ...
    'YData', [0, 1], ...
    'Visible', 'off', ...
    'Parent', handles.time_bar_2 ...
    );

handles.bar_end_3 = line( ...
    'YData', [0, 1], ...
    'Visible', 'off', ...
    'Parent', handles.time_bar_3 ...
    );

handles.bar_end_channels = line( ...
    'YData', [0, 1], ...
    'Visible', 'off', ...
    'Parent', handles.time_bar_channels ...
    );


% Optical Action Potential Analysis Button Group and Buttons
% Create Button Group

tgroup = uitabgroup( ...
    'Parent', f, ...
    'Units', 'Pixels', ...
    'Position', [825, 0, 425, 250] ...
    );

cond_sig = uitab( ...
    'Parent', tgroup, ...
    'ToolTipString', 'Processing signal of the first screen (left)', ...
    'Title', 'Condition Signals 1' ...
    );

cond_sig2 = uitab( ...
    'Parent', tgroup, ...
    'ToolTipString', 'Processing signal of the second screen (right)', ...
    'Title', 'Condition Signals 2' ...
    );

anal_data = uitab( ...
    'Parent', tgroup, ...
    'ToolTipString', 'Analyzing the potential Data_1', ...
    'Title', 'Potential' ...
    );

calc_signa = uitab( ...
    'Parent', tgroup, ...
    'ToolTipString', 'Analyzing the calcium Data_1', ...
    'Title', 'Calcium' ...
    );

plug_tab = uitab( ...
    'Parent', tgroup, ...
    'Title', 'Plug ins' ...
    );


%----------------------------------------------%
% Signal Conditioning Button Group and Buttons %
%----------------------------------------------%

cond_sign_scrns_button_1 = uicontrol( ...
    'Parent', cond_sig, ...
    'Style', 'checkbox', ...
    'FontSize', 10, ...
    'String', 'Both Screens', ...
    'ToolTipString', 'Check to apply on both screens ', ...
    'Value', 0, ...
    'Position', [25,80, 150, 25], ...
    'Callback', {@both_screen_option_callback} ...
    );

cond_sign_scrns_button_2 = uicontrol( ...
    'Parent', cond_sig2, ...
    'Style', 'checkbox', ...
    'FontSize', 10, ...
    'String', 'Both Screens', ...
    'ToolTipString', 'Check to apply on both screens ', ...
    'Value', 0, ...
    'Position', [25,80, 150, 25], ...
    'Callback', {@both_screen_option_callback} ...
    );

working_interval_1=uicontrol( ...
    'Parent', cond_sig, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Processing on time interval', ...
    'Position', [90, 220, 300, 25], ...
    'ToolTipString', 'Processing on time interval selected in the box below the movies. Do not select the initial values', ...
    'Value', 0 ,...
    'Callback', {@interval_option_callback} ...
    );
working_interval_2=uicontrol( ...
    'Parent', cond_sig2, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Processing on time interval', ...
    'Position', [90, 220, 300, 25], ...
    'ToolTipString', 'Processing on time interval selected in the box below the movies. Do not select the initial values.', ...
    'Value', 0, ...
    'Callback', {@interval_option_callback} ...
    );

removeBG_button_1 = uicontrol( ...
    'Parent', cond_sig, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Remove Background', ...
    'Position', [25, 180, 150, 25], ...
    'ToolTipString', 'Enter the parameter values below, check here, press "Apply"', ...
    'Value', 1 ...
    );

removeBG_button_2 = uicontrol( ...
    'Parent', cond_sig2, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Remove Background', ...
    'ToolTipString', 'Enter the parameter values below, check here, press "Apply"', ...
    'Position', [25, 180, 150, 25], ...
    'Value', 1 ...
    );

% bg_thresh_label =
uicontrol( ...
    'Parent', cond_sig, ...
    'Style', 'text', ...
    'FontSize', 9, ...
    'String', 'BG Threshold', ...
    'Position', [45, 150, 80, 25] ...
    );

% bg_thresh_label2 =
uicontrol( ...
    'Parent', cond_sig2, ...
    'Style', 'text', ...
    'FontSize', 9, ...
    'String', 'BG Threshold', ...
    'Position', [45, 150, 80, 25] ...
    );

% perc_ex_label =
uicontrol( ...
    'Parent', cond_sig, ...
    'Style', 'text', ...
    'FontSize', 9, ...
    'String', 'EX Threshold', ...
    'Position', [45, 125, 80, 25] ...
    );

% perc_ex_label2 =
uicontrol( ...
    'Parent', cond_sig2, ...
    'Style', 'text', ...
    'FontSize', 9, ...
    'String', 'EX Threshold', ...
    'Position', [45, 125, 80, 25] ...
    );

bg_thresh_edit_1 = uicontrol( ...
    'Parent', cond_sig, ...
    'Style', 'edit', ...
    'Fontsize', 9, ...
    'String', '0.3', ...
    'Position', [130, 160, 35, 18] ...
    );

bg_thresh_edit_2 = uicontrol( ...
    'Parent', cond_sig2, ...
    'Style', 'edit', ...
    'Fontsize', 9, ...
    'String', '0.3', ...
    'Position', [130, 160, 35, 18] ...
    );

perc_ex_edit_1 = uicontrol( ...
    'Parent', cond_sig, ...
    'Style', 'edit', ...
    'Fontsize', 9, ...
    'String', '0.1', ...
    'Position', [130, 135, 35, 18] ...
    );

perc_ex_edit_2 = uicontrol( ...
    'Parent', cond_sig2, ...
    'Style', 'edit', ...
    'Fontsize', 9, ...
    'String', '0.1', ...
    'Position', [130, 135, 35, 18] ...
    );

bin_button_1 = uicontrol( ...
    'Parent', cond_sig, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Bin', ...
    'ToolTipString', 'Remove some noise, using the pixels mean of the selected matrix. Select the matrix size, check here, press "Apply"', ...
    'Position', [205, 180, 150, 25], ...
    'Value', 1 ...
    );

bin_button_2 = uicontrol( ...
    'Parent', cond_sig2, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Bin', ...
    'Position', [205, 180, 150, 25], ...
    'ToolTipString', 'Remove some noise, using the pixels mean of the selected matrix. Select the matrix size, check here, press "Apply"', ...
    'Value', 1 ...
    );

filt_button_1 = uicontrol( ...
    'Parent', cond_sig, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Filter', ...
    'Position', [205, 155, 150, 25], ...
    'ToolTipString', 'Select the filter value, check here, press "Apply"', ...
    'Value', 1 ...
    );

filt_button_2 = uicontrol( ...
    'Parent', cond_sig2, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Filter', ...
    'Position', [205, 155, 150, 25], ...
    'ToolTipString', 'Select the filter value, check here, press "Apply"', ...
    'Value', 1 ...
    );

removeDrift_button_1 = uicontrol( ...
    'Parent', cond_sig, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Drift', ...
    'ToolTipString', 'Adjust a slanted waveform to level off the baseline. Select the drift value, check here, press "Apply"', ...
    'Position', [205, 130, 150, 25] ...
    );

removeDrift_button_2 = uicontrol( ...
    'Parent', cond_sig2, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Drift', ...
    'ToolTipString', 'Adjust a slanted waveform to level off the baseline. Select the drift value, check here, press "Apply"', ...
    'Position', [205, 130, 150, 25] ...
    );

norm_button_1 = uicontrol( ...
    'Parent', cond_sig, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Normalize', ...
    'ToolTipString', 'Normalize Data_1 points to be within 0 and 1. Check here, press "Apply"', ...
    'Position', [25, 105, 125, 25], ...
    'Value', 1 ...
    );

norm_button_2 = uicontrol( ...
    'Parent', cond_sig2, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Normalize', ...
    'ToolTipString', 'Normalize Data_1 points to be within 0 and 1. Check here, press "Apply"', ...
    'Position', [25, 105, 125, 25], ...
    'Value', 1 ...
    );

apply_button_1 = uicontrol( ...
    'Parent', cond_sig, ...
    'Style', 'pushbutton', ...
    'Fontsize', 9, ...
    'String', 'Apply', ...
    'Position', [205, 80, 165, 30], ...
    'ToolTipString', 'Apply the selected process', ...
    'Callback', {@cond_sig_selcbk} ...
    );

apply_button_2 = uicontrol( ...
    'Parent', cond_sig2, ...
    'Style', 'pushbutton', ...
    'Fontsize', 9, ...
    'String', 'Apply', ...
    'Position', [205, 80, 165, 30], ...
    'ToolTipString', 'Apply the selected process', ...
    'Callback', {@cond_sig_selcbk} ...
    );

%Pop-up menu options
bin_popup_1 = uicontrol( ...
    'Parent', cond_sig, ...
    'Style', 'popupmenu', ...
    'Fontsize', 9, ...
    'String', {'3 x 3', '5 x 5', '7 x 7'}, ...
    'Position', [270, 185, 100, 17], ...
    'Value', 3 ...
    );

bin_popup_2 = uicontrol( ...
    'Parent', cond_sig2, ...
    'Style', 'popupmenu', ...
    'Fontsize', 9, ...
    'String', {'3 x 3', '5 x 5', '7 x 7'}, ...
    'Position', [270, 185, 100, 17], ...
    'Value', 3 ...
    );

filt_popup_1 = uicontrol( ...
    'Parent', cond_sig, ...
    'Style', 'popupmenu', ...
    'Fontsize', 9, ...
    'String', {'[0 50]', '[0 75]', '[0 100]', '[0 150]'}, ...
    'Value', 4, ...
    'Position', [270, 160, 100, 17] ...
    );

filt_popup_2 = uicontrol( ...
    'Parent', cond_sig2, ...
    'Style', 'popupmenu', ...
    'Fontsize', 9, ...
    'String', {'[0 50]', '[0 75]', '[0 100]', '[0 150]'}, ...
    'Value', 4, ...
    'Position', [270, 160, 100, 17] ...
    );

drift_popup_1 = uicontrol( ...
    'Parent', cond_sig, ...
    'Style', 'popupmenu', ...
    'Fontsize', 9, ...
    'String', {'1st Order', '2nd Order', '3rd Order', '4th Order'}, ...
    'Position', [270, 135, 100, 17] ...
    );

drift_popup_2 = uicontrol( ...
    'Parent', cond_sig2, ...
    'Style', 'popupmenu', ...
    'Fontsize', 9, ...
    'String', {'1st Order', '2nd Order', '3rd Order', '4th Order'}, ...
    'Position', [270, 135, 100, 17] ...
    );

%---------------%
% Analyze tab 1 %
%---------------%
% Invert Color Map Option
invert_cmap = uicontrol( ...
    'Parent', anal_data, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Invert Colormaps', ...
    'Position', [260, 220, 140, 25], ...
    'ToolTipString', 'Check it to invert the color of the map', ...
    'Callback', {@invert_cmap_callback} ...
    );

act_cmap = uicontrol( ...
    'Parent', anal_data, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Time option', ...
    'Position', [260, 180, 140, 25], ...
    'ToolTipString', 'Check it to define of a new time interval from the first upstroke to the last decrease' ...
    );

% starttimeamap_text =
uicontrol( ...
    'Parent', anal_data, ...
    'Style', 'text', ...
    'Fontsize', 9, ...
    'String', 'Start Time', ...
    'ToolTipString', 'Start time of the working interval', ...
    'Position', [0, 220, 80, 25] ...
    );

starttimeamap_edit = uicontrol( ...
    'Parent', anal_data, ...
    'Style', 'edit', ...
    'Fontsize', 9, ...
    'Position', [80, 220, 50, 25], ...
    'ToolTipString', 'Enter the start time of the working interval', ...
    'Callback', {@amaptime_edit_callback} ...
    );

% endtimeamap_text   =
uicontrol( ...
    'Parent', anal_data, ...
    'Style', 'text', ...
    'Fontsize', 9, ...
    'String', 'End Time', ...
    'ToolTipString', 'End time of the working interval', ...
    'Position', [130, 220, 80, 25] ...
    );

endtimeamap_edit = uicontrol( ...
    'Parent', anal_data, ...
    'Style', 'edit', ...
    'Fontsize', 9, ...
    'Position', [205, 220, 50, 25], ...
    'ToolTipString', 'Enter the end time of the working interval', ...
    'Callback', {@amaptime_edit_callback} ...
    );
% new zero  ......................................................
% new_zero_text_1 =
uicontrol( ...
    'Parent', anal_data, ...
    'Style', 'text', ...
    'Fontsize', 9, ...
    'String', 'New Start :', ...
    'Position', [10, 180, 80, 25] ...
    );
% new_zero_text_1_1 =
uicontrol( ...
    'Parent', anal_data, ...
    'Style', 'text', ...
    'Fontsize', 9, ...
    'String', '0', ...
    'Position', [100, 180, 20, 25] ...
    );
% new_end_text_1   =
uicontrol( ...
    'Parent', anal_data, ...
    'Style', 'text', ...
    'Fontsize', 9, ...
    'String', 'New End :', ...
    'ToolTipString', 'Value corresponding to the maximum time of the maps on this time interval', ...
    'Position', [130, 180, 80, 25] ...
    );

new_end_edit = uicontrol( ...
    'Parent', anal_data, ...
    'Style', 'text', ...
    'Fontsize', 9, ...
    'Position', [200, 180, 60, 25], ...
    'ToolTipString', 'Value corresponding to the maximum time of the maps on this time interval', ...
    'Callback', {@newEnd_callback} ...
    );


%push button


% actimap_button   =
uicontrol( ...
    'Parent', anal_data, ...
    'Style', 'pushbutton', ...
    'Fontsize', 9, ...
    'String', 'Activation Map', ...
    'Position', [250, 100, 120, 30], ...
    'ToolTipString', 'Create a map of all the activation time on the entered time interval', ...
    'Callback', {@createmap_button_callback} ...
    );

% APD Map
APD_map = uipanel( ...
    'Parent', anal_data, ...
    'Title', 'APD Map', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [0, 0, 240, 180] ...
    );

remove_motion_click = uicontrol( ...
    'Parent', APD_map, ...
    'Style', 'checkbox', ...
    'HorizontalAlignment', 'left', ...
    'Fontsize', 9, ...
    'String', 'Remove Motion', ...
    'Position', [0, 0, 0, 0] ...
    );

% validation_button_1   =
uicontrol( ...
    'Parent', APD_map, ...
    'Style', 'pushbutton', ...
    'HorizontalAlignment', 'left', ...
    'Fontsize', 9, ...
    'String', 'Global APD MAP | RT MAP', ...
    'ToolTipString', 'Create action potential duration and repolarization global maps of the entered time interval', ...
    'Position', [10, 50, 200, 30], ...
    'Callback', {@create_button_callback} ...
    );

% validation_button_1_1   =
uicontrol( ...
    'Parent', APD_map, ...
    'Style', 'pushbutton', ...
    'HorizontalAlignment', 'left', ...
    'Fontsize', 9, ...
    'String', 'Regional APD MAP | RT MAP', ...
    'Position', [10, 10, 200, 30], ...
    'ToolTipString', 'Create action potential duration and repolarization regional maps of the entered time interval. Click and select the desired region on the first screen.', ...
    'Callback', {@create_buttonR_callback} ...
    );


% minapd_text =
uicontrol( ...
    'Parent', APD_map, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 9, ...
    'String', 'Min APD', ...
    'ToolTipString', 'Enter the minimum range value of the action potential duration in milliseconds', ...
    'Position', [120, 120, 60, 25] ...
    );

minapd_edit = uicontrol( ...
    'Parent', APD_map, ...
    'Style', 'edit', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 9, ...
    'String', '0', ...
    'Position', [180, 120, 50, 25], ...
    'ToolTipString', 'Enter the minimum range value of the action potential duration in milliseconds', ...
    'Callback', {@minapd_edit_callback} ...
    );

% maxapd_text =
uicontrol( ...
    'Parent', APD_map, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 9, ...
    'String', 'Max APD', ...
    'ToolTipString', 'Enter the percentage of the action potential duration', ...
    'Position', [5, 115, 60, 25] ...
    );

maxapd_edit = uicontrol( ...
    'Parent', APD_map, ...
    'Style', 'edit', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 9, ...
    'String', '1000', ...
    'Position', [65, 120, 50, 25], ...
    'ToolTipString', 'Enter the maximum range value of the action potential duration in milliseconds', ...
    'Callback', {@maxapd_edit_callback} ...
    );

% percentapd_text     =
uicontrol( ...
    'Parent', APD_map, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 9, ...
    'String', '%APD', ...
    'ToolTipString', 'Enter the minimum range value of the action potential duration in milliseconds', ...
    'Position', [5, 85, 60, 25] ...
    );

percentapd_edit = uicontrol( ...
    'Parent', APD_map, ...
    'Style', 'edit', ...
    'HorizontalAlignment', 'left', ...
    'Fontsize', 9, ...
    'String', '0.8', ...
    'ToolTipString', 'Enter the maximum range value of the action potential duration in milliseconds', ...
    'Position', [65, 90, 50, 25], ...
    'callback', {@percentapd_edit_callback} ...
    );


%---------------%
% Calcium tab   %
%---------------%


% starttimeamap_text =
uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'text', ...
    'Fontsize', 9, ...
    'String', 'Start Time', ...
    'ToolTipString', 'Start time of the working interval', ...
    'Position', [0, 220, 80, 25] ...
    );

starttimeamap_edit2 = uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'edit', ...
    'Fontsize', 9, ...
    'Position', [80, 220, 50, 25], ...
    'ToolTipString', 'Enter the start time of the working interval', ...
    'Callback', {@amaptime_edit_callback2} ...
    );

% endtimeamap_text   =
uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'text', ...
    'Fontsize', 9, ...
    'String', 'End Time', ...
    'ToolTipString', 'End time of the working interval', ...
    'Position', [130, 220, 80, 25] ...
    );

endtimeamap_edit2 = uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'edit', ...
    'Fontsize', 9, ...
    'ToolTipString', 'Enter the end time of the working interval', ...
    'Position', [205, 220, 50, 25], ...
    'Callback', {@amaptime_edit_callback2} ...
    );

% CAD_map =
uipanel( ...
    'Parent', calc_signa, ...
    'Title', 'Select the map(s) desired', ...
    'Units', 'Pixels', ...
    'Fontsize', 9, ...
    'Position', [0, 0, 420, 200] ...
    );
% mincad_text        =
uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 9, ...
    'ToolTipString', 'Enter the minimum range value of the calcium duration in milliseconds', ...
    'String', 'Min', ...
    'Position', [10, 145, 60, 25]);

% mincad_edit        =
uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'edit', ...
    'HorizontalAlignment', 'left', ...
    'Fontsize', 9, ...
    'String', '0', ...
    'Position', [35, 150, 50, 25], ...
    'ToolTipString', 'Enter the minimum range value of the calcium duration in milliseconds', ...
    'Callback', {@minapd_edit_callback2});

% maxcad_text        =
uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 9, ...
    'String', 'Max', ...
    'ToolTipString', 'Enter the maximum range value of the calcium duration in milliseconds', ...
    'Position', [10, 115, 60, 25]);

% maxcad_edit       =
uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'edit', ...
    'HorizontalAlignment', 'left', ...
    'Fontsize', 9, ...
    'String', '1000', ...
    'ToolTipString', 'Enter the maximum range value of the calcium duration in milliseconds', ...
    'Position', [35, 120, 50, 25], ...
    'Callback', {@maxapd_edit_callback2});

TTP_box = uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Time-To-Peak', ...
    'ToolTipString', 'Time between the begin of the upstroke to the peak of the upstroke', ...
    'Position', [130, 130, 140, 25]);

Tfall = uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'Tfall', ...
    'ToolTipString', 'Time required for Ca2+ extrusion to reach ~63,2% of the baseline', ...
    'Position', [130, 105, 50, 25]);

cad30_cad80 = uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', 'CaD30/CaD80', ...
    'ToolTipString', 'Ratio of early extrusion phase to late extrusion phase', ...
    'Position', [270, 150, 140, 25]);

CaD_box = uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', '%CaD', ...
    'ToolTipString', 'Ca2+ duration from the begin of the upstroke to x% of the extrusion phase', ...
    'Position', [270, 120, 100, 25]);


percentcad_edit = uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'edit', ...
    'HorizontalAlignment', 'left', ...
    'Fontsize', 9, ...
    'String', '0.8', ...
    'ToolTipString', 'Ca2+ duration from the begin of the upstroke to x% of the extrusion phase', ...
    'Position', [330, 120, 40, 25]);

CaD_APD_box = uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'checkbox', ...
    'Fontsize', 9, ...
    'String', '%CaD-APD', ...
    'ToolTipString', 'Difference between Ca2+ transient duration and optical action potential duration', ...
    'Position', [270, 90, 100, 25]);


percentcad_apd_edit = uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'edit', ...
    'HorizontalAlignment', 'left', ...
    'Fontsize', 9, ...
    'String', '0.8', ...
    'Position', [370, 90, 40, 25], ...
    'ToolTipString', 'Difference between Ca2+ transient duration and optical action potential duration', ...
    'callback', {@percentapd_edit_callback2});

% Calc_button      =
uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'pushbutton', ...
    'Fontsize', 9, ...
    'String', 'Create map(s)', ...
    'Position', [245, 20, 120, 30], ...
    'ToolTipString', 'Create the whole map of the selected maps', ...
    'Callback', {@calcinfo_button_callback});

% Calc_regional_button      =
uicontrol( ...
    'Parent', calc_signa, ...
    'Style', 'pushbutton', ...
    'Fontsize', 9, ...
    'String', 'Create Regional map(s)', ...
    'Position', [40, 20, 150, 30], ...
    'ToolTipString', 'Create regional map of the selected maps', ...
    'Callback', {@calcinfo_regional_button_callback});


% Plug-In
plugin_group = uibuttongroup( ...
    'Parent', anal_data, ...
    'Title', 'Plug Ins', ...
    'FontSize', 12, ...
    'Position', [0, 0, 0, 0] ...
    );


% starttimebtstrp_text =
uicontrol( ...
    'Parent', plugin_group, ...
    'Style', 'text', ...
    'FontSize', 12, ...
    'String', 'Start Time', ...
    'Position', [0, 0, 57, 25] ...
    );

starttimebtstrp_edit = uicontrol( ...
    'Parent', plugin_group, ...
    'Style', 'edit', ...
    'FontSize', 12, ...
    'Position', [85, 74, 55, 22], ...
    'Callback', {@btstrptime_edit_callback});

% endtimebtstrp_text =
uicontrol( ...
    'Parent', plugin_group, ...
    'Style', 'text', ...
    'FontSize', 12, ...
    'String', 'End Time', ...
    'Position', [0, 0, 54, 25] ...
    );

endtimebtstrp_edit = uicontrol( ...
    'Parent', plugin_group, ...
    'Style', 'edit', ...
    'FontSize', 12, ...
    'Position', [0, 0, 55, 22], ...
    'Callback', {@btstrptime_edit_callback} ...
    );

% grps_text =
uicontrol( ...
    'Parent', plugin_group, ...
    'Style', 'text', ...
    'FontSize', 12, ...
    'String', 'Max Groups', ...
    'Position', [0, 0, 68, 25] ...
    );

grp_edit = uicontrol( ...
    'Parent', plugin_group, ...
    'Style', 'edit', ...
    'String', '10', ...
    'FontSize', 14, ...
    'Position', [0, 0, 55, 22] ...
    );

%-------------------%
% Fin analyse tab 1 %
%-------------------%


%-------------%
% Plug-In tab %
%-------------%

% createphase_button   =
uicontrol( ...
    'Parent', plug_tab, ...
    'Style', 'pushbutton', ...
    'Fontsize', 9, ...
    'String', 'Calculate Phase', ...
    'Position', [10, 200, 170, 30], ...
    'Callback', {@createphase_button_callback} ...
    );

% createDomFreq_button =
uicontrol( ...
    'Parent', plug_tab, ...
    'Style', 'pushbutton', ...
    'Fontsize', 9, ...
    'String', 'Dominant Frequency', ...
    'Position', [10, 165, 170, 30], ...
    'Callback', {@calcDomFreq_button_callback} ...
    );

% createSegData_button =
uicontrol( ...
    'Parent', plug_tab, ...
    'Style', 'pushbutton', ...
    'Fontsize', 9, ...
    'String', 'Bootstrap Analysis', ...
    'Position', [10, 130, 170, 30], ...
    'Callback', {@calcSegData_button_callback} ...
    );

% starttimebtstrp_text =
uicontrol( ...
    'Parent', plug_tab, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'Fontsize', 9, ...
    'String', 'Start Time', ...
    'Position', [200, 200, 75, 25] ...
    );

starttimebtstrp_edit = uicontrol( ...
    'Parent', plug_tab, ...
    'Style', 'edit', ...
    'Fontsize', 9, ...
    'Position', [290, 200, 55, 25], ...
    'Callback', {@btstrptime_edit_callback} ...
    );

% endtimebtstrp_text   =
uicontrol( ...
    'Parent', plug_tab, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'Fontsize', 9, ...
    'String', 'End Time', ...
    'Position', [200, 165, 75, 25] ...
    );

endtimebtstrp_edit = uicontrol( ...
    'Parent', plug_tab, ...
    'Style', 'edit', ...
    'Fontsize', 9, ...
    'Position', [290, 165, 55, 25], ...
    'Callback', {@btstrptime_edit_callback} ...
    );

% grps_text =
uicontrol( ...
    'Parent', plug_tab, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'Fontsize', 9, ...
    'String', 'Max Groups', ...
    'Position', [200, 130, 75, 25] ...
    );

grp_edit = uicontrol( ...
    'Parent', plug_tab, ...
    'Style', 'edit', ...
    'Fontsize', 9, ...
    'Position', [290, 130, 55, 25] ...
    );

%-----------------%
% Fin Plug-In tab %
%-----------------%

%-----------------%
% Color creation  %
%-----------------%

orange_red = [255, 69, 0] / 255;
dark_orange = [255, 140, 0] / 255;

dark_green = [0, 100, 0] / 255;
lime_green = [50, 205, 50] / 255;

medium_blue = [0, 0, 205] / 255;
dodger_blue = [30, 144, 255] / 255;

handles.line_signal_scrn_1_ana_1 = line(0, 0, 'Color', 'black', 'LineWidth', 1, 'Parent', handles.axe_signal_scrn_1_ana);
handles.line_signal_scrn_2_ana_1 = line(0, 0, 'Color', 'black', 'LineWidth', 1, 'Parent', handles.axe_signal_scrn_2_ana);
handles.line_signal_scrn_3_ana_1 = line(0, 0, 'Color', 'black', 'LineWidth', 1, 'Parent', handles.axe_signal_scrn_3_ana);

handles.line_signal_scrn_1_1_1 = line(0, 0, 'Color', medium_blue, 'LineWidth', 1, 'Parent', handles.axe_signal_scrn_1_1);
handles.line_signal_scrn_2_1_1 = line(0, 0, 'Color', dark_green, 'LineWidth', 1, 'Parent', handles.axe_signal_scrn_2_1);
handles.line_signal_scrn_3_1_1 = line(0, 0, 'Color', orange_red, 'LineWidth', 1, 'Parent', handles.axe_signal_scrn_3_1);

handles.line_signal_scrn_1_2_1 = line(0, 0, 'Color', dodger_blue, 'LineWidth', 1, 'Parent', handles.axe_signal_scrn_1_2);
handles.line_signal_scrn_2_2_1 = line(0, 0, 'Color', lime_green, 'LineWidth', 1, 'Parent', handles.axe_signal_scrn_2_2);
handles.line_signal_scrn_3_2_1 = line(0, 0, 'Color', dark_orange, 'LineWidth', 1, 'Parent', handles.axe_signal_scrn_3_2);

handles.line_signal_scrn_1_3_1 = line(0, 0, 'Color', medium_blue, 'LineWidth', 1, 'Parent', handles.axe_signal_scrn_1_3);
handles.line_signal_scrn_1_3_2 = line(0, 0, 'Color', dodger_blue, 'LineWidth', 1, 'Parent', handles.axe_signal_scrn_1_3);

handles.line_signal_scrn_2_3_1 = line(0, 0, 'Color', dark_green, 'LineWidth', 1, 'Parent', handles.axe_signal_scrn_2_3);
handles.line_signal_scrn_2_3_2 = line(0, 0, 'Color', lime_green, 'LineWidth', 1, 'Parent', handles.axe_signal_scrn_2_3);

handles.line_signal_scrn_3_3_1 = line(0, 0, 'Color', orange_red, 'LineWidth', 1, 'Parent', handles.axe_signal_scrn_3_3);
handles.line_signal_scrn_3_3_2 = line(0, 0, 'Color', dark_orange, 'LineWidth', 1, 'Parent', handles.axe_signal_scrn_3_3);

%Create Line for channels screen
handles.line_channel_scrn_1 = line(0, 0, 'Color', 'black', 'LineWidth', 1, 'Parent', handles.axe_channel_scrn_1);
handles.line_channel_scrn_2 = line(0, 0, 'Color', 'black', 'LineWidth', 1, 'Parent', handles.axe_channel_scrn_2);
handles.line_channel_scrn_3 = line(0, 0, 'Color', 'black', 'LineWidth', 1, 'Parent', handles.axe_channel_scrn_3);
handles.line_channel_scrn_4 = line(0, 0, 'Color', 'black', 'LineWidth', 1, 'Parent', handles.axe_channel_scrn_4);

%medium_orchid=[186,85,211]/255;

%% GUI PROPERTIES

%-----------------%
% GUI PROPERTIES  %
%-----------------%

% Allow all GUI structures to bte scaled when window is dragged
h_fig = findobj(f, '-not', 'Units', 'normalized');
lgt_h_fig = length(h_fig);
for k = 1:lgt_h_fig
    if isprop(h_fig(k), 'Units')
        set(h_fig(k), 'Units', 'normalized')
    end
end
movegui(f, 'center')

%% Data_1 IMPORT FROM 1ST INTERFACE

% Initialize handles
handles.displayedwavecount_1 = 0;
handles.rightpanelcount = 0;
handles.analogcount = 0;
handles.grabbed_3 = -1;
handles.M1 = [[0, 0]; [0, 0]; [0, 0]];
handles.M2 = [[0, 0]; [0, 0]; [0, 0]]; % this handle stores the locations of the markers
handles.graphdisplayed = 0;
handles.symmetry = 0; %this handle indicate if symmetry is clicked
handles.scatrewrite = false;
handles.normflag = 0; % this handle indicate if normalize is clicked
handles.wave_window = 1; % this handle indicate the window number of the next wave displayed
handles.frame_1 = 1; % this handles indicate the current frame being displayed by the movie screen for the first video
handles.frame_2 = 1; % this handles indicate the current frame being displayed by the movie screen for the second video
handles.slide = -1; % this handle indicate if the movie slider is clicked
handles.cmap = colormap('Jet'); %saves the default colormap values
handles.invert = 0;
% Convert and/or Load File
handles.dir_1 = directory;
handles.filename_1 = filename;
%condition signals handles
handles.state_bg='Background not removed';
handles.state_norm='Not normalized ';
handles.state_bin='Not binned ';
handles.state_filt= 'Not filtered ';
handles.state_drift=' Not drifted ' ;

%ICI
[SData,handles] = Load_Rhythm_Data(handles,3);
if length(SData)>1
    Data_1 = SData.Data_1;
    Data_2 = SData.Data_2;
elseif length(SData)==1
    Data_1 = SData.Data_1;
end

%Analog display
Fs = round(handles.Fs/ 1000, 4);

uicontrol( ...
    'Parent', pmovies, ...
    'Style', 'text', ...
    'HorizontalAlignment', 'left', ...
    'Fontsize', 9, ...
    'String', ['Sampling Frequency : ', num2str(Fs),  ' KHz'], ...
    'Position', [450, 1, 200, 25] ...
    );
handles.time = (1:size(handles.cmosData_1, 3)) / handles.Fs;
if handles.version == 1
    if isfield(Data_1, 'Analog1')
        handles.analog1 = Data_1.Analog1(:, 2:end);
        set(analog_popup, 'Value', 2)
        handles.analogcount = 1;
        set(handles.line_signal_scrn_1_ana_1, 'XData', handles.time, 'YData', squeeze(handles.analog1(:, :)))
        set(handles.line_signal_scrn_2_ana_1, 'XData', handles.time, 'YData', squeeze(handles.analog1(:, :)))
        set(handles.line_signal_scrn_3_ana_1, 'XData', handles.time, 'YData', squeeze(handles.analog1(:, :)))
    else
        if isfield(Data_1, 'Analog2')
            handles.analog2 = Data_1.Analog2(:, 2:end);
            set(analog_popup, 'Value', 3)
            handles.analogcount = 1;
            set(handles.line_signal_scrn_1_ana_1, 'XData', handles.time, 'YData', squeeze(handles.analog2(:, :)), 'XLim', [min(handles.time), max(handles.time)])
            set(handles.line_signal_scrn_2_ana_1, 'XData', handles.time, 'YData', squeeze(handles.analog2(:, :)), 'XLim', [min(handles.time), max(handles.time)])
            set(handles.line_signal_scrn_3_ana_1, 'XData', handles.time, 'YData', squeeze(handles.analog2(:, :)), 'XLim', [min(handles.time), max(handles.time)])
        else
            set(analog_popup, 'Value', 1)
            handles.analogcount = 0;
            set(handles.line_signal_scrn_1_ana_1, 'XData', 0, 'YData', 0)
            set(handles.line_signal_scrn_2_ana_1, 'XData', 0, 'YData', 0)
            set(handles.line_signal_scrn_3_ana_1, 'XData', 0, 'YData', 0)
        end
    end
end


%%%%%%%%% WINDOWED Data_1 %%%%%%%%%%
handles.matrixMax = .9 * max(handles.cmosData_1(:));
handles.matrixMax2 = .9 * max(handles.cmosData_2(:));
% Data_1.channel1 is not necessarily the ecg channel. Please make changes based on your specific situation
if handles.version == 1
    handles.ecg = Data_1.channel1;
end
% Initialize movie screen to the first frame

set(f, 'CurrentAxes', handles.movie_scrn_1);
G = real2rgb(handles.bg, 'gray');
Mframe = handles.cmosData_1(:, :, handles.frame_1);
J = real2rgb(Mframe, 'jet');
A = real2rgb(Mframe >= handles.minVisible, 'gray');
I = J .* A + G .* (1 - A);
set(handles.movie_scrn_1, 'Xlim', [0, 100], 'Ylim', [0, 100]);
handles.movie_img1 = image(I, 'Parent', handles.movie_scrn_1, 'tag', 'image1');

set(f, 'CurrentAxes', handles.movie_scrn_2);
G2 = real2rgb(handles.bg2, 'gray');
Mframe2 = handles.cmosData_2(:, :, handles.frame_2);
J2 = real2rgb(Mframe2, 'jet');
A2 = real2rgb(Mframe2 >= handles.minVisible, 'gray');
I2 = J2 .* A2 + G2 .* (1 - A2);
set(handles.movie_scrn_2, 'Xlim', [0, 100], 'Ylim', [0, 100]);
handles.movie_img2 = image(I2, 'Parent', handles.movie_scrn_2, 'tag', 'image2');

% Scale signal screens and sweep bar to appropriate time scale
handles.time = (1:size(handles.cmosData_1, 3)) / handles.Fs;

%for the Signal Display panel
set(handles.axe_signal_scrn_1_1, 'XLim', [min(handles.time), max(handles.time)])
set(handles.axe_signal_scrn_2_1, 'XLim', [min(handles.time), max(handles.time)])
set(handles.axe_signal_scrn_3_1, 'XLim', [min(handles.time), max(handles.time)])

set(handles.time_bar_1, 'XLim', [min(handles.time), max(handles.time)])
set(handles.time_bar_2, 'XLim', [min(handles.time), max(handles.time)])
set(handles.time_bar_3, 'XLim', [min(handles.time), max(handles.time)])

set(handles.axe_signal_scrn_1_ana, 'XLim', [min(handles.time), max(handles.time)])
set(handles.axe_signal_scrn_2_ana, 'XLim', [min(handles.time), max(handles.time)])
set(handles.axe_signal_scrn_3_ana, 'XLim', [min(handles.time), max(handles.time)])

set(handles.axe_signal_scrn_1_2, 'XLim', [min(handles.time), max(handles.time)])
set(handles.axe_signal_scrn_2_2, 'XLim', [min(handles.time), max(handles.time)])
set(handles.axe_signal_scrn_3_2, 'XLim', [min(handles.time), max(handles.time)])

set(handles.axe_signal_scrn_1_3, 'XLim', [min(handles.time), max(handles.time)])
set(handles.axe_signal_scrn_2_3, 'XLim', [min(handles.time), max(handles.time)])
set(handles.axe_signal_scrn_3_3, 'XLim', [min(handles.time), max(handles.time)])

set(handles.sweep_axes_1, 'XLim', [min(handles.time), max(handles.time)], 'NextPlot', 'replacechildren')
set(handles.sweep_axes_2, 'XLim', [min(handles.time), max(handles.time)], 'NextPlot', 'replacechildren')
set(handles.sweep_axes_3, 'XLim', [min(handles.time), max(handles.time)], 'NextPlot', 'replacechildren')


%for the Channels Screens

set(handles.axe_channel_scrn_1, 'XLim', [min(handles.time), max(handles.time)])
set(handles.axe_channel_scrn_2, 'XLim', [min(handles.time), max(handles.time)])
set(handles.axe_channel_scrn_3, 'XLim', [min(handles.time), max(handles.time)])
set(handles.axe_channel_scrn_4, 'XLim', [min(handles.time), max(handles.time)])

set(handles.time_bar_channels, 'XLim', [min(handles.time), max(handles.time)], 'NextPlot', 'replacechildren')
set(handles.sweep_axes_channels_screens, 'XLim', [min(handles.time), max(handles.time)], 'NextPlot', 'replacechildren')

% Fill times into activation map editable textboxes
handles.starttime = min(handles.time);
handles.endtime = max(handles.time);
set(starttimemap_edit, 'String', num2str(handles.starttime))
set(endtimemap_edit, 'String', num2str(handles.endtime))
set(starttimeamap_edit, 'String', num2str(handles.starttime))
set(endtimeamap_edit, 'String', num2str(handles.endtime))
set(starttimeamap_edit2, 'String', num2str(handles.starttime))

set(endtimeamap_edit2, 'String', num2str(handles.endtime))
set(starttimebtstrp_edit, 'String', num2str(handles.starttime))
set(endtimebtstrp_edit, 'String', num2str(handles.endtime))

% Initialize movie slider to the first frame
set(movie_slider, 'Value', 0)



set(f, 'CurrentAxes', handles.movie_scrn_2);
axis off;

set(f, 'CurrentAxes', handles.movie_scrn_1);
axis off;

set(gca, 'NextPlot', 'add')

sz = 40;
colaxscat = [[0, 0, 1]; [0, 1, 0]; [1, 0, 0]];

handles.scatM2 = scatter(handles.M2(:, 1), handles.M2(:, 2), sz, colaxscat, 'filled', 'Marker', 'square', 'MarkerEdgeColor', [1, 1, 1], 'Parent', handles.movie_scrn_2);
handles.scatM1 = scatter(handles.M1(:, 1), handles.M1(:, 2), sz, colaxscat, 'filled', 'Marker', 'square', 'MarkerEdgeColor', [1, 1, 1], 'Parent', handles.movie_scrn_1);
set([handles.scatM1, handles.scatM2], 'buttondownfcn', {@button_down_function});

% Mouse Listening Function
set(f, 'WindowButtonUpFcn', {@button_up_function});
set(f, 'WindowButtonMotionFcn', {@button_motion_function});
set([f, handles.bar_start_1, handles.bar_start_2, handles.bar_start_3, handles.bar_start_channels, ...
    handles.bar_end_1, handles.bar_end_2, handles.bar_end_3, handles.bar_end_channels, ...
    handles.time_bar_1, handles.time_bar_2, handles.time_bar_3, handles.movie_scrn_1, handles.movie_scrn_2], 'buttondownfcn', {@button_down_function});
handles.vw_start = str2double(get(starttimemap_edit, 'String'));
handles.vw_end = str2double(get(endtimemap_edit, 'String'));

%% CALLBACK %%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
%   All Callback functions   %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% USER FUNCTIONALITY
%% Listen for mouse clicks for the point-dragger
% When mouse button is clicked and held find associated marker
    function button_down_function(obj, ~)
        theaxes = ancestor(obj, 'axes');
        test = get(theaxes, 'XLim') == [handles.vw_start, handles.vw_end];
        if test(1, 1) == 1
            theaxes2 = ancestor(obj, 'line');
            ps2 = get(theaxes2, 'XData');
            i_temp2 = ps2(1, 1) + 0.005;
            j_temp2 = ps2(1, 1) - 0.005;
            barlist = [handles.bar_start_1, handles.bar_start_2, handles.bar_start_3, handles.bar_start_channels, handles.bar_end_1, handles.bar_end_2, handles.bar_end_3, handles.bar_end_channels];
            for j = 1:8
                currentBar = get(barlist(j), 'XData');
                if i_temp2 > currentBar(1) && j_temp2 < currentBar(1)
                    handles.grabbed_3 = j;
                    break
                end
            end
            
        elseif theaxes == handles.movie_scrn_2
            ps2 = get(gca, 'CurrentPoint');
            i_temp2 = round(ps2(1, 1)) - 2;
            i_temp3 = round(ps2(1, 1)) + 2;
            j_temp2 = round(ps2(2, 2)) - 2;
            j_temp3 = round(ps2(2, 2)) + 2;
            if i_temp3 <= size(handles.cmosData_2, 1) || j_temp3 < size(handles.cmosData_2, 2) || i_temp2 > 1 || j_temp2 > 1
                if size(handles.M2, 1) > 0
                    for j = 1:size(handles.M2, 1)
                        if handles.M2(j, 1) >= i_temp2 && handles.M2(j, 2) >= j_temp2 && handles.M2(j, 1) <= i_temp3 && handles.M2(j, 2) <= j_temp3
                            handles.grabbed_2 = j;
                            break
                        end
                    end
                end
            end
        elseif theaxes == handles.movie_scrn_1
            ps2 = get(gca, 'CurrentPoint');
            i_temp2 = round(ps2(1, 1)) - 2;
            i_temp3 = round(ps2(1, 1)) + 2;
            j_temp2 = round(ps2(2, 2)) - 2;
            j_temp3 = round(ps2(2, 2)) + 2;
            % if one of the markers on the movie screen is clicked
            if i_temp3 <= size(handles.cmosData_1, 1) || j_temp3 < size(handles.cmosData_1, 2) || i_temp2 > 1 || j_temp2 > 1
                if size(handles.M1, 1) > 0
                    for j = 1:size(handles.M1, 1)
                        if handles.M1(j, 1) >= i_temp2 && handles.M1(j, 2) >= j_temp2 && handles.M1(j, 1) <= i_temp3 && handles.M1(j, 2) <= j_temp3
                            handles.grabbed_1 = j;
                            break
                        end
                    end
                end
            end
        end
    end

%% Bar time activation
    function timebar_button_callback(~, ~)
        % get the bounds of the viewing window
        if handles.timebar_button
            
            handles.vw_start = str2double(get(starttimemap_edit, 'String'));
            handles.vw_end = str2double(get(endtimemap_edit, 'String'));
            
            set(handles.bar_start_1, 'XData', [handles.vw_start, handles.vw_start], 'color', 'r', 'visible', 'off')
            set(handles.bar_end_1, 'XData', [handles.vw_end, handles.vw_end], 'color', 'r', 'visible', 'off')
            set(handles.bar_start_2, 'XData', [handles.vw_start, handles.vw_start], 'color', 'r', 'visible', 'off')
            set(handles.bar_end_2, 'XData', [handles.vw_end, handles.vw_end], 'color', 'r', 'visible', 'off')
            set(handles.bar_start_3, 'XData', [handles.vw_start, handles.vw_start], 'color', 'r', 'visible', 'off')
            set(handles.bar_end_3, 'XData', [handles.vw_end, handles.vw_end], 'color', 'r', 'visible', 'off')
            set(handles.bar_start_channels, 'XData', [handles.vw_start, handles.vw_start], 'color', 'r', 'visible', 'off')
            set(handles.bar_end_channels, 'XData', [handles.vw_end, handles.vw_end], 'color', 'r', 'visible', 'off')
            
            handles.timebar(1, :) = [handles.vw_start, handles.vw_end];
            handles.timebar(2, :) = [handles.vw_start, handles.vw_end];
            handles.timebar(3, :) = [handles.vw_start, handles.vw_end];
            
            
            handles.timebar_button = 0;
            hold off;
            
        else
            handles.vw_start = str2double(get(starttimemap_edit, 'String'));
            handles.vw_end = str2double(get(endtimemap_edit, 'String'));
            
            handles.timebar(1, :) = [handles.vw_start, handles.vw_end];
            handles.timebar(2, :) = [handles.vw_start, handles.vw_end];
            handles.timebar(3, :) = [handles.vw_start, handles.vw_end];
            
            set(handles.bar_start_1, 'XData', [handles.vw_start, handles.vw_start], 'color', 'r', 'visible', 'on')
            set(handles.bar_end_1, 'XData', [handles.vw_end, handles.vw_end], 'color', 'r', 'visible', 'on')
            set(handles.bar_start_2, 'XData', [handles.vw_start, handles.vw_start], 'color', 'r', 'visible', 'on')
            set(handles.bar_end_2, 'XData', [handles.vw_end, handles.vw_end], 'color', 'r', 'visible', 'on')
            set(handles.bar_start_3, 'XData', [handles.vw_start, handles.vw_start], 'color', 'r', 'visible', 'on')
            set(handles.bar_end_3, 'XData', [handles.vw_end, handles.vw_end], 'color', 'r', 'visible', 'on')
            set(handles.bar_start_channels, 'XData', [handles.vw_start, handles.vw_start], 'color', 'r', 'visible', 'on')
            set(handles.bar_end_channels, 'XData', [handles.vw_end, handles.vw_end], 'color', 'r', 'visible', 'on')
            
            handles.timebar_button = 1;
            hold off; axis off;
            
        end
        
        
    end
%% When mouse button is released
    function button_up_function(~, ~)
        handles.grabbed_1 = -1;
        handles.grabbed_2 = -1;
        handles.grabbed_3 = -1;
    end

%% Update appropriate screens or slider when mouse is moved
    function button_motion_function(obj, ~)
        % Update movie screen marker location
        if handles.grabbed_1 > -1
            set(obj, 'CurrentAxes', handles.movie_scrn_1, 'NextPlot', 'add')
        elseif handles.grabbed_2 > -1
            set(obj, 'CurrentAxes', handles.movie_scrn_2, 'NextPlot', 'add')
        end
        ps = get(gca, 'CurrentPoint');
        i_temp = round(ps(1, 1));
        
        j_temp = round(ps(2, 2));
        
        if handles.grabbed_3 > -1
            i_temp = ps(1, 1);
            
            if handles.grabbed_3 <= 4
                set(handles.bar_start_1, 'XData', [i_temp, i_temp], 'YData', [0, 1])
                set(handles.bar_start_2, 'XData', [i_temp, i_temp], 'YData', [0, 1])
                set(handles.bar_start_3, 'XData', [i_temp, i_temp], 'YData', [0, 1])
                set(handles.bar_start_channels, 'XData', [i_temp, i_temp], 'YData', [0, 1])
                set(starttimeamap_edit, 'String', round(i_temp, 3))
                set(starttimeamap_edit2, 'String', round(i_temp, 3))
                newEnd_callback(starttimeamap_edit)
            else
                set(handles.bar_end_1, 'XData', [i_temp, i_temp], 'YData', [0, 1])
                set(handles.bar_end_2, 'XData', [i_temp, i_temp], 'YData', [0, 1])
                set(handles.bar_end_3, 'XData', [i_temp, i_temp], 'YData', [0, 1])
                set(handles.bar_end_channels, 'XData', [i_temp, i_temp], 'YData', [0, 1])
                set(endtimeamap_edit, 'String', round(i_temp, 3))
                set(endtimeamap_edit2, 'String', round(i_temp, 3))
                newEnd_callback(endtimeamap_edit)
            end
            
        end
        if i_temp <= size(handles.cmosData_1, 1) && j_temp <= size(handles.cmosData_1, 2) && i_temp > 1 && j_temp > 1
            casegrab = 0;
            if handles.grabbed_1 > -1
                handles.M1(handles.grabbed_1, :) = [i_temp, j_temp];
                if handles.symmetry
                    handles.M2(handles.grabbed_1, :) = [100 - i_temp, j_temp];
                else
                    handles.M2 = handles.M1;
                end
                casegrab = handles.grabbed_1;
            end
            if handles.grabbed_2 > -1
                handles.M2(handles.grabbed_2, :) = [i_temp, j_temp];
                handles.M2 = handles.M1;
                casegrab = handles.grabbed_2;
            end
            i = i_temp;
            j = j_temp;
            switch casegrab
                case 1
                    handles.M1(1, :) = [i, j];
                    handles.M2(1, :) = [i, j];
                    set(handles.line_signal_scrn_1_2_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, i, :))+1);
                    set(handles.line_signal_scrn_1_3_2, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, i, :))+1);
                    if handles.graphdisplayed == 0
                        handles.graphdisplayed = 1;
                    end
                    
                    set(handles.line_signal_scrn_1_1_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(j, i, :)));
                    set(handles.line_signal_scrn_1_3_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(j, i, :)));
                    
                case 2
                    handles.M1(2, :) = [i, j];
                    handles.M2(2, :) = [i, j];
                    set(handles.line_signal_scrn_2_2_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, i, :))+1);
                    set(handles.line_signal_scrn_2_3_2, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, i, :))+1);
                    if handles.graphdisplayed == 1
                        handles.graphdisplayed = 2;
                    end
                    
                    set(handles.line_signal_scrn_2_1_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(j, i, :)));
                    set(handles.line_signal_scrn_2_3_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(j, i, :)));
                    
                case 3
                    handles.M1(3, :) = [i, j];
                    if handles.symmetry
                        handles.M2(3, :) = [100 - i, j];
                        set(handles.line_signal_scrn_3_2_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, 100 - i, :))+1);
                        set(handles.line_signal_scrn_3_3_2, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, 100 - i, :))+1);
                    else
                        handles.M2(3, :) = [i, j];
                        set(handles.line_signal_scrn_3_2_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, i, :))+1);
                        set(handles.line_signal_scrn_3_3_2, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, i, :))+1);
                    end
                    if handles.graphdisplayed == 2
                        handles.graphdisplayed = 3;
                    end
                    
                    set(handles.line_signal_scrn_3_1_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(j, i, :)));
                    
                    set(handles.line_signal_scrn_3_3_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(j, i, :)));
                    
            end
            set(handles.scatM1, 'XData', handles.M1(:, 1), 'YData', handles.M1(:, 2))
            set(handles.scatM2, 'XData', handles.M2(:, 1), 'YData', handles.M2(:, 2))
        end
    end

%% MOVIE SCREEN
%% Movie Slider Functionality
    function movieslider_callback(source, ~)
        val = get(source, 'Value');
        i = round(val * size(handles.cmosData_1, 3)) + 1;
        handles.frame_1 = i;
        handles.frame_2 = i;
        if handles.frame_1 == size(handles.cmosData_1, 3) +1
            i = size(handles.cmosData_1, 3);
            handles.frame_1 = size(handles.cmosData_1, 3);
            handles.frame_2 = size(handles.cmosData_1, 3);
        end
        % Update movie screen
        set(handles.movie_scrn_1, 'NextPlot', 'add', 'YTick', [], 'XTick', []);
        set(f, 'CurrentAxes', handles.movie_scrn_1);
        drawFrame1(i);
        
        
        % Update movie screen2
        set(handles.movie_scrn_2, 'NextPlot', 'add', 'YTick', [], 'XTick', []);
        set(f, 'CurrentAxes', handles.movie_scrn_2);
        drawFrame2(i);
        
        % Update markers on movie screen1&2
        if isfield(handles, 'scatM1')
            set(handles.scatM1, 'XData', handles.M1(:, 1), 'YData', handles.M1(:, 2));
            set(handles.scatM2, 'XData', handles.M2(:, 1), 'YData', handles.M2(:, 2));
        end
        
        % Update sweep bar
        a = [handles.time(i), handles.time(i)]; b = [0, 1];
        set(handles.sweep_bar_1, 'XData', a, 'YData', b, 'visible', 'on');
        set(handles.sweep_bar_2, 'XData', a, 'YData', b, 'visible', 'on');
        set(handles.sweep_bar_3, 'XData', a, 'YData', b, 'visible', 'on');
        set(handles.sweep_bar_start_channels, 'XData', a, 'YData', b, 'visible', 'on');
        clc;
        hold off; axis off
    end

%% Draw
    function drawFrame1(frame)
        G = handles.bgRGB_1;
        Mframe = handles.cmosData_1(:, :, frame);
        if handles.normflag == 0
            Mmax = handles.matrixMax;
            Mmin = handles.minVisible;
            numcol = size(jet, 1);
            J = ind2rgb(round((Mframe - Mmin) ./ (Mmax - Mmin) * (numcol - 1)), 'jet');
            A = real2rgb(Mframe >= handles.minVisible, 'gray');
        else
            J = real2rgb(Mframe, 'jet');
            A = real2rgb(Mframe >= handles.normalizeMinVisible, 'gray');
        end
        I = J .* A + G .* (1 - A);
        set(handles.movie_img1, 'CData', I)
    end

    function drawFrame2(frame)
        G2 = handles.bgRGB_2;
        Mframe2 = handles.cmosData_2(:, :, frame);
        if handles.normflag == 0
            Mmax2 = handles.matrixMax2;
            Mmin2 = handles.minVisible;
            numcol2 = size(jet, 1);
            J2 = ind2rgb(round((Mframe2 - Mmin2) ./ (Mmax2 - Mmin2) * (numcol2 - 1)), 'jet');
            
            A2 = real2rgb(Mframe2 <= handles.minVisible, 'gray');
        else
            
            J2 = flipud(real2rgb(Mframe2, 'jet'));
            A2 = real2rgb(Mframe2 <= handles.normalizeMinVisible, 'gray');
            
            
        end
        I2 = J2 .* A2 + G2 .* (1 - A2);
        
        
        set(handles.movie_img2, 'CData', I2)
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DISPLAY CONTROL
%% Play button functionality
    function play_stop_button_callback(~, ~)
        handles.playback = handles.playback - 1;
        if handles.playback == -1 % if the PLAY button hasn't been clicked
            handles.playback = 1;
            handles.isplay = true;
            set(play_stop_button, 'String', 'Pause')
        elseif handles.playback == 1
            handles.isplay = true;
            set(play_stop_button, 'String', 'Pause')
        elseif handles.playback == 0
            handles.isplay = false;
            set(play_stop_button, 'String', 'Play')
        else
        end
       
        if handles.isplay
            start = str2double(get(starttimemap_edit, 'String'));
            endt = str2double(get(endtimemap_edit, 'String'));
            if handles.starttime~=start
                if handles.frame1>round(start*handles.Fs,0)&&handles.frame1<round(endt*handles.Fs,0)
                    startframe=handles.frame1;
                else
                handles.frame1=round(start*handles.Fs,0);
                startframe = handles.frame1;
                end
            else
                startframe = handles.frame_1;
            end
            if handles.endtime~=endt
                endframe=round(endt*handles.Fs,0);
            else
                endframe =size(handles.cmosData_1, 3);
            end
            
            % Update movie screen with new frames
            
            x=round(((endframe-startframe)/handles.Fs)*2,0);
            if x==0
                x=1;
            end
            i=0;
            for i = startframe:x:endframe
                if handles.isplay
                    set(f, 'CurrentAxes', handles.movie_scrn_1)
                    drawFrame1(i);
                    drawFrame2(i);
                    handles.frame_1 = i;
                    handles.frame_2 = i;
                    
                    if isfield(handles, 'scatM1')
                        set(handles.scatM1, 'XData', handles.M1(:, 1), 'YData', handles.M1(:, 2))
                        set(handles.scatM2, 'XData', handles.M2(:, 1), 'YData', handles.M2(:, 2))
                    end
                    pause(0.01)
                    % Update movie slider
                    set(movie_slider, 'Value', (i - 1) / size(handles.cmosData_1, 3))
                    
                    % Update sweep bar
                    a = [handles.time(i), handles.time(i)]; b = [0, 1];
                    set(handles.sweep_bar_1, 'XData', a, 'YData', b, 'visible', 'on')
                    set(handles.sweep_bar_2, 'XData', a, 'YData', b, 'visible', 'on')
                    set(handles.sweep_bar_3, 'XData', a, 'YData', b, 'visible', 'on')
                    set(handles.sweep_bar_start_channels, 'XData', a, 'YData', b, 'visible', 'on')
                    pause(0.01); pause(0.01)
                   
                else
                    break
                end
                
            end
           
            if handles.isplay
                set(play_stop_button, 'String', 'Play')
                handles.isplay=false;
               
                drawFrame1(startframe);
                drawFrame2(startframe);
                handles.frame_1 = startframe;
                handles.frame_2 = startframe;
                set(movie_slider, 'Value', (startframe-1) / size(handles.cmosData_1, 3))
                set(handles.sweep_bar_1, 'XData', a, 'YData', b, 'visible', 'off')
                set(handles.sweep_bar_2, 'XData', a, 'YData', b, 'visible', 'off')
                set(handles.sweep_bar_3, 'XData', a, 'YData', b, 'visible', 'off')
                set(handles.sweep_bar_start_channels, 'XData', a, 'YData', b, 'visible', 'off')
                handles.playback = 0;
            end
            if i==round(endt*handles.Fs,0)
                handles.frame1=round(start*handles.Fs,0);
                
                
            end
        else
            currentframe = handles.frame_1;
            drawFrame1(currentframe);
            
            currentframe2 = handles.frame_2;
            drawFrame2(currentframe2);
            
            if isfield(handles, 'scatM1')
                set(handles.scatM1, 'XData', handles.M1(:, 1), 'YData', handles.M1(:, 2))
                set(handles.scatM2, 'XData', handles.M2(:, 1), 'YData', handles.M2(:, 2))
            end
        end
        
    end

%% Display Wave Button Functionality
    function dispwave_button_callback(~, ~)
        [i_temp, j_temp] = myginput(1, 'circle');
        i = round(i_temp);
        j = round(j_temp);
        
        %make sure pixel selected is within handles.movie_scrn_1
        if i_temp > size(handles.cmosData_1, 1) || j_temp > size(handles.cmosData_1, 2) || i_temp <= 1 || j_temp <= 1
            msgbox('Warning: Pixel Selection out of Boundary', 'Title', 'help')
        else
            % Find the correct wave window
            if handles.displayedwavecount_1 < 3
                handles.displayedwavecount_1 = handles.displayedwavecount_1 + 1;
            end
            
            if handles.wave_window == 4
                handles.wave_window = 1;
            end
            wave_window = handles.wave_window;
            
            
            switch wave_window
                case 1
                    set(handles.line_signal_scrn_1_1_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(j, i, :)));
                    set(handles.line_signal_scrn_1_2_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, i, :)));
                    set(handles.line_signal_scrn_1_3_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(j, i, :)));
                    set(handles.line_signal_scrn_1_3_2, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, i, :)));
                    
                    handles.M1(1, :) = [i, j];
                    if handles.symmetry
                        handles.M2(1, :) = [100 - i, j];
                        set(handles.line_signal_scrn_2_1_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, 100 - i, :)));
                        set(handles.line_signal_scrn_1_3_2, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, 100 - i, :)));
                    else
                        handles.M2(1, :) = handles.M1(1, :);
                    end
                case 2
                    set(handles.line_signal_scrn_2_1_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(j, i, :)));
                    set(handles.line_signal_scrn_2_2_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, i, :)));
                    set(handles.line_signal_scrn_2_3_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(j, i, :)));
                    set(handles.line_signal_scrn_2_3_2, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, i, :)));
                    
                    handles.M1(2, :) = [i, j];
                    handles.M2(2, :) = handles.M1(2, :);
                case 3
                    set(handles.line_signal_scrn_3_1_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(j, i, :)));
                    set(handles.line_signal_scrn_3_2_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, i, :)));
                    set(handles.line_signal_scrn_3_3_1, 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(j, i, :)));
                    set(handles.line_signal_scrn_3_3_2, 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(j, i, :)));
                    
                    handles.M1(3, :) = [i, j];
                    handles.M2(3, :) = handles.M1(3, :);
            end
            
        end
        % temp addition
        
        handles.wave_window = wave_window + 1; % Dial up the wave window count
        if handles.normflag==0
            set(f, 'CurrentAxes', handles.movie_scrn_1);
            currentframe1 = handles.frame_1;
            drawFrame1(currentframe1);
            set(f, 'CurrentAxes', handles.movie_scrn_2);
            currentframe2 = handles.frame_2;
            drawFrame2(currentframe2);
        else
            if handles.frame_1==1
                set(f, 'CurrentAxes', handles.movie_scrn_1);
                currentframe1 = handles.frame_1;
                drawFrame1(currentframe1);
                set(f, 'CurrentAxes', handles.movie_scrn_2);
                currentframe2 = handles.frame_2+1;
                drawFrame2(currentframe2);
            end
        end
        
        set(handles.scatM1, 'XData', handles.M1(:, 1), 'YData', handles.M1(:, 2))
        set(handles.scatM2, 'XData', handles.M2(:, 1), 'YData', handles.M2(:, 2))
    end

%% Export movie to .avi file
%Construct a VideoWriter object and view its properties. Set the frame rate to 60 frames per second:
    function expmov_button_callback(~, ~)
        h = findobj(f, 'Enable', 'on');
        set(h, 'Enable', 'off')
        enableDisableFig(f, 'off');
        scrn_size = get(0, 'ScreenSize');
        xmiddle_1 = scrn_size(3) / 2;
        ymiddle_1 = scrn_size(4) / 2;
        sizex_1 = 230;
        sizey_1 = 360;
        form_video = figure('NumberTitle', 'off', 'toolbar', 'none', 'Menubar', 'none', 'Unit', 'Pixel', 'Position', [xmiddle_1 - (sizex_1 / 2), ymiddle_1 - (sizey_1 / 2), sizex_1, sizey_1], 'CloseRequestFcn', @my_closereq);
        movegui(form_video, 'center')
        form_video_panel = uipanel('Position', [0, 0, 1, 1], 'Parent', form_video);
        uicontrol('Parent', form_video_panel, 'Style', 'text', 'HorizontalAlignment', 'left', 'Fontsize', 9, 'Unit', 'Pixel', 'String', 'Which movie screen do you want ?', 'Position', [10, 330, 290, 20]);
        scrn_choice = uicontrol('Parent', form_video_panel, 'Style', 'popupmenu', 'HorizontalAlignment', 'left', 'Fontsize', 9, 'Unit', 'Pixel', 'String', {'Screen 1'}, 'Position', [10, 300, 120, 30], 'Callback', @Call_Screen);
        uicontrol('Parent', form_video_panel, 'Style', 'text', 'HorizontalAlignment', 'left', 'Fontsize', 9, 'Unit', 'Pixel', 'String', 'Start Time & End Time :', 'Position', [10, 270, 290, 20]);
        start_1_box = uicontrol('Parent', form_video_panel, 'Style', 'edit', 'HorizontalAlignment', 'left', 'Fontsize', 9, 'Unit', 'Pixel', 'Position', [10, 240, 50, 30], 'String', get(starttimeamap_edit, 'String'));
        end_1_box = uicontrol('Parent', form_video_panel, 'Style', 'edit', 'HorizontalAlignment', 'left', 'Fontsize', 9, 'Unit', 'Pixel', 'Position', [75, 240, 50, 30], 'String', get(endtimeamap_edit, 'String'));
        uicontrol('Parent', form_video_panel, 'Style', 'text', 'HorizontalAlignment', 'left', 'Fontsize', 9, 'Unit', 'Pixel', 'String', 'Frame Rate (image per second) :', 'Position', [10, 210, 290, 20]);
        frame_rate = uicontrol('Parent', form_video_panel, 'Style', 'edit', 'HorizontalAlignment', 'left', 'Fontsize', 9, 'Unit', 'Pixel', 'String', '15', 'Position', [10, 180, 50, 30]);
        uicontrol('Parent', form_video_panel, 'Style', 'text', 'HorizontalAlignment', 'left', 'Fontsize', 9, 'Unit', 'Pixel', 'String', 'Sampling Ratio :', 'Position', [10, 150, 290, 20]);
        uicontrol('Parent', form_video_panel, 'Style', 'edit', 'HorizontalAlignment', 'left', 'Fontsize', 9, 'Unit', 'Pixel', 'String', '1', 'Position', [10, 120, 50, 30]);
        uicontrol('Parent', form_video_panel, 'Style', 'text', 'HorizontalAlignment', 'left', 'Fontsize', 9, 'Unit', 'Pixel', 'String', 'movie name :', 'Position', [10, 90, 290, 20]);
        name_movie_box = uicontrol('Parent', form_video_panel, 'Style', 'edit', 'HorizontalAlignment', 'left', 'Fontsize', 9, 'Unit', 'Pixel', 'String', 'movie_test', 'Position', [10, 60, 120, 30]);
        uicontrol('Parent', form_video_panel, 'Style', 'pushbutton', 'HorizontalAlignment', 'left', 'Fontsize', 9, 'Unit', 'Pixel', 'String', 'OK', 'Position', [(sizex_1 / 2) - (75 / 2), 15, 75, 30], 'Callback', @Validation);
        h2 = findobj(form_video, 'Units', 'Pixel');
        set(h2, 'Units', 'Normalized')
        function Call_Screen(hObj, ~)
            if get(hObj, 'Value') == 1
                set(start_1_box, 'String', get(starttimeamap_edit_1, 'String'));
                set(end_1_box, 'String', get(endtimeamap_edit_1, 'String'));
            else
                set(start_1_box, 'String', get(starttimeamap_edit_2, 'String'));
                set(end_1_box, 'String', get(endtimeamap_edit_2, 'String'));
            end
        end
        function Validation(~, ~)
            scrn_chose = get(scrn_choice, 'Value');
            start_1 = str2double(get(start_1_box, 'String'));
            endp_1 = str2double(get(end_1_box, 'String'));
            Fr_Ra = str2double(get(frame_rate, 'String'));
            name_movie = get(name_movie_box, 'String');
            enableDisableFig(f, 'on');
            set(h, 'Enable', 'on')
            delete(form_video)
        end
        function my_closereq(~, ~)
            scrn_chose = 0;
            enableDisableFig(f, 'on');
            set(h, 'Enable', 'on')
            delete(form_video)
        end
        waitfor(form_video)
        sizex_1 = 500;
        sizey_1 = 500;
        dsja = figure('Unit', 'Pixel', 'Position', [xmiddle_1 - (sizex_1 / 2), ymiddle_1 - (sizey_1 / 2), sizex_1, sizey_1]);
        movegui(dsja, 'center')
        a1 = axes('Parent', dsja, 'Unit', 'Pixel', 'Position', [50, 50, 400, 400], 'NextPlot', 'add');
        if scrn_chose == 1
            image(handles.bgRGB_2, 'Parent', a1);
        else
            close(dsja)
            return
        end
        
        axis image
        axis off
        title('Activation Map')
        
        if scrn_chose == 1
            actMap1 = aMap2(handles.cmosData_1, start_1, endp_1, handles.Fs);
        end
        
        hold on;
        m_actMap1max_1 = max(actMap1(:));
        for a = 1:m_actMap1max_1
            M_actMap1{a} = double(actMap1 == a) * a + double(actMap1 == a + 1) * (a + 1) + double(actMap1 == a - 1) * (a - 1);
            M_actMap1{a}(M_actMap1{a} == 0) = NaN;
        end
        
        
        for i = 1:1:m_actMap1max_1
            dlps_1 = surf(M_actMap1{i}, 'EdgeColor', 'none', 'Parent', a1);
            shading interp
            alpha(dlps_1, .9)
            if i > 1
                dlps_1_p1 = surf(M_actMap1{i - 1}, 'EdgeColor', 'none', 'Parent', a1);
                shading interp
                alpha(dlps_1_p1, .7)
                if i > 2
                    dlps_1_p2 = surf(M_actMap1{i - 2}, 'EdgeColor', 'none', 'Parent', a1);
                    shading interp
                    alpha(dlps_1_p2, .6)
                    if i > 3
                        dlps_1_p3 = surf(M_actMap1{i - 3}, 'EdgeColor', 'none', 'Parent', a1);
                        shading interp
                        alpha(dlps_1_p3, .5)
                    end
                end
            end
            colormap(flip(hot(3)))
            pause(0.01)
            child_handles = allchild(dsja);
            for ksx = 1:length(child_handles)
                if child_handles(ksx) ~= a1
                    delete(child_handles(ksx))
                end
            end
            F(i) = getframe(dsja);
            if i < m_actMap1max_1
                delete(dlps_1)
                if i > 1
                    delete(dlps_1_p1)
                    if i > 2
                        delete(dlps_1_p2)
                        if i > 3
                            delete(dlps_1_p3)
                        end
                    end
                end
            end
        end
        video = VideoWriter([name_movie, '.avi'], 'Uncompressed AVI');
        video.FrameRate = Fr_Ra;
        open(video)
        writeVideo(video, F);
        close(video)
        popup_video = msgbox(['The video: ', name_movie, '.avi has been succesfully created']);
        waitfor(popup_video)
        close(dsja)
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SIGNAL SCREENS

%% Start Time Editable Textbox for Signal Screens && End Time Editable Textbox for Signal Screens
    function time_edit_callback(source, ~)
        %get the val01 (lower limit) and val02 (upper limit) plot values
        if source == endtimemap_edit
            val01 = str2double(get(starttimemap_edit, 'String'));
            val02 = str2double(get(source, 'String'));
            
        else
            val01 = str2double(get(source, 'String'));
            val02 = str2double(get(endtimemap_edit, 'String'));
        end
        
        
        if val01 >= handles.starttime && val01 <= handles.endtime && val02 >= handles.starttime && val02 <= handles.endtime
            
            set(handles.axe_signal_scrn_1_1, 'XLim', [val01, val02]);
            set(handles.axe_signal_scrn_2_1, 'XLim', [val01, val02]);
            set(handles.axe_signal_scrn_3_1, 'XLim', [val01, val02]);
            
            set(handles.time_bar_1, 'XLim', [val01, val02]);
            set(handles.time_bar_2, 'XLim', [val01, val02]);
            set(handles.time_bar_3, 'XLim', [val01, val02]);
            set(handles.time_bar_channels, 'XLim', [val01, val02]);
            
            
            set(handles.axe_signal_scrn_1_ana, 'XLim', [val01, val02]);
            set(handles.axe_signal_scrn_1_2, 'XLim', [val01, val02]);
            set(handles.axe_signal_scrn_1_3, 'XLim', [val01, val02]);
            
            set(handles.axe_signal_scrn_2_ana, 'XLim', [val01, val02]);
            set(handles.axe_signal_scrn_2_2, 'XLim', [val01, val02]);
            set(handles.axe_signal_scrn_2_3, 'XLim', [val01, val02]);
            
            set(handles.axe_signal_scrn_3_ana, 'XLim', [val01, val02]);
            set(handles.axe_signal_scrn_3_2, 'XLim', [val01, val02]);
            set(handles.axe_signal_scrn_3_3, 'XLim', [val01, val02]);
            
            
            set(handles.axe_channel_scrn_1, 'XLim', [val01, val02]);
            set(handles.axe_channel_scrn_2, 'XLim', [val01, val02]);
            set(handles.axe_channel_scrn_3, 'XLim', [val01, val02]);
            set(handles.axe_channel_scrn_4, 'XLim', [val01, val02]);
            
            set(handles.sweep_axes_1, 'XLim', [val01, val02]);
            set(handles.sweep_axes_2, 'XLim', [val01, val02]);
            set(handles.sweep_axes_3, 'XLim', [val01, val02]);
            set(handles.sweep_axes_channels_screens, 'XLim', [val01, val02]);
            
            handles.vw_start = val01;
            handles.vw_end = val02;
            
        else
            if val01 < handles.starttime || val01 > handles.endtime
                error = 'The START TIME must be greater than %d and less than %.3f.';
                msgbox(sprintf(error, handles.starttime, handles.endtime), 'Incorrect Input', 'Warn');
                set(source, 'String', handles.starttime)
                
                set(handles.axe_signal_scrn_1_1, 'XLim', [handles.starttime, val02]);
                set(handles.axe_signal_scrn_2_1, 'XLim', [handles.starttime, val02]);
                set(handles.axe_signal_scrn_3_1, 'XLim', [handles.starttime, val02]);
                
                set(handles.time_bar_1, 'XLim', [handles.starttime, val02]);
                set(handles.time_bar_2, 'XLim', [handles.starttime, val02]);
                set(handles.time_bar_3, 'XLim', [handles.starttime, val02]);
                set(handles.time_bar_channels, 'XLim', [handles.starttime, val02]);
                
                
                set(handles.axe_signal_scrn_1_ana, 'XLim', [handles.starttime, val02]);
                set(handles.axe_signal_scrn_1_2, 'XLim', [handles.starttime, val02]);
                set(handles.axe_signal_scrn_1_3, 'XLim', [handles.starttime, val02]);
                
                set(handles.axe_signal_scrn_2_ana, 'XLim', [handles.starttime, val02]);
                set(handles.axe_signal_scrn_2_2, 'XLim', [handles.starttime, val02]);
                set(handles.axe_signal_scrn_2_3, 'XLim', [handles.starttime, val02]);
                
                set(handles.axe_signal_scrn_3_ana, 'XLim', [handles.starttime, val02]);
                set(handles.axe_signal_scrn_3_2, 'XLim', [handles.starttime, val02]);
                set(handles.axe_signal_scrn_3_3, 'XLim', [handles.starttime, val02]);
                
                
                set(handles.axe_channel_scrn_1, 'XLim', [handles.starttime, val02]);
                set(handles.axe_channel_scrn_2, 'XLim', [handles.starttime, val02]);
                set(handles.axe_channel_scrn_3, 'XLim', [handles.starttime, val02]);
                set(handles.axe_channel_scrn_4, 'XLim', [handles.starttime, val02]);
                
                set(handles.sweep_axes_1, 'XLim', [handles.starttime, val02]);
                set(handles.sweep_axes_2, 'XLim', [handles.starttime, val02]);
                set(handles.sweep_axes_3, 'XLim', [handles.starttime, val02]);
                set(handles.sweep_axes_channels_screens, 'XLim', [handles.starttime, val02]);
                
                handles.vw_start = handles.starttime;
                handles.vw_end = val02;
            else
                error = 'The END TIME must be greater than %d and less than %.3f.';
                msgbox(sprintf(error, handles.starttime, handles.endtime), 'Incorrect Input', 'Warn');
                set(source, 'String', handles.endtime)
                
                set(handles.axe_signal_scrn_1_1, 'XLim', [val01, handles.endtime]);
                set(handles.axe_signal_scrn_2_1, 'XLim', [val01, handles.endtime]);
                set(handles.axe_signal_scrn_3_1, 'XLim', [val01, handles.endtime]);
                
                set(handles.time_bar_1, 'XLim', [val01, handles.endtime]);
                set(handles.time_bar_2, 'XLim', [val01, handles.endtime]);
                set(handles.time_bar_3, 'XLim', [val01, handles.endtime]);
                set(handles.time_bar_channels, 'XLim', [val01, handles.endtime]);
                
                
                set(handles.axe_signal_scrn_1_ana, 'XLim', [val01, handles.endtime]);
                set(handles.axe_signal_scrn_1_2, 'XLim', [val01, handles.endtime]);
                set(handles.axe_signal_scrn_1_3, 'XLim', [val01, handles.endtime]);
                
                set(handles.axe_signal_scrn_2_ana, 'XLim', [val01, handles.endtime]);
                set(handles.axe_signal_scrn_2_2, 'XLim', [val01, handles.endtime]);
                set(handles.axe_signal_scrn_2_3, 'XLim', [val01, handles.endtime]);
                
                set(handles.axe_signal_scrn_3_ana, 'XLim', [val01, handles.endtime]);
                set(handles.axe_signal_scrn_3_2, 'XLim', [val01, handles.endtime]);
                set(handles.axe_signal_scrn_3_3, 'XLim', [val01, handles.endtime]);
                
                
                set(handles.axe_channel_scrn_1, 'XLim', [val01, handles.endtime]);
                set(handles.axe_channel_scrn_2, 'XLim', [val01, handles.endtime]);
                set(handles.axe_channel_scrn_3, 'XLim', [val01, handles.endtime]);
                set(handles.axe_channel_scrn_4, 'XLim', [val01, handles.endtime]);
                
                set(handles.sweep_axes_1, 'XLim', [val01, handles.endtime]);
                set(handles.sweep_axes_2, 'XLim', [val01, handles.endtime]);
                set(handles.sweep_axes_3, 'XLim', [val01, handles.endtime]);
                set(handles.sweep_axes_channels_screens, 'XLim', [val01, handles.endtime]);
                
                handles.vw_start = val01;
                handles.vw_end = handles.endtime;
            end
        end
    end


%% Export signal waves to new screen
    function expwave_button_callback(~, ~)
        % Check if there is wave to export :
        if handles.displayedwavecount_1 == 0 && handles.rightpanelcount == 0
            msgbox('There is nothing to export')
            return
        end
        
        xlimit = get(handles.axe_signal_scrn_1_1, 'XLim');
        switch handles.displayedwavecount_1
            case 0
                lineDisplayed = {};
            case 1
                lineDisplayed = {handles.line_signal_scrn_1_1_1, handles.line_signal_scrn_1_2_1, ...
                    handles.line_signal_scrn_1_3_1, handles.line_signal_scrn_1_3_2};
                maximum = 2;
            case 2
                lineDisplayed = {handles.line_signal_scrn_1_1_1, handles.line_signal_scrn_2_1_1, ...
                    handles.line_signal_scrn_1_2_1, handles.line_signal_scrn_2_2_1, ...
                    handles.line_signal_scrn_1_3_1, handles.line_signal_scrn_1_3_2, ...
                    handles.line_signal_scrn_2_3_1, handles.line_signal_scrn_2_3_2};
                maximum = 4;
                %                 ygeneral = 3;
            case 3
                lineDisplayed = {handles.line_signal_scrn_1_1_1, handles.line_signal_scrn_2_1_1, handles.line_signal_scrn_3_1_1, ...
                    handles.line_signal_scrn_1_2_1, handles.line_signal_scrn_2_2_1, handles.line_signal_scrn_3_2_1, ...
                    handles.line_signal_scrn_1_3_1, handles.line_signal_scrn_1_3_2, ...
                    handles.line_signal_scrn_2_3_1, handles.line_signal_scrn_2_3_2, ...
                    handles.line_signal_scrn_3_3_1, handles.line_signal_scrn_3_3_2};
                maximum = 6;
                %                 ygeneral = 3;
        end
        
        if handles.analogcount && handles.displayedwavecount_1 ~= 0
            maximum = (maximum / 2) * 3;
            switch maximum
                case 3
                    oldlineDisplayed = lineDisplayed;
                    lineDisplayed(1, 1) = {handles.line_signal_scrn_1_ana_1};
                    if handles.displayedwavecount_1 ~= 0
                        for km = 1:4
                            lineDisplayed(1, km + 1) = oldlineDisplayed(1, km);
                        end
                    end
                case 6
                    oldlineDisplayed = lineDisplayed;
                    lineDisplayed(1, 1) = {handles.line_signal_scrn_1_ana_1};
                    lineDisplayed(1, 2) = {handles.line_signal_scrn_2_ana_1};
                    if handles.displayedwavecount_1 ~= 0
                        for km = 1:8
                            lineDisplayed(1, km + 2) = oldlineDisplayed(1, km);
                        end
                    end
                case 9
                    oldlineDisplayed = lineDisplayed;
                    lineDisplayed(1, 1) = {handles.line_signal_scrn_1_ana_1};
                    lineDisplayed(1, 2) = {handles.line_signal_scrn_2_ana_1};
                    lineDisplayed(1, 3) = {handles.line_signal_scrn_3_ana_1};
                    if handles.displayedwavecount_1 ~= 0
                        for km = 1:12
                            lineDisplayed(1, km + 3) = oldlineDisplayed(1, km);
                        end
                    end
            end
        end
        
        if handles.rightpanelcount ~= 0
            chanelline = {handles.line_channel_scrn_1, handles.line_channel_scrn_2, handles.line_channel_scrn_3, handles.line_channel_scrn_4};
            kb = 1;
            for kn = 1:4
                if get(chanelline{kn}, 'XData') ~= 0
                    rightpanelline(1, kb) = chanelline{kn};
                    kb = kb + 1;
                end
            end
        end
        
        w = figure;
        
        if handles.rightpanelcount == 0
            if handles.analogcount == 0
                wave_y = 3;
                wave_x = handles.displayedwavecount_1;
                n = 1;
                for ii = 1:wave_y * wave_x
                    sbpt = subplot(wave_y, wave_x, ii);
                    set(sbpt, 'XLim', xlimit)
                    if ii > maximum
                        set(lineDisplayed{n}, 'Parent', sbpt)
                        n = n + 1;
                        set(lineDisplayed{n}, 'Parent', sbpt)
                    else
                        set(lineDisplayed{n}, 'Parent', sbpt)
                        set(sbpt, 'XTickLabel', {' '});
                    end
                    n = n + 1;
                end
            else
                wave_y = 4;
                wave_x = handles.displayedwavecount_1;
                n = 1;
                for ii = 1:wave_y * wave_x
                    sbpt = subplot(wave_y, wave_x, ii);
                    set(sbpt, 'XLim', xlimit)
                    if ii > maximum
                        set(lineDisplayed{n}, 'Parent', sbpt)
                        n = n + 1;
                        set(lineDisplayed{n}, 'Parent', sbpt)
                    else
                        set(lineDisplayed{n}, 'Parent', sbpt)
                        set(sbpt, 'XTickLabel', {' '});
                    end
                    n = n + 1;
                end
            end
        else
            wave_x_displaywave = 12 / (handles.displayedwavecount_1 + 1);
            
            if handles.analogcount == 0
                wave_y_displaywave = 4;
                turn_y = 2;
            else
                wave_y_displaywave = 3;
                turn_y = 3;
            end
            
            wave_y_right = 12 / handles.rightpanelcount;
            switch wave_y_right
                case 12
                    turn_y_right = 0;
                case 6
                    turn_y_right = 1;
                case 4
                    turn_y_right = 2;
                case 3
                    turn_y_right = 3;
            end
            
            base_display = [1, ((wave_y_displaywave - 1) * 12) + wave_x_displaywave];
            
            n = 1;
            for kb = 0:turn_y
                for ks = 0:handles.displayedwavecount_1 -1
                    sbpt = subplot(12, 12, base_display + kb * wave_y_displaywave * 12 + ks * wave_x_displaywave);
                    set(sbpt, 'Units', 'normalized')
                    position_current = get(sbpt, 'Position');
                    if handles.displayedwavecount_1 == 3
                        position_current = position_current - position_current .* [0, 0, .2, .2];
                        set(sbpt, 'XLim', xlimit, 'Position', position_current);
                    else
                    end
                    if kb > turn_y -1
                        set(lineDisplayed{n}, 'Parent', sbpt)
                        n = n + 1;
                        set(lineDisplayed{n}, 'Parent', sbpt)
                    else
                        set(lineDisplayed{n}, 'Parent', sbpt)
                        set(sbpt, 'XLim', xlimit, 'Position', position_current, 'XTickLabel', {' '});
                    end
                    n = n + 1;
                end
            end
            
            base_display = [12 - wave_x_displaywave + 1, ((wave_y_right - 1) * 12) + 12];
            
            for kbn = 0:turn_y_right
                sbpt = subplot(12, 12, base_display + kbn * wave_y_right * 12);
                set(sbpt, 'Units', 'normalized')
                position_current = get(sbpt, 'Position');
                position_current = position_current - position_current .* [0, 0, .2, .2];
                set(sbpt, 'XLim', xlimit, 'Position', position_current);
                set(rightpanelline(1, kbn + 1), 'Parent', sbpt)
                set(sbpt, 'XLim', xlimit)
                if kbn ~= turn_y_right
                    set(sbpt, 'XLim', xlimit, 'Position', position_current, 'XTickLabel', {' '});
                end
            end
        end
        
        set(w, 'CloseRequestFcn', @close_request)
        
        function close_request(~, ~)
            try
                lineDisplayed = {handles.line_signal_scrn_1_ana_1, handles.line_signal_scrn_2_ana_1, handles.line_signal_scrn_3_ana_1, ...
                    handles.line_signal_scrn_1_1_1, handles.line_signal_scrn_2_1_1, handles.line_signal_scrn_3_1_1, ...
                    handles.line_signal_scrn_1_2_1, handles.line_signal_scrn_2_2_1, handles.line_signal_scrn_3_2_1, ...
                    handles.line_signal_scrn_1_3_1, handles.line_signal_scrn_1_3_2, ...
                    handles.line_signal_scrn_2_3_1, handles.line_signal_scrn_2_3_2, ...
                    handles.line_signal_scrn_3_3_1, handles.line_signal_scrn_3_3_2, ...
                    handles.line_channel_scrn_1, handles.line_channel_scrn_2, handles.line_channel_scrn_3, handles.line_channel_scrn_4};
                
                papa = {handles.axe_signal_scrn_1_ana, handles.axe_signal_scrn_2_ana, handles.axe_signal_scrn_3_ana, ...
                    handles.axe_signal_scrn_1_1, handles.axe_signal_scrn_2_1, handles.axe_signal_scrn_3_1, ...
                    handles.axe_signal_scrn_1_2, handles.axe_signal_scrn_2_2, handles.axe_signal_scrn_3_2, ...
                    handles.axe_signal_scrn_1_3, handles.axe_signal_scrn_1_3, handles.axe_signal_scrn_2_3, ...
                    handles.axe_signal_scrn_2_3, handles.axe_signal_scrn_3_3, handles.axe_signal_scrn_3_3, ...
                    handles.axe_channel_scrn_1, handles.axe_channel_scrn_2, handles.axe_channel_scrn_3, handles.axe_channel_scrn_4};
                
                
                for iii = 1:length(papa)
                    set(lineDisplayed{iii}, 'Parent', papa{iii})
                end
                
                delete(w);
            catch
                msgbox('please restart RHYTHM');
                delete(w);
                delete(f);
            end
        end
    end

%% Import signal in channels screens
    function scrn_popup_callback(hObject, ~)
        popup_value = get(hObject, 'Value');
        
        switch hObject
            case scrn1_popup
                currentline = handles.line_channel_scrn_1;
            case scrn2_popup
                currentline = handles.line_channel_scrn_2;
            case scrn3_popup
                currentline = handles.line_channel_scrn_3;
            case scrn4_popup
                currentline = handles.line_channel_scrn_4;
            case analog_popup
                currentline = [handles.line_signal_scrn_1_ana_1, handles.line_signal_scrn_2_ana_1, handles.line_signal_scrn_3_ana_1];
                
        end
        if handles.version == 1
            switch popup_value -1
                case 0 % none
                    set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                case 1
                    if isfield(Data_1, 'Analog1')
                        handles.analog1 = Data_1.Analog1(:, 2:end);
                        set(currentline, 'XData', handles.time, 'YData', squeeze(handles.analog1(:)), 'Visible', 'on');
                    else
                        msgbox('No wave to import. The channel analog 1 is empty', 'Icon', 'help');
                        set(hObject, 'Value', 1);
                        set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                    end
                case 2
                    if isfield(Data_1, 'Analog2')
                        handles.analog2 = Data_1.Analog2(:, 2:end);
                        set(currentline, 'XData', handles.time, 'YData', squeeze(handles.analog2(:)), 'Visible', 'on');
                    else
                        msgbox('No wave to import. The channel analog 2 is empty', 'Icon', 'help');
                        set(hObject, 'Value', 1);
                        set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                    end
                case 3
                    if isfield(Data_1, 'channel1')
                        if length(Data_1.channel1) == 8192
                            handles.channel1 = Data_1.channel1(:, 1:2048);
                            handles.time2 = (1:size(handles.channel1, 2)) / handles.Fs;
                            set(currentline, 'XData', handles.time2, 'YData', squeeze(handles.channel1(:)), 'Visible', 'on');
                        else
                            handles.channel1 = Data_1.channel1(:, 2:1024);
                            set(currentline, 'XData', handles.time, 'YData', squeeze(handles.channel1(:)), 'Visible', 'on');
                        end
                    else
                        msgbox('No wave to import. The channel 2 is empty', 'Icon', 'help');
                        set(hObject, 'Value', 1);
                        set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                    end
                    
                case 4
                    if isfield(Data_1, 'channel2')
                        if length(Data_1.channel2) == 8192
                            handles.channel2 = Data_1.channel2(:, 1:2048);
                            handles.time2 = (1:size(handles.channel2, 2)) / handles.Fs;
                            set(currentline, 'XData', handles.time2, 'YData', squeeze(handles.channel2(:)), 'Visible', 'on');
                        else
                            handles.channel2 = Data_1.channel2(:, 2:1024);
                            set(currentline, 'XData', handles.time, 'YData', squeeze(handles.channel2(:)), 'Visible', 'on');
                        end
                    else
                        msgbox('No wave to import. The channel 2 is empty', 'Icon', 'help');
                        set(hObject, 'Value', 1);
                        set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                    end
                case 5
                    if isfield(Data_1, 'channel3')
                        handles.channel3 = Data_1.channel3(:, 2:end);
                        set(currentline, 'XData', handles.time, 'YData', squeeze(handles.channel3(:)), 'Visible', 'on');
                    else
                        msgbox('No wave to import. The channel 3 is empty', 'Icon', 'help');
                        set(hObject, 'Value', 1);
                        set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                    end
                case 6
                    if isfield(Data_1, 'channel4')
                        handles.channel4 = Data_1.channel4(:, 2:end);
                        set(currentline, 'XData', handles.time, 'YData', squeeze(handles.channel4(:)), 'Visible', 'on');
                    else
                        msgbox('No wave to import. The channel 4 is empty', 'Icon', 'help');
                        set(hObject, 'Value', 1);
                        set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                    end
                case 7
                    if isfield(Data_1, 'channel5')
                        handles.channel5 = Data_1.channel5(:, 2:end);
                        set(currentline, 'XData', handles.time, 'YData', squeeze(handles.channel5(:)), 'Visible', 'on');
                    else
                        msgbox('No wave to import. The channel 5 is empty', 'Icon', 'help');
                        set(hObject, 'Value', 1);
                        set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                    end
                case 8
                    if isfield(Data_1, 'channel6')
                        handles.channel6 = Data_1.channel6(:, 2:end);
                        set(currentline, 'XData', handles.time, 'YData', squeeze(handles.channel6(:)), 'Visible', 'on');
                    else
                        msgbox('No wave to import. The channel 6 is empty', 'Icon', 'help');
                        set(hObject, 'Value', 1);
                        set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                    end
                case 9
                    if isfield(Data_1, 'channel7')
                        handles.channel7 = Data_1.channel7(:, 2:end);
                        set(currentline, 'XData', handles.time, 'YData', squeeze(handles.channel7(:)), 'Visible', 'on');
                    else
                        msgbox('No wave to import. The channel 7 is empty', 'Icon', 'help');
                        set(hObject, 'Value', 1);
                        set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                    end
                case 10
                    if isfield(Data_1, 'channel8')
                        handles.channel8 = Data_1.channel8(:, 2:end);
                        set(currentline, 'XData', handles.time, 'YData', squeeze(handles.channel8(:)), 'Visible', 'on');
                    else
                        msgbox('No wave to import. The channel 8 is empty', 'Icon', 'help');
                        set(hObject, 'Value', 1);
                        set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                    end
                case 11
                    if isfield(Data_1, 'channel9')
                        handles.channel9 = Data_1.channel9(:, 2:end);
                        set(currentline, 'XData', handles.time, 'YData', squeeze(handles.channel9(:)), 'Visible', 'on');
                    else
                        msgbox('No wave to import. The channel 9 is empty', 'Icon', 'help');
                        set(hObject, 'Value', 1);
                        set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                    end
                    
            end
        else
            switch popup_value -1
                case 0 % none
                    set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                case 1
                    if Data_1.channel{1, 1}(1) ~= 0
                        
                        set(currentline, 'XData', handles.time2, 'YData', squeeze(handles.channel1(:)), 'Visible', 'on');
                    else
                        msgbox('No wave to import. The channel 1 is empty', 'Icon', 'help');
                        set(hObject, 'Value', 1);
                        set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                    end
                    
                case 2
                    if Data_1.channel{2, 1}(1) ~= 0
                        
                        set(currentline, 'XData', handles.time2, 'YData', squeeze(handles.channel2(:)), 'Visible', 'on');
                        
                    else
                        msgbox('No wave to import. The channel 2 is empty', 'Icon', 'help');
                        set(hObject, 'Value', 1);
                        set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                    end
                case 3
                    if Data_1.channel{3, 1}(1) ~= 0
                        set(currentline, 'XData', handles.time2, 'YData', squeeze(handles.channel3(:)), 'Visible', 'on');
                        
                    else
                        msgbox('No wave to import. The channel 3 is empty', 'Icon', 'help');
                        set(hObject, 'Value', 1);
                        set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                    end
                case 4
                    if Data_1.channel{4, 1}(1) ~= 0
                        set(currentline, 'XData', handles.time2, 'YData', squeeze(handles.channel4(:)), 'Visible', 'on');
                    else
                        msgbox('No wave to import. The channel 4 is empty', 'Icon', 'help');
                        set(hObject, 'Value', 1);
                        set(currentline, 'XData', 0, 'YData', 0, 'Visible', 'off');
                    end
                    
            end
        end
        handles.rightpanelcount = 0;
        handles.analogcount = 0;
        if get(scrn1_popup, 'Value') ~= 1
            handles.rightpanelcount = handles.rightpanelcount + 1;
        end
        if get(scrn2_popup, 'Value') ~= 1
            handles.rightpanelcount = handles.rightpanelcount + 1;
        end
        if get(scrn3_popup, 'Value') ~= 1
            handles.rightpanelcount = handles.rightpanelcount + 1;
        end
        if get(scrn4_popup, 'Value') ~= 1
            handles.rightpanelcount = handles.rightpanelcount + 1;
        end
        if get(analog_popup, 'Value') ~= 1
            handles.analogcount = 1;
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CONDITION SIGNALS
%% Condition Signals Selection Change Callback
    function cond_sig_selcbk(source, ~)
        
        gg1 = waitbar(1, 'Wait please ...');
        % Read check box
        if source == apply_button_1
            interv=get(working_interval_1,'Value');
        end
        if source == apply_button_2
            interv=get(working_interval_2,'Value');
        end
        
        if interv
            val01 = round(str2double(get(starttimemap_edit, 'String'))*handles.Fs,0);
            val02 = round(str2double(get(endtimemap_edit, 'String'))*handles.Fs);
            if val01/handles.Fs <handles.starttime+handles.starttime*0.05
                val01=2;
            end
            int=(val01:val02);
        end
        if  get(cond_sign_scrns_button_1, 'Value') == 0 && get(cond_sign_scrns_button_2, 'Value') == 0
            %%
            if source == apply_button_1
                current_data = flipud(double(Data_1.cmosData));
                current_bg = flipud(double(Data_1.bgimage));
                removeBG_state = get(removeBG_button_1, 'Value');
                filt_state = get(filt_button_1, 'Value');
                bin_state = get(bin_button_1, 'Value');
                drift_state = get(removeDrift_button_1, 'Value');
                norm_state = get(norm_button_1, 'Value');
                bin_pop_state = get(bin_popup_1, 'Value');
                filt_pop_state = get(filt_popup_1, 'Value');
                ord_val = get(drift_popup_1, 'Value');
                ord_str = get(drift_popup_1, 'String');
                current_scrn = handles.movie_scrn_1;
                
                %handles
                
                if removeBG_state
                    handles.state_bg=strcat('Background removed :            BG Threshold :',  get(bg_thresh_edit_1, 'String'), '           EX Threshold :', get(perc_ex_edit_1, 'String') );
                else
                    handles.state_bg=' Background not removed ';
                end
                if norm_state
                    handles.state_norm= 'Normalized';
                else
                    handles.state_norm='Not normalized ';
                end
                if bin_state
                    if bin_pop_state == 1
                        handles.state_bin=('Binned : 3 x 3 ' );
                    elseif bin_pop_state == 2
                        handles.state_bin=('Binned : 5 x 5 ' );
                    elseif bin_pop_state == 3
                        handles.state_bin=('Binned : 7 x 7 ' );
                    end
                else
                    handles.state_bin='Not binned ';
                end
                if filt_state
                    if filt_pop_state == 1
                        handles.state_filt=strcat('Filtered : [0 50] ');
                    elseif filt_pop_state == 2
                        handles.state_filt=strcat('Filtered : [0 75] ');
                    elseif filt_pop_state == 3
                        handles.state_filt=strcat('Filtered : [0 100] ');
                    elseif filt_pop_state == 4
                        handles.state_filt=strcat('Filtered : [0 150] ');
                    end
                else
                    handles.state_filt= 'Not filtered ';
                end
                if drift_state
                    if ord_val == 1
                        handles.state_drift=strcat('Drifted : [1 st order] ');
                    elseif ord_val == 2
                        handles.state_drift=strcat('Drifted : [2 nd order] ');
                    elseif ord_val == 3
                        handles.state_drift=strcat('Drifted : [3 rd order] ');
                    elseif ord_val == 4
                        handles.state_drift=strcat('Drifted : [4 th order] ');
                    end
                else
                    handles.state_drift=' Not drifted ' ;
                    
                end
                
            elseif source == apply_button_2
                if handles.version == 1
                    current_data = -((double(Data_1.cmosData2)));
                    current_bg = flipud(double(Data_1.bgimage2));
                else
                    current_data =- (double(Data_2.cmosData));
                    current_bg =flipud( double(Data_2.bgimage));
                end
                
                removeBG_state = get(removeBG_button_2, 'Value');
                filt_state = get(filt_button_2, 'Value');
                bin_state = get(bin_button_2, 'Value');
                drift_state = get(removeDrift_button_2, 'Value');
                norm_state = get(norm_button_2, 'Value');
                bin_pop_state = get(bin_popup_2, 'Value');
                filt_pop_state = get(filt_popup_2, 'Value');
                ord_val = get(drift_popup_2, 'Value');
                ord_str = get(drift_popup_2, 'String');
                current_scrn = handles.movie_scrn_2;
                %handles
                
                if removeBG_state
                    handles.state_bg=strcat('Background removed :            BG Threshold :',  get(bg_thresh_edit_2, 'String'), '           EX Threshold :', get(perc_ex_edit_2, 'String') );
                else
                    handles.state_bg=' Background not removed ';
                end
                if norm_state
                    handles.state_norm= 'Normalized';
                else
                    handles.state_norm='Not normalized ';
                end
                if bin_state
                    if bin_pop_state == 1
                        handles.state_bin=('Binned : 3 x 3 ' );
                    elseif bin_pop_state == 2
                        handles.state_bin=('Binned : 5 x 5 ' );
                    elseif bin_pop_state == 3
                        handles.state_bin=('Binned : 7 x 7 ' );
                    end
                else
                    handles.state_bin='Not binned ';
                end
                if filt_state
                    if filt_pop_state == 1
                        handles.state_filt=strcat('Filtered : [0 50] ');
                    elseif filt_pop_state == 2
                        handles.state_filt=strcat('Filtered : [0 75] ');
                    elseif filt_pop_state == 3
                        handles.state_filt=strcat('Filtered : [0 100] ');
                    elseif filt_pop_state == 4
                        handles.state_filt=strcat('Filtered : [0 150] ');
                    end
                else
                    handles.state_filt= 'Not filtered ';
                end
                if drift_state
                    if ord_val == 1
                        handles.state_drift=strcat('Drifted : [1 st order] ');
                    elseif ord_val == 2
                        handles.state_drift=strcat('Drifted : [2 nd order] ');
                    elseif ord_val == 3
                        handles.state_drift=strcat('Drifted : [3 rd order] ');
                    elseif ord_val == 4
                        handles.state_drift=strcat('Drifted : [4 th order] ');
                    end
                else
                    handles.state_drift=' Not drifted ' ;
                    
                end
                
            end
            if interv
                
                current_data_total=current_data(:, :, 2:end);
                current_data_total(:,:,int)=0;
                current_data = current_data(:, :, int);
                
                
                current_bgRGB = real2rgb(current_bg, 'gray');
                
            else
                current_bgRGB = real2rgb(current_bg, 'gray');
                current_data=    current_data(:, :, 2:end);
            end
            handles.normflag = 0; % Initialize normflag
            %%
            
            if removeBG_state == 1
                if source == apply_button_1
                    bg_thresh = str2double(get(bg_thresh_edit_1, 'String'));
                    perc_ex = str2double(get(perc_ex_edit_1, 'String'));
                elseif source == apply_button_2
                    perc_ex = str2double(get(perc_ex_edit_2, 'String'));
                    bg_thresh = str2double(get(bg_thresh_edit_2, 'String'));
                end
                current_data = remove_BKGRD(current_data, current_bg, bg_thresh, perc_ex);
            end
            
            if bin_state == 1
                if bin_pop_state == 3
                    bin_size = 7;
                elseif bin_pop_state == 2
                    bin_size = 5;
                else
                    bin_size = 3;
                end
                current_data = binning(current_data, bin_size);
            end
            
            if filt_state == 1
                if filt_pop_state == 4
                    or = 100;
                    lb = 0.5;
                    hb = 150;
                elseif filt_pop_state == 3
                    or = 100;
                    lb = 0.5;
                    hb = 100;
                elseif filt_pop_state == 2
                    or = 100;
                    lb = 0.5;
                    hb = 75;
                else
                    or = 100;
                    lb = 0.5;
                    hb = 50;
                end
                current_data = filter_data(current_data, handles.Fs, or, lb, hb);
            end
            
            if drift_state == 1
                current_data = remove_Drift(current_data, ord_str(ord_val));
            end
            
            
            if norm_state == 1
                if source==apply_button_1
                    current_data = normalize_data(current_data, handles.Fs);
                    handles.normflag = 1;
                else
                    
                    current_data = -(normalize_data((-current_data), handles.Fs));
                    handles.normflag = 1;
                end
                
            end
            
            %             Adapt the current_data to the time interval observed
            
            if interv
                empty_data=current_data_total*0;
                z=1;
                
                for i=int(1):int(end)
                    empty_data(:,:,i)=current_data(:,:,z);
                    z=z+1;
                end
                
                current_data=empty_data;
                
            end
            %%
            
            % Update movie screen with the conditioned Data_1
            
            if source == apply_button_1
                handles.cmosData_1 = current_data;
                handles.bg = current_bg;
                handles.movie_scrn_1 = current_scrn;
                handles.bg_RGB_1 = current_bgRGB;
                set(f, 'CurrentAxes', handles.movie_scrn_1)
                handles.matrixMax = .9 * max(current_data(:));
                currentframe = handles.frame_1;
                if handles.normflag == 0
                    %                     drawFrame1(currentframe+1);
                    drawFrame1(currentframe);
                    hold on
                else
                    drawFrame1(currentframe);
                    %                     drawFrame1(currentframe+1);
                    caxis([0, 1])
                    hold on
                end
                
                set(current_scrn, 'YTick', [], 'XTick', []);
                
                % Update markers on movie screen
                M1 = handles.M1;
                [a, ~] = size(M1);
                hold on
                for x = 1:a
                    set(handles.scatM1, 'XData', handles.M1(:, 1), 'YData', handles.M1(:, 2))
                    set(handles.movie_scrn_1, 'YTick', [], 'XTick', []); % Hide tick markes
                end
                hold off
                v = [handles.line_signal_scrn_1_1_1, handles.line_signal_scrn_2_1_1, handles.line_signal_scrn_3_1_1,handles.line_signal_scrn_1_3_1,handles.line_signal_scrn_2_3_1,handles.line_signal_scrn_3_3_1];
                
                if handles.M1(1, 1) ~= 0
                    %
                    set(v(1), 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(handles.M1(1, 2), handles.M1(1, 1), :)));
                    set(v(4), 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(handles.M1(1, 2), handles.M1(1, 1), :)));
                end
                if handles.M1(2, 1) ~= 0
                    
                    set(v(2), 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(handles.M1(2, 2), handles.M1(2, 1), :)));
                    set(v(5), 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(handles.M1(2, 2), handles.M1(2, 1), :)));
                    
                end
                if handles.M1(3, 1) ~= 0
                    %
                    set(v(3), 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(handles.M1(3, 2), handles.M1(3, 1), :)));
                    set(v(6), 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(handles.M1(3, 2), handles.M1(3, 1), :)));
                    
                end
            elseif source == apply_button_2
                %
                handles.cmosData_2 = current_data;
                handles.bg2 = current_bg;
                handles.movie_scrn_2 = current_scrn;
                handles.bg_RGB_2 = current_bgRGB;
                
                set(f, 'CurrentAxes', handles.movie_scrn_2)
                handles.matrixMax2 = .9 * max(current_data(:));
                currentframe = handles.frame_2;
                
                
                if handles.normflag == 0
                    drawFrame2(currentframe);
                    hold on
                else
                    drawFrame2(currentframe);
                    caxis([0, 1])
                    hold on
                end
                set(handles.movie_scrn_2, 'YTick', [], 'XTick', []); % Hide tick markes
                % Update markers on movie screen
                
                M2 = handles.M2;
                [a, ~] = size(M2);
                hold on
                for x = 1:a
                    set(handles.scatM2, 'XData', handles.M2(:, 1), 'YData', handles.M2(:, 2))
                    set(handles.movie_scrn_2, 'YTick', [], 'XTick', []); % Hide tick markes
                end
                hold off
                
                v = [handles.line_signal_scrn_1_2_1, handles.line_signal_scrn_2_2_1, handles.line_signal_scrn_3_2_1,handles.line_signal_scrn_1_3_2,handles.line_signal_scrn_2_3_2,handles.line_signal_scrn_3_3_2];
                if M2(1, 1) ~= 0
                    
                    
                    
                    set(v(1), 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(M2(1, 2), M2(1, 1), :))+1);
                    set(v(4), 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(M2(1, 2), M2(1, 1), :))+1);
                    
                end
                if M2(2, 1) ~= 0
                    
                    set(v(2), 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(M2(2, 2), M2(2, 1), :))+1);
                    set(v(5), 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(M2(2, 2), M2(2, 1), :))+1);
                    
                end
                if M2(3, 1) ~= 0
                    
                    set(v(3), 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(M2(3, 2), M2(3, 1), :))+1);
                    set(v(6), 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(M2(3, 2), M2(3, 1), :))+1);
                    
                end
            end
            close(gg1)
        else
            %% option
            
            current_data = flipud(double(Data_1.cmosData));
            current_bg = flipud(double(Data_1.bgimage));
            removeBG_state = get(removeBG_button_1, 'Value');
            filt_state = get(filt_button_1, 'Value');
            bin_state = get(bin_button_1, 'Value');
            drift_state = get(removeDrift_button_1, 'Value');
            norm_state = get(norm_button_1, 'Value');
            bin_pop_state = get(bin_popup_1, 'Value');
            filt_pop_state = get(filt_popup_1, 'Value');
            ord_val = get(drift_popup_1, 'Value');
            ord_str = get(drift_popup_1, 'String');
            current_scrn = handles.movie_scrn_1;
            interv=get(working_interval_1,'Value');
            
            if handles.version == 1
                current_data2 = -((double(Data_1.cmosData2)));
                current_bg2 = flipud(double(Data_1.bgimage2));
            else
                current_data2 = -(double(Data_2.cmosData));
                current_bg2 = flipud(double(Data_2.bgimage));
            end
            
            removeBG_state2 = get(removeBG_button_2, 'Value');
            filt_state2 = get(filt_button_2, 'Value');
            bin_state2 = get(bin_button_2, 'Value');
            drift_state2 = get(removeDrift_button_2, 'Value');
            norm_state2 = get(norm_button_2, 'Value');
            bin_pop_state2 = get(bin_popup_2, 'Value');
            filt_pop_state2 = get(filt_popup_2, 'Value');
            ord_val2 = get(drift_popup_2, 'Value');
            ord_str2 = get(drift_popup_2, 'String');
            current_scrn2 = handles.movie_scrn_2;
            
            if interv
                %
                current_data_total=current_data(:, :, 2:end);
                current_data_total(:,:,int)=0;
                current_data = current_data(:, :, int);
                
                current_bgRGB = real2rgb(current_bg, 'gray');
                current_bgRGB2 = real2rgb(current_bg2, 'gray');
                current_data_total2=current_data2(:, :, 2:end);
                current_data_total2(:,:,int)=0;
                current_data2 = current_data2(:, :, int);
            else
                current_bgRGB = real2rgb(current_bg, 'gray');
                current_bgRGB2 = real2rgb(current_bg2, 'gray');
                current_data=    current_data(:, :, 2:end);
                current_data2=current_data2(:, :, 2:end);
                
            end
            handles.normflag = 0; % Initialize normflag
            
            
            if source == apply_button_1
                if removeBG_state == 1
                    set (removeBG_button_2, 'Value', 1)
                    bg_thresh = str2double(get(bg_thresh_edit_1, 'String'));
                    perc_ex = str2double(get(perc_ex_edit_1, 'String'));
                    set( bg_thresh_edit_2 , 'String', bg_thresh) ;
                    set( perc_ex_edit_2 , 'String', perc_ex);
                    current_data = remove_BKGRD(current_data, current_bg, bg_thresh, perc_ex);
                    current_data2 = remove_BKGRD(current_data2, current_bg2, bg_thresh, perc_ex);
                else
                    set (removeBG_button_2, 'Value', 0)
                end
                
                if bin_state == 1
                    if bin_pop_state == 3
                        bin_size = 7;
                    elseif bin_pop_state == 2
                        bin_size = 5;
                    else
                        bin_size = 3;
                    end
                    current_data = binning(current_data, bin_size);
                    current_data2 = binning(current_data2, bin_size);
                    set (bin_button_2, 'Value', 1) ;
                    set( bin_popup_2 , 'Value', bin_pop_state ) ;
                else
                    set (bin_button_2, 'Value', 0) ;
                end
                
                if filt_state == 1
                    if filt_pop_state == 4
                        or = 100;
                        lb = 0.5;
                        hb = 150;
                    elseif filt_pop_state == 3
                        or = 100;
                        lb = 0.5;
                        hb = 100;
                    elseif filt_pop_state == 2
                        or = 100;
                        lb = 0.5;
                        hb = 75;
                    else
                        or = 100;
                        lb = 0.5;
                        hb = 50;
                    end
                    current_data = filter_data(current_data, handles.Fs, or, lb, hb);
                    current_data2 = filter_data(current_data2, handles.Fs, or, lb, hb);
                    set (filt_button_2, 'Value', 1) ;
                    set( filt_popup_2 , 'Value', filt_pop_state ) ;
                else
                    set (filt_button_2, 'Value', 0) ;
                end
                
                if drift_state == 1
                    current_data = remove_Drift(current_data, ord_str(ord_val));
                    current_data2 = remove_Drift(current_data2, ord_str2(ord_val2));
                    set (removeDrift_button_2, 'Value', 1) ;
                    set( drift_popup_2 , 'Value', ord_val ) ;
                else
                    set (removeDrift_button_2, 'Value', 0) ;
                end
                
                if norm_state == 1
                    current_data = normalize_data(current_data, handles.Fs);
                    current_data2 = -normalize_data(-current_data2, handles.Fs);
                    handles.normflag = 1;
                    set (norm_button_2, 'Value', 1) ;
                else
                    set (norm_button_2, 'Value', 0) ;
                end
                
                
            elseif source == apply_button_2
                
                if removeBG_state2 == 1
                    set (removeBG_button_1, 'Value', 1)
                    bg_thresh = str2double(get(bg_thresh_edit_2, 'String'));
                    perc_ex = str2double(get(perc_ex_edit_2, 'String'));
                    set( bg_thresh_edit_1 , 'Value', bg_thresh) ;
                    set( perc_ex_edit_1 , 'Value', perc_ex);
                    current_data = remove_BKGRD(current_data, current_bg, bg_thresh, perc_ex);
                    current_data2 = remove_BKGRD(current_data2, current_bg2, bg_thresh, perc_ex);
                else
                    set (removeBG_button_1, 'Value', 0) ;
                end
                
                if bin_state2 == 1
                    if bin_pop_state2 == 3
                        bin_size = 7;
                    elseif bin_pop_state2 == 2
                        bin_size = 5;
                    else
                        bin_size = 3;
                    end
                    current_data = binning(current_data, bin_size);
                    current_data2 = binning(current_data2, bin_size);
                    set (bin_button_1, 'Value', 1) ;
                    set( bin_popup_1 , 'Value', bin_pop_state2 ) ;
                else
                    set (bin_button_1, 'Value', 0) ;
                end
                
                if filt_state2 == 1
                    if filt_pop_state2 == 4
                        or = 100;
                        lb = 0.5;
                        hb = 150;
                    elseif filt_pop_state2 == 3
                        or = 100;
                        lb = 0.5;
                        hb = 100;
                    elseif filt_pop_state2 == 2
                        or = 100;
                        lb = 0.5;
                        hb = 75;
                    else
                        or = 100;
                        lb = 0.5;
                        hb = 50;
                    end
                    current_data = filter_data(current_data, handles.Fs, or, lb, hb);
                    current_data2 = filter_data(current_data2, handles.Fs, or, lb, hb);
                    set (filt_button_1, 'Value', 1) ;
                    set( filt_popup_1 , 'Value', filt_pop_state2 ) ;
                else
                    set (filt_button_1, 'Value', 0) ;
                end
                if drift_state2 == 1
                    current_data = remove_Drift(current_data, ord_str(ord_val));
                    current_data2 = remove_Drift(current_data2, ord_str2(ord_val2));
                    set (removeDrift_button_1, 'Value', 1) ;
                    set( drift_popup_1 , 'Value', ord_val2 ) ;
                else
                    set (removeDrift_button_1, 'Value', 0) ;
                end
                
                if norm_state2 == 1
                    current_data = normalize_data(current_data, handles.Fs);
                    current_data2 = -normalize_data(-current_data2, handles.Fs);
                    handles.normflag = 1;
                    set (norm_button_1, 'Value', 1) ;
                else
                    set (norm_button_1, 'Value', 0) ;
                end
                
            end
            
            if removeBG_state
                handles.state_bg=strcat('Background removed :            BG Threshold :',  get(bg_thresh_edit_2, 'String'), '           EX Threshold :', get(perc_ex_edit_2, 'String') );
            else
                handles.state_bg=' Background not removed ';
            end
            if norm_state
                handles.state_norm= 'Normalized';
            else
                handles.state_norm='Not normalized ';
            end
            if bin_state
                if bin_pop_state == 1
                    handles.state_bin=('Binned : 3 x 3 ' );
                elseif bin_pop_state == 2
                    handles.state_bin=('Binned : 5 x 5 ' );
                elseif bin_pop_state == 3
                    handles.state_bin=('Binned : 7 x 7 ' );
                end
            else
                handles.state_bin='Not binned ';
            end
            if filt_state
                if filt_pop_state == 1
                    handles.state_filt=strcat('Filtered : [0 50] ');
                elseif filt_pop_state == 2
                    handles.state_filt=strcat('Filtered : [0 75] ');
                elseif filt_pop_state == 3
                    handles.state_filt=strcat('Filtered : [0 100] ');
                elseif filt_pop_state == 4
                    handles.state_filt=strcat('Filtered : [0 150] ');
                end
            else
                handles.state_filt= 'Not filtered ';
            end
            if drift_state
                if ord_val == 1
                    handles.state_drift=strcat('Drifted : [1 st order] ');
                elseif ord_val == 2
                    handles.state_drift=strcat('Drifted : [2 nd order] ');
                elseif ord_val == 3
                    handles.state_drift=strcat('Drifted : [3 rd order] ');
                elseif ord_val == 4
                    handles.state_drift=strcat('Drifted : [4 th order] ');
                end
            else
                handles.state_drift=' Not drifted ' ;
                
            end
            
            
            if interv
                
                %Adapt the current_data to the time interval observed
                empty_data=current_data_total*0;   z=1;
                for i=int(1):int(end)
                    empty_data(:,:,i)=current_data(:,:,z);
                    z=z+1;
                end
                
                current_data=empty_data;
                
                %                 Adapt the current_data2 to the time interval observed
                empty_data2=current_data_total2*0;   z=1;
                for i=int(1):int(end)
                    empty_data2(:,:,i)=current_data2(:,:,z);
                    z=z+1;
                end
                
                current_data2=empty_data2;
            end
            
            %         % Update movie screen with the conditioned Data_1
            %
            if source == apply_button_1 || source == apply_button_2
                handles.cmosData_1 = current_data;
                handles.bg = current_bg;
                handles.movie_scrn_1 = current_scrn;
                handles.bg_RGB_1 = current_bgRGB;
                set(f, 'CurrentAxes', handles.movie_scrn_1)
                handles.matrixMax = .9 * max(current_data(:));
                currentframe = handles.frame_1;
                if handles.normflag == 0
                    drawFrame1(currentframe);
                    hold on
                else
                    drawFrame1(currentframe);
                    caxis([0, 1])
                    hold on
                end
                
                set(current_scrn, 'YTick', [], 'XTick', []);
                
                % Update markers on movie screen
                M1 = handles.M1;
                [a, ~] = size(M1);
                hold on
                for x = 1:a
                    set(handles.scatM1, 'XData', handles.M1(:, 1), 'YData', handles.M1(:, 2))
                    set(handles.movie_scrn_1, 'YTick', [], 'XTick', []); % Hide tick markes
                end
                hold off
                v = [handles.line_signal_scrn_1_1_1, handles.line_signal_scrn_2_1_1, handles.line_signal_scrn_3_1_1,handles.line_signal_scrn_1_3_1,handles.line_signal_scrn_2_3_1,handles.line_signal_scrn_3_3_1];
                
                if handles.M1(1, 1) ~= 0
                    set(v(1), 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(handles.M1(1, 2), handles.M1(1, 1), :)));
                    set(v(4), 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(handles.M1(1, 2), handles.M1(1, 1), :)));
                end
                if handles.M1(2, 1) ~= 0
                    set(v(2), 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(handles.M1(2, 2), handles.M1(2, 1), :)));
                    set(v(5), 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(handles.M1(2, 2), handles.M1(2, 1), :)));
                end
                if handles.M1(3, 1) ~= 0
                    set(v(3), 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(handles.M1(3, 2), handles.M1(3, 1), :)));
                    set(v(6), 'XData', handles.time, 'YData', squeeze(handles.cmosData_1(handles.M1(3, 2), handles.M1(3, 1), :)));
                    
                end
                
                handles.cmosData_2 = current_data2;
                handles.bg2 = current_bg2;
                handles.movie_scrn_2 = current_scrn2;
                handles.bg_RGB_2 = current_bgRGB2;
                
                set(f, 'CurrentAxes', handles.movie_scrn_2)
                handles.matrixMax2 = .9 * max(current_data2(:));
                currentframe2 = handles.frame_2;
                if handles.normflag == 0
                    drawFrame2(currentframe2);
                    hold on
                else
                    drawFrame2(currentframe2);
                    caxis([0, 1])
                    hold on
                end
                set(handles.movie_scrn_2, 'YTick', [], 'XTick', []); % Hide tick markes
                % Update markers on movie screen
                M2 = handles.M2;
                [a, ~] = size(M2);
                hold on
                for x = 1:a
                    set(handles.scatM2, 'XData', handles.M2(:, 1), 'YData', handles.M2(:, 2))
                    set(handles.movie_scrn_2, 'YTick', [], 'XTick', []); % Hide tick markes
                end
                hold off
                v = [handles.line_signal_scrn_1_2_1, handles.line_signal_scrn_2_2_1, handles.line_signal_scrn_3_2_1,handles.line_signal_scrn_1_3_2,handles.line_signal_scrn_2_3_2,handles.line_signal_scrn_3_3_2];
                if M2(1, 1) ~= 0
                    set(v(1), 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(M2(1, 2), M2(1, 1), :))+1);
                    set(v(4), 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(M2(1, 2), M2(1, 1), :))+1);
                    
                end
                if M2(2, 1) ~= 0
                    set(v(2), 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(M2(2, 2), M2(2, 1), :))+1);
                    set(v(5), 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(M2(2, 2), M2(2, 1), :))+1);
                    
                end
                if M2(3, 1) ~= 0
                    set(v(3), 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(M2(3, 2), M2(3, 1), :))+1);
                    set(v(6), 'XData', handles.time, 'YData', squeeze(handles.cmosData_2(M2(3, 2), M2(3, 1), :))+1);
                    
                end
            end
            close(gg1)
        end
        
    end


    function both_screen_option_callback (source, ~)
        if source == cond_sign_scrns_button_1
            if get(cond_sign_scrns_button_1, 'Value')==1
                set(cond_sign_scrns_button_2, 'Value',1)
            else
                set(cond_sign_scrns_button_2, 'Value',0)
            end
            set(working_interval_2,'Value',get(working_interval_1,'Value'))
        elseif get(cond_sign_scrns_button_2, 'Value') ==1
            set(cond_sign_scrns_button_1, 'Value',1)
        else
            set(cond_sign_scrns_button_1, 'Value',0)
            set(working_interval_1,'Value',get(working_interval_2,'Value'))
        end
    end

    function interval_option_callback (source, ~)
        
        if source == working_interval_1
            if get(working_interval_1, 'Value')==1
                set(working_interval_2, 'Value',1)
                
            else
                set(working_interval_2, 'Value',0)
            end
            
        elseif source == working_interval_2
            if get(working_interval_2, 'Value') ==1
                set(working_interval_1, 'Value',1)
                
            else
                set(working_interval_1, 'Value',0)
                
            end
        end
    end

%% INVERT COLORMAP: inverts the colormaps for all isochrone maps
    function invert_cmap_callback(~, ~)
        invert_cmap_1_state = get(invert_cmap, 'Value');
        if invert_cmap_1_state == 1
            handles.invert = 1;
        else
            handles.invert = 0;
        end
    end
%% ACTIVATION MAP
%% Callback for Start and End Time for Activation Map
    function amaptime_edit_callback(source, ~)
        % get the bounds of the viewing window
        handles.vw_start = str2double(get(starttimemap_edit, 'String'));
        handles.vw_end = str2double(get(endtimemap_edit, 'String'));
        
        % get the bounds of the activation window
        a_start = str2double(get(starttimeamap_edit, 'String'));
        a_end = str2double(get(endtimeamap_edit, 'String'));
        set(starttimeamap_edit2, 'String', a_start)
        set(endtimeamap_edit2, 'String', a_end)
        set(new_end_edit, 'String', a_end - a_start);
        newEnd_callback(source)
        if a_start >= handles.starttime && a_start <= handles.endtime
            if a_end >= handles.starttime && a_end <= handles.endtime
                a = [a_start, a_start];
                c = [a_end, a_end];
                
                set(handles.time_bar_1, 'NextPlot', 'replacechildren', 'Visible', 'off');
                set(handles.time_bar_2, 'NextPlot', 'replacechildren', 'Visible', 'off');
                set(handles.time_bar_3, 'NextPlot', 'replacechildren', 'Visible', 'off');
                set(handles.time_bar_channels, 'NextPlot', 'replacechildren', 'Visible', 'off');
                
                set(f, 'CurrentAxes', handles.time_bar_1);
                set(handles.bar_start_1, 'XData', a, 'color', 'r', 'visible', 'on')
                set(handles.bar_end_1, 'XData', c, 'color', 'r', 'visible', 'on')
                axis([handles.vw_start, handles.vw_end, 0, 1]);
                hold off;
                
                set(f, 'CurrentAxes', handles.time_bar_2);
                set(handles.bar_start_2, 'XData', a, 'color', 'r', 'visible', 'on')
                set(handles.bar_end_2, 'XData', c, 'color', 'r', 'visible', 'on')
                axis([handles.vw_start, handles.vw_end, 0, 1]);
                hold off;
                
                set(f, 'CurrentAxes', handles.time_bar_3);
                set(handles.bar_start_3, 'XData', a, 'YData', [0, 1], 'color', 'r', 'visible', 'on')
                set(handles.bar_end_3, 'XData', c, 'YData', [0, 1], 'color', 'r', 'visible', 'on')
                axis([handles.vw_start, handles.vw_end, 0, 1]);
                hold off;
                
                set(f, 'CurrentAxes', handles.time_bar_channels);
                set(handles.bar_start_channels, 'XData', a, 'YData', [0, 1], 'color', 'r', 'visible', 'on')
                set(handles.bar_end_channels, 'XData', c, 'YData', [0, 1], 'color', 'r', 'visible', 'on')
                axis([handles.vw_start, handles.vw_end, 0, 1]);
                hold off;
                
                
                handles.timebar(1, :) = [a_start, a_end];
                handles.timebar(2, :) = [a_start, a_end];
                handles.timebar(3, :) = [a_start, a_end];
                
                handles.a_start = a_start;
                handles.a_end = a_end;
                
                newEnd_callback(source)
            else
                error = 'The END TIME must be greater than %d and less than %.3f.';
                msgbox(sprintf(error, handles.starttime, handles.endtime), 'Incorrect Input', 'Warn');
                set(endtimeamap_edit, 'String', handles.endtime)
            end
        end
    end
    function amaptime_edit_callback2(~, ~)
        % get the bounds of the viewing window
        handles.vw_start = str2double(get(starttimemap_edit, 'String'));
        handles.vw_end = str2double(get(endtimemap_edit, 'String'));
        
        % get the bounds of the activation window
        a_start = str2double(get(starttimeamap_edit2, 'String'));
        a_end = str2double(get(endtimeamap_edit2, 'String'));
        set(starttimeamap_edit, 'String', a_start)
        set(endtimeamap_edit, 'String', a_end)
        
        
        if a_start >= handles.starttime && a_start <= handles.endtime
            if a_end >= handles.starttime && a_end <= handles.endtime
                a = [a_start, a_start];
                c = [a_end, a_end];
                
                set(handles.time_bar_1, 'NextPlot', 'replacechildren', 'Visible', 'off');
                set(handles.time_bar_2, 'NextPlot', 'replacechildren', 'Visible', 'off');
                set(handles.time_bar_3, 'NextPlot', 'replacechildren', 'Visible', 'off');
                set(handles.time_bar_channels, 'NextPlot', 'replacechildren', 'Visible', 'off');
                
                set(f, 'CurrentAxes', handles.time_bar_1);
                set(handles.bar_start_1, 'XData', a, 'color', 'r', 'visible', 'on')
                set(handles.bar_end_1, 'XData', c, 'color', 'r', 'visible', 'on')
                axis([handles.vw_start, handles.vw_end, 0, 1]);
                hold off;
                
                set(f, 'CurrentAxes', handles.time_bar_2);
                set(handles.bar_start_2, 'XData', a, 'color', 'r', 'visible', 'on')
                set(handles.bar_end_2, 'XData', c, 'color', 'r', 'visible', 'on')
                axis([handles.vw_start, handles.vw_end, 0, 1]);
                hold off;
                
                set(f, 'CurrentAxes', handles.time_bar_3);
                set(handles.bar_start_3, 'XData', a, 'YData', [0, 1], 'color', 'r', 'visible', 'on')
                set(handles.bar_end_3, 'XData', c, 'YData', [0, 1], 'color', 'r', 'visible', 'on')
                axis([handles.vw_start, handles.vw_end, 0, 1]);
                hold off;
                
                set(f, 'CurrentAxes', handles.time_bar_channels);
                set(handles.bar_start_channels, 'XData', a, 'YData', [0, 1], 'color', 'r', 'visible', 'on')
                set(handles.bar_end_channels, 'XData', c, 'YData', [0, 1], 'color', 'r', 'visible', 'on')
                axis([handles.vw_start, handles.vw_end, 0, 1]);
                hold off;
                
                
                handles.timebar(1, :) = [a_start, a_end];
                handles.timebar(2, :) = [a_start, a_end];
                handles.timebar(3, :) = [a_start, a_end];
                
                handles.a_start = a_start;
                handles.a_end = a_end;
                
                
            else
                error = 'The END TIME must be greater than %d and less than %.3f.';
                msgbox(sprintf(error, handles.starttime, handles.endtime), 'Incorrect Input', 'Warn');
                set(endtimeamap_edit2, 'String', handles.endtime)
            end
        end
    end

%% Button to create activation map
    function createmap_button_callback(~, ~)
        handles.state_screen='Screen 1';
        gg = waitbar(1, 'Building  Activation Map...');
        handles.a_start = str2double(get(starttimeamap_edit, 'String'));
        handles.a_end = str2double(get(endtimeamap_edit, 'String'));
        option_cmap_1_state = get(act_cmap, 'Value');
        if option_cmap_1_state == 1
            try
                [start, endp] = OptionAPDaMap(handles.cmosData_1, handles.a_start, handles.a_end, handles.Fs, handles.M1);
                aMap(handles.cmosData_1, start, endp, handles.Fs, handles.invert);
            catch
                if handles.M1(2,1)==0
                    msgbox('Please select at least 2 points on the movie screen 1');
                end
            end
        else
            aMap(handles.cmosData_1, handles.a_start, handles.a_end, handles.Fs, handles.invert, handles);
            close(gg)
        end
        
    end

%% New zero
    function newEnd_callback(~)
        
        val1 = (str2double(get(starttimeamap_edit, 'String')));
        val2 = (str2double(get(endtimeamap_edit, 'String')));
        newzero = (val2 - val1) * 1000;
        set(new_end_edit, 'String', newzero)
    end

% Button to create map / regional map for APD and Repolarization

    function create_button_callback(~, ~)
        Data_1 = handles.cmosData_1;
        handles.state_screen='Screen 1';
        apd_start = str2double(get(starttimeamap_edit, 'String'));
        apd_end = str2double(get(endtimeamap_edit, 'String'));
        option_cmap_1_state = get(act_cmap, 'Value');
        handles.percentAPD = str2double(get(percentapd_edit, 'String'));
        if option_cmap_1_state == 1
            try
                [start, endp] = OptionAPDaMap(handles.cmosData_1, apd_start, apd_end, handles.Fs, handles.M1);
                HeterogeneityRep2(Data_1, start, endp, handles.Fs, handles.percentAPD, handles.cmap, handles.invert);
            catch
                if handles.M1(2,1)==0
                    msgbox('Please select at least 2 points on the movie screen 1');
                end
            end
        else
            HeterogeneityRep2(Data_1, apd_start, apd_end, handles.Fs, handles.percentAPD, handles.cmap, handles.invert,handles);
        end
    end

    function create_buttonR_callback(~, ~)
        handles.state_screen='Screen 1';
        Data_1 = handles.cmosData_1;
        apd_start = str2double(get(starttimeamap_edit, 'String'));
        apd_end = str2double(get(endtimeamap_edit, 'String'));
        handles.percentAPD = str2double(get(percentapd_edit, 'String'));
        handles.maxapd = str2double(get(maxapd_edit, 'String'));
        handles.minapd = str2double(get(minapd_edit, 'String'));
        remove_motion_state = get(remove_motion_click, 'Value');
        axes(handles.movie_scrn_1)
        coordinate = getrect(handles.movie_scrn_1);
        bg = handles.bg;
        
        option_cmap_1_state = get(act_cmap, 'Value');
        if option_cmap_1_state == 1
            try
                [start, endp] = OptionAPDaMap(handles.cmosData_1, apd_start, apd_end, handles.Fs, handles.M1);
                [I, apdMap] = apdCalc(Data_1, start, endp, handles.Fs, handles.percentAPD, handles.maxapd, ...
                    handles.minapd, remove_motion_state, coordinate, bg);
                
                gg = rtCalc(Data_1, start, endp, handles.Fs, handles.percentAPD, handles.maxapd, ...
                    handles.minapd, remove_motion_state, coordinate, bg, I, apdMap, handles.invert, handles);
                close(gg)
            catch
            end
        else
            
            [I, apdMap] = apdCalc(Data_1, apd_start, apd_end, handles.Fs, handles.percentAPD, handles.maxapd, ...
                handles.minapd, remove_motion_state, coordinate, bg);
            
            gg = rtCalc(Data_1, apd_start, apd_end, handles.Fs, handles.percentAPD, handles.maxapd, ...
                handles.minapd, remove_motion_state, coordinate, bg, I, apdMap, handles.invert, handles);
            close(gg)
        end
    end

%% APD Min editable textbox
    function minapd_edit_callback(~, ~)
        minapd = str2double(get(minapd_edit, 'String'));
        maxapd = str2double(get(maxapd_edit, 'String'));
        
        if minapd < 1
            msgbox('Please enter valid number in milliseconds')
        end
        if maxapd <= minapd
            msgbox('Maximum APD needs to be greater than Minimum APD', 'Title', 'Warn')
        end
    end
%% APD Max editable textbox
    function maxapd_edit_callback(source, ~)
        val = get(source, 'String');
        handles.maxapd = str2double(val);
        minapd = str2double(get(minapd_edit, 'String'));
        maxapd = str2double(get(maxapd_edit, 'String'));
        if maxapd < 1
            msgbox('Please enter valid number in milliseconds')
        end
        if maxapd <= minapd
            msgbox('Maximum APD needs to be greater than Minimum APD', 'Title', 'Warn')
        end
    end
%% percent APD editable textbox
    function percentapd_edit_callback(source, ~)
        val = get(source, 'String');
        handles.percentAPD = str2double(val);
        if handles.percentAPD < .1 || handles.percentAPD > 1
            msgbox('Please enter number between .1 - 1', 'Title', 'Warn')
            set(percentapd_edit, 'String', '0.8')
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%CALCIUM
%% Calcium map
    function calcinfo_button_callback(~, ~)
        apd_start = str2double(get(starttimeamap_edit2, 'String'));
        apd_end = str2double(get(endtimeamap_edit2, 'String'));
        gg = waitbar(1, 'Building Calcium Map...');
        
        handles.TTP = get(TTP_box, 'Value');
        handles.Tfall = get(Tfall, 'Value');
        handles.Cad30Cad80 = get(cad30_cad80, 'Value');
        if get(CaD_box, 'Value')
            handles.percentCaD = str2double(get(percentcad_edit, 'String'));
        else
            handles.percentCaD = str2double('');
        end
        if get(CaD_APD_box, 'Value')
            handles.percentCaD_APD = str2double(get(percentcad_apd_edit, 'String'));
        else
            handles.percentCaD_APD = str2double('');
        end
        calcInfo(handles.cmosData_1, handles.cmosData_2, apd_start, apd_end, handles.Fs, handles.invert, handles.percentCaD, handles.TTP, handles.Tfall, handles.Cad30Cad80, handles.percentCaD_APD, handles);
        close(gg)
    end
%% Calcium regional map
    function calcinfo_regional_button_callback(~, ~)
        apd_start = str2double(get(starttimeamap_edit2, 'String'));
        apd_end = str2double(get(endtimeamap_edit2, 'String'));
        
        
        % Read APD Parameters
        handles.percentAPD = str2double(get(percentapd_edit, 'String'));
        handles.maxapd = str2double(get(maxapd_edit, 'String'));
        handles.minapd = str2double(get(minapd_edit, 'String'));
        % Read remove motion check box
        % remove_motion_state = 
        get(remove_motion_click, 'Value');
        axes(handles.movie_scrn_1)
        coordinate = getrect(handles.movie_scrn_2);
        gg = waitbar(1, 'Building Calcium Map...');
        handles.TTP = get(TTP_box, 'Value');
        handles.Tfall = get(Tfall, 'Value');
        handles.Cad30Cad80 = get(cad30_cad80, 'Value');
        if get(CaD_box, 'Value')
            handles.percentCaD = str2double(get(percentcad_edit, 'String'));
        else
            handles.percentCaD = str2double('');
        end
        if get(CaD_APD_box, 'Value')
            handles.percentCaD_APD = str2double(get(percentcad_apd_edit, 'String'));
        else
            handles.percentCaD_APD = str2double('');
        end
        
        calcInfoRegional(handles.cmosData_1, handles.cmosData_2, apd_start, apd_end, handles.Fs, handles.invert, handles.percentCaD, handles.TTP, handles.Tfall, handles.Cad30Cad80, handles.percentCaD_APD, handles.maxapd, handles.minapd, coordinate, handles.bg2, handles);
        
        
        close(gg)
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLUG INS
%% Button to Compute Phase Map
    function createphase_button_callback(~, ~)
        gg = waitbar(1, 'Calculating Phase Map...');
        phaseMap(handles.cmosData_1, handles.dir_1, handles.starttime, handles.endtime, handles.Fs);
        close(gg)
    end

%% Button to Compute Dominant Frequency Map
    function calcDomFreq_button_callback(~, ~)
        gg = waitbar(1, 'Calculating Dominant Frequency Map...');
        calDomFreq(handles.cmosData_1, handles.Fs);
        close(gg)
    end

%% Button to Perform Bootstrap Segmentation
    function calcSegData_button_callback(~, ~)
        gg = waitbar(1, 'Performing Boostrap Analysis...');
        grp_nbr = str2double(get(grp_edit, 'String'));
        seg_Data(handles.cmosData_1, str2double(get(starttimebtstrp_edit, 'String')), str2double(get(endtimebtstrp_edit, 'String')), handles.Fs, handles.bg, grp_nbr);
        pause(.1)
        close(gg)
    end
%% Callback for Start and End Time for Bootstrapping
    function btstrptime_edit_callback(~, ~)
        btstrp_start = str2double(get(starttimebtstrp_edit, 'String'));
        btstrp_end = str2double(get(endtimebtstrp_edit, 'String'));
        if btstrp_start >= handles.starttime && btstrp_start <= handles.endtime
            if btstrp_end >= handles.starttime && btstrp_end <= handles.endtime
                set(f, 'CurrentAxes', handles.sweep_axes_1)
                set(f, 'CurrentAxes', handles.sweep_axes_2)
                set(f, 'CurrentAxes', handles.sweep_axes_3)
                a = [btstrp_start, btstrp_start]; b = [0, 1];
                plot(a, b, 'Color', [1, 153 / 255, 51 / 255], 'Parent', handles.sweep_axes_1)
                plot(a, b, 'Color', [1, 153 / 255, 51 / 255], 'Parent', handles.sweep_axes_2)
                plot(a, b, 'Color', [1, 153 / 255, 51 / 255], 'Parent', handles.sweep_axes_3)
                hold on
                a = [btstrp_end, btstrp_end]; b = [0, 1];
                plot(a, b, 'Color', [1, 153 / 255, 51 / 255], 'Parent', handles.sweep_axes_1)
                plot(a, b, 'Color', [1, 153 / 255, 51 / 255], 'Parent', handles.sweep_axes_2)
                plot(a, b, 'Color', [1, 153 / 255, 51 / 255], 'Parent', handles.sweep_axes_3)
                axis([handles.starttime, handles.endtime, 0, 1])
                hold off; axis off
                hold off
                handles.btstrp_start = btstrp_start;
                handles.btstrp_end = btstrp_end;
            else
                error = 'The END TIME must be greater than %d and less than %.3f.';
                msgbox(sprintf(error, handles.starttime, handles.endtime), 'Incorrect Input', 'Warn');
                set(endtimebtstrp_edit, 'String', handles.endtime)
            end
        else
            error = 'The START TIME must be greater than %d and less than %.3f.';
            msgbox(sprintf(error, handles.starttime, handles.endtime), 'Incorrect Input', 'Warn');
            set(starttimebtstrp_edit, 'String', handles.starttime)
        end
    end

end
