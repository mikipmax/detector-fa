function [t,x_out] = mV_seg(x_in,Fs,base,gain)

% Funci�n que estandariza la se�al a mV vs Segundos
% VARIABLES DE ENTRADA
%   x_in -> Se�al x_out original
%   Fs -> Frecuencia de muestreo de la se�al
%   base -> Base de la se�al, tomada del .info
%   gain -> Gain de la se�al, tomada del .info
% VARIABLES DE SALIDA

% IMPLEMENTACI�N DE LA ESTANDARIZACI�N

% Tomo el primer canal de la se�al
x_out = x_in; %aqu� puede seleccionar el canal que desea analizar(si hubiera m�s de 1 canal)

% Ponemos la se�al en segundos vs mv
x_out=(x_out-base)/gain;

% Tama�o de la se�al
N=length(x_out);

% Genero el vector tiempo de la se�al
t=(0:N-1)/Fs;

end