#!/bin/zsh

SRC_DIR="/home/nvidia/nx_update"
DEST_DIR="/home/nvidia"
FIRMWARE_DIR="/home/nvidia/nx_update/firmware"
BACKUP_CONFIG_DIR="/home/nvidia/nx_update/config"

# 检查源文件夹是否存在
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Source directory $SRC_DIR does not exist."
    exit 1
fi

# 检查目标文件夹是否存在
if [ ! -d "$DEST_DIR" ]; then
    echo "Error: Destination directory $DEST_DIR does not exist."
    exit 1
fi

# 检查 flight_logs 文件夹是否存在
FLIGHT_LOGS_DIR="$DEST_DIR/flight_logs"
if [ ! -d "$FLIGHT_LOGS_DIR" ]; then
    echo "Creating $FLIGHT_LOGS_DIR directory..."
    mkdir "$FLIGHT_LOGS_DIR"
fi

# 检查 flight_logs/new 文件夹是否存在
NEW_FLIGHT_LOGS_DIR="$FLIGHT_LOGS_DIR/new"
if [ ! -d "$NEW_FLIGHT_LOGS_DIR" ]; then
    echo "Creating $NEW_FLIGHT_LOGS_DIR directory..."
    mkdir "$NEW_FLIGHT_LOGS_DIR"
fi

if [ ! -d "$FIRMWARE_DIR" ]; then
    echo "Creating $FIRMWARE_DIR directory..."
    mkdir "$FIRMWARE_DIR"
fi
# 解压当前文件夹内的 nx_ros_repo.zip 到 /home/nvidia/nx_update/firmware
ZIP_FILE="/home/nvidia/nx_update/nx_ros_repo.zip"
if [ -f "$ZIP_FILE" ]; then
    echo "Unzipping $ZIP_FILE to $FIRMWARE_DIR..."
    unzip -q -o "$ZIP_FILE" -d "$FIRMWARE_DIR"
else
    echo "Error: $ZIP_FILE does not exist."
    exit 1
fi

# 创建备份配置文件夹
if [ ! -d "$BACKUP_CONFIG_DIR" ]; then
    mkdir -p "$BACKUP_CONFIG_DIR"
fi

# 备份 uav_id_config.yaml 文件到 /home/nvidia/nx_update/config/
UAV_ID_CONFIG_FILE="$FIRMWARE_DIR/src/cyber/launch_config/config/uav_id_config.yaml"
if [ -f "$UAV_ID_CONFIG_FILE" ]; then
    echo "Backing up $UAV_ID_CONFIG_FILE to $BACKUP_CONFIG_DIR..."
    cp "$UAV_ID_CONFIG_FILE" "$BACKUP_CONFIG_DIR/"
fi

# 备份原有的 nx_ros_repo 文件夹
CURRENT_TIME=$(date +"%Y%m%d_%H%M%S")
if [ -d "$FIRMWARE_DIR" ]; then
    echo "Backing up existing $FIRMWARE_DIR to ${FIRMWARE_DIR}_bak_$CURRENT_TIME..."
    mv "$FIRMWARE_DIR" "${FIRMWARE_DIR}_bak_$CURRENT_TIME"
fi

# 复制 /home/nvidia/nx_update/script/ 的内容到 /home/nvidia/
SCRIPT_DIR="$SRC_DIR/script"
if [ -d "$SCRIPT_DIR" ]; then
    echo "Copying contents of $SCRIPT_DIR to $DEST_DIR..."
    cp -r "$SCRIPT_DIR"/* "$DEST_DIR"
else
    echo "Error: $SCRIPT_DIR does not exist."
    exit 1
fi

# 复制 /home/nvidia/nx_update/firmware/nx_ros_repo 到 /home/nvidia
FIRMWARE_DIR="$SRC_DIR/firmware/nx_ros_repo"
if [ -d "$FIRMWARE_DIR" ]; then
    echo "Copying $FIRMWARE_DIR to $DEST_DIR..."
    cp -r "$FIRMWARE_DIR" "$DEST_DIR"
else
    echo "Error: $FIRMWARE_DIR does not exist."
    exit 1
fi

# 复制备份的 uav_id_config.yaml 文件到新的 nx_ros_repo 目录
BACKUP_UAV_ID_CONFIG_FILE="$BACKUP_CONFIG_DIR/uav_id_config.yaml"
NEW_UAV_ID_CONFIG_DIR="$DEST_DIR/nx_ros_repo/src/cyber/launch_config/config"
if [ -f "$BACKUP_UAV_ID_CONFIG_FILE" ]; then
    echo "Copying $BACKUP_UAV_ID_CONFIG_FILE to $NEW_UAV_ID_CONFIG_DIR..."
    cp "$BACKUP_UAV_ID_CONFIG_FILE" "$NEW_UAV_ID_CONFIG_DIR/"
fi

echo "Setup complete."
