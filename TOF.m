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

E1 = 2 .* atan(sqrt((1 - e) ./ (1 + e)) .* tan(th1 ./ 2));
E2 = 2 .* atan(sqrt((1 - e) ./ (1 + e)) .* tan(th2 ./ 2));

for k = 1:length(a)
    if E1(k) < 0
        E1(k) = E1(k) + 2*pi;
    end
    
    if E2(k) < 0
        E2(k) = E2(k) + 2*pi;
    end
end

n = sqrt(mu ./ a.^3);

t1 = (E1 - e .* sin(E1)) ./ n;
t2 = (E2 - e .* sin(E2)) ./ n;

T = 2 * pi * sqrt(a.^3 / mu);

deltat = nan(1, length(a));
for k = 1:length(a)
    if t1(k) > t2(k)
        deltat(k) = T(k) - t1(k) + t2(k);
    else 
        deltat(k) = t2(k) - t1(k);
    end
end