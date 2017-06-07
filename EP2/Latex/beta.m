%Funcao definida no EP
function y = ep(t)
	a = 1.97994808;
	b = 0.88084997;
	for i = 1:length(t)
		y(i) = 0.25*(2^(a*(1-t(i))))*(1 - sin(b*pi*t(i)));
	endfor
endfunction

%Quadrado da diferenca entre a funcao beta de parametros p(1) e p(2) e a funcao y
function sumSquareErrors = model(p,t,y)
	a=p(1);
	b=p(2);
	B=betapdf(t, a, b);
	for i = 10:length(y) 
		difference = y(i) - B(i);
	endfor
	sumSquareErrors = sum(difference.^2);
endfunction


%Inicializacao de variaveis
importance = 0;
t          = 0:0.0001:1;
inicial    = [0.55, 1.4];
%--------------------------

x   = rand(1, 200000);
y   = rand(1, 200000);
f   = ep(x);
ajustado = fmins('model', inicial, [],[], t, y);
a = ajustado(1);
b = ajustado(2);
for i = 1:200000
	importance += fb(i)/B(i);	   %Metodo Importance
endfor
importance *= 0.000005;
