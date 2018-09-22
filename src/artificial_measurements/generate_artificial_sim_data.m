function [ground_truth, node_pos, edge_pdr, edge_wifi, rssi_measurement, ap_position] = generate_artificial_sim_data
% Generating artificial RSSI to Distance Function

[bt_esp.header, bt_esp.raw] = parse_bt( 'BLUETOOTH_ESP.csv' );

[bt_esp.coordinates, bt_esp.ref_removed, bt_esp.mean, bt_esp.std, bt_esp.refPoints_mean, bt_esp.refPoints_total, bt_esp.timestamp] = ... 
    calc_mean_std_bt( bt_esp.raw );

xstar_esp = rssi_distance_curve_fitting(bt_esp.refPoints_total, bt_esp.ref_removed);
plot_rssi_distance_curve(xstar_esp, bt_esp.refPoints_total, bt_esp.ref_removed, bt_esp.refPoints_mean, bt_esp.mean);

% Generating 3 AP
% AP_x = [x;y]
ap_1 = [-1; -1];
ap_2 = [12; 12];
ap_3 = [26; 26];
ap_4 = [-1; 26];
ap_5 = [26; -1];
ap_position = [ ap_1,ap_2,ap_3,ap_4,ap_5];

% Generating step length, direction and rssi measurements 
% pos_n = [delta_x; delta_y; delta_theta; rssi_1; rssi_2; rssi_3]

line_1 = [0:25;zeros(1,26)];
line_2 = [line_1,[25*ones(1,25);1:25]];
line_3 = [line_2, [24:-1:0; 25*ones(1,25)]];
line_4 = [line_3, [zeros(1,25); 24:-1:0]];
coordinate = [line_4, [0:25;zeros(1,26)]];

delta_pos = [];
theta = 0;
for i=2:size(coordinate,2)
    temp_delta_pos = coordinate(:,i) - coordinate(:,i-1);
    delta_pos = [delta_pos, temp_delta_pos];
    theta = [theta, atan2d(temp_delta_pos(2), temp_delta_pos(1))];
end

delta_theta = [];
for i=2:size(coordinate,2)
    delta_theta = [delta_theta, theta(:,i) - theta(:,i-1)];
end

ground_truth = [coordinate; theta];

% adding noise to the delta_pos and delta_theta

noisy_delta_coordinate = delta_pos + 0.1*rand(size(delta_pos));
noisy_delta_theta = delta_theta + 1*rand(size(delta_theta));

noisy_coordinate = [0;0];
noisy_theta = [90];
for i=1:size(noisy_delta_coordinate,2)
    noisy_coordinate = [noisy_coordinate, noisy_coordinate(:,i) + noisy_delta_coordinate(:,i)];
    noisy_theta = [noisy_theta, noisy_theta(:,i) + noisy_delta_theta(:,i)];
end


rssi_measurement = [];
% creating artificial rssi measurement
for i=1:size(coordinate,2)
    distance_to_ap_1 = norm(ap_1 - coordinate(:,i));
    rssi_1 = path_loss_model(xstar_esp, distance_to_ap_1);
    distance_to_ap_2 = norm(ap_2 - coordinate(:,i));
    rssi_2 = path_loss_model(xstar_esp, distance_to_ap_2);
    distance_to_ap_3 = norm(ap_3 - coordinate(:,i));
    rssi_3 = path_loss_model(xstar_esp, distance_to_ap_3);
    distance_to_ap_4 = norm(ap_4 - coordinate(:,i));
    rssi_4 = path_loss_model(xstar_esp, distance_to_ap_4);
    distance_to_ap_5 = norm(ap_4 - coordinate(:,i));
    rssi_5 = path_loss_model(xstar_esp, distance_to_ap_5);
    rssi_measurement = [rssi_measurement, [rssi_1; rssi_2; rssi_3; rssi_4; rssi_5]];
end

node_pos = [noisy_coordinate; noisy_theta; rssi_measurement];

