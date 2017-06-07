#!/usr/bin/octave -qf

1;
ignore_function_time_stamp("all");
clear all;
%Funcao definida no EP
function y = ep(t)
	a = 1.97994808;
	b = 0.88084997;
	for i = 1:length(t)
		y(i) = 0.25*(2^(a*(1-t(i))))*(1 - sin(b*pi*t(i)));
	endfor
endfunction

%Primeira derivada da funcao ep
function y = d1ep(t)
	a = 1.97994808;
	b = 0.88084997;
	for i = 1:length(t)
		y(i) = exp(-1.3724*t(i))*(1.35345*sin(2.76727*t(i))-2.72908*cos(2.76727*t(i))-1.35345);
	endfor
endfunction

%Segunda derivada da funcao ep
function y = d2ep(t)
	a = 1.97994808;
	b = 0.88084997;
	for i = 1:length(t)
		y(i) = exp(-1.3724*t(i))*(5.69463*sin(2.76727*t(i))+7.49075*cos(2.76727*t(i))+1.85747);
	endfor
endfunction

%Taylor centrado em 0.5
function y = taylor(t)
	a = 1.97994808;
	b = 0.88084997;
	for i = 1:length(t)
		y(i) = ep(0.5) + d1ep(0.5)*(t(i) - 0.5) + d2ep(0.5)*0.5*(t(i) - 0.5)*(t(i) - 0.5);
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
n          = 0;
cru        = 0;
valcont    = 0;
importance = 0;
t          = 0:0.0001:1;
inicial    = [0.55, 1.4];

%Ajusta polinomio e plota os graficos
figure;
p       = polyfit(t, ep(t), 2);
plot(t, ep(t), "linewidth", 2);
polyint = p(3) + p(2)*0.5 + p(1)/3;
y       = polyval(p, t);
hold on;
plot(t, y, "color", 'r', "linewidth", 2);
plot(t, taylor(t), "color", 'g', "linewidth", 2);
legend('Principal', 'Ajuste por MMQ', 'Taylor centrado em 0.5');

%Ajusta Funcao Beta e plota os graficos
figure;
hold off;
ajustado = fmins('model', inicial, [],[], t, y);
y        = betapdf(t, ajustado(1), ajustado(2));
plot(t, ep(t), "linewidth", 2);
hold on;
plot(t, y, "color", 'g', "linewidth", 2);
legend('Principal', 'Distribuicao Beta');
ylim([0, 1]);
a = ajustado(1);
b = ajustado(2);

x  = rand(1, 200000);
y  = rand(1, 200000);
f  = ep(x);
w  = betaincinv(x, a, b);
B  = betapdf(w, a, b);
fb = ep(w);
pol = polyval(p, x);
for i = 1:200000
	cru        += f(i);            %Metodo Cru
	valcont    += f(i) - pol(i);   %Metodo com variavel de controle
	importance += fb(i)/B(i);	   %Metodo Importance
	if(y(i) < f(i))                %Metodo Hit or Miss
			n++;          
	endif                         
endfor
cru        *= 0.000005;
valcont    *= 0.000005;
valcont    += polyint;
hitmiss     = 0.000005*n;
importance *= 0.000005;
printf('Metodo cru:\n\tValor -> %f\n\tErro -> %f%%\n\n',
	cru, 100*abs(cru - 0.196064)/0.196064);
printf('Metodo hit or miss:\n\tValor -> %f\n\tErro -> %f%%\n\n',
	hitmiss, 100*abs(hitmiss - 0.196064)/0.196064);
printf('Metodo por variavel de controle:\n\tValor -> %f\n\tErro -> %f%%\n\n',
	valcont, 100*abs(valcont - 0.196064)/0.196064);
printf('Metodo por importance sample:\n\tValor -> %f\n\tErro -> %f%%\n\n',
	importance, 100*abs(importance - 0.196064)/0.196064);
