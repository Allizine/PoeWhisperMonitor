# PoE Whisper Monitor

**PoE Whisper Monitor** is a PowerShell-based tool designed to help **Path of Exile** players monitor their in-game whispers and send them directly to a **Discord webhook** for real-time notifications. This tool features a clean, user-friendly GUI with pause/resume functionality, configuration file management, and system notifications.

## 📋 **Features**
- Real-time monitoring of **Path of Exile whispers**.
- Sends **Discord webhook notifications** for each new whisper.
- **Pause/Resume functionality** to control monitoring.
- **Browse button** to select your log file location.
- **Configuration saved** in the user's Documents folder.
- Sends a **confirmation message** to the Discord webhook to notify that the script is running.

---

## ⚙️ **Requirements**
- Windows OS
- PowerShell (5.1 or later)
- Discord Webhook URL

---

## 🚀 **How to Use**

### 1. **Clone the Repository**
Clone the repository to your local machine:
```bash
git clone https://github.com/your-username/PoEWhisperMonitor.git
```

### 2. **Run the Script**
Open PowerShell and navigate to the directory containing the `PoEWhisperMonitor.ps1` file.

Run the script:
```powershell
.\PoEWhisperMonitor.ps1
```

### 3. **Configure the Tool**
When the tool launches:
1. Enter your **Discord Webhook URL**.
2. Click **Browse** to select the **Path of Exile log file** (typically located at `Documents\My Games\Path of Exile\logs\Client.txt`).
3. Click **Start Monitoring** to begin.

### 4. **Pause and Resume Monitoring**
You can pause and resume the monitoring process using the **Pause Monitoring** button.

---

## 📂 **Configuration File**
The tool saves your webhook URL and log file location in a configuration file located in:
```
Documents\PoEWhisperMonitor\config.json
```
This file will be automatically created and updated by the tool.

---

## 🔔 **Discord Notifications**
The tool sends a message to your configured Discord webhook when:
- The tool starts.
- A new whisper is detected.

### **Example Notification:**
```
**New Whisper Received**
**From:** Allizine
**Message:** This player is AFK.
```
---

## 💡 **Troubleshooting**
### **No UI Appears**
Ensure that you are using PowerShell 5.1 or later and running the script from an elevated PowerShell session.

### **Webhook URL is Not Working**
Ensure that the **Discord webhook URL** is correct and active.

### **Log File Not Found**
Make sure that you have selected the correct **Client.txt** log file from your Path of Exile directory.

---

## 📖 **How It Works**
1. The tool monitors the **Client.txt** file for new whispers.
2. When a new whisper is detected, it extracts the sender and message.
3. The tool sends a formatted message to your **Discord webhook**.
4. It also sends a **confirmation message** when the tool starts.

---

## 🖌️ **UI Overview**
| Element          | Description                            |
|------------------|----------------------------------------|
| Webhook URL      | Enter your Discord webhook URL.        |
| Log File Location| Browse and select your log file.       |
| Start Monitoring | Starts the whisper monitoring process. |
| Pause Monitoring | Pauses the monitoring process.         |
| Status Label     | Displays the current status of the tool.|

---

---

## 🤝 **Contributing**
Contributions are welcome! Please open an issue or submit a pull request for any changes you would like to make.

---

## 📧 **Contact**
If you have any questions or feedback, feel free to reach out at:
- **GitHub:** [Allizne](https://github.com/Allizine)
- **Discord:** Allizine

