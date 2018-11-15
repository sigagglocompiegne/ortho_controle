/*

-- #################################################################### SUIVI CODE SQL ####################################################################

2018-01-10 : FV / initialisation du code

*/

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        DROP                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- fkey
ALTER TABLE m_signalement.geo_ortho_signa DROP CONSTRAINT IF EXISTS an_raepa_id_fkey;
-- classe
DROP TABLE IF EXISTS m_signalement.geo_ortho_signa;
-- domaine de valeur
DROP TABLE IF EXISTS m_signalement.lt_ortho_catctr;
-- sequence
DROP SEQUENCE IF EXISTS m_signalement.geo_ortho_signa_id_seq;


/*

-- #################################################################### SCHEMA  ####################################################################

-- Schema: m_signalement

-- DROP SCHEMA m_signalement;

CREATE SCHEMA m_signalement
  AUTHORIZATION sig_create;

GRANT ALL ON SCHEMA m_signalement TO postgres;
GRANT ALL ON SCHEMA m_signalement TO groupe_sig WITH GRANT OPTION;
COMMENT ON SCHEMA m_signalement
  IS 'Schéma contenant les différentes tables gérant les signalements';

*/


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINES DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ################################################################# Domaine valeur - lt_ortho_catctr #############################################

-- Table: m_signalement.lt_ortho_catctr

-- DROP TABLE m_signalement.lt_ortho_catctr;

CREATE TABLE m_signalement.lt_ortho_catctr
(
  code character(2) NOT NULL,
  sous_code character varying(2) NOT NULL,
  valeur character varying(254) NOT NULL,
  objet character varying(254),
  moyen character varying(254),
  CONSTRAINT lt_ortho_catctr_pkey PRIMARY KEY (code,sous_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_signalement.lt_ortho_catctr
  OWNER TO sig_create;
GRANT ALL ON TABLE m_signalement.lt_ortho_catctr TO sig_create;
GRANT SELECT ON TABLE m_signalement.lt_ortho_catctr TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_signalement.lt_ortho_catctr TO edit_sig;

COMMENT ON TABLE m_signalement.lt_ortho_catctr
  IS 'Liste des valeurs de l''attribut catégorie de contrôle (catctr) de la donnée relative au signalement d''anomalies lors du recette d''un orthophotoplan  (geo_ortho_signal)';
COMMENT ON COLUMN m_signalement.lt_ortho_catctr.code IS 'Code';
COMMENT ON COLUMN m_signalement.lt_ortho_catctr.sous_code IS 'Sous code';
COMMENT ON COLUMN m_signalement.lt_ortho_catctr.valeur IS 'Valeur';
COMMENT ON COLUMN m_signalement.lt_ortho_catctr.objet IS 'Objet';
COMMENT ON COLUMN m_signalement.lt_ortho_catctr.moyen IS 'Moyen';

INSERT INTO m_signalement.lt_ortho_catctr(
            code, sous_code, valeur, objet, moyen)
    VALUES
    ('01','00','Géométrie',NULL,NULL),
    ('01','01','Géométrie - précision planimétrique','Vérifier la précision planimétrique de l''image','Mesurer l''écart entre une donnée de référence (topo centimétrique) et sa représentation dans l''image'),
    ('01','02','Géométrie - devers','Vérifier angle et importance des devers des bâtiments','Mesurer le décalage du toit sur la partie ayant le plus devers sur un bâtiment dont la hauteur est connue et importante ou mesurer le décalage par rapport à une donnée de référence du bâti'),    
    ('01','03','Géométrie - raccord en limite de ligne de mosaïquage','Vérifier les raccords géométriques des objets de part et d''autres des lignes de mosaïquage','Regarder principalement les raccords au niveau des infrastructures routières ou ferrée'),
    ('01','04','Géométrie - redressement','Vérifier les lignes de rupture de pente (talus, falaise, ligne de crête …) et le redressement localisée de ces parties d''image','Vérifier la présence d''une ligne de rupture de pente dans le MNT à ces endroits'),
    ('01','05','Géométrie - redressement des ouvrages d''art','Vérifier que les ouvrages d''art (type pont/viaduc etc …) ont une forme rectiligne','Regarder notamment au niveau des tabliers des ponts, la présence de lignes de rupture dans le MNT'),
    ('01','99','Géométrie - autre paramètre de contrôle',NULL,NULL),
    ('02','00','Radiométrie',NULL,NULL),
    ('02','01','Radiométrie - teinte générale de l''orthophotoplan','Vérifier la teinte globale de l''image','Regarder si elle n''est pas trop terne ou au contraire trop contrastée, si elle le tire pas trop sur une couleur en particulier, si il ne semble pas y avoir un voile etc …)'),
    ('02','02','Radiométrie - teinte sur une partie de l''orthophotoplan','Vérifier la teinte sur des portions d''image','Regarder si elle n''est pas trop terne ou au contraire trop contrastée, si elle le tire pas trop sur une couleur en particulier, si il ne semble pas y avoir un voile etc …'),            
    ('02','03','Radiométrie - raccord de teinte en limite de ligne de mosaïquage','Vérifier si la colorimétrie est homogène de part et d''autre des lignes de moisaïquage',NULL),
    ('02','04','Radiométrie - saturation des blancs','Vérifier que les éléments restent bien discernables dans les blancs, c’est-à-dire que les blancs ne soient pas trop saturés','Regarder notamment sur les toits de bâtiments industriels'),     
    ('02','05','Radiométrie - reflet','Vérifier la présence localisée de reflets','Regarder principalement les zones d''eau (cours d''eau, mare etc …) ou les surfaces claires (toiture métallique, enrochement)'),   
    ('02','06','Radiométrie - dureté des ombres','Vérifier dans les ombres que les éléments restent bien discernables, c''est-à-dire que les ombres ne soient pas trop dures','Regarder notamment l''espace public au niveau de l''ombre des bâtiments'),
    ('02','99','Radiométrie - autre paramètre de contrôle',NULL,NULL),
    ('03','00','Particularité',NULL,NULL),    
    ('03','01','Particularité - nébulosité','Vérifier la présence de nuages ou de leurs ombres portées dans l''image','Regarder les cas d''impression de voile sur l''image ou de tâches d''ombre'),
    ('03','99','Particularité - autre',NULL,NULL),
    ('99','99','Autre',NULL,NULL);
    
    
