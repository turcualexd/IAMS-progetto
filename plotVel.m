function [vr_mat, vth_mat] = plotVel(a, e, th_0, mu)

% la funzione prende in input i parametri di forma dell'orbita, l'anomalia
% vera iniziale dell'orbita e la costante gravitazionale e restituisce i
% vettori velocità e i grafici relativi

if nargin == 2
    th_0 = 0;
end

if nargin == 3
    mu = 3.986e5;
end

th = (0:2*pi/100000:2*pi)';
p = a*(1-e^2);

vr = abs(sqrt(mu/p)*e*sin(th(:)));
vth = abs(sqrt(mu/p)*(1+e*cos(th(:))));
vr_0 = abs(sqrt(mu/p)*e*sin(th_0));
vth_0 = abs(sqrt(mu/p)*(1+e*cos(th_0)));

subplot(1,2,1);
plot(th, vr);
hold on
xlabel("theta [rad]");
ylabel("velocità radiale [km/s]");
plot(th_0, vr_0, 'o');
legend("", "punto iniziale");
grid on
title("velocità radiale");

hold on
subplot(1,2,2);
plot(th, vth);
hold on
xlabel("theta [rad]");
ylabel("velocità tangenziale [km/s]");
plot(th_0, vth_0, 'o');
legend("", "punto iniziale");
grid on

title("velocità tangenziale");

vr_mat = [th,vr];
vth_mat = [th, vth];
