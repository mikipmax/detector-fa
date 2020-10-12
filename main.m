clc;
clear;

try
    [filename,pathname]=uigetfile('*.mat*','Carga de Señal ECG');
    fprintf('Archivo: %s\nPath: %s\n',filename,pathname);
    if(filename~="")
        %%Cargamos la Señal
        senial=load(strcat(pathname,filename));
        inputData=["Frecuencia","Gain"];
        data=inputdlg(inputData,'Ingrese los Parámetros',[1 30]);
        
        Fs=str2double(data(1));
        Gain=str2double(data(2));
        
        
        %%Estandarizamos
        [t,ecg]=estandarizar(senial.val(1,:),Fs,0,Gain);
        t1=t;
        
        %%Complejo QRS
        [ecgP,Qx,Qy,Rx,Ry,Sx,Sy]=QRS(ecg,Fs);
        
        %%Segmento P
        t=(1:length(ecgP));
        
        [Px,Py]=P(ecgP,t,Rx,Fs);
        
        %%Graficamos señal original y la señal procesada
        plot(ecg)
        hold on
        plot(ecgP)
        hold off
        title("Señal Original vs Señal Procesada")
        legend('Señal Original','Señal Procesada');
        
        %%Graficamos la señal procesada con su complejo QRS
        
        figure
        plot(ecgP)
        hold on
        
        scatter(Qx,Qy,"kO","MarkerFaceColor","k")
        scatter(Rx,Ry,"rs","MarkerFaceColor","r")
        scatter(Sx,Sy,"cO","MarkerFaceColor","c")
        
        %Gráfica de los intervalos R-R
        dist=max(Ry)*1.25;
        % Rayas Verticales
        
        
        intRR=diff(Rx)/Fs;
        hold on
        for i=1:length(Rx)
            plot([Rx(i) Rx(i)],[Ry(i) dist*1.05],'k--','LineWidth',1)
            if i<length(Rx)
                text(Rx(i),dist*1.05,num2str(intRR(i)))
            end
        end
        % Raya Horizontal
        hold on
        
        
        plot([Rx(1) Rx(length(Rx))],[dist dist],'k--','LineWidth',1)
        
        
        %Graficamos la taquicardía
        
        
        tR=t1(Rx);
        % Intervalo Normal entre R-R
        % 60 bpm -> Intervalo R-R es 1 seg
        % 100 bpm -> Intervalo R-R es 0.6 seg
        delta_tR = zeros(length(Rx)-1,1);
        disp('====================================')
        disp('  INTERVALO DE TIEMPO R-R (Normal)  ')
        fprintf('60 lpm = 1 seg\n100 lpm = 0.6 seg\n')
        hold on
        for j=1:length(delta_tR)
            delta_tR(j)=tR(j+1)-tR(j);
            Fc=60*(1/delta_tR(j));% Frec. Card - Método Tradicional
            % Comprobamos si el Intervalo R-R está dentro del rango normal
            if(delta_tR(j)>=0.6 && delta_tR(j)<=1)
                interValor = 1;% Almacenamos 1=Intervalo Normal
                fprintf('Intervalo R-R = %0.5f >> NORMAL, FC = %d\n',delta_tR(j),round(Fc));
            elseif(delta_tR(j)<0.6) % Cuando el Intervalo R-R es <0.6 -> Taquicardia
                interValor = 2;% Almacenamos 2=Intervalo Taquicardia
                % Obtenemos las posiciones "x","y" de los Picos del Intervalo R-R
                yTaq=[Ry(j) Ry(j+1)];
                xTaq=[Rx(j) Rx(j+1)];
                fprintf('Intervalo R-R = %0.5f >> TAQUICARDIA, FC = %d\n',delta_tR(j),round(Fc));
                % Creamos una línea que une a cada Intervalo R-R y colocamos el
                % intervalo que posee
                plot(xTaq,yTaq,'r','LineWidth',1)
                % Graficamos los Picos R donde no cumplen en Intervalo R-R normal
                %gscatter(app.AxesDT,xTaq,yTaq)
                text(mean(xTaq(1))*1.035,mean(yTaq(1))*1.035,strcat("FC:",num2str(round(Fc))))
            elseif(delta_tR(j)>1) % Cuando Intervalo R-R es > 1 -> Bradicardia
                interValor = 3;% Alamacenamos 3=Intervalo Bradicardia
            end
            % Guardamos en un vector al intervalo y su característica Norm,Taq,Bra
            %intervaloRR(j,1:2)=[delta_tR(j),interValor];
        end
        
        
       %Px y Py son las coordenadas de los pico P, entonces si no hay picos
       %P y además en la gráfica debemos visualizar si en dicho segmento hay
       %taquicardía(Rectas color rojo) para decir que hay posible fibrilación auricular
        if ~isempty(Px) && ~isempty(Py)  
            %Graficamos pico P
            scatter(Px,Py,"mO","MarkerFaceColor","m");
            legend(app.AxesDT,"Señal Procesada","Q","R","S","P","Intervalo R-R")
 
        else
        
            disp("En esta señal presenta" + ...
                " ausencia de Pico P en ese instante de tiempo por eso" + ...
                " no se visualiza en la gráfica.");
            
            legend("Señal Procesada","Q","R","S","Intervalo R-R")
            
        end
        title("PQRS")
    end
catch
    
end