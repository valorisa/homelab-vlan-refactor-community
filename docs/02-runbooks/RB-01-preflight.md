# RB-01 : Preflight Check (Avant de tout casser)

Une migration réseau complète présente de grands risques de "lockout" (se bloquer soi-même en dehors de l'infrastructure). Suivez cette checklist de préparation stricte.

## 1. Préparer une "Porte de sortie" (Secours)

Pour ne pas perdre la main sur le pare-feu lors du changement de l'interface LAN :
* [ ] Configurez un port physique inutilisé du FortiGate (ex: `port5` ou `mgmt`) avec une IP fixe hors du plan cible (ex: `192.168.1.99/24`).
* [ ] Autorisez les accès administratifs (`HTTPS`, `SSH`, `PING`) sur cette interface de secours.
* [ ] Préparez un PC portable avec un câble Ethernet et configurez-lui l'IP statique `192.168.1.100`. 
* [ ] Branchez le PC sur le port de secours et vérifiez que vous avez accès à l'interface d'administration.

## 2. Sauvegardes de l'existant

* [ ] **FortiGate :** Exportez la configuration complète (System > Admin > Backup).
* [ ] **Cisco Catalyst :** Récupérez la running-config.
  ```cisco
  enable
  show running-config
  copy running-config tftp://<IP_DU_SERVEUR>/cisco-backup.cfg
  ```
* [ ] **Proxmox / VM :** Prenez un snapshot des machines virtuelles critiques (notamment routeur virtuel s'il y en a, et vieux serveur DHCP).
* [ ] **Sauvegarde de données :** Lancez une tâche de synchronisation (rsync) vers le NAS de backup pour les données vitales.

## 3. Inventaire statique

* [ ] Relevez les adresses MAC et adresses IP statiques de vos équipements critiques (Switchs, NAS, IPBX, Contrôleurs Wi-Fi).
* [ ] Dressez la liste des baux DHCP actuels à conserver.

## 4. Tests de référence (Baseline)

Avant de casser l'existant, vérifiez les performances pour pouvoir comparer post-migration :
* [ ] Testez le débit vers le NAS en 10 Gb/s via iperf3 ou en copiant un gros fichier. Notez la vitesse moyenne (en Mo/s).
* [ ] Testez la résolution DNS interne et externe.

> **Décision validée :** Vous pouvez maintenant procéder à la création du lien physique principal (RB-02).