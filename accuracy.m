%% 计算相对精度
num = 0;        
err = 0;
for i = 1 : node
    for j = i+1 : node
        if(netss(i,j) ~= 0)
            num = num + 1;
            sum = 0;
            for k = 1:dim       % 求欧式距离的平方
                sum = sum + (xy(i,k)-xy(j,k))^2;
            end
            err = err + abs(sqrt(sum) - netss(i,j));
        end
    end
end

err = err/num;
disp(err/0.4);