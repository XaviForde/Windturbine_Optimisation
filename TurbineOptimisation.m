function [] = TurbineOptimisation()
%%%%Script to find the optimal solution for theta0, theta_twist and 
%chrod gradient

[x] = fminsearchbnd(@sinfit, [1.5 1 0], [0.5 0.1 -pi], [2 2 pi], opts, Data);
