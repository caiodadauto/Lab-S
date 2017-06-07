% Distribuicao Weibull
function y = fun(x, tf, td)
	y = 0;
	for i = 1:length(tf)
		y = y + (log(x(2)) + (x(2) - 1) * log(tf(i) + x(1)) - x(2) * log(x(3))
			- ((tf(i) + x(1))/x(3))^x(2) + (x(1)/x(3))^x(2));
	end
	for i = 1:length(td)
		y = y  + ((-1) * ((td(i) + x(1))/x(3))^x(2) + (x(1)/x(3))^x(2));
	end
end
