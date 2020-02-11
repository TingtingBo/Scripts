%{
    Yacine Mahdid 2020-02-6
    Here we visualize what we just created in ex_0_0 in order to check if
    the matrices make sense. We are looking only at one pre configured
    state for one pre configured participant.
%}


% Setup the experiment
setup_experiments;

% Extract Needed Variables
ppt = settings.participant;
state = settings.state;
in_path = settings.output_path;
out_path = settings.output_path;

% Constructing the in and out filename
in_filename = strcat(in_path,ppt, '_', state, '_wpli.mat');
out_figure_path = mkdir_if_not_exist(in_path, 'figure');

% Load the wpli struct
data = load(in_filename);
result_wpli = data.result_wpli;

%% Make the figures for whole brain

% Plot the average wPLI matrix
out_avg_figure = strcat(out_figure_path,filesep, ppt,'_',state,'_avg_wpli.fig');
avg_wpli = result_wpli.data.avg_wpli;
title_name = strcat(ppt,' ',state,' Average wPLI');
label_names = '';
color = 'jet';
isInterpolation = 0;
plot_wpli(avg_wpli, title_name, label_names, color, isInterpolation)


% Aggregate statistic over the whole wPLI matrices (mean and std)
out_stat_figure = strcat(out_figure_path, filesep, ppt,'_',state,'_stat_wpli.fig');
mean_wpli = mean(result_wpli.data.wpli,3);
std_wpli = std(result_wpli.data.wpli,1,3);

figure
subplot(2,1,1)
plot(mean_wpli)
title(strcat(ppt,' ', state, ' Global wPLI over time'))
subplot(2,1,2)
plot(std_wpli)
title(strcat(ppt,' ', state, ' Standard Deviation of Global wPLI over time'))

% Generate a video of the whole wPLI matrices over time
out_video = strcat(out_figure_path, filesep, ppt, '_', state, '_wpli');
make_video_functional_connectivity(out_video, result_wpli.data.wpli, .1)

%% Separate the 