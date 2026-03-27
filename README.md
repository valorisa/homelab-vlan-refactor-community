# Homelab VLAN Refactor - Community Edition

## Résumé exécutif

Ce dépôt propose un guide de reconstruction "from scratch" d'une infrastructure réseau pour homelab. Il est directement inspiré de la démarche documentée par la chaîne YouTube iMot3k ("Je change TOUT mon réseau, et j'ai encore tout pété. 🤷‍♂️"). 

L'objectif est d'abandonner un réseau plat (VLAN 1 "fourre-tout") pour une architecture segmentée, sécurisée et performante. Ce projet intègre la création d'un agrégat de liens (LACP) entre un pare-feu et un switch cœur de réseau, le déploiement d'un plan IP cohérent, la centralisation du DHCP/DNS, l'utilisation du Wi-Fi avec PPSK, et la sécurisation des sauvegardes.

Ce "Golden Path" privilégie des configurations simples, lisibles et reproductibles pour la communauté.

## Matériel actuel vs cible (Budget 1000 €)

| Composant | Matériel d'origine | Cible / Occasion recommandée | Prix estimé | Justification |
| :--- | :--- | :--- | :--- | :--- |
| **Pare-feu / Routeur** | USG / Box FAI | Fortinet FortiGate 60F | ~350 € | Routage inter-VLAN, relais DHCP, filtrage fin, MDNS multicast. |
| **Cœur de réseau L2** | Zyxel GS1900-10HP V2 | Cisco Catalyst 2960X-48LPD-L | ~60 € | 48 ports PoE, LACP robuste, VLAN natif paramétrable, prix imbattable. |
| **Switch 10 Gb/s** | (Aucun) | MikroTik 10G (ex: CRS305) | ~120 € | Connectivité 10 Gb/s abordable pour NAS et PC principal. |
| **Stockage / Compute** | HBA PCIe x1 (lent) | Carte LSI SAS 9300-8i (Mode IT) | ~80 € | Lignes PCIe x8 pour lever le goulot d'étranglement (vitesse proche 10 Gb/s). |
| **Points d'accès Wi-Fi** | Zyxel (PPSK payant) | 4x Ubiquiti U7 Lite | ~400 € | PPSK gratuit avec contrôleur local (VM), limite le nombre de SSID. |
| **Total estimé** | | | **~1010 €** | *Sources : Leboncoin, eBay.* |

## Structure du projet

* `docs/` : Documentation de l'architecture, plan d'adressage IP et checklists.
* `runbooks/` : Guides pas-à-pas pour la migration (du préflight au rollback).
* `configs/` : Fichiers de configuration génériques pour Fortinet, Cisco, Windows et UniFi.
* `scripts/` : Scripts d'automatisation (extinction du NAS de backup, etc.).

## Comment démarrer ?

1. Lisez `docs/01-architecture/overview.md` pour comprendre la cible.
2. Consultez `docs/01-architecture/vlan-table.md` pour le plan IP.
3. Exécutez le **RB-01-preflight.md** dans le dossier `runbooks/` avant de modifier la moindre configuration.