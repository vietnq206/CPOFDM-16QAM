function [bit] = decoding16QAM(data,map)

    rData = real(data);
    iData = -imag(data);

    min = 99999;
    k=1;
    for i =1:length(map)
       value = sqrt((rData-map(i).Y)^2 +(iData-map(i).X)^2);
       if ( value < min)
            min = value;
            k =i;
       end
    end
    bit = map(k).bit;
   
end