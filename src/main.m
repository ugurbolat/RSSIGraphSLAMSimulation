clear
close all

addpath('artificial_measurements');
addpath('device_measurements');
addpath('pdr');
addpath('slam');

%% Testing with artificial measurments

[ground_truth, node_pos, edge_pdr, edge_wifi, rssi_measurement, ap_position] = generate_artificial_sim_data;

% initial_pos = zeros(size(pos));
initial_pos = node_pos(1:2,:);

lb = zeros(size(initial_pos));
% lb = [];
ub = [];

% testing slam error model with init_pos
residuals = slam_error_model(initial_pos, edge_pdr, edge_wifi);

f = @(x) slam_error_model(x, edge_pdr, edge_wifi);

options = optimoptions('lsqnonlin','Algorithm','Levenberg-Marquardt',...
    'Diagnostics','on','Display','iter-detailed',...
    'TolFun', 1e-6, 'MaxIter', 1000, 'MaxFunEvals', 10000 );

[xstar] = lsqnonlin(f,initial_pos,lb,ub,options);

temp_x = zeros(size(xstar));
temp_x(1,:) = xstar(1,1);
temp_x(2,:) = xstar(2,1);
slam_result = xstar - temp_x;

figure
p1 = plot(node_pos(1,:),node_pos(2,:),'k.-');
hold on
plot(ap_position(1,:), ap_position(2,:), 'b*');
p2 = plot(slam_result(1,:),slam_result(2,:),'r.-');
p3 = plot(ground_truth(1,:),ground_truth(2,:),'.-');
title('SLAM Results')
legend([p1 p2 p3], 'Before SLAM', 'After SLAM', 'Ground Truth');
