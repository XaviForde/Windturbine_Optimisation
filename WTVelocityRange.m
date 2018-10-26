function [Diff] = WTVelocityRange(Parameters, A, k, omega, chord_mean, TipRadius, RootRadius, B, MinV0, MaxV0)
%3: ANNUAL ENERGY - loop WTSingleVelocity to find the moments across the
%entire velocity range. Combine this with the frequency information to get
%the AEP. Parameters = [theta0, theta_twist, chord_grad]




%% Calculate total tangential moment for each speed

delta_V0 = 1;
V0 = MinV0:delta_V0:MaxV0;               % Set up wing velocity range in m/s
MT = zeros(length(V0), 1);      % Initialise tangential moment vector for each wind speed
MN = zeros(length(V0), 1);      %Initialise normal moment vector for each wind speed
Power = zeros(length(V0), 1);   %Initialise power vector for each wind speed

%% Calculate power for each speed

for i = 1:length(V0)
    
    [MT(i), MN(i)] = WTSingleVelocity(V0(i), Parameters(1), Parameters(2), chord_mean, Parameters(3), TipRadius, RootRadius, omega, B);
    
    Power(i) = MT(i)*B*omega;
end

P_speed = zeros(length(V0)-1, 1);       %Set vector of speed probablilities
AEP_speed = zeros(length(V0)-1, 1);     %Set vector of annual power at each speed
Power_midpoint = zeros(length(V0)-1, 1);

for i = 1:(length(V0)-1)        % PUT THIS FOR LOOP INTO PREVIOUS ONE
    
    P_speed(i) = exp(-(V0(i)/A)^k) - exp(-(V0(i+1)/A)^k); %Calculate probability f speed between Vi and Vi+1
    
    Power_midpoint(i) = .5*(Power(i) + Power(i+1));
    
    AEP_speed(i) = Power_midpoint(i) * P_speed(i) * 8760;
    
end

%AEP = sum(AEP_speed);
Diff = [Power_midpoint, P_speed, AEP_speed];

end