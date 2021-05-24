function [map] = mapping_16QAM(v1,v2)

    x(1).bit =[0 0];
    x(2).bit =[0 1];
    x(3).bit =[1 1];
    x(4).bit =[1 0];
    y(1).v = v1;
    y(2).v = v2;
    center = (4-1)/2 +1;
    for i = 1:4
        for j =1:4
            ind = ( i-1)*4 +j;
            map(ind).X = (i-center)/(abs(i-center))*y(fix(abs(i-center))+1).v;
            map(ind).Y = (j-center)/abs(j-center)*y(fix(abs(j-center))+1).v;
            map(ind).bit = [x(i).bit x(j).bit];
            phase =  atan2(map(ind).Y,map(ind).X) - atan2(0,1);
%             if ( phase < 0) 
%                 phase = phase + 2*pi;
%             end
           % phase = (phase/pi)*180;
            map(ind).phase = phase;
            map(ind).amp = sqrt(map(ind).X^2+map(ind).Y^2 );
            
        end
    end
      

end