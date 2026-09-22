# Méthodologie

Comment passer d'un comptage de camions à une estimation de la valeur économique qu'ils
transportent, à chaque frontière interprovinciale.

## 1. Des routes aux interfaces

Chaque frontière interprovinciale est traversée par plusieurs routes (les **segments**). Le
DJMA (débit journalier moyen annuel) de chaque segment est d'abord corrigé selon sa codification
qualité (R/C/E — voir [Données](donnees.md)), puis les segments d'une même interface sont
agrégés :

```
flux_routiers.xlsx (segment × année)
        │  agrégation par interface
        ▼
req_djma_c_tot_par_interface.xlsx (interface × année)
```

Les étapes 1 et 2 sont implémentées par les requêtes SQL
[`01_req_moy_djma_c_par_route.sql`](../sql/01_req_moy_djma_c_par_route.sql) et
[`02_req_djma_c_tot_par_interface.sql`](../sql/02_req_djma_c_tot_par_interface.sql) — voir
[Base de données](base_de_donnees.md) pour le détail complet.

## 2. Du DJMA au nombre de camions annuel

Le DJMA camion est un débit *journalier*. Pour obtenir un volume annuel de camions par
interface :

```
nb_camions_annuel = DJMA_camion_total × 365
```

C'est la colonne `tot_cam_ann_par_interface` de `req_djma_c_tot_par_interface.xlsx`.

## 3. La valeur économique — StatCan

En parallèle, la table StatCan (tableau 23-10-0142, *Origin and destination of transported
commodities*) donne la valeur totale ($) des marchandises échangées entre chaque paire de
provinces, par année et par type de marchandise, filtrée sur le mode **Truck (for-hire)**.

Cette valeur est agrégée au niveau interface/année dans `req_val_tot_ann_par_interface.xlsx`, via
[`03_req_mat_eco_valeur.sql`](../sql/03_req_mat_eco_valeur.sql) puis
[`04_req_val_tot_ann_par_interface.sql`](../sql/04_req_val_tot_ann_par_interface.sql).

## 4. La valeur par camion

```
valeur_par_camion = valeur_totale_$ (interface, année) / nb_camions_annuel (interface, année)
```

C'est le résultat final, produit par [`05_req_val_camions.sql`](../sql/05_req_val_camions.sql) :
`req_val_camions.xlsx`, colonne `val_camion`. Il répond à la question
*"en moyenne, un camion qui traverse cette frontière transporte combien de dollars de
marchandises ?"*, et permet de comparer cette valeur entre interfaces et dans le temps
(2013–2017).

## Limite méthodologique à garder en tête

Cette valeur est une **moyenne agrégée**, pas une mesure directe par camion : elle suppose que
la répartition de la valeur entre camions est relativement homogène à l'intérieur d'une même
interface/année. Une interface avec un mélange très hétérogène de marchandises (ex. quelques
chargements de très haute valeur et beaucoup de chargements à faible valeur) verra sa moyenne
masquer cette variance interne.

---
[← Base de données](base_de_donnees.md) · [Retour au sommaire](../README.md) · [Suite : Résultats →](resultats.md)
