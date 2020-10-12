function [Px,Py]=P(ecg,t,rx,Fs)
%% UBICACIÓN DE LA ONDA P

% Obtenemos los picos R y retrocedemos un rango máximo de 200 ms
ddf=[];

for i=1:length(rx)
    % convertimos ms a samples
    p_r_max=rx(i)-(200/1000)*Fs;
    p_r_min=rx(i)-(120/1000)*Fs;
    % Buscamos aquellos que están dentro del rango 0.12seg-0.20seg
    ad=find(t>=p_r_max & t<=p_r_min);
    dfd=max(ecg(ad));
    if dfd>=0.075
        ddf=[ddf [t(find(ecg==dfd)) dfd]'];
    end
end

% Verificamos si está vacío
if ~isempty(ddf)
    %hold on,
    %scatter(ddf(1,:),ddf(2,:),'*k');
    rangoP=[];
    Rangos=[];
    px=(ddf(1,:));% Ubicamos posición en "x"
    py=(ddf(2,:));% Ubicamos posición en "y"
    for i=1:length(px)
        rangoP=[rangoP; ((px(i))-40):1:px(i) (px(i)+1:1:px(i)+40)];
        % %Creo un rango que engloba cada pico P en un rango de [-40 40]
    end
    adx=[];
    adx1=[];
    
    for i=1:length(px)
        %subplot(6,5,i),findpeaks(ecg(rangoP(i,:)),t(rangoP(i,:)))
        %Imprime cada una de las ondas P
        ecg(px(i))+0.005;
        ecg(px(i)+1);
        if ecg(px(i))+0.005<ecg(px(i)-1)
            adx=[adx i];
        end
        ecg(px(i))+0.005;
        ecg(px(i)-1);
        if ecg(px(i))+0.005<ecg(px(i)+1)
            adx1=[adx1 i];
        end
    end
    
    bandera=0;
    
    if ~isempty(adx1)
        px(adx1)=[];
        py(adx1)=[];
        bandera=1;
    end
    
    if ~isempty(adx) && bandera==0
        px(adx)=[];
        py(adx)=[];
    end
    %hold on,scatter(px,py,'kO','MarkerFaceColor','k');
    Px=px;
    Py=py;
else
    Px=[];
    Py=[];
end

end