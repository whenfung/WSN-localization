function f = fun(i, x, xy, anchor, netss, netsa)  % 计算方差
    [~,dim] = size(x);            % 维度，二维还是三维
    [anch, node] = size(netsa);   % 锚点和未知节点的数量
    f = 0;
    for j = 1 : node              % 两网络的未知节点之间的距离平方差
        if(netss(i,j) ~= 0 )
            square_sum = 0;
            for k = 1 : dim
               square_sum = square_sum + (x(k) - xy(j,k))^2;
            end
             f = f + (sqrt(square_sum) - netss(i,j))^2;
        end
    end
    for j = 1 : anch              % 两网络的未知节点和锚点之间的距离平方差
        if(netsa(j, i) ~= 0)
            square_sum = 0;
            for k = 1 : dim
               square_sum = square_sum + (x(k) - anchor(k,j))^2;
            end
            f = f + (sqrt(square_sum) - netsa(j,i))^2;
        end
    end
end
