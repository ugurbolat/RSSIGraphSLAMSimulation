function plot_rssi_distance_curve(xstar, refPoints_total, rssi, refPoints_mean, rssi_mean)

figure
plot(refPoints_total, rssi,'.');
hold on
plot(refPoints_mean, rssi_mean,'k.','MarkerSize',13);

f = @(x, d) path_loss_model(x,d);
temp_distance = linspace(0.1,8,1000);
temp_rssi = f(xstar,temp_distance);
plot(temp_distance, temp_rssi,'r-');

end