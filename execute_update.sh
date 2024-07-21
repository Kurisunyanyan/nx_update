#!/bin/zsh

# 源文件夹
SRC_DIR="/home/nvidia/update"
# 目标文件夹
DEST_DIR="/home/nvidia"
# 压缩文件
ZIP_FILE="$SRC_DIR/nx_ros_repo.zip"
# 新的文件夹
NEW_DIR="/home/nvidia/nx_ros_repo"

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

# 解压 nx_ros_repo.zip 到 /home/nvidia/update
if [ -f "$ZIP_FILE" ]; then
    echo "Unzipping $ZIP_FILE to $SRC_DIR..."
    unzip -q -o "$ZIP_FILE" -d "$SRC_DIR"
else
    echo "Error: $ZIP_FILE does not exist."
    exit 1
fi

# 备份原有的 nx_ros_repo 文件夹
CURRENT_TIME=$(date +"%Y%m%d_%H%M%S")
if [ -d "$NEW_DIR" ]; then
    echo "Backing up existing $NEW_DIR to ${NEW_DIR}_bak_$CURRENT_TIME..."
    mv "$NEW_DIR" "${NEW_DIR}_bak_$CURRENT_TIME"
fi

# 移动 /home/nvidia/update 文件夹内的所有内容到 /home/nvidia/
for file in "$SRC_DIR"/*; do
    echo "Moving $file to $DEST_DIR..."
    mv "$file" "$DEST_DIR"
done

# 移动备份的 uav_id_config.yaml 文件到新的 nx_ros_repo 目录
if [ -f "${NEW_DIR}_bak_$CURRENT_TIME/src/cyber/launch_config/config/uav_id_config.yaml" ]; then
    echo "Moving ${NEW_DIR}_bak_$CURRENT_TIME/src/cyber/launch_config/config/uav_id_config.yaml to $NEW_DIR/src/cyber/launch_config/config/..."
    mv "${NEW_DIR}_bak_$CURRENT_TIME/src/cyber/launch_config/config/uav_id_config.yaml" "$NEW_DIR/src/cyber/launch_config/config/"
fi

echo "Setup complete."
