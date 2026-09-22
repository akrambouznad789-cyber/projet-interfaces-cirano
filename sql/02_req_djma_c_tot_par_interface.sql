-- Agrège le DJMA moyen par segment (requête 01) en un total par interface/année,
-- et projette ce débit journalier sur une base annuelle (x 365 jours).
SELECT
    req_moy_djma_c_par_route.interface_id,
    req_moy_djma_c_par_route.fr_annee,
    Sum(req_moy_djma_c_par_route.moy_dhma_c_par_route) AS tot_djma_c_par_interface,
    Sum(req_moy_djma_c_par_route.moy_dhma_c_par_route) * 365 AS tot_cam_ann_par_interface
FROM req_moy_djma_c_par_route
GROUP BY
    req_moy_djma_c_par_route.interface_id,
    req_moy_djma_c_par_route.fr_annee;
