%----------- Chao Huang --------------------
clear; clc;

Re=6378.14; %[km]





w0 = [-6621.949926 -485.079670 -766.522384 -0.009311 -9.175045 -4.536935 5233.5];


%
options = odeset('RelTol',1e-12,'AbsTol',1e-12);
% 'Refine' was used to produce good-looking plots
% default value of Refine was 4. Tolerances were also tightened.
% scalar relative error tolerance 'RelTol' (1e-3 by default) and
% vector of absolute error tolerances 'AbsTol' (all components 1e-6 by
% default).

%figure

%[progate firing propagte2 firing2 ]
time_vec = [1087.5 1166.525 2607.5 2663.405 4475.0 4500.654 5828.833 5856.729 6631.5 6645.661 (7645.661+24*60)]; %time vector [min]
%------GTO t=0 ---------------------
sample_qty = (time_vec(1)-0)*2;     %every minute
time_info = linspace(0,time_vec(1)*60,sample_qty);

[t1,y1] = ode45(@eq_propagate,time_info,w0,options); %J2   


%------1 firing   -----------------
declination = -22.3*pi/180;
ap_pe = 0; % apogee =0 perigee=1

sample_qty = (time_vec(2)-time_vec(1))*2;     %every minute
time_info = linspace(0,(time_vec(2)-time_vec(1))*60,sample_qty);
l_v=length(t1); %last value
[tf1,yf1] = ode45(@eq_firing_lae,time_info,y1(l_v,:),options,declination,ap_pe);  %Firing
%------- propagate -----------
sample_qty = (time_vec(3)-time_vec(2))*2;     %every minute
time_info = linspace(0,(time_vec(3)-time_vec(2))*60,sample_qty);
l_v=length(tf1); %last value
[t2,y2] = ode45(@eq_propagate,time_info,yf1(l_v,:),options);  %J2

%-------2 firing -------------
declination = -22.75*pi/180;
ap_pe = 0; % apogee =0 perigee=1

sample_qty = (time_vec(4)-time_vec(3))*2;     %every minute
time_info = linspace(0,(time_vec(4)-time_vec(3))*60,sample_qty);
l_v=length(t2); %last value
[tf2,yf2] = ode45(@eq_firing_lae,time_info,y2(l_v,:),options,declination,ap_pe);  %Firing
%-------propagate-------------
sample_qty = (time_vec(5)-time_vec(4))*2;     %every minute
time_info = linspace(0,(time_vec(5)-time_vec(4))*60,sample_qty);
l_v=length(tf2); %last value
[t3,y3] = ode45(@eq_propagate,time_info,yf2(l_v,:),options);  %J2

%-------3 firing -------------

declination = -22.75*pi/180;
ap_pe = 0; % apogee =0 perigee=1

sample_qty = (time_vec(6)-time_vec(5))*2;     %every minute
time_info = linspace(0,(time_vec(6)-time_vec(5))*60,sample_qty);
l_v=length(t3); %last value
[tf3,yf3] = ode45(@eq_firing_lae,time_info,y3(l_v,:),options,declination,ap_pe);  %Firing
%-------propagate-------------
sample_qty = (time_vec(7)-time_vec(6))*2;     %every minute
time_info = linspace(0,(time_vec(7)-time_vec(6))*60,sample_qty);
l_v=length(tf3); %last value
[t4,y4] = ode45(@eq_propagate,time_info,yf3(l_v,:),options);  %J2


%-------4 firing -------------

declination = -22.6*pi/180;
ap_pe = 0; % apogee =0 perigee=1

sample_qty = (time_vec(8)-time_vec(7))*2;     %every minute
time_info = linspace(0,(time_vec(8)-time_vec(7))*60,sample_qty);
l_v=length(t4); %last value
[tf4,yf4] = ode45(@eq_firing_lae,time_info,y4(l_v,:),options,declination,ap_pe);  %Firing
%-------propagate-------------
sample_qty = (time_vec(9)-time_vec(8))*2;     %every minute
time_info = linspace(0,(time_vec(9)-time_vec(8))*60,sample_qty);
l_v=length(tf4); %last value
[t5,y5] = ode45(@eq_propagate,time_info,yf4(l_v,:),options);  %J2


%-------5 firing -------------

declination = 0*pi/180;
ap_pe = 0; % apogee =0 perigee=1

sample_qty = (time_vec(10)-time_vec(9))*2;     %every minute
time_info = linspace(0,(time_vec(10)-time_vec(9))*60,sample_qty);
l_v=length(t5); %last value
[tf5,yf5] = ode45(@eq_firing_lae,time_info,y5(l_v,:),options,declination,ap_pe);  %Firing
%-------propagate-------------
sample_qty = (time_vec(11)-time_vec(10))*2;     %every minute
time_info = linspace(0,(time_vec(11)-time_vec(10))*60,sample_qty);
l_v=length(tf5); %last value
[t6,y6] = ode45(@eq_propagate,time_info,yf5(l_v,:),options);  %J2


