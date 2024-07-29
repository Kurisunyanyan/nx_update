import argparse
import subprocess
import os
import yaml

def run_command(command):
    try:
        subprocess.run(command, check=True, shell=True)
    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {e}")

def read_uav_id_from_yaml(file_path):
    if not os.path.exists(file_path):
        print(f"YAML config file ({file_path}) doesn't exist.")
        exit(1)
    with open(file_path, 'r') as file:
        config = yaml.safe_load(file)
        return config.get('uav_id', 1)  # Default to 1 if uav_id is not in the file

# Read uav_id from the YAML configuration file
yaml_config_path = "/home/nvidia/nx_ros_repo/src/cyber/launch_config/config/uav_id_config.yaml"
uav_id = read_uav_id_from_yaml(yaml_config_path)

# Parse arguments
parser = argparse.ArgumentParser(description="Drone configuration and launch script.")
parser.add_argument("-at", "--attach", action="store_true", help="Attach tmux window")
parser.add_argument("-r", "--record_rosbag", action="store_true", help="Record ROS bag")
parser.add_argument("-d", "--start_mission", action="store_true", help="Mission")
parser.add_argument("-f", "--flight_test", action="store_true", help="Flight test")
parser.add_argument("-hitl", "--hitl_test", action="store_true", help="Hitl test")
parser.add_argument("-m", "--mavros", action="store_true", help="Enable mavros")

parser.add_argument("-debug_mode", "--debug_mode", action="store_true", help="debug_mode")

parser.add_argument("-n", "--drone_namespace", type=str, default="drone", help="Drone namespace")

parser.add_argument("-max_aspd", "--max_airspeed", type=float, default=35.0, help="Max airspeed")
parser.add_argument("-min_aspd", "--min_airspeed", type=float, default=26.0, help="Min airspeed")

parser.add_argument("-alt_t", "--takeoff_alt", type=float, default=50.0, help="Takeoff altitude")
parser.add_argument("-alt_m", "--mission_alt", type=float, default=50.0, help="Mission altitude")

parser.add_argument("-alt_low", "--alt_low", type=float, default=50.0, help="Mission altitude")
parser.add_argument("-alt_high", "--alt_high", type=float, default=50.0, help="Mission altitude")
parser.add_argument("-alt_constrain", "--alt_constrain", type=int, default=0, help="Mission altitude constrain")

parser.add_argument("-acc_r", "--accept_radius", type=float, default=300.0, help="Accept radius")
parser.add_argument("-l_time", "--loiter_time", type=float, default=300.0, help="Loiter duration time")
parser.add_argument("-e_hdg", "--heading_error", type=float, default=10.0, help="Assemble heading error")
parser.add_argument("-c_lost", "--communication_lost", type=float, default=5.0, help="Max communication lost")
parser.add_argument("-gcs_lost", "--gcs_lost", type=float, default=300.0, help="Max gcs lost")
parser.add_argument("-s_log", "--save_log", type=int, default=0, help="Save control frame log")
parser.add_argument("-d_en", "--debug_info_enable", type=int, default=0, help="Enable debug info")

args = parser.parse_args()

# Override the uav_id with the one from the YAML file
args.uav_id = uav_id

# Print all settings
print("Configuration Settings:")
print(f"Mission: {args.start_mission}")

def bool2str(bool_value):
    return "true" if bool_value else "false"

print("Running on real hardware")
ns = f"{args.drone_namespace}{args.uav_id - 1}"
fcu_url = f"udp://:14550@192.168.144.20{args.uav_id}:14540"
print(f"Drone Namespaces: {ns}")

tmux_ns = f"real_{args.uav_id}"
tmuxinator_config = "cyber.yml"

if not os.path.exists(tmuxinator_config):
    print(f"Project config ({tmuxinator_config}) doesn't exist.")
    exit(1)
command = (
    f"tmuxinator start -n {tmux_ns} -p {tmuxinator_config} "
    f"drone_namespace={ns} uav_id={args.uav_id} "
    f"hitl={bool2str(args.hitl_test)} "
    f"min_airspeed={args.min_airspeed} max_airspeed={args.max_airspeed} "
    f"alt_low={args.alt_low} alt_high={args.alt_high} alt_constrain={args.alt_constrain} "
    f"accept_radius={args.accept_radius} "
    f"loiter_time={args.loiter_time} "
    f"gcs_lost={args.gcs_lost} "
    f"communication_lost={args.communication_lost} "
    f"heading_error={args.heading_error} "
    f"save_log={args.save_log} "
    f"debug_info_enable={args.debug_info_enable} "
    f"debug_mode={bool2str(args.debug_mode)} "
    f"flight_test={bool2str(args.flight_test)} "
    f"mavros={bool2str(args.mavros)} "
    f"fcu_url={fcu_url} "
    f"mission_alt={args.mission_alt} "
    f"takeoff_alt={args.takeoff_alt} "
)

print(f"Running command: {command}")
run_command(command)

if args.attach:
    run_command(f"tmux attach-session -t {tmux_ns}:mission")
