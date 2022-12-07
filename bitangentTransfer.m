function [DeltaV1, DeltaV2, Deltat, om_f_new, om_t, a_t, e_t] = bitangentTransfer(a_i, e_i, a_f, e_f, type, om_i,  mu)

% Bitangent transfer for ellipctic orbits
% 
% [DeltaV1, DeltaV2, Deltat] = bitangentTransfer(a_i, e_i, a_f, e_f, type, mu)
% 
% -----------------------------------------------------------------------------------
% Input arguments:
% ai            [1x1]       initial semi-major axis                         [km]
% ei            [1x1]       initial eccentricity                            [-]
% af            [1x1]       final semi-major axis                           [km]
% ef            [1x1]       final eccentricity                              [-]
% type          [char]      maneuver type                                   [-]
% om_i          [1x1]       initial pericenter anomaly                      [rad]
% mu            [1x1]       gravitational parameter                         [km^3/s^2]
% 
% -----------------------------------------------------------------------------------
% Output arguments:
%
% DeltaV1       [1x1]       1st maneuvre impulse                            [km/s]
% DeltaV2       [1x1]       2nd maneuvre impulse                            [km/s]
% Deltat        [1x1]       maneuvre time                                   [s]
% om_f_new      [1x1]       new final pericenter anomaly                    [rad]
% om_t          [1x1]       transfer pericenter anomaly                     [rad]
% -----------------------------------------------------------------------------------

% If mu is not assigned, the default value is set to Earth
if nargin == 6
    mu = 3.986e5;
end

% Setting the new pericenter anomaly as the one of the initial orbit, it may
% changes during che manuevre 

om_f_new = om_i;
om_t = om_i;

% Dependening on the maneuvre selected, defines the transfer orbit

switch type

    case 'pa' 

        rpi = a_i * (1 - e_i);
        raf = a_f * (1 + e_f);

        if rpi < raf
            rpt = rpi;
            rat = raf;  
        else
            rat = rpi;
            rpt = raf;
            om_t = om_i + pi;
        end
        
        a_t = (rpt + rat)/2;
        e_t = abs(rat - rpt)/(rat + rpt);

        DeltaV1 = sqrt(mu) * ( sqrt( (2/rpt) - (1/a_t)) - sqrt(( 2/rpi) - 1/a_i));
        DeltaV2 = sqrt(mu) * ( sqrt( (2/raf) - (1/a_f)) - sqrt(( 2/rat) - 1/a_t));

    case 'ap'

        rai = a_i * (1 + e_i);
        rpf = a_f * (1 - e_f);

        if rpf < rai
            rpt = rpf;
            rat = rai;  
        else
            rat = rpf;
            rpt = rai;
            om_t = om_i + pi;
        end
        
        a_t = (rat + rpt)/2;
        e_t = abs(rat-rpt)/(rat+rpt);
        DeltaV1 = sqrt(mu) * ( sqrt( (2/rat) - (1/a_t)) - sqrt(( 2/rai) - 1/a_i));
        DeltaV2 = sqrt(mu) * ( sqrt( (2/rpf) - (1/a_f)) - sqrt(( 2/rpt) - 1/a_t));

    case 'pp'

        rpi = a_i * (1 - e_i);
        rpf = a_f * (1 - e_f);

        if rpf < rpi
            rpt = rpf;
            rat = rpi; 
            om_t = om_i + pi;
        else
            rat = rpf;
            rpt = rpi;
           
        end

        a_t = (rat + rpt)/2;
        e_t = abs(rat-rpt)/(rat+rpt);
        DeltaV1 = sqrt(mu) * ( sqrt( (2/rpt) - (1/a_t)) - sqrt(( 2/rpi) - 1/a_i));
        DeltaV2 = sqrt(mu) * ( sqrt( (2/rpf) - (1/a_f)) - sqrt(( 2/rat) - 1/a_t));

        om_f_new = om_i + pi;

    case 'aa'

        rai = a_i * ( 1 + e_i);
        raf = a_f * ( 1 + e_f);

        if rai < raf
            rpt = rai;
            rat = raf;
            om_t = om_i + pi;
        else
            rpt = raf;
            rat = rai;
        end     
        
        a_t = (rat + rpt)/2;
        e_t = abs(rat-rpt)/(rat+rpt);
        DeltaV1 = sqrt(mu) * ( sqrt( (2/rpt) - (1/a_t)) - sqrt(( 2/rai) - 1/a_i));
        DeltaV2 = sqrt(mu) * ( sqrt( (2/raf) - (1/a_f)) - sqrt(( 2/rat) - 1/a_t));
        
        om_f_new = om_i + pi;
end 

Deltat = pi * (a_t^3 /mu)^(1/2);

end










        