% wu=length(t1)
% [ela, elb]=size(y1)
%  
% for puntos=1:elb
%      pun(puntos,1)=y1(wu,puntos);
% end
% pun


%-------------Ploting---------


% ColorSet = [
% 	0.00  0.00  1.00
%     1.00  0.00  0.00 
% 	0.00  0.50  0.00 
% 	0.00  0.75  0.75
% 	0.75  0.00  0.75
% 	0.75  0.75  0.00 
% 	0.25  0.25  0.25
% 	0.75  0.25  0.25
% 	0.95  0.95  0.00 
% 	0.25  0.25  0.75
% 	0.75  0.75  0.75
% 	0.00  1.00  0.00 
% 	0.76  0.57  0.17
% 	0.54  0.63  0.22
% 	0.34  0.57  0.92
% 	1.00  0.10  0.60
% 	0.88  0.75  0.73
% 	0.10  0.49  0.47
% 	0.66  0.34  0.65
% 	0.99  0.41  0.23
% ];
% 
% set(0,'DefaultAxesColorOrder',ColorSet); %set to all




%set(gca, 'ColorOrder', ColorSet);
% figure
% hold all;
% for m = 1:50
%   plot([0 51-m], [0 m]);
% end
% 
% 


%%
%---------------------Ploting X Y Z------------------
close all;
figure;
hold on;
hold all; % no reset color order
[earth_x,earth_y,earth_z] = sphere;
%surf (earth_x*Re,earth_y*Re,earth_z*Re)
mesh (earth_x*Re,earth_y*Re,earth_z*Re);
%plot3 (earth_x*Re,earth_y*Re,earth_z*Re)

%plot3(0,0,0,'-*')




% Create the lines before the loop
% Create the first line with "dummy" data that will be overwritten
myLines(1) = plot3(NaN, NaN, NaN,'LineWidth',1);
% So the second PLOT3 call doesn't clear the first line, turn hold on
%hold on
% Create the second line
myLines(2) = plot3(NaN, NaN, NaN, '-r','LineWidth',1);
% From now on, we're not going to call any high-level plotting function
% So we can turn hold back off
%hold off


%np=100; %number of point for each plot
n_time_faster = 1000; % n*realtime to regulate the speed of simulation
%each_point_time_multi = 2; %each point = 30 s

%total time faster = n_time_faster*each_point_time_multi
time_pause = 30/n_time_faster; % each data =30s 
np = 10; %number of point between each graph
grid on;
axis equal;
view(45, 10);
rotate3d on;

tam = length(t1)
% Perform the plotting

%round(linspace(1,tam,))
for k = 1:np:tam % from ode, each data = 30s

    pause(time_pause); 
    set(myLines(1), 'XData', y1(1:k-1,1), 'YData', y1(1:k-1,2), 'ZData', y1(1:k-1,3));
    set(myLines(2), 'Marker','o','XData', y1(k,1), 'YData', y1(k,2), 'ZData', y1(k,3));
 
    drawnow;

   
end



myLines(1) = plot3(NaN, NaN, NaN,'LineWidth',1);
tam = length(yf1)
% Perform the plotting
for k = 1:np:tam % I try to avoid using i as a loop variable
 
    pause(time_pause); 
    set(myLines(1), 'XData', yf1(1:k,1), 'YData', yf1(1:k,2), 'ZData', yf1(1:k,3),'LineWidth',2);
    set(myLines(2), 'Marker','o','XData', yf1(k,1), 'YData', yf1(k,2), 'ZData', yf1(k,3));
    drawnow;
    
end
%plot3(ys1(:,1),ys1(:,2),ys1(:,3),'LineWidth',2);
%plot3(yf1(:,1),yf1(:,2),yf1(:,3),'LineWidth',2);


myLines(1) = plot3(NaN, NaN, NaN,'LineWidth',1);
tam = length(y2)
% Perform the plotting
for k = 1:np:tam % I try to avoid using i as a loop variable
    pause(time_pause);
    set(myLines(1), 'XData', y2(1:k,1), 'YData', y2(1:k,2), 'ZData', y2(1:k,3));
    set(myLines(2), 'Marker','o','XData', y2(k,1), 'YData', y2(k,2), 'ZData', y2(k,3));
    drawnow;
end
%plot3(y2(:,1),y2(:,2),y2(:,3));
%plot3(ys2(:,1),ys2(:,2),ys2(:,3),'LineWidth',2);



