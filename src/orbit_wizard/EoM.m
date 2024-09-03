function [xdot] = EoM(t,x)

% y is the initial conditions, and time is in seconds
% Set constant values
R_E = 6378/6.878e+03;     % Earth radius (km)
mu = 1;                   % Earth gravitational parameter
J2 = 0.00108263;     % Earth 2nd zonal harmonic coefficient

% Pull out the initial conditions to components 
rx = x(1); %km
ry = x(2); %km
rz = x(3); %km
vx = x(4); %km/s 
vy = x(5); %km/s 
vz = x(6); %km/s
 
% Normalize the position vector for future use
r = norm([rx, ry, rz]);

% Find gravity acceleration from the position vector 
agx = -mu*rx/r^3; %km/s^2
agy = -mu*ry/r^3; %km/s^2
agz = -mu*rz/r^3; %km/s^2

% compute oblateness accerleration here 

adx = -(3*J2*mu*R_E^2*rx)/(2*r^5) * (1-(5*rz^2)/r^2);
ady = -(3*J2*mu*R_E^2*ry)/(2*r^5) * (1-(5*rz^2)/r^2);
adz = -(3*J2*mu*R_E^2*rz)/(2*r^5) * (3-(5*rz^2)/r^2);

% sum up the acceleration due to gravity and oblateness 
ax = agx + adx;
ay = agy + ady;
az = agz + adz;

% Set up new conditions after t seconds
xdot = [vx; vy; vz; ax; ay; az];

end
