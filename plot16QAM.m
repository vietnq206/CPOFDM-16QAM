function plot16QAM(map)
    
    for i = 1:length(map)
       plot(map(i).X,map(i).Y,'b');
       str = sprintf('%d%d%d%d',map(i).bit);
       text(map(i).X,map(i).Y,str);
       hold on;
       
    end

    grid on;

end