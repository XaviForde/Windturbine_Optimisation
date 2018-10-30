function [] = WTOptimisation()
%4: OPTIMISATION - use fminsearchbnd to optimise ?0, ?tw, and cgrad for
%maximum AEP.

%OPTIMISE FIT - 3 variables: amplitude, frequency and phaselag
opts = optimset('fminsearch');
opts.Display = 'iter'; %What to display in command window
opts.TolX = 0.001; %Tolerance on the variation in the parameters
opts.TolFun = 0.001; %Tolerance on the error
opts.MaxFunEvals = 100; %Max number of iterations

[x] = fminsearchbnd(@WTVelocityRange, [12*pi/180 1 0], [0 1 0], [45*pi/180 1 0], opts);

%WRITE OPTIMAL VARIABLES IN COMMAND WINDOW
disp(strcat('OPTIMAL VALUES: Theta at Root = ', num2str(x(1)), 'Angle Twist Rate = ', num2str(x(2)), 'Chord Gradient = ', num2str(x(3))))

end