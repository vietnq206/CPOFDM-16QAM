clear;
clc;
fileID = fopen('OFDM_signal.txt','r');
formatSpec = '%f';
fBase  = fscanf(fileID,'%d\n',1);
fFirst = fscanf(fileID,'%d\n',1);
nChannel = fscanf(fileID,'%d\n',1);
Tsig = fscanf(fileID,'%f\n',1);
sizeS = [1 Inf];
signal = fscanf(fileID,formatSpec,sizeS);


rTg = 1/8;
nSymbol = 64;
sigSymbol = length(signal)/nSymbol;
lTg = sigSymbol-sigSymbol/(1+rTg);
for i = 1:nSymbol
   k = (i-1)*sigSymbol+1;
   sOFDM(i).symbol=signal(k:k+sigSymbol-1); 
end


%cutting CP part

for i = 1:nSymbol
   sOFDM(i).initSymbol=sOFDM(i).symbol(lTg+1:length(sOFDM(i).symbol)); 
end


