function [DeltaV, omf, theta] = changeOrbitalPlane(a, e, i_i, OMi, omi, i_f, OMf, mu)

% Change of Plane maneuver
% 
% [DeltaV, omf, theta] = changeOrbitalPlane(a, e, i_i, OMi, omi, i_f, OMf, mu)
% 
% --------------------------------------------------------------------------------------------
% Input arguments:
% a             [1x1]       semi-major axis                                         [km]
% e             [1x1]       eccentricity                                            [-]
% i_i           [1x1]       initial inclination                                     [rad]
% OMi           [1x1]       initial RAAN (Right Ascension of the Ascending Node)    [rad]
% omi           [1x1]       initial pericenter anomaly                              [rad]
% i_f           [1x1]       final inclination                                       [rad]
% OMf           [1x1]       final RAAN (Right Ascension of the Ascending Node)      [rad]
% mu            [1x1]       gravitational parameter                                 [km^3/s^2]
% 
% --------------------------------------------------------------------------------------------
% Output arguments:
% DeltaV        [2x1]       maneuver impulse (both intersections)                   [km]
% omf           [1x1]       final pericenter anomaly                                [rad]
% theta         [2x1]       true anomaly at maneuver (both intersections)           [rad]
% 
% --------------------------------------------------------------------------------------------

% If mu is not assigned, the default value is set to Earth
if nargin == 7
    mu = 3.986 * 10^5;
end

DeltaOM = OMf - OMi;
Deltai = i_f - i_i;

if Deltai == 0
    error("The variation of inclination is zero")

elseif DeltaOM == 0
    alpha = Deltai;
    omf = omi;
    theta1 = 2*pi - omf;

else
    alpha = acos( cos(i_i) * cos(i_f) + sin(i_i) * sin(i_f) * cos(DeltaOM) );
    sin_ui = sin(DeltaOM) / sin(alpha) * sin(i_f);
    sin_uf = sin(DeltaOM) / sin(alpha) * sin(i_i);

    if DeltaOM > 0 && Deltai > 0
        cos_ui = (-cos(i_f) + cos(alpha) * cos(i_i)) / (sin(alpha) * sin(i_i));
        cos_uf = (cos(i_i) - cos(alpha) * cos(i_f)) / (sin(alpha) * sin(i_f));
        ui = atan2(sin_ui, cos_ui);
        uf = atan2(sin_uf, cos_uf);
        theta1 = ui - omi;
        omf = uf - theta1;

        elseif DeltaOM > 0 && Deltai < 0
            cos_ui = (cos(i_f) - cos(alpha) * cos(i_i)) / (sin(alpha) * sin(i_i));
            cos_uf = (-cos(i_i) + cos(alpha) * cos(i_f)) / (sin(alpha) * sin(i_f));
            ui = atan2(sin_ui, cos_ui);
            uf = atan2(sin_uf, cos_uf);
            theta1 = 2*pi - ui - omi;
            omf = 2*pi - uf - theta1;

        elseif DeltaOM < 0 && Deltai > 0
            cos_ui = (-cos(i_f) + cos(alpha) * cos(i_i)) / (sin(alpha) * sin(i_i));
            cos_uf = (cos(i_i) - cos(alpha) * cos(i_f)) / (sin(alpha) * sin(i_f));
            ui = atan2(sin_ui, cos_ui);
            uf = atan2(sin_uf, cos_uf);
            theta1 = 2*pi - ui - omi;
            omf = 2*pi - uf - theta1;
            
        elseif DeltaOM < 0 && Deltai < 0
            cos_ui = (cos(i_f) - cos(alpha) * cos(i_i)) / (sin(alpha) * sin(i_i));
            cos_uf = (-cos(i_i) + cos(alpha) * cos(i_f)) / (sin(alpha) * sin(i_f));
            ui = atan2(sin_ui, cos_ui);
            uf = atan2(sin_uf, cos_uf);
            theta1 = ui - omi;
            omf = uf - theta1;

    end
end

if theta1 < 0
    theta1 = theta1 + pi;
elseif theta1 >= pi
    theta1 = theta1 - pi;
end

theta2 = theta1 + pi;
theta = [theta1; theta2];

p = a * (1 - e^2);

V_theta = sqrt(mu / p) * (1 + e * cos(theta));
DeltaV = 2 * V_theta * sin(alpha / 2);