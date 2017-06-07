%Funcao definida no EP
function y = ep(t)
	a = 1.97994808;
	b = 0.88084997;
	for i = 1:length(t)
		y(i) = 0.25*(2^(a*(1-t(i))))*(1 - sin(b*pi*t(i)));
	endfor
endfunction

%Metropolis Hastings com nucleo normal
function [x1,a] = MHstepn(x0, sig)
	xp = rem(abs(normrnd(x0, sig)), 1);     %Determina candidato
	accprob = ep(xp)/ep(x0);                %Probabilidade de aceitacao
	u = rem(abs(normrnd(0, sig)), 1);
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
xn   = 0;           %Ponto inicial normal
Xn   = zeros(1,n);   %Vetor para armazenar os pontos determinados pelo MH normla
t    = 0:0.0001:1;
sig  = 1;            %Sigma da gaussiana
accn = [0 0];        %Vetor para determinar o ratio de aceitacao (normal)

for i = 1:n
	[xn,an] = MHstepn(xn,sig);
	accn   = accn + [an 1.0];
	Xn(i)  = xn;
endfor

In = sum(Xn)/n;