myLines(1) = plot3(NaN, NaN, NaN,'LineWidth',1);
tam = length(yf2)
% Perform the plotting
for k = 1:np:tam % I try to avoid using i as a loop variable
 
    pause(time_pause); 
    set(myLines(1), 'XData', yf2(1:k,1), 'YData', yf2(1:k,2), 'ZData', yf2(1:k,3),'LineWidth',2);
    set(myLines(2), 'Marker','o','XData', yf2(k,1), 'YData', yf2(k,2), 'ZData', yf2(k,3));
    drawnow;
    
end
%plot3(yf2(:,1),yf2(:,2),yf2(:,3),'LineWidth',2);


myLines(1) = plot3(NaN, NaN, NaN,'LineWidth',1);
tam = length(y3)
% Perform the plotting
for k = 1:np:tam % I try to avoid using i as a loop variable
    pause(time_pause);
    set(myLines(1), 'XData', y3(1:k,1), 'YData', y3(1:k,2), 'ZData', y3(1:k,3));
    set(myLines(2), 'Marker','o','XData', y3(k,1), 'YData', y3(k,2), 'ZData', y3(k,3));
    drawnow;
end
%plot3(y3(:,1),y3(:,2),y3(:,3));


myLines(1) = plot3(NaN, NaN, NaN,'LineWidth',1);
tam = length(yf3)
% Perform the plotting
for k = 1:np:tam % I try to avoid using i as a loop variable
 
    pause(time_pause); 
    set(myLines(1), 'XData', yf3(1:k,1), 'YData', yf3(1:k,2), 'ZData', yf3(1:k,3),'LineWidth',2);
    set(myLines(2), 'Marker','o','XData', yf3(k,1), 'YData', yf3(k,2), 'ZData', yf3(k,3));
    drawnow;
    
end
%plot3(yf3(:,1),yf3(:,2),yf3(:,3),'LineWidth',2);



myLines(1) = plot3(NaN, NaN, NaN,'LineWidth',1);
tam = length(y4)
% Perform the plotting
for k = 1:np:tam % I try to avoid using i as a loop variable
    pause(time_pause);
    set(myLines(1), 'XData', y4(1:k,1), 'YData', y4(1:k,2), 'ZData', y4(1:k,3));
    set(myLines(2), 'Marker','o','XData', y4(k,1), 'YData', y4(k,2), 'ZData', y4(k,3));
    drawnow;
end
%plot3(y4(:,1),y4(:,2),y4(:,3));
%plot3(ys4(:,1),ys4(:,2),ys4(:,3),'LineWidth',2);


myLines(1) = plot3(NaN, NaN, NaN,'LineWidth',1);
tam = length(yf4)
% Perform the plotting
for k = 1:np:tam % I try to avoid using i as a loop variable
 
    pause(time_pause); 
    set(myLines(1), 'XData', yf4(1:k,1), 'YData', yf4(1:k,2), 'ZData', yf4(1:k,3),'LineWidth',2);
    set(myLines(2), 'Marker','o','XData', yf4(k,1), 'YData', yf4(k,2), 'ZData', yf4(k,3));
    drawnow;
    
end

%plot3(yf4(:,1),yf4(:,2),yf4(:,3),'LineWidth',2);


myLines(1) = plot3(NaN, NaN, NaN,'LineWidth',1);
tam = length(y5)
% Perform the plotting
for k = 1:np:tam % I try to avoid using i as a loop variable
    pause(time_pause);
    set(myLines(1), 'XData', y5(1:k,1), 'YData', y5(1:k,2), 'ZData', y5(1:k,3));
    set(myLines(2), 'Marker','o','XData', y5(k,1), 'YData', y5(k,2), 'ZData', y5(k,3));
    drawnow;
end
%plot3(y5(:,1),y5(:,2),y5(:,3));
%plot3(ys5(:,1),ys5(:,2),ys5(:,3),'LineWidth',2);



myLines(1) = plot3(NaN, NaN, NaN,'LineWidth',1);
tam = length(yf5)
% Perform the plotting
for k = 1:np:tam % I try to avoid using i as a loop variable
 
    pause(time_pause); 
    set(myLines(1), 'XData', yf5(1:k,1), 'YData', yf5(1:k,2), 'ZData', yf5(1:k,3),'LineWidth',2);
    set(myLines(2), 'Marker','o','XData', yf5(k,1), 'YData', yf5(k,2), 'ZData', yf5(k,3));
    drawnow;
    
end
%plot3(yf5(:,1),yf5(:,2),yf5(:,3),'LineWidth',2);

myLines(1) = plot3(NaN, NaN, NaN,'LineWidth',1);
tam = length(y6)
% Perform the plotting
for k = 1:np:tam % I try to avoid using i as a loop variable
    pause(time_pause);
    set(myLines(1), 'XData', y6(1:k,1), 'YData', y6(1:k,2), 'ZData', y6(1:k,3));
    set(myLines(2), 'Marker','o','XData', y6(k,1), 'YData', y6(k,2), 'ZData', y6(k,3));
    drawnow;
end

