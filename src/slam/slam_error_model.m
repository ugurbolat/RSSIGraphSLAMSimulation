function [residuals] = slam_error_model(predicted_pos, edges_pdr, edges_wifi)

residuals = [];
pdr_errors = [];
wifi_errors = [];

for i = 1:size(edges_pdr,2)
    pdr_errors = [pdr_errors, edges_pdr(3:4,i) - (predicted_pos(1:2,i+1)-predicted_pos(1:2,i))];
end
% residuals = sum(pdr_errors.^2,2);
% residuals_delta_x = (pdr_errors(1,:)').^2;
% residuals_delta_y = (pdr_errors(2,:)').^2;
residuals_delta_x = (pdr_errors(1,:)');
residuals_delta_y = (pdr_errors(2,:)');


distance_error_max = 20;
distance_error_min = 5; 
for i = 1:size(edges_wifi,2)
%     loop_closure_pos_distance = norm(predicted_pos(1:2,edges_wifi(1,i)) - predicted_pos(1:2,edges_wifi(2,i)));
%     if  loop_closure_pos_distance < distance_error_min
%         wifi_error = 0 ;
%     elseif loop_closure_pos_distance > distance_error_max
%         wifi_error = distance_error_max - distance_error_min;
%     else
%         wifi_error = (loop_closure_pos_distance - distance_error_min)/(distance_error_max - distance_error_min);
%     end
    wifi_errors = [wifi_errors, norm(predicted_pos(1:2,edges_wifi(1,i)) - predicted_pos(1:2,edges_wifi(2,i)))];
end

% residuals_delta_wifi = (wifi_errors').^2;
residuals_delta_wifi = (wifi_errors');
residuals = [residuals_delta_x; residuals_delta_y; residuals_delta_wifi];


end