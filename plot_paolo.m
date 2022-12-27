function plot_paolo(x, y, forma, spessore)

% prende in input x, y, forma è la forma del puntino

lx = length(x);
ly = length(y);
lc = length(forma);

if lx ~= ly ||ly ~= lc || lx ~= lc
    error('vettori non validi\n');
    return
end

figure
hold on
grid minor
for i = 1:lx
    plot(x(i), y(i), forma(i), LineWidth= spessore);
end
