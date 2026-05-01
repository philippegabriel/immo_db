select
distinct date_mutation as "Date Mutation",
nature_mutation as "Nature Mutation",
valeur_fonciere as "Valeur Foncière",
adresse_numero as "Num. Voie",
adresse_code_voie as "Type de Voie",
adresse_nom_voie,
code_postal as "Code Postal",
nom_commune,
type_local as "Type Local",
surface_reelle_bati as "Surface réelle Batie",
nombre_pieces_principales as "Nombre Pièces principales",
surface_terrain as "Surface Terrain"
from dvf
where code_postal=84100
order by Valeur_fonciere desc;
