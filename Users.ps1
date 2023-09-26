 ### Admin rights opvragen ###
 
  if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`"  `"$($MyInvocation.MyCommand.UnboundArguments)`""
 Exit
}

### Module MSonline detecteren, anders installeren ###

    if (Get-Module -ListAvailable -Name MSonline) {
     Write-Host "MSOnline Module Is installed"
    pause
    } 
    else{
    
    
    Write-Host "Installing MSOnline lodule"
    Install-module MSonline
    
    }

### Connect to MSOnline ###

Connect-MsolService

### variabelen ####
$Domainname = Get-MsolDomain | Select-Object Name | Convert-String -Example "Name=trainingintune2508.onmicrosoft.com"="trainingintune2508.onmicrosoft.com"

### aanmaken users ###
New-MsolUser -UserPrincipalName ("david.chew@"+$domainname) -DisplayName "David Chew" -FirstName "David" -LastName "Chew" -UsageLocation "BE" -Department Sales
New-MsolUser -UserPrincipalName ("Bas.Schutte@"+$domainname) -DisplayName "Bas Schutte" -FirstName "Bas" -LastName "Schutte" -UsageLocation "BE" -Department Sales
New-MsolUser -UserPrincipalName ("Sander.Strauss@"+$domainname) -DisplayName "Sander Strauss" -FirstName "Sander" -LastName "Strauss" -UsageLocation "BE" -Department Sales
New-MsolUser -UserPrincipalName ("Teunis.hake@"+$domainname) -DisplayName "Teunis Hake" -FirstName "Teunis" -LastName "Hake" -UsageLocation "BE" -Department Sales
New-MsolUser -UserPrincipalName ("Lammert.Homan@"+$domainname) -DisplayName "Lammert Homan" -FirstName "Lammert" -LastName "Homan" -UsageLocation "BE" -Department Marketing
New-MsolUser -UserPrincipalName ("Tom.Ras@"+$domainname) -DisplayName "Tom Ras" -FirstName "Tom" -LastName "Ras" -UsageLocation "BE" -Department Marketing
New-MsolUser -UserPrincipalName ("Lammert.Kess@"+$domainname) -DisplayName "Lammert Kess" -FirstName "Lammert" -LastName "Kess" -UsageLocation "BE" -Department Marketing
New-MsolUser -UserPrincipalName ("Mariska.Cramp@"+$domainname) -DisplayName "Mariska Cramp" -FirstName "Mariska" -LastName "Cramp" -UsageLocation "BE" -Department Administratie
New-MsolUser -UserPrincipalName ("Marloes.VanRooy@"+$domainname) -DisplayName "Marloes Van Rooy" -FirstName "Marloes" -LastName "Van Rooy" -UsageLocation "BE" -Department Administratie
New-MsolUser -UserPrincipalName ("Paula.VanRooy@"+$domainname) -DisplayName "Paula Van Rooy" -FirstName "Paula" -LastName "Van Rooy" -UsageLocation "BE" -Department Administratie
New-MsolUser -UserPrincipalName ("Paulien.Tempel@"+$domainname) -DisplayName "Paulien Tempel" -FirstName "Paulien" -LastName "Tempel" -UsageLocation "BE" -Department Administratie
New-MsolUser -UserPrincipalName ("Willeke.Drayer@"+$domainname) -DisplayName "Willeke Drayer" -FirstName "Willeke" -LastName "Drayer" -UsageLocation "BE" -Department Administratie
New-MsolUser -UserPrincipalName ("Paulien.Goossen@"+$domainname) -DisplayName "Paulien Goossen" -FirstName "Paulien" -LastName "Goossen" -UsageLocation "BE" -Department Administratie

