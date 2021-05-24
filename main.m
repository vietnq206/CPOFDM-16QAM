
clear;
clc;
v1 = 1;
v2 = 3;
nBit = 1024;
lSymbol = 4;
nChannel = 4;
baseFreq = 100; % 1Hz
tSymbol = nChannel/baseFreq; % time for one symbol
nSymbol = nBit/(nChannel*lSymbol);
bitSequence = bit_generate(nBit);

mapQAM = mapping_16QAM(v1,v2);

for k = 1:nBit/lSymbol
    rInd = fix((k-1)/nChannel) +1;
    cInd = k-(rInd-1)*nChannel;
    fr = (k-1)*lSymbol +1;
    bSymbol(rInd,cInd).bit = bitSequence(fr:fr+lSymbol-1);  
end

fBase = 100; %100Hz for base frequence
fFirst = 200; %500Hz for first channel
Fs = 1024;
rTg = 1/8; %Ratio of guard 
Tsym = 1/fBase;
Tg = Tsym*rTg;
Tsig = nSymbol*(Tsym+Tg);

bSymbol = generateSymbolWave(bSymbol,mapQAM,fBase,fFirst,rTg,Fs);
 
sOFDM = [];
for k=1:nSymbol
    tmpSignal = 0;
    for j= 1:nChannel
        tmpSignal = tmpSignal + bSymbol(k,j).symbol;
    end
    sOFDM = [sOFDM tmpSignal];
end

%sOFDM is the signal CP-OFDM
% figure(1);
% dt = 1/(fBase*Fs);
% t=(0:length(sOFDM)-1)*dt;
% plot(t,sOFDM);
% title('Signal CP-OFDM');
% xlabel('Time [s]');
% ylabel('Amplitude');


fftOFDM = fft(sOFDM);
fftOFDM = fftshift(fftOFDM);
freq = (-length(sOFDM)/2:length(sOFDM)/2-1)*fBase;



% figure(2);
% plot(freq, 2*abs(fftOFDM)/Fs);
% title('Spectrum of sine');
% xlabel('Frequency [Hz]');
% ylabel('Amplitude');
%  

% figure(3);
  pOFDM = sOFDM.^2;
% plot(t, 10*log10(pOFDM));
% title('Power of CP-OFDM signal');
% xlabel('Time [s]');
% ylabel('Power [dB]');
 

powerOFDM = 0;
for k= 1: length(pOFDM)
    powerOFDM = powerOFDM + pOFDM(k);
    
end
powerOFDM = powerOFDM/length(pOFDM);
snr_lin = 10^(5/10);    % 5dB
var = powerOFDM/snr_lin;
%var =2000;
noise = (var/sqrt(2))*(randn(1,length(sOFDM)) +i*randn(1,length(sOFDM)));
sOFDM_fft = fft(sOFDM) + noise*Fs/2;
%sOFDM = sOFDM + abs(noise);
sOFDM = ifft(sOFDM_fft);                  %add noise into signal

% figure(4);
% 
% plot(t,noise);
% title('Signal CP-OFDM with Gaussian noise');
% xlabel('Time [s]');
% ylabel('Amplitude');


sorted_noise = sort(abs(noise));
dx = 0:0.001:20;
count =1;
Fx = zeros(1,length(dx));

k=1;
while ( k<= length(sorted_noise))
    if count <length(dx)
        if sorted_noise(k)<=dx(count)
        Fx(count)= Fx(count) +1; 
        k = k+1;
        else 
            count = count +1;
            Fx(count) = Fx(count-1);
        end
    else
        Fx(count)= Fx(count) +1; 
        k=k+1;
    end
    
    
end
Fx = Fx./length(sorted_noise);

dx1 = 0:0.1:20;
Px = zeros(1,length(dx1));
Px(1) = Fx(100)/(dx(100));
for k = 2:length(dx1)-2
    Px(k) =(Fx(k*100)-Fx((k-1)*100))/(dx(k*100)-dx((k-1)*100));
end


figure(5);
subplot(2,1,1);
plot(dx,Fx);
title(' Cumulative distribution function');
xlabel('Value');
ylabel('F(x)');

subplot(2,1,2);
plot(dx1,Px);
title('Probability density function ');
xlabel('Value');
ylabel('P(x)');



%Send Signal
% fileID = fopen('OFDM_signal.txt','w');
% fprintf(fileID,'%d\n',fBase);
% fprintf(fileID,'%d\n',fFirst);
% fprintf(fileID,'%d\n',nChannel);
% fprintf(fileID,'%f\n',Tsig);
% 
% fprintf(fileID,'%f\n',sOFDM);
% fclose(fileID); 





signal = sOFDM;
sigSymbol = length(signal)/nSymbol;
lTg = sigSymbol-sigSymbol/(1+rTg);




for j = 1:nSymbol
   k = (j-1)*sigSymbol+1;
   sigOFDM(j).symbol=signal(k:k+sigSymbol-1); 
end


%cutting CP part
bitseq =[];
for k = 1:nSymbol
   sigOFDM(k).initSymbol=sigOFDM(k).symbol(lTg+1:length(sigOFDM(k).symbol));
   sigOFDM(k).fft = fft(sigOFDM(k).initSymbol).*2/Fs;
   for j=1:nChannel
       tBit(k,j).data = sigOFDM(k).fft(fFirst/fBase+j);
       tBit(k,j).bit =decoding16QAM(tBit(k,j).data,mapQAM);
       bitseq = [bitseq tBit(k,j).bit];
    end
end


figure(1);
plot16QAM(mapQAM);
hold on;
for k = 1:nSymbol
   for j=1:nChannel
   rBit = real(tBit(k,j).data);
   iBit = -imag(tBit(k,j).data);
   plot(iBit,rBit,'r*');
   hold on;
   end
end
   




% tmp = sigOFDM(1).initSymbol;
% dftm = fft(tmp);
% 2*abs(dftm)/1024;
% checkAmp = 2*abs(dftm)/1024;
% checkphase = angle(dftm);
% tmpSignal = 0;
% for j= 1:nChannel
% tmpSignal = tmpSignal + bSymbol(1,j).symbol;
% end
% tmpSignal = tmpSignal(129:1152);
% dft2 = fft(tmpSignal);
% check2Amp = 2*abs(dft2)/1024;
% check2phase = angle(dft2);
% 

tam =0;
for k=1:length(noise)
  tam = tam + abs(noise(k));
end
 
