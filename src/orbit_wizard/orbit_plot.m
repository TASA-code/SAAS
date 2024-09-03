function orbit_plot(r, r_ecef, lla) 

    % Plot Orbit around earth
    figure
    subplot(2,2,1)
    plot3(r(:,1), r(:,2), r(:,3),'LineWidth',2,'color','r')
    hold on
    plot_globe();
    grid on
    axis equal

    subplot(2,2,2)
    plot3(r_ecef(:,1), r_ecef(:,2), r_ecef(:,3),'LineWidth',2,'color','r')
    hold on
    text(r_ecef(1,1), r_ecef(1,2), r_ecef(1,3),'Start','FontWeight','bold')
    text(r_ecef(end,1), r_ecef(end,2), r_ecef(end,3),'End','FontWeight','bold')
    plot_globe();
    grid on
    hold off
    axis equal


    subplot(2,2,3:4)
    
    % loads Earth topographic data
    load('topo.mat','topo');
    
    % rearranges Earth topopgrahic data so it goes from -180 to 180 
    topoplot = [topo(:,181:360),topo(:,1:180)];
    
    % plots Earth map by making a contour plot of topographic data at
    contour(-180:179,-90:89,topoplot,[0,0],'k');
    hold on
    scatter(lla(:,2),lla(:,1),'.', 'color','r');
    
    grid on
    box on
    ax = gca; 
    ax.GridColor = [0.35,0.35,0.35];
    ax.GridLineStyle = ':';
    pbaspect([2 1 1])
    axis([-180 180 -90 90]);
    xticks(-180:30:180);
    yticks(-90:30:90);

end