# Données

Le projet s'appuie sur deux familles de tables : des **tables de référence** (la géométrie du
problème — quelles interfaces, quels segments) et des **tables dérivées** (les résultats de
l'agrégation et du calcul final).

## Tables de référence (`data/master/`)

| Fichier | Rôle | Lignes |
|---|---|---|
| `interface.xlsx` | Les 9 interfaces interprovinciales (BC_AB, AB_SK, … NS_NL) | 9 |
| `matrice_interface.xlsx` | Directionnalité province origine/destination par interface | — |
| `segments_comptages.xlsx` | Les routes précises qui traversent chaque frontière | 66 |
| `flux_routiers.xlsx` | DJMA brut par route/année (2013–2017), avec codification qualité | 380 |

Une **interface** (ex. `ON_QC`) est la frontière entre deux provinces. Chaque interface est
traversée par plusieurs **segments** : les routes précises qui la franchissent. Par exemple,
`ON_QC` regroupe 6 segments (autoroute 401/A-20, autoroute 417/A-40, route 148, etc.).

## Tables dérivées (`data/processed/`)

| Fichier | Rôle | Lignes |
|---|---|---|
| `req_moy_djma_c_par_route.xlsx` | DJMA corrigé moyen, par route | — |
| `req_djma_c_tot_par_interface.xlsx` | DJMA total et nb. camions/an, agrégé par interface | 57 |
| `req_mat_eco_valeur.xlsx` | Valeur $ des échanges par province origine/destination/année/matière (StatCan, mode camion) | 82 577 |
| `req_val_tot_ann_par_interface.xlsx` | Valeur $ totale par interface/année | 45 |
| `req_val_camions.xlsx` | **Résultat final** — valeur moyenne par camion, par interface/année | 45 |

## Codification qualité des comptages

Chaque route de `flux_routiers.xlsx` est codifiée selon la fiabilité de sa donnée DJMA (totale,
camions, et % camions) :

| Code | Signification |
|---|---|
| **R** | Réelle — valeur mesurée directement |
| **C** | Calculée — dérivée d'une autre mesure disponible sur la même route |
| **E** | Estimée — aucune mesure directe, complétée par une méthode logique |

Cette codification est ce que visualise [`figures/g1_qualite_donnees.png`](../figures/g1_qualite_donnees.png)
(voir [Résultats](resultats.md)) : elle permet de voir en un coup d'œil quelles routes reposent
sur une mesure solide et lesquelles sont des approximations.

## Provenance des sources brutes

Les comptages provinciaux et le tableau StatCan qui alimentent ces tables sont documentés,
avec citations exactes, dans [`data/raw/README.md`](../data/raw/README.md).

---
[← Retour au sommaire](../README.md) · [Suite : Méthodologie →](methodologie.md)
