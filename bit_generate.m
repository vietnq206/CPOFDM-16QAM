function s = bit_generate(k)
s = [];
if mod(k,2) == 1
    msg = 'Length of sequence should be multiples of 2';
    error(msg);
end
    
data_1 = ones(1,k/2);
index_1 = k/2;

data_0 = zeros(1,k/2);
index_0 = k/2;


while (index_1 > 0 || index_0 > 0)
    if(randi(2)-1 == 1)
        if(index_1 > 0)
            s = [s data_1(index_1)];
            index_1 = index_1 -1;
        end
    else
        if(index_0 > 0)
            s = [s data_0(index_0)];
            index_0 = index_0 -1;
        end        
    end
    
        
end

end

