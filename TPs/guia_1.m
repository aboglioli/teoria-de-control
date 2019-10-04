clc
clear all

disp("# Guia 1")

% Ejercicio 1
disp("## Ejercicio 1")

disp("a) (4 + 3 * i) + (5 - 7 * i)")
(4 + 3 * i) + (5 - 7 * i)
pause

disp("b) (8 + 3i) - (12 + 6i) + (-9 + 12i)")
(8+3i)-(12+6i)+(-9+12i)
pause

disp("c) (8 + 3i) * (8 - 3i)")
(8+3i)*(8-3i)
% un número complejo por su conjugado pierde su parte imaginaria
pause

disp("d) 2 + (6 - 3i)")
2 + (6 - 3i)
pause

disp("e) 3 * (2/3 - 8/3i)")
3 * (2/3 - 8/3i)
pause

% Ejercicio 2
disp("## Ejercicio 2")

z1 = 2+3i

modulo = abs(z1)
pause

fase = angle(z1) % argumento, en rads
pause

re = real(z1) % parte real
pause

im = imag(z1) % parte imaginaria
pause

conjugado = conj(z1)
pause

% Ejercicio 3
disp("## Ejercicio 3")

z1 = 3 + 5i;
z2 = 1 - 2i;

modulo = abs(z1)
suma = z1 + z2
prod = z1 * z2
div = z1 / z2

disp("e) Comprobar arg(z1/z2) = arg(z1) - arg(z2)")
div_arg = rad2deg(angle(div))
z1_arg = rad2deg(angle(z1))
z2_arg = rad2deg(angle(z2))

if div_arg == z1_arg - z2_arg
    disp("Se comprueba que arg(z1/z2) = arg(z1) - arg(z2)")
else
    disp("No se comprueba que arg(z1/z2) = arg(z1) - arg(z2)")
end

pause

% Ejercicio 4
disp("## Ejercicio 4")

z4 = 1 + sqrt((3i)^(1-i))
z4_re = real(z4)
z4_im = imag(z4)
z4_mod = abs(z4)
z4_arg = rad2deg(angle(z4))

pause

% Ejercicio 5
disp("## Ejercicio 5")

z5 = 1 + 2i
z5_re = real(z5)
z5_im = imag(z5)
z5_conj = conj(z5)
z5_mod = abs(z5)
z5_arg = rad2deg(angle(z5))

hold on
figure(1);
plot(z5, '*');
compass(z5);
hold off

pause

% Ejercicio 6
disp("## Ejercicio 6")

z1 = 2+3i
z2 = 3+2i
sum = z1 + z2
Z = [z1, z2, sum]

compass(Z, 'b'); 
grid