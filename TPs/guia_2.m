clc
clear all

disp("# Guia 2")

% Ejercicio 1
disp("## Ejercicio 1")

z1 = -1 + 2i
z1_arg = angle(z1), z1_atan2 = atan2(2, -1)
z1_re = real(z1)
z1_im = imag(z1)

plot(z1, 'r')

pause

% Ejercicio 2
disp("## Ejercicio 2")

% vector real
x = [-1:0.05:1]; % vector de 36 columnas y 41 filas
% operador punto, se genera vector complejo
y = x.^2; % A*B
z = complex(x, y) % x: parte real, y: parte imaginaria

pause
subplot(2, 2, 1), plot(x, y), title("a) dos vectores-fila, dibuja abscisas-ordenadas")
subplot(2, 2, 2), plot([x, y]), title("b) único vector-fila, dibuja indice-entradas del vector")
subplot(2, 2, 3), plot([x; y]), title("c) una matriz con dos filas, dibuja cada columna")
subplot(2, 2, 4), plot(z), title("d) un vector-fila complejo, dibuja parte real-parte imaginaria")
% en el último el num real es tratado como complejo con parte real y parte
% imaginaria nula.
pause

% Ejercicio 3
disp("## Ejercicio 3")