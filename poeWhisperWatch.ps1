# Load Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Get the path to the user's Documents folder
$documentsPath = [System.Environment]::GetFolderPath("MyDocuments")
$configFolderPath = Join-Path -Path $documentsPath -ChildPath "PoEWhisperMonitor"

# Create the folder if it doesn't exist
if (-not (Test-Path -Path $configFolderPath)) {
    New-Item -ItemType Directory -Path $configFolderPath
}

# Set the full path for the config file
$configFilePath = Join-Path -Path $configFolderPath -ChildPath "config.json"

# Function to load saved configuration
function Load-Config {
    if (Test-Path $configFilePath) {
        return Get-Content -Path $configFilePath | ConvertFrom-Json
    } else {
        # First-time run welcome message
        [System.Windows.Forms.MessageBox]::Show(
            "Welcome to PoE Whisper Monitor! This tool will help you monitor whispers in Path of Exile and send them to your Discord webhook. Please provide your webhook URL and log file location to get started.",
            "Welcome",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
        return @{
            WebhookUrl = ""
            LogFilePath = ""
        }
    }
}

# Function to save configuration
function Save-Config {
    param (
        [string]$WebhookUrl,
        [string]$LogFilePath
    )
    $config = @{
        WebhookUrl = $WebhookUrl
        LogFilePath = $LogFilePath
    }
    $config | ConvertTo-Json -Depth 1 | Set-Content -Path $configFilePath
}

# Function to send a webhook notification
function Send-WebhookNotification {
    param (
        [string]$WebhookUrl,
        [string]$Message
    )
    $body = @{
        content = $Message
    } | ConvertTo-Json -Depth 1
    Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $body -ContentType 'application/json'
}

# Load existing configuration
$config = Load-Config

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "PoE Whisper Monitor"
$form.Size = New-Object System.Drawing.Size(500, 350)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(40, 44, 52)
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Label Style
$labelStyle = @{
    ForeColor = [System.Drawing.Color]::White
    Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
}

# Webhook URL Label
$labelWebhook = New-Object System.Windows.Forms.Label
$labelWebhook.Text = "Discord Webhook URL:"
$labelWebhook.Location = New-Object System.Drawing.Point(20, 20)
$labelWebhook.Size = New-Object System.Drawing.Size(200, 30)
$labelWebhook | ForEach-Object { $_.ForeColor = $labelStyle.ForeColor; $_.Font = $labelStyle.Font }
$form.Controls.Add($labelWebhook)

# Webhook URL TextBox
$textboxWebhook = New-Object System.Windows.Forms.TextBox
$textboxWebhook.Location = New-Object System.Drawing.Point(20, 50)
$textboxWebhook.Size = New-Object System.Drawing.Size(440, 25)
$textboxWebhook.Text = $config.WebhookUrl
$form.Controls.Add($textboxWebhook)

# Log File Label
$labelLogFile = New-Object System.Windows.Forms.Label
$labelLogFile.Text = "Log File Location:"
$labelLogFile.Location = New-Object System.Drawing.Point(20, 90)
$labelLogFile.Size = New-Object System.Drawing.Size(200, 30)
$labelLogFile | ForEach-Object { $_.ForeColor = $labelStyle.ForeColor; $_.Font = $labelStyle.Font }
$form.Controls.Add($labelLogFile)

# Log File TextBox
$textboxLogFile = New-Object System.Windows.Forms.TextBox
$textboxLogFile.Location = New-Object System.Drawing.Point(20, 120)
$textboxLogFile.Size = New-Object System.Drawing.Size(340, 25)  # Adjusted width to fit the Browse button
$textboxLogFile.Text = $config.LogFilePath
$form.Controls.Add($textboxLogFile)

# Browse Button
$buttonBrowse = New-Object System.Windows.Forms.Button
$buttonBrowse.Text = "Browse..."
$buttonBrowse.Location = New-Object System.Drawing.Point(375, 120)  # Adjusted to align with the text box
$buttonBrowse.Size = New-Object System.Drawing.Size(85, 25)
$buttonBrowse.BackColor = [System.Drawing.Color]::FromArgb(58, 62, 71)
$buttonBrowse.ForeColor = [System.Drawing.Color]::White
$buttonBrowse.FlatStyle = "Flat"
$form.Controls.Add($buttonBrowse)

# Start Button
$buttonStart = New-Object System.Windows.Forms.Button
$buttonStart.Text = "Start Monitoring"
$buttonStart.Location = New-Object System.Drawing.Point(20, 180)
$buttonStart.Size = New-Object System.Drawing.Size(200, 40)
$buttonStart.BackColor = [System.Drawing.Color]::FromArgb(72, 79, 89)
$buttonStart.ForeColor = [System.Drawing.Color]::White
$buttonStart.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$buttonStart.FlatStyle = "Flat"
$form.Controls.Add($buttonStart)

# Pause Button
$buttonPause = New-Object System.Windows.Forms.Button
$buttonPause.Text = "Pause Monitoring"
$buttonPause.Location = New-Object System.Drawing.Point(260, 180)
$buttonPause.Size = New-Object System.Drawing.Size(200, 40)
$buttonPause.BackColor = [System.Drawing.Color]::FromArgb(72, 79, 89)
$buttonPause.ForeColor = [System.Drawing.Color]::White
$buttonPause.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$buttonPause.FlatStyle = "Flat"
$form.Controls.Add($buttonPause)

# Status Label
$labelStatus = New-Object System.Windows.Forms.Label
$labelStatus.Text = ""
$labelStatus.Location = New-Object System.Drawing.Point(20, 240)
$labelStatus.Size = New-Object System.Drawing.Size(440, 30)
$labelStatus.ForeColor = [System.Drawing.Color]::LightGreen
$form.Controls.Add($labelStatus)

# Browse Button Click Event
$buttonBrowse.Add_Click({
    $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $fileDialog.Filter = "Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
    if ($fileDialog.ShowDialog() -eq "OK") {
        $textboxLogFile.Text = $fileDialog.FileName
    }
})

# Start and Pause Button State Variables
$isPaused = $false

# Start Button Click Event
$buttonStart.Add_Click({
    if ($isPaused) {
        $labelStatus.Text = "Monitoring resumed..."
        $isPaused = $false
    } else {
        $webhookUrl = $textboxWebhook.Text
        $logFilePath = $textboxLogFile.Text

        if (-not [string]::IsNullOrWhiteSpace($webhookUrl) -and (Test-Path $logFilePath)) {
            Save-Config -WebhookUrl $webhookUrl -LogFilePath $logFilePath
            $labelStatus.Text = "Monitoring started..."
            $labelStatus.ForeColor = [System.Drawing.Color]::LightGreen

            # Send start notification to Discord
            Send-WebhookNotification -WebhookUrl $webhookUrl -Message "**PoE Whisper Monitor has started successfully!**"

            $lastWhisper = ""
            while (-not $isPaused) {
                if (Test-Path $logFilePath) {
                    $newLine = Get-Content -Path $logFilePath -Tail 1
                    if ($newLine -match "@From" -and $newLine -ne $lastWhisper) {
                        $lastWhisper = $newLine
                        $matches = [regex]::Match($newLine, "@From (.*?): (.*)")
                        if ($matches.Success) {
                            $sender = $matches.Groups[1].Value
                            $message = $matches.Groups[2].Value
                            Send-WebhookNotification -WebhookUrl $webhookUrl -Message "**New Whisper Received**`n**From:** $sender`n**Message:** $message"
                        }
                    }
                }
                Start-Sleep -Seconds 5
            }
        } else {
            $labelStatus.Text = "Please enter valid inputs!"
            $labelStatus.ForeColor = [System.Drawing.Color]::Red
        }
    }
})

# Pause Button Click Event
$buttonPause.Add_Click({
    $isPaused = $true
    $labelStatus.Text = "Monitoring paused..."
})

# Show the form
$form.ShowDialog()
