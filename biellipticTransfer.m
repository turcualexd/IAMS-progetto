function [DeltaV1, DeltaV2, DeltaV3, Deltat1, Deltat2] = biellipticTransfer(a_i, e_i, a_f, e_f, rat, mu)

% Bitangent transfer for ellipctic orbits
% 
% [DeltaV1, DeltaV2, DeltaV3, Deltat1, Deltat2] = biellipticTransfer(a_i, e_i, a_f, e_f, ra_t, mu)
% 
% -----------------------------------------------------------------------------------
% Input arguments:
% a_i           [1x1]       initial semi-major axis                         [km]
% e_i           [1x1]       initial eccentricity                            [-]
% a_f           [1x1]       final semi-major axis                           [km]
% e_f           [1x1]       final eccentricity                              [-]
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

% t1
rpt1 = a_i * (1 - e_i);
rat1 = rat;

a_t1 = (rpt + rat1)/2;

% t2
rat2 = rat1;
rpt2 = a_f * (1 - e_f);

a_t2 = (rat2 + rpt2)/2;

% velocità
DeltaV1 = sqrt(mu) * ( sqrt( (2/rpt1) - (1/a_t1)) - sqrt(( 2/rpt1) - 1/a_i));
DeltaV2 = sqrt(mu) * ( sqrt( (2/rat2) - (1/a_t2)) - sqrt(( 2/rat1) - 1/a_t1));
DeltaV3 = sqrt(mu) * ( sqrt( (2/rpt2) - (1/a_f)) - sqrt(( 2/rpt2) - 1/a_t2));

% tempi
Deltat1 = pi * (a_t1^3 /mu)^(1/2);
Deltat2 = pi * (a_t2^3 /mu)^(1/2);
