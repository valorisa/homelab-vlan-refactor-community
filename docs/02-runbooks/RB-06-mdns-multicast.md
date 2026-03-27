# RB-06 : Routage Multicast & mDNS (Spotify Connect, AirPlay)

Segmenter son réseau en VLANs casse instantanément les protocoles de découverte qui utilisent le multicast (mDNS/Bonjour). Conséquence : depuis le VLAN Admin ou PC, vous ne voyez plus votre amplificateur audio (ex: Onkyo) ou votre Apple TV situés dans le VLAN IoT.

Plutôt que d'activer un répéteur mDNS aveugle, nous configurons des politiques FortiGate précises.

## 1. Figer l'IP de l'appareil cible

1. Sur votre Windows Server (DHCP), créez une réservation pour l'amplificateur (ex: `10.20.50.40` dans le VLAN PC).

## 2. Activer les politiques Multicast sur le FortiGate

Par défaut, le FortiGate bloque le multicast inter-interfaces.

1. Allez dans **System > Feature Visibility** et activez **Multicast Forwarding**.
2. Allez dans **Policy & Objects > Multicast Policy**.
3. Créez une règle permettant le trafic mDNS :
   * **Incoming Interface :** `VLAN_10_ADMIN` (là où est votre smartphone)
   * **Outgoing Interface :** `VLAN_50_PC` (là où est l'ampli)
   * **Source Address :** `all` (ou l'IP de votre smartphone)
   * **Destination Address :** Pensez à créer un objet adresse multicast pour mDNS (`224.0.0.251`) et sélectionnez-le.
   * **Action :** `Accept`

## 3. Configuration de la règle de retour (Optionnelle mais souvent requise)

Certains appareils ont besoin de répondre en multicast ou de s'annoncer au client.
* Créez la règle inverse (Incoming `VLAN_50`, Outgoing `VLAN_10`) en limitant strictement la **Source Address** à l'adresse IP fixe de l'amplificateur.

## 4. Validation

1. Connectez votre smartphone au VLAN Admin.
2. Ouvrez l'application Spotify.
3. Cliquez sur l'icône des appareils : votre amplificateur Onkyo doit apparaître (via Spotify Connect / mDNS) malgré la séparation des réseaux.