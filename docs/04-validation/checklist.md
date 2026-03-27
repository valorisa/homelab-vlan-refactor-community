# Checklist de Validation Post-Migration

Utilisez cette liste pour confirmer que votre nouvelle architecture est pleinement opérationnelle avant de supprimer l'ancien matériel ou le VLAN de transition.

## Couche Physique & Liaison (L1/L2)

* [ ] Les deux câbles du lien LACP sont branchés entre le FortiGate et le Cisco.
* [ ] La commande `show etherchannel summary` sur le Cisco affiche les ports en état `(P)`.
* [ ] Le lien SFP+ 10 Gb/s entre le switch principal et le switch MikroTik est UP.
* [ ] Le NAS et le PC principal synchronisent bien à 10 Gb/s (`iperf3` > 9 Gbits/sec).

## Couche Réseau & Routage (L3)

* [ ] Le FortiGate pingue les passerelles `.254` de tous les VLANs configurés.
* [ ] Un PC connecté sur un port assigné au VLAN 50 (PC) obtient bien une adresse IP `10.20.50.x`.
* [ ] Le PC en VLAN 50 parvient à pinger Internet (ex: `8.8.8.8`) et à résoudre un nom de domaine.
* [ ] Le PC en VLAN 50 NE PEUT PAS pinger un équipement du VLAN 10 (Admin), validant ainsi l'isolation par défaut du pare-feu.

## Services & Wi-Fi

* [ ] Connexion au SSID unique `Home-WiFi` avec le mot de passe "IoT" : l'appareil obtient une IP `10.20.20.x`.
* [ ] L'application Spotify sur un smartphone (VLAN Admin) voit et peut contrôler un amplificateur situé dans le VLAN PC (Validation du mDNS/Multicast).

## Sauvegardes

* [ ] La tâche Rsync TrueNAS vers QNAP se termine sans erreur.
* [ ] Le NAS QNAP s'éteint automatiquement suite à l'exécution du script post-backup.