# RB-04 : Windows Server 2022 (DHCP/DNS) & DHCP Relay

Avoir un serveur DHCP par interface sur le pare-feu est fastidieux à gérer (surtout pour les réservations statiques IP). La bonne pratique appliquée ici est d'utiliser une VM unique sous Windows Server 2022 pour centraliser l'AD (optionnel), le DNS et le DHCP.

## 1. Configuration de la VM Windows Server

1. Installez Windows Server 2022 sur votre hyperviseur (Proxmox).
2. Placez l'interface réseau virtuelle dans le VLAN Admin (ID 10).
3. Attribuez-lui une adresse IP fixe (ex: `10.20.10.10`) avec comme passerelle le FortiGate (`10.20.10.254`).
4. Ajoutez les rôles **Serveur DHCP** et **Serveur DNS** via le Gestionnaire de serveur.
5. Dans la console DHCP, créez une "Étendue" (Scope) pour chaque VLAN (10, 20, 30, 50, 100, 200). 
   * Spécifiez bien la passerelle `.254` correspondante à chaque étendue.
   * Spécifiez le serveur DNS (`10.20.10.10`).

> 🔒 **Sécurité :** Créez une règle sur le FortiGate interdisant à cette VM l'accès à Internet, sauf vers les serveurs DNS publics (ex: `1.1.1.1` et `8.8.8.8`) pour la résolution récursive.

## 2. Configuration du DHCP Relay (FortiGate)

Puisque les clients des VLAN 20, 50, etc., ne sont pas dans le même sous-réseau que le serveur DHCP, leurs requêtes broadcast seront bloquées. Le FortiGate doit agir comme relais.

Pour *chaque* interface VLAN créée sur le FortiGate :

1. Allez dans **Network > Interfaces**.
2. Éditez l'interface VLAN (ex: `VLAN_50_PC`).
3. Dans la section **DHCP Server**, choisissez **Relay** (au lieu de Server).
4. Indiquez l'adresse IP du serveur Windows Server (`10.20.10.10`).

## 3. Validation

* Branchez un PC sur un port switch assigné au VLAN 50.
* Vérifiez qu'il obtient une IP en `10.20.50.x`.
* Vérifiez que le FortiGate a bien appliqué les règles (les logs du serveur DHCP Windows doivent montrer un "DHCP DISCOVER" relayé par la passerelle).