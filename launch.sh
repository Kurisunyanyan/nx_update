#!/bin/bash

# Function to check the exit status of the previous command
check_status() {
  if [[ $? -ne 0 ]]; then
    echo "$1"
    exit 1
  fi
}

# Source .bashrc if it exists
if [[ -f /home/nvidia/.bashrc ]]; then
  source /home/nvidia/.bashrc
else
  echo "/home/nvidia/.bashrc not found"
  exit 1
fi

# Run log_clean.py
python3 /home/nvidia/log_clean.py
check_status "Failed to run log_clean.py"

# Run log_swap.py
python3 /home/nvidia/log_swap.py
check_status "Failed to run log_swap.py"

# Start ROS core
roscore &
check_status "Failed to start ROS core"
ROS_PID=$!

# Run launch_main.sh
sh /home/nvidia/launch_main.sh
check_status "Failed to run launch_main.sh"

# Wait for background processes to finish
wait $ROS_PID
