function [MT_local, MN, output] = WTSingleVelocity(V0, theta0, theta_twist, chord_mean, chord_grad, TipRadius, RootRadius, omega, B)
%2: WHOLE ROTOR - loop WTInducedCalcs to find the values for all radii,
%then integrate these to get the normal and tangential moment at the blade
%root.

%% Set constants       %%%%% Future work: can these be set as globals?
rho = 1.225;        %density of air in kg/m^3

%% Set up geometry
y = 1.5:1:19.5;   %Vector of local radii (elements) (in m)
y_delta = y(2) - y(1);  %delta is difference between adjacent elements
R = TipRadius - RootRadius;

%% Set up empty outputs arrays to improve efficiency
output = zeros(length(y),5);
MN_local = zeros(length(y),1);
MT_local = zeros(length(y),1);
%% 2: Calculate individual element moment both in plane and normal

for i = 1:length(y)
    
    %Calculate local chord and angle of attack
    chord_local = chord_mean + (y(i) - (R/2))*chord_grad;
    theta_local = theta0 + y(i)*theta_twist;
    
    %Calculate Cn and Ct for the local element
    [a_out, adash_out, phi, Cn, Ct] = WTInducedCalcs(0, 0, V0, omega, y(i), theta_local, chord_local , B);
    output(i,:) = [a_out, adash_out, phi, Cn, Ct];
    
    % Calculate Relative Velocity  %%%%%Future work: can this be pulled form previous function?
    V_rel = ((V0*(1-a_out))^2 + ((omega*y(i))*(1 + adash_out))^2)^.5;
    
    %Calculate the local moment in normal and tangential (torque) directions
    MN_local(i) = (.5*rho*(V_rel^2)*chord_local*Cn)*y_delta*y(i);
    MT_local(i) = (.5*rho*(V_rel^2)*chord_local*Ct)*y_delta*y(i);
    
end

%% Integrate the moments to find totals

MN = sum(MN_local);
MT = sum(MT_local);

end