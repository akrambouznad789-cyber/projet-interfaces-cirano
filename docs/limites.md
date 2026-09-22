# Limites et pistes explorées

## Piste cartographique abandonnée

Une visualisation géographique (QGIS + génération de polygones aux points de franchissement de
frontière avec `geopandas`, à partir du réseau routier StatCan et des limites provinciales) a
été explorée en amont de ce dépôt. Elle a été abandonnée au profit des graphiques statiques R :
le géoréférencement précis de chaque segment (angle de la route, position exacte du
franchissement) demandait un travail manuel important pour un gain limité par rapport aux
visualisations déjà informatives de la section [Résultats](resultats.md).

## Couverture temporelle

La période utile est contrainte par l'intersection des deux sources :
- Camionnage (DJMA) : 2013–2017
- Données commerciales StatCan (tableau 23-10-0142) : 2011–2017

Le résultat final (`req_val_camions.xlsx`) est donc limité à 2013–2017, la fenêtre commune.

## Sources de comptage manquantes

Voir [`data/raw/README.md`](../data/raw/README.md) pour le détail des sources déjà documentées.
Il manque des rapports de comptage pour la Colombie-Britannique, la Saskatchewan, la
Nouvelle-Écosse, l'Île-du-Prince-Édouard et Terre-Neuve-et-Labrador — les valeurs DJMA de ces
provinces dans `flux_routiers.xlsx` reposent en grande partie sur des estimations (voir la
codification qualité dans [Résultats](resultats.md#qualité-des-données-par-route-et-indicateur)).

## Valeur par camion = une moyenne, pas une mesure directe

Voir la note dans [Méthodologie](methodologie.md#limite-méthodologique-à-garder-en-tête) : la
valeur par camion est une moyenne agrégée par interface/année, pas une mesure individuelle.

---
[← Résultats](resultats.md) · [Retour au sommaire](../README.md)
