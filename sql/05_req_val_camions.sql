-- Résultat final : jointure de la valeur $ totale (requête 04) et du nombre
-- de camions annuel (requête 02) par interface/année, pour calculer la
-- valeur moyenne transportée par camion.
SELECT
    req_val_tot_ann_par_interface.interface_id,
    req_val_tot_ann_par_interface.me_annee,
    req_val_tot_ann_par_interface.val_tot,
    req_djma_c_tot_par_interface.tot_cam_ann_par_interface,
    req_val_tot_ann_par_interface.val_tot
        / req_djma_c_tot_par_interface.tot_cam_ann_par_interface AS val_camion
FROM req_val_tot_ann_par_interface
INNER JOIN req_djma_c_tot_par_interface
    ON (req_val_tot_ann_par_interface.me_annee = req_djma_c_tot_par_interface.fr_annee)
    AND (req_val_tot_ann_par_interface.interface_id = req_djma_c_tot_par_interface.interface_id);
