#!/bin/zsh

# 源文件夹
SRC_DIR="/home/nvidia/nx_update"
# 目标文件夹
DEST_DIR="/home/nvidia"
# 新的文件夹
NEW_DIR="$SRC_DIR/nx_ros_repo"
# 备份文件夹
BACKUP_CONFIG_DIR="$SRC_DIR/config"

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

# 解压当前文件夹内的 nx_ros_repo.zip 到 /home/nvidia/nx_update/nx_ros_repo
ZIP_FILE="./nx_ros_repo.zip"
if [ -f "$ZIP_FILE" ]; then
    echo "Unzipping $ZIP_FILE to $NEW_DIR..."
    unzip -q -o "$ZIP_FILE" -d "$NEW_DIR"
else
    echo "Error: $ZIP_FILE does not exist."
    exit 1
fi

# 创建备份配置文件夹
if [ ! -d "$BACKUP_CONFIG_DIR" ]; then
    mkdir -p "$BACKUP_CONFIG_DIR"
fi

# 备份 uav_id_config.yaml 文件到 /home/nvidia/nx_update/config/
UAV_ID_CONFIG_FILE="$NEW_DIR/src/cyber/launch_config/config/uav_id_config.yaml"
if [ -f "$UAV_ID_CONFIG_FILE" ]; then
    echo "Backing up $UAV_ID_CONFIG_FILE to $BACKUP_CONFIG_DIR..."
    cp "$UAV_ID_CONFIG_FILE" "$BACKUP_CONFIG_DIR/"
fi

# 备份原有的 nx_ros_repo 文件夹
CURRENT_TIME=$(date +"%Y%m%d_%H%M%S")
if [ -d "$NEW_DIR" ]; then
    echo "Backing up existing $NEW_DIR to ${NEW_DIR}_bak_$CURRENT_TIME..."
    mv "$NEW_DIR" "${NEW_DIR}_bak_$CURRENT_TIME"
fi



# 复制备份的 uav_id_config.yaml 文件到新的 nx_ros_repo 目录
BACKUP_UAV_ID_CONFIG_FILE="$BACKUP_CONFIG_DIR/uav_id_config.yaml"
NEW_UAV_ID_CONFIG_DIR="$NEW_DIR/src/cyber/launch_config/config"
if [ -f "$BACKUP_UAV_ID_CONFIG_FILE" ]; then
    echo "Copying $BACKUP_UAV_ID_CONFIG_FILE to $NEW_UAV_ID_CONFIG_DIR..."
    cp "$BACKUP_UAV_ID_CONFIG_FILE" "$NEW_UAV_ID_CONFIG_DIR/"
fi

# 移动 /home/nvidia/nx_update 文件夹内的所有内容到 /home/nvidia/
for file in "$SRC_DIR"/*; do
    echo "Moving $file to $DEST_DIR..."
    mv "$file" "$DEST_DIR"
done

echo "Setup complete."
