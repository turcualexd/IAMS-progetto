function [DeltaV, thi, thf] = changePericenterArg(a, e, omi, omf, mu)

% Change of Pericenter Argument maneuver
% 
% [DeltaV, thetai, thetaf] = changePericenterArg(a, e, omi, omf, mu)
% 
% -----------------------------------------------------------------------------------
% Input arguments:
% a             [1x1]       semi-major axis                                 [km]
% e             [1x1]       eccentricity                                    [-]
% omi           [1x1]       initial pericenter anomaly                      [rad]
% omf           [1x1]       final pericenter anomaly                        [rad]
% mu            [1x1]       gravitational parameter                         [km^3/s^2]
% 
% -----------------------------------------------------------------------------------
% Output arguments:
% DeltaV        [1x1]       maneuver impulse                                [km/s]
% thi           [2x1]       initial true anomalies                          [rad]
% thf           [2x1]       final true anomalies                            [rad] 
%
% -----------------------------------------------------------------------------------


% If mu is not assigned, the default value is set to Earth
if nargin == 4
    mu = 3.986 * 10^5;
end

% initial and final true anomalies

delta_om = omf - omi;
if delta_om < 0 
    delta_om = 2*pi - delta_om;
end

thi = [(delta_om/2) pi+(delta_om/2)];
thf = [2*pi-(delta_om/2) pi-(delta_om/2)];

% maneuver impulse
p = a * (1- e^2);
v_r = sqrt(mu/p) * e * sin(delta_om/2);

DeltaV = 2*v_r;

