-- Agrège la valeur économique filtrée (requête 03) en un total $ par interface/année,
-- toutes matières et toutes paires origine/destination confondues.
SELECT
    req_mat_eco_valeur.interface_id,
    req_mat_eco_valeur.me_annee,
    Sum(req_mat_eco_valeur.me_valeur) AS val_tot
FROM req_mat_eco_valeur
GROUP BY
    req_mat_eco_valeur.interface_id,
    req_mat_eco_valeur.me_annee;
