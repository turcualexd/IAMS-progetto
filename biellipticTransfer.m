function [DeltaV1, DeltaV2, DeltaV3, Deltat1, Deltat2] = biellipticTransfer(ai, ei, af, ef, ra_t, mu)

% Bitangent transfer for ellipctic orbits
% 
% [DeltaV1, DeltaV2, DeltaV3, Deltat1, Deltat2] = biellipticTransfer(ai, ei, af, ef, ra_t, mu)
% 
% -----------------------------------------------------------------------------------
% Input arguments:
% ai            [1x1]       initial semi-major axis                         [km]
% ei            [1x1]       initial eccentricity                            [-]
% af            [1x1]       final semi-major axis                           [km]
% ef            [1x1]       final eccentricity                              [-]
% ra_t          [1x1]       transfer orbits apocenter distance              [km]
% mu            [1x1]       gravitational parameter                         [km^3/s^2]
% 
% -----------------------------------------------------------------------------------
% Output arguments:
%
% DeltaV1       [1x1]       1st maneuvre impulse                            [km/s]
% DeltaV2       [1x1]       2nd maneuvre impulse                            [km/s]
% DeltaV3       [1x1]       3nd maneuvre impulse                            [km/s]
% Deltat1       [1x1]       maneuvre time 1                                 [s]
% Deltat2       [1x1]       maneuvre time 2                                 [s]
% 
% -----------------------------------------------------------------------------------

% If mu is not assigned, the default value is set to Earth
if nargin == 5
    mu = 3.986e5;
end


