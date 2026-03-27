# RB-03 : Migration avec le VLAN "Merdouille" (ID 1000)

Si tout votre réseau actuel est sur le VLAN 1 (réseau plat), le passage direct à 6 VLANs distincts va causer une perte de connectivité massive (IP incompatibles, perte du DHCP). Pour mitiger cela, nous utilisons un VLAN de transition : le VLAN 1000 "Merdouille".

## 1. Création du VLAN 1000 sur le FortiGate

Ce VLAN va temporairement héberger l'ancien plan d'adressage (ou un plan temporaire) le temps de migrer les appareils un par un.

1. Sur le FortiGate : **Network > Interfaces**.
2. **Create New > Interface** :
   * **Name :** `VLAN_1000_MERDOUILLE`
   * **Type :** `VLAN`
   * **Interface :** `LACP_CORE` (l'agrégat créé au RB-02)
   * **VLAN ID :** `1000`
   * **IP/Network Mask :** L'adresse IP qui servira de passerelle temporaire (ex: `10.20.1000.254/24`).

## 2. Propagation sur les Switchs (Cisco & autres)

Si ce n'est pas déjà fait, déclarez le VLAN 1000 dans la base VLAN du switch cœur.

```cisco
configure terminal
vlan 1000
 name MERDOUILLE
exit
```

## 3. Bascule des ports d'accès

Plutôt que de chercher à deviner quel équipement va dans quel VLAN définitif tout de suite, passez tous les ports "VLAN 1" en ports d'accès "VLAN 1000".

```cisco
configure terminal
interface range gigabitEthernet 1/0/1-44
 switchport access vlan 1000
exit
write memory
```

Vos équipements sont maintenant isolés dans ce VLAN. Vous pouvez ensuite prendre le temps, port par port, de les assigner vers leur VLAN définitif (10, 20, 50, etc.) au fur et à mesure que vous configurez le DHCP.