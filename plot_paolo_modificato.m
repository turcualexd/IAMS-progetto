function plot_paolo_modificato(x, y, forma, spessore, color)

% prende in input x, y, forma è la forma del puntino

lx = length(x);
ly = length(y);
lf = length(forma);
ls = length(spessore);
lc = length(color);

if lx ~= ly ||ly ~= lf || lx ~= lf ||lx ~= ls ||  lx ~= lc
    error('vettori non validi\n');
    return
end

figure
hold on
grid minor
for i = 1:lx
    plot(x(i), y(i), forma(i), LineWidth= spessore(i), MarkerEdgeColor=color(i));
end
