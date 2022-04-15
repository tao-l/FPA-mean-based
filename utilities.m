function us = utilities(vs, bs)
n = length(vs); 
us = vs;
maxb = max(bs);
num = sum(bs == maxb);
for i = 1:n
    if bs(i) == maxb
        us(i) = (vs(i) - bs(i)) / num;
    else
        us(i) = 0;
    end
end
end
