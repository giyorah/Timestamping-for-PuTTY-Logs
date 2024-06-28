# Streamlined Timestamping for PuTTY Logs

This mini-project was created to address the inconvenience of PuTTY not providing native timestamps on its log entries. It includes a PowerShell script and a batch file designed to add timestamps to each log entry, creating a chronological record. Additionally, the script manages the associated process to ensure proper termination.

## Features

- **Real-time Monitoring:** Continuously monitors a specified log file for new entries.
- **Timestamp Insertion:** Adds precise timestamps to the beginning of each log entry.
- **Dual Output:** Writes timestamped entries to both a new log file and the console for immediate visibility.
- **Process Management:** Automatically starts the specified application and gracefully terminates it when monitoring ends.

## Requirements

- **Windows Operating System:** This tool is specifically designed for Windows environments.
- **PowerShell:** Ensure you have PowerShell installed/enabled on your system.

## Files

- **`TimestampingLogMonitor.ps1`:** The core PowerShell script responsible for log monitoring, timestamping, and process management.
- **`TLM Launcher.bat`:** A batch file that streamlines the execution of the PowerShell script and related cleanup tasks.

## How to Use

1. **Clone/Download:** Clone this repository or download the files to your local machine.

2. **Execute:** Double-click `TLM Launcher.bat`, follow the instructions and start the monitoring process:
    - You will be prompted to enter the directory where the shourcut to PuTTY's stored session and its associated log file are located.
   - The timestamped log file (`ts_log.txt`) will be created in the same directory.

4. **Exit:** Press `Ctrl+C` in the console window to stop monitoring. The application will be terminated gracefully, taking care to terminate the associated PuTTY process.

## Configuration

You can customize the following settings in `TimestampingLogMonitor.ps1`:

- **`$timestampFormat`:** Modify the format of the timestamps (default: "yyyy-MM-dd HH:mm:ss").
- **`$checkInterval`:** Adjust the interval (in seconds) between log file checks (default: 1 second).

## Contributing

Contributions and improvements are welcome! Feel free to fork this repository and submit pull requests.

## License

This project is licensed under the MIT License.