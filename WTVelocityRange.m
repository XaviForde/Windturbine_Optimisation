function [Diff] = WTVelocityRange(Parameters)
%3: ANNUAL ENERGY - loop WTSingleVelocity to find the moments across the
%entire velocity range. Combine this with the frequency information to get
%the AEP. Parameters = [theta0, theta_twist, chord_grad]

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
AEP_speed_ideal = zeros(length(V0)-1, 1);
Power_ideal = zeros(length(V0)-1, 1);

%% Calculate power for each speed

[MT(1), MN(1)] = WTSingleVelocity(V0(1), Parameters(1), Parameters(2), chord_mean, Parameters(3), TipRadius, RootRadius, omega, B);

Power(1) = MT(1)*B*omega;

for i = 2:length(V0)
    
    [MT(i), MN(i), ~, ~] = WTSingleVelocity(V0(i), Parameters(1), Parameters(2), chord_mean, Parameters(3), TipRadius, RootRadius, omega, B);
    
    Power(i) = MT(i)*B*omega;
    
    %%%Calculating power and probablilities in the speed intervals 
    P_speed(i-1) = exp(-(V0(i-1)/A)^k) - exp(-(V0(i)/A)^k); %Calculate probability of speed between Vi and Vi+1
    
    Power_midpoint(i-1) = 0.5*(Power(i-1) + Power(i));          %Power at mid point is average of lower and upper bounds
    Power_ideal(i-1) = (16/27) * 0.5*rho*(((V0(i-1)+V0(i))/2)^3)*Area;  %Theoretical maximum power defined by Betz limit
    
    AEP_speed(i-1) = Power_midpoint(i-1) * P_speed(i-1) * 8760;         %Calculate predictied anual power generated at each windspeed range
    AEP_speed_ideal(i-1) = Power_ideal(i-1) * P_speed(i-1) * 8760;   %Calculate the ideal anual power generated at each windspeed range
    
end

AEP = sum(AEP_speed);
AEP_ideal = sum(AEP_speed_ideal);

% [tip_deflection, M_root] = WTBendingDeflection(Parameters(1), Parameters(2), Parameters(3));
% disp(strcat('Tip deflection: ', num2str(tip_deflection), '  M_root: ', num2str(M_root)));
% if  tip_deflection > 3 || M_root > 0.5e6
%     AEP = 0;
% end
Diff = AEP_ideal - AEP;
assert(Diff > 0, 'Error!Predicted power greater than ideal.')

end