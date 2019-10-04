disp("Ejercicio 2")
clc; clear all

A = [-2 2; 0.5 -0.75];
B = [0; 0.5];
C = [1 0];
D = 0; % no existe transmision directa entre la entrada y la salida

HC = ss(A, B, C, D) % crea el objeto sistema continuo
disp("La siguiente figura representa la respuesta del sistema evaluando solo a X1) frente a un paso unitario0") % para impulso la funcion es impulse
figure

x0 = [20; 100] % suponiendo temperaturas iniciales de 20 y 100 grados en cada 
initial(HC, x0) % graficar la respuesta del sistema con la condición inicial, es
pause % mostrar primer gráfico
title("Se observa como el reciento X1 es afectado por la temperatura mayor del otro recinto, pero éste pierde temperatura gradualmente")
disp("En la sgte figura aplicamos a la entrada valores de magnitud constantes igual a la unidad (escalón unitario)")
step(HC) % comando para graficar la respuesta del sistema ante una entrada escalón
title("Se observa que la salida tiende a equilibrarse en el valor 2 luego de 25 seg")