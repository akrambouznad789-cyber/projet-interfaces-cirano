# ============================================================
#  GRAPHIQUES - TRANSPORT ROUTIER INTERPROVINCIAL
# ============================================================
# Packages requis (décommenter pour installer une première fois) :
# install.packages(c("ggplot2","readxl","dplyr","tidyr","scales","ggalluvial","showtext","sysfonts","here"))

library(ggplot2)
library(readxl)
library(dplyr)
library(tidyr)
library(scales)
library(ggalluvial)
library(showtext)
library(sysfonts)
library(here)

# ============================================================
# POLICE — Lato (Google Fonts, friendly + pro)
# ============================================================
font_add_google("Lato", "lato")
showtext_auto()

# ============================================================
# THÈME GLOBAL
# ============================================================
theme_transport <- function(base_size = 13) {
  theme_minimal(base_size = base_size, base_family = "lato") +
    theme(
      plot.title       = element_text(size = base_size + 6, face = "bold",   margin = margin(b = 6)),
      plot.subtitle    = element_text(size = base_size + 1, color = "grey45", margin = margin(b = 12)),
      axis.title       = element_text(size = base_size + 2, face = "bold"),
      axis.text        = element_text(size = base_size),
      legend.title     = element_text(size = base_size,     face = "bold"),
      legend.text      = element_text(size = base_size - 1),
      strip.text       = element_text(size = base_size,     face = "bold"),
      panel.grid.minor = element_blank()
    )
}

# ============================================================
# CHEMINS — relatifs à la racine du dépôt (lancer avec here::here()
# ou ouvrir le projet R depuis la racine du repo)
# ============================================================
chemin_master    <- here("data", "master")
chemin_processed <- here("data", "processed")
chemin_figures   <- here("figures")
dir.create(chemin_figures, showWarnings = FALSE, recursive = TRUE)

# ============================================================
# CHARGEMENT DES DONNÉES
# ============================================================
val_cam  <- read_excel(file.path(chemin_processed, "req_val_camions.xlsx"))
eco      <- read_excel(file.path(chemin_processed, "req_mat_eco_valeur.xlsx"))
flux     <- read_excel(file.path(chemin_master,    "flux_routiers.xlsx"))
segments <- read_excel(file.path(chemin_master,    "segments_comptages.xlsx"))

# ============================================================
# ORDRE ET LABELS OUEST → EST
# ============================================================
ordre_interfaces <- c("BC_AB", "AB_SK", "SK_MB", "MB_ON", "ON_QC", "QC_NB", "NB_NS", "NB_PE", "NS_NL")
ordre_prov       <- c("BC", "AB", "SK", "MB", "ON", "QC", "NB", "NS", "PE", "NL")

# Fonction pour convertir "BC_AB" → "BC][AB"
fmt_iface <- function(x) gsub("_", "][", x)

# Palette cohérente par interface (utilisée dans G2, G3, G4)
couleurs_interfaces <- c(
  "BC_AB" = "#1f78b4",
  "AB_SK" = "#33a02c",
  "SK_MB" = "#ff7f00",
  "MB_ON" = "#e31a1c",
  "ON_QC" = "#6a3d9a",
  "QC_NB" = "#b15928",
  "NB_NS" = "#a6cee3",
  "NB_PE" = "#b2df8a",
  "NS_NL" = "#fb9a99"
)

# ============================================================
# GRAPHIQUE 1 — Qualité des données (heatmap codifications)
# ============================================================
ordre_prov_routes <- c("BC", "AB", "SK", "MB", "ON", "QC", "NB", "NS", "PEI", "NL")

heatmap_data <- flux %>%
  group_by(route_id) %>%
  summarise(
    DJMA_Cam = names(sort(table(fr_djma_cam_c), decreasing = TRUE))[1],
    DJMA_Tot = names(sort(table(fr_djma_c),     decreasing = TRUE))[1],
    Pct_Cam  = names(sort(table(fr_pc_cam_c),   decreasing = TRUE))[1],
    .groups  = "drop"
  ) %>%
  mutate(province = sub("_.*", "", route_id)) %>%
  mutate(province = factor(province, levels = ordre_prov_routes)) %>%
  arrange(province, route_id) %>%
  mutate(route_id = factor(route_id, levels = unique(route_id))) %>%
  pivot_longer(c(DJMA_Cam, DJMA_Tot, Pct_Cam),
               names_to = "indicateur", values_to = "codification") %>%
  mutate(
    indicateur   = recode(indicateur,
      DJMA_Cam = "DJMA Camions", DJMA_Tot = "DJMA Total", Pct_Cam = "% Camions"),
    codification = factor(codification, levels = c("R", "C", "E"))
  )

g1 <- ggplot(heatmap_data, aes(x = indicateur, y = route_id, fill = codification)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = codification), size = 3.2, fontface = "bold", color = "white",
            family = "lato") +
  scale_fill_manual(
    values = c("R" = "#33a02c", "C" = "#ff7f00", "E" = "#e31a1c"),
    labels = c("R" = "R — Réelle", "C" = "C — Calculée", "E" = "E — Estimée")
  ) +
  facet_grid(province ~ ., scales = "free_y", space = "free_y") +
  labs(
    title    = "Qualité des données par route et indicateur",
    subtitle = "Codification dominante | 2013 — 2017 | Ouest — Est",
    x = "Indicateur", y = "Route", fill = "Codification"
  ) +
  theme_transport(base_size = 12) +
  theme(
    strip.text.y    = element_text(angle = 0),
    axis.text.y     = element_text(size = 9),
    panel.grid      = element_blank(),
    legend.position = "bottom"
  )

