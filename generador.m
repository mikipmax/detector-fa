function generador()
load('matriz2Entrenar.mat')
%Pasamos de una tabla a una matriz
matCat=table2array(matriz2Entrenar);

ejeXSano=[]; %Vector para el eje X de las se�ales sanas
ejeYSano=[]; %Vector para el eje Y de las se�ales sanas
ejeXAF=[]; %Vector para el eje X de las se�ales con Fibrilaci�n
ejeYAF=[]; %Vector para el eje Y de las se�ales con Fibrilaci�n
for i=1:length(matCat) %Recorro cada se�al
    
    
    
    
    if i>30 %si es mayor a 30 significa que las dem�s son se�ales con fibrilaci�n y les pongo 1 como clasificador
        
        ejeXAF=[ejeXAF matCat(i,3)]; %A�ado el ancho de banda de cada se�al con fibrilaci�n
        ejeYAF=[ejeYAF matCat(i,5)]; %A�ado la media de la frecuencia de cada se�al con fibrilaci�n
    else
        ejeXSano=[ejeXSano matCat(i,3)]; %A�ado el ancho de banda de cada se�al sana
        ejeYSano=[ejeYSano matCat(i,5)]; %A�ado la media de la frecuencia de cada se�al sana
    end
    
    
    
end


modelo=trainClassifier(matriz2Entrenar); %Este m�todo fue autogenerado luego de usar el toolbox
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