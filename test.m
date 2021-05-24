clear;
clc
Fs = 10240; % sampling rate of 1000 Hz
    t = 0:1/Fs:0.1-1/Fs;
    x = 0.2*sin(2*pi*300*t+1.15) + 0.1*sin(2*pi*100*t+2.14)  ;
    xdft = fft(x);
    %xdft = xdft(1:length(x)/2+1);
    DF = 100*Fs/length(x) % frequency increment
    freqvec = 0:DF:100*Fs-DF;
    plot(freqvec,2*abs(xdft)/Fs);
    
    
    x1 = 2*abs(xdft)/Fs;
    
    x2 = angle(xdft);