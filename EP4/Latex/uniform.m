%Funcao definida no EP
function y = ep(t)
	a = 1.97994808;
	b = 0.88084997;
	for i = 1:length(t)
		y(i) = 0.25*(2^(a*(1-t(i))))*(1 - sin(b*pi*t(i)));
	endfor
endfunction

%Metropolis Hastings com nucleo uniforme
function [x1,a] = MHstepu(x0)
	xp = rem(unifrnd(0, 1), 1);             %Determina candidato
	accprob = ep(xp)/ep(x0);                %Probabilidade de aceitacao
	u = normrnd(0, 1);
	if u <= min(1, accprob)                 %Condicao de aceite
		x1 = xp; 
		a = 1;
	else
		x1 = x0;
		a = 0;
	endif
endfunction

%Inicializacao de variaveis
n    = 5000;          
xu   = 0;           %Ponto inicial uniforme
Xu   = zeros(1,n);   %Vetor para armazenar os pontos determinados pelo MH uniforme
t    = 0:0.0001:1;
sig  = 1;            %Sigma da gaussiana
accu = [0 0];        %Vetor para determinar o ratio de aceitacao (uniforme)

for i = 1:n
	[xu,au] = MHstepu(xu);
	accu   = accu + [au 1.0];
	Xu(i)  = xu;
endfor

Iu = sum(Xu)/n;
