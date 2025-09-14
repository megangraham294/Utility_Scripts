#!/usr/bin/env python3

import os
import re
import argparse
from datetime import datetime, timedelta

#----------------------------------------------------------#
# Rename files by shifting embedded timestamps by N hours.
#
# Usage:
#   python3 renamegmt.py --path /path/to/files --hours -5
#
# Example (subtract 5 hours from data on a harddirve):
#   python3 renamegmt.py --path /Volumes/BatDrive/SomeFolder/ --hours -5
#----------------------------------------------------------#

def main():
    parser = argparse.ArgumentParser(description="Rename files by shifting timestamps.")
    parser.add_argument("--path", "-p", required=True, help="Path to the folder containing files.")
    parser.add_argument("--hours", "-H", type=int, required=True,
                        help="Number of hours to shift (negative for earlier, positive for later).")
    args = parser.parse_args()

    directory = args.path
    hours_shift = args.hours

    # regex to match timestamps like YYYYMMDD_HHMMSS
    pattern = re.compile(r"(\d{8})_(\d{6})")

    for filename in os.listdir(directory):
        match = pattern.search(filename)
        if match:
            date_str, time_str = match.groups()
            
            # Parse datetime
            dt = datetime.strptime(date_str + time_str, "%Y%m%d%H%M%S")
            
            # Shift time
            new_dt = dt + timedelta(hours=hours_shift)
            
            # Format back
            new_timestamp = new_dt.strftime("%Y%m%d_%H%M%S")
            
            # Replace old timestamp with new
            new_filename = pattern.sub(new_timestamp, filename)
            
            # Rename file
            old_path = os.path.join(directory, filename)
            new_path = os.path.join(directory, new_filename)
            os.rename(old_path, new_path)
            print(f"Renamed: {filename} → {new_filename}")

if __name__ == "__main__":
    main()
