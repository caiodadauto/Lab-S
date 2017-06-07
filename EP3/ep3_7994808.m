%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nome: Caio Vinicius Dadauto          Exercício de programa 3      
% Nusp: 7994808                                                     
% Curso: Laboratorio de Programacao e Simulacao                     
% Turma: Noturno                                                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%Metropolis Hastings com nucleo uniforme
function [x1,a] = MHstepu()
    xp = unifrnd(0, 1) - 0.5;                     %Determina candidato
    accprob = ep(xp)/ep(x0);                %Probabilidade de aceitacao
    u = normrnd(0, 1) - 0.5;
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
xn    = 0;           %Ponto inicial normal
xu    = 0;           %Ponto inicial uniforme
Xn   = zeros(1,n);   %Vetor para armazenar os pontos determinados pelo MH normla
Xu   = zeros(1,n);   %Vetor para armazenar os pontos determinados pelo MH uniforme
t    = 0:0.0001:1;
sig  = 1;            %Sigma da gaussiana
accn = [0 0];        %Vetor para determinar o ratio de aceitacao (normal)
accu = [0 0];        %Vetor para determinar o ratio de aceitacao (uniforme)

xn = input("Entre com o valor inicial entre 0 e 1 para o nucleo normal: ");
xu = input("Entre com o valor inicial entre 0 e 1 para o nucleo uniforme: ");
n  = input("Entre com o valor de iteracoes a serem realizadas: ");
for i = 1:n
    [xn,an] = MHstepn(xn,sig);
    [xu,au] = MHstepn(xu,sig);
    accn   = accn + [an 1.0];
    accu   = accu + [au 1.0];
    Xn(i)  = xn;
    Xu(i)  = xu;
endfor

%Plota figuras
figure;
plot(t, ep(t), "linewidth", 2, "color", 'k');
hold off;
figure;
hist(Xn, 50);
figure;
hist(Xu, 50);

In = sum(Xn)/n;
Iu = sum(Xu)/n;
printf('MH normal:\n\tValor -> %f\n\tErro -> %f%%\n\nRatio -> %f\n\n', 
    In, 100*abs((In - 0.196064)/0.196064), accn(1)/accn(2));
printf('MH uniforme:\n\tValor -> %f\n\tErro -> %f%%\n\nRatio --> %f\n\n',
    Iu, 100*abs((Iu - 0.196064)/0.196064), accu(1)/accu(2));
