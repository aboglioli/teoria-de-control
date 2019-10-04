disp("Guia 3: Laplace")

% Ejercicio 1
clc, clear all
disp("Ejercicio 1")

roots([1 6 14 16 8])
pause

% Ejercicio 2
clc, clear all
disp("Ejercicio 2")
disp('Transformada de Laplace F(t)= 1')

syms t s
laplace(1, t, s)
pause

disp("Inver de f(s)=s+3/s^2")
f = (s + 3) / s^2
F = ilaplace(f)
pause

% Ejercicio 3
clc, clear all
disp("Ejercicio 2")
disp("fracciones parciales de los polinomios")
num = [1 3 2 2];
den = [1 4 4];
[r, p, k] = residue(num, den)

% r = residuos, p = polos, k terminos directos sin denominador
% resultado = P1(s)/P2(s) = s - 1 + 2/( s +2)+2/(s+2)^2
pause