print(g1)
ggsave(file.path(chemin_figures, "g1_qualite_donnees.png"), g1,
       width = 9, height = 11, dpi = 300, bg = "white")


# ============================================================
# GRAPHIQUE 2 — Valeur par camion par interface et année
# ============================================================
val_cam_ord <- val_cam %>%
  filter(interface_id %in% ordre_interfaces) %>%
  mutate(
    interface_id  = factor(interface_id, levels = ordre_interfaces),
    interface_lbl = fmt_iface(as.character(interface_id))
  )

g2 <- ggplot(val_cam_ord, aes(x = me_annee, y = val_camion,
                         color = interface_id, group = interface_id)) +
  geom_line(linewidth = 1.4) +
  geom_point(size = 3) +
  scale_x_continuous(breaks = 2013:2017) +
  scale_y_continuous(labels = dollar_format(prefix = "$", big.mark = " ")) +
  scale_color_manual(
    values = couleurs_interfaces,
    labels = fmt_iface(ordre_interfaces)
  ) +
  labs(
    title    = "Valeur moyenne transportée par camion",
    subtitle = "Par interface provinciale | 2013 — 2017 | Ouest — Est",
    x = "Année", y = "Valeur par camion ($)", color = "Interface"
  ) +
  theme_transport()

print(g2)
ggsave(file.path(chemin_figures, "g2_valeur_par_camion.png"), g2,
       width = 10, height = 6, dpi = 300, bg = "white")


# ============================================================
# GRAPHIQUE 3 — Sankey : flux économiques à travers les interfaces
# Chaque colonne = une interface, les flux transitent de gauche à droite
# Année modifiable ici ↓
# ============================================================
annee_sankey <- 2017

# Construire le format alluvial : chaque prov_or est un flux qui traverse les interfaces
sankey_wide <- eco %>%
  filter(me_annee == annee_sankey, me_categ == "Value",
         interface_id %in% ordre_interfaces) %>%
  group_by(interface_id, prov_or) %>%
  summarise(valeur = sum(me_valeur, na.rm = TRUE), .groups = "drop") %>%
  mutate(
    interface_lbl = factor(fmt_iface(interface_id), levels = fmt_iface(ordre_interfaces)),
    prov_or       = factor(prov_or, levels = ordre_prov)
  )

g3 <- ggplot(sankey_wide,
       aes(x = interface_lbl, y = valeur / 1e9,
           alluvium = prov_or, stratum = prov_or, fill = prov_or)) +
  geom_flow(alpha = 0.55, width = 0.35) +
  geom_stratum(width = 0.35, color = "white") +
  geom_text(stat = "stratum", aes(label = after_stat(stratum)),
            size = 3, fontface = "bold", family = "lato", color = "white") +
  scale_fill_brewer(palette = "Paired") +
  scale_y_continuous(labels = function(x) paste0(x, " G$")) +
  labs(
    title    = paste0("Flux économiques à travers les interfaces (", annee_sankey, ")"),
    subtitle = "Valeur des marchandises transportées par camion | Ouest — Est",
    x = "Interface", y = "Valeur (G$)", fill = "Province d'origine"
  ) +
  theme_transport() +
  theme(
    axis.text.x     = element_text(angle = 30, hjust = 1),
    legend.position = "bottom"
  )

print(g3)
ggsave(file.path(chemin_figures, "g3_sankey_flux_economiques.png"), g3,
       width = 11, height = 7, dpi = 300, bg = "white")


# ============================================================
# GRAPHIQUE 4 — Type de matière par interface
# Année modifiable ici ↓
# ============================================================
annee_mat <- 2017

mat_data <- eco %>%
  filter(me_annee == annee_mat, me_categ == "Value",
         interface_id %in% ordre_interfaces) %>%
  group_by(interface_id, me_matiere) %>%
  summarise(valeur = sum(me_valeur, na.rm = TRUE), .groups = "drop") %>%
  mutate(
    interface_lbl = factor(fmt_iface(interface_id), levels = fmt_iface(ordre_interfaces)),
    matiere_court = gsub(" \\[.*\\]", "", me_matiere)
  )

g4 <- ggplot(mat_data, aes(x = interface_lbl, y = valeur / 1e9, fill = matiere_court)) +
  geom_col(position = "stack", color = "white", linewidth = 0.3) +
  scale_y_continuous(labels = function(x) paste0(x, " G$")) +
  scale_fill_brewer(palette = "Set3") +
  labs(
    title    = paste0("Composition des échanges par type de matière (", annee_mat, ")"),
    subtitle = "Valeur des marchandises par interface | Ouest — Est",
    x = "Interface", y = "Valeur (milliards $)", fill = "Type de matière"
  ) +
  theme_transport() +
  theme(
    axis.text.x     = element_text(angle = 30, hjust = 1),
    legend.position = "bottom"
  ) +
  guides(fill = guide_legend(nrow = 4))

print(g4)
ggsave(file.path(chemin_figures, "g4_composition_matieres.png"), g4,
       width = 11, height = 7, dpi = 300, bg = "white")

cat("\nFigures exportées dans:", chemin_figures, "\n")
