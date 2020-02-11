function  [matrix,channels_location] = filter_non_scalp(matrix,channels_location)
% FILTER_NON_SCALP Remove non scalp channels from a given matrix
    
    % Variable definition
    non_scalp_channel_label = {'E127', 'E126', 'E17', 'E128', 'E125', 'E21', 'E25', 'E32', 'E38', 'E44', 'E14', 'E8', 'E1', 'E121', 'E114', 'E43', 'E49', 'E56', 'E63', 'E68', 'E73', 'E81', 'E120', 'E113', 'E107', 'E99', 'E94', 'E88', 'E48', 'E119'};

    % Iterate over each non scalp channel label and check if they exist in
    % the channels_location, if yes remove the record in the matrix and in
    % the channels location
    for i=1:length(non_scalp_channel_label)
        current_label = non_scalp_channel_label{i};
        for j=1:length(channels_location)
           if(strcmp(channels_location(j).labels,current_label))
               channels_location(j) = [];
               matrix(j,:) = [];
               matrix(:,j) = [];
               break;
           end
        end
    end
end

