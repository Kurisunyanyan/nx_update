#!/bin/bash
tmux kill-server
# python3 /home/nvidia/launch_cyber.py -n uav -max_aspd 33.0 -min_aspd 27.0 -acc_r 300.0 -l_time 300.0 -e_hdg 5.0 -c_lost 5.0 -alt_t 30.0 -alt_m 50.0 -g_l 300.0 -hitl -at 
python3 /home/nvidia/launch_cyber.py -n uav -e_hdg 5.0 -c_lost 5.0 -gcs_lost 300.0 -l_time 300.0 -acc_r 300.0 -max_aspd 33.0 -min_aspd 27.0 -alt_low 1450.0 -alt_high 1700.0 -hitl -at -debug_mode 
