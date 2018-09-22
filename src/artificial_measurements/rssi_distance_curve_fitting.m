function [xstar] = rssi_distance_curve_fitting(distances, rssi_measurements)

indexes = ~isnan(rssi_measurements);
rssi_measurements = rssi_measurements(indexes);
distances = distances(indexes);

f = @(x, d) path_loss_model(x,d);

x0 = [-77; 2];

options = optimoptions('lsqcurvefit','Algorithm','Levenberg-Marquardt','Diagnostics','on','Display','iter-detailed');
[xstar,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(f,x0,distances,rssi_measurements,[],[],options);

end