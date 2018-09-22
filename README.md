# RSSI-based Graph SLAM Simulation Environment

This repo surves as an initial matlab prototype for Graph SLAM system.

For futher explaination, I refers reader to the research paper [report](https://github.com/ugurbolat/SmartphoneGraphSLAM/blob/master/report/report.pdf), where I also implement a Robust SLAM algorithm with real-world measurement.

## RSSI-Distance Relationship

The measurements are collected from ESP-32 BLE Beacon.

![alt text](fig/rssi-distance.jpg)

## Ground Truth Trajectory

Artificially created ground truth walking path surrounded by 5 RSSI-based access point.

![alt text](fig/groun_truth_walking_path.jpg)

## Loop Closures with RSSI matches

Low values corresponds to loop closures.

![alt text](fig/rssi_history_correlation.jpg)

## Measured (Drifted) Trajectory - 1

Artificially created measured walking path for the same ground truth trajectory with loop closures.

![alt text](fig/measured_walking_path.jpg)

## SLAM Optimization Results - 1

This optimization's results are from previous measurements that has only true positive loop closures.

![alt text](fig/slam_results.jpg)

## Measured Trajectory with False Positives - 2

Several false positive loop closures added.

![alt text](fig/measured_walking_path_false_pos.jpg)

## SLAM Optimization Results - 2

If there are false positive loop closures, the LM method cannot converge to a desired local minimum.

![alt text](fig/slam_results_false_pos.jpg)

