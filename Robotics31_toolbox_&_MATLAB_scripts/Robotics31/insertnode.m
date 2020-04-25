function queueOut = insertnode(queue, node)

n = length(queue);

i1 = 1;
i2 = n;

while 1
    i = floor((i1 + i2) / 2);
    
    if i == i1
        if node.cost > queue(i).cost
            if i2 > i
                if node.cost > queue(i2).cost
                    queueOut = [queue(1:i2); node; queue(i2+1:n)];
                else
                    queueOut = [queue(1:i); node; queue(i+1:n)];
                end
            else
                queueOut = [queue(1:i); node; queue(i+1:n)];
            end
        else
            queueOut = [queue(1:i-1); node; queue(i:n)];
        end
        
        return
    end             
    
    if node.cost > queue(i).cost
        i1 = i;
    else
        i2 = i;
    end      
end
