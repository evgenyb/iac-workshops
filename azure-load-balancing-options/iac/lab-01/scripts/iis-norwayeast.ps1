Add-WindowsFeature Web-Server
Set-Content -Path "C:\inetpub\wwwroot\Default.htm" -Value $($env:computername)
New-Item -ItemType directory -Path "C:\inetpub\wwwroot\images"
$imagevalue = "Images: " + $($env:computername)
Set-Content -Path "C:\inetpub\wwwroot\images\test.htm" -Value $imagevalue
