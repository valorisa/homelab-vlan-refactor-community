<#
.SYNOPSIS
    Script de création par lot des étendues DHCP sur Windows Server 2022.
.DESCRIPTION
    Ce script automatise la création des scopes pour les VLANs de la Community Edition,
    en définissant les plages d'adresses, la passerelle FortiGate (.254) et le DNS central.
#>

$DnsServerIP = "10.20.10.10"
$DomainName = "homelab.local"

# Définition des VLANs à provisionner
$Vlans = @(
    @{ Name="VLAN10_ADMIN"; Subnet="10.20.10.0"; Start="10.20.10.100"; End="10.20.10.200"; GW="10.20.10.254" },
    @{ Name="VLAN20_IOT";   Subnet="10.20.20.0"; Start="10.20.20.100"; End="10.20.20.200"; GW="10.20.20.254" },
    @{ Name="VLAN50_PC";    Subnet="10.20.50.0"; Start="10.20.50.100"; End="10.20.50.200"; GW="10.20.50.254" }
)

foreach ($Vlan in $Vlans) {
    Write-Host "Création de l'étendue : $($Vlan.Name)" -ForegroundColor Cyan
    
    # 1. Ajout de l'étendue (Scope)
    Add-DhcpServerv4Scope -Name $Vlan.Name -StartRange $Vlan.Start -EndRange $Vlan.End -SubnetMask "255.255.255.0" -State Active
    
    # 2. Configuration des options (Routeur / Passerelle = 003)
    Set-DhcpServerv4OptionValue -ScopeId $Vlan.Subnet -OptionId 3 -Value $Vlan.GW
    
    # 3. Configuration des options (Serveur DNS = 006, Nom de domaine = 015)
    Set-DhcpServerv4OptionValue -ScopeId $Vlan.Subnet -OptionId 6 -Value $DnsServerIP
    Set-DhcpServerv4OptionValue -ScopeId $Vlan.Subnet -OptionId 15 -Value $DomainName
    
    Write-Host "-> Terminé pour $($Vlan.Subnet)`n" -ForegroundColor Green
}