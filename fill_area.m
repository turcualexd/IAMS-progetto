function h = fill_area(x,y,r, colour, alpha)

th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = fill(xunit, yunit, colour, 'FaceAlpha', alpha);
