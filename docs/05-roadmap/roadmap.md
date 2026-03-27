# Roadmap (Évolutions futures)

Félicitations, vous avez un réseau propre, segmenté et robuste ! Voici les prochaines étapes que vous pouvez envisager pour améliorer encore votre homelab (ces concepts sont développés dans la version *Expert Playbook*).

## À court terme (1 à 3 mois)

1. **Monitoring (SNMP) :**
   * Déployer une stack Grafana / Prometheus ou LibreNMS dans le VLAN Admin.
   * Activer le SNMP v2c/v3 sur le FortiGate et le Cisco pour surveiller la bande passante du LAG.
2. **Durcissement des règles de Pare-feu :**
   * Remplacer la règle "VLAN Admin vers ANY" par des règles restrictives basées sur les ports (TCP 443, 22, etc.).
   * Activer l'IPS (Intrusion Prevention System) du FortiGate sur les flux sortants des VLANs IoT et Caméras.

## À moyen terme (6 mois)

1. **Authentification 802.1x (Filaire) :**
   * Au lieu d'assigner les ports du switch manuellement, utiliser un serveur RADIUS (ex: NPS sur le Windows Server) pour placer dynamiquement le PC dans le bon VLAN lors du branchement du câble.
2. **Infrastructure-as-Code (IaC) :**
   * Gérer la création des scopes DHCP via Terraform ou Ansible plutôt que via des scripts PowerShell manuels.