clear variables

% sylvester pantograph
% see sylvester_pantograph.png
% convention is that lower case letters denote scalars and so the order
% does not matter, but upper case letters denote vectors so the order
% determines the direction of the vector.
%
% az=za=10; but tAZ is the orientation of vector AZ and is not the same as 
% tZA. To relate the two, you must use a constraint, for e.g., tAZ=tZA+pi; 
az=10; ab=40; bd=ab; de=40; ef=de;
by=de; ye=bd; yz=54;

% angular speed of the crank or input link
wAZ=2; % rad/s
aAZ=0;
simTime=2*2*pi/wAZ; % multiply by the number of cycles you want to see

% *** Processing ***
% linspace linearly spaces the time into 100 equal sections
t=linspace(0,simTime, 100);
tAZ=wAZ*t; % theta_2

tYZ=pi/4*ones(1,numel(t));

% note that the fourbar_position solves a linkage in the fourbar.png

% (1) R_AZ + R_BA - R_BY - R_YZ = 0
[wBA, ~, wBY, ~, tBA, ~, tBY]=fourbar_velocity(az, ab, by, yz, wAZ, tAZ, 0, tYZ);
tYB=tBY+pi;
tDB=tBA;
wYB=wBY;
wDB=wBA;

% (2) 
[wED, ~, wEY, ~, tED,~, tEY]=fourbar_velocity(bd, de,ye,  by, wDB, tDB, wYB, tYB);
tFE=tED;
wFE=wED;

% extract positions of all points
zx=zeros(1,numel(t)); zy=zeros(1,numel(t));
yx=yz*cos(tYZ); yy=yz*sin(tYZ);
ax=az*cos(tAZ); ay=az*sin(tAZ);
bx=ax+ab*cos(tBA); by=ay+ab*sin(tBA);
dx=bx+bd*cos(tDB); dy=by+bd*sin(tDB);
ex=dx+de*cos(tED); ey=dy+de*sin(tED);
fx=ex+ef*cos(tFE); fy=ey+ef*sin(tFE);


% animate
% for ii=1:numel(t)
%     figure(1); gcf; clf;
%     plot_linkage(ax,ay, bx,by, dx,dy, ex,ey, fx,fy, zx, zy, yx, yy,  ii);
%     drawnow;
% end

figure(1); gcf; clf; % new figure window for plot
ii=1;
subplot(2,2,1);
plot_linkage(ax,ay, bx,by, dx,dy, ex,ey, fx,fy, zx, zy, yx, yy, ii);


subplot(2,2,2);

plot (fx, fy, 'linewidth', 2); 
set(gca, 'fontsize', 24, 'fontname', 'times');
axis image;
grid on;
title('foot path');

subplot(2,2,3);
plot(t, fx, 'linewidth', 2);
hold on;
plot(t, fy, 'linewidth', 2);
grid on;
set(gca, 'fontsize', 24, 'fontname', 'times');
xlabel('time (s)');
legend('F_x', 'F_y');

subplot(2,2,4);
fdotx=-ef*wFE.*sin(tFE) - ye*wEY.*sin(tEY);
fdoty=ef*wFE.*cos(tFE) + ye*wEY.*cos(tEY);

plot(t, sqrt(fdotx.^2+fdoty.^2), 'linewidth', 2);
grid on;
ytickformat('%.3f')
set(gca, 'fontsize', 24, 'fontname', 'times');
xlabel('time (s)');
ylabel('F(speed) mm/s');



function plot_linkage(ax,ay, bx,by, dx,dy, ex,ey, fx,fy,zx, zy, yx, yy, ii)

% connect points using lines
plot(yx,yy, 'ks', 'markersize', 8);

hold on;
plot(zx, zy, 'rs', 'markersize', 8);
plot([ax(ii), bx(ii)], [ay(ii), by(ii)], 'r', 'linewidth', 2);
plot([ax(ii), zx(ii)], [ay(ii), zy(ii)], 'k', 'linewidth', 2);
plot([yx(ii), zx(ii)], [yy(ii), zy(ii)], 'k--', 'linewidth', 2);
plot([dx(ii), bx(ii)], [dy(ii), by(ii)], 'k', 'linewidth', 2);
plot([yx(ii), bx(ii)], [yy(ii), by(ii)], 'b', 'linewidth', 2);
plot([yx(ii), ex(ii)], [yy(ii), ey(ii)], 'g', 'linewidth', 2);
plot([ex(ii), dx(ii)], [ey(ii), dy(ii)], 'r', 'linewidth', 2);
plot([ex(ii), fx(ii)], [ey(ii), fy(ii)], 'k', 'linewidth', 2);

text(ax(ii)*1.1, ay(ii)*1.1, 'A', 'fontsize', 16);
text(bx(ii)*1.1, by(ii)*1.1, 'B', 'fontsize', 16);
text(dx(ii)*1.1, dy(ii)*1.1, 'D', 'fontsize', 16);
text(ex(ii)*1.1, ey(ii)*1.1, 'E', 'fontsize', 16);
text(fx(ii)*1.1, fy(ii)*1.1, 'F', 'fontsize', 16);
text(zx(ii)*1.1, zy(ii)*1.1, 'Z', 'fontsize', 16);
text(yx(ii)*1.1, yy(ii)*1.1, 'Y', 'fontsize', 16);


axis image;
axis([-100 100 -100 100]);
axis off;
end