%Danielle Nadin 11-12-2019
%Sweep through range of network thresholds and compute binary small-worldness to determine 
% the 'small-world regime range' as defined in Basset et al (2008). 

% modified by Yacine Mahdid 2019-12-12
%
% Experiment Variables

filename = 'MDFA17_BASELINE.set';
filepath = 'C:\Users\biapt\Desktop\motif fix\mdfa17_data';
recording = load_set(filename, filepath);

% wPLI Properties
frequency_band = [8 13]; % This is in Hz
window_size = 10; % This is in seconds and will be how we chunk the whole dataset
number_surrogate = 20; % Number of surrogate wPLI to create
p_value = 0.05; % the p value to make our test on
step_size = window_size;
result_wpli = na_wpli(recording, frequency_band, window_size, step_size, number_surrogate, p_value);

% Network Properties Parameters

pli_matrix = result_wpli.data.avg_wpli;
threshold_range = 0.01:0.01:0.60; %range of thresholds to sweep

number_random_network = 10;

%loop through thresholds
for j = 1:length(threshold_range) 
    current_threshold = threshold_range(j);
    disp(strcat("Doing the threshold : ", string(current_threshold)));
    
    % Thresholding and binarization using the current threshold
    t_network = threshold_matrix(pli_matrix, current_threshold);
    b_network = binarize_matrix(t_network);
    
    % Find average path length
    [b_lambda,geff,~,~,~] = charpath(distance_bin(b_network),0,0);

    % Find clustering coefficient
    clustering_coef = clustering_coef_bu(b_network);
    
    
    % Calculate the null network parameters
    random_networks = zeros(number_random_network,length(pli_matrix),length(pli_matrix));
    parfor r = 1:number_random_network
        disp(strcat("Random network #",string(r)));
        [random_networks(r,:,:),~] = randmio_und(b_network,10);    % generate random matrix
    end

    % Find properties for `number_random_network` random network
    total_random_lambda = 0;
    total_random_clustering_coef = 0;
    for r = 1:number_random_network
        % Create the random network based on the pli matrix instead of the
        % binary network
        random_b_network = squeeze(random_networks(r,:,:));
        
        [rlambda,rgeff,~,~,~] = charpath(distance_bin(random_b_network),0,0);   % charpath for random network
        random_clustering_coef = clustering_coef_bu(random_b_network); % cc for random network

        total_random_lambda = total_random_lambda + rlambda;
        total_random_clustering_coef = total_random_clustering_coef + nanmean(random_clustering_coef);
    end

    rlambda = total_random_lambda/number_random_network;
    global_random_clustering_coef = total_random_clustering_coef/number_random_network;

    binary_clustering(j) = nanmean(clustering_coef) / global_random_clustering_coef; % normalized clustering coefficient
    binary_charpath(j) = b_lambda / rlambda;  % normalized path length
    bsw(j) = binary_clustering(j)/binary_charpath(j); 
end

figure
plot(threshold_range, bsw)
title("MDFA17 Average wPLI Binary Small Worldness with 1% increment");
xlabel('Network threshold (%)')
ylabel('Binary small-worldness')