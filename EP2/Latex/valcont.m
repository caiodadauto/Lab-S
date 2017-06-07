%Funcao definida no EP
function y = ep(t)
	a = 1.97994808;
	b = 0.88084997;
	for i = 1:length(t)
		y(i) = 0.25*(2^(a*(1-t(i))))*(1 - sin(b*pi*t(i)));
	endfor
endfunction

%Inicializacao de variaveis
valcont    = 0;
t          = 0:0.0001:1;

x   = rand(1, 200000);
y   = rand(1, 200000);
f   = ep(x);
p   = polyfit(t, ep(t), 2);
pol = polyval(p, x);
for i = 1:200000
	valcont    += f(i) - pol(i);
endfor
valcont    += polyint;
