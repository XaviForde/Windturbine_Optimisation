%% Script to plot theta0 against distance from Betz limit
clc
clear


theta0 = [-15*pi/180:0.05:-0, 0:.03:20*pi/180]; %becomes unsolvable around theta0=0
dist2betz_theta0 = zeros(1,length(theta0));     %Initialise vector for results
for i = 1:length(theta0)
    
    
    dist2betz_theta0(i) = WTVelocityRange([theta0(i) -0.4*pi/180 0]);
    disp('Loop 1, counter:')
    disp(i)
end

theta_twist = [-2*pi/180:0.2*pi/180:-1.6*pi/180, -1*pi/180:0.2*pi/180:1*pi/180];
dist2betz_theta_twist = zeros(1,length(theta_twist));
for i = 1:length(theta_twist)
    
    dist2betz_theta_twist(i) = WTVelocityRange([12*pi/180 theta_twist(i) 0]);
    disp('Loop 2, counter:')
    disp(i)
end

chord_grad = 0.105:-.05:-.105;
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
%% Plotting results
figure()
plot((theta0.*(180/pi)),eff_theta0)
xlabel('Theta at Root (Degrees)')
ylabel('Efficiency (% of Betz Limit)')
figure()
plot((theta_twist.*(180/pi)),eff_theta_twist)
xlabel('Rate of Angular Twist in (Degrees/meter)')
ylabel('Efficiency (% of Betz Limit)')
figure()
plot(chord_grad, eff_chord_grad)
xlabel('Rate of Chord Change Along Span')
ylabel('Efficiency (% of Betz Limit)')