function [a_out, adash_out, phi, Cn, Ct] = WTInducedCalcs(a_in, adash_in, V0, omega, y, theta, chord, B)
%1: SINGLE ELEMENT: use an iterative solution to find the values of a,
%adash, phi, Cn and Ct at a particular radius.

%% Set constants
rho = 1.225;        %density of air in kg/m^3
mu = 18.81e-6;      %kinematic viscosity in Pa.s

error_tol = .0001;  % setting allowable error
error = error_tol + 1; %set first error to initiate while loop

%% loop over until error goes below tolerance
i = 0;      %Initialize counter, will need to break loop if i exceeds 100
while error >= error_tol && i <101
    i = i + 1;
    
    %% Calculate  angles
    phi = atan(((1-a_in)*V0) / ((1+adash_in)*omega*y));
    
    alpha = phi - theta;
    
    %% Calculate Reynolds number
    V_rel = ((V0*(1-a_in))^2 + ((omega*y)*(1 + adash_in))^2)^.5;
    
    Re = (rho*V_rel*chord) / mu;
    
    %% Get non-dimensional lift and drag coefficients and convert
    [Cl, Cd] = ForceCoefficient(alpha, Re);
    Cn = Cl*cos(phi) + Cd*sin(phi);         %Normal Force Coefficient
    Ct = Cl*sin(phi) - Cd*cos(phi);         %Tangential Force Coefficient
    
    %% Calculate new values for a and a'
    sigma = (B*chord) / (2*pi()*y);
    a_out = 1 / (((4*sin(phi)^2)/(sigma*Cn)) + 1);
    adash_out = 1 / (((4*sin(phi)*cos(phi))/(sigma*Ct)) - 1);
    
    %% Calculate error
    error = abs(a_out - a_in) + abs(adash_out - adash_in);
    
    %% If error greater than allowable error apply relaxation factor,
    %else the solution has been found and while loop can be broken
    if error >= error_tol
        a_in = 0.1*(a_out - a_in) + a_in;
        adash_in = 0.1*(adash_out - adash_in) + adash_in;
    else
        break
    end
    
end

%% If counter exceed 100 set a' to zero and solve for a

if i > 100
    
    a_in = 0;
    adash_out = 0;
    while error >= error_tol
        i = i+1;
        %Trying to find where Optimiser gets stuck
        if rem(i, 10000) == 0
            disp(strcat('i = ', num2str(i)))
            disp(strcat('Alpha = ', num2str(alpha*180/pi), ' Theta = ', num2str(theta*180/pi), ' a = ', num2str(a_in)))
        end
        %% Calculate  angles
        phi = atan(((1-a_in)*V0) / ((1)*omega*y));
        
        alpha = phi - theta;
        
        %%%%%%%%%%% After 50000 iterations just set alpha to a solvable value
        if i > 50000
            alpha = 11*pi/180;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% Calculate Reynolds number
        V_rel = ((V0*(1-a_in))^2 + ((omega*y)*(1))^2)^.5;
        
        Re = (rho*V_rel*chord) / mu;
        
        %% Get non-dimensional lift and drag coefficients and convert
        [Cl, Cd] = ForceCoefficient(alpha, Re);
        
        %%%%%%%%%%%% Every 10000 iterations interrogate CL and CD
%         if rem(i, 10000) == 0
%             disp(strcat('C_LIFT: ', num2str(Cl), '  C_DRAG: ', num2str(Cd), '  C_NORM: ', num2str(Cn), 'RE = ', num2str(RE)));
%         end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Cn = Cl*cos(phi) + Cd*sin(phi);         %Normal Force Coefficient
        Ct = Cl*sin(phi) - Cd*cos(phi);         %Tangential Force Coefficient
        
        %% Calculate new values for a and a'
        sigma = (B*chord) / (2*pi*y);
        a_out = 1 / (((4*sin(phi)^2)/(sigma*Cn)) + 1);
        
        %% Calculate error
        error = abs(a_out - a_in);
        
        %% If error greater than allowable error apply relaxation factor,
        % else the solution has been found and while loop can be broken
        if error >= error_tol
            if i < 10000
            a_in = 0.1*(a_out - a_in) + a_in;  %Relaxation facto k=.1 added
            else
                a_in = 0.05*(a_out - a_in) + a_in; %Add more relaxation if not converging
            end
            
        else
            break
        end
        
    end
    
end
end
