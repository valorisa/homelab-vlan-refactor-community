# Plan d'adressage et table des VLAN

La convention de nommage suit le format IP `10.20.<ID_VLAN>.0/24`. Toutes les passerelles portées par le pare-feu Fortinet se terminent par `.254`.

| VLAN ID | Nom | Réseau | Passerelle | Rôle & Usage | Wi-Fi (PPSK) |
| :---: | :--- | :--- | :--- | :--- | :--- |
| **10** | `Admin` | `10.20.10.0/24` | `10.20.10.254` | Infrastructure, serveurs critiques, PC administrateur. Accès étendu. | Oui |
| **20** | `IoT` | `10.20.20.0/24` | `10.20.20.254` | Objets connectés (domotique, capteurs). Accès LAN restreint. | Oui |
| **30** | `VoIP` | `10.20.30.0/24` | `10.20.30.254` | Téléphonie IP (ex: Mytel 470). Isolé avec QoS prioritaire. | Optionnel |
| **50** | `PC` | `10.20.50.0/24` | `10.20.50.254` | Équipements de vie (smartphones persos, TV, amplis hi-fi). | Oui |
| **100** | `Caméras` | `10.20.100.0/24` | `10.20.100.254` | Flux vidéo (ex: Ubiquiti UNVR). Totalement isolé d'Internet. | Non |
| **200** | `Invités` | `10.20.200.0/24` | `10.20.200.254` | Visiteurs. Accès Internet uniquement. Isolation des clients. | Oui |
| **999** | `Native` | *N/A* | *N/A* | VLAN fictif ("Blackhole") pour sécuriser le trunk LACP Cisco. | Non |
| **1000** | `Merdouille`| `10.20.1000.0/24` | `10.20.1000.254` | VLAN de transition. Remplace l'ancien VLAN 1 temporairement. | Non |

## Notes de sécurité

* Le serveur DHCP central (VLAN 10) possède une adresse IP statique (`10.20.10.10`).
* Les règles de pare-feu FortiGate interdisent par défaut les communications inter-VLAN, à l'exception du trafic explicitement autorisé (ex: VLAN 50 vers l'imprimante, VLAN 10 vers VLAN 20 pour la gestion).