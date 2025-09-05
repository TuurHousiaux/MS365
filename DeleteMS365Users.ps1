# Ensure Microsoft.Graph.Users module is installed
$requiredModules = @("Microsoft.Graph.Users", "Microsoft.Graph.Identity.DirectoryManagement", "microsoft.graph.directoryObjects")
foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing module: $module"
        Install-Module $module -Scope CurrentUser -Force
    } else {
        Write-Host "Module already installed: $module"
    }
}

# Import Graph module
Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Identity.DirectoryManagement
Import-Module microsoft.graph.directoryObjects

# Connect to Microsoft Graph with required scopes
Connect-MgGraph -Scopes "User.ReadWrite.All", "Domain.Read.All", "Directory.AccessAsUser.All"

# Export domain list using Microsoft Graph (simulate previous Get-MsolDomain behavior)
$domainName = Get-MgDomain | Select-Object -ExpandProperty Id

# User definitions
$users = @(
    @{ FirstName = "David"; LastName = "Chew"; Department = "Sales"; },
    @{ FirstName = "Bas"; LastName = "Schutte"; Department = "Sales"; },
    @{ FirstName = "Sander"; LastName = "Strauss"; Department = "Sales"; },
    @{ FirstName = "Teunis"; LastName = "Hake"; Department = "Sales"; },
    @{ FirstName = "Lammert"; LastName = "Homan"; Department = "Marketing"; },
    @{ FirstName = "Tom"; LastName = "Ras"; Department = "Marketing"; },
    @{ FirstName = "Lammert"; LastName = "Kess"; Department = "Marketing"; },
    @{ FirstName = "Mariska"; LastName = "Cramp"; Department = "Administratie"; },
    @{ FirstName = "Marloes"; LastName = "VanRooy"; Department = "Administratie"; },
    @{ FirstName = "Paula"; LastName = "VanRooy"; Department = "Administratie"; },
    @{ FirstName = "Paulien"; LastName = "tempintuneel"; Department = "Administratie"; },
    @{ FirstName = "Willeke"; LastName = "Drayer"; Department = "Administratie"; },
    @{ FirstName = "Paulien"; LastName = "Goossen"; Department = "Administratie"; }
)
foreach ($user in $users) {
    $upn = "$($user.FirstName).$($user.LastName)@$domainName"

    try {
        # Check of gebruiker bestaat
        $existingUser = Get-MgUser -UserId $upn -ErrorAction SilentlyContinue

        if ($null -ne $existingUser) {
            # Soft delete gebruiker
            Remove-MgUser -UserId $upn -Confirm:$false
            Write-Host "🗑️ Gebruiker $upn is verwijderd (soft delete)" -ForegroundColor Yellow

            # Wacht even zodat Graph de verwijdering verwerkt
            Start-Sleep -Seconds 3

            # Probeer gericht te zoeken via filter
            try {
                $deletedUser = Get-MgDirectoryDeletedItemAsUser -All| Where-Object UserPrincipalName -like *$upn -ErrorAction Stop
            }
            catch {
                # Fallback: zoek handmatig
                Write-Host "⚠️ Filter niet ondersteund, gebruik fallback via Where-Object" -ForegroundColor DarkYellow
                $deletedUser = Get-MgDirectoryDeletedItemAsUser -All| Where-Object UserPrincipalName -like *$upn
            }

            if ($deletedUser) {
                # Hard delete (permanent verwijderen)
                Remove-MgDirectoryDeletedItem -DirectoryObjectId $deletedUser.Id -Confirm:$false
                Write-Host "✅ Gebruiker ${upn} is permanent verwijderd (hard delete)" -ForegroundColor Green
            }
            else {
                Write-Host "⚠️ Gebruiker ${upn} niet gevonden in Deleted Items om permanent te verwijderen" -ForegroundColor Cyan
            }
        }
        else {
            Write-Host "ℹ️ Gebruiker ${upn} bestaat niet, overslaan." -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "❌ Fout bij verwijderen gebruiker ${upn}: $($_.Exception.Message)" -ForegroundColor Red
    }
}
