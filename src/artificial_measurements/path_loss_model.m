function [rssi] = PathLoss(x, distance)
    rssi_0 = x(1);
    alpha = x(2);
    rssi = rssi_0 - 10*alpha*log(distance);
end