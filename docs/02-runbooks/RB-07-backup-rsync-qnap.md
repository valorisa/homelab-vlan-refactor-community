# RB-07 : Sauvegardes Rsync 10 Gb/s et Extinction NAS

Avoir le NAS principal (TrueNAS) et le NAS de secours (QNAP) allumés en permanence dans le même VLAN est une vulnérabilité (risques de ransomware ou de surtension). 

La stratégie implémentée ici :
1. Les deux NAS sont connectés en 10 Gb/s via le switch MikroTik (VLAN Admin).
2. Le QNAP de secours s'allume tout seul à une heure précise (planification matérielle QNAP).
3. TrueNAS effectue un `rsync` des données.
4. Un script bash sur TrueNAS vérifie la fin du transfert et éteint le QNAP via SSH.

## 1. Prérequis Réseau

* TrueNAS IP : `10.20.10.9` (NIC 10G)
* QNAP IP : `10.20.10.11` (NIC 10G)
* Assurez-vous d'avoir généré une clé SSH sur le TrueNAS et de l'avoir copiée (`ssh-copy-id`) sur l'utilisateur admin du QNAP pour un accès sans mot de passe.

## 2. Configuration de la tâche Rsync (TrueNAS)

1. Dans l'interface TrueNAS Scale, allez dans **Data Protection > Rsync Tasks**.
2. Créez une tâche de type "Push" (TrueNAS vers QNAP).
3. Définissez le répertoire source (ex: `/mnt/pool-ssd/data`) et la destination SSH sur le QNAP (ex: `admin@10.20.10.11:/share/Backup/data`).
4. Planifiez l'exécution 10 minutes après l'heure d'allumage programmée du QNAP.

## 3. Script d'extinction automatique (Post-Backup)

Ce script doit tourner en tâche cron sur le serveur TrueNAS/Proxmox à un intervalle régulier, ou être chaîné à la fin de la tâche Rsync.

*(Le script complet se trouve dans le dossier `scripts/bash/qnap-shutdown-after-rsync.sh` du dépôt).*

**Logique du script :**
* Il lit le fichier de log généré par Rsync.
* S'il détecte la chaîne signalant le succès ("rsync completed" ou équivalent).
* Il lance la commande SSH : `ssh admin@10.20.10.11 "sudo /sbin/poweroff"`.

## 4. Validation

1. Forcez le lancement de la tâche Rsync.
2. Surveillez la bande passante : vous devriez voir des pointes autour de 500 Mo/s à 1 Go/s (merci le 10 Gb/s et le HBA LSI).
3. À la fin du transfert, vérifiez que le QNAP s'éteint tout seul.