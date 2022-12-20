function [omi, theta] = changeOrbitalPlane_mod_rel(i_f, OMf, omf, i_i, OMi)

DeltaOM = OMf - OMi;

alpha = acos( cos(i_i) * cos(i_f) + sin(i_i) * sin(i_f) * cos(DeltaOM) );
sin_ui = sin(DeltaOM) / sin(alpha) * sin(i_f);
sin_uf = sin(DeltaOM) / sin(alpha) * sin(i_i);

cos_ui = (cos(i_f) - cos(alpha) * cos(i_i)) / (sin(alpha) * sin(i_i));
cos_uf = (-cos(i_i) + cos(alpha) * cos(i_f)) / (sin(alpha) * sin(i_f));
ui = atan2(sin_ui, cos_ui);
uf = atan2(sin_uf, cos_uf);
theta1 = 2*pi - uf - omf;
omi = 2*pi - ui - theta1;

if theta1 < 0
    theta1 = theta1 + pi;
elseif theta1 >= pi
    theta1 = theta1 - pi;
end

theta2 = theta1 + pi;
theta = [theta1; theta2];