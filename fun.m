function f = fun(i, x, xy, anchor, netss, netsa)  % º∆À„∑Ω≤Ó
    [~,dim] = size(x);                       
    [anch, node] = size(netsa);
    f = 0;
    for j = 1 : node
        if(netss(i,j) ~= 0 )
            square_sum = 0;
            for k = 1 : dim
               square_sum = square_sum + (x(k) - xy(j,k))^2;
            end
             f = f + (sqrt(square_sum) - netss(i,j))^2;
        end
    end
    for j = 1 : anch
        if(netsa(j, i) ~= 0)
            square_sum = 0;
            for k = 1 : dim
               square_sum = square_sum + (x(k) - anchor(k,j))^2;
            end
            f = f + (sqrt(square_sum) - netsa(j,i))^2;
        end
    end
end
