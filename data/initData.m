clear;clc;
radio = 0.4;                      % 通信半径
anchor = [-0.3, -0.3, 0.3, 0.3; -0.3, 0.3, -0.3, 0.3];  % 4 个锚点坐标需要手动设置，放在四个角落
sensors = -0.5 + 1.0*rand(20,2);       % 随机散布未知节点

% 计算锚点和其周围的未知节点的距离
netsa = zeros(4,20);
for i = 1 :4
    for j = 1:20
        dist = norm([sensors(j,1) sensors(j,2)]-[anchor(1,i) anchor(2,i)]);
        if(dist < radio)
            netsa(i,j) = dist;        % 记录通信半径内的邻居节点
        end
    end
end

% 计算未知节点之间的距离
netss = zeros(20,20);
for i = 1:20
    for j = 1:20
        dist = norm([sensors(j,1) sensors(j,2)]-[sensors(i,1) sensors(i,2)]); 
        if(dist < radio)
            netss(i,j) = dist;
        end
    end
end

% 作图查看
% plot(anchor(1,:),anchor(2,:), '*r');    % 画锚点
% hold on;
% plot(sensors(:,1),sensors(:,2),'ob');     % 画未知节点的坐标
% legend('参考节点','未知节点')

