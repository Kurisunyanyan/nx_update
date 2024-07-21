import os
import shutil
from datetime import datetime

directory = os.path.expanduser("~/flight_logs")
new_folder = os.path.join(directory, "new")
old_folder_prefix = os.path.join(directory, "old_")

folder_count = len([d for d in os.listdir(directory) if os.path.isdir(os.path.join(directory, d))])

print(f"The number of folders in {directory} is: {folder_count}")

new_old_folder_name = f"{old_folder_prefix}{folder_count}"

shutil.move(new_folder, new_old_folder_name)

os.mkdir(new_folder)

print(f"Moved contents of {new_folder} to {new_old_folder_name}")
