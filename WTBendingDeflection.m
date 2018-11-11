function [tip_deflection] = WTBendingDeflection(theta0, theta_twist, chord_grad)
%%Calculates deflection in the normal direction
%% Setting as constants%%%%
omega = 3.14;
chord_mean = 1;
R = 20;
RootRadius = 1;
B = 3;
V0 = 25;
rho = 1.225; 

%% Set up geometry
y = 1:1:20;   %Vector of local radii (elements) (in m)
y = y';
N = length(y);   %number of elements
y_delta = y(2) - y(1);  %delta is difference between adjacent elements
%% Get local stifness and k
EI_local = zeros(1,N);

%% Initialise
k = zeros(1,N);
MN_local = zeros(1,N);
BeamTheta_local = zeros(1,N);
u = zeros(1,N);
Cn = zeros(1,N);
%% Boundary Conditions
MN_local(N) = 0;
BeamTheta_local(1) = 0; %Beam deflection angle at root
u(1) = 0;               %Beam deflection at root

%% Calculate local moments an
for i = N-1:-1:1
    %Calculate local chord and angle of attack
    chord_local = chord_mean + ((y(i)) - (R/2))*chord_grad;
    theta_local = theta0 + (y(i))*theta_twist;
    
    [a_out, adash_out, ~, Cn(i), ~] = WTInducedCalcs(0, 0, V0, omega, y(i), theta_local, chord_local, B);
    V_rel = ((V0*(1-a_out))^2 + ((omega*y(i))*(1 + adash_out))^2)^.5;
    MN_local(i) =  MN_local(i+1) + (.5*rho*(V_rel^2)*chord_local*Cn(i))*y_delta*y(i);
    EI_local(i) = getStiffness(chord_local);
    k(i) = MN_local(i)/EI_local(i);
end

for i = 1:N-1
    BeamTheta_local(i+1) = BeamTheta_local(i) + 0.5*(k(i+1) + k(i))*(y(i+1) - y(i));
end



for i = 1:N-1
    u(i+1) = u(i) + BeamTheta_local(i)*(y(i+1)-y(i)) + ((1/6)*k(i+1) + (1/3)*k(i))*(y(i+1)-y(i))^2;
end

tip_deflection = u(end);
