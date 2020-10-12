function [caracteristicas]= extrCaract(senial,gainp,Fsp)

 load(senial) %Cargo las se�ales sanas con cada iteraci�n
 Fs=128;   
 sig=(val(1,:)-0)/gainp; %Paso a mv las se�ales sanas
    if Fsp~=128
        
    sig=resample(sig,128,Fsp);
    end
    N=length(sig); %Calculo la longitud de las se�ales sanas
    t=(0:N-1)/Fs; %Calculo el vector de tiempo para las se�ales sanas
    
    x=sig'; %Transpuesta de la se�al ecg
    
    
    %% FOURIER
    N=length(x);
    nFFT=2;
    while nFFT<N
        nFFT = nFFT*2;
    end
    P1=abs(fft(x,nFFT)); %Transformada corta de fourier
    
    f1=linspace(0,Fs,nFFT);
    
    [Pmax,Ppos]=max(P1); %Guardo las coordenadas de la potencia m�xima
    %% MATRIZ DE DATOS
    [bw,flo,fhi,powr] = obw(x,Fs);
    [mnfreq,pwr1] = meanfreq(x,Fs);
    [mdfreq,pwr2] = medfreq(x,Fs);
    caracteristicas=[];
    caracteristicas=[caracteristicas; Pmax f1(Ppos) bw powr mnfreq mdfreq];
end