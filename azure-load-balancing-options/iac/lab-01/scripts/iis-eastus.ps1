Add-WindowsFeature Web-Server
Set-Content -Path "C:\inetpub\wwwroot\Default.htm" -Value $($env:computername)
New-Item -ItemType directory -Path "C:\inetpub\wwwroot\videos"
$videovalue = "Videos: " + $($env:computername)
Set-Content -Path "C:\inetpub\wwwroot\videos\test.htm" -Value $videovalue