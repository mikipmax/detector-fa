function generador()
load('matriz2Entrenar.mat')
%Pasamos de una tabla a una matriz
matCat=table2array(matriz2Entrenar);

ejeXSano=[]; %Vector para el eje X de las señales sanas
ejeYSano=[]; %Vector para el eje Y de las señales sanas
ejeXAF=[]; %Vector para el eje X de las señales con Fibrilación
ejeYAF=[]; %Vector para el eje Y de las señales con Fibrilación
for i=1:length(matCat) %Recorro cada señal
    
    
    
    
    if i>30 %si es mayor a 30 significa que las demás son señales con fibrilación y les pongo 1 como clasificador
        
        ejeXAF=[ejeXAF matCat(i,3)]; %Añado el ancho de banda de cada señal con fibrilación
        ejeYAF=[ejeYAF matCat(i,5)]; %Añado la media de la frecuencia de cada señal con fibrilación
    else
        ejeXSano=[ejeXSano matCat(i,3)]; %Añado el ancho de banda de cada señal sana
        ejeYSano=[ejeYSano matCat(i,5)]; %Añado la media de la frecuencia de cada señal sana
    end
    
    
    
end


modelo=trainClassifier(matriz2Entrenar); %Este método fue autogenerado luego de usar el toolbox
%Classification learner
%Se envia a entrenar con el modelo Quadratic SVM
%Cuyos predictores son x: ancho de banda e y: media de la frecuencia
assignin("base","ejeXAF",ejeXAF);
assignin("base","ejeYAF",ejeYAF);
assignin("base","ejeXSano",ejeXSano);
assignin("base","ejeYSano",ejeYSano);
assignin("base","matriz2Entrenar",matriz2Entrenar);
assignin("base","modelo",modelo);
end