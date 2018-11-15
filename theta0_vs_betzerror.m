%% Script to plot theta0 against distance from Betz limit
clc
clear


theta0 = deg2rad(0):deg2rad(0.1):deg2rad(15); %becomes unsolvable around theta0=0
dist2betz_theta0 = zeros(1,length(theta0));     %Initialise vector for results
for i = 1:length(theta0)
    
    
    dist2betz_theta0(i) = WTVelocityRange([theta0(i) -0.4*pi/180 0]);
    disp('Loop 1, counter:')
    disp(i)
end

theta_twist = deg2rad(-1.5):deg2rad(.1):deg2rad(0); %[-2*pi/180:0.2*pi/180:-1.6*pi/180, -1*pi/180:0.2*pi/180:1*pi/180];
dist2betz_theta_twist = zeros(1,length(theta_twist));
for i = 1:length(theta_twist)
    
    dist2betz_theta_twist(i) = WTVelocityRange([12*pi/180 theta_twist(i) 0]);
    disp('Loop 2, counter:')
    disp(i)
end

chord_grad = 0.10:-.01:-.10;
dist2betz_chord_grad = zeros(1,length(chord_grad));
for i = 1:length(chord_grad)
    
    dist2betz_chord_grad(i) = WTVelocityRange([12*pi/180 -0.4*pi/180 chord_grad(i)]);
    disp('Loop 3, counter:')
    disp(i)
    
end

%% Convert to percentage of theoretical efficiency limit
Betzlimit = 1.99684E+09;
eff_theta0 = ((Betzlimit - dist2betz_theta0) / Betzlimit)*100;
eff_theta_twist = ((Betzlimit - dist2betz_theta_twist) / Betzlimit)*100;
eff_chord_grad = ((Betzlimit - dist2betz_chord_grad) / Betzlimit)*100;

%% Theta0
figure()
plot((theta0.*(180/pi)),eff_theta0)
title('Effect of Root Inclination on AEP', 'FontSize', 12)
xlabel('Theta at Root (Degrees)')
ylabel('Efficiency (% of Betz Limit)')
ylim([0 70])
grid on
print -depsc C:\Users\xav_m\OneDrive\Documents\XAVI\University\Final_Year\HELICOPTERS\Coursework\Windturbine_Optimisation\Report\Figures\ChangeTheta0
%% Theta twist
figure()
plot((theta_twist.*(180/pi)),eff_theta_twist)
title('Effect of Rate of Twist on AEP', 'FontSize', 12)
xlabel('Rate of Angular Twist (Degrees/meter)')
ylabel('Efficiency (% of Betz Limit)')
ylim([0 70])
grid on
print -depsc C:\Users\xav_m\OneDrive\Documents\XAVI\University\Final_Year\HELICOPTERS\Coursework\Windturbine_Optimisation\Report\Figures\ChangeThetaTW
%% Chord gradient
figure()
plot(chord_grad, eff_chord_grad)
title('Effect of Chord Gradient on AEP')
xlabel('Rate of Chord Change Along Span')
ylabel('Efficiency (% of Betz Limit)')
ylim([0 70])
grid on
print -depsc C:\Users\xav_m\OneDrive\Documents\XAVI\University\Final_Year\HELICOPTERS\Coursework\Windturbine_Optimisation\Report\Figures\ChangeGrad