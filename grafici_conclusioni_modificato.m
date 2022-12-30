clear
clc
close all

tempi = [17523.1496 14461.7429 17464.4130 21973.3098 18728.5707 28868.3598 15603.0824 14421.7183 32409.9559 8964.9024 28259.7957];
vv = [6.6450 7.1386 7.1222 6.6614 9.0993 9.1511 7.4603 7.4767 6.9762 5.1306 5.3574];
forma = ['o'; 'o'; 'o'; 'o'; 'o'; 'o'; 'o'; 'o'; 'd'; 'd'; 's'];
spessore = [6; 3; 3; 3; 4; 4; 3; 3; 6; 6; 5]; 
color = ["#0000cd"; "#EDB120";"#c0c0c0"; "#d2b48c"; "#ff4500"; "#dc143c"; "#ffc0cb"; "#778899"; "r"; "b"; "#0000cd"];
plot_paolo_modificato(tempi, vv, forma, spessore, color);

ylabel('\DeltaV [km/s]', FontSize=18);
xlabel('Time required [s]', FontSize=18);
vv_min = min(vv);
t_min = min(tempi);

legend('S1: proposed standard', 'S2', 'S3', 'S4', 'S5', 'S6: worst strategy', 'S7', 'S8', 'A1: worst alternative', 'A2: best strategy', 'A3', fontsize=15); 

