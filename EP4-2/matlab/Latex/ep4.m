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

1;

% Inicializacao de variaveis
rho = [0.05; 0.01; 0.2; 0.3; 0.4; 0.5; 0.6; 0.7; 0.8; 0.9];
tf  = [0.01; 0.19; 0.51; 0.57; 0.70; 0.73; 0.75; 0.75;
		1.11; 1.16; 1.21; 1.22; 1.24; 1.48; 1.54; 1.59;
		1.61; 1.61; 1.62; 1.62; 1.71; 1.75; 1.77; 1.79;
		1.88; 1.90; 1.93; 2.01; 2.16; 2.18; 2.30; 2.30;
		2.41; 2.44; 2.57; 2.61; 2.62; 2.72; 2.76; 2.84;
		2.96; 2.98; 3.19; 3.25; 3.31];
td  = [1.19; 3.50;  3.50;  3.50;  3.50;];

N      = 10000;
ev     = zeros(10);
p      = [1, 4];
objfun = @(x) (-1) * fun(x, tf, td); 
for i = 1:length(rho)
	n      = 0;
	k      = 0;
	alpha0 = rho(i) * p(2) * gamma(1 + 1/p(1));
	x0     = [alpha0, 1, 1];
	option = optimset('Algorithm', 'interior-point');
	confun = @(x) con(x, rho(i));
	theta  = fmincon(objfun, x0, [], [], [], [], [0; 3; 0], [Inf; 4; Inf], confun, option);
	disp(theta);
	phi    = objfun(theta);
	funphi = @(x) objfun(x) * (objfun(x) >= phi);
	while k < N
		val = [rand * pi/2, 3 + rand, rand * pi/2];
		y0  = [tan(val(1)), val(2), tan(val(3))];
		newfunphi = funphi(y0) * (sec(val(1)) * sec(val(3)))^2;
		if ~isnan(newfunphi)
			if newfunphi > 0
				n = n + 1;
			end
			k = k + 1;
		end
	end
	kapa   = n/N;
	disp(kapa);
	ev(i)  = 1 - kapa;
end
disp(ev);
