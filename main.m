clear;clc;

%% 载入仿真数据
cd data;
initData;
cd ..;

%% 前期处理

[dim,~] = size(anchor);      % 维度
[anch, node] = size(netsa);  % 锚点 anch 和节点

netss = [netss,netsa'];                        % 拼接为  20*24                
netss = [netss;netsa,zeros(anch,anch)];        % 扩宽    24*24

%% 计算跳数，保存路径

step = zeros(anch,node+anch);                  % 最小跳数矩阵
path = zeros(anch,node+anch);                  % 路径矩阵

for i = 1:anch
    for j =1:node
        if netsa(i,j) ~= 0
            step(i,j) = 1;                     % 与锚点直接相连的未知节点 Hop=1
        end
    end
end

s=1;         % 为宽度遍历作准备                                

while(true)
    temp = step;                                                       % 临时矩阵用来判断是否更新完毕
    for i = 1:anch                                                     % 4 个锚点分别广播
        for j =1:(node+anch)    
            for k = 1:(node+anch)
                if step(i,j) == s && netss(j,k) ~= 0 && step(i,k) == 0 % 遍历未知的点
                    path(i,k) = j;                                     % 存储当前结点的上一节点
                    step(i,k) = s + 1;                                 % 与当前层相连的赋值到下一层
                end
            end
        end
    end
    if isequal(temp, step)
        break;                                                         % 最小跳数计算完成跳出循环
    end
    s = s + 1;
end

for i = 1:anch
    step(i,node+i)=0;                      % 手动校正
end

%% 估计路径
dist = zeros(anch, node + anch);                                    

for i = 1 : anch
    for j = 1 :(node + anch)
        tmp_j = j;
        while(true)
            k = path(i, tmp_j);
            if(k == 0) 
                dist(i,j) = dist(i,j) + netsa(i,tmp_j);
                break;
            end
            dist(i,j) = dist(i, j) + netss(k, tmp_j);
            tmp_j = k;
        end
    end
end

%% 利用估计距离定位

xy = zeros(node,dim);       % 坐标           

for i = 1:node
    A = zeros(anch-1,dim);
    B = zeros(anch-1,1);
    
    for j = 1 : anch-1
        for k = 1:dim
            A(j,k) = 2 * (anchor(k,j)-anchor(k,anch)); % x y z
            B(j) = B(j) + anchor(k,j)^2 - anchor(k, anch)^2;
        end
        B(j) = B(j) + dist(anch,i)^2-dist(j,i)^2;
    end
    C = A\B;
    xy(i,1) = C(1);
    xy(i,2) = C(2);
end

accuracy;  % 计算并显示相对精度

%% 迭代

for k = 1:5
     for i = 1 : node
         x = xy(i,:);
         x = fminsearch(@(x)fun(i,x,xy,anchor,netss,netsa),x);  % 迭代函数
         xy(i,:) = x;
     end
end

 %% 绘制结果图
 
if(dim == 2)  % 二维图
    plot(anchor(1,:),anchor(2,:), '*r');
    hold on;
    plot(xy(:,1),xy(:,2),'ob');
    hold on;
    plot(sensors(:,1),sensors(:,2),'*g');
    legend('参考节点坐标','未知节点估计坐标','未知节点实际坐标');
else          % 三维图
    plot3(anchor(1,:),anchor(2,:),anchor(3,:), '*b');
    hold on;
    plot3(xy(:,1),xy(:,2),xy(:,3),'or');
    %hold on;
    %plot3(sensors(:,1),sensors(:,2),sensors(:,3),'*b');
end

accuracy;  % 计算并显示相对精度