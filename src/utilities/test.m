clear;
close all; clc;
SA = [0; -1; 0];

beta = deg2rad(-30);

SUN = [cos(beta); sin(beta); 0];

psi = deg2rad(0);


R_pitch = [cos(psi)  0   sin(psi);
           0         1   0;
          -sin(psi)  0   cos(psi) ];


theta = deg2rad(linspace(0, 180, 90));

for i = 1:length(theta)

    R_yaw = [cos(theta(i)) -sin(theta(i))   0
             sin(theta(i))  cos(theta(i))   0
             0           0            1 ];

    temp(:,i) = R_pitch*R_yaw*SA;


    result(i) = dot(temp(:,i),SUN);
    
end


data = [rad2deg(psi)*ones(1,length(theta)); rad2deg(theta); result; temp]'


[max_value, row_index] = max(abs(data(:,3)));
max_row = data(row_index,:);
disp(max_row)

energy = dot([temp(1,row_index),temp(2,row_index),temp(3,row_index)],SUN)




figure();
subplot(3,1,1:2)
for i = 1:length(theta)
    quiver3(0,0,0,temp(1,i),temp(2,i),temp(3,i),'color','k')
    hold on 
end
quiver3(0,0,0,temp(1,row_index),temp(2,row_index),temp(3,row_index),'color','r','LineWidth',2)
quiver3(0,0,0,SUN(1),SUN(2),SUN(3),'color','#EDB120','LineWidth',2)
set(gca, 'ZDir', 'reverse');
set(gca, 'YDir', 'reverse');
xlabel('x')
ylabel('y')
view([112.6,31.16])
grid on; box on;

subplot(3,1,3)
plot(rad2deg(theta), result, 'linewidth',3)
grid on; box on;





% psi  = deg2rad(linspace(0, -90, 10));
% beta = deg2rad(-30*ones(1,length(psi)));
% theta = atan(-cos(psi)./tan(beta));

% figure()
% plot(rad2deg(psi), rad2deg(theta), 'linewidth',3)
% grid on
% box on




syms theta psi beta real;

R_pitch = [cos(psi)  0   sin(psi)
           0         1   0 
          -sin(psi)  0   cos(psi)];

R_yaw = [cos(theta) -sin(theta)   0
         sin(theta)  cos(theta)   0
         0           0            1 ];

temp = R_pitch * R_yaw * [0; -1; 0];

dot_prod = dot(temp,[cos(beta); sin(beta); 0])

expr = diff(dot_prod, theta)




