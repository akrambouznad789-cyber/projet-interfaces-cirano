-- DJMA camion corrigé, moyenné par sous-interface (segment) et année.
-- Jointure segments_comptages (quel segment appartient à quelle interface)
-- avec flux_routiers (le DJMA brut par route/année).
SELECT
    segments_comptages.interface_id,
    segments_comptages.sc_sous_interface,
    flux_routiers.fr_annee,
    Avg(flux_routiers.fr_djma_cam) AS moy_dhma_c_par_route
FROM segments_comptages
INNER JOIN flux_routiers
    ON segments_comptages.route_id = flux_routiers.route_id
GROUP BY
    segments_comptages.interface_id,
    segments_comptages.sc_sous_interface,
    flux_routiers.fr_annee;
