# RB-05 : Wi-Fi UniFi U7 Lite & PPSK (Private Pre-Shared Key)

La gestion de 6 SSID différents pollue le spectre radio et dégrade les performances Wi-Fi. La solution retenue (après abandon de Zyxel Nebula car payant) est l'utilisation de points d'accès Ubiquiti U7 Lite avec la technologie PPSK (gratuite en contrôleur on-prem).

Le PPSK permet d'avoir un seul SSID (ex: `Home-WiFi`), mais de router l'utilisateur vers un VLAN spécifique en fonction du mot de passe qu'il saisit.

## 1. Préparation du Contrôleur On-Premise

1. Installez le **UniFi Network Server** sur une VM (Debian/Ubuntu) dans le VLAN Admin (10). Ne dépendez pas du Cloud Key ou d'un service cloud.
2. Connectez vos bornes U7 Lite sur les ports PoE du switch Cisco.
3. Adoptez les bornes depuis le contrôleur.

## 2. Configuration des Réseaux (Networks) dans UniFi

Le contrôleur doit connaître vos VLANs pour pouvoir y injecter le trafic.
1. Allez dans **Settings > Networks**.
2. Créez des réseaux de type **VLAN Only** (ou Third-Party Gateway) correspondant à votre plan :
   * Nom: `IoT`, VLAN ID: `20`
   * Nom: `PC`, VLAN ID: `50`
   * Nom: `Admin`, VLAN ID: `10`

## 3. Configuration du SSID et du PPSK

1. Allez dans **Settings > WiFi**.
2. Créez un nouveau réseau Wi-Fi :
   * **Name :** `Home-WiFi`
   * **Password :** Entrez un mot de passe par défaut (celui qui ira dans le VLAN PC par exemple).
3. Activez l'option **Private Pre-Shared Keys (PPSK)**.
4. Ajoutez vos mots de passe secondaires et associez-les au bon VLAN :
   * Mot de passe : `SuperSecretAdmin` -> Réseau : `Admin` (VLAN 10)
   * Mot de passe : `IotPass123` -> Réseau : `IoT` (VLAN 20)

## 4. Validation

* Sur votre smartphone, connectez-vous au SSID `Home-WiFi` avec le mot de passe IoT.
* Vérifiez votre adresse IP : elle doit commencer par `10.20.20.x`.
* Oubliez le réseau, reconnectez-vous avec le mot de passe Admin. Votre IP doit changer en `10.20.10.x`.