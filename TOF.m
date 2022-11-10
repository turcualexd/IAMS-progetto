function deltat = TOF(a, e, th1, th2, mu)

% Time of flight
% 
% deltat = TOF(a, e, th1, th2, mu)
% 
% -----------------------------------------------------------------------------------
% Input arguments:
% a             [1x1]       semi-major axis                                 [km]
% e             [1x1]       eccentricity                                    [-]
% th1           [1x1]       initial true anomaly                            [rad]
% th2           [1x1]       final true anomaly                              [rad]
% mu            [1x1]       gravitational parameter                         [km^3/s^2]
% 
% -----------------------------------------------------------------------------------
% Output arguments:
%
% deltat        [1x1]       time of flight                                  [s]
% 
% -----------------------------------------------------------------------------------

% If mu is not assigned, the default value is set to Earth
if nargin == 4
    mu = 3.986e5;
end

E1 = 2*atan(sqrt((1-e)/(1+e))*tan(th1/2))
E2 = 2*atan(sqrt((1-e)/(1+e))*tan(th2/2))

n = sqrt(mu/(a^3));

t1 = (E1 - e * sin(E1))/n
t2 = (E2 - e * sin(E2))/n

deltat = t2 - t1;

T = 2*pi*sqrt(a^3/mu);

if th2 < th1
    deltat = deltat + T;
end

