# RB-02 : Création de l'Agrégat de Liens (LACP / LAG)

L'objectif de cette étape est de relier le FortiGate 60F au Cisco Catalyst 2960X via deux câbles (ports 3 et 4 côté FortiGate, ports Gi1/0/45 et 46 côté Cisco) pour doubler la bande passante et assurer la redondance. 

> ⚠️ **Avertissement :** Ne branchez pas le deuxième câble avant d'avoir configuré le LACP des deux côtés, sous peine de créer une boucle réseau (si le Spanning-Tree ne réagit pas assez vite).

## 1. Côté FortiGate (802.3ad)

1. Allez dans **Network > Interfaces**.
2. Cliquez sur **Create New > Interface**.
3. Remplissez les champs :
   * **Name :** `LACP_CORE`
   * **Type :** `802.3ad Aggregate`
   * **Interface Members :** Sélectionnez les ports physiques (ex: `port3`, `port4`).
   * **Role :** `LAN`
4. Laissez les autres paramètres par défaut (LACP mode Active).
5. Validez.

## 2. Côté Cisco Catalyst 2960X

Connectez-vous en console ou SSH au Cisco. L'erreur classique (rencontrée par iMot3k) est de laisser le VLAN 1 non tagué traverser le trunk. Nous allons forcer le `native vlan` sur un ID inutilisé (le 999) pour obliger le switch à taguer tous les autres VLANs de données.

```cisco
enable
configure terminal

! Création du Port-Channel
interface port-channel 1
 description UPLINK_FORTIGATE
 switchport mode trunk
 switchport trunk native vlan 999
 switchport trunk allowed vlan 10,20,30,50,100,200,1000
exit

! Assignation des ports physiques au LAG
interface range gigabitEthernet 1/0/45-46
 description LACP_MEMBER_FORTIGATE
 switchport mode trunk
 switchport trunk native vlan 999
 switchport trunk allowed vlan 10,20,30,50,100,200,1000
 channel-group 1 mode active
exit
write memory
```

## 3. Validation

* Branchez les deux câbles.
* Sur le Cisco, tapez `show etherchannel summary`. Les ports `Gi1/0/45` et `Gi1/0/46` doivent apparaître avec le flag `(P)` pour "bundled in port-channel".
* Sur le FortiGate, l'interface `LACP_CORE` doit avoir le statut `Up` (vert).