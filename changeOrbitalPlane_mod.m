function [omf, theta] = changeOrbitalPlane_mod(i_i, OMi, omi, i_f, OMf)

% Change of Plane maneuver
% 
% [omf, theta] = changeOrbitalPlane(i_i, OMi, omi, i_f, OMf)
% 
% --------------------------------------------------------------------------------------------
% Input arguments:
% i_i           [1x1]       initial inclination                                     [rad]
% OMi           [1x1]       initial RAAN (Right Ascension of the Ascending Node)    [rad]
% omi           [1x1]       initial pericenter anomaly                              [rad]
% i_f           [1x1]       final inclination                                       [rad]
% OMf           [1x1]       final RAAN (Right Ascension of the Ascending Node)      [rad]
% 
% --------------------------------------------------------------------------------------------
% Output arguments:
% omf           [1x1]       final pericenter anomaly                                [rad]
% theta         [2x1]       true anomaly at maneuver (both intersections)           [rad]
% 
% --------------------------------------------------------------------------------------------

DeltaOM = OMf - OMi;
Deltai = i_f - i_i;

if Deltai == 0
    error("The variation of inclination is zero")

elseif DeltaOM == 0
    omf = omi;
    theta1 = 2*pi - omf;

elseif i_i == 0
    omf = omi - OMf;
    theta1 = 2*pi - omf;

elseif i_f == 0
    omf = omi + OMi;
    theta1 = 2*pi - omi;

elseif i_i == pi
    omf = omi - OMf;
    theta1 = 2*pi - omf;

elseif i_f == pi
    omf = omi + OMi;
    theta1 = 2*pi - omi;

else
    alpha = acos( cos(i_i) * cos(i_f) + sin(i_i) * sin(i_f) * cos(abs(DeltaOM)) );
    sin_ui = sin(abs(DeltaOM)) / sin(alpha) * sin(i_f);
    sin_uf = sin(abs(DeltaOM)) / sin(alpha) * sin(i_i);

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