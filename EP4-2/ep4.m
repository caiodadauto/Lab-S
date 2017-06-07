%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nome: Caio Vinicius Dadauto          Exercício de programa 2      
% Nusp: 7994808                                                     
% Curso: Laboratorio de Programacao e Simulacao                     
% Turma: Noturno                                                    
%                                                                   
% Este programa faz uso do pacoote 'optim' do projeto octave-forge  
%      pkg install -forge optim                                     
%      pkg load optim                                               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#!/usr/bin/octave -qf

1;
ignore_function_time_stamp("all");
clear all;


% Distribuicao Weibull
function y = weibull(x, tf, td)
    y = 0;
    for i = 1:length(tf)
        y -= log(x(2)) + (x(2) + 1) * log(tf(i) + x(1)) - x(2) * log(x(3)) - ((tf(i) + x(1))/x(3))^x(2) + (x(1)/x(3))^x(2);
    endfor
    for i = 1:length(td)
        y -= (-1) * ((td(i) + x(1))/x(3))^x(2) + (x(1)/x(3))^x(2);
    endfor
endfunction

% Inicializacao de variaveis
rho = [0.05; 0.01; 0.2; 0.3; 0.4; 0.5; 0.6; 0.7; 0.8; 0.9];
tf  = [0.01; 0.19; 0.51; 0.57; 0.70; 0.73; 0.75; 0.75;
        1.11; 1.16; 1.21; 1.22; 1.24; 1.48; 1.54; 1.59;
        1.61; 1.61; 1.62; 1.62; 1.71; 1.75; 1.77; 1.79;
        1.88; 1.90; 1.93; 2.01; 2.16; 2.18; 2.30; 2.30;
        2.41; 2.44; 2.57; 2.61; 2.62; 2.72; 2.76; 2.84;
        2.96; 2.98; 3.19; 3.25; 3.31];
td  = [1.19; 3.50;  3.50;  3.50;  3.50;];

wei = @(x) weibull(x, tf, td); 
for i = length(rho)
    contorno = @(x) rho(i) * x(3) * gamma(1 + 1/x(1)) - x(1);
    x0   = [1.25; 3.28; 3.54];
    [ev, obj, info, iter, nf, lambda] = sqp(x0, wei, contorno, []);
    printf('Para rho = %g -> apha = %g; beta = %g; gamma = %g\n', rho(i), ev(1), ev(2), ev(3));
endfor
