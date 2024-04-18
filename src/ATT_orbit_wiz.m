%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SAAS ATT_orbit_wiz.m
%
%   Cooper Chang Chien
%
%   Input:
%     @param sim      :  (struct)  Simulation setups
%     @param model    :  (struct)  Model parameters
%
%
%   Output:
%     Simulate satellite orbit based on sim.orbit.OE 
%
%
%   Copyright (C) System Engineering (SE), TASA - All Rights Reserved
%
%   This code is provided under the MIT License.
%
%   Written by Cooper Chang Chien <cooper@tasa.org.tw>, April 2024.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [] = ATT_orbit_wiz(sim, model)
    

    fprintf('Simulation Propagating...\n')
    mu_E = 3.986004418e14;     % Earth gravitational parameter (m^3/s^2)    
    

    %% PRE-STEP #1:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Parameter setup and undimensionlise
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [r_ECI, v_ECI] = OE2ECI(sim.orbit.OE);
    
    % undimensionalise
    DU = norm(r_ECI);
    TU = sqrt(DU^3/mu_E);
    
    r_undim = r_ECI/DU;
    v_undim = v_ECI/(DU/TU);
    x0 = [r_undim' v_undim'];
    

    %% MAIN:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Orbit propagate using ode45
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % undimensionlise with TU
    tspan = sim.orbit.tspan/TU;
    tol = odeset('RelTol',1e-8,'AbsTol',1e-8);
    [t,x] = ode45(@EoM,tspan,x0,tol);
    
    r = [x(:,1), x(:,2), x(:,3)] * DU;
    v = [x(:,4), x(:,5), x(:,6)] * DU/TU;
    t = t * TU;


    %% POST ANALYSIS:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Coordinate transform:
    %  1. ECI  --> ECEF
    %  2. ECEF --> LLA
    %
    %  Plot Result, function called (orbit_plot)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    epoch = model.lla_date(1);
    [r_ecef, ~] = ECI2ECEF(epoch, t, r, v);

    lla = ecef2lla(r_ecef, 'WGS84');

    orbit_plot(r, r_ecef, lla) 

end





