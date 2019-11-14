function make_wpli(data,type,labels)
    figure;
    analysis_technique = "Alpha wPLI";
    axe1 = subplot(1,3,1);
    axe_title = strcat(type," ",analysis_technique, " Baseline");
    make_matrix(data.baseline_wpli, axe_title, labels);
    
    axe2 = subplot(1,3,2);
    axe_title = strcat(type," ",analysis_technique, " Hot");
    make_matrix(data.pain_wpli, axe_title, labels);
    
    axe3 = subplot(1,3,3);
    diff_norm_wpli = log(data.baseline_wpli ./ data.pain_wpli);
    axe_title = strcat(type," ",analysis_technique, " Log Ratio (Baseline vs Hot)");
    make_matrix(diff_norm_wpli, axe_title, labels);
    
    % Add in the colorbar
    colormap(axe1,'jet');
    colormap(axe2, 'jet');
    colormap(axe3, 'hot');
end
