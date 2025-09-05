# -------------------------------
# 🧩 MODULE CHECK EN INSTALLATIE
# -------------------------------

$requiredModules = @(
    "Microsoft.Graph.Users",
    "Microsoft.Graph.Identity.DirectoryManagement"
)

foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "📦 Installeren module: $module" -ForegroundColor Yellow
        Install-Module $module -Scope CurrentUser -Force
    } else {
        Write-Host "✅ Module al geïnstalleerd: $module" -ForegroundColor Green
    }
}

# -------------------------------
# 📥 IMPORTEREN EN CONNECTIE
# -------------------------------

Write-Host "`n🔌 Verbinden met Microsoft Graph..." -ForegroundColor Cyan

Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Identity.DirectoryManagement

Connect-MgGraph -Scopes "User.ReadWrite.All", "Domain.Read.All"

# -------------------------------
# 🌐 DOMEIN OPHALEN
# -------------------------------

Write-Host "`n🌍 Ophalen domeinnaam..." -ForegroundColor Cyan

$domainName = Get-MgDomain | Select-Object -ExpandProperty Id
Write-Host "✅ Gebruikt domein: $domainName" -ForegroundColor Green

# -------------------------------
# 👥 GEBRUIKERS DEFINIËREN
# -------------------------------

$users = @(
    @{ FirstName = "David"; LastName = "Chew"; Department = "Sales" },
    @{ FirstName = "Bas"; LastName = "Schutte"; Department = "Sales" },
    @{ FirstName = "Sander"; LastName = "Strauss"; Department = "Sales" },
    @{ FirstName = "Teunis"; LastName = "Hake"; Department = "Sales" },
    @{ FirstName = "Lammert"; LastName = "Homan"; Department = "Marketing" },
    @{ FirstName = "Tom"; LastName = "Ras"; Department = "Marketing" },
    @{ FirstName = "Lammert"; LastName = "Kess"; Department = "Marketing" },
    @{ FirstName = "Mariska"; LastName = "Cramp"; Department = "Administratie" },
    @{ FirstName = "Marloes"; LastName = "VanRooy"; Department = "Administratie" },
    @{ FirstName = "Paula"; LastName = "VanRooy"; Department = "Administratie" },
    @{ FirstName = "Paulien"; LastName = "tempintuneel"; Department = "Administratie" },
    @{ FirstName = "Willeke"; LastName = "Drayer"; Department = "Administratie" },
    @{ FirstName = "Paulien"; LastName = "Goossen"; Department = "Administratie" }
)

# -------------------------------
# 🧑‍💻 AANMAKEN VAN GEBRUIKERS
# -------------------------------

Write-Host "`n🚀 Start aanmaken gebruikers..." -ForegroundColor Cyan

foreach ($user in $users) {
    $upn = "$($user.FirstName).$($user.LastName)@$domainName"

    # Controleren of gebruiker al bestaat
    $existingUser = Get-MgUser -UserId $upn -ErrorAction SilentlyContinue
    if ($null -ne $existingUser) {
        Write-Host "⚠️  Gebruiker bestaat al: $upn" -ForegroundColor Yellow
        continue
    }

    # Aanmaken wachtwoordprofiel
    $passwordProfile = @{
        Password = "TempP@ssw0rd123!"
        ForceChangePasswordNextSignIn = $true
    }

    # Aanmaken gebruikersparameters
    $newUserParams = @{
        AccountEnabled    = $true
        DisplayName       = "$($user.FirstName) $($user.LastName)"
        MailNickname      = "$($user.FirstName)$($user.LastName)"
        UserPrincipalName = $upn
        GivenName         = $user.FirstName
        Surname           = $user.LastName
        UsageLocation     = "BE"
        Department        = $user.Department
        PasswordProfile   = $passwordProfile
    }

    try {
        New-MgUser @newUserParams
        Write-Host "✅ Gebruiker aangemaakt: ${upn}" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Fout bij aanmaken gebruiker: ${upn}" -ForegroundColor Red
        Write-Host $($_.Exception.Message) -ForegroundColor DarkRed
    }
}

Write-Host "`n🎉 Voltooid!" -ForegroundColor Cyan
