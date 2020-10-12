function [t,x_out] = mV_seg(x_in,Fs,base,gain)

% Función que estandariza la señal a mV vs Segundos
% VARIABLES DE ENTRADA
%   x_in -> Señal x_out original
%   Fs -> Frecuencia de muestreo de la señal
%   base -> Base de la señal, tomada del .info
%   gain -> Gain de la señal, tomada del .info
% VARIABLES DE SALIDA

% IMPLEMENTACIÓN DE LA ESTANDARIZACIÓN

% Tomo el primer canal de la señal
x_out = x_in; %aquí puede seleccionar el canal que desea analizar(si hubiera más de 1 canal)

% Ponemos la señal en segundos vs mv
x_out=(x_out-base)/gain;

% Tamaño de la señal
N=length(x_out);

% Genero el vector tiempo de la señal
t=(0:N-1)/Fs;

end