function [] = ATT_orbit_wiz(OE, dates)
    
    fprintf('Simulation Propagating...\n')
    
    global orbit;
    % define physical constants
    
    mu_E = 3.986004418e14;     % Earth gravitational parameter (m^3/s^2)    
    
    [r_ECI, v_ECI] = OE2ECI(OE);
    
    % undimensionalise
    DU = norm(r_ECI);
    TU = sqrt(DU^3/mu_E);
    
    r_undim = r_ECI/DU;
    v_undim = v_ECI/(DU/TU);

    
    % define orbital period
    % undimensionlise with TU
    T_0 = 2*pi*sqrt(OE(1)^3/mu_E)/TU;
    tspan = [0 orbit*T_0];
    
    x0 = [r_undim' v_undim'];
    
    tol = odeset('RelTol',1e-8,'AbsTol',1e-8);
    [t,x] = ode45(@EoM,tspan,x0,tol);
    
    r = [x(:,1), x(:,2), x(:,3)] * DU;
    v = [x(:,4), x(:,5), x(:,6)] * DU/TU;


    epoch = datetime(dates, 'InputFormat', 'uuuu-DDD-HH:mm:ss.SSS', 'TimeZone', 'UTC');
    r_ecef = zeros(length(t),3);

    for i = 1:length(t)
        duration_to_add = seconds(t(i)*TU);
        new_datetime = epoch + duration_to_add;
            
        % Convert datetime to UTC
        new_utc = datetime(new_datetime, 'TimeZone', 'UTC', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS');
        [r_ecef(i,:), ~] = eci2ecef(new_utc,r(i,:),v(i,:));
        
    end

    lla = ecef2lla(r_ecef, 'WGS84');

    
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





