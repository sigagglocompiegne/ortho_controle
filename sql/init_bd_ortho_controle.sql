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
ALTER TABLE m_signalement.geo_ortho_signal DROP CONSTRAINT IF EXISTS lt_ortho_catctr_fkey;
ALTER TABLE m_signalement.geo_ortho_signal DROP CONSTRAINT IF EXISTS lt_ortho_rq_portee_fkey;
-- classe
DROP TABLE IF EXISTS m_signalement.geo_ortho_signal;
-- domaine de valeur
DROP TABLE IF EXISTS m_signalement.lt_ortho_catctr;
DROP TABLE IF EXISTS m_signalement.lt_ortho_rq_portee;
-- sequence
DROP SEQUENCE IF EXISTS m_signalement.geo_ortho_signal_id_seq;


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
  valeur character varying(254) NOT NULL,
  objet character varying(254),
  moyen character varying(254),
  CONSTRAINT lt_ortho_catctr_pkey PRIMARY KEY (code)
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
COMMENT ON COLUMN m_signalement.lt_ortho_catctr.valeur IS 'Valeur';
COMMENT ON COLUMN m_signalement.lt_ortho_catctr.objet IS 'Objet';
COMMENT ON COLUMN m_signalement.lt_ortho_catctr.moyen IS 'Moyen';

INSERT INTO m_signalement.lt_ortho_catctr(
            code, valeur, objet, moyen)
    VALUES
    ('00','Non renseigné',NULL,NULL),
    ('10','Géométrie',NULL,NULL),
    ('11','Géométrie - précision planimétrique','Vérifier la précision planimétrique de l''image','Mesurer l''écart entre une donnée de référence (topo centimétrique) et sa représentation dans l''image'),
    ('12','Géométrie - devers','Vérifier angle et importance des devers des bâtiments','Mesurer le décalage du toit sur la partie ayant le plus devers sur un bâtiment dont la hauteur est connue et importante ou mesurer le décalage par rapport à une donnée de référence du bâti'),    
    ('13','Géométrie - raccord en limite de ligne de mosaïquage','Vérifier les raccords géométriques des objets de part et d''autres des lignes de mosaïquage','Regarder principalement les raccords au niveau des infrastructures routières ou ferrée'),
    ('14','Géométrie - redressement','Vérifier les lignes de rupture de pente (talus, falaise, ligne de crête …) et le redressement localisée de ces parties d''image','Vérifier la présence d''une ligne de rupture de pente dans le MNT à ces endroits'),
    ('15','Géométrie - redressement des ouvrages d''art','Vérifier que les ouvrages d''art (type pont/viaduc etc …) ont une forme rectiligne','Regarder notamment au niveau des tabliers des ponts, la présence de lignes de rupture dans le MNT'),
    ('19','Géométrie - autre paramètre de contrôle',NULL,NULL),
    ('20','Radiométrie',NULL,NULL),
    ('21','Radiométrie - teinte générale de l''orthophotoplan','Vérifier la teinte globale de l''image','Regarder si elle n''est pas trop terne ou au contraire trop contrastée, si elle le tire pas trop sur une couleur en particulier, si il ne semble pas y avoir un voile etc …)'),
    ('22','Radiométrie - teinte sur une partie de l''orthophotoplan','Vérifier la teinte sur des portions d''image','Regarder si elle n''est pas trop terne ou au contraire trop contrastée, si elle le tire pas trop sur une couleur en particulier, si il ne semble pas y avoir un voile etc …'),            
    ('23','Radiométrie - raccord de teinte en limite de ligne de mosaïquage','Vérifier si la colorimétrie est homogène de part et d''autre des lignes de moisaïquage',NULL),
    ('24','Radiométrie - saturation des blancs','Vérifier que les éléments restent bien discernables dans les blancs, c’est-à-dire que les blancs ne soient pas trop saturés','Regarder notamment sur les toits de bâtiments industriels'),     
    ('25','Radiométrie - reflet','Vérifier la présence localisée de reflets','Regarder principalement les zones d''eau (cours d''eau, mare etc …) ou les surfaces claires (toiture métallique, enrochement)'),   
    ('26','Radiométrie - dureté des ombres','Vérifier dans les ombres que les éléments restent bien discernables, c''est-à-dire que les ombres ne soient pas trop dures','Regarder notamment l''espace public au niveau de l''ombre des bâtiments'),
    ('29','Radiométrie - autre paramètre de contrôle',NULL,NULL),
    ('30','Particularité',NULL,NULL),    
    ('31','Particularité - nébulosité','Vérifier la présence de nuages ou de leurs ombres portées dans l''image','Regarder les cas d''impression de voile sur l''image ou de tâches d''ombre'),
    ('39','Particularité - autre',NULL,NULL),
    ('99','Autre',NULL,NULL);

