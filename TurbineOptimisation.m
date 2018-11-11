function [] = TurbineOptimisation()
%%%%Script to find the optimal solution for theta0, theta_twist and 
%chrod gradient

%OPTIMISE FIT - 3 variables: Theta0, Theta_grad and Chord_grad
opts = optimset('fminsearch');
opts.Display = 'iter'; %What to display in command window
opts.TolX = 0.001; %Tolerance on the variation in the parameters
opts.TolFun = 1e6;  %Tolerance on the error
opts.MaxFunEvals = 150; %Max number of iterations

%fminsearch inputs: (function, initial guess, lower limits on variables, 
% upper limits on variables, options)

%Limit for Theta0 is set to +/- 20 degrees
%Limit for rate of twist is set so 45 degrees twis over blade is the
%maximum
% Limit for chord grad set so there is at least 20cm chord at root for
% attatchment and so chord is positive at R = 20 

[x] = fminsearchbnd(@WTVelocityRange, [5*pi/180 -.3*pi/180 .05], [-20*pi/180 -2.36*pi/180 -0.105], [20*pi/180 2.36*pi/180 (8/95)], opts);

disp(strcat('OPTIMAL VALUES: Theta0 = ', num2str(x(1)*180/pi), ' Twist Rate = ', num2str(x(2)*180/pi), ' Taper Rate = ', num2str(x(3))))

%% Check bending moment does not Exceed 0.5MNm
%WTSingleVelocity inputs => V0, theta0, theta_twist, chord_mean, chord_grad, TipRadius, RootRadius, omega, B

%[MT, ~] = WTSingleVelocity(25, x(1), x(2), 1, x(3), 20, 1, 30, 3);

%disp(MT)

%% Compute and display how 
BetzLimit = 1.99684E+09;
diff = WTVelocityRange(x);
eff = (BetzLimit - diff) / BetzLimit * 100;

disp(strcat('Percentage of Betz Limit = ', num2str(eff), ' %'))



end
