delits <- read_csv2("delitDep.csv", na="NA", locale=locale(encoding="latin1"))
delits
dim(delits)
ls(delits)

### rowSums fait les sommes ligne par ligne
### | = OU logique
macrocat <- delits %>%
  mutate(
    `Atteintes aux personnes` = rowSums(across(contains("Homicides") |
                                                 contains("Tentatives_homicides") |
                                                 contains("Coups_et_blessures") |
                                                 contains("Autres_coups_et_blessures") |
                                                 contains("Violences__mauvais_traitements") |
                                                 contains("Violences_autorité") |
                                                 contains("Atteintes_dignité") |
                                                 contains("Atteintes_sex") |
                                                 contains("Viols") |
                                                 contains("Harc") |
                                                 contains("Seques") |
                                                 contains("Prises_d_otages") |
                                                 contains("Règlements_compte")), na.rm = TRUE),
    
    `Atteintes aux biens` = rowSums(across(contains("Camb") |
                                             contains("Vols_") |
                                             contains("Autres_vols") |
                                             contains("Destructions") |
                                             contains("dégrada") |
                                             contains("Incendies") |
                                             contains("Violations_domicile") |
                                             contains("Recels")), na.rm = TRUE),
    
    `Éco-financier` = rowSums(across(contains("Escroqueries") |
                                       contains("Banqueroutes") |
                                       contains("Fraudes_fiscales") |
                                       contains("Fausse_monnaie") |
                                       contains("Achats_ventes_sans_factures") |
                                       contains("Marchandage") |
                                       contains("Travail_clandestin") |
                                       contains("Prix_illicittes") |
                                       contains("Contrefaçons") |
                                       contains("cartes_crédit") |
                                       contains("chèques_volés") |
                                       contains("Infractions_chèques") |
                                       contains("Autres_délits_éco_financiers")), na.rm = TRUE),
    
    `Stupéfiants` = rowSums(across(contains("stup")), na.rm = TRUE),
    
    `Étrangers et séjour` = rowSums(across(
      contains("étranger") | contains("étrangers")), na.rm = TRUE),
    
    `Administratif, professionnel et réglementaire` = rowSums(across(contains("urbanisme") |
                                                                       contains("profession_règlementée") |
                                                                       contains("Fraudes_alimentaires") |
                                                                       contains("santé_publique") |
                                                                       contains("alcool_tabac") |
                                                                       contains("Chasse_pêche") |
                                                                       contains("animaux") |
                                                                       contains("courses__jeux") |
                                                                       contains("garde_mineurs")), na.rm = TRUE),
    
    `Ordre public, autorité et sûreté` = rowSums(across(contains("Outrages") |
                                                          contains("Menaces") |
                                                          contains("Proxénétisme") |
                                                          contains("armes_prohib") |
                                                          contains("Atteintes_aux_intérêts_fondamentaux") |
                                                          contains("Attentats") |
                                                          contains("interdiction_séjour")), na.rm = TRUE),
    
    `Faux et usage de faux` = rowSums(across(contains("Faux_") |
                                               contains("faux_docs") |
                                               contains("Faux_doc") |
                                               contains("Autres_faux")), na.rm = TRUE)
  )

newdelit <- select(macrocat, Dpt,
                   `Atteintes aux personnes`,
                   `Atteintes aux biens`,
                   `Éco-financier`,
                   `Stupéfiants`,
                   `Étrangers et séjour`,
                   `Administratif, professionnel et réglementaire`,
                   `Ordre public, autorité et sûreté`,
                   `Faux et usage de faux`)
newdelit

delits_long <- newdelit %>% 
  pivot_longer(cols = `Atteintes aux personnes`:`Faux et usage de faux`)
delits_long

delits_wide <- delits_long %>% 
  pivot_wider(names_from = name, values_from = value)
delits_wide

newdelit %>%
  pivot_longer(`Atteintes aux personnes`:`Faux et usage de faux`) %>%
  group_by(name) %>%
  slice_max(order_by = value, n = 10) %>%
  ungroup() %>%
  arrange(name, desc(value)) %>%
  print(n = 80)

newdelit %>% #data
  filter(Dpt %in% c("1", "7", "26", "38", "42", "69", "73", "74")) %>% #filtre Rhône-Alpes
  drop_na() %>% #data
  ggplot() + #mapping
  aes(x = Dpt) + #mapping
  geom_col(aes(y = `Atteintes aux personnes`, fill = "Atteintes aux personnes"), position = "dodge") + #layers
  geom_col(aes(y = `Atteintes aux biens`, fill = "Atteintes aux biens"), position = "dodge") + #layers
  geom_col(aes(y = `Éco-financier`, fill = "Éco-financier"), position = "dodge") + #layers
  geom_col(aes(y = Stupéfiants, fill = "Stupéfiants"), position = "dodge") + #layers
  geom_col(aes(y = `Étrangers et séjour`, fill = "Étrangers et séjour"), position = "dodge") + #layers
  geom_col(aes(y = `Administratif, professionnel et réglementaire`, fill = "Administratif, professionnel et réglementaire"), position = "dodge") + #layers
  geom_col(aes(y = `Ordre public, autorité et sûreté`, fill = "Ordre public, autorité et sûreté"), position = "dodge") + #layers
  geom_col(aes(y = `Faux et usage de faux`, fill = "Faux et usage de faux"), position = "dodge") 
  scale_y_continuous(limits = c(0, 80000)) + #scales #layers
  theme_bw() + #theme
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 8)) + #options
  xlab("Département") + #options
  ylab("Nombre de délits") + #options
  ggtitle("Comparaison des délits par département") #options
  
  ### deuxième graphique
  delits %>%
    mutate(
      Total_homicides = Homicides_vol + Homicides_autres + Homicides_sur_moins_15,
      Total_tentatives = Tentatives_homicides_vol + Tentatives_homicides_autres,
      taux_reussite_homicide = Total_homicides / (Total_homicides + Total_tentatives) * 100
    ) %>% #avoir le total des homicides réussis 
    filter((taux_reussite_homicide) & (Total_homicides + Total_tentatives) > 0) %>%
    arrange(desc(taux_reussite_homicide)) %>%
    slice_head(n = 10) %>%
    ggplot() +
    aes(x = reorder(Dpt, taux_reussite_homicide), y = taux_reussite_homicide, fill = Dpt) +
    geom_col() +
    coord_flip() +
    theme_bw() +
    xlab("Département") +
    ylab("Taux de réussite homicides (%)") +
    ggtitle("Top 10 départements - Taux de réussite des homicides") +
    theme(legend.position = "none")
#### bon la j'ai pas réfléchi car si j'ai 100% c'est parce que je dois avoir 2/2 ou 1/1
  ### je vais refaire mais pour les 10 départements ayant le plus d'homicide
  
  delits %>%
    mutate(
      Total_homicides = Homicides_vol + Homicides_autres + Homicides_sur_moins_15,
      Total_tentatives = Tentatives_homicides_vol + Tentatives_homicides_autres,
      taux_reussite_homicide = Total_homicides / (Total_homicides + Total_tentatives) * 100
    ) %>%
    arrange(desc(Total_homicides)) %>%
    slice_head(n = 10) %>%
    ggplot() +
    aes(x = reorder(Dpt, Total_homicides), y = Total_homicides, fill = taux_reussite_homicide) +
    geom_col() +
    coord_flip() +
    scale_fill_gradient(low = "yellow", high = "red") +
    theme_bw() +
    xlab("Département") +
    ylab("Nombre d'homicides") +
    labs(fill = "Taux de réussite (%)") +
    ggtitle("Top 10 départements - Homicides et taux de réussite")
  