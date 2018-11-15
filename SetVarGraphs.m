%% Set parameters given in handout

Parameters = [ deg2rad(12) deg2rad(-.4) 0];
%% Setting as constants%%%%
A = 7;
k = 1.8;
omega = 3.14;
chord_mean = 1;
TipRadius = 20;
RootRadius = 1;
B = 3;
MinV0 = 5;
MaxV0 = 25;

%% Constants
rho = 1.225;        %density of air in kg/m^3
Area = (TipRadius^2)*(pi);           %Area in m^2

%% Calculate total tangential moment for each speed
delta_V0 = 1;
V0 = MinV0:delta_V0:MaxV0;      % Set up wing velocity range in m/s
MT = zeros(length(V0), 1);      % Initialise tangential moment vector for each wind speed
MN = zeros(length(V0), 1);      %Initialise normal moment vector for each wind speed
Power = zeros(length(V0), 1);   %Initialise power vector for each wind speed

P_speed = zeros(length(V0)-1, 1);           %Initialise vector of speed probablilities
AEP_speed = zeros(length(V0)-1, 1);         %Initialise vector of annual power at each speed
Power_midpoint = zeros(length(V0)-1, 1);    %Initialise vector of power inbetween speeds
V0_midpoint = zeros(length(V0)-1, 1);
AEP_speed_ideal = zeros(length(V0)-1, 1);
Power_ideal_midpoint = zeros(length(V0)-1, 1);

%% Calculate power for each speed

[MT(1), MN(1)] = WTSingleVelocity(V0(1), Parameters(1), Parameters(2), chord_mean, Parameters(3), TipRadius, RootRadius, omega, B);

Power(1) = MT(1)*B*omega;
Power_ideal(1) = (16/27) * 0.5*rho*(V0(1)^3)*Area;  %Theoretical maximum power defined by Betz limit
for i = 2:length(V0)
    
    [MT(i), MN(i), ~, ~] = WTSingleVelocity(V0(i), Parameters(1), Parameters(2), chord_mean, Parameters(3), TipRadius, RootRadius, omega, B);
    
    Power(i) = MT(i)*B*omega;
    
    %%%Calculating power and probablilities in the speed intervals 
    P_speed(i-1) = exp(-(V0(i-1)/A)^k) - exp(-(V0(i)/A)^k); %Calculate probability of speed between Vi and Vi+1
    
    V0_midpoint(i-1) = 0.5 * (V0(i-1) + V0(i));  %for plotting power;
    Power_midpoint(i-1) = 0.5*(Power(i-1) + Power(i));          %Power at mid point is average of lower and upper bounds
    Power_ideal(i) = (16/27) * 0.5*rho*(V0(i)^3)*Area;  %Theoretical maximum power defined by Betz limit
    Power_ideal_midpoint(i-1) = (16/27) * 0.5*rho*(((V0(i-1)+V0(i))/2)^3)*Area;  %Theoretical maximum power defined by Betz limit
    
    
    AEP_speed(i-1) = Power_midpoint(i-1) * P_speed(i-1); % * 8760;         %Calculate predictied anual power generated at each windspeed range
    AEP_speed_ideal(i-1) = Power_ideal_midpoint(i-1) * P_speed(i-1); %* 8760;   %Calculate the ideal anual power generated at each windspeed range
    
end


%% second dataset
Parameters = [ deg2rad(10) deg2rad(-.1) 0];

[MT(1), MN(1)] = WTSingleVelocity(V0(1), Parameters(1), Parameters(2), chord_mean, Parameters(3), TipRadius, RootRadius, omega, B);

Power2(1) = MT(1)*B*omega;
Power_ideal(1) = (16/27) * 0.5*rho*(V0(1)^3)*Area;  %Theoretical maximum power defined by Betz limit
for i = 2:length(V0)
    
    [MT(i), MN(i), ~, ~] = WTSingleVelocity(V0(i), Parameters(1), Parameters(2), chord_mean, Parameters(3), TipRadius, RootRadius, omega, B);
    
    Power2(i) = MT(i)*B*omega;
    
    %%%Calculating power and probablilities in the speed intervals 
    P_speed(i-1) = exp(-(V0(i-1)/A)^k) - exp(-(V0(i)/A)^k); %Calculate probability of speed between Vi and Vi+1
    
    V0_midpoint(i-1) = 0.5 * (V0(i-1) + V0(i));  %for plotting power;
    Power_midpoint2(i-1) = 0.5*(Power2(i-1) + Power2(i));          %Power at mid point is average of lower and upper bounds
    Power_ideal(i) = (16/27) * 0.5*rho*(V0(i)^3)*Area;  %Theoretical maximum power defined by Betz limit
    Power_ideal_midpoint(i-1) = (16/27) * 0.5*rho*(((V0(i-1)+V0(i))/2)^3)*Area;  %Theoretical maximum power defined by Betz limit
    
    
    AEP_speed2(i-1) = Power_midpoint2(i-1) * P_speed(i-1) ;%* 8760;         %Calculate predictied anual power generated at each windspeed range
    AEP_speed_ideal(i-1) = Power_ideal_midpoint(i-1) * P_speed(i-1); %* 8760;   %Calculate the ideal anual power generated at each windspeed range
    
end
AEP2 = sum(AEP_speed2) * 8760;
AEP = sum(AEP_speed) * 8760;
AEP_ideal = sum(AEP_speed_ideal) * 8760;

BetzPC = 100 - 100* (AEP_ideal - AEP) / AEP_ideal;
BetzPC2 = 100 - 100* (AEP_ideal - AEP2) / AEP_ideal;
%% plot wind v power
figure()
plot(V0, Power/1e6, '-b')
hold on
ylim([0 8])
xlim([5 25])
title('Effect of Windspeed on Turbine Power Ouput')
xlabel('Windspeed (m/s)')
ylabel('Power in MW')
plot(V0, Power2/1e6, '-k')
hold on
plot(V0, Power_ideal/1e6, '-r')
hold on
legend('Set 1 Output', 'Set 2 Output',  'Betz Limit')
grid on
%print -depsc C:\Users\xav_m\OneDrive\Documents\XAVI\University\Final_Year\HELICOPTERS\Coursework\Windturbine_Optimisation\Report\Figures\WindSpeedVPower

%% Plot Weibull
figure()
plot([5; V0_midpoint], [.1135; P_speed])
title('Weibull Windspeed Distribution')
ylabel('Probability Density')
xlabel('Windspeed in m/s')
grid on
%print -depsc C:\Users\xav_m\OneDrive\Documents\XAVI\University\Final_Year\HELICOPTERS\Coursework\Windturbine_Optimisation\Report\Figures\Weibull


%% AEP PLOT

figure()
plot(V0_midpoint, AEP_speed, '-b')
hold on
plot(V0_midpoint, AEP_speed2, '-k')
hold on
plot(V0_midpoint, AEP_speed_ideal, '-r')
hold on
title('Anual Energy Production Distribution')
ylabel('Power * Probability Density')
xlabel('Windspeed in m/s')
ylim([0 2.5e4])
legend({'Set 1', 'Set 2',  'Betz Limit'}, 'location', 'NorthEast')
grid on
%print -depsc C:\Users\xav_m\OneDrive\Documents\XAVI\University\Final_Year\HELICOPTERS\Coursework\Windturbine_Optimisation\Report\Figures\AEP1