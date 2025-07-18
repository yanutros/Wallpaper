# WallpaperScriptCode.ps1

# URL de l’image à appliquer
$imageUrl = "https://cf.bstatic.com/xdata/images/hotel/max1024x768/359680233.jpg?k=646a2ea1faee562dd9622e4a0b60b3f48b3bef0f51579223932089be0ab73e3d&o=&hp=1"
$imagePath = "$env:USERPROFILE\Pictures\359680233.jpg"

# Télécharger l’image
Invoke-WebRequest -Uri $imageUrl -OutFile $imagePath

# Fonction pour changer le fond d'écran utilisateur
function Set-DesktopWallpaper {
    param([string]$WallpaperPath)
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@
    [void][Wallpaper]::SystemParametersInfo(20, 0, $WallpaperPath, 3)
}

Set-DesktopWallpaper -WallpaperPath $imagePath

# Définir l’image de l’écran de verrouillage (verrouillage session)
$CSPKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
if (!(Test-Path $CSPKey)) { New-Item -Path $CSPKey -Force | Out-Null }
New-ItemProperty -Path $CSPKey -Name LockScreenImageStatus -Value 0 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $CSPKey -Name LockScreenImagePath -Value $imagePath -PropertyType String -Force | Out-Null
New-ItemProperty -Path $CSPKey -Name LockScreenImageUrl -Value $imagePath -PropertyType String -Force | Out-Null

# Remarque : Les modifications de l’écran de verrouillage nécessitent des droits administrateur
