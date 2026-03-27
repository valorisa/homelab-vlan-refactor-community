# Registre des risques et Plan de Rollback (Community)

Ce document liste les problèmes fréquents lors de la refonte d'un réseau homelab (basé sur le retour d'expérience d'iMot3k) et les solutions de contournement.

## R01 : Lockout du pare-feu FortiGate

* **Description :** En modifiant l'interface LAN principale pour la passer en agrégat (LACP), vous perdez l'accès à l'interface d'administration.
* **Prévention :** Avoir configuré une interface physique dédiée (ex: `port5`) avec une IP statique hors plan (ex: `192.168.1.99`) et branché un PC en direct.
* **Rollback :** Se connecter sur l'interface de secours, supprimer l'interface LACP, et réassigner le rôle LAN au port d'origine.

## R02 : Incompatibilité du VLAN Natif sur le Trunk

* **Description :** Le trafic du réseau plat d'origine (VLAN 1 non tagué) traverse le trunk Cisco et crée des conflits de routage sur le FortiGate, ou empêche le LACP de monter.
* **Prévention :** Définir explicitement un `native vlan 999` (fictif) sur l'interface port-channel du Cisco.
* **Rollback :** Revenir temporairement au VLAN 1 natif via `no switchport trunk native vlan`.

## R03 : Panne globale du DHCP

* **Description :** La VM Windows Server 2022 est injoignable ou le relais DHCP Fortinet est mal configuré. Les clients n'ont plus d'IP.
* **Prévention :** Assigner une IP statique au serveur Windows (`10.20.10.10`) et vérifier la route vers la passerelle `.254`.
* **Rollback :** Activer temporairement le serveur DHCP natif du FortiGate sur l'interface VLAN critique (ex: VLAN 50).