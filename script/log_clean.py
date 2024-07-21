import os
import shutil
from datetime import datetime

LOG_DIR = "/home/nvidia/flight_logs"
MAX_SIZE = 30 * 1024 * 1024 * 1024  # 30GB

def get_directory_size(directory):
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(directory):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            total_size += os.path.getsize(fp)
    return total_size

def main():
    current_size = get_directory_size(LOG_DIR)
    
    if current_size > MAX_SIZE:
        old_dirs = [d for d in os.listdir(LOG_DIR) if d.startswith('old_')]
        old_dirs.sort(key=lambda x: int(x.split('_')[-1]))

        if old_dirs:
            # 删除所有的 old 文件夹
            for dir_name in old_dirs:
                dir_path = os.path.join(LOG_DIR, dir_name)
                shutil.rmtree(dir_path)
            
            print(f"{datetime.now()}: Log directory exceeded 30GB. All 'old' folders have been deleted.")
        else:
            print(f"{datetime.now()}: Log directory exceeded 30GB, but no old folders to delete.")
    else:
        print(f"{datetime.now()}: Log directory size is within limits.")

if __name__ == "__main__":
    main()
