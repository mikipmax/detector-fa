function [ecgP,Qx,Qy,Rx,Ry,Sx,Sy]=QRS(ecg,Fs)
    %% PREPROCESAMIENTO Y DETECCIÓN DEL COMPLEJO QRS
    % La función DetQRS permite obtener el complejo QRS, para ello realiza un
    % preprocesamiento de la señal, aplicando filtros para suavizado y para
    % quitar la tendencia de la señal.
    [q,s,ry,rx,ecgP]=DetQRS(ecg,Fs);
    %Genero un vector de tiempo en samples
    %%
    % Realizamos un Algoritmo de corrección y Ajuste del segmento Q-S
    qx=q(1,:); %Guardo la coordenada en x del pico Q
    qy=q(2,:); %Guardo la coordenada en y del pico Q
    sx=s(1,:); %Guardo la coordenada en x del pico S
    sy=s(2,:); %Guardo la coordenada de y en el pico S
    vecQx=[]; %Vector para guardar las coordenadas x del pico Q
    vecQy=[]; %Vector para guardar las coordenadas y del pico Q
    vecSx=[]; %Vector para guardar las coordenadas x del pico S
    vecSy=[]; %Vector para guardar las coordenadas y del pico S

    % Colocamos un bloque de excepciones para evitar errores
    try   
        for i=1:length(rx) %Recorro los picos R en x

            % PARA EL Q
            % Esto se implementó porque hay veces que se detecta más de un pico
            % Q en un intervalo R-R, dado que hay veces que el pico Q se hace
            % más grande que un S

            % Filtro todos los picos Q en "x" que tengo a la izquierda de cada 
            % pico R en "x"
            q_temp_izq=qx(find(qx<rx(i))); 
            % Puede darse el caso de que no haya un pico Q a la izquierda
            % entonces valido que no este vacio para evitar errores
            if ~isempty(q_temp_izq)
                % Obtengo la posición del último pico Q en y que este a lado 
                % del R en "y"
                posQy= qy(length(q_temp_izq)); 
                % Obtengo la posición del último pico Q en "x" que este a lado 
                % del pico R en "x"
                q_final=q_temp_izq(length(q_temp_izq)); 
            end
            % Filtro todos los picos S en "x" que tengo a la derecha de cada
            % pico R en "x"
            s_temp_izq=sx(find(sx<rx(i))); 
            % Puede darse el caso de que no haya un pico S a la izquierda
            % entonces valido que no este vacio para evitar errores
            if ~isempty(s_temp_izq)  
                % Obtengo la posición del último pico S en "y" que este a lado
                % del R en "y"
                posQy1= sy(length(s_temp_izq)); 
                % Obtengo la posición del último pico S en "x"
                s_final=s_temp_izq(length(s_temp_izq));
            end
            % Comprobamos si los vectores son vacíos y si los valores del
            % q_final y s_final
            if (~isempty(q_temp_izq) && ~isempty(s_temp_izq)) && q_final<s_final         
                q_final=s_final;
                posQy=posQy1;
            end

            % PARA EL S

            q_temp_der=qx(find(qx>rx(i)));
            if ~isempty(q_temp_der)
                [mins,pos]=min(q_temp_der);           
                q_final1=q_temp_der(pos);
            end

            s_temp_der=sx(find(sx>rx(i)));
            if ~isempty(s_temp_der)
                [mins1,pos1]=min(s_temp_der);
                s_final1=s_temp_der(pos1);
            end    
            % Comprobamos si los vectores son vacíos y si los valore del
            % q_final y s_final
            if (~isempty(q_temp_der) && ~isempty(s_temp_der)) && q_final1>s_final1
                q_final1=s_final1;   
            end
            % Asignamos a los vectores que contendrán los respectivos valores
            % de cada Q-R-S
            vecQx=[vecQx q_final];
            vecQy=[vecQy posQy];     
            vecSx=[vecSx q_final1];

        end
        % Colocamos los valores "y" del pico S
        for i=1:length(vecSx)
            a=find(qx==vecSx(i));
            b=find(sx==vecSx(i));
            if ~isempty(a) && isempty(b)
                vecSy=[vecSy qy(a)];
            end
            if isempty(a) && ~isempty(b)
                vecSy=[vecSy sy(b)];
            end
            a=[];
            b=[];
        end
        % Graficamos la señal con el respectivo Complejo QRS
%         figure, plot(t,ecg)
%         hold on,scatter(rx,ry,'o');
%         hold on,scatter(vecQx,vecQy,'mx');
%         hold on,scatter(vecSx,vecSy,'g*');
          Qx=vecQx;Qy=vecQy;
          Rx=rx;Ry=ry;
          Sx=vecSx;Sy=vecSy;
    catch
        % Graficamos la señal con el respectivo Complejo QRS
%         figure, plot(t,ecg)
%         hold on,scatter(rx,ry,'go');
%         hold on,scatter(qx,qy,'mx');
%         hold on,scatter(sx,sy,'g*');
          Qx=qx;Qy=qy;
          Rx=rx;Ry=ry;
          Sx=sx;Sy=sy;
    end
end