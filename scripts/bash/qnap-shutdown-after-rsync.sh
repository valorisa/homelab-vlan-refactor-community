#!/usr/bin/env bash
#
# Script : qnap-shutdown-after-rsync.sh
# Rôle : Éteindre le NAS QNAP de backup (via SSH) après la réussite du rsync.
# À exécuter sur le serveur source (TrueNAS / Proxmox).

set -euo pipefail

# -- Configuration --
QNAP_HOST="10.20.10.11"
QNAP_USER="admin"
RSYNC_LOG="/var/log/rsync-qnap-backup.log"
SUCCESS_STRING="total size is" # Chaîne typique de fin de rsync réussi

# Vérification de l'existence du log
if [[ ! -f "$RSYNC_LOG" ]]; then
    echo "Erreur : Fichier de log introuvable ($RSYNC_LOG)."
    exit 1
fi

# Recherche de la chaîne de succès dans les 10 dernières lignes du log
if tail -n 10 "$RSYNC_LOG" | grep -q "$SUCCESS_STRING"; then
    echo "Succès du Rsync détecté. Extinction du NAS QNAP à distance..."
    
    # Commande SSH pour éteindre le QNAP (nécessite l'échange de clés SSH)
    ssh -o StrictHostKeyChecking=accept-new "${QNAP_USER}@${QNAP_HOST}" "sudo /sbin/poweroff"
    
    if [[ $? -eq 0 ]]; then
        echo "Ordre d'extinction envoyé avec succès."
    else
        echo "Erreur lors de l'envoi de la commande d'extinction."
    fi
else
    echo "Rsync non terminé ou en erreur. Le QNAP reste allumé."
fi