clear; close all; clc;

mat1 = csvread('circular_motition.csv',4);
mat2 = csvread('vertical acceleration.csv',4);
mat3 = csvread('tan_accel.csv',4);
mat4 = csvread('cen_accel.csv',4);
mat5 = csvread('ang_accel.csv',4);
mat6 = csvread('ang_res_accel.csv',4);
mat7 = csvread('vert_pos.csv',4);

seconds = 3.07; %end of pull stroke
m_s = seconds * 1000;

seconds2 = 2.2; % when the rotation starts
m_s2 = seconds2 * 1000;

figure;

% Plot 1: Angle vs Time
subplot(3,3,1)
plot(mat1(1:180,1),mat1(1:180,2))
hold on
plot([m_s m_s],[-40 100],'--')
plot([m_s2 m_s2],[-40 100],'--',color='g')

ylabel('Angle')
xlabel('Time (s)')
title('Circular Motion')

% Plot 2: Vertical Acceleration vs Time
subplot(3,3,2)
plot(mat2(1:180,1),mat2(1:180,2))
hold on
plot([m_s m_s],[-0.15 0.2],'--')
plot([m_s2 m_s2],[-0.15 0.2],'--',color='g')

ylabel('Acceleration')
xlabel('Time (s)')
title('Vertical Acceleration')

% Plot 3: Tangential Acceleration vs Time
subplot(3,3,3)
plot(mat3(1:180,1),mat3(1:180,2))
hold on
plot([m_s m_s],[-1.5 1.5],'--')
plot([m_s2 m_s2],[-1.5 1.5],'--',color='g')

ylabel('Tan Accel')
xlabel('Time (s)')
title('Tangential Acceleration')

% Plot 4: Centripetal Acceleration vs Time
subplot(3,3,4)
plot(mat4(1:180,1),mat4(1:180,2))
hold on
plot([m_s m_s],[0 0.9],'--')
plot([m_s2 m_s2],[0 0.9],'--',color='g')

ylabel('Cen Accel')
xlabel('Time (s)')
title('Centripetal Acceleration')

% Plot 5: Angular Acceleration vs Time
subplot(3,3,5)
plot(mat5(1:180,1),mat5(1:180,2))
hold on
plot([m_s m_s],[-5000 5000],'--')
plot([m_s2 m_s2],[-5000 5000],'--',color='g')

ylabel('Ang Accel')
xlabel('Time (s)')
title('Angular Acceleration')

% Plot 6: Resultant Acceleration vs Time
subplot(3,3,6)
plot(mat6(1:180,1),mat6(1:180,2))
hold on
plot([m_s m_s],[-0.1 1.75],'--')
plot([m_s2 m_s2],[-0.1 1.75],'--',color='g')

ylabel('Res Accel')
xlabel('Time (s)')
title('Resultant Acceleration')

% Plot 7: Vertical Posititon vs Time
subplot(3,3,7)
plot(mat7(1:180,1),mat7(1:180,2))
hold on
%plot([m_s m_s],[-0.1 1.75],'--')
plot([m_s m_s],[4 5.5],'--')
plot([m_s2 m_s2],[4 5.5],'--',color='g')
ylabel('Vertical Posititon (in)')
xlabel('Time (s)')
title('Vertical Posititon')

sgtitle('Motion Analysis') % Title for the entire figure
