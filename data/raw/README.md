# Sources des données brutes

Ce dossier documente la provenance des données. Les fichiers sources bruts eux-mêmes sont
volumineux et/ou soumis aux conditions d'utilisation des fournisseurs, donc **non versionnés**
(`.gitignore`) — seules les tables déjà nettoyées et prêtes à l'emploi qui en sont dérivées sont
committées dans [`data/master/`](../master/) et [`data/processed/`](../processed/).

## 1. Valeur économique des échanges interprovinciaux — Statistique Canada

**Table** : *Origin and destination of transported commodities, Canadian Freight Analysis
Framework*
**Numéro de produit** : 23 10 0142
**URL** : https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=2310014201
**Fréquence** : annuelle, 2011–2017
**Dimensions** : géographie d'origine, géographie de destination, mode de transport, groupe de
marchandises, caractéristique (valeur $)

`data/processed/req_mat_eco_valeur.xlsx` est un extrait filtré de cette table (mode = *Truck
(for-hire)* uniquement, agrégé au niveau province plutôt que région infra-provinciale).

Fichier brut : `raw/sources/statcan_23100142/23100142-eng.zip` (~90 Mo, non versionné).

## 2. Comptages de trafic (DJMA) par province

Les débits journaliers moyens annuels (DJMA) — total et camions — proviennent des publications
et outils de comptage ouverts de chaque province. Rapports/exemples consultés, conservés dans
`raw/sources/comptages_provinciaux/` (non versionnés, volumineux) :

| Fichier | Province | Source | Description |
|---|---|---|---|
| `AL-00138170.pdf` | Alberta | Alberta Transportation | Rapport de comptage directionnel (Turning Movement / AADT-ASDT), station de référence 138170 |
| `MAN-traffic_report_2024.pdf` | Manitoba | Manitoba Highway Traffic Information System | *Traffic on Manitoba Highways*, publication annuelle |
| `NB-dti-traffic-counters-2018-2020.pdf` | Nouveau-Brunswick | NB Dept. of Transportation and Infrastructure (DTI) | Carte des compteurs de circulation, 2018–2020 |
| `ON-Provincial_Highways_traffic_Volumes_1988-2021.pdf` | Ontario | Ministère des Transports de l'Ontario, Provincial Traffic Office | *Provincial Highways Traffic Volumes*, 1988–2019 et 2021 |
| `QC(A85)-0008502000_agreg.pdf` | Québec | MTQ, Direction générale du Bas-Saint-Laurent | Données agrégées (Cir-6002), station 12081, Autoroute 85 près de la frontière QC/NB |

> **Sources manquantes** : Colombie-Britannique, Saskatchewan, Nouvelle-Écosse,
> Île-du-Prince-Édouard, Terre-Neuve-et-Labrador — à ajouter si retrouvées.

Chaque route a ensuite été codifiée dans `data/master/flux_routiers.xlsx` selon la fiabilité de
sa donnée :
- **R** — valeur réelle mesurée
- **C** — valeur calculée (dérivée d'une autre mesure disponible pour cette route)
- **E** — valeur estimée (aucune mesure directe, complétée par une méthode logique)

## Pourquoi ces fichiers ne sont pas versionnés

- Le fichier StatCan brut (~90 Mo) dépasse ce qui est raisonnable pour un dépôt de portfolio ;
  l'extrait pertinent est déjà dans `data/processed/req_mat_eco_valeur.xlsx`.
- Les PDF provinciaux sont des publications tierces volumineuses (jusqu'à ~20 Mo) ; les valeurs
  DJMA qui en sont extraites sont déjà consolidées dans `data/master/flux_routiers.xlsx`.

Ce dossier sert à la traçabilité et à la reproductibilité ; il n'est pas requis pour relancer les
analyses, qui partent directement des tables de `data/master/` et `data/processed/`.
