clear
clc
close all

tempi = [17523.1496 14461.7429 17464.4130 21973.3098 18728.5707 28868.3598 15603.0824 14421.7183 32409.9559 8964.9024 28259.7957];
vv = [6.6450 7.1386 7.1222 6.6614 9.0993 9.1511 7.4603 7.4767 6.9762 5.1306 5.3574];
forma = ['o'; 'o'; 'o'; 'o'; 'o'; 'o'; 's'; 's'; 's'; 's'; 's'];

plot_paolo(tempi, vv, forma, 2);

xlabel('\DeltaV [km/s]');
ylabel('Time required [s]');
vv_min = min(vv);
t_min = min(tempi);

