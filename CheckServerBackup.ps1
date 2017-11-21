# Author : Alexis D
#
# Backup and send report using PowerShell and Windows Server Backup feature
# 
# Remember to set a scheduled task to execute this script on trigger of Microsoft-Windows-Backup\Operational source Backup eventID 14 (backup completed)

#####
#Modify this
#####
$sender="backup@domain.tld"
$recipient="alerts@domain.tld"
$mailServer="mta@domain.tld"
################################

$date=Get-Date -Format yyyy.M.d
$job=Get-WBJob -Previous 1
$backupDuration=(New-TimeSpan -Start $job.StartTime -End $job.EndTime).ToString()

$mailBody=@"
Backup date : $date
Duration : $backupDuration
$mailBody+="Success log :`n"+(Get-content $job.SuccessLogPath)
"@

If($job.HResult -eq 0){
    $backupState="Backup successful"
    $mailPriority=Low
}

elif($job.JobState -ne 0){
    $backupState="Backup failed or incomplete"
    $mailPriority=High
    $mailBody+="Error log :`n"+(Get-content $job.FailureLogPath)
}

Send-MailMessage -From $sender -To $recipient -Subject "$backupState on $ENV:ComputerName" -SmtpServer $mailServer -Priority $mailPriority -Body $mailBody