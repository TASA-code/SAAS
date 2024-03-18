function [] = groundtrack(GEO,colour)
    
    lat = GEO(1);
    lon = GEO(2);
    
    % loads Earth topographic data
    load('topo.mat','topo');
    
    % rearranges Earth topopgrahic data so it goes from -180 to 180 
    % deg longitude
    topoplot = [topo(:,181:360),topo(:,1:180)];
    
    % plots Earth map by making a contour plot of topographic data at
    % elevation of 0
    contour(-180:179,-90:89,topoplot,[0,0],'k');

    scatter(lon,lat,'.',colour);
    
    % axis equal
    grid on
    box on
    ax = gca; 
    ax.GridColor = [0.35,0.35,0.35];
    ax.GridAlpha = 1;
    ax.GridLineStyle = ':';
    pbaspect([4 2 1])
    xlim([-180,180]);
    xticks(-180:30:180);
    ylim([-90,90]);
    yticks(-90:30:90);
    % xlabel('Longitude, $\lambda\;[^{\circ}]$','Interpreter','latex',...
    %     'FontSize',12);
    % ylabel('Latitude, $\phi\;[^{\circ}]$','Interpreter','latex',...
    %     'FontSize',12);




end