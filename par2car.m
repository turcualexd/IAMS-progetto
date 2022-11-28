function [rr, vv] = par2car(a, e, i, OM, om, th, unit, mu)

% Trasformation from Keplerian parameters to cartesian coordinates
% 
% [rr, vv] = par2car(a, e, i, OM, om, th, unit, mu)
% 
% -----------------------------------------------------------------------------------
% Input arguments:
% a             [1x1]       semi-major axis                                 [km]
% e             [1x1]       eccentricity                                    [-]
% i             [1x1]       inclination                                     [rad/deg]
% OM            [1x1]       RAAN (Right Ascension of the Ascending Node)    [rad/deg]
% om            [1x1]       pericenter anomaly                              [rad/deg]
% th            [1x1]       true anomaly                                    [rad/deg]
% unit          [string]    unit of measure of angles ("rad" or "deg")      [-]
% mu            [1x1]       gravitational parameter                         [km^3/s^2]
% 
% -----------------------------------------------------------------------------------
% Output arguments:
% rr            [3x1]       position vector                                 [km]
% vv            [3x1]       velocity vector                                 [km/s]
% 
% -----------------------------------------------------------------------------------

% If mu is not assigned, the default value is set to Earth
switch nargin
    case 6
        unit = "rad";
        mu = 3.986 * 10^5;
    case 7
        mu = 3.986 * 10^5;
end

% If angles are in degrees, converts in radians
if unit == "deg"
    i = deg2rad(i);
    OM = deg2rad(OM);
    om = deg2rad(om);
    th = deg2rad(th);
end

% -------------------------------------------------------------

% Rotation matrixes

R_OM =  [ cos(OM),    sin(OM),    0;
          -sin(OM),   cos(OM),    0;
          0,          0,          1 ];

R_i =   [ 1,          0,          0;
          0,          cos(i),     sin(i);
          0,          -sin(i),    cos(i) ];

R_om =  [ cos(om),    sin(om),    0;
          -sin(om),   cos(om),    0;
          0,          0,          1 ];

T = ( R_om * R_i * R_OM )';

% -------------------------------------------------------------

% Finds rr and vv given the input parameters

p = a * (1 - e^2);
r_norm = p / ( 1 + e * cos(th) );

rr_tilde = r_norm * [ cos(th), sin(th), 0 ]';
rr = T * rr_tilde;

vv_tilde = sqrt(mu / p) * [ -sin(th), e + cos(th), 0 ]';
vv = T * vv_tilde;