function [EI] = getStiffness(c)
%Returns the stiffness for a given chord length

EI = 40*(10^9)*((c*(0.2*c)^3) / 12);

end