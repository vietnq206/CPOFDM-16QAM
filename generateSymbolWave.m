function [bSymbol] = generateSymbolWave(bSymbol,mapQAM,fBase,fs,rTg,N)

sSym = size(bSymbol);
sMap = size(mapQAM);

Tsym= 1/fBase;

dt = Tsym/N;
t=0:dt:Tsym-dt;

nTg = N - N * rTg;


for i = 1:sSym(1)
    for j = 1:sSym(2)
        bit = bSymbol(i,j).bit;
        for k = 1:sMap(2)
            if mapQAM(k).bit == bit 
                fq = (j-1)*fBase+fs;                             %Generate frequence by channel
                phase = mapQAM(k).phase;                        % mapping to phase
                wSymbol = mapQAM(k).amp*sin(2*pi*fq*t + phase);  %Generate signal of symbol
                gSymbol = wSymbol(nTg+1:N);                     %Generate guard
                 bSymbol(i,j).phase = phase;
                bSymbol(i,j).symbol = [gSymbol wSymbol];        %Generate carrier signal
                break
            end
        end
        
            
    end
    

end
end

