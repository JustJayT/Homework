# PowerShell script to set up the notification script
$scriptPath = "C:\Users\$env:USERNAME\AppData\Roaming\notification_script.py"
$batchPath = "C:\Users\$env:USERNAME\AppData\Roaming\run_notification_script.bat"
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\run_notification_script.bat"

# Create the Python script
$pythonScript = @"
import time
import os

def show_message():
    try:
        time.sleep(30)  # Wait for 30 seconds
        message = 'This is a message to show the script execution.'
        file_path = os.path.expandvars(r'%APPDATA%\message.txt')
        with open(file_path, 'w') as file:
            file.write(message)
        os.system(f'notepad.exe "{file_path}"')
    except Exception as e:
        error_log_path = os.path.expandvars(r'%APPDATA%\notification_error.log')
        with open(error_log_path, 'a') as log_file:
            log_file.write(f"Error: {e}\n')

if __name__ == "__main__":
    show_message()
"@
$pythonScript | Out-File -FilePath $scriptPath -Force

# Create the batch file
$batchFile = @"
@echo off
pythonw "$scriptPath"
"@
$batchFile | Out-File -FilePath $batchPath -Force

# Copy the batch file to the startup folder
Copy-Item -Path $batchPath -Destination $startupPath -Force
