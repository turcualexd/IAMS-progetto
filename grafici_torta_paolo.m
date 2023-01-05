% strategia standard
close all
clear

st = [(0.5863+0.1642) 5.1840 0.7105];
% labels = {'Manovra Bitangente PA', 'Cambio piano', 'Cambio argomento del pericentro'};
explode = [1,0,1];
pie3(st, explode);
