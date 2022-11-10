clear, clc, close all

a = 7470.96;
e = 0.120449;
i_i = 0;
OMi = pi / 4;
omi = deg2rad(30.013);
i_f = pi / 6;
OMf = pi / 3;

[DeltaV, omf, theta] = changeOrbitalPlane(a, e, i_i, OMi, omi, i_f, OMf)