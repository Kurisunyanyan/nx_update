#!/bin/zsh

# 检查是否提供了压缩包文件名后一半作为参数
if [ -z "$1" ]; then
    echo "Usage: $0 <zip_file_suffix>"
    exit 1
fi

# 设置文件路径
ZIP_FILE_SUFFIX="$1"
ZIP_FILE="/home/nvidia/nx_update_${ZIP_FILE_SUFFIX}.zip"
DEST_DIR="/home/nvidia/nx_update"
SCRIPT_NAME="execute_update.sh"

# 如果 update 文件夹存在，则删除它
if [ -d "$DEST_DIR" ]; then
    echo "Removing existing $DEST_DIR..."
    rm -rf "$DEST_DIR"
fi

# 检查 zip 文件是否存在
if [ -f "$ZIP_FILE" ]; then
    echo "Unzipping $ZIP_FILE to $DEST_DIR..."
    
    # 创建目标文件夹（如果不存在）
    mkdir -p "$DEST_DIR"
    
    # 解压 zip 文件到目标文件夹
    unzip -q -d "$DEST_DIR" "$ZIP_FILE" 
    
    # 检查解压后的脚本是否存在
    if [ -f "$DEST_DIR/$SCRIPT_NAME" ]; then
        echo "Executing $DEST_DIR/$SCRIPT_NAME..."
        
        # 赋予脚本执行权限
        chmod +x "$DEST_DIR/$SCRIPT_NAME"
        
        # 执行脚本
        "$DEST_DIR/$SCRIPT_NAME"
    else
        echo "Error: $SCRIPT_NAME not found in $DEST_DIR"
    fi
else
    echo "Error: $ZIP_FILE not found"
fi
