Add-WindowsFeature Web-Server
Add-Content -Path "C:\inetpub\wwwroot\Default.htm" -Value $($env:computername)
New-Item -ItemType directory -Path "C:\inetpub\wwwroot\video"
$videovalue = "Video: " + $($env:computername)
Set-Content -Path "C:\inetpub\wwwroot\video\test.htm" -Value $videovalue