edge_pdr = [];
for i = 1:size(noisy_delta_coordinate,2)
    edge_pdr(1,i) = i+1;
    edge_pdr(2,i) = i;
    edge_pdr(3:4,i) = noisy_delta_coordinate(:,i);
    edge_pdr(5,i) = noisy_delta_theta(i);
    
%     % convertin negative degress to positive
%     if edges_pdr(5,i) < 0
%         edges_pdr(5,i) = edges_pdr(5,i) + 360;
%     end
end

edge_wifi = [];
% distance_error_max = 20;
% distance_error_min = 5; 

correlation_results = 20 * ones(size(rssi_measurement,2), size(rssi_measurement,2));
for i = size(rssi_measurement,2):-1:1
    temp_correlation = [];
    for j = i-1:-1:1
        rssi_diff = norm(rssi_measurement(:,i) - rssi_measurement(:,j));
        correlation_results(i,j) = rssi_diff;
        if rssi_diff < 0.1
            % change wifi error later with max-min threshold style
            wifi_error = norm(coordinate(:,i) - coordinate(:,j));
            edge_wifi = [edge_wifi, [i; j; wifi_error]]; 
        end
    end
end

x_axis = 1:size(rssi_measurement,2);
figure
p0 = bar(x_axis(1:100), correlation_results(101,1:100));
title('RSSI History Correlation'); % set title

figure
imagesc(correlation_results); % plot the matrix
% set(gca, 'XTick', 1:size(correlation_results,2)); % center x-axis ticks on bins
% set(gca, 'YTick', 1:size(correlation_results,2)); % center y-axis ticks on bins
% set(gca, 'XTickLabel', x_axis); % set x-axis labels
% set(gca, 'YTickLabel', x_axis); % set y-axis labels
title('RSSI History Correlation'); % set title
colormap('jet'); % set the colorscheme
colorbar; % enable colorbar

figure
p1 = plot(coordinate(1,:),coordinate(2,:), 'k-o');
hold on
p2 = plot(ap_position(1,:), ap_position(2,:), 'b*');
title('Ground Truth Walking Path')
xlabel('x coordinates')
ylabel('y coordinates')
legend([p1 p2], 'Walking Path','Access Points')



% adding false-positive loop closure for testing robust graph-slam
false_positives = [...
    [62;12;0], ...
    [63;13;0], ...
    [64;14;0], ...
    [37;87;0], ...
    [38;88;0], ...
    [39;99;0], ...
    [2;1;0], ...
    [3;1;0], ...
    [4;1;0], ...
    [5;1;0], ...
    [6;1;0], ...
    [26;23;0], ...
    [28;27;0], ...
    [29;28;0], ...
    [29;26;0], ...
    [30;26;0], ...
    [52;50;0], ...
    [53;50;0], ...
    [54;50;0], ...
    [55;50;0], ...
    ];

figure
p3 = plot(noisy_coordinate(1,:),noisy_coordinate(2,:), 'k-o');
hold on
p4 = plot(ap_position(1,:), ap_position(2,:), 'b*');
for i=1:size(edge_wifi,2)
    x = [noisy_coordinate(1,edge_wifi(1,i)), noisy_coordinate(1,edge_wifi(2,i))];
    y = [noisy_coordinate(2,edge_wifi(1,i)), noisy_coordinate(2,edge_wifi(2,i))];
    p5 = plot(x, y, '-r');
end
title('Measured Walking Path')
xlabel('x coordinates')
ylabel('y coordinates')


for i=1:size(false_positives,2)
    x = [noisy_coordinate(1,false_positives(1,i)), noisy_coordinate(1,false_positives(2,i))];
    y = [noisy_coordinate(2,false_positives(1,i)), noisy_coordinate(2,false_positives(2,i))];
    p6 = plot(x, y, '-b');
end

legend([p3 p4 p5, p6], 'Walking Path','Access Points', 'True Positive Loop Closures', 'False Positive Loop Closures')

title('Artificial Measurements')
xlabel('x coordinates')
ylabel('y coordinates')

% adding false positives
edge_wifi = [false_positives, edge_wifi];

end