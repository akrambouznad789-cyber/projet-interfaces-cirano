-- Filtre et rattache la table économique brute StatCan (matrice_economique,
-- 352 326 lignes, tous modes et toutes provinces) aux interfaces routières,
-- en ne gardant que le mode camion et la caractéristique "Value" ($).
-- matrice_interface fait le pont province origine/destination -> interface_id.
SELECT
    a.interface_id,
    b.prov_or,
    b.prov_des,
    b.me_annee,
    b.me_mode,
    b.me_matiere,
    b.me_categ,
    b.me_valeur
FROM matrice_interface AS a, matrice_economique AS b
WHERE a.prov_or = b.prov_or
    AND a.prov_des = b.prov_des
    AND me_mode = 'Truck (for-hire)'
    AND me_categ = 'Value'
ORDER BY a.interface_id, b.prov_or, b.prov_des, b.me_annee;
