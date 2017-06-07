% Funcao de contorno
function [c, ceq] = con(x, rho)
	c = [];
	ceq = rho * x(3) * gamma(1 + 1/x(2)) - x(1);
end