-- ################################################################# Domaine valeur - lt_ortho_rq_portee #############################################

-- Table: m_signalement.lt_ortho_rq_portee

-- DROP TABLE m_signalement.lt_ortho_rq_portee;

CREATE TABLE m_signalement.lt_ortho_rq_portee
(
  code character(2) NOT NULL,
  valeur character varying(254) NOT NULL,
  CONSTRAINT lt_ortho_rq_portee_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_signalement.lt_ortho_rq_portee
  OWNER TO sig_create;
GRANT ALL ON TABLE m_signalement.lt_ortho_rq_portee TO sig_create;
GRANT SELECT ON TABLE m_signalement.lt_ortho_rq_portee TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_signalement.lt_ortho_rq_portee TO edit_sig;

COMMENT ON TABLE m_signalement.lt_ortho_rq_portee
  IS 'Liste des valeurs de l''attribut portée de la remarque (rq_portee) de la donnée relative au signalement d''anomalies lors du recette d''un orthophotoplan  (geo_ortho_signal)';
COMMENT ON COLUMN m_signalement.lt_ortho_rq_portee.code IS 'Code';
COMMENT ON COLUMN m_signalement.lt_ortho_rq_portee.valeur IS 'Valeur';

INSERT INTO m_signalement.lt_ortho_rq_portee(
            code, valeur)
    VALUES
    ('0','Non renseigné'),
    ('1','Ponctuelle'),
    ('2','Générale'),
    ('9','Autre');
        

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                  CLASSE OBJET                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### CLASSE GEO_ORTHO_SIGNAL ###############################################

-- Table: m_signalement.geo_ortho_signal

-- DROP TABLE m_signalement.geo_ortho_signal;

CREATE TABLE m_signalement.geo_ortho_signal
(
  idsignal bigint NOT NULL,
  catctr character varying(1) NOT NULL DEFAULT '0',
  sscatctr character varying(2) NOT NULL DEFAULT '00',
  rq_portee character varying(1)NOT NULL DEFAULT '0',
  rq_detail character varying(254),
  src_geom character varying(2) NOT NULL DEFAULT '00',
  src_date character varying(4) NOT NULL DEFAULT '0000',
  ope_sai character varying(50),
  date_sai timestamp without time zone NOT NULL DEFAULT now(),  
  date_maj timestamp without time zone,
  geom geometry(Point,2154) NOT NULL,
  CONSTRAINT geo_ortho_signal_pkey PRIMARY KEY (idsignal) 
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_signalement.geo_ortho_signal
  OWNER TO sig_create;
GRANT ALL ON TABLE m_signalement.geo_ortho_signal TO sig_create;
GRANT SELECT ON TABLE m_signalement.geo_ortho_signal TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE m_signalement.geo_ortho_signal TO edit_sig;

COMMENT ON TABLE m_signalement.geo_ortho_signal
  IS 'Table de signalement d''anomalies lors du contrôle d''un orthophotoplan';
COMMENT ON COLUMN m_signalement.geo_ortho_signal.idsignal IS 'Identifiant de la canalisation';
COMMENT ON COLUMN m_signalement.geo_ortho_signal.catctr IS 'Catégorie du point de contrôle';
COMMENT ON COLUMN m_signalement.geo_ortho_signal.sscatctr IS 'Sous-catégorie du point de contrôle';
COMMENT ON COLUMN m_signalement.geo_ortho_signal.rq_portee IS 'portée de la remarque (ponctuelle ou générale)';
COMMENT ON COLUMN m_signalement.geo_ortho_signal.rq_detail IS 'Remarque détaillé de l''anomalie';
COMMENT ON COLUMN m_signalement.geo_ortho_signal.src_geom IS 'Référentiel de saisie';
COMMENT ON COLUMN m_signalement.geo_ortho_signal.src_date IS 'Anné du millésime du référentiel de saisie';
COMMENT ON COLUMN m_signalement.geo_ortho_signal.ope_sai IS 'Opérateur de la dernière saisie en base de l''objet';
COMMENT ON COLUMN m_signalement.geo_ortho_signal.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_signalement.geo_ortho_signal.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_signalement.geo_ortho_signal.geom IS 'Géométrie ponctuelle de l''objet';

-- Sequence: m_signalement.geo_ortho_signal_id_seq

-- DROP SEQUENCE m_signalement.geo_ortho_signal_id_seq;

CREATE SEQUENCE m_signalement.geo_ortho_signal_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE m_signalement.geo_ortho_signal_id_seq
  OWNER TO sig_create;
GRANT ALL ON SEQUENCE m_signalement.geo_ortho_signal_id_seq TO sig_create;
GRANT SELECT, USAGE ON SEQUENCE m_signalement.geo_ortho_signal_id_seq TO public;

ALTER TABLE m_signalement.geo_ortho_signal ALTER COLUMN idsignal SET DEFAULT nextval('m_signalement.geo_ortho_signal_id_seq'::regclass);


-- index spatial

CREATE INDEX geo_ortho_signal_geom_gist ON m_signalement.geo_ortho_signal USING GIST (geom);



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                           FKEY (clé étrangère)                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ############ GEO_ORTHO_SIGNAL ############

ALTER TABLE m_signalement.geo_ortho_signal

  ADD CONSTRAINT lt_ortho_catctr_fkey FOREIGN KEY (sscatctr)
      REFERENCES m_signalement.lt_ortho_catctr (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT lt_ortho_rq_portee_fkey FOREIGN KEY (rq_portee)
      REFERENCES m_signalement.lt_ortho_rq_portee (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION; 


      
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      TRIGGER                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### FONCTION TRIGGER - FT_GEO_ORTHO_SIGNAL ###################################################

-- Function: m_signalement.ft_geo_ortho_signal()

-- DROP FUNCTION m_signalement.ft_geo_ortho_signal();

CREATE OR REPLACE FUNCTION m_signalement.ft_geo_ortho_signal()
  RETURNS trigger AS
$BODY$


DECLARE v_id_signal integer;

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

NEW.catctr=LEFT(NEW.sscatctr,1);
NEW.date_sai=now();
NEW.date_maj = NULL;

RETURN NEW;


-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN

NEW.catctr=LEFT(NEW.sscatctr,1);
NEW.date_sai=OLD.date_sai;
NEW.date_maj=now();

RETURN NEW;

END IF;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION m_signalement.ft_geo_ortho_signal()
  OWNER TO sig_create;
GRANT EXECUTE ON FUNCTION m_signalement.ft_geo_ortho_signal() TO public;
GRANT EXECUTE ON FUNCTION m_signalement.ft_geo_ortho_signal() TO sig_create;
GRANT EXECUTE ON FUNCTION m_signalement.ft_geo_ortho_signal() TO create_sig;
COMMENT ON FUNCTION m_signalement.ft_geo_ortho_signal() IS 'Fonction trigger pour mise à jour de la donnée de signalement d''un référentiel ortho';


-- Trigger: t_t1_geo_ortho_signal on m_signalement.geo_ortho_signal

-- DROP TRIGGER t_t1_geo_ortho_signal ON m_signalement.geo_ortho_signal;

CREATE TRIGGER t_t1_geo_ortho_signal
  BEFORE INSERT OR UPDATE
  ON m_signalement.geo_ortho_signal
  FOR EACH ROW
  EXECUTE PROCEDURE m_signalement.ft_geo_ortho_signal();
       
