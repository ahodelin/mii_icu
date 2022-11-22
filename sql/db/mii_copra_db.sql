--
-- PostgreSQL database dump
--

-- Dumped from database version 15.0
-- Dumped by pg_dump version 15.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: copra; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA copra;


--
-- Name: mii_copra; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA mii_copra;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: co6_config_variable_types; Type: TABLE; Schema: copra; Owner: -
--

CREATE TABLE copra.co6_config_variable_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    tablename character varying NOT NULL
);


--
-- Name: co6_config_variables; Type: TABLE; Schema: copra; Owner: -
--

CREATE TABLE copra.co6_config_variables (
    id bigint NOT NULL,
    name character varying,
    description character varying,
    unit character varying,
    co6_config_variabletypes_id integer,
    parent integer,
    deleted boolean
);


--
-- Name: co6_data_decimal_6_3; Type: TABLE; Schema: copra; Owner: -
--

CREATE TABLE copra.co6_data_decimal_6_3 (
    id bigint NOT NULL,
    varid integer NOT NULL,
    deleted boolean NOT NULL,
    parent_id bigint NOT NULL,
    parent_varid integer NOT NULL,
    val numeric(9,3) NOT NULL,
    datetimeto timestamp without time zone,
    validated boolean,
    flagcurrent boolean
);


--
-- Name: co6_data_object; Type: TABLE; Schema: copra; Owner: -
--

CREATE TABLE copra.co6_data_object (
    id bigint NOT NULL,
    varid integer NOT NULL,
    parent_id bigint NOT NULL,
    parent_varid integer NOT NULL,
    flagcurrent boolean NOT NULL
);


--
-- Name: co6_data_string; Type: TABLE; Schema: copra; Owner: -
--

CREATE TABLE copra.co6_data_string (
    id bigint NOT NULL,
    varid integer NOT NULL,
    parent_id bigint NOT NULL,
    parent_varid integer NOT NULL,
    datetimeto timestamp without time zone,
    val character varying,
    deleted boolean,
    flagcurrent boolean
);


--
-- Name: co6_medic_data_patient; Type: TABLE; Schema: copra; Owner: -
--

CREATE TABLE copra.co6_medic_data_patient (
    id bigint NOT NULL,
    geb timestamp without time zone,
    geschlecht character varying(50),
    patid character varying(50)
);


--
-- Name: co6_medic_pressure; Type: TABLE; Schema: copra; Owner: -
--

CREATE TABLE copra.co6_medic_pressure (
    id bigint NOT NULL,
    varid integer NOT NULL,
    parent_id bigint NOT NULL,
    parent_varid integer NOT NULL,
    systolic numeric(9,3),
    mean numeric(9,3),
    diastolic numeric(9,3),
    datetimeto timestamp without time zone,
    validated boolean,
    deleted boolean,
    flagcurrent boolean
);


--
-- Name: mapping_mii_co6_2; Type: TABLE; Schema: copra; Owner: -
--

CREATE TABLE copra.mapping_mii_co6_2 (
    profile_id integer,
    profile_name character varying,
    category_coding_system text,
    category_coding_code character varying,
    code_coding_system_snomed text,
    code_coding_code_snomed character varying,
    code_coding_system_loinc text,
    code_coding_code_loinc character varying,
    code_coding_system_ieee text,
    code_coding_code_ieee character varying,
    valuequantity_system text,
    valuequantity_code character varying,
    conf_var_unit character varying,
    device_reference text,
    meta_profile text,
    conf_var_id bigint,
    conf_var_parent_id bigint,
    conf_var_parent_name character varying,
    conf_var_name character varying,
    conf_var_description character varying,
    conf_var_types_id integer,
    conf_var_types_name character varying,
    code_systolic_coding_system_snomed text,
    code_systolic_coding_code_snomed character varying,
    code_systolic_coding_system_loinc text,
    code_systolic_coding_code_loinc character varying,
    code_systolic_coding_system_ieee text,
    code_systolic_coding_code_ieee character varying,
    code_mean_coding_system_snomed text,
    code_mean_coding_code_snomed character varying,
    code_mean_coding_system_loinc text,
    code_mean_coding_code_loinc character varying,
    code_mean_coding_system_ieee text,
    code_mean_coding_code_ieee character varying,
    code_diastolic_coding_system_snomed text,
    code_diastolic_coding_code_snomed character varying,
    code_diastolic_coding_system_loinc text,
    code_diastolic_coding_code_loinc character varying,
    code_diastolic_coding_system_ieee text,
    code_diastolic_coding_code_ieee character varying,
    matching_valide boolean,
    unit_transform numeric DEFAULT 1
);


--
-- Name: v_profil_decimal; Type: VIEW; Schema: copra; Owner: -
--

CREATE VIEW copra.v_profil_decimal AS
 SELECT ('d_'::text || md5((((( SELECT tables.table_name
           FROM information_schema.tables
          WHERE (((tables.table_schema)::name = 'copra'::name) AND ((tables.table_name)::name = 'co6_data_decimal_6_3'::name))))::text || cdd.id) || (mmc.profile_name)::text))) AS id,
    mmc.meta_profile,
    'final'::text AS status,
    mmc.category_coding_system,
    mmc.category_coding_code,
    mmc.code_coding_system_snomed,
    mmc.code_coding_code_snomed,
    mmc.code_coding_system_loinc,
    mmc.code_coding_code_loinc,
    mmc.code_coding_system_ieee,
    mmc.code_coding_code_ieee,
    ('p_'::text || md5(((cmdp.id)::character varying)::text)) AS subject_reference,
    (cdd.val * mmc.unit_transform) AS "valueQuantity_value",
    mmc.valuequantity_system AS "valueQuantity_system",
    mmc.valuequantity_code AS "valueQuantity_code",
    cdd.datetimeto AS "effectiveDataTime"
   FROM (((copra.co6_data_decimal_6_3 cdd
     JOIN copra.co6_config_variables ccv ON ((cdd.varid = ccv.id)))
     JOIN copra.mapping_mii_co6_2 mmc ON ((mmc.conf_var_id = ccv.id)))
     JOIN copra.co6_medic_data_patient cmdp ON ((cmdp.id = cdd.parent_id)))
  WHERE (cdd.validated AND (NOT cdd.deleted) AND cdd.flagcurrent);


--
-- Name: v_profil_pressure; Type: VIEW; Schema: copra; Owner: -
--

CREATE VIEW copra.v_profil_pressure AS
 SELECT ('pr_'::text || md5((((( SELECT tables.table_name
           FROM information_schema.tables
          WHERE (((tables.table_schema)::name = 'copra'::name) AND ((tables.table_name)::name = 'co6_medic_pressure'::name))))::text || cdd.id) || (mmc.profile_name)::text))) AS id,
    mmc.meta_profile,
    'final'::text AS status,
    mmc.category_coding_system,
    mmc.category_coding_code,
    ('p_'::text || md5(((cmdp.id)::character varying)::text)) AS subject_reference,
    cdd.datetimeto AS "effectiveDataTime",
    mmc.code_systolic_coding_system_snomed,
    mmc.code_systolic_coding_code_snomed,
    mmc.code_systolic_coding_system_loinc,
    mmc.code_systolic_coding_code_loinc,
    mmc.code_systolic_coding_system_ieee,
    mmc.code_systolic_coding_code_ieee,
    cdd.systolic AS "valueQuantity_value_systolic",
    mmc.valuequantity_system AS "valueQuantity_system_systolic",
    mmc.valuequantity_code AS "valueQuantity_code_systolic",
    mmc.code_mean_coding_system_snomed,
    mmc.code_mean_coding_code_snomed,
    mmc.code_mean_coding_system_loinc,
    mmc.code_mean_coding_code_loinc,
    mmc.code_mean_coding_system_ieee,
    mmc.code_mean_coding_code_ieee,
    cdd.mean AS "valueQuantity_value_mean",
    mmc.valuequantity_system AS "valueQuantity_system_mean",
    mmc.valuequantity_code AS "valueQuantity_code_mean",
    mmc.code_diastolic_coding_system_snomed,
    mmc.code_diastolic_coding_code_snomed,
    mmc.code_diastolic_coding_system_loinc,
    mmc.code_diastolic_coding_code_loinc,
    mmc.code_diastolic_coding_system_ieee,
    mmc.code_diastolic_coding_code_ieee,
    cdd.mean AS "valueQuantity_value_diastolic",
    mmc.valuequantity_system AS "valueQuantity_system_diastolic",
    mmc.valuequantity_code AS "valueQuantity_code_diastolic"
   FROM (((copra.co6_medic_pressure cdd
     JOIN copra.co6_config_variables ccv ON ((cdd.varid = ccv.id)))
     JOIN copra.mapping_mii_co6_2 mmc ON ((mmc.conf_var_id = ccv.id)))
     JOIN copra.co6_medic_data_patient cmdp ON ((cmdp.id = cdd.parent_id)))
  WHERE (cdd.validated AND (NOT cdd.deleted) AND cdd.flagcurrent);


--
-- Name: v_profil_string; Type: VIEW; Schema: copra; Owner: -
--

CREATE VIEW copra.v_profil_string AS
 SELECT ('s_'::text || md5((((( SELECT tables.table_name
           FROM information_schema.tables
          WHERE (((tables.table_schema)::name = 'copra'::name) AND ((tables.table_name)::name = 'co6_data_string'::name))))::text || cdd.id) || (mmc.profile_name)::text))) AS id,
    mmc.meta_profile,
    'final'::text AS status,
    mmc.category_coding_system,
    mmc.category_coding_code,
    mmc.code_coding_system_snomed,
    mmc.code_coding_code_snomed,
    mmc.code_coding_system_loinc,
    mmc.code_coding_code_loinc,
    mmc.code_coding_system_ieee,
    mmc.code_coding_code_ieee,
    ('p_'::text || md5(((cmdp.id)::character varying)::text)) AS subject_reference,
    ((cdd.val)::numeric * mmc.unit_transform) AS "valueQuantity_value",
    mmc.valuequantity_system AS "valueQuantity_system",
    mmc.valuequantity_code AS "valueQuantity_code",
    cdd.datetimeto AS "effectiveDataTime"
   FROM (((copra.co6_data_string cdd
     JOIN copra.co6_config_variables ccv ON ((cdd.varid = ccv.id)))
     JOIN copra.mapping_mii_co6_2 mmc ON ((mmc.conf_var_id = ccv.id)))
     JOIN copra.co6_medic_data_patient cmdp ON ((cmdp.id = cdd.parent_id)))
  WHERE ((NOT cdd.deleted) AND cdd.flagcurrent AND ((cdd.val)::text ~ '^\d+$|^\d+\.\d+$'::text));


--
-- Name: co6_config_variable_types; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.co6_config_variable_types (
    id character varying,
    name character varying,
    tablename character varying,
    storagetype character varying
);


--
-- Name: co6_config_variables; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.co6_config_variables (
    id bigint,
    name character varying,
    description character varying,
    unit character varying,
    co6_config_variabletypes_id integer,
    parent bigint,
    deleted character varying,
    loinc character varying,
    displayname character varying
);


--
-- Name: conf_var_no_for_analysis; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.conf_var_no_for_analysis (
    conf_var_id bigint,
    conf_var_name character varying,
    conf_var_description character varying,
    conf_var_types_name character varying,
    conf_var_parent_name character varying,
    quantities bigint
);


--
-- Name: config_var; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.config_var (
    quantity bigint,
    id bigint,
    name character varying,
    description character varying
);


--
-- Name: mii_icu; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.mii_icu (
    profile_id integer NOT NULL,
    profile_name character varying NOT NULL,
    category_coding_system text,
    category_coding_code character varying,
    code_coding_system_snomed text,
    code_coding_code_snomed character varying,
    code_coding_system_loinc text,
    code_coding_code_loinc character varying,
    code_coding_system_ieee text,
    code_coding_code_ieee character varying,
    valuequantity_system text,
    valuequantity_code character varying,
    device_reference text,
    code_systolic_coding_system_snomed text,
    code_systolic_coding_code_snomed character varying,
    code_systolic_coding_system_loinc text,
    code_systolic_coding_code_loinc character varying,
    code_systolic_coding_system_ieee text,
    code_systolic_coding_code_ieee character varying,
    code_mean_coding_system_snomed text,
    code_mean_coding_code_snomed character varying,
    code_mean_coding_system_loinc text,
    code_mean_coding_code_loinc character varying,
    code_mean_coding_system_ieee text,
    code_mean_coding_code_ieee character varying,
    code_diastolic_coding_system_snomed text,
    code_diastolic_coding_code_snomed character varying,
    code_diastolic_coding_system_loinc text,
    code_diastolic_coding_code_loinc character varying,
    code_diastolic_coding_system_ieee text,
    code_diastolic_coding_code_ieee character varying,
    meta_profile text
);


--
-- Name: fhir_profile_observations_profile_id_seq; Type: SEQUENCE; Schema: mii_copra; Owner: -
--

CREATE SEQUENCE mii_copra.fhir_profile_observations_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fhir_profile_observations_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: mii_copra; Owner: -
--

ALTER SEQUENCE mii_copra.fhir_profile_observations_profile_id_seq OWNED BY mii_copra.mii_icu.profile_id;


--
-- Name: mapping_mii_co6; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.mapping_mii_co6 (
    profile_id integer,
    profile_name character varying,
    category_coding_system text,
    category_coding_code character varying,
    code_coding_system_snomed text,
    code_coding_code_snomed character varying,
    code_coding_system_loinc text,
    code_coding_code_loinc character varying,
    code_coding_system_ieee text,
    code_coding_code_ieee character varying,
    valuequantity_system text,
    valuequantity_code character varying,
    conf_var_unit character varying,
    device_reference text,
    meta_profile text,
    conf_var_id bigint,
    conf_var_parent_id bigint,
    conf_var_parent_name character varying,
    conf_var_name character varying,
    conf_var_description character varying,
    conf_var_types_id integer,
    conf_var_types_name character varying,
    code_systolic_coding_system_snomed text,
    code_systolic_coding_code_snomed character varying,
    code_systolic_coding_system_loinc text,
    code_systolic_coding_code_loinc character varying,
    code_systolic_coding_system_ieee text,
    code_systolic_coding_code_ieee character varying,
    code_mean_coding_system_snomed text,
    code_mean_coding_code_snomed character varying,
    code_mean_coding_system_loinc text,
    code_mean_coding_code_loinc character varying,
    code_mean_coding_system_ieee text,
    code_mean_coding_code_ieee character varying,
    code_diastolic_coding_system_snomed text,
    code_diastolic_coding_code_snomed character varying,
    code_diastolic_coding_system_loinc text,
    code_diastolic_coding_code_loinc character varying,
    code_diastolic_coding_system_ieee text,
    code_diastolic_coding_code_ieee character varying,
    matching_valide boolean
);


--
-- Name: mapping_mii_co6_2; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.mapping_mii_co6_2 (
    profile_id integer,
    profile_name character varying,
    category_coding_system text,
    category_coding_code character varying,
    code_coding_system_snomed text,
    code_coding_code_snomed character varying,
    code_coding_system_loinc text,
    code_coding_code_loinc character varying,
    code_coding_system_ieee text,
    code_coding_code_ieee character varying,
    valuequantity_system text,
    valuequantity_code character varying,
    conf_var_unit character varying,
    device_reference text,
    meta_profile text,
    conf_var_id bigint,
    conf_var_parent_id bigint,
    conf_var_parent_name character varying,
    conf_var_name character varying,
    conf_var_description character varying,
    conf_var_types_id integer,
    conf_var_types_name character varying,
    code_systolic_coding_system_snomed text,
    code_systolic_coding_code_snomed character varying,
    code_systolic_coding_system_loinc text,
    code_systolic_coding_code_loinc character varying,
    code_systolic_coding_system_ieee text,
    code_systolic_coding_code_ieee character varying,
    code_mean_coding_system_snomed text,
    code_mean_coding_code_snomed character varying,
    code_mean_coding_system_loinc text,
    code_mean_coding_code_loinc character varying,
    code_mean_coding_system_ieee text,
    code_mean_coding_code_ieee character varying,
    code_diastolic_coding_system_snomed text,
    code_diastolic_coding_code_snomed character varying,
    code_diastolic_coding_system_loinc text,
    code_diastolic_coding_code_loinc character varying,
    code_diastolic_coding_system_ieee text,
    code_diastolic_coding_code_ieee character varying,
    matching_valide boolean,
    unit_transform numeric DEFAULT 1
);


--
-- Name: mapping_mii_co6_2_result; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.mapping_mii_co6_2_result (
    profile_id integer,
    profile_name character varying,
    category_coding_system text,
    category_coding_code character varying,
    code_coding_system_snomed text,
    code_coding_code_snomed character varying,
    code_coding_system_loinc text,
    code_coding_code_loinc character varying,
    code_coding_system_ieee text,
    code_coding_code_ieee character varying,
    valuequantity_system text,
    valuequantity_code character varying,
    conf_var_unit character varying,
    device_reference text,
    meta_profile text,
    conf_var_id bigint,
    conf_var_parent_id bigint,
    conf_var_parent_name character varying,
    conf_var_name character varying,
    conf_var_description character varying,
    conf_var_types_id integer,
    conf_var_types_name character varying,
    code_systolic_coding_system_snomed text,
    code_systolic_coding_code_snomed character varying,
    code_systolic_coding_system_loinc text,
    code_systolic_coding_code_loinc character varying,
    code_systolic_coding_system_ieee text,
    code_systolic_coding_code_ieee character varying,
    code_mean_coding_system_snomed text,
    code_mean_coding_code_snomed character varying,
    code_mean_coding_system_loinc text,
    code_mean_coding_code_loinc character varying,
    code_mean_coding_system_ieee text,
    code_mean_coding_code_ieee character varying,
    code_diastolic_coding_system_snomed text,
    code_diastolic_coding_code_snomed character varying,
    code_diastolic_coding_system_loinc text,
    code_diastolic_coding_code_loinc character varying,
    code_diastolic_coding_system_ieee text,
    code_diastolic_coding_code_ieee character varying,
    matching_valide boolean,
    unit_transform numeric,
    profil_generic character varying,
    profil_generic_id integer
);


--
-- Name: mapping_mii_co6_raw; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.mapping_mii_co6_raw (
    conf_var_id bigint,
    conf_var_parent_id bigint,
    conf_var_parent_name character varying,
    profile_name text,
    conf_var_name character varying,
    conf_var_description character varying,
    conf_var_unit character varying,
    profile_unit text,
    conf_var_types_id integer,
    conf_var_types_name character varying,
    loinc character varying,
    url_loinc text,
    snomed character varying,
    url_snomed text,
    matching integer,
    quantities bigint
);


--
-- Name: mapping_mii_co6_tmp; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.mapping_mii_co6_tmp (
    conf_var_id bigint,
    conf_var_parent_id bigint,
    conf_var_parent_name character varying,
    profile_name text,
    conf_var_name character varying,
    conf_var_description character varying,
    conf_var_unit character varying,
    profile_unit text,
    conf_var_types_id integer,
    conf_var_types_name character varying,
    loinc character varying,
    snomed character varying,
    ieee character varying,
    matching_valide boolean,
    quantities bigint,
    profile_type character varying
);


--
-- Name: mapping_mii_copra_old; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.mapping_mii_copra_old (
    conf_var_id bigint,
    conf_var_parent_id bigint,
    conf_var_parent_name character varying,
    profile_name text,
    conf_var_name character varying,
    conf_var_description character varying,
    conf_var_unit character varying,
    profile_unit text,
    conf_var_types_id integer,
    conf_var_types_name character varying,
    loinc character varying,
    url_loinc text,
    snomed character varying,
    url_snomed text,
    matching integer,
    quantities bigint,
    profile_type character varying DEFAULT 'Observation'::character varying,
    ieee character varying
);


--
-- Name: mii_icu_changed_provi; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.mii_icu_changed_provi (
    profile_name character varying NOT NULL,
    profile_type character varying NOT NULL,
    profile_unit character varying,
    profile_status character varying NOT NULL,
    mapped boolean,
    ops character varying,
    loinc character varying,
    ieee character varying,
    snomed character varying
);


--
-- Name: mii_icu_new; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.mii_icu_new (
    profile_name character varying NOT NULL,
    profile_type character varying NOT NULL,
    profile_status character varying NOT NULL,
    profile_datum character varying
);


--
-- Name: mii_icu_used; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.mii_icu_used (
    id_profile integer NOT NULL,
    profile character varying NOT NULL,
    typ character varying NOT NULL
);


--
-- Name: mii_icu_used_all_info; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.mii_icu_used_all_info (
    id_profile integer,
    standard character varying,
    matched text,
    typ_standard character varying,
    profile_unit text,
    loinc character varying,
    snomed character varying,
    ieee text,
    matching_to_control integer,
    mathching integer
);


--
-- Name: mii_icu_used_id_profile_seq; Type: SEQUENCE; Schema: mii_copra; Owner: -
--

CREATE SEQUENCE mii_copra.mii_icu_used_id_profile_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mii_icu_used_id_profile_seq; Type: SEQUENCE OWNED BY; Schema: mii_copra; Owner: -
--

ALTER SEQUENCE mii_copra.mii_icu_used_id_profile_seq OWNED BY mii_copra.mii_icu_used.id_profile;


--
-- Name: profile_config_vars_python; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.profile_config_vars_python (
    profil character varying,
    config_var_name_description character varying,
    score integer
);


--
-- Name: quantities_conf_var; Type: TABLE; Schema: mii_copra; Owner: -
--

CREATE TABLE mii_copra.quantities_conf_var (
    quantities bigint,
    id_conf_var bigint NOT NULL,
    name_conf_var character varying NOT NULL,
    description_conf_var character varying
);


--
-- Name: v_copra_not_units; Type: VIEW; Schema: mii_copra; Owner: -
--

CREATE VIEW mii_copra.v_copra_not_units AS
 SELECT mmcf.conf_var_id,
    mmcf.conf_var_name,
    mmcf.conf_var_description,
    mmcf.conf_var_unit
   FROM mii_copra.mapping_mii_copra_old mmcf
  WHERE (mmcf.conf_var_unit IS NULL);


--
-- Name: v_mii_icu_new_old; Type: VIEW; Schema: mii_copra; Owner: -
--

CREATE VIEW mii_copra.v_mii_icu_new_old AS
 SELECT n.profile_name AS new_profile,
    o.profile_name AS old_profile
   FROM (mii_copra.mii_icu_new n
     FULL JOIN mii_copra.mii_icu_changed_provi o ON (((o.profile_name)::text = (n.profile_name)::text)))
  ORDER BY n.profile_name;


--
-- Name: v_not_in_copra; Type: VIEW; Schema: mii_copra; Owner: -
--

CREATE VIEW mii_copra.v_not_in_copra AS
 SELECT mii_icu_new.profile_name,
    0 AS mapped
   FROM mii_copra.mii_icu_new
  WHERE (NOT ((mii_icu_new.profile_name)::text IN ( SELECT mmcf.profile_name
           FROM mii_copra.mapping_mii_copra_old mmcf)));


--
-- Name: v_observations_units; Type: VIEW; Schema: mii_copra; Owner: -
--

CREATE VIEW mii_copra.v_observations_units AS
 SELECT count(miuai.id_profile) AS "Anzahl",
        CASE
            WHEN (miuai.profile_unit IS NOT NULL) THEN 'unit'::text
            ELSE 'not unit'::text
        END AS "Einheit"
   FROM mii_copra.mii_icu_used_all_info miuai
  WHERE ((miuai.typ_standard)::text = 'Observation'::text)
  GROUP BY
        CASE
            WHEN (miuai.profile_unit IS NOT NULL) THEN 'unit'::text
            ELSE 'not unit'::text
        END;


--
-- Name: v_orbservations_no_units; Type: VIEW; Schema: mii_copra; Owner: -
--

CREATE VIEW mii_copra.v_orbservations_no_units AS
 SELECT miuai.standard
   FROM mii_copra.mii_icu_used_all_info miuai
  WHERE (((miuai.typ_standard)::text = 'Observation'::text) AND (miuai.profile_unit IS NULL));


--
-- Name: v_profile_codesystems; Type: VIEW; Schema: mii_copra; Owner: -
--

CREATE VIEW mii_copra.v_profile_codesystems AS
 SELECT count(miuai.id_profile) AS "Anzahl",
    'LOINC'::text AS "Codesystem"
   FROM mii_copra.mii_icu_used_all_info miuai
  WHERE (miuai.loinc IS NOT NULL)
UNION
 SELECT count(miuai.id_profile) AS "Anzahl",
    'SNOMED-CT'::text AS "Codesystem"
   FROM mii_copra.mii_icu_used_all_info miuai
  WHERE (miuai.snomed IS NOT NULL)
UNION
 SELECT count(miuai.id_profile) AS "Anzahl",
    'IEEE'::text AS "Codesystem"
   FROM mii_copra.mii_icu_used_all_info miuai
  WHERE (miuai.ieee IS NOT NULL)
UNION
 SELECT count(mii_icu_used_all_info.id_profile) AS "Anzahl",
    'Gesamt'::text AS "Codesystem"
   FROM mii_copra.mii_icu_used_all_info
UNION
 SELECT count(mii_icu_used_all_info.id_profile) AS "Anzahl",
    'no Codesystem'::text AS "Codesystem"
   FROM mii_copra.mii_icu_used_all_info
  WHERE ((mii_icu_used_all_info.loinc IS NULL) AND (mii_icu_used_all_info.snomed IS NULL) AND (mii_icu_used_all_info.ieee IS NULL))
  ORDER BY 1;


--
-- Name: v_profile_no_codesystem; Type: VIEW; Schema: mii_copra; Owner: -
--

CREATE VIEW mii_copra.v_profile_no_codesystem AS
 SELECT mii_icu_used_all_info.standard,
    mii_icu_used_all_info.typ_standard
   FROM mii_copra.mii_icu_used_all_info
  WHERE ((mii_icu_used_all_info.loinc IS NULL) AND (mii_icu_used_all_info.snomed IS NULL) AND (mii_icu_used_all_info.ieee IS NULL))
  ORDER BY mii_icu_used_all_info.standard;


--
-- Name: v_profiles_matching; Type: VIEW; Schema: mii_copra; Owner: -
--

CREATE VIEW mii_copra.v_profiles_matching AS
 SELECT DISTINCT miu.profile AS standard,
    mi.profile_name AS matched,
    miu.typ AS typ_standard
   FROM (mii_copra.mapping_mii_copra_old mi
     RIGHT JOIN mii_copra.mii_icu_used miu ON ((mi.profile_name = (miu.profile)::text)))
  ORDER BY miu.profile, mi.profile_name;


--
-- Name: mii_icu profile_id; Type: DEFAULT; Schema: mii_copra; Owner: -
--

ALTER TABLE ONLY mii_copra.mii_icu ALTER COLUMN profile_id SET DEFAULT nextval('mii_copra.fhir_profile_observations_profile_id_seq'::regclass);


--
-- Name: mii_icu_used id_profile; Type: DEFAULT; Schema: mii_copra; Owner: -
--

ALTER TABLE ONLY mii_copra.mii_icu_used ALTER COLUMN id_profile SET DEFAULT nextval('mii_copra.mii_icu_used_id_profile_seq'::regclass);


--
-- Data for Name: co6_config_variable_types; Type: TABLE DATA; Schema: copra; Owner: -
--

COPY copra.co6_config_variable_types (id, name, tablename) FROM stdin;
\.


--
-- Data for Name: co6_config_variables; Type: TABLE DATA; Schema: copra; Owner: -
--

COPY copra.co6_config_variables (id, name, description, unit, co6_config_variabletypes_id, parent, deleted) FROM stdin;
\.


--
-- Data for Name: co6_data_decimal_6_3; Type: TABLE DATA; Schema: copra; Owner: -
--

COPY copra.co6_data_decimal_6_3 (id, varid, deleted, parent_id, parent_varid, val, datetimeto, validated, flagcurrent) FROM stdin;
\.


--
-- Data for Name: co6_data_object; Type: TABLE DATA; Schema: copra; Owner: -
--

COPY copra.co6_data_object (id, varid, parent_id, parent_varid, flagcurrent) FROM stdin;
\.


--
-- Data for Name: co6_data_string; Type: TABLE DATA; Schema: copra; Owner: -
--

COPY copra.co6_data_string (id, varid, parent_id, parent_varid, datetimeto, val, deleted, flagcurrent) FROM stdin;
\.


--
-- Data for Name: co6_medic_data_patient; Type: TABLE DATA; Schema: copra; Owner: -
--

COPY copra.co6_medic_data_patient (id, geb, geschlecht, patid) FROM stdin;
\.


--
-- Data for Name: co6_medic_pressure; Type: TABLE DATA; Schema: copra; Owner: -
--

COPY copra.co6_medic_pressure (id, varid, parent_id, parent_varid, systolic, mean, diastolic, datetimeto, validated, deleted, flagcurrent) FROM stdin;
\.


--
-- Data for Name: mapping_mii_co6_2; Type: TABLE DATA; Schema: copra; Owner: -
--

COPY copra.mapping_mii_co6_2 (profile_id, profile_name, category_coding_system, category_coding_code, code_coding_system_snomed, code_coding_code_snomed, code_coding_system_loinc, code_coding_code_loinc, code_coding_system_ieee, code_coding_code_ieee, valuequantity_system, valuequantity_code, conf_var_unit, device_reference, meta_profile, conf_var_id, conf_var_parent_id, conf_var_parent_name, conf_var_name, conf_var_description, conf_var_types_id, conf_var_types_name, code_systolic_coding_system_snomed, code_systolic_coding_code_snomed, code_systolic_coding_system_loinc, code_systolic_coding_code_loinc, code_systolic_coding_system_ieee, code_systolic_coding_code_ieee, code_mean_coding_system_snomed, code_mean_coding_code_snomed, code_mean_coding_system_loinc, code_mean_coding_code_loinc, code_mean_coding_system_ieee, code_mean_coding_code_ieee, code_diastolic_coding_system_snomed, code_diastolic_coding_code_snomed, code_diastolic_coding_system_loinc, code_diastolic_coding_code_loinc, code_diastolic_coding_system_ieee, code_diastolic_coding_code_ieee, matching_valide, unit_transform) FROM stdin;
1	Arterieller Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	386534000	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Arterieller-Druck	100089	1	Patient	ABP_2	zweiter arterieller Blutdruck	12	Medic_Pressure	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
1	Arterieller Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	386534000	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Arterieller-Druck	103010	1	Patient	Nierenverfahren_MS_Multi_artDruck	arterieller Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
1	Arterieller Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	386534000	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Arterieller-Druck	100093	1	Patient	ABP_1	arterieller Blutdruck 1	12	Medic_Pressure	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
2	Atemfrequenz	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	86290005	https://loinc.org/9279-1/	9279-1	\N	\N	http://unitsofmeasure.org	/min	1/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Atemfrequenz	1267	1	Patient	AF	Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
3	Atemzugvolumen-Waehrend-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	250874002	http://loinc.org	76222-9	urn:iso:std:iso:11073:10101	151980	http://unitsofmeasure.org	mL	ml	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Atemzugvolumen-Waehrend-Beatmung	104726	1	Patient	Beatmung_MS_Pallas_Vt	Gemessenes Tidalvolumen.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
4	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	426102006	http://loinc.org	76009-0	urn:iso:std:iso:11073:10101	152004	http://unitsofmeasure.org	L/min	L/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/SBeatmungsvolumen-Pro-Minute-Machineller-Beatmung	103320	1	Patient	Beatmung_MS_Evita4_MV	gemessenes Atemminutenvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
4	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	426102006	http://loinc.org	76009-0	urn:iso:std:iso:11073:10101	152004	http://unitsofmeasure.org	L/min	L/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/SBeatmungsvolumen-Pro-Minute-Machineller-Beatmung	100098	1	Patient	Beatmung_Messung_MV	Mindest Volumen tot.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
4	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	426102006	http://loinc.org	76009-0	urn:iso:std:iso:11073:10101	152004	http://unitsofmeasure.org	L/min	L/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/SBeatmungsvolumen-Pro-Minute-Machineller-Beatmung	104725	1	Patient	Beatmung_MS_Pallas_MV	Gemessenes Atemminutenvolumen.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
5	Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck	100094	1	Patient	NBP_1	nichtinvasiver Blutdruck 1	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1
5	Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck	104356	1	Patient	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1
5	Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck	106468	1	Patient	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1
6	Blutdruck Generisch	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck-Generisch	106468	1	Patient	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1
6	Blutdruck Generisch	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck-Generisch	100094	1	Patient	NBP_1	nichtinvasiver Blutdruck 1	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1
6	Blutdruck Generisch	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck-Generisch	104356	1	Patient	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1
7	Blutfluss durch cardiovasculäres Gerät	http://snomed.info/sct	182744004	http://snomed.info/sct	444479000	\N	\N	\N	\N	http://unitsofmeasure.org	L/min	L/Min	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutfluss-Cardiovasculaeres-Geraet	106332	1	Patient	CardioHelpMaquet_MS_Blutfluss	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
8	Druckdifferenz Beatmung	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76154-4	urn:iso:std:iso:11073:10101	152720	http://unitsofmeasure.org	cm[H2O]	cm H2O	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Druckdifferenz-Beatmung	103078	1	Patient	Beatmung_MS_VisionA_Amplitude	gemessene Druckdifferenz im HFOV Modus	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
9	Einstellung-Einatmungszeit-Beatmung	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76334-2	urn:iso:std:iso:11073:10101	16929632	http://unitsofmeasure.org	s	s	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Einstellung-Einatmungszeit-Beatmung	103297	1	Patient	Beatmung_ES_Evita4_Tinsp	eingestellte absolute Inspirationszeit	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
9	Einstellung-Einatmungszeit-Beatmung	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76334-2	urn:iso:std:iso:11073:10101	16929632	http://unitsofmeasure.org	s	s	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Einstellung-Einatmungszeit-Beatmung	102887	1	Patient	Beatmung_ES_G5_Ti	Einstelungswert für die Inspirationszeit	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
10	Exspiratorischer Gasfluss	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	60792-9	urn:iso:std:iso:11073:10101	151944	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Exspiratorischer-Gasfluss	102915	1	Patient	Beatmung_MS_G5_ExspFlow	Exspiratorischer Peakflow, ein Monitoring-Parameter	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
11	Exspiratorischer Sauerstoffpartialdruck	http://snomed.info/sct	40617009	http://snomed.info/sct	250775008	http://loinc.org	3147-6	urn:iso:std:iso:11073:10101	153132	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Exspiratorischer-Sauerstoffpartialdruck	103817	1	Patient	PtiO2Druck	Gemessener Sauerstoffpartialdruck im Parenchym	12	Medic_Pressure	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
12	Herzfrequenz	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	364075005	http://loinc.org	8867-4	\N	\N	http://unitsofmeasure.org	/min	1/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzfrequenz	1266	1	Patient	HF	Herzfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
13	Herzzeitvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	82799009	http://loinc.org	8741-1	urn:iso:std:iso:11073:10101	150276	http://unitsofmeasure.org	L/min	L/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzzeitvolumen	102184	1	Patient	VigilanceC_HZV	Herzzeitvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
13	Herzzeitvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	82799009	http://loinc.org	8741-1	urn:iso:std:iso:11073:10101	150276	http://unitsofmeasure.org	L/min	L/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzzeitvolumen	102051	1	Patient	HZV	Herzzeitvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
14	Inspiratorischer Gasfluss	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76275-7	urn:iso:std:iso:11073:10101	151948	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Eingestellter-Inspiratorischer-Gasfluss	102903	1	Patient	Beatmung_MS_G5_InspFlow	Inspiratorischer Peakflow, ein Monitoring-Parameter	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
15	Intrakranieller Druck (ICP)	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	250844005	http://loinc.org	60956-0	urn:iso:std:iso:11073:10101	153608	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Intrakranieller-Druck-ICP	100088	1	Patient	ICP	Intrakranialer Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
16	Ionisiertes Kalzium aus Nierenersatzverfahren	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	83064-6	\N	\N	http://unitsofmeasure.org	mmol/L	mmol/l	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Ionisiertes-Kalzium-Nierenersatzverfahren	103058	1	Patient	Nierenverfahren_ES_Multi_CalciumFiltrat	Calciumrate	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
16	Ionisiertes Kalzium aus Nierenersatzverfahren	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	83064-6	\N	\N	http://unitsofmeasure.org	mmol/L	mmol/L	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Ionisiertes-Kalzium-Nierenersatzverfahren	104974	1	Patient	NEV_CRRT_ES_Multi_CalciumFiltrat	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
17	Koerpergewicht	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	27113001	http://loinc.org	29463-7	\N	\N	http://unitsofmeasure.org	kg	kg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpergewicht	6	1	Patient	Patient_Gewicht	Gewicht des Patienten	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
17	Koerpergewicht	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	27113001	http://loinc.org	29463-7	\N	\N	http://unitsofmeasure.org	kg	kg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpergewicht	101322	20	Fall	Patient_AufnGewicht	Aufnahmegewicht (fallbezogen)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
18	Koerpergroesse	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	1153637007	http://loinc.org	8302-2	\N	\N	http://unitsofmeasure.org	cm	cm	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpergroesse	7	1	Patient	Patient_Groesse	Größe des Patienten	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
19	Koerpertemperatur Kern	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	276885007	http://loinc.org	8329-5	urn:iso:std:iso:11073:10101	150368	http://unitsofmeasure.org	Cel	°C	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpertemperatur-Kern	110933	1	Patient	P_Temperatur_Kern	Anlage für Philips Monitoring	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
20	Kopfumfang	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	\N	\N	http://loinc.org	9843-4	\N	\N	http://unitsofmeasure.org	cm	cm	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Kopfumfang	11	1	Patient	COPRA_Patient_Kopfumfang	Kopfumfang des Patienten in Zentimetern	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
21	Linksatrialer Druck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksatrialer-Druck	100091	1	Patient	LAP	Linksatrial  Mitteldruck	6	Decimal_6_3	\N	\N	http://loinc.org	60989-1	urn:iso:std:iso:11073:10101	150065	\N	\N	http://loinc.org	8399-8	urn:iso:std:iso:11073:10101	150067	\N	\N	http://loinc.org	75933-2	urn:iso:std:iso:11073:10101	150066	t	1
22	Linksventrikulaerer Schlagvolumenindex	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	277381004	http://loinc.org	76297-1	urn:iso:std:iso:11073:10101	149764	http://unitsofmeasure.org	mL/m2	ml/m2	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaerer-Schlagvolumenindex	102036	1	Patient	p-SVI	Schlagvolumenindex  (PICCO Modul Dräger Monitoring)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	1/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	101442	1	Patient	Beatmung_Messung_AF	Breathing Frequency	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	1/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	104727	1	Patient	Beatmung_MS_Pallas_Frequenz	Gemessene Atemfrequenz.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	1/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	100108	1	Patient	Beatmung_Einstellung_AF	Beatmungsfrequenz (f/AF)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	AZ/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	103035	1	Patient	Beatmung_MS_G5_ftotal	Gesamtatemfrequenz, ein Monitoring Parameter	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	bpm	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	103323	1	Patient	Beatmung_MS_Evita4_frequenz	gemessene Gesamtatemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
24	Mittlerer Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76530-5	urn:iso:std:iso:11073:10101	151975	http://unitsofmeasure.org	cm[H2O]	cm H2O	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mittlerer-Beatmungsdruck	102873	1	Patient	Beatmung_ES_VisionA_MAP	Mittlerer Atemwegsdruck (MAP)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
24	Mittlerer Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76530-5	urn:iso:std:iso:11073:10101	151975	http://unitsofmeasure.org	cm[H2O]	cm H2O	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mittlerer-Beatmungsdruck	102878	1	Patient	Beatmung_MS_VisionA_MAP	gemessener Mittlerer Atemwegsdruck unter HFO bei Alpha Vision	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
24	Mittlerer Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76530-5	urn:iso:std:iso:11073:10101	151975	http://unitsofmeasure.org	cm[H2O]	[cmH2O]	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mittlerer-Beatmungsdruck	104249	1	Patient	Beatmung_MS_Servoi_Pmean	Mittlerer Atemwegsdruck 	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	[cmH2O]	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	104264	1	Patient	Beatmung_ES_Servoi_PEEP	PEEP 	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
26	Pulmonalarterieller Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Pulmonalarterieller-Blutdruck	102050	1	Patient	PAP	Pulmunalarterieller Druck	12	Medic_Pressure	\N	\N	http://loinc.org	8440-0	urn:iso:std:iso:11073:10101	150045	\N	\N	http://loinc.org	8414-5	urn:iso:std:iso:11073:10101	150047	\N	\N	http://loinc.org	8385-7	urn:iso:std:iso:11073:10101	150046	t	1
27	Pulmonalarterieller wedge Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	118433006	http://loinc.org	75994-4	urn:iso:std:iso:11073:10101	150052	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Pulmonalarterieller-Wedge-Druck	102018	1	Patient	PWP	Pulmunaler Wedgedruck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
29	Sauerstofffraktion eingestellt	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	%	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103296	1	Patient	Beatmung_ES_Evita4_O2Konzentration	eingestellte O2 Konzentration des Frischgases	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
29	Sauerstofffraktion eingestellt	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	%	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103214	1	Patient	Beatmung_ES_3100B_O2Konzentration	Einstellwert: O2 Konzentration des Gasgemisches	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
29	Sauerstofffraktion eingestellt	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	%	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	100105	1	Patient	Beatmung_Einstellung_FiO2	O²- Konzentration im Inspirationsgemisch (FiO2)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
30	Sauerstoffgasfluss	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	19941-4	\N	\N	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffgasfluss	106784	1	Patient	Beatmung_ES_Optiflow_O2Flow	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
30	Sauerstoffgasfluss	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	19941-4	\N	\N	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffgasfluss	103091	1	Patient	Beatmung_ES_CF800_SauerstoffFlow	Einstellgröße Gasfluss Sauerstoff	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
31	Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	\N	\N	http://loinc.org	59408-5	urn:iso:std:iso:11073:10101	150456	http://unitsofmeasure.org	%	%	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffsaettigung-Im-Arteriellen-Blut-Per-Pulsoxymetrie	102010	1	Patient	SpO2	Sauerstoffsättigung Pulsoxymetrie	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
32	Spontane-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19839-0	urn:iso:std:iso:11073:10101	152498	http://unitsofmeasure.org	/min	AZ/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Atemfrequenz-Beatmet	103036	1	Patient	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
32	Spontane-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19839-0	urn:iso:std:iso:11073:10101	152498	http://unitsofmeasure.org	/min	1/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Atemfrequenz-Beatmet	100270	1	Patient	Beatmung_Messung_AFSpontan	Respiratory Rate (spontan)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
32	Spontane-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19839-0	urn:iso:std:iso:11073:10101	152498	http://unitsofmeasure.org	/min	bpm	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Atemfrequenz-Beatmet	103324	1	Patient	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
33	Spontane-Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19840-8	urn:iso:std:iso:11073:10101	152490	http://unitsofmeasure.org	/min	AZ/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Mechanische-Atemfrequenz-Beatmet	103036	1	Patient	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	Vol%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103314	1	Patient	Beatmung_MS_Evita4_FiO2	gemessene O2 Konzentration des inspiratorischen Atemgasgemisches	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0.01
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103216	1	Patient	Beatmung_MS_3100B_O2Konzentration	Messwert: gemessene O2 Konzentration des Gasgemisches	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0.01
33	Spontane-Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19840-8	urn:iso:std:iso:11073:10101	152490	http://unitsofmeasure.org	/min	bpm	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Mechanische-Atemfrequenz-Beatmet	103324	1	Patient	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
34	Substituatfluss	http://snomed.info/sct	182744004	http://snomed.info/sct	708513005	\N	\N	\N	\N	http://unitsofmeasure.org	mL/h	mL/h	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Substituatfluss	102992	1	Patient	Nierenverfahren_ES_BM25_Umsatz	Austausch, Substituat, ml/h	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
34	Substituatfluss	http://snomed.info/sct	182744004	http://snomed.info/sct	708513005	\N	\N	\N	\N	http://unitsofmeasure.org	mL/h	mL/h	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Substituatfluss	102978	1	Patient	Nierenverfahren_ES_Multi_Substituat	Umsatz, Austausch Substituat ml/h	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
35	Venöser Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	252076005	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Venoeser-Druck	103011	1	Patient	Nierenverfahren_MS_Multi_venDruck	venöser Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
37	Zentralvenoeser Druck (ZVD)	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	71420008	http://loinc.org	60985-9	urn:iso:std:iso:11073:10101	150084	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Zentralvenoeser-Blutdruck	1269	1	Patient	ZVD	Zentralvenöser Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	102030	1	Patient	SV	Schlagvolumen 	3	String	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	102874	1	Patient	Beatmung_ES_VisionA_Schlagvolumen	Schlagvolumen (SV) in engl. (cycle volume)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	102408	1	Patient	p-SV	Schlagvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	104758	1	Patient	Schlagvolumen	gemessenes Schlagvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	100102	1	Patient	Beatmung_Einstellung_PEEP	Positiver endexspiratorischer Druck (PEEP)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	103943	1	Patient	Beatmung_ES_Heimbeatmung_Peep	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	100275	1	Patient	Beatmung_Messung_PEEP	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	104722	1	Patient	Beatmung_MS_Pallas_PEEP	Dokumentation des gemessenen PEEPs.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	101444	1	Patient	Beatmung_Messung_IntrinsicPEEP	Intrinsic PEEP	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972
38	Dauer Haemodialysesitzung	http://snomed.info/sct	182744004	http://snomed.info/sct	445940005	\N	\N	\N	\N	http://unitsofmeasure.org	h	min	DeviceMetric/Example_Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Dauer-Haemodialysesitzung	110772	1	Patient	P_NEV_HD_MS_5008onl_Rest_Zeit_min	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0.016666667
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	103318	1	Patient	Beatmung_MS_Evita4_PEEP	gemessener positiver endexspiratorischer Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972
41	Maximaler Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76531-3	urn:iso:std:iso:11073:10101	151973	http://unitsofmeasure.org	cm[H2O]	mmHg	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Maximaler-Beatmungsdruck	100300	1	Patient	Beatmung_Messung_Pmax	Peak Airway Pressure	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.35951
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	100100	1	Patient	Beatmung_Messung_FiO2	FiO2	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0.01
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	104730	1	Patient	Beatmung_MS_Pallas_O2_insp	Gemessene inspiratorische O2 Konzentration.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0.01
\.


--
-- Data for Name: co6_config_variable_types; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.co6_config_variable_types (id, name, tablename, storagetype) FROM stdin;
1	Object	CO6_Data_Object	1
2	Long	CO6_Data_Long	2
3	String	CO6_Data_String	2
5	DateTime	CO6_Data_DateTime	2
6	Decimal_6_3	CO6_Data_Decimal_6_3	2
12	Medic_Pressure	CO6_Medic_Pressure	2
13	DrugApplication	CO6_Medic_Data_DrugApplication	1
14	Drug	CO6_Medic_Data_Drug	2
15	Link	CO6_Data_Link	2
16	DrugMixture	CO6_Medic_Data_DrugMixture	1
17	FixedDateTime	CO6_Data_DateTime	2
18	LaborValue	CO6_Medic_Data_Labor	2
19	BarValue	CO6_Data_BarValue	2
20	RespirationBarValue	CO6_Data_BarValue	2
21	GroupedParameterObject	CO6_Data_GroupedParameterObject	1
22	DrugApplicationObject	CO6_Medic_Data_DrugApplication	1
23	StaffMemberObject	CO6_Admin_User_Properties	1
24	DrugOrder	CO6_Medic_Data_DrugApplication	1
25	GroupedParameterPropertyObject	CO6_Data_GroupedParameterPropertyObject	1
26	ApparatusBar	CO6_Medic_Data_ApparatusBar	2
27	SubScore	CO6_Medic_Data_SubScore	2
28	OrganisationalUnitObject	CO6_Admin_OrganisationalUnit_Properties	1
29	StringOrder	CO6_Data_String_Order	2
30	Decimal_6_3Order	CO6_Data_Decimal_6_3_Order	2
31	StringProcedure	CO6_Data_String_Order	2
32	Decimal_6_3Procedure	CO6_Data_Decimal_6_3_Order	2
33	Picture	CO6_Data_Binary	2
34	ListValue	CO6_Data_ReferencedValue	2
35	DrugOrderV2	CO6_Medic_Data_DrugOrderV2	1
36	SingleDrugOrder	CO6_Medic_Data_SingleDrugOrder	2
37	TransientObject	CO6_Data_Object	1
38	TemporalAssignment	CO6_Data_TemporalAssignment	2
39	DurationString	CO6_Data_DurationString	2
41	CareDiagnosisObject	CO6_Medic_Data_Care_Diagnosis	1
42	CareAimObject	CO6_Medic_Data_Care_Aims	1
43	CareInterventionObject	CO6_Medic_Data_Care_Interventions	1
44	CareTextObject	CO6_Medic_Data_Care_Texts	1
45	CareExecutionValue	CO6_Medic_Data_Care_Executions	2
46	CareEvaluationValue	CO6_Medic_Data_Care_Evaluations	2
47	CareLinkValue	CO6_Medic_Data_Care_Links	1
48	CareInterventionBreakValue	CO6_Medic_Data_Care_InterventionBreaks	2
50	LEPEventData	CO6_LEP_Data_Value	2
51	LEPInformationData	CO6_LEP_Data_Value	2
52	LEPTimeLineData	CO6_LEP_Data_Value	2
53	MergeSourceLink	CO6_Data_Link	2
54	MergeTargetLink	CO6_Data_Link	2
55	PdfValue	CO6_Data_Binary	2
\.


--
-- Data for Name: co6_config_variables; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.co6_config_variables (id, name, description, unit, co6_config_variabletypes_id, parent, deleted, loinc, displayname) FROM stdin;
1	Patient	Patient	\N	1	0	\N	\N	\N
2	Patient_Name	Name des Patiente	\N	3	1	\N	\N	\N
3	Patient_Vorname	Vorname des Patiente	\N	3	1	\N	\N	\N
4	Patient_Geburtsdatum	Geburtsdatum des Patienten	\N	17	1	\N	\N	\N
5	Patient_Geschlecht	Geschlecht des Patienten	\N	3	1	\N	\N	\N
8	Patient_ID	Identifikation des Patiente	\N	3	1	\N	\N	\N
20	Fall	Fall	\N	1	1	\N	\N	\N
21	Fall_Aufnahme	Aufnahmezeitpunkt für den Fall	\N	5	20	\N	\N	\N
22	Fall_Entlassung	Entlassungszeitpunkt für den Fall	\N	5	20	\N	\N	\N
23	Fall_Nummer	Identifikationsnummer des Falles	\N	3	20	\N	\N	\N
30	Behandlung	Behandlung	\N	1	20	\N	\N	\N
40	Behandlungsort	Behandlungsort	\N	1	0	\N	\N	\N
50	Belegung	Belegung eines Behandlungsortes	\N	1	40	\N	\N	\N
10067	CO_Arzt_Verordnungen_angemeldet	Diagnostik- bzw. Konsilanforderung angemeldet	\N	2	10066	\N	\N	Diagnostik- bzw. Konsilanforderung angemeldet
10068	CO_Arzt_Verordnungen_Befund	Befund zur Diagnostik- bzw. Konsilanforderung	\N	3	10066	\N	\N	Befund zur Diagnostik- bzw. Konsilanforderung
10069	CO_Arzt_Verordnungen_Beginn	Zeitpunkt, zu dem die Diagnostik- bzw. Konsilanforderung geschrieben wurde	\N	5	10066	\N	\N	Zeitpunkt der Diagnostik- bzw. Konsilanforderung
10070	CO_Arzt_Verordnungen_Fragestellung	Fragestellung zur Diagnostik- bzw. Konsilanforderung	\N	3	10066	\N	\N	Fragestellung zur Diagnostik- bzw. Konsilanforderu
10071	CO_Arzt_Verordnungen_erledigt	Zeitpunkt der erledigten Diagnostik- bzw. Konsilanforderung	\N	5	10066	\N	\N	Zeitpunkt der erledigten Diagnostik- bzw. Konsilan
10072	CO_Arzt_Verordnungen_Befundender	Name des Arztes, der die Diagnostik- bzw. Konsilanforderung befundet.	\N	3	10066	\N	\N	Name des Arztes, der die Diagnostik- bzw. Konsilan
104122	Schleuse_nach_Standard	\N	\N	19	100471	\N	\N	\N
61	Medikamentengabe	Medikamentengabe	\N	13	60	\N	\N	\N
62	Medikament	Medikament	\N	14	60	\N	\N	\N
65	Medikamentengabe_NichtVerordnetGrund	Grund der Nicht-Nachverordnung von einer Gabe	\N	3	61	\N	\N	\N
66	Medikament_Verordnung	Medikament einer Verordnung	\N	14	90	\N	\N	\N
70	Medikamentengabe_Object	Darstellung der Medikamentengabe als Objekt	\N	22	60	\N	\N	\N
75	Medikamentenverordnung	Verordnung für ein Medikament.	\N	24	60	\N	\N	\N
76	Medikamentengabe_Verordnung	Referenz auf die Verordnung, welche durch diese Gabe erfüllt wurde.	\N	15	61	\N	\N	\N
80	Organisationseinheit	Organisationseinheit	\N	28	0	\N	\N	\N
90	Medikamentenverordnung_V2	Verordnung von Serien	\N	35	1	\N	\N	\N
91	Einzelverordnung	Wird beim Dokumentieren und Nachverordnen einer Gabe erzeugt.	\N	36	90	\N	\N	\N
120	Computer	Computer	\N	1	0	\N	\N	\N
10073	CO_Arzt_Verordnungen_Kategorie	Kategorie, ob es sich um Diagnostik- oder Konsilanforderung handelt.	\N	3	10066	\N	\N	Kategorie der Diagnostik- oder Konsilanforderung
10074	CO_Arzt_Verordnungen_Lokalisation	Lokalisation der zu befundenden Region	\N	3	10066	\N	\N	Lokalisation der zu befundenden Region
6	Patient_Gewicht	Gewicht des Patienten	kg	6	1	\N	\N	\N
7	Patient_Groesse	Größe des Patienten	cm	6	1	\N	\N	\N
10075	CO_Arzt_Verordnungen_Methode	Methode der Diagnostik bzw. des Konsils	\N	3	10066	\N	\N	Methode der Diagnostik bzw. des Konsils
10257	CO_Filter	Transientes Objekt für Filterkriterien	\N	37	0	\N	\N	Filter
10258	CO_Filter_Datum_Beginn	Filtervariable für ein Beginndatum	\N	5	10257	\N	\N	Datum Beginn
10259	CO_Filter_Datum_Ende	Filtervariable für ein Endedatum	\N	5	10257	\N	\N	Datum Ende
10260	CO_Filter_Zahl	Filtervariable für eine Ganzzahl	\N	2	10257	\N	\N	Filter Zahl
10261	CO_Filter_ja_nein_1	Filtervariable ein Ja-/Nein-Feld	\N	2	10257	\N	\N	Filter Ja/Nein1
10262	CO_Filter_ja_nein_2	Filtervariable ein Ja-/Nein-Feld	\N	2	10257	\N	\N	Filter Ja/Nein2
10263	CO_Filter_Verordnung_Kategorie	Filtervariable für die VO-Kategorie	\N	3	10257	\N	\N	Filter Verordnungskategorie
10410	CO_Arzt_Verordnungen_Status	Status der Verordnung/Aufgabe (z.B. offen oder erledigt)	\N	3	10066	\N	\N	Status der Verordnung/Aufgabe
10411	CO_Arzt_Verordnungen_Termin	Termin für die Untersuchung/Massnahme	\N	5	10066	\N	\N	Termin Untersuchung/Massnahme
104123	Koerperpflege_Haut_Nagelstatus	\N	\N	3	100384	\N	\N	\N
130	Behandlung_INPULS	INPULS-Pflegekategorie	\N	1	30	\N	\N	\N
131	Behandlung_INPULS_Beatmung	gemeldete Beatmungsstunden (in Minuten)	\N	2	130	\N	\N	\N
132	Behandlung_INPULS_Datum	Tag für den die Pflegekategorie erhoben wurde	\N	5	130	\N	\N	\N
133	Behandlung_INPULS_Freigabe	Gemeldet am	\N	5	130	\N	\N	\N
134	Behandlung_INPULS_Kategorie	Pflegekategorie	\N	2	130	\N	\N	\N
135	Behandlung_INPULS_Kriterium_ID	IDs der INPULS-Kriterien, welche zur Kategorie geführt haben; ... und der zusätzlichen Kategorien	\N	2	130	\N	\N	\N
136	Behandlung_INPULS_Transporte	Transporte	\N	3	130	\N	\N	\N
137	Behandlung_INPULS_Betrachtungszeitraum	Betrachtungszeitraum in Minuten	\N	2	130	\N	\N	\N
138	Organisationseinheit_INPULS_Pfad	Pfad für den Export der INPULS-Kategorien	\N	3	80	\N	\N	\N
139	Behandlung_INPULS_Kriterium_Höherstufung_ID	IDs der INPULS-Kriterien, welche zur Höherstufung der Kategorie dienen	\N	2	130	\N	\N	\N
140	Behandlung_INPULS_Kriterium_Basiskategorie_ID	IDs der INPULS-Kriterien, welche als Basis zur Kategorie dienen	\N	2	130	\N	\N	\N
162	Organisationseinheit_INPULS_Export_Zeitpunkt	Zeitpunkte der INPULS-Pflegekategorie-Exporte für diese OE	\N	5	80	\N	\N	\N
10412	CO_Arzt_Verordnungen_Wiederholung_Tage	Wiederholung der Untersuchung/Massnahme für x Tage	\N	2	10066	\N	\N	Untersuchung/Massnahme für x Tage
10413	CO_Arzt_Verordnungen_Anzeigetext	Anzeigetext der Anordnung/Aufgabe (verwendet für Darstellung in ObjectLine))	\N	3	10066	\N	\N	Anzeigetext der Anordnung/Aufgabe
10414	CO_Arzt_Verordnungen_Wiederholung	mehrfache Zeiten für Anordnung/Aufgabe	\N	1	10066	\N	\N	Zeiten der Anordnung/Aufgabe
102804	Score_mRS	\N	\N	1	1	\N	\N	\N
10415	CO_Arzt_Verordnungen_Wiederholung_Zeit	Zeit für Anordnung/Aufgabe	\N	2	10414	\N	\N	Zeit der Anordnung/Aufgabe
10416	CO_Arzt_Verordnungen_Anzeigedatum	wird zur Anzeige in ObjektLines verwendet und dynamisch angelegt bzw. geändert	\N	5	10066	\N	\N	Anzeigedatum der Verordnung/Aufgabe
10465	CO_Filter_Verordnung_Methode	Filtervariable für die VO-Methode	\N	5	10257	\N	\N	Filter Verordnungsmethode
10466	CO_Filter_Verordnung_Status	Filtervariable für den VO-Status	\N	3	10257	\N	\N	Filter Verordnungsstatus
10483	CO_Filter_Verordnung_TerminVon	Filtervariable für die VO-Termin Von	\N	5	10257	\N	\N	Filter Verordnungstermin Von
10484	CO_Filter_Verordnung_TerminBis	Filtervariable für die VO-Termin Bis	\N	5	10257	\N	\N	Filter Verordnungstermin Bis
10508	CO_Filter_Name	Filtervariable für einen Namen	\N	3	10257	\N	\N	Filter Name
10509	CO_Filter_Ort	Filtervariable für einen Ort/eine Stadt	\N	3	10257	\N	\N	Filter Ort
10510	CO_Filter_PLZ	Filtervariable für eine Postleitzahl	\N	3	10257	\N	\N	Filter Postleitzahl
10511	CO_Filter_ExterneID	Filtervariable für eine externe ID	\N	3	10257	\N	\N	Filter externe ID
10512	CO_Filter_MultiString	Filter Objekt für multiple String	\N	37	10257	\N	\N	Filter MultiString
10513	CO_Filter_MultiString_Eintrag	Filtervariable für einen multiplen String	\N	3	10512	\N	\N	Filter MultiString
10514	CO_Arzt_Verordnungen_ObjectLink	Objekt mit Links auf die zugehörigen Durchführungsobjekte	\N	1	10066	\N	\N	Durchführungsobjekte zur VO
10515	CO_Arzt_Verordnungen_ObjectLink_Eintrag	Texteintrag zum zugehörigen Durchführungsobjekt der VO	\N	3	10514	\N	\N	Texteintrag zum Durchführungsobjekt
10516	CO_Arzt_Verordnungen_ObjectLink_Link	Link zum zugehörigen Durchführungsobjekt der VO	\N	15	10514	\N	\N	Link zum Durchführungsobjekt
10596	CO_Arzt_Verordnungen_Berechtigungscheck	Variable die Berechtigungen für Neuanlage enthält	\N	3	10066	\N	\N	Berechtigungscheck für neue AO
10597	CO_Arzt_Verordnungen_Intervall_Tage	Intervall zwischen den Wiederholungen der Untersuchung/Massnahme in x Tagen	\N	2	10066	\N	\N	Intervall zwischen Wiederholungen der AO
10598	CO_Filter_Verordnung_OrderDesc	Filtervariable um AO absteigend sortieren	\N	2	10257	\N	\N	AO absteigend sortieren
10599	CO_Filter_Verordnung_keinLabor	Filtervariable um Labor auszublenden	\N	2	10257	\N	\N	Labor auszublenden
10945	CO_Filter_Freitext	Filtervariable für Freitextsuche	\N	3	10257	\N	\N	Filter - Freitext
11214	CO_Arzt_Verordnungen_unvisiert	Gibt an ob die Verordnung nicht visiert ist	\N	2	10066	\N	\N	Visierstatus der VO
11215	CO_Arzt_Verordnungen_Kopierstatus	Kopierstatus der Verordnung	\N	3	10066	\N	\N	Kopierstatus der VO
11288	CO_Arzt_Verordnungen_Leistungsanforderung	Link auf Leistungsanforderungsobjekt zur Anordnung	\N	15	10066	\N	\N	Leistungsanforderung zur Anordnung
20151	CO_Filter_Praemedikation_PatName	Filtervariable Prämedikation Nachname	\N	3	10257	\N	\N	Praemedikation Filter Name
20152	CO_Filter_Praemedikation_PatVorname	Filtervariable Prämedikation Nachname	\N	3	10257	\N	\N	Praemedikation Filter Vorname
20153	CO_Filter_Praemedikation_FallNr	Filtervariable Prämedikation Fallnummer	\N	3	10257	\N	\N	Praemedikation Filter FallID
20154	CO_Filter_Praemedikation_GebDatum	Filtervariable PrämedikationGeburtsdatum	\N	5	10257	\N	\N	Praemedikation Filter Geburtsdatum
20155	CO_Filter_Praemedikation_OpTraktSaal	Filtervariable Prämedikation OP Saal	\N	3	10257	\N	\N	Praemedikation Filter OP Saal
20156	CO_Filter_Praemedikation_OpDatum	Filtervariable Prämedikation OP Datum	\N	5	10257	\N	\N	Praemedikation Filter OP Tag
20204	CO_Filter_Praemedikation_Datum	Filtervariable Prämedikation Datum	\N	5	10257	\N	\N	Praemedikation Filter Prämed-Datum
20205	CO_Filter_Praemedikation_Freigabe	Filtervariable Prämedikation Freigabestatus	\N	3	10257	\N	\N	Praemedikation Filter Freigabe
100001	GCS_ADULT	\N	\N	1	30	\N	\N	\N
100000	TISS28	\N	\N	1	30	\N	\N	\N
100373	Koerperpflege_Mund_Zahnstatus	\N	\N	3	100368	\N	\N	Pflegedoku - Zähne (Status)
100374	Koerperpflege_Mund_Zahnpflege	\N	\N	3	100368	\N	\N	Pflegedoku - Zähne (Pflege)
100376	Koerperpflege_Haare_Status	\N	\N	3	100375	\N	\N	Pflegedoku - Haare (Status)
100377	Koerperpflege_Haare_Pflege	\N	\N	3	100375	\N	\N	Pflegedoku - Haare (Pflege)
231	Patient_Archivdruck_Status	Archivdruck-Status	\N	3	220	\N	\N	\N
232	Patient_Archivdruck_Druckobjekt	Archivdruck-Druckobjekt	\N	15	220	\N	\N	\N
500	Geraet	Objekt für die Geratedefinition	\N	1	0	\N	\N	\N
600	COPRA_Pflege	\N	\N	41	30	\N	\N	\N
601	COPRA_Pflege_Ätiologie	\N	\N	44	600	\N	\N	\N
100379	Koerperpflege_Ohren_Status	\N	\N	3	100378	\N	\N	Pflegedoku - Ohren (Status rechts)
100380	Koerperpflege_Ohren_Pflege	\N	\N	3	100378	\N	\N	Pflegedoku - Ohren (Pflege rechts)
100382	Koerperpflege_Nabel_Status	\N	\N	3	100381	\N	\N	Pflegedoku - Nabel (Status)
100383	Koerperpflege_Nabel_Pflege	\N	\N	3	100381	\N	\N	Pflegedoku - Nabel (Pflege)
100385	Koerperpflege_Haut_Hautstatus	\N	\N	3	100384	\N	\N	Pflegedoku - Haut (Status)
100386	Koerperpflege_Haut_Oedeme	\N	\N	3	100384	\N	\N	Pflegedoku - Haut (Ödeme)
100387	Koerperpflege_Haut_Hautkolorit	\N	\N	3	100384	\N	\N	Pflegedoku - Haut (Kolorit)
100388	Koerperpflege_Haut_Hautpflege	\N	\N	3	100384	\N	\N	Pflegedoku - Haut (Pflege)
100390	Koerperpflege_Waschen_Waschen	\N	\N	3	100389	\N	\N	Pflegedoku - Körperpflege (Übernahme)
100391	Koerperpflege_Waschen_Intimpflege	\N	\N	3	100389	\N	\N	Pflegedoku - Körperpflege (Intimpflege)
100392	Koerperpflege_Waschen_Urogenitalstatus	\N	\N	3	100389	\N	\N	Pflegedoku - Körperpflege (Urogenitalstatus)
100454	Ernaehren_Ausscheiden_Abdomen_Status	\N	\N	3	100453	\N	\N	Pflegedoku - Stuhl (Abdomenstatus)
100455	Ernaehren_Ausscheiden_Peristaltik	\N	\N	3	100453	\N	\N	Pflegedoku - Stuhl (Abdomenperistaltik)
100456	Ernaehren_Ausscheiden_Abfuehrmassn	\N	\N	3	100453	\N	\N	Pflegedoku - Stuhl (Abführmaßnahmen)
100457	Ernaehren_Ausscheiden_StuhlAussehen	\N	\N	3	100453	\N	\N	Pflegedoku - Stuhl (Aussehen)
100460	Ernaehren_Ausscheiden_MagensaftpH	\N	\N	3	100453	\N	\N	Pflegedoku - Kostform (Magensaft pH)
100462	Ernaehren_Ausscheiden_ErbrechenWie	\N	\N	3	100453	\N	\N	Pflegedoku - Erbrechen (Wie)
100463	Ernaehren_Ausscheiden_ErbrechenAussehen	\N	\N	3	100453	\N	\N	Pflegedoku - Erbrechen (Aussehen)
100465	Ernaehren_Ausscheiden_UrinAussehen	\N	\N	3	100453	\N	\N	Pflegedoku - Urin (Aussehen)
100466	Ernaehren_Ausscheiden_AnusPraeteroral_Status	\N	\N	3	100453	\N	\N	Pflegedoku - AP oral (Status)
100483	Sicherheit_Geraeteueberpruef_BeatmBeutelMaske	\N	\N	3	100480	\N	\N	Pflegedoku - Qualitätschecks (Beatm.btl/-maske)
100484	Sicherheit_Geraeteueberpruef_Sogstaerkenkontrolle	\N	\N	3	100480	\N	\N	Pflegedoku - Qualitätschecks (Sogstärke)
100485	Sicherheit_Geraeteueberpruef_Laufratenkontrolle	\N	\N	3	100480	\N	\N	Pflegedoku - Qualitätschecks (Laufraten)
100487	Sicherheit_Geraeteueberpruef_Absauggeraet	\N	\N	3	100480	\N	\N	Pflegedoku - Qualitätschecks (Absauggerät)
100489	Sicherheit_Geraeteueberpruef_Druckbeutel	\N	\N	3	100480	\N	\N	Pflegedoku - Qualitätschecks (Druckbeutel)
104386	AT_Zahnschutz	\N	\N	2	30	\N	\N	\N
1260	Behandlung_FachlicheOE	fachliche Organisationseinheit der Behandlung	\N	15	30	\N	\N	\N
1261	Behandlung_PflegerischeOE	pflegerische Organisationseinheit der Behandlung	\N	15	30	\N	\N	\N
1263	Behandlung_Beginn	Beginn der Behandlung	\N	5	30	\N	\N	\N
1264	Behandlung_Ende	Ende der Behandlung	\N	5	30	\N	\N	\N
1265	Behandlung_Auftrag	\N	\N	3	30	\N	\N	\N
1279	Diagnose_Code	Code der Diagnose	\N	3	1278	\N	\N	Diagnose / Vorerkrankung (ICD - Code)
1280	Diagnose_Bezeichnung	Bezeichnung der Diagnose	\N	3	1278	\N	\N	Diagnosen / Vorerkrankung (Text)
1281	Diagnose_Typ	Typ der Diagnose	\N	3	1278	\N	\N	Diagnosen / Vorerkrankung (Typ)
100490	Sicherheit_Geraeteueberpruef_Pacer	\N	\N	3	100480	\N	\N	Pflegedoku - Qualitätschecks (Pacer)
100491	Sicherheit_Geraeteueberpruef_Tracheostomaset	\N	\N	3	100480	\N	\N	Pflegedoku - Qualitätschecks (Tracheostomaset)
100495	Sicherheit_Wechsel_O2BrilleBrille	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (O2 Insufflation)
100498	Sicherheit_Wechsel_TrachcareSystem	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (Trachcare)
100499	Sicherheit_Wechsel_Inhalationssystem	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (Inhalationssystem)
100500	Sicherheit_Wechsel_Nahrungspumpenset	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (Nahrungspumpenset)
100470	Sicherheit	\N	\N	21	1	\N	\N	\N
103672	Wunddokumentation_Tiefe_Aufnahme	Dokumentation der Wundtiefe bei Aufnahme oder Erstauftreten	\N	3	100189	\N	\N	Wunden u. Defekte (Tiefe)
103673	IstPflege_Koerperpfl_Lippenstatus	Beschreibung des Lippenstatus bei Aufnahme	\N	3	30	\N	\N	Körperpflege (Lippenstatus)
103674	IstPflege_Koerperpfl_Haarstatus	Beschreibung des Haarstatus bei Aufnahme	\N	3	30	\N	\N	Körperpflege (Haarstatus)
103675	IstPflege_Koerperpfl_Zahnstatus	Beschreibung des Zahnstatus bei Aufnahme	\N	3	30	\N	\N	Körperpflege (Zahnstatus)
103676	IstPflege_Koerperpfl_Ohrenstatusre	Beschreibung des Ohrenstatus rechts bei Aufnahme	\N	3	30	\N	\N	Körperpflege (Ohrenstatus rechts)
103677	IstPflege_Koerperpfl_Ohrenstatusli	Beschreibung des Ohrenstatus links bei Aufnahme	\N	3	30	\N	\N	Körperpflege (Ohrenstatus links)
103678	IstPflege_Koerperpfl_Nasenstatusre	Beschreibung des Nasenstatus rechts bei Aufnahme	\N	3	30	\N	\N	Körperpflege (Nasenstatus rechts)
103679	IstPflege_Koerperpfl_Nasenstatusli	Beschreibung des Nasenstatus links bei Aufnahme	\N	3	30	\N	\N	Körperpflege (Nasenstatus links)
106447	ZW_ICP_kont	ICP Zielwert	mmHg	39	30	\N	\N	Zielwertdefinition für ICP
106448	ZW_CPP_kont	CPP Zielwert	mmHg	39	30	\N	\N	Zielwertdefinition für CPP
106449	ZW_SpO2_kont	SpO2 Zielwert	%	39	30	\N	\N	Zielwertdefinition für SpO2
10066	CO_Arzt_Verordnungen	In diesem Objekt werden Verordnungsanforderungen und -befunde zu Diagnostik bzw. Konsilen eingetragen.	\N	1	30	\N	\N	Verordnungen zu Diagnostik und Konsilen
10492	CO_Filter_Verordnung_Schicht	Filtervariable für die Schicht, deren Aufgaben in der Verordnungsliste dargestellt werden sollen.	\N	3	10257	\N	\N	Filter Verordnungsschicht
10506	CO_Arzt_Verordnungen_Schema	Schema für Verordnungen	\N	3	10066	\N	\N	Verordnungsschema
100017	GCS_ADULT_Wert	\N	\N	2	100001	\N	\N	\N
100028	Patient_Besucherregelung	Besucherverinbarung für den Patienten	\N	3	1	\N	\N	\N
100029	Betreuer_Telefon	Telefonummer des Patientenbetreuers	\N	3	1	\N	\N	Betreuer (Telefon)
100031	Betreuer_Name	Betreuer des Patienten	\N	3	1	\N	\N	Betreuer (Name)
100032	Patient_Sprache	Muttersprache des Patienten	\N	3	1	\N	\N	\N
100033	Patient_Religion	Religion des Patienten	\N	3	1	\N	\N	\N
100034	Angehoerige1_Telefon	Angehoerigen-Telefon	\N	3	1	\N	\N	Angehörige (Telefon)
100035	Angehoerige1_Name	Nachname des Angehörigen	\N	3	1	\N	\N	Angehörige (Name)
106450	ZW_BZ_kont	BZ Zielwert	mg/dl	39	30	\N	\N	Zielwertdefinition für BZ
106451	ZW_Bilanz_kont	Bilanz Zielwert	ml	39	30	\N	\N	Zielwertdefinition für Bilanz
106452	VO_Allgemein_kont	\N	\N	39	30	\N	\N	Verordnung allgemein
106453	VO_Kostform_kont	Kostform Intervention	\N	39	30	\N	\N	Verordnung Kostform
106454	VO_Lagerung_kont	Lagerung Intervention	\N	39	30	\N	\N	Verordnung Lagerung
106455	TabelleAerzte_Labor_Ausg_Datum	\N	\N	5	102409	\N	\N	\N
106456	VO_Messintervall_BZ_kont	BZ-Kontrolle Messintervall	\N	39	30	\N	\N	Messintervall BZ
106457	VO_Messintervall_Bilanz_kont	Bilanz Messintervall	\N	39	30	\N	\N	Messintervall Bilanzierung
106458	VO_Messintervall_SpezGew_kont	Spez.Gew. Messintervall	\N	39	30	\N	\N	Messintervall spezifisches Gewicht Urin
106459	VO_Messintervall_Gewicht_kont	Gewicht Messintervall	\N	39	30	\N	\N	Messintervall Gewicht
106460	VO_Messintervall_ICP_kont	ICP Messintervall	\N	39	30	\N	\N	Messintervall ICP
106461	VO_Messintervall_ZVD_kont	ZVD Messintervall	\N	39	30	\N	\N	Messintervall ZVD
106462	VO_Messintervall_BGA_kont	\N	\N	39	30	\N	\N	Messintervall BGA
106463	VO_Messintervall_Pupillen_kont	Pupillen Zielwert	\N	39	30	\N	\N	Zielwert Pupillenkontrolle
106464	VO_Messintervall_Bewusst_kont	Bewusstsein Messintervall 	\N	39	30	\N	\N	Messintervall Bewusstsein
106465	CO6_Filter_ToDo_FallNr	Globaler Zwischenspeicherfür die Fallnummer für die Verwendung in Dialogen die aufgrund der Var-Struktur nicht an das Fallobjekt kommen.	\N	3	650	\N	\N	CO6_Filter_ToDo_FallNr
106466	B_Aufnahmegewicht_Wert	\N	\N	6	30	\N	\N	Aufnahmegewicht der Behandlung
106467	B_Aufnahmegroesse_Wert	\N	\N	6	30	\N	\N	Groesse bei Behandlungbeginn
104387	AT_KopfAbgedeckt	\N	\N	2	30	\N	\N	\N
100043	TISS28_TS_Wert	\N	\N	2	100000	\N	\N	\N
106469	IABP_CARDIOSAVE_ES_IABPAufblasen	Dokumentation des prozentualen Anteils des Aufblasens des Ballons	\N	6	1	\N	\N	\N
106470	IABP_CARDIOSAVE_ES_EKG_Ableitung	Dokumentation der gewählten EKG Ableitung für den IABP Einsatz	\N	3	1	\N	\N	\N
106471	IABP_CARDIOSAVE_ES_Unterstuetzungsdruck	Dokumentation des Unterstützungdruckes	\N	6	1	\N	\N	\N
106472	IABP_CARDIOSAVE_ES_IABP_Frequenz	Dokumentation der IABP Frequenz	\N	3	1	\N	\N	\N
106473	IABP_CARDIOSAVE_ES_Triggerauswahl_EKG_RR_Pacer	Dokumentation des ausgewählten Triggers der IABP	\N	3	1	\N	\N	\N
106474	IABP_CARDIOSAVE_ES_IABPLeersaugen	Dokumentation des prozentualen Anteils des Leersaugens des Ballons	\N	6	1	\N	\N	\N
106475	EinweisenderArzt_Email	\N	\N	3	20	\N	\N	\N
106476	EinweisenderArzt_Fax	\N	\N	3	20	\N	\N	\N
106477	EinweisenderArzt_Telefon	\N	\N	3	20	\N	\N	\N
106478	EinweisenderArzt_Land	\N	\N	3	20	\N	\N	\N
106479	EinweisenderArzt_Ort	\N	\N	3	20	\N	\N	\N
106480	EinweisenderArzt_PLZ	\N	\N	3	20	\N	\N	\N
106481	EinweisenderArzt_Strasse	\N	\N	3	20	\N	\N	\N
106486	Hausarzt_Titel	\N	\N	3	1	\N	\N	\N
106487	Angehoerige3_Strasse	\N	\N	3	1	\N	\N	\N
106488	Angehoerige3_TelefonArbeit	\N	\N	3	1	\N	\N	\N
106489	Angehoerige3_TelefonMobil	\N	\N	3	1	\N	\N	\N
106490	Angehoerige3_Telefon	\N	\N	3	1	\N	\N	\N
106491	Angehoerige3_Land	\N	\N	3	1	\N	\N	\N
106492	Angehoerige3_Ort	\N	\N	3	1	\N	\N	\N
106493	Angehoerige3_PLZ	\N	\N	3	1	\N	\N	\N
106494	Angehoerige3_Vorname	\N	\N	3	1	\N	\N	\N
106495	Angehoerige3_Name	\N	\N	3	1	\N	\N	\N
106496	Angehoerige3_Verwandtschaftsgrad	\N	\N	3	1	\N	\N	\N
106497	Angehoerige2_TelefonArbeit	\N	\N	3	1	\N	\N	\N
106498	Angehoerige2_TelefonMobil	\N	\N	3	1	\N	\N	\N
106499	Angehoerige2_Telefon	\N	\N	3	1	\N	\N	\N
106500	Angehoerige2_Land	\N	\N	3	1	\N	\N	\N
106501	Angehoerige2_Strasse	\N	\N	3	1	\N	\N	\N
106502	Angehoerige2_Ort	\N	\N	3	1	\N	\N	\N
106503	Angehoerige2_PLZ	\N	\N	3	1	\N	\N	\N
106504	Angehoerige2_Vorname	\N	\N	3	1	\N	\N	\N
106505	Angehoerige2_Name	\N	\N	3	1	\N	\N	\N
106506	Angehoerige2_Verwandtschaftsgrad	\N	\N	3	1	\N	\N	\N
106507	Betreuer2_Aufgabenkreis	\N	\N	3	1	\N	\N	\N
106508	Betreuer_Aufgabenkreis	\N	\N	3	1	\N	\N	\N
106509	Betreuer2_TelefonMobil	\N	\N	3	1	\N	\N	\N
106510	Betreuer2_Land	\N	\N	3	1	\N	\N	\N
106511	Betreuer2_PLZ	\N	\N	3	1	\N	\N	\N
100094	NBP_1	nichtinvasiver Blutdruck 1	mmHg	12	1	\N	\N	\N
106512	Betreuer2_Strasse	\N	\N	3	1	\N	\N	\N
106513	Betreuer2_Vorname	\N	\N	3	1	\N	\N	\N
106514	Betreuer2_Name	\N	\N	3	1	\N	\N	\N
106515	Betreuer2_Status	\N	\N	3	1	\N	\N	\N
106516	Betreuer2_Ort	\N	\N	3	1	\N	\N	\N
106517	Waermesysteme_BairHugger_Doku_Temperatur	Liste	°C	3	1	\N	\N	\N
106518	Waermesysteme_BairHugger_Doku_Geblaese	Liste	Stufe	3	1	\N	\N	\N
106519	Behandlung_GegangenOhneArztkontakt	Gegangen ohne Arztkontakt	\N	2	30	\N	\N	\N
106520	MTS	\N	\N	1	30	\N	\N	\N
106521	Fall_Anamnese_Auslandsaufenthalt_Nein	Auslandsaufenthalt in den letzten 6 Monaten?	\N	2	20	\N	\N	\N
106522	Fall_Anamnese_Auslandsaufenthalt_Ja	Auslandsaufenthalt in den letzten 6 Monaten?	\N	2	20	\N	\N	\N
106523	Fall_Anamnese_Tetanusschutz_Nein	\N	\N	2	20	\N	\N	\N
106524	Fall_Anamnese_Tetanusschutz_unbekannt	\N	\N	2	20	\N	\N	\N
106525	Fall_Anamnese_Tetanusschutz_Ja	\N	\N	2	20	\N	\N	\N
106526	Fall_Anamnese_Schwangerschaft_unbekannt	\N	\N	2	20	\N	\N	\N
106527	Fall_Anamnese_Schwangerschaft_Nein	\N	\N	2	20	\N	\N	\N
106528	Fall_Anamnese_Schwangerschaft_Ja	\N	\N	2	20	\N	\N	\N
106529	MTS_GCS_Adult_Wert_Aufnahme	\N	\N	2	106520	\N	\N	\N
106530	MTS_GCS_Adult_Motorik_Aufnahme	\N	\N	27	106520	\N	\N	\N
106531	MTS_GCS_Adult_Sprache_Aufnahme	\N	\N	27	106520	\N	\N	\N
106532	MTS_GCS_Adult_Augen_Aufnahme	\N	\N	27	106520	\N	\N	\N
106533	MTS_Result_ueberprueft	\N	\N	3	106520	\N	\N	\N
106534	MTS_Pupillenreaktionindir_li_neg	\N	\N	2	106520	\N	\N	\N
106535	MTS_Pupillenreaktionindir_li_pos	\N	\N	2	106520	\N	\N	\N
106536	MTS_Pupillenreaktiondir_li_k	\N	\N	2	106520	\N	\N	\N
106537	MTS_Pupillenreaktiondir_li_v	\N	\N	2	106520	\N	\N	\N
106538	MTS_Pupillenreaktiondir_li_p	\N	\N	2	106520	\N	\N	\N
106539	MTS_PupillenBesond_li_GA	\N	\N	2	106520	\N	\N	\N
106540	MTS_Pupillenform_li_r	\N	\N	2	106520	\N	\N	\N
106541	MTS_Pupillengroesse_li_w	\N	\N	2	106520	\N	\N	\N
106542	MTS_Pupillengroesse_li_x	\N	\N	2	106520	\N	\N	\N
106543	MTS_Pupillengroesse_li_m	\N	\N	2	106520	\N	\N	\N
106544	MTS_Pupillengroesse_li_e	\N	\N	2	106520	\N	\N	\N
106545	MTS_Pupillenreaktionindir_re_neg	\N	\N	2	106520	\N	\N	\N
106546	MTS_Pupillenreaktionindir_re_pos	\N	\N	2	106520	\N	\N	\N
106547	MTS_Pupillenreaktiondir_re_p	\N	\N	2	106520	\N	\N	\N
106548	MTS_Pupillenreaktiondir_re_k	\N	\N	2	106520	\N	\N	\N
106549	MTS_Pupillenreaktiondir_re_v	\N	\N	2	106520	\N	\N	\N
100146	Atemwege_Typ	\N	\N	3	100132	\N	\N	Atemwege (Typ)
100147	Atemwege_Groesse	\N	\N	3	100132	\N	\N	Atemwege (Größe)
100151	Atemwege_Lage	\N	\N	3	100150	\N	\N	Atemwege - Lage
100153	Drainagen_Art	\N	\N	3	100135	\N	\N	Drainage (Typ)
100154	Drainagen_Groesse	\N	\N	3	100135	\N	\N	Drainage (Größe)
100155	Drainagen_Lage	\N	\N	3	100135	\N	\N	Drainage (Lage)
106550	MTS_PupillenBesond_re_GA	\N	\N	2	106520	\N	\N	\N
106551	MTS_Pupillenform_re_r	\N	\N	2	106520	\N	\N	\N
106552	MTS_Pupillengroesse_re_x	\N	\N	2	106520	\N	\N	\N
106553	MTS_Pupillengroesse_re_w	\N	\N	2	106520	\N	\N	\N
106554	MTS_Pupillengroesse_re_m	\N	\N	2	106520	\N	\N	\N
106555	MTS_Pupillengroesse_re_e	\N	\N	2	106520	\N	\N	\N
106556	MTS_INFO_CODE_VP	CODE zum Überspringen der Pflichtfelder Vitalparameter - Anforderung für IT Lizenz	\N	3	106520	\N	\N	\N
106557	MTS_Temp1a	\N	\N	6	106520	\N	\N	\N
106558	MTS_BZ	\N	\N	6	106520	\N	\N	\N
106559	MTS_AF	\N	\N	6	106520	\N	\N	\N
106560	MTS_SPO2	\N	\N	6	106520	\N	\N	\N
106561	MTS_HF	\N	\N	6	106520	\N	\N	\N
106562	MTS_RR_dia	\N	\N	6	106520	\N	\N	\N
106563	MTS_RR_sys	\N	\N	6	106520	\N	\N	\N
106564	MTS_Typ	\N	\N	3	106520	\N	\N	\N
106565	MTS_EinschaetzerName	\N	\N	3	106520	\N	\N	\N
106566	Start_MTS	\N	\N	5	106520	\N	\N	\N
106567	MTS_Schmerzbeurteilung_Kommentar	Freitextfeld	\N	3	106520	\N	\N	\N
106568	Schmerz_10	\N	\N	2	106520	\N	\N	\N
106569	Schmerz_9	\N	\N	2	106520	\N	\N	\N
106570	Schmerz_8	\N	\N	2	106520	\N	\N	\N
106571	Schmerz_7	\N	\N	2	106520	\N	\N	\N
106572	Schmerz_6	\N	\N	2	106520	\N	\N	\N
106573	Schmerz_5	\N	\N	2	106520	\N	\N	\N
106574	Schmerz_4	\N	\N	2	106520	\N	\N	\N
106575	Schmerz_3	\N	\N	2	106520	\N	\N	\N
106576	Schmerz_2	\N	\N	2	106520	\N	\N	\N
106577	Schmerz_1	\N	\N	2	106520	\N	\N	\N
106578	Schmerz_0	\N	\N	2	106520	\N	\N	\N
106579	MTS_Symptom_Kommentar	\N	\N	3	106520	\N	\N	\N
100159	Drainagen_Nullpunkt	\N	\N	3	100157	\N	\N	Drainagen (Drainagenhöhe)
100161	Enteralesonden_Typ	\N	\N	3	100133	\N	\N	Gastroenterale Sonden (Typ)
100162	Enteralesonden_Groesse	\N	\N	3	100133	\N	\N	Gastroenterale Sonden (Größe)
100167	Enteralesonden_Pflege	\N	\N	3	100165	\N	\N	Enterale Sonden (Pflege)
100168	HarnwegeDarm_Typ	\N	\N	3	100134	\N	\N	Urinausscheidung (Typ)
100169	HarnwegeDarm_Lage	\N	\N	3	100134	\N	\N	Urinausscheidung (Lage)
100170	HarnwegeDarm_Groesse	\N	\N	3	100134	\N	\N	Urinausscheidung (Größe)
100174	HarnwegeDarm_Pflege	\N	\N	3	100172	\N	\N	Harnwege (Pflege)
100175	Zugaenge_Typ	\N	\N	3	100131	\N	\N	Zugänge (Typ)
100176	Zugaenge_Groesse	\N	\N	3	100131	\N	\N	Zugänge (Größe)
100177	Zugaenge_Lage	\N	\N	3	100131	\N	\N	Zugänge (Lage)
100181	Zugaenge_Pulse	\N	\N	3	100179	\N	\N	Zugänge (Pulse)
100182	Dekubitus	\N	\N	21	1	\N	\N	\N
100189	Wunddokumentation	\N	\N	21	1	\N	\N	\N
100190	Wunddokumentation_Typ	\N	\N	3	100189	\N	\N	Wunden u. Defekte (Typ)
100191	Wunddokumentation_Ort	\N	\N	3	100189	\N	\N	Wunden u. Defekte (Ort)
100195	Wunddokumentation_Pflege	\N	\N	3	100193	\N	\N	Wunden u. Defekte (Pflege)
106580	MTS_Result	\N	\N	34	106520	\N	\N	\N
106581	Behandlung_Reanimationspflicht_Aufnahme	Pat. wird unter Reanimstionsbedingungen aufgenommen	\N	2	30	\N	\N	\N
106582	Behandlung_ZNA_Ersteinschaetzung_Name	\N	\N	3	30	\N	\N	\N
106583	Behandlung_ZNA_Erstkontakt	\N	\N	5	30	\N	\N	\N
106584	Ende_MTS	\N	\N	5	106520	\N	\N	\N
100197	Zugaenge_Pflege	\N	\N	3	100179	\N	\N	Zugänge (Pflege)
100198	Zugaenge_Beobachtung	\N	\N	3	100179	\N	\N	Zugänge (Beobachtung)
106585	Behandlung_NA_Dash_Board_Memo	\N	\N	3	30	\N	\N	\N
106586	B_Zielwert_NRS_kont	\N	1-10	39	30	\N	\N	\N
106587	B_Zielwert_GCS_kont	\N	\N	39	30	\N	\N	\N
106588	B_Zielwert_AF_kont	\N	\N	39	30	\N	\N	\N
106589	B_Zielwert_Diastole	\N	mmHg	39	30	\N	\N	\N
106590	B_Zielwert_Syst	\N	mmHg	39	30	\N	\N	\N
106591	Behandlung_Entlassmedikation_keineNotwendig	\N	\N	2	30	\N	\N	\N
106592	F_MedDoku_Entlassmedikation	\N	\N	1	20	\N	\N	\N
106593	B_EntlassBefund_entlArzt	\N	\N	3	30	\N	\N	\N
106594	B_Proceder_Therapiempfehlung	\N	\N	3	30	\N	\N	\N
106595	B_Abschlussdiagnose	\N	\N	3	30	\N	\N	\N
106596	Fall_Vormedikation_Nicht_Erfasst	\N	\N	2	20	\N	\N	\N
106597	Fall_Vormedikation_Keine_Vorhanden	\N	\N	2	20	\N	\N	\N
106598	F_MedDoku_Entlassmedikation_Anmerkung	\N	\N	3	106592	\N	\N	\N
106599	F_MedDoku_Entlassmedikation_Dosierung_nachts	\N	\N	3	106592	\N	\N	\N
106600	F_MedDoku_Entlassmedikation_pausiert_seit	\N	\N	3	106592	\N	\N	\N
106601	F_MedDoku_Entlassmedikation_Dosierung_mittags	\N	\N	3	106592	\N	\N	\N
106602	F_MedDoku_Entlassmedikation_Dosierung_abends	\N	\N	3	106592	\N	\N	\N
106603	F_MedDoku_Entlassmedikation_Dosierung	\N	\N	3	106592	\N	\N	\N
106604	F_MedDoku_Entlassmedikation_Dosierung_morgens	\N	\N	3	106592	\N	\N	\N
106605	F_MedDoku_Entlassmedikation_Medikamentenname	\N	\N	3	106592	\N	\N	\N
106606	MTS_Einschaetzung_Nr	\N	\N	6	106520	\N	\N	\N
106607	MTS_Schmerzgrad	\N	\N	2	106520	\N	\N	\N
106608	MTS_Temp	\N	\N	6	106520	\N	\N	\N
106609	Behandlung_ZNA_Spaetester_Arztkontakt	\N	\N	5	30	\N	\N	\N
106610	ZW_RR_sys	RR_systolisch Zielwert	\N	39	30	\N	\N	\N
106611	ZW_RR_dia	RR_diastolisch Zielwert	\N	39	30	\N	\N	\N
106612	ZW_AF_kont	Atemfrequenz Zielwert	\N	39	30	\N	\N	\N
106613	ZW_GCS_kont	GCS Zielwert	\N	39	30	\N	\N	\N
106614	ZW_NRS_Schmerz_kont	NRS Zielwert	\N	39	30	\N	\N	\N
106615	B_EinschaetzungArbeitsdiagnose	\N	\N	3	30	\N	\N	\N
106616	Behandlung_Verlegung_wohin_geplant	\N	\N	3	30	\N	\N	geplanter Verlegungsort
106617	Tabelle_NA_AerzteMassnahmen	\N	\N	1	30	\N	\N	ärztliche Maßnahmen
106618	Tabelle_NA_AerzteMassnahmen_Bereich	\N	\N	3	106617	\N	\N	\N
106619	Tabelle_NA_AerzteMassnahmen_DokuZeit	\N	\N	5	106617	\N	\N	\N
106620	Tabelle_NA_AerzteMassnahmen_Gruppe	\N	\N	3	106617	\N	\N	\N
106621	Tabelle_NA_AerzteMassnahmen_Dokumentation	\N	\N	3	106617	\N	\N	\N
106622	Tabelle_NA_AerzteMassnahmen_DurchgefuehrtVon	\N	\N	3	106617	\N	\N	\N
106623	CO6_Filter_ToDo_NARoomAss	Raumzuweisungsvariable Notaufnahme	\N	34	650	\N	\N	\N
106624	Beatmung_ES_T1_Apnoezeit_Backup	\N	s	6	1	\N	\N	\N
106625	Beatmung_ES_T1_ARDS	\N	\N	3	1	\N	\N	\N
106626	Beatmung_ES_T1_Body_Wt	Eingestelltes Körpergewicht	kg	3	1	\N	\N	\N
106627	Beatmung_ES_T1_Chron_Hyperkapnie	\N	\N	3	1	\N	\N	\N
106629	Beatmung_ES_T1_CO2Elim_Target_Shift	\N	\N	3	1	\N	\N	\N
106630	Beatmung_ES_T1_Druckrampe	Inspiratorische Bemühung des Patienten, die das Beatmungsgerät veranlasst, einen Atemhub abzugeben	ms	6	1	\N	\N	\N
106632	Beatmung_ES_T1_Drucktrigger	\N	mbar	6	1	\N	\N	\N
106633	Beatmung_ES_T1_ETS	Exspiratorische Triggersensitivität, eine Parametereinstellung	%	6	1	\N	\N	\N
106634	Beatmung_ES_T1_F_CMV	Eingestellte CMV Frequenz bei dem Respirator G5 in den Beatmungsmodi DUOPAP, APVcmv, Pcmv, 	b/min	3	1	\N	\N	\N
106635	Beatmung_ES_T1_F_SIMV	Eingestellt SIMV Frequenz bei dem Respirator T1 in den Beatmungsmodi APVsimv, Psimv.	b/min	3	1	\N	\N	\N
106636	Beatmung_ES_T1_PEEP_CPAP_Ptief	Eingestelltes unteres Druckniveau bei den Respirator G5 in verschiedenen Beatmungsmodis.	mbar	6	1	\N	\N	\N
106637	Beatmung_ES_T1_Psupport	Beatmung_ES_T1_Psupport	\N	6	1	\N	\N	\N
106638	Beatmung_ES_T1_Pkontrol_Phoch	Eingestelltes oberes Druckniveau bei dem Respirator  G5 in verschiedenen Beatmungsmodi	mbar	6	1	\N	\N	\N
106639	Beatmung_ES_T1_Plateau	prozentualer Anteil der Inspiration, der Plateauphase bestimmt wird	%	6	1	\N	\N	\N
106640	Beatmung_ES_T1_Ti	Einstelungswert für die Inspirationszeit	s	6	1	\N	\N	\N
106641	Beatmung_ES_T1_Sauerstoff	Sauerstoffeinstellung	Vol%	6	1	\N	\N	\N
106642	F_MedDoku_Entlassmedikation_Applikation	\N	\N	3	106592	\N	\N	\N
106643	F_MedDoku_Vormedikation_Applikation	\N	\N	3	105241	\N	\N	\N
106644	F_MedDoku_Vormedikation_Entlasscopy2	\N	\N	2	105241	\N	\N	\N
106645	F_MedDoku_Entlassmedikation_CopyID	Für die Kopie Aufnahmemedikation--> Entlassmedikation	\N	6	106592	\N	\N	\N
106646	Pat_Allergie_vorhanden_ActiveX	Implementierung für anamnestische Erhebung des Status innerhalb d. Active X Anwendung	\N	2	1	\N	\N	Allergie vorhanden 
106647	Fall_Allergie_unbekannt	Allergiestatus unbekannt fallbezogen - Active X Plugin	\N	2	20	\N	\N	Allergiestatus nicht bekannt
106648	Fall_Allergie_nichtErhoben	Fall_Allergie_nichtErhoben - Active X Plugin	\N	2	20	\N	\N	Allergiestatus nicht erhoben
106649	Fall_Anamnese_Auslandsaufenthalt_unbekannt	Status nicht bekannt	\N	2	20	\N	\N	nicht bekannt
106650	Patient_PeaklowMessung	Peaklfowmeter Messung in % mit Definition <> Messung exspirat. Spitzenfluss	%	3	1	\N	\N	\N
106652	Score_UStix_Dichte	\N	\N	27	106651	\N	\N	\N
106653	Score_UStix_Haemoglobin	\N	\N	27	106651	\N	\N	\N
106654	Score_UStix_Bilirubin	\N	\N	27	106651	\N	\N	\N
106655	Score_UStix_Keton	\N	\N	27	106651	\N	\N	\N
106656	Score_UStix_Protein	\N	\N	27	106651	\N	\N	\N
106657	Score_UStix_Leukozyten	\N	\N	27	106651	\N	\N	\N
106658	Score_UStix_Wert	\N	\N	2	106651	\N	\N	\N
100307	Atemwege_Cuffdruck	\N	\N	3	100150	\N	\N	Atemwege - Cuffdruck
100309	Atemwege_Beobachtung	\N	\N	3	100150	\N	\N	Atemwege - Beobachtung
100313	Dekubitus_Sekret	\N	\N	3	100186	\N	\N	Dekubitus (Sekretbeschaffenheit)
106659	Score_UStix_pH	\N	\N	27	106651	\N	\N	\N
106660	Score_UStix_Blut	\N	\N	27	106651	\N	\N	\N
106661	Score_UStix_Urobilinogen	\N	\N	27	106651	\N	\N	\N
106662	Score_UStix_Glucose	\N	\N	27	106651	\N	\N	\N
106663	Score_UStix_Nitrit	\N	\N	27	106651	\N	\N	\N
106664	Score_UStix_Datum	\N	\N	5	106651	\N	\N	\N
106665	Fall_Schwangerschaftstest_durchgefuehrt	Listenanhang mit positiv und negativ Auswahl	\N	3	20	\N	\N	\N
106666	MTS_Peakflow	Peakflowmessung mit Angabe > <, daher String	\N	3	106520	\N	\N	\N
106667	HeartWare_Watt_Doku	\N	\N	6	1	\N	\N	\N
106668	HeartWare_RPM_Doku	\N	\N	6	1	\N	\N	\N
106669	HeartWare_Blutfluss_Doku	\N	\N	6	1	\N	\N	\N
106670	F_MedDoku_Entlassmedikation_CopyID2	COPY Vormedikation--Entlassmedikation	\N	3	106592	\N	\N	\N
106671	B_IstPflege_Schmerzklassifikation_akut	\N	\N	2	30	\N	\N	\N
106672	B_IstPflege_Schmerzklassifikation_chronisch	\N	\N	2	30	\N	\N	\N
106673	B_IstPflege_Koerperpflege_komplett	\N	\N	2	30	\N	\N	\N
106674	B_IstPflege_Ernaehrung_Normalkost	\N	\N	2	30	\N	\N	\N
106675	B_IstPflege_Ernaehrung_Diaet	\N	\N	2	30	\N	\N	\N
106676	B_IstPflege_Ernaehrung_Anreichen	\N	\N	2	30	\N	\N	\N
106677	B_IstPflege_Ernaehrung_Hilfestellung	\N	\N	2	30	\N	\N	\N
106678	B_IstPflege_FreitextergaenzungAllgem	\N	\N	3	30	\N	\N	Pflege (Freitextergänzung)
106679	B_IstPflege_bisVersorgung_ambPD	\N	\N	2	30	\N	\N	\N
106680	B_IstPflege_bisVersorgung_Angehoerige	\N	\N	2	30	\N	\N	\N
106681	B_IstPflege_bisVersorgung_Sonst	\N	\N	2	30	\N	\N	\N
106682	B_IstPflege_bisVersorgung_selbst	\N	\N	2	30	\N	\N	\N
106683	B_IstPflege_SozVersorgung_OFW	\N	\N	2	30	\N	\N	\N
106684	B_IstPflege_SozVersorgung_Pflegeeinrichtung	\N	\N	2	30	\N	\N	\N
106685	B_IstPflege_SozVersorgung_Betreuung	\N	\N	2	30	\N	\N	\N
106686	B_IstPflege_SozVersorgung_inGemeinschaft	\N	\N	2	30	\N	\N	\N
106687	B_IstPflege_SozVersorgung_alleine	\N	\N	2	30	\N	\N	\N
106688	B_IstPflege_InfoErhaltenvon_Betreuer	\N	\N	2	30	\N	\N	\N
106689	B_IstPflege_InfoErhaltenvon_Anghoerige	\N	\N	2	30	\N	\N	\N
106690	B_IstPflege_InfoErhaltenvon_Sonst	\N	\N	2	30	\N	\N	\N
106691	B_IstPflege_InfoErhaltenvon_Patient	\N	\N	2	30	\N	\N	\N
100318	Dekubitus_Groesse	\N	cm	3	100186	\N	\N	Dekubitus (Dekugröße)
100319	Dekubitus_Wundtiefe	\N	cm	3	100186	\N	\N	Dekubitus (Dekubitustiefe)
100323	Drainagen_Sog	\N	cm H2O	3	100157	\N	\N	Drainagen (Sog)
100324	Drainagen_Pflege	\N	\N	3	100157	\N	\N	Drainagen (Pflege)
100325	Drainagen_Beobachtung	\N	\N	3	100157	\N	\N	Drainagen (Beobachtung)
100326	Drainagen_Sekret	\N	\N	3	100157	\N	\N	Drainagen (Sekretbeschaffenheit)
100331	Atemwege_Pflege	\N	\N	3	100150	\N	\N	Atemwege - Pflege
100332	Enteralesonden_Beobachtung	\N	\N	3	100165	\N	\N	Enterale Sonden (Beobachtung)
100333	Enteralesonden_Markierung	\N	\N	3	100165	\N	\N	Enterale Sonden (Markierung)
100335	HarnwegeDarm_Beobachtung	\N	\N	3	100172	\N	\N	Harnwege (Beobachtung)
100337	Wunddokumentation_Groesse	\N	\N	3	100193	\N	\N	Wunden u. Defekte (Wundgröße)
100338	Wunddokumentation_Wundtiefe	\N	\N	3	100193	\N	\N	Wunden u. Defekte (Wundtiefe)
100339	Wunddokumentation_Beobachtung	\N	\N	3	100193	\N	\N	Wunden u. Defekte (Beobachtung)
100340	Wunddokumentation_Sekret	\N	\N	3	100193	\N	\N	Wunden u. Defekte (Sekretbeschaffenheit)
106692	Behandlung_VO_Sonstige	\N	\N	2	30	\N	\N	\N
106693	Behandlung_VO_Medikation_Akut	\N	\N	2	30	\N	\N	\N
106694	Behandlung_VO_Dauermedikation	bezogen auf kontinuierliche Verordnungen	\N	2	30	\N	\N	\N
106695	B_Entlassbefund_Datum	\N	\N	6	30	\N	\N	\N
106696	Dekubitus_Fotodokumentation_Verlauf	Listeneintrag -Fotodokumentation durchgeführt	\N	3	100186	\N	\N	Dekubitus (Fotodokumentation)
106697	Wunden_Fotodokumentation_Verlauf	Verlaufseintrag bei Erstellung einer Fotodokumentation. Dient nur als Durchführungsnachweis	\N	3	100193	\N	\N	Wunden u. Defekte (Fotodokumentation)
106698	ECMO_Kanuelen	\N	\N	21	1	\N	\N	\N
106699	ECMO_Kanuelen_erste_Beobschtung_Aufnahme	\N	\N	3	106698	\N	\N	ECMO / IABP Kanüle (1. Beobachtung)
106700	ECMO_Kanuelen_Anlage_Aufnahme	\N	\N	5	106698	\N	\N	\N
100358	Koerperpflege_Augen_Status	\N	\N	3	100357	\N	\N	Pflegedoku - Augen (Status rechts)
100359	Bewegen	\N	\N	21	1	\N	\N	\N
100362	Koerperpflege_Augen_Sekret	\N	\N	3	100357	\N	\N	Pflegedoku - Augen (Sekret rechts)
100363	Koerperpflege_Augen_Pflege	\N	\N	3	100357	\N	\N	Pflegedoku - Augen (Pflege rechts)
100365	Koerperpflege_Nase_Status	\N	\N	3	100364	\N	\N	Pflegedoku - Nase (Status rechts)
100366	Koerperpflege_Nase_Pflege	\N	\N	3	100364	\N	\N	Pflegedoku - Nase (Pflege rechts)
100369	Koerperpflege_Mund_Status	\N	\N	3	100368	\N	\N	Pflegedoku - Mund (Status)
100370	Koerperpflege_Mund_Pflege	\N	\N	3	100368	\N	\N	Pflegedoku - Mund (Pflege)
100371	Koerperpflege_Mund_Lippenstatus	\N	\N	3	100368	\N	\N	Pflegedoku - Lippen (Status)
100372	Koerperpflege_Mund_Lippenpflege	\N	\N	3	100368	\N	\N	Pflegedoku - Lippen (Pflege)
100395	Koerperpflege_Betten_Betten	\N	\N	3	100394	\N	\N	Pflegedoku - Betten (Betten)
100407	Bewegen_Bewegungen_DekuRisiko	\N	\N	3	100360	\N	\N	Pflegedoku - Druckgefährdung (Deku Zusatzrisiko)
100408	Bewegen_Bewegungen_DekuProphylaxe	\N	\N	3	100360	\N	\N	Pflegedoku - Druckgefährdung (Deku Prophylaxe)
100410	Bewegen_Bewegungen_Lagerungspeziell	\N	\N	3	100360	\N	\N	Pflegedoku - Positionsunterstützung (speziell)
100411	Bewegen_Bewegungen_Lagerungshilfsmittel	\N	\N	3	100360	\N	\N	Pflegedoku - Mobilisation (Hilfsmittel)
100412	Bewegen_Bewegungen_Mobilisierungsart	\N	\N	3	100360	\N	\N	Pflegedoku - Mobilisation (Art)
100413	Bewegen_Bewegungen_MobiKomplikation	\N	\N	3	100360	\N	\N	Pflegedoku - Mobilisation (Komplikation)
100416	Bewegen_Bewegungen_ExtensionArt	\N	\N	3	100360	\N	\N	Pflegedoku - Mobilisation (Extensionsart)
100417	Bewegen_Bewegungen_ExtensionGewicht	\N	\N	3	100360	\N	\N	Pflegedoku - Mobilisation (Extensionsgewicht)
100420	Befinden_Schlafen_Schlafverhalten	\N	\N	3	100419	\N	\N	Pflegedoku - Schlaf (Schlafverhalten)
100422	Befinden_Befinden_Befund	\N	\N	3	100421	\N	\N	Pflegedoku - Befinden (Befinden)
100423	Befinden_Befinden_Verhalten	\N	\N	3	100421	\N	\N	Pflegedoku - Befinden (Verhalten)
100424	Befinden_Befinden_Bewusstsein	\N	\N	3	100421	\N	\N	Pflegedoku - Befinden (Bewusstsein)
100425	Befinden_Befinden_Stimulation	\N	\N	3	100421	\N	\N	Pflegedoku - Befinden (Simulation)
100429	Befinden_Befinden_BabinskiReflexeLi	\N	\N	3	100421	\N	\N	Befinden (Babinski links)
106701	ECMO_Kanuelen_Markierung_Aufnahme	\N	\N	3	106698	\N	\N	ECMO / IABP Kanüle (Markierung)
106702	ECMO_Kanuelen_entfernt	\N	\N	5	106698	\N	\N	\N
106703	ECMO_Kanuelen_vorhanden	\N	\N	2	106698	\N	\N	\N
106704	ECMO_Kanuelen_Lage	\N	\N	6	106698	\N	\N	\N
100431	Befinden_Krampfanfall_Art	\N	\N	3	100430	\N	\N	Pflegedoku - Krampfanfall (Art / Begleitersch.)
100432	Befinden_Krampfanfall_Lokalisation	\N	\N	3	100430	\N	\N	Pflegedoku - Krampfanfall (Lokalisation)
100433	Befinden_Krampfanfall_Dauer	\N	\N	3	100430	\N	\N	Pflegedoku - Krampfanfall (Dauer)
100435	Befinden_Schmerzen_Lokalisation	\N	\N	3	100434	\N	\N	Pflegedoku - Schmerzen (Lokalisation)
100436	Befinden_Schmerzen_Qualitaet	\N	\N	3	100434	\N	\N	Pflegedoku - Schmerzen (Qualität)
100437	Befinden_Schmerzen_ReportPatient	\N	\N	3	100434	\N	\N	Pflegedoku - Schmerzen (Stärke)
100438	Befinden_Schmerzen_Fremdeinschaetzung	\N	\N	3	100434	\N	\N	Pflegedoku - Schmerzen (Fremdeinschätzung)
100446	Ernaehren	\N	\N	21	1	\N	\N	\N
100448	Ernaehren_Kostform_Erwachsene	\N	\N	3	100447	\N	\N	Pflegedoku - Kostform (Kostform)
100450	Ernaehren_Kostform_Getraenke	\N	\N	3	100447	\N	\N	Pflegedoku - Kostform (Getränke)
100451	Ernaehren_Kostform_Nahrungszusatz	\N	\N	3	100447	\N	\N	Pflegedoku - Kostform (Nahrungszusatz)
100452	Ernaehren_Kostform_Nahrungsaufnahme	\N	\N	3	100447	\N	\N	Pflegedoku - Kostform (Nahrungsaufnahme)
100453	Ernaehren_Ausscheiden_Wert	\N	\N	25	100446	\N	\N	\N
106741	CO_Bericht_Arztbrief_Medi_Name2	\N	\N	3	106740	\N	\N	\N
100467	Ernaehren_Ausscheiden_AnusPraeteroral_Pflege	\N	\N	3	100453	\N	\N	Pflegedoku - AP oral (Pflege)
100468	Ernaehren_Ausscheiden_AnusPraeteraboral_Status	\N	\N	3	100453	\N	\N	Pflegedoku - AP aborall (Status)
100469	Ernaehren_Ausscheiden_AnusPraeteraboral_Pflege	\N	\N	3	100453	\N	\N	Pflegedoku - AP aborall (Pflege)
100472	Sicherheit_Infektionspropylaxe_Massnahme	\N	\N	3	100471	\N	\N	Pflegedoku - Infektionsprophylaxe (Maßnahmen)
100474	Sicherheit_MikrobioProbe_AbnahmeArtOrt	\N	\N	3	100473	\N	\N	Pflegedoku - Mikrobiologische Probe (Abnahme)
100476	Sicherheit_Propylaxen_Thrombosepropylaxe	\N	\N	3	100475	\N	\N	Pflegedoku - Prophylaxen (Thrombosenprophyl.)
100477	Sicherheit_Propylaxen_Kontrakturpropylaxe	\N	\N	3	100475	\N	\N	Pflegedoku - Prophylaxen (Kontrakturprophylaxe)
100478	Sicherheit_Propylaxen_Sturzgefaehrdung	\N	\N	3	100475	\N	\N	Pflegedoku - Prophylaxen (Sturzgefährdung)
100481	Sicherheit_Geraeteueberpruef_Monitor	\N	\N	3	100480	\N	\N	Pflegedoku - Qualitätschecks (Monitor)
100482	Sicherheit_Geraeteueberpruef_Beatmungsgeraet	\N	\N	3	100480	\N	\N	Pflegedoku - Qualitätschecks (Beatmungsgerät)
100501	Sicherheit_Wechsel_Beatmungssystem	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (Systemwechsel Beatmung)
100505	Sicherheit_Wechsel_SaO2SensorI	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (SpO2-Sensor 1)
100506	Sicherheit_Wechsel_SaO2SensorII	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (SpO2-Sensor 2)
100507	Sicherheit_Wechsel_tcO2tcCO2Sonde	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (tcpO2/tcpCO2)
100512	Sicherheit_Wechsel_MSZulauf	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (MS-Zulauf)
100514	Sicherheit_Wechsel_ArtSystem	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (Arterielles System)
100523	Sicherheit_Wechsel_Bett	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (Bett)
100526	PersoenlAspekte_Besucher_Besuchvon	\N	\N	3	100525	\N	\N	Pflegedoku - Besuch (Besucher)
100528	PersoenlAspekte_Taufe_durchgefuehrt	\N	\N	3	100527	\N	\N	Pflegedoku - Seelsorger (Taufe)
100530	PersoenlAspekte_Nottaufe	\N	\N	3	100529	\N	\N	Pflegedoku - Seelsorger (Nottaufe)
100532	PersoenlAspekte_Krankensalbung	\N	\N	3	100531	\N	\N	Pflegedoku - Seelsorger (Krankensalbung)
100533	PT_Massnahme	\N	\N	21	1	\N	\N	\N
100535	PT_Massnahmen_AbbruchDerTherapie	\N	\N	3	100534	\N	\N	Physioth/Ergoth/Logop (Abbruch der Therapie)
100536	PT_Massnahmen_AnleitungBeratung	\N	\N	3	100534	\N	\N	Physioth/Ergoth/Logop (Anleitung/Beratung)
100537	PT_Massnahmen_Atemtherapie	\N	\N	3	100534	\N	\N	Physioth/Ergoth/Logop (Atemtherapie)
100538	PT_Massnahmen_BefunderhebungUntersuchung	\N	\N	3	100534	\N	\N	Physioth/Ergoth/Logop (Befunderheb./Untersuchung)
106705	ECMO_Kanuelen_Groesse	\N	\N	3	106698	\N	\N	ECMO / IABP Kanüle (Göße)
106706	ECMO_Kanuelen_Typ	\N	\N	3	106698	\N	\N	ECMO / IABP Kanüle (Typ)
106707	ECMO_Kanuelen_Wert	\N	\N	25	106698	\N	\N	\N
100543	PT_Massnahmen_Hilfsmittelversorgung	\N	\N	3	100534	\N	\N	Physioth/Ergoth/Logop (Hilfsmittelversorgung)
100546	PT_Massnahmen_Lagerung	\N	\N	3	100534	\N	\N	Physioth/Ergoth/Logop (Lagerung)
100547	PT_Massnahmen_Lokomotion	\N	\N	3	100534	\N	\N	Physioth/Ergoth/Logop (Mobilisation)
100548	PT_Massnahmen_ManuelleLymphdrainage	\N	\N	3	100534	\N	\N	Physioth/Ergoth/Logop (Manuelle Lymphdrainage)
100549	PT_Massnahmen_ManuelleTherapie	\N	\N	3	100534	\N	\N	Physioth/Ergoth/Logop (Manuelle Therapie)
100550	PT_Massnahmen_Massagetherapie	\N	\N	3	100534	\N	\N	Physioth/Ergoth/Logop (Massagetherapie)
100551	PT_Massnahmen_PhysiotherapieAllgemein	\N	\N	3	100534	\N	\N	Physioth/Ergoth/Logop (Physioth. Allgemein)
100555	PT_Massnahmen_PTNeurophysiologischerGrundlage	\N	\N	3	100534	\N	\N	Physioth/Ergoth/Logop (Neurophysiologische Ther)
100558	PT_Massnahmen_Thermotherapie	\N	\N	3	100534	\N	\N	Physioth/Ergoth/Logop (Thermotherapie)
106708	ECMO_Kanuelen_Pulse	\N	\N	3	106707	\N	\N	ECMO-Kanülen (Pulse)
106709	ECMO_Kanuelen_Systemwechsel	\N	\N	3	106707	\N	\N	ECMO-Kanülen (Systemwechsel)
106710	ECMO_Kanuelen_Blutentnahme	\N	\N	6	106707	\N	\N	\N
106711	ECMO_Kanuelen_Markierung_cm	\N	\N	6	106707	\N	\N	\N
106712	ECMO_Kanuelen_Beobachtung	\N	\N	3	106707	\N	\N	ECMO-Kanülen (Beobachtung)
106713	ECMO_Kanuele_Pflege	\N	\N	3	106707	\N	\N	ECMO-Kanülen (Pflege)
106714	Behandlung_Mitbehandler_NA	\N	\N	3	30	\N	\N	\N
106715	B_UeW_Sonst_kont	\N	\N	39	30	\N	\N	\N
106716	B_UeW_Drainagen_kont	\N	\N	39	30	\N	\N	\N
106717	B_UeW_Bilanz_kont	\N	\N	39	30	\N	\N	\N
106718	B_UeW_Neurolog_Status_kont	\N	\N	39	30	\N	\N	\N
106719	B_UeW_Kreislaufkontrolle_kont	\N	\N	39	30	\N	\N	\N
106720	B_Entlassungsbefund_Datum	Neuanlage für B_Entlassbefund, da diese den falschen Datentyp hat	\N	5	30	\N	\N	\N
106721	B_Zuweisung_Warteraum	\N	\N	2	30	\N	\N	\N
106722	B_Zuweisung_Behandlungsraum	\N	\N	2	30	\N	\N	\N
106725	Arztbrief	\N	\N	37	30	\N	\N	\N
106726	Arztbriefunterstuetzung_Gesamt	\N	\N	3	106725	\N	\N	\N
106727	Arztbriefunterstuetzung_Datum	\N	\N	3	106725	\N	\N	\N
104388	AT_Warmtouch	\N	\N	2	30	\N	\N	\N
106728	Arztbriefunterstuetzung_Abschlussdiagnose	\N	\N	3	106725	\N	\N	\N
106729	Arztbriefunterstuetzung_Aufnahmegrund	\N	\N	3	106725	\N	\N	\N
106730	Arztbriefunterstuetzung_Medikationstherapie	\N	\N	3	106725	\N	\N	\N
106731	Arztbriefunterstuetzung_E_Medikation	\N	\N	3	106725	\N	\N	\N
106732	Arztbriefunterstuetzung_V_Medikation	\N	\N	3	106725	\N	\N	\N
106733	Arztbriefunterstuetzung_Untersuchung	\N	\N	3	106725	\N	\N	\N
106734	Arztbriefunterstuetzung_Therapie	\N	\N	3	106725	\N	\N	\N
106735	Arztbriefunterstuetzung_MaBiDiKo	\N	\N	3	106725	\N	\N	\N
106736	Arztbriefunterstuetzung_Anamnese	\N	\N	3	106725	\N	\N	\N
106737	B_IstPflege_Koerperpflege_Hilfestellung	\N	\N	2	30	\N	\N	\N
106738	B_IstPflege_Koerperpflege_Selbstaendig	\N	\N	2	30	\N	\N	\N
106739	CO_Bericht_Arztbrief2	\N	\N	1	20	\N	\N	\N
106740	CO_Bericht_Arztbrief_Medikation2	\N	\N	1	106739	\N	\N	\N
106742	CO_Bericht_Arztbrief_Medi_Appl2	\N	\N	3	106740	\N	\N	\N
106743	CO_Bericht_Arztbrief_Medi_Info2	\N	\N	3	106740	\N	\N	\N
106744	CO_Bericht_Arztbrief_Medi_Schema2	\N	\N	3	106740	\N	\N	\N
106745	IstPflege_ErnaehrAussch_SpontUrin_Beurteilung	\N	\N	3	30	\N	\N	Ausscheidung (Beurteilung Urin)
106746	IstPflege_ErnaehrAussch_SpontStuhl_Beurteilung	\N	\N	3	30	\N	\N	Ausscheidung (Beurteilung Stuhl)
106747	ECMO_Kanuelen_Lage_string	\N	\N	3	106698	\N	\N	ECMO / IABP Kanüle (Lage)
106748	IstPflege_Ausscheidung_Bemerkungen	\N	\N	3	30	\N	\N	Ausscheidung (Bemerkung)
106749	Fall_UStix	\N	\N	1	20	\N	\N	\N
106750	UStix_Bilirubin	\N	\N	3	106749	\N	\N	\N
106751	UStix_Blut	\N	\N	3	106749	\N	\N	\N
106752	UStix_Dichte	\N	\N	3	106749	\N	\N	\N
106753	UStix_Glucose	\N	\N	3	106749	\N	\N	\N
106754	UStix_Haemoglobin	\N	\N	3	106749	\N	\N	\N
106755	UStix_Keton	\N	\N	3	106749	\N	\N	\N
106756	UStix_Leukoz	\N	\N	3	106749	\N	\N	\N
106757	UStix_Nitrit	\N	\N	3	106749	\N	\N	\N
106758	UStix_pH	\N	\N	3	106749	\N	\N	\N
106759	UStix_Protein	\N	\N	3	106749	\N	\N	\N
106760	UStix_Urobilinogen	\N	\N	3	106749	\N	\N	\N
106761	UStix_Wert	\N	\N	3	106749	\N	\N	\N
106762	UStix_Datum	\N	\N	3	106749	\N	\N	\N
106766	Fall_UStix_DateTime	\N	\N	5	106749	\N	\N	\N
106768	B_Relevante_Vorgeschichte	\N	\N	3	30	\N	\N	\N
106769	B_AufnahmeSozialanamneseArzt	\N	\N	3	30	\N	\N	\N
106770	MTS_Visus_Arzt	\N	\N	3	106520	\N	\N	\N
106771	MTS_Visus_Arzt_Zeitpunkt	\N	\N	5	106520	\N	\N	\N
106772	Arztbriefunterstuetzung_Vorerkrankung	\N	\N	3	106725	\N	\N	\N
100642	IstPflege_Bewusstsein	\N	\N	3	30	\N	\N	Bewusstsein
100646	PersoenSeelsGespraech	\N	\N	3	100645	\N	\N	Pflegedoku - Seelsorger (Gespräch)
100648	PersoenlAspekte_Ethikkonsil	\N	\N	3	100647	\N	\N	Pflegedoku -  Ethikkonsil (Status)
100651	AtmenKreislaufTemp_Atemtyp	\N	\N	3	100650	\N	\N	Pflegedoku - Atmung (Atemtyp)
100652	AtmenKreislaufTemp_Atemgeraeusch	\N	\N	3	100650	\N	\N	Pflegedoku - Atmung (Atemgeräusch)
100653	AtmenKreislaufTemp_At_BelueftungRe	\N	\N	3	100650	\N	\N	Pflegedoku - Atmung (Belüftung rechts)
100654	AtmenKreislaufTemp_At_Einziehung	\N	\N	3	100650	\N	\N	Pflegedoku - Atmung (Einziehungen)
100655	AtmenKreislaufTemp_At_Husten	\N	\N	3	100650	\N	\N	Pflegedoku - Atmung (Husten / -reflex)
100656	AtmenKreislaufTemp_At_Abhusten	\N	\N	3	100650	\N	\N	Pflegedoku - Atmung (Abhusten)
100657	AtmenKreislaufTemp_At_Atemtrain	\N	\N	3	100650	\N	\N	Pflegedoku - Atmung (Atemtraining)
100658	AtmenKreislaufTemp_At_Atemtherapie	\N	\N	3	100650	\N	\N	Pflegedoku - Atmung (Atemtherapie)
106773	Arztbriefunterstuetzung_BehDiagnose	Behandlungsdiagnose	\N	3	106725	\N	\N	\N
106774	Arztbriefunterstuetzung_ReleVorges	Relevante Vorgeschichte	\N	3	106725	\N	\N	\N
106775	Arztbriefunterstuetzung_VitalparameterMTS	\N	\N	3	106725	\N	\N	\N
106776	ABP1_Messung_Ort	Ort der Messung ABP1	\N	19	1	\N	\N	\N
106777	ABP2_Messung_Ort	Ort der Messung ABP2	\N	19	1	\N	\N	\N
106778	Fototherapie_Balken	\N	\N	19	1	\N	\N	\N
106779	SpO2_Messung_Ort_Paediatrie	\N	\N	19	1	\N	\N	\N
106780	SpO2_Messung_Ort2_Paediatrie	\N	\N	19	1	\N	\N	\N
106781	LEV_Geraeteauswahl	\N	\N	26	1	\N	\N	\N
106782	Arztbriefunterstuetzung_UStix	\N	\N	3	106725	\N	\N	\N
106783	Beatmung_ES_Optiflow_O2Konzentration	\N	%	6	1	\N	\N	\N
106784	Beatmung_ES_Optiflow_O2Flow	\N	l/min	6	1	\N	\N	\N
106785	Beatmung_ES_Optiflow_PEEP	Liste hinterlegt, definierte Peepeinstellungen über Ventil	mbar/cmH2o	3	1	\N	\N	\N
107783	NEV_PD_Doku_Einlaufzeit	\N	\N	3	1	\N	\N	\N
100659	AtmenKreislaufTemp_At_Absaugen	\N	\N	3	100650	\N	\N	Pflegedoku - Atmung (Absaugen)
100660	AtmenKreislaufTemp_At_NaseRachensekr	\N	\N	3	100650	\N	\N	Atmung (Nase-/Rachensekret)
100661	AtmenKreislaufTemp_At_Trachsekret	\N	\N	3	100650	\N	\N	Atmung (TrachSekret)
100662	AtmenKreislaufTemp_At_TrachMenge	\N	\N	3	100650	\N	\N	Pflegedoku - Atmung (Trachealsekretmenge)
100664	AtmenKreislaufTemp_Kreisl_Pulskontr	\N	\N	3	100663	\N	\N	Pflegedoku - Kreislauf (Pulskontrolle rechts)
100667	AtmenKreislaufTemp_Kreisl_RekapZeit	\N	\N	3	100663	\N	\N	Pflegedoku - Kreislauf (Rekapillarisierungszeit)
100669	AtmenKreislaufTemp_Temp_TempStatusPat	\N	\N	3	100668	\N	\N	Pflegedoku - Temperatur (Status Patient)
100670	AtmenKreislaufTemp_Temp_TempRegul	\N	\N	3	100668	\N	\N	Pflegedoku - Temperatur (Regulation)
107784	NEV_PD_Doku_Auslaufhoehe	\N	cm	6	1	\N	\N	\N
107785	NEV_PD_Doku_Auslaufmenge	\N	ml	6	1	\N	\N	\N
107786	NEV_PD_Doku_Auslaufzeit	\N	\N	3	1	\N	\N	\N
107787	NEV_PD_Doku_Aussehen_Dialysat	\N	\N	3	1	\N	\N	\N
107788	NEV_PD_Doku_Bemerkung	\N	\N	3	1	\N	\N	\N
107789	NEV_PD_Doku_Bilanz	\N	\N	6	1	\N	\N	\N
107790	NEV_PD_Doku_Dialysat1_Balken	\N	\N	19	1	\N	\N	\N
107791	NEV_PD_Doku_Dialysat2_Balken	\N	\N	19	1	\N	\N	\N
107792	NEV_PD_Doku_Einlaufhoehe	\N	cm	6	1	\N	\N	\N
107793	NEV_PD_Doku_Einlaufmenge	\N	ml	6	1	\N	\N	\N
107794	NEV_PD_Doku_Mischung_Lsg1_Lsg2	\N	\N	3	1	\N	\N	\N
107795	NEV_PD_Doku_Schlauchheizung	\N	°C	6	1	\N	\N	\N
107796	NEV_PD_Doku_Verweildauer	\N	\N	3	1	\N	\N	\N
107797	NEV_PD_Doku_Zugang	\N	\N	3	1	\N	\N	\N
107798	NEV_PD_Doku_Zugang_Balken	\N	\N	19	1	\N	\N	\N
107799	NEV_PD_Doku_Zykluszeit	\N	\N	3	1	\N	\N	\N
107800	NEV_PD_VO_Auslaufmenge	Pertionealdialyse Auslaufmenge in ml	ml	6	1	\N	\N	\N
107801	NEV_PD_VO_Auslaufzeit	Auslaufzeit	\N	3	1	\N	\N	\N
107802	NEV_PD_VO_Dialysat1_Balken	\N	\N	19	1	\N	\N	\N
107803	NEV_PD_VO_Dialysat2_Balken	\N	\N	19	1	\N	\N	\N
107804	NEV_PD_VO_Einlaufhoehe	Einlaufhöhe in cm	cm	3	1	\N	\N	\N
100731	Ernaehren_Ausscheiden_Stuhl_Mengeml	\N	ml	6	100453	\N	\N	\N
107805	NEV_PD_VO_Einlaufmenge	Peritonealdialyse Einlaufmenge in ml	ml	6	1	\N	\N	\N
107806	NEV_PD_VO_Einlaufzeit	\N	\N	3	1	\N	\N	\N
107807	NEV_PD_VO_Mischung_Lsg1_Lsg2	\N	\N	3	1	\N	\N	\N
107808	NEV_PD_VO_Verweildauer	\N	\N	3	1	\N	\N	\N
107809	NEV_PD_VO_Zugang_Balken	\N	\N	19	1	\N	\N	\N
107810	NEV_PD_VO_Zykluszeit	\N	\N	3	1	\N	\N	\N
107811	Beatmung_ES_Leoni_Sauerstoff	\N	Vol %	6	1	\N	\N	\N
107812	Beatmung_ES_Leoni_Apnoezeit	Apnoezeit	sec.	6	1	\N	\N	\N
107813	Beatmung_ES_Leoni_Pinsp	\N	cmH2O	6	1	\N	\N	\N
107814	Beatmung_ES_Leoni_Psupport	\N	cmH20	6	1	\N	\N	\N
107815	Beatmung_ES_Leoni_PEEP	\N	cmH2O	6	1	\N	\N	\N
107816	Beatmung_ES_Leoni_FlowInsp	\N	l/min	6	1	\N	\N	\N
107817	Beatmung_ES_Leoni_TriggerVol	\N	%	6	1	\N	\N	\N
107818	Beatmung_ES_Leoni_Frequenz	\N	1/min	6	1	\N	\N	\N
107819	Beatmung_ES_Leoni_TInsp	\N	sec	6	1	\N	\N	\N
107820	Beatmung_ES_Leoni_Backup	\N	1/min	6	1	\N	\N	\N
107821	Beatmung_ES_Leoni_Flow	\N	l/min	6	1	\N	\N	\N
107822	Beatmung_ES_Leoni_CPAP	\N	cmH2O	6	1	\N	\N	\N
107823	Beatmung_ES_Leoni_TApnoe	\N	sec	6	1	\N	\N	\N
107824	Beatmung_ES_Leoni_HFFrequenz	\N	\N	6	1	\N	\N	\N
107825	Beatmung_ES_Leoni_HFAmplitude	\N	cmH2O	6	1	\N	\N	\N
107826	Beatmung_ES_Leoni_IEVerhaeltnis	\N	\N	3	1	\N	\N	\N
107828	Beatmung_ES_Leoni_IRec	\N	sec	6	1	\N	\N	\N
107829	Beatmung_ES_Leoni_Frequenz_Rec	\N	\N	6	1	\N	\N	\N
107830	Beatmung_ES_Leoni_PRec	\N	sec	6	1	\N	\N	\N
107831	Beatmung_ES_Leoni_P_man	\N	cmH2O	6	1	\N	\N	\N
107832	Beatmung_ES_Leoni_Flush	\N	\N	6	1	\N	\N	\N
107833	Beatmung_MS_Leoni_O2	\N	Vol%	6	1	\N	\N	\N
107834	Beatmung_MS_Leoni_Ppeak	\N	cmH2O	6	1	\N	\N	\N
107835	Beatmung_MS_Leoni_Pmean	\N	cmH2O	6	1	\N	\N	\N
107836	Beatmung_MS_Leoni_Peep_CPAP	\N	cmH2O	6	1	\N	\N	\N
107837	Beatmung_MS_Leoni_Frequenz	\N	1/min	6	1	\N	\N	\N
107838	Beatmung_MS_Leoni_MV	\N	l/min	6	1	\N	\N	\N
107839	Beatmung_MS_Leoni_Vti	\N	ml	6	1	\N	\N	\N
107840	Beatmung_MS_Leoni_Vte	\N	ml	6	1	\N	\N	\N
107841	Beatmung_MS_Leoni_Freq_Spontan	\N	1/min	6	1	\N	\N	\N
107842	Beatmung_MS_Leoni_Spont	\N	%	6	1	\N	\N	\N
107843	Beatmung_MS_Leoni_Leck	\N	%	6	1	\N	\N	\N
107844	Beatmung_MS_Leoni_Cdyn	\N	ml/cmH2O	6	1	\N	\N	\N
100776	IstPflege_Koerperkerntemp	\N	\N	3	30	\N	\N	Temperatur (Wert)
100777	IstPflege_periphTemperatur	\N	\N	3	30	\N	\N	Temperatur (Info)
107845	Beatmung_MS_Leoni_Texp	\N	sec	6	1	\N	\N	\N
107846	Beatmung_MS_Leoni_BaseFlow	\N	l/min	6	1	\N	\N	\N
107847	Beatmung_MS_Leoni_HFAmp	\N	cmH2O	6	1	\N	\N	\N
107848	Beatmung_MS_Leoni_FreqHZ	\N	\N	6	1	\N	\N	\N
107849	Beatmung_MS_Leoni_DCO2	\N	ml/sec	6	1	\N	\N	\N
107850	Beatmung_MS_Leoni_VTHF	\N	\N	6	1	\N	\N	\N
107851	Beatmung_MS_Leoni_C20C	\N	\N	6	1	\N	\N	\N
107852	Bewegen_Bewegungen_LagerungKinderklinikBalken	\N	\N	19	1	\N	\N	\N
107853	Therapiebetten_Doku_Giraffe_ES_Luftfeuchtigkeit	Einstellung der Luftfeuchtigkeit im Inkubator	%	6	1	\N	\N	\N
107854	Therapiebetten_Doku_Giraffe_ES_Lufttemperatur	Einstellung der Luftemperatur	°C	6	1	\N	\N	\N
107855	Therapiebetten_Doku_Giraffe_ES_O2	Einstellung der O2-Konzentration im Inkubator	%	6	1	\N	\N	\N
107856	Therapiebetten_Doku_Giraffe_MS_Luftfeuchtigkeit	Messung der Luftfeuchtigkeit im Inkubator	%	6	1	\N	\N	\N
107857	Therapiebetten_Doku_Giraffe_MS_Lufttemperatur	Messung der Luftemperatur im Inkubator	°C	6	1	\N	\N	\N
107858	Therapiebetten_Doku_Giraffe_MS_O2	Messung der O2-Konzentration im Inkubator	%	6	1	\N	\N	\N
107859	Therapiebetten_VO_Giraffe_ES_Luftfeuchtigkeit	\N	%	6	1	\N	\N	\N
107860	Therapiebetten_VO_Giraffe_ES_Lufttemperatur	\N	°C	6	1	\N	\N	\N
107861	Therapiebetten_VO_Giraffe_ES_O2_Konzentration	\N	%	6	1	\N	\N	\N
107862	Therapiebetten_Doku_Atom_ES_Luftfeuchtigkeit	\N	%	6	1	\N	\N	\N
107863	Therapiebetten_Doku_Atom_ES_Lufttemperatur	\N	°C	6	1	\N	\N	\N
107864	Therapiebetten_Doku_Atom_ES_O2_Konzentration	\N	%	6	1	\N	\N	\N
107865	Therapiebetten_VO_Atom_ES_Luftfeuchtigkeit	\N	%	6	1	\N	\N	\N
107866	Therapiebetten_VO_Atom_ES_Lufttemperatur	\N	°C	6	1	\N	\N	\N
107867	Therapiebetten_VO_Atom_ES_O2_Konzentration	\N	%	6	1	\N	\N	\N
107868	Beatmung_ES_T1_Ttief	Einstellwert: Zeiteinstellung für das untere Druckniveau	mbar	6	1	\N	\N	\N
107869	Beatmung_ES_T1_Vt	Einstellwert: Tidalvolumen	ml	6	1	\N	\N	\N
107870	Beatmung_MS_T1_AutoPeep	Unerwarteter positiver endexspiratorischer Druck	mbar	6	1	\N	\N	\N
107871	Beatmung_MS_T1_Cstat	Statische Compliance	ml/mbar	6	1	\N	\N	\N
107872	Beatmung_MS_T1_ExpMinVol	Exspiratorisches Minutenvolumen	l/min	6	1	\N	\N	\N
107873	Beatmung_MS_T1_ExspFlow	Exspiratorischer Peakflow	l/min	6	1	\N	\N	\N
107874	Beatmung_MS_T1_fSpontan	Spontane Atemfrequenz	AZ/min	6	1	\N	\N	\N
107875	Beatmung_MS_T1_fTotal	Gesamtfrequenz	AZ/min	6	1	\N	\N	\N
107876	Beatmung_MS_T1_IEVerhaeltnis	gemessenes I:E Verhältnis	\N	3	1	\N	\N	\N
107877	Beatmung_MS_T1_Mvspont	\N	l/min	6	1	\N	\N	\N
100778	IstPflege_AtmKreislTemp_Bemerkungen	\N	\N	3	30	\N	\N	Atmung, Kreislauf, Temperatur (Bemerkung)
100785	IstPflege_Verhalten	\N	\N	3	30	\N	\N	Patientenverhalten
100787	IstPflege_SchmerzrepPat	\N	\N	3	30	\N	\N	Schmerzreport (Patient)
100788	IstPflege_FremdeinschSchmerz	\N	\N	3	30	\N	\N	Fremdeinschätzung Schmerz
100794	IstPflege_Befinden_Bemerkungen	\N	\N	3	30	\N	\N	Befinden (Bemerkungen)
100816	IstPflege_Beweg_Bewegungen	\N	\N	3	30	\N	\N	Bewegung (Bewegung)
100817	IstPflege_Bewegen_Muskeltonus	\N	\N	3	30	\N	\N	Bewegung (Muskeltonus)
100818	IstPflege_Bewegen_Handicaps	\N	\N	3	30	\N	\N	Bewegung (Handicaps)
107878	Beatmung_MS_T1_InspFlow	Inspiratorischer Peakflow	l/min	6	1	\N	\N	\N
107915	NEV_PD_VO_Zugang	\N	\N	3	1	\N	\N	\N
107879	Beatmung_MS_T1_O2VolProzent	Sauerstoffkonzentration des abgegebenen Gasgemisches	%	6	1	\N	\N	\N
107880	Beatmung_MS_T1_P01	Atemweg-Okklusionsdruck, ein Monitoring-Parameter	mbar	6	1	\N	\N	\N
107881	Beatmung_MS_T1_PeepCPAP	Messwert: Beatmungsdruck Peep/CPAP	mbar	6	1	\N	\N	\N
107882	Beatmung_MS_T1_petCO2	\N	mmHg	6	1	\N	\N	\N
107883	Beatmung_MS_T1_Pinsp	Inspiratorischer Druck; mit Pinsp wird der Zieldruck (zusätzlich zu PEEP/CPAP) bezeichnet, der im Modus ASV während der Inspirationsphase abgegeben wird	mbar	6	1	\N	\N	\N
107884	Beatmung_MS_T1_Pmittel	Messwert: Beatmungsmitteldruck	mbar	6	1	\N	\N	\N
107885	Beatmung_MS_T1_Pmin	Minimaler Atemwegsdruck, ein Monitoring Parameter	mbar	6	1	\N	\N	\N
107886	Beatmung_MS_T1_Pplateau	Plateau-Atemwegsdruck	mbar	6	1	\N	\N	\N
107887	Beatmung_MS_T1_PTP	Druck Zeit Produkt (Pressure Time Product)	mbar x s	6	1	\N	\N	\N
107888	Beatmung_MS_T1_Rinsp	Inspiratorische Flow-Resistance	mbar/l/s	6	1	\N	\N	\N
107889	Beatmung_MS_T1_RSB	Index für schnelle Flachatmung (Rapid Shallow Breathing Index)	\N	6	1	\N	\N	\N
107890	Beatmung_MS_T1_SpO2	Wert gemessen am Ventilator	mmHg	6	1	\N	\N	\N
107891	Beatmung_MS_T1_TI	Inspirationszeit in Sekunden	s	6	1	\N	\N	\N
107892	Beatmung_MS_T1_VLeckage	Leckagevolumen	l/min	6	1	\N	\N	\N
107893	Beatmung_MS_T1_VTE	Messwert; exspiratorisches Tidalvolumen	ml	6	1	\N	\N	\N
107894	Beatmung_MS_T1_Vti	\N	ml	6	1	\N	\N	\N
107895	Beatmung_ES_T1_IEVerhaeltnis	\N	\N	3	1	\N	\N	\N
107897	Beatmung_ES_T1_Timaxi	eingestellte maximale Inspirationszeit im Modus NIV	\N	6	1	\N	\N	\N
100819	IstPflege_Bewegen_Bemerkungen	\N	\N	3	30	\N	\N	Bewegung (Bemerkungen)
100823	IstPflege_ErnaehrAusscheid_Bemerkungen	\N	\N	3	30	\N	\N	Ernährung (Bemerkungen)
100828	IstPflege_Koerperpfl_Hautstatus	\N	\N	3	30	\N	\N	Körperpflege (Hautstatus)
100829	IstPflege_Koerperpfl_Hautkolorit	\N	\N	3	30	\N	\N	Körperpflege (Hautkolorit)
100830	IstPflege_Koerperpfl_Augenstatusli	\N	\N	3	30	\N	\N	Körperpflege (Augenstatus links)
100831	IstPflege_Koerperpfl_Augenstatusre	\N	\N	3	30	\N	\N	Körperpflege (Augenstatus rechts)
100832	IstPflege_Koerperpfl_Mundstatus	\N	\N	3	30	\N	\N	Körperpflege (Mundstatus)
100833	IstPflege_Koerperpfl_Fehlbildungen	\N	\N	3	30	\N	\N	Körperpflege (Fehlbildung)
100835	Atemwege_TSBeob	\N	\N	3	100150	\N	\N	Atemwege - Sekretbeschaffenheit
100836	Atemwege_TSMenge	\N	\N	3	100150	\N	\N	Atemwege - TS-Menge
100854	VerlegPfl_Atm_Atemtyp	\N	\N	3	30	\N	\N	Atmen, Kreislauf, Körpertemp. - Atemtyp
107898	Beatmung_ES_T1_Pinsp	\N	mbar	6	1	\N	\N	\N
107899	Beatmung_ES_T1_Flowtrigger	\N	l/min	6	1	\N	\N	\N
107900	Beatmung_ES_T1_PeepCPAP	\N	mbar	6	1	\N	\N	\N
107901	Beatmung_ES_T1_ProzentMinVol	Prozentsatz des Minutenvolumens, eine Parametereinstellung im ASV Modus	%	6	1	\N	\N	\N
107902	Beatmung_ES_T1_Pasvlimit	\N	mbar	6	1	\N	\N	\N
107903	Beatmung_ES_T1_Phoch	Einstellwert oberes Druckniveau im Modus DuoPAP	mbar	6	1	\N	\N	\N
107904	Beatmung_ES_T1_Ptief	Einstellwert: unteres Druckniveau im Modus APRV	mbar	6	1	\N	\N	\N
107905	Beatmung_MS_T1_VT_IBW	\N	\N	6	1	\N	\N	\N
107906	Beatmung_MS_T1_VCO2	\N	\N	6	1	\N	\N	\N
107907	Beatmung_ES_Heimbeatmung_Frequenz	\N	AZ/min	6	1	\N	\N	\N
107908	Beatmung_MS_Heimbeatmung_MV	\N	l/min	6	1	\N	\N	\N
107909	Beatmung_MS_Heimbeatmung_Ppeak	\N	mbar	6	1	\N	\N	\N
107910	Beatmung_MS_Heimbeatmung_Pmittel	\N	mbar	6	1	\N	\N	\N
107911	Beatmung_MS_Heimbeatmung_VTe	\N	ml	6	1	\N	\N	\N
100857	VerlegPfl_Atm_Atemtrain	\N	\N	3	30	\N	\N	Atmen, Kreislauf, Körpertemp. - Atemtraining
100861	VerlegPfl_Atm_Koerperkerntemp	\N	\N	3	30	\N	\N	Atmen, Kreislauf, Körpertemp. - Temperatur
100863	VerlegPfl_Atm_Bemerkung	\N	\N	3	30	\N	\N	Atmen, Kreislauf, Körpertemp. - Bemerkungen
100864	VerlPfl_Befind_Bewusstsein	\N	\N	3	30	\N	\N	Befinden - Bewusstsein
100871	VerlPfl_Befind_Verhalten	\N	\N	3	30	\N	\N	Befinden - Verhalten
100872	VerlPfl_Befind_Reflexe	\N	\N	3	30	\N	\N	Befinden - Reflexe
100882	VerlPfl_Befind_Bemerkungen	\N	\N	3	30	\N	\N	Befinden - Bemerkung
100883	VerlPfl_Beweg_Bewegungen	\N	\N	3	30	\N	\N	Bewegen - Bewegung
100884	VerlPfl_Beweg_Handicaps	\N	\N	3	30	\N	\N	Bewegen - Handicaps
100885	VerlPfl_Beweg_Muskeltonus	\N	\N	3	30	\N	\N	Bewegen - Muskeltonus
100886	VerlPfl_Beweg_Bemerkungen	\N	\N	3	30	\N	\N	Bewegen - Bemerkungen
100887	VerlPfl_Koerperpfl_Hautstatus	\N	\N	3	30	\N	\N	Körperpflege - Hautstatus
100888	VerlPfl_Koerperpfl_Hautkolorit	\N	\N	3	30	\N	\N	Körperpflege - Hautkolorit
107912	Beatmung_MS_Heimbeatmung_VTi	\N	ml	6	1	\N	\N	\N
107913	Beatmung_ES_Heimbeatmung_Drucktrigger	\N	mbar	6	1	\N	\N	\N
107914	Beatmung_ES_Heimbeatmung_Flowtrigger	\N	mbar	6	1	\N	\N	\N
107927	NEV_PD_VO_Einlaufh	Peritonealdialyse - Einlaufhöhe in cm	cm	6	1	\N	\N	\N
107928	P_ADVOS_Doku_AbschlussBegruendung	\N	\N	3	1	\N	\N	\N
107929	P_ADVOS_Doku_AbschlussUrteil	\N	\N	3	1	\N	\N	\N
107930	P_ADVOS_MS_ADVOS_Ultrafiltratmengekum_ml	\N	\N	6	1	\N	\N	\N
107931	P_ADVOS_MS_ADVOS_venDruck	\N	\N	6	1	\N	\N	\N
107932	P_ADVOS_MS_ADVOS_PreDialysatorDruck	\N	\N	6	1	\N	\N	\N
107933	P_ADVOS_MS_ADVOS_artDruck	\N	\N	6	1	\N	\N	\N
107934	P_ADVOS_MS_ADVOS_Calcium_postFilter	\N	\N	6	1	\N	\N	\N
100897	VerlPfl_ErnaehrAussch_KostErw	\N	\N	3	30	\N	\N	Ernährung / Ausscheidung - Kostform
100900	VerlPfl_ErnaehrAussch_NahrAufn	\N	\N	3	30	\N	\N	Ernährung /Ausscheidung - Nahrungsaufnahme
100903	VerlPfl_ErnaehrAussch_Bemerkung	\N	\N	3	30	\N	\N	Ernährung / Ausscheidung - Bemerkungen
100909	VerlegPfl_Koerperpfl_Augenstatusli	\N	\N	3	30	\N	\N	Körperpflege - Augenstatus links
100910	VerlegPfl_Koerperpfl_Augenstatusre	\N	\N	3	30	\N	\N	Körperpflege - Augenstatus rechts
100911	VerlegPfl_Koerperpfl_Mundstatus	\N	\N	3	30	\N	\N	Körperpflege - Mundstatus
100912	VerlegPfl_Koerperpfl_Fehlbildung	\N	\N	3	30	\N	\N	Körperpflege - Fehlbildung
100918	AtmenKreislaufTemp_At_BelueftungLi	\N	\N	3	100650	\N	\N	Pflegedoku - Atmung (Belüftung links)
100921	Atemwege_Markierung	\N	\N	3	100150	\N	\N	Atemwege - Markierung
107935	P_ADVOS_MS_ADVOS_Calcium_preFilter	\N	\N	6	1	\N	\N	\N
107936	P_ADVOS_ES_ADVOS_CalciumFluss	\N	ml/h	6	1	\N	\N	\N
107937	P_ADVOS_ES_ADVOS_CitratFluss	\N	\N	6	1	\N	\N	\N
107938	P_ADVOS_ES_ADVOS_UltrafiltratRate	\N	\N	6	1	\N	\N	\N
107939	P_ADVOS_ES_ADVOS_Systemtemperatur	\N	\N	6	1	\N	\N	\N
107940	P_ADVOS_ES_ADVOS_Blutfluss	\N	\N	6	1	\N	\N	\N
107943	P_ADVOS_Doku_SpuelloesungAntikoag1	\N	\N	3	1	\N	\N	\N
107948	P_ADVOS_ADVOS_Doku_Balken	\N	\N	26	1	\N	\N	\N
107949	P_ADVOS_VO_ADVOS_Systemtemperatur	\N	\N	6	1	\N	\N	\N
107950	P_ADVOS_VO_ADVOS_CalciumFluss	\N	\N	6	1	\N	\N	\N
107951	P_ADVOS_VO_ADVOS_CitratFluss	\N	\N	6	1	\N	\N	\N
107952	P_ADVOS_VO_ADVOS_UFRateMax	\N	\N	6	1	\N	\N	\N
107953	P_ADVOS_VO_ADVOS_BlutflussMax	\N	\N	6	1	\N	\N	\N
107954	P_ADVOS_VO_SpuelloesungAntikoag	\N	\N	3	1	\N	\N	\N
107955	P_ADVOS_VO_Antikoagulation	\N	\N	3	1	\N	\N	\N
107956	P_ADVOS_VO_CalciumLoesung	\N	\N	3	1	\N	\N	\N
107957	P_ADVOS_VO_CitratLoesung	\N	\N	3	1	\N	\N	\N
107958	P_ADVOS_VO_Dialysatloesung	\N	\N	3	1	\N	\N	\N
107959	P_ADVOS_VO_Zugang	\N	\N	3	1	\N	\N	\N
107960	P_ADVOS_VO_Filter	\N	\N	3	1	\N	\N	\N
107961	P_ADVOS_ADVOS_VO_Balken	\N	\N	26	1	\N	\N	\N
107962	P_ADVOS_Doku_CitratLoesung	\N	\N	19	1	\N	\N	\N
107963	P_ADVOS_Doku_CalciumLoesung	\N	\N	19	1	\N	\N	\N
107964	P_ADVOS_Doku_SpuelloesungAntikoag	\N	\N	19	1	\N	\N	\N
107965	P_ADVOS_Doku_Antikoagulanz	\N	\N	19	1	\N	\N	\N
107966	P_ADVOS_Doku_Dialysatloesung	\N	\N	19	1	\N	\N	\N
107967	P_ADVOS_Doku_Filter	\N	\N	19	1	\N	\N	\N
107968	P_ADVOS_Doku_Zugang11	Liste	\N	3	1	\N	\N	\N
107969	Score_Ramsay	\N	\N	1	1	\N	\N	\N
107970	Ramsay_Verlauf_Wert	\N	\N	2	107969	\N	\N	\N
107971	Ramsay_Verlauf_Datum	\N	\N	5	107969	\N	\N	\N
107972	Score_Ramsay_Aufnahme	Aktualisierung der Variablenstruktur , Bestehdner Ramsay Score als String Variable wird hierdurch abgelöst	\N	1	30	\N	\N	\N
107973	Score_Ramsay_Aufnahme_Wert	\N	\N	2	107972	\N	\N	\N
107974	P_ADVOS_Doku_Zugang	\N	\N	19	1	\N	\N	\N
107975	P_Beatmung_ES_C3_Groesse	\N	cm	6	1	\N	\N	\N
107976	P_Beatmung_ES_C3_Body_Wt	eingestelltes Körpergewicht	\N	3	1	\N	\N	\N
107977	P_Beatmung_ES_C3_Druckrampe	\N	s	6	1	\N	\N	\N
107978	P_Beatmung_ES_C3_Tubuskompensation	\N	%	3	1	\N	\N	\N
107979	P_Beatmung_ES_C3_Tubusgroesse	\N	\N	3	1	\N	\N	\N
107980	P_Beatmung_ES_C3_Sauerstoff	\N	Vol%	6	1	\N	\N	\N
107981	P_Beatmung_ES_C3_PEEP_CPAP_Ptief	Eingestellter PEEP, CPAP oder Ptief	mbar	6	1	\N	\N	\N
107982	P_Beatmung_ES_C3_ProzentMinVol	\N	%	6	1	\N	\N	\N
107983	P_Beatmung_ES_C3_Pasvlimit	\N	mbar	6	1	\N	\N	\N
107984	P_Beatmung_ES_C3_Pkontrol_Phoch	\N	mbar	6	1	\N	\N	\N
107985	P_Beatmung_ES_C3_Vt	\N	ml	6	1	\N	\N	\N
107986	P_Beatmung_ES_C3_Pinsp	Inspiratorischer Druck	mbar	6	1	\N	\N	\N
107987	P_Beatmung_ES_C3_Plateau	\N	mbar	6	1	\N	\N	\N
107988	P_Beatmung_ES_C3_F_CMV	Eingestellte CMV Frequenz	\N	3	1	\N	\N	\N
107989	P_Beatmung_ES_C3_F_SIMV	Eingestellte SIMV Frequenz	\N	3	1	\N	\N	\N
107990	P_Beatmung_ES_C3_Thoch	\N	s	6	1	\N	\N	\N
107991	P_Beatmung_ES_C3_Ti	\N	\N	6	1	\N	\N	\N
107992	P_Beatmung_ES_C3_Ptief	\N	\N	6	1	\N	\N	\N
107993	P_Beatmung_ES_C3_Timax	Inspirationszeit max	s	6	1	\N	\N	\N
107994	P_Beatmung_ES_C3_Ttief	\N	\N	6	1	\N	\N	\N
107995	P_Beatmung_ES_C3_Psupport	\N	\N	6	1	\N	\N	\N
107996	P_Beatmung_ES_C3_Flowtrigger	\N	\N	6	1	\N	\N	\N
107997	P_Beatmung_ES_C3_ETS	\N	\N	6	1	\N	\N	\N
107998	P_Beatmung_ES_C3_Flow	\N	l/min	6	1	\N	\N	\N
107999	P_Beatmung_ES_C3_Oxygen_Target_Shift	\N	\N	3	1	\N	\N	\N
108000	P_Beatmung_ES_C3_passiver_Patient	\N	\N	3	1	\N	\N	\N
108001	P_Beatmung_ES_C3_Kein_Recruitment	\N	\N	3	1	\N	\N	\N
108002	P_Beatmung_ES_C3_HLI	\N	\N	3	1	\N	\N	\N
108004	P_Beatmung_ES_C3_Peep_GrenzwertMin	\N	\N	6	1	\N	\N	\N
108005	P_Beatmung_ES_C3_Peep_GrenzwertMax	\N	\N	6	1	\N	\N	\N
108006	P_Beatmung_ES_C3_Quick_Wean	\N	\N	3	1	\N	\N	\N
108007	P_Beatmung_ES_C3_Zeit_zw2_SBT	\N	\N	6	1	\N	\N	\N
108008	P_Beatmung_ES_C3_Frequenz_Backup	\N	AZ/min	6	1	\N	\N	\N
108009	P_Beatmung_ES_C3_Pkontrol_Backup	\N	\N	6	1	\N	\N	\N
108010	P_Beatmung_ES_C3_Backup_Vt	\N	\N	6	1	\N	\N	\N
108011	P_Beatmung_ES_C3_Backup_Ti	\N	s	6	1	\N	\N	\N
108012	P_Beatmung_MS_C3_Sauerstoff	\N	Vol%	6	1	\N	\N	\N
108013	P_Beatmung_MS_C3_VLeckage	\N	\N	6	1	\N	\N	\N
108014	P_Beatmung_MS_C3_VTE	\N	\N	6	1	\N	\N	\N
108015	P_Beatmung_MS_C3_VTi	\N	\N	6	1	\N	\N	\N
108016	P_Beatmung_MS_C3_ExspMinVol	Exspiratorisches Minutenvolumen	l/min	6	1	\N	\N	\N
108017	P_Beatmung_MS_C3_MVspn	spontanes Atemminutenvolumen	l/min	6	1	\N	\N	\N
108018	P_Beatmung_MS_C3_fSpontan	Spontane Atemfrequenz	bpm	6	1	\N	\N	\N
108019	P_Beatmung_MS_C3_fTotal	Gesamtatemfrequenz	bpm	6	1	\N	\N	\N
108020	P_Beatmung_MS_C3_VCO2	\N	\N	6	1	\N	\N	\N
108021	P_Beatmung_MS_C3_petCO2	Endtidaler CO2-Partialdruck	mmHg	6	1	\N	\N	\N
108022	P_Beatmung_MS_C3_Ppeak	\N	\N	6	1	\N	\N	\N
108023	P_Beatmung_MS_C3_Pplateau	Plateau- oder endinspiratorischer Druck	mbar	6	1	\N	\N	\N
108024	P_Beatmung_MS_C3_Pinsp	Inspiratorischer Druck	mbar	6	1	\N	\N	\N
108025	P_Beatmung_MS_C3_Pmittel	\N	\N	6	1	\N	\N	\N
108026	P_Beatmung_MS_C3_PeepCPAP	\N	\N	6	1	\N	\N	\N
108027	P_Beatmung_MS_C3_Pmin	\N	mbar	6	1	\N	\N	\N
108028	P_Beatmung_MS_C3_AutoPeep	AutoPEEP oder intrinsischer PEEP	mbar	6	1	\N	\N	\N
108029	P_Beatmung_MS_C3_TE	\N	\N	6	1	\N	\N	\N
108030	P_Beatmung_MS_C3_TI	\N	\N	6	1	\N	\N	\N
108031	P_Beatmung_MS_C3_IEVerhaeltnis	Verhältnis Inspirationszeit:Exspirationszeit	\N	3	1	\N	\N	\N
108032	P_Beatmung_MS_C3_ExspFlow	Exspiratorischer Peakflow	l/min	6	1	\N	\N	\N
108033	P_Beatmung_MS_C3_InspFlow	Inspiratorischer Peakflow	l/min	6	1	\N	\N	\N
108034	P_Beatmung_MS_C3_RCexsp	Exspiratorische Zeitkonstante	s	6	1	\N	\N	\N
108035	P_Beatmung_MS_C3_Rinsp	Inspiratorische Flow-Resistance	cmH2O/l/s	6	1	\N	\N	\N
108036	P_Beatmung_MS_C3_Cstat	Statische Compliance	ml/mbar	6	1	\N	\N	\N
108037	P_Beatmung_MS_C3_PTP	\N	\N	6	1	\N	\N	\N
108038	P_Beatmung_MS_C3_P01	Atemwegs-Okklusionsdruck	mbar	6	1	\N	\N	\N
104125	Behandlung_DIVI_ZustandBeiPostIntensivVisite	\N	\N	3	30	\N	\N	\N
108039	P_Beatmung_MS_C3_RSB	Index für schnelle Flachatmung („Rapid Shallow Breathing Index“) 	1/l * min	6	1	\N	\N	\N
108040	P_Beatmung_MS_C3_WOBimp	\N	\N	6	1	\N	\N	\N
108041	P_Beatmung_MS_C3_Leckage	\N	%	6	1	\N	\N	\N
108042	P_EctSta	Ectopic Status Label	\N	3	1	\N	\N	\N
108043	P_RhySta	Arrhytmia Rhytm Status label	\N	3	1	\N	\N	\N
108044	Ernaehren_Ausscheiden_Windelgewicht_Mengeg	Windelgewicht in g. Wird in Bilanz als ml verrechnet	\N	6	100453	\N	\N	\N
108045	VO_Fototherapie_Massnahme	\N	\N	39	30	\N	\N	\N
108046	VO_Drainagen_Einstellung_kont	\N	\N	39	30	\N	\N	\N
108047	VO_Magenrestersatz_kont	Magenrestesatz Intervention	\N	39	30	\N	\N	\N
108053	GW_Kopfumfang_kont	Kopfumfang Grenzwert 	\N	39	30	\N	\N	\N
108054	GW_tcpO2_kont	tcpO2 Grenzwert	\N	39	30	\N	\N	\N
108070	VO_AP_Ersatz	Verordnung AP Ersatz	\N	39	30	\N	\N	\N
108071	VO_Nahrungsersatz_kont	\N	\N	39	30	\N	\N	\N
108072	VO_Messintervall_Stuhlgang_kont	Stuhlgang Messintervall	\N	39	30	\N	\N	\N
108073	VO_MS_kont	Magensonde Messintervall	\N	39	30	\N	\N	\N
108074	VO_Fototherapie_kont	\N	\N	39	30	\N	\N	\N
108075	VO_Messintervall_UrinStix_kont	UrinStix Messintervall	\N	39	30	\N	\N	\N
108076	VO_Stuhlgang_Therapie_kont	\N	\N	39	30	\N	\N	\N
108083	VO_Messintervall_tcpO2	tcpO2 Messintervall	\N	39	30	\N	\N	\N
108085	VO_Messintervall_Kopfumfang_kont	Kopfumfang Messintervall	\N	39	30	\N	\N	\N
108089	ZW_GewichtKg_kont	Gewicht Zielwert	\N	39	30	\N	\N	\N
108090	ZW_Kopf_Umfang_kont	Kopfumfang Zielwert	\N	39	30	\N	\N	\N
108091	ZW_tcpO2_kont	tcpO2 Zielwert	\N	39	30	\N	\N	\N
108094	ZW_Sa_O2_kont	SaO2 Zielwert	\N	39	30	\N	\N	\N
108097	Patient_Sorgerecht	\N	\N	3	1	\N	\N	Patient (Sorgerecht)
108098	Patient_verheiratet_Mutter_nein	\N	\N	2	1	\N	\N	\N
108099	Patient_verheiratet_Mutter_ja	\N	\N	2	1	\N	\N	\N
108100	Fall_Para	\N	\N	2	20	\N	\N	\N
108101	Fall_Gravida	\N	\N	2	20	\N	\N	\N
108102	Patient_konsanguin_nein	\N	\N	2	1	\N	\N	\N
108103	Patient_konsanguin_ja	\N	\N	2	1	\N	\N	\N
108104	Aufnahme_Eltern_behArzt	\N	\N	3	30	\N	\N	Aufnahme (Schwangerschaftsanamnese - aufn. Arzt)
108105	Aufnahme_Eltern_Arzt_Datum	\N	\N	5	30	\N	\N	\N
108106	Aufnahme_Herkunftsland_Mutter	Herkunftsland der Mutter	\N	3	1	\N	\N	Mutter (Herkunftsland)
108107	Aufnahme_Beruf_Vater	\N	\N	3	1	\N	\N	Vater (Beruf)
108108	Aufnahme_Beruf_Mutter	\N	\N	3	1	\N	\N	Mutter (Beruf)
108109	B_Aufnahme_Celestan_Datum_3	\N	\N	5	30	\N	\N	\N
108110	B_Aufnahme_Celestan_Datum_2	\N	\N	5	30	\N	\N	\N
108111	Aufnahme_huefte_neg	\N	\N	2	1	\N	\N	\N
108112	Aufnahme_huefte_pos	\N	\N	2	1	\N	\N	\N
108113	Blutgruppe_Mutter	\N	\N	3	1	\N	\N	Mutter (Blutgruppe)
108114	B_Aufnahme_Celestan_Datum_1	\N	\N	5	30	\N	\N	\N
108115	Aufnahme_Celestan_nein	\N	\N	2	30	\N	\N	\N
108116	B_Aufnahme_Celestan_ja	\N	\N	2	30	\N	\N	\N
108117	Aufnahme_AKS_neg	\N	\N	2	30	\N	\N	\N
108118	Aufnahme_AKS_pos	\N	\N	2	30	\N	\N	\N
108119	Aufnahme_GBS_unbekannt	\N	\N	2	30	\N	\N	\N
108120	Aufnahme_GBS_nein	\N	\N	2	30	\N	\N	\N
108121	Aufnahme_GBS_ja	\N	\N	2	30	\N	\N	\N
108122	Aufnahme_Fieber_nein	\N	\N	2	30	\N	\N	\N
108123	Aufnahme_Fieber_ja	\N	\N	2	30	\N	\N	\N
108124	Aufnahme_BS_nein	\N	\N	2	30	\N	\N	\N
108125	Aufnahme_BS_ja	\N	\N	2	30	\N	\N	\N
108126	Aufnahme_Praeeklampsie_nein	\N	\N	2	30	\N	\N	\N
108127	Aufnahme_Praeeklampsie_ja	\N	\N	2	30	\N	\N	\N
108128	P_Aufnahme_Schwangerschaft_sonstigeString	\N	\N	3	1	\N	\N	Aufnahme (Schwangerschaft - Sonstige)
108129	Aufnahme_Schwangerschaft_sonstige	\N	\N	2	1	\N	\N	\N
108130	Aufnahme_Schwangerschaft_ICSI	\N	\N	2	1	\N	\N	\N
108131	Aufnahme_Schwangerschaft_IVF	\N	\N	2	1	\N	\N	\N
108132	Aufnahme_Schwangerschaft_spontan	\N	\N	2	1	\N	\N	\N
108133	Aufnahme_Roeteln_Titer	\N	\N	3	30	\N	\N	Aufnahme (Röteln - Titer)
108134	Aufnahme_Viruslast	\N	\N	3	30	\N	\N	Aufnahme (Viruslast)
108135	Aufnahme_IgM_neg	\N	\N	2	30	\N	\N	\N
108136	Aufnahme_IgM_pos	\N	\N	2	30	\N	\N	\N
108137	Aufnahme_IgG_neg	\N	\N	2	30	\N	\N	\N
108138	Aufnahme_IgG_pos	\N	\N	2	30	\N	\N	\N
108139	Aufnahme_HIV_unbekannt	\N	\N	2	30	\N	\N	\N
108140	Aufnahme_HIV_neg	\N	\N	2	30	\N	\N	\N
108141	Aufnahme_HIV_pos	\N	\N	2	30	\N	\N	\N
108142	Aufnahme_Toxoplasmose_unbekannt	\N	\N	2	30	\N	\N	\N
108143	Aufnahme_Toxoplasmose_neg	\N	\N	2	30	\N	\N	\N
108144	Aufnahme_Toxoplasmose_pos	\N	\N	2	30	\N	\N	\N
108145	Aufnahme_Clamydien_neg	\N	\N	2	30	\N	\N	\N
108146	Aufnahme_Clamydien_pos	\N	\N	2	30	\N	\N	\N
108147	Aufnahme_Roeteln_immun	\N	\N	2	30	\N	\N	\N
108148	Aufnahme_Roeteln_nicht_immun	\N	\N	2	30	\N	\N	\N
108149	Aufnahme_HbsAg_neg	\N	\N	2	30	\N	\N	\N
108150	Aufnahme_HbsAg_pos	\N	\N	2	30	\N	\N	\N
108151	Mutter_Geburtsdatum	Geburtsdatum der Mutter	\N	5	1	\N	\N	\N
108152	Mutter_Name	\N	\N	3	1	\N	\N	Mutter (Name)
104389	AT_Kuehlmatte	\N	\N	2	30	\N	\N	\N
108153	Aufnahme_Alkohol_ja	Alkoholgebrauch während der Schwangerschaft	\N	2	1	\N	\N	\N
108154	Aufnahme_Alkohol_nein	Alkoholgebrauch während der Schwangerschaft	\N	2	1	\N	\N	\N
108155	Aufnahme_Nikotin_ja	Nikotingebrauch während der Schwangerschaft	\N	2	1	\N	\N	\N
108156	Aufnahme_Nikotin_nein	Nikotingebrauch während der Schwangerschaft	\N	2	1	\N	\N	\N
108157	Aufnahme_Insulin_ja	Insulinapplikation während der Schwangerschaft	\N	2	1	\N	\N	\N
108158	Aufnahme_Insulin_nein	Insulinapplikation während der Schwangerschaft	\N	2	1	\N	\N	\N
108159	Aufnahme_GDM_ja	\N	\N	2	1	\N	\N	\N
108160	Aufnahme_GDM_nein	\N	\N	2	1	\N	\N	\N
108161	Aufnahme_Medikamente_Schwangerschaft_Text	\N	\N	3	1	\N	\N	Aufnahme (Medikamente i. d. Schwangerschaft)
108162	Aufnahme_Probleme_Schwangerschaft_Text	\N	\N	3	1	\N	\N	Aufnahme (Schwangerschaftsanamnese Probleme)
108163	Doku_Eltern_Erkrankungen	\N	\N	1	20	\N	\N	\N
108164	Doku_Familienanamnese	\N	\N	1	20	\N	\N	\N
108165	Doku_Vater_Erkrankungen_Eintrag	\N	\N	3	108163	\N	\N	\N
108166	Doku_Familienanamnese_Eintrag	\N	\N	3	108164	\N	\N	Familienanamnese (Eintrag)
108167	Doku_Mutter_Erkrankungen_Eintrag	\N	\N	3	108163	\N	\N	\N
108168	Aufnahme_Geburtslage_becken	\N	\N	2	1	\N	\N	\N
108169	Aufnahme_Geburt_Komplikation_ja	\N	\N	2	1	\N	\N	\N
108170	Aufnahme_Geburtslage_schaedel	\N	\N	2	1	\N	\N	\N
108171	Aufnahme_Geburt_Komplikation_nein	\N	\N	2	1	\N	\N	\N
108172	Aufnahme_Kolorit_marmoriert	\N	\N	2	30	\N	\N	\N
108173	Aufnahme_Kolorit_blass	\N	\N	2	30	\N	\N	\N
108174	Aufnahme_Kolorit_zyanotisch	\N	\N	2	30	\N	\N	\N
108175	Aufnahme_Kolorit_rosig	\N	\N	2	30	\N	\N	\N
108176	Aufnahme_Kolorit_ikterisch	\N	\N	2	30	\N	\N	\N
108177	Aufnahme_Haut_Turgor	\N	\N	2	30	\N	\N	\N
108178	Aufnahme_Haut_Petechien	\N	\N	2	30	\N	\N	\N
108179	Aufnahme_Haut_Oedeme	\N	\N	2	30	\N	\N	\N
108180	Aufnahme_Haut_unauffaellig	\N	\N	2	30	\N	\N	\N
108181	Aufnahme_Fehlbildung_Anus	\N	\N	2	30	\N	\N	\N
108182	Aufnahme_Fehlbildung_auffaellig_beschr	\N	\N	3	30	\N	\N	Aufnahme (Fehlbildungen - auffällig)
108183	Aufnahme_Fehlbildung_auffaellig	\N	\N	2	30	\N	\N	\N
108184	Aufnahme_Fehlbildung_Gaumen	\N	\N	2	30	\N	\N	\N
108185	Aufnahme_Fehlbildung_Kopf	\N	\N	2	30	\N	\N	\N
108186	Aufnahme_Fehlbildung_Bauch	\N	\N	2	30	\N	\N	\N
108187	Aufnahme_Fehlbildung_Skelett	\N	\N	2	30	\N	\N	\N
108188	Aufnahme_Geburtstrauma_Csuccadeneum	\N	\N	2	30	\N	\N	\N
108228	Aufnahme_Atmung_intubiert	\N	\N	2	30	\N	\N	\N
108189	Aufnahme_Geburtstrauma_Verletzung_beschr	\N	\N	3	30	\N	\N	Aufnahme (Trauma - Verletzungen / Hämatome)
108190	Aufnahme_Geburtstrauma_Verletzung	\N	\N	2	30	\N	\N	\N
108191	Aufnahme_Geburtstrauma_Claviculafraktur	\N	\N	2	30	\N	\N	\N
108192	Aufnahme_Geburtstrauma_Kephalhaematom	\N	\N	2	30	\N	\N	\N
108193	Aufnahme_Geburtstrauma_nicht	\N	\N	2	30	\N	\N	\N
108194	Aufnahme_Genitale_auffaellig	\N	\N	2	30	\N	\N	\N
108195	Aufnahme_Genitale_auffaellig_beschr	\N	\N	3	30	\N	\N	Aufnahme (Genitale - auffällig)
108196	Aufnahme_Genitale_weiblich	\N	\N	2	30	\N	\N	\N
108197	Aufnahme_Genitale_maennlich	\N	\N	2	30	\N	\N	\N
108198	Aufnahme_Auge_auffaellig_beschr	\N	\N	3	30	\N	\N	Aufnahme (Auge auffällig)
108199	Aufnahme_Auge_auffaellig	\N	\N	2	30	\N	\N	\N
108200	Aufnahme_Auge_unauffaellig	\N	\N	2	30	\N	\N	\N
108201	Aufnahme_Abdomen_auffaellig_beschr	\N	\N	3	30	\N	\N	Aufnahme (Abdomen - auffällig)
108202	Aufnahme_Abdomen_auffaellig	\N	\N	2	30	\N	\N	\N
108203	Aufnahme_Abdomen_unauff	\N	\N	2	30	\N	\N	\N
108204	Aufnahme_Kreislauf_instabil	\N	\N	2	30	\N	\N	\N
108205	B_Aufnahme_Haut_Exanthem	\N	\N	2	30	\N	\N	\N
108206	Aufnahme_Abdomen_Druckschmerz	\N	\N	2	30	\N	\N	\N
108207	Aufnahme_Abdomen_Splenomegalie	\N	\N	2	30	\N	\N	\N
108208	Aufnahme_Abdomen_Hepatomegalie	\N	\N	2	30	\N	\N	\N
108209	Aufnahme_Abdomen_ausladend	\N	\N	2	30	\N	\N	\N
108210	Aufnahme_Abdomen_Peristaltik	\N	\N	2	30	\N	\N	\N
108211	Aufnahme_Kreislauf_instabil_beschr	\N	\N	3	30	\N	\N	Aufnahme (Kreislauf - instabil)
108212	Aufnahme_Kreislauf_stabil	\N	\N	2	30	\N	\N	\N
108213	Aufnahme_Kreislauf_Herzgeraeusch_beschr	\N	\N	3	30	\N	\N	Aufnahme (Kreislauf - Herzgeräusch)
108214	Aufnahme_Kreislauf_Herzgeraeusch	\N	\N	2	30	\N	\N	\N
108215	Aufnahme_Kreislauf_PulsNichtTastbar	\N	\N	2	30	\N	\N	\N
108216	Aufnahme_Kreislauf_Arrhythmie	\N	\N	2	30	\N	\N	\N
108217	Aufnahme_Kreislauf_Femoralispuls	\N	\N	2	30	\N	\N	\N
108218	Aufnahme_Kreislauf_Herzton	\N	\N	2	30	\N	\N	\N
108219	Aufnahme_Kreislauf_cap	\N	\N	2	30	\N	\N	\N
108220	Aufnahme_Atmung_Bradypnoe	\N	\N	2	30	\N	\N	\N
108221	Aufnahme_Atmung_auffaellig_beschreibung	\N	\N	3	30	\N	\N	Aufnahme (Atmung - Auskultation auffällig)
108222	Aufnahme_Atmung_auffaellig	\N	\N	2	30	\N	\N	\N
108223	Aufnahme_Atmung_Einziehungen	\N	\N	2	30	\N	\N	\N
108224	Aufnahme_Atmung_cpap	\N	\N	2	30	\N	\N	\N
108225	Aufnahme_Atmung_Tachypnoe	\N	\N	2	30	\N	\N	\N
108226	Aufnahme_Atmung_Stoehnen	\N	\N	2	30	\N	\N	\N
108227	Aufnahme_Atmung_O2Vorlage	\N	\N	2	30	\N	\N	\N
108229	Aufnahme_Atmung_Eupnoe	\N	\N	2	30	\N	\N	\N
108230	Aufnahme_Atmung_spontan	\N	\N	2	30	\N	\N	\N
104126	Behandlung_DIVI_DatumPostIntensivVisite2	\N	\N	5	30	\N	\N	\N
108231	B_Aufnahme_Ernaehrungszustand	Ernährungszustand bei Aufnahme	\N	3	30	\N	\N	Aufnahme (Ernährungszustand)
108232	B_Aufnahme_Allgemeinzustand	Allgemeinzustand bei Aufnahme	\N	3	30	\N	\N	Aufnahme (Allgemeinzustand)
108233	Score_Petrussa	\N	\N	1	1	\N	\N	\N
108234	Aufnahme_Paed_Ergaenzung	\N	\N	3	30	\N	\N	Aufnahme (Ergänzungen)
108235	Aufnahme_Neurologie_auffaellig_beschr	\N	\N	3	30	\N	\N	Aufnahme (Neurologie - neurologisch auffällig)
108236	Aufnahme_Neurologie_auffaell	\N	\N	2	30	\N	\N	\N
108237	Aufnahme_Neurologie_Fontanelle_unauffaellig	\N	\N	2	30	\N	\N	\N
108238	Aufnahme_Neurologie_Tonus_unauffaellig	\N	\N	2	30	\N	\N	\N
108239	Aufnahme_Neurologie_Motorik_unauffaellig	\N	\N	2	30	\N	\N	\N
108240	Aufnahme_Neurologie_wach	\N	\N	2	30	\N	\N	\N
108241	Score_Petrussa_Wert	\N	\N	2	108233	\N	\N	\N
108242	Aufnahme_IndikationSectio_Text	\N	\N	3	1	\N	\N	Aufnahme (Indikation zur Sectio)
108243	Aufnahme_Geburt_spontan	\N	\N	2	1	\N	\N	\N
108244	Aufnahme_Geburt_VE	\N	\N	2	1	\N	\N	\N
108245	Aufnahme_Sectio_Notsectio	\N	\N	2	1	\N	\N	\N
108246	Aufnahme_Sectio_sekundaer	\N	\N	2	1	\N	\N	\N
108247	Aufnahme_Sectio_primaer	\N	\N	2	1	\N	\N	\N
108248	B_Aufnahme_Perzentile_Geburtsgewicht	\N	\N	6	30	\N	\N	\N
108249	B_Nabelschnur_pH	\N	\N	6	30	\N	\N	\N
108250	B_Aufnahme_Perzentile_Groesse	\N	\N	6	30	\N	\N	\N
108251	B_Aufnahme_Perzentile_Kopfumfang	\N	\N	6	30	\N	\N	\N
108252	Patient_Kopfumfang_Aufnahme	\N	\N	6	1	\N	\N	\N
108253	P_Apgar_Wert10	\N	\N	2	1	\N	\N	\N
108254	P_Apgar_Wert5	\N	\N	2	1	\N	\N	\N
108255	P_Apgar_Wert1	\N	\N	2	1	\N	\N	\N
108256	F_Sozialanamnese_Betreuung_Schule_Klasse	\N	\N	3	20	\N	\N	Sozialanamnese / Betreuung (Schulklasse)
108257	F_Sozialanamnese_Betreuung_Schule	\N	\N	2	20	\N	\N	\N
108258	F_Sozialanamnese_Betreuung_Kindergarten	\N	\N	2	20	\N	\N	\N
108259	F_Sozialanamnese_Betreuung_zuhause	\N	\N	2	20	\N	\N	\N
108260	F_Sozialanamnese_Betreuung_Sonstiges	\N	\N	3	20	\N	\N	Sozialanamnese / Betreuung (Sonstiges)
108261	B_Impfung_Sonstige_Wert	\N	\N	3	30	\N	\N	Impfungen Sonstige
108262	B_Impfung_sonstige	\N	\N	2	30	\N	\N	\N
108263	B_Impfung_Keine	\N	\N	2	30	\N	\N	\N
108264	B_Impfung_STIKO	Impfungen nach STIKO durchgeführt	\N	2	30	\N	\N	\N
108265	B_Anamnese_Fieber_seit	\N	\N	6	30	\N	\N	\N
108266	B_Anamnese_Obstipation_seit	\N	\N	6	30	\N	\N	\N
108267	B_Anamnese_Durchfall_seit	\N	\N	6	30	\N	\N	\N
108268	B_Anamnese_Erbrechen_seit	\N	\N	6	30	\N	\N	\N
108269	B_Anamnese_Husten_seit	\N	\N	6	30	\N	\N	\N
108270	B_Anamnese_Schnupfen_seit	\N	\N	6	30	\N	\N	\N
108271	B_Anamnese_Obstipation_ja	\N	\N	2	30	\N	\N	\N
108272	B_Anamnese_Durchfall_ja	\N	\N	2	30	\N	\N	\N
108273	B_Anamnese_Erbrechen_ja	\N	\N	2	30	\N	\N	\N
108274	B_Aufnahme_Husten_ja	\N	\N	2	1	\N	\N	\N
108275	B_Aufnahme_Schnupfen_ja	\N	\N	2	30	\N	\N	\N
108276	Aufnahme_Erstversorgung_Text	\N	\N	3	1	\N	\N	Aufnahme (Erstversorgung / Epikrise)
108277	Aufnahme_Geburtslage_andere_text	\N	\N	3	1	\N	\N	Aufnahme (Geburtslage - andere)
108278	Aufnahme_Geburt_Komplikation_Text	\N	\N	3	1	\N	\N	Aufnahme (Geburtskomplikationen)
108279	Aufnahme_Fruchtwasser_blutig	\N	\N	2	1	\N	\N	\N
108280	Aufnahme_Fruchtwasser_erbsbrei	\N	\N	2	1	\N	\N	\N
108281	Aufnahme_Fruchtwasser_gruen	\N	\N	2	1	\N	\N	\N
108282	Aufnahme_Fruchtwasser_klar	\N	\N	2	1	\N	\N	\N
108283	Komplexbehandlung_Kind	\N	\N	1	1	\N	\N	\N
108284	Komplexbehandlung_Kind_Aufnahmestatus	\N	\N	27	108283	\N	\N	\N
108285	Komplexbehandlung_Kind_HF	\N	\N	27	108283	\N	\N	\N
108286	Komplexbehandlung_Kind_Wert	\N	\N	2	108283	\N	\N	\N
108287	Komplexbehandlung_Kind_extern	\N	\N	27	108283	\N	\N	\N
108288	Komplexbehandlung_Kind_Intervention	\N	\N	27	108283	\N	\N	\N
108289	Komplexbehandlung_Kind_AlkaloseAzidose	\N	\N	27	108283	\N	\N	\N
108290	Komplexbehandlung_Kind_ICP	\N	\N	27	108283	\N	\N	\N
108291	Komplexbehandlung_Kind_Dialyse	\N	\N	27	108283	\N	\N	\N
108292	Komplexbehandlung_Kind_Monitoring	\N	\N	27	108283	\N	\N	\N
108293	Komplexbehandlung_Kind_Katheter	\N	\N	27	108283	\N	\N	\N
108294	Komplexbehandlung_Kind_Fluessigkeitsersatz	\N	\N	27	108283	\N	\N	\N
108295	Komplexbehandlung_Kind_Katecholamin	\N	\N	27	108283	\N	\N	\N
108296	Komplexbehandlung_Kind_Beatmung	\N	\N	27	108283	\N	\N	\N
108297	Komplexbehandlung_Kind_GCS	\N	\N	27	108283	\N	\N	\N
108298	Komplexbehandlung_Kind_Pupillenreaktion	\N	\N	27	108283	\N	\N	\N
108299	Komplexbehandlung_Kind_GOT	\N	\N	27	108283	\N	\N	\N
108300	Komplexbehandlung_Kind_Quick	\N	\N	27	108283	\N	\N	\N
108301	Komplexbehandlung_Kind_Kreatinin	\N	\N	27	108283	\N	\N	\N
108302	Komplexbehandlung_Kind_SBE	Standard Base Excess	\N	27	108283	\N	\N	\N
108303	Komplexbehandlung_Kind_Thrombozyten	\N	\N	27	108283	\N	\N	\N
108304	Komplexbehandlung_Kind_Leukozyten	\N	\N	27	108283	\N	\N	\N
108305	Komplexbehandlung_Kind_PaCO2	\N	\N	27	108283	\N	\N	\N
108306	Komplexbehandlung_Kind_Horovitz	\N	\N	27	108283	\N	\N	\N
108307	Komplexbehandlung_Kind_RR_sys	\N	\N	27	108283	\N	\N	\N
108308	Komplexbehandlung_Kind_Alter	\N	\N	27	108283	\N	\N	\N
108309	Bezugsperson_Pflegekraft	\N	\N	3	20	\N	\N	\N
108310	Sicherheit_Wechsel_NeoJet	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (Neo-Jet)
108311	Sicherheit_Wechsel_HME_Filter	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (HME-Filter)
108312	Sicherheit_Wechsel_Ablaufbeutel	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (Ablaufbeutel)
108313	Sicherheit_Wechsel_ZVD	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (ZVD)
108314	Sicherheit_Wechsel_Infusionssystem	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (Infusionssystem)
108315	Sicherheit_Wechsel_Microclave	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (Microclave)
108316	Sicherheit_Wechsel_Dialysesystem	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (Dialysesystem)
108317	Sicherheit_Geraeteueberpruef_ZVD_Arterie_ICP	\N	\N	3	100480	\N	\N	Pflegedoku - Qualitätschecks (ICP)
108318	Sicherheit_Geraeteueberpruef_ZVD_Arterie_PAP	\N	\N	3	100480	\N	\N	Pflegedoku - Qualitätschecks (PAP)
108319	Sicherheit_Geraeteueberpruef_ZVD_Arterie_LAP	\N	\N	3	100480	\N	\N	Pflegedoku - Qualitätschecks (LAP)
108320	Sicherheit_Geraeteueberpruef_ZVD_Arterie	\N	\N	3	100480	\N	\N	Pflegedoku - Qualitätschecks (ZVD/Arterie Null)
108321	P_Ernaehren_Kostform_Nahrungsaufnahme_getrunkenml	Menge der Nahrung in ml, die getrunken wurde. Die Menge wird nicht mit der Bilanz verrechnet	ml	6	100447	\N	\N	\N
108322	P_Ernaehren_Kostform_Nahrungsaufnahme_gestilltml	Menge der Nahrung in ml, die gestillt wurde. Die Menge wird nicht mit der Bilanz verrechnet	ml	6	100447	\N	\N	\N
108323	P_Ernaehren_Kostform_Nahrungsaufnahme_sondiertml	Menge der Nahrung in ml, die sondiert wurde. Die Menge wird nicht mit der Bilanz verrechnet	ml	6	100447	\N	\N	\N
108324	Koerperpflege_Umfaenge_Bein_li_unten	\N	\N	3	104092	\N	\N	Pflegedoku - Umfang (Bein links unten)
108325	Koerperpflege_Umfaenge_Bein_li_oben	\N	\N	3	104092	\N	\N	Pflegedoku - Umfang (Bein links oben)
108326	Koerperpflege_Umfaenge_Bein_re_unten	\N	\N	3	104092	\N	\N	Pflegedoku - Umfang (Bein rechts unten)
108327	Koerperpflege_Umfaenge_Bein_re_oben	\N	\N	3	104092	\N	\N	Pflegedoku - Umfang (Bein rechts oben)
108328	Koerperpflege_Umfaenge_Arm_li_unten	\N	\N	3	104092	\N	\N	Pflegedoku - Umfang (Arm links unten)
108329	Koerperpflege_Umfaenge_Arm_li_oben	\N	\N	3	104092	\N	\N	Pflegedoku - Umfang (Arm links oben)
108330	Koerperpflege_Umfaenge_Arm_re_unten	\N	\N	3	104092	\N	\N	Pflegedoku - Umfang (Arm rechts unten)
108331	Koerperpflege_Umfaenge_Arm_re_oben	\N	\N	3	104092	\N	\N	Pflegedoku - Umfang (Arm rechts oben)
108332	VerlegPfl_Elternanleitung_Hautpflege	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (Hautpflege)
108333	VerlegPfl_Elternanleitung_WaschenBaden	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (Waschen/Baden)
108334	VerlegPfl_Elternanleitung_Mund_Zahnpflege	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (Mund-/Zahnpflege)
108335	VerlegPfl_Elternanleitung_Wickeln	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (Wickeln)
108336	VerlegPfl_Elternanleitung_VerabreichenMedikamente	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (Verab. Medikamente)
108337	VerlegPfl_Elternanleitung_BroviacHickman	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (VW Broviac/Hickman Ka.)
108338	VerlegPfl_Elternanleitung_Einmalkatheter	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (Einmalkatheterisierung)
108339	VerlegPfl_Elternanleitung_APPflege	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (AP Pflege)
108340	VerlegPfl_Elternanleitung_E_Pumpe	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (Umgang Ernährungspumpe)
108341	VerlegPfl_Elternanleitung_PEG	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (Pflege von MS/PEG)
104127	Behandlung_DIVI_ZustandBeiVerlegung	\N	\N	3	30	\N	\N	\N
101319	Zugaenge_Systemwechsel	\N	\N	3	100179	\N	\N	Zugänge (Systemwechsel)
101320	Atemw_Systemwechsel	\N	\N	3	100150	\N	\N	Atemwege - Systemwechsel
108342	VerlegPfl_Elternanleitung_Sondieren	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (Sondieren von Nahrung)
108343	VerlegPfl_Elternanleitung_Stillanleitung	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (Stillanleitung/Fütter.)
108344	VerlegPfl_Elternanleitung_Notsituation	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (Verhalten Notsituation)
108345	VerlegPfl_Elternanleitung_Inhalation	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (Inhalation)
108346	VerlegPfl_Elternanleitung_ManuelleBeutelbeatmung	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (Manu. Beutelbeat. TK) 
108347	VerlegPfl_Elternanleitung_Absaugen	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (Absaugen TK)
108348	VerlegPfl_Elternanleitung_TKWechsel	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (TK Wechsel)
108349	VerlegPfl_Elternanleitung_TKPflege	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (TK Pflege)
108350	VerlegPfl_Elternanleitung_AbsaugenNNR	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (Absaugen NNR)
108351	VerlegPfl_Elternanleitung_O2	\N	\N	3	30	\N	\N	Pers. Aspekte - Elternan. (O2 Applikation)
108352	VerlPfl_PersoenlAspekte_Besuchssituation	\N	\N	3	30	\N	\N	Persönliche Aspekte - Besuchssituation
108353	VerlPfl_PersoenlAspekte_Angehoerige_VerwGrad	\N	\N	3	30	\N	\N	Persönliche Aspekte - Angehörige (Verw. Grad)
108354	VerlPfl_PersoenlAspekte_Angehoerige_Telefon	\N	\N	3	30	\N	\N	Persönliche Aspekte - Angehörige (Telefon)
108355	VerlPfl_PersoenlAspekte_Angehoerige_Vorname	\N	\N	3	30	\N	\N	Persönliche Aspekte - Angehörige (Vorname)
108356	VerlPfl_PersoenlAspekte_Angehoerige_Name	\N	\N	3	30	\N	\N	Persönliche Aspekte - Angehörige (Name)
108357	VerlPfl_PersoenlAspekte_Betreuer_Status	\N	\N	3	30	\N	\N	Persönliche Aspekte - Betreuung (Status)
108358	VerlPfl_PersoenlAspekte_Betreuer_Telefon	\N	\N	3	30	\N	\N	Persönliche Aspekte - Betreuung (Telefon)
108359	VerlPfl_PersoenlAspekte_Betreuer_Vorname	\N	\N	3	30	\N	\N	Persönliche Aspekte - Betreuung (Vorname)
108360	VerlPfl_PersoenlAspekte_Betreuer_Name	\N	\N	3	30	\N	\N	Persönliche Aspekte - Betreuung (Name)
108361	VerlPfl_PersoenlAspekte_Besuchszeit	\N	\N	3	30	\N	\N	Persönliche Aspekte - Besuchszeit der Eltern
108362	VerlPfl_PersAspekt_Bemerkung	\N	\N	3	30	\N	\N	Persönliche Aspekte - Bemerkungen
108363	VerlPfl_Beweg_BradenQ	\N	\N	3	30	\N	\N	\N
108364	VerlegPfl_Vital_SpO2	\N	%	6	30	\N	\N	\N
108365	VerlegPfl_Vital_Herzrhythmus	\N	\N	3	30	\N	\N	Atmen, Kreislauf, Körpertemp. - Herzrhythmus
108366	VerlegPfl_Vital_HF	\N	\N	6	30	\N	\N	\N
108367	Score_BernerSchmerzscore_O2_Saettigung	\N	\N	27	102789	\N	\N	\N
108368	Score_BernerSchmerzscore_Atmung	\N	\N	27	102789	\N	\N	\N
108369	Score_Berner_Wert	\N	\N	2	102789	\N	\N	\N
108370	Score_BernerSchmerzscore_Koerperausdruck	\N	\N	27	102789	\N	\N	\N
108371	Score_BernerSchmerzscore_Gesichtsmimik	\N	\N	27	102789	\N	\N	\N
108372	Score_BernerSchmerzscore_Hautfarbe	\N	\N	27	102789	\N	\N	\N
101347	Befinden_Befinden_BabinskiReflexeRe	\N	\N	3	100421	\N	\N	Befinden (Babinski rechts)
101361	IstPflege_Schrittmacher	\N	\N	3	30	\N	\N	Schrittmacher
108373	Score_BernerSchmerzscore_Weinen	\N	\N	27	102789	\N	\N	\N
108374	Score_BernerSchmerzscore_Beruhigung	\N	\N	27	102789	\N	\N	\N
108375	Score_BernerSchmerzscore_Herzfrequenz	\N	\N	27	102789	\N	\N	\N
108376	Score_BernerSchmerzscore_Schlaf	\N	\N	27	102789	\N	\N	\N
108377	Score_BradenQ	\N	\N	1	1	\N	\N	\N
108378	Score_BradenQ_Wert	\N	\N	2	108377	\N	\N	\N
108379	Score_BradenQ_Reibung	\N	\N	27	108377	\N	\N	\N
108380	Score_BradenQ_Mobilitaet	\N	\N	27	108377	\N	\N	\N
108381	Score_BradenQ_Ernaehrung	\N	\N	27	108377	\N	\N	\N
108382	Score_BradenQ_Aktivitaet	\N	\N	27	108377	\N	\N	\N
108383	Score_BradenQ_Gewebe	\N	\N	27	108377	\N	\N	\N
108384	Score_BradenQ_Feuchtigkeit	\N	\N	27	108377	\N	\N	\N
108385	Score_BradenQ_Sensorisch	\N	\N	27	108377	\N	\N	\N
108386	Score_ComfortSkala_Mimik	\N	\N	27	102794	\N	\N	\N
108387	Score_ComfortSkala_Muskeltonus	\N	\N	27	102794	\N	\N	\N
108388	Score_ComfortSkala_Herzfrequenz	\N	\N	27	102794	\N	\N	\N
108389	Score_ComfortSkala_Koerperbewegungen	\N	\N	27	102794	\N	\N	\N
108390	Score_ComfortSkala_MAD	Mittlerer Arterieller Blutdruck	\N	27	102794	\N	\N	\N
108391	Score_ComfortSkala_Wachheit	Wachheit/Aufmerksamkeit	\N	27	102794	\N	\N	\N
108392	Score_ComfortSkala_Wert	\N	\N	2	102794	\N	\N	\N
108393	Score_ComfortSkala_Atmung	\N	\N	27	102794	\N	\N	\N
108394	Score_ComfortSkala_Agitation	\N	\N	27	102794	\N	\N	\N
108395	Score_FLACC	\N	\N	1	1	\N	\N	\N
108396	Score_FLACC_Consolability	\N	\N	27	108395	\N	\N	\N
108397	Score_FLACC_Wert	\N	\N	2	108395	\N	\N	\N
108398	Score_FLACC_Legs	\N	\N	27	108395	\N	\N	\N
108399	Score_FLACC_Cry	\N	\N	27	108395	\N	\N	\N
108400	Score_FLACC_Face	\N	\N	27	108395	\N	\N	\N
108401	Score_FLACC_Activity	\N	\N	27	108395	\N	\N	\N
108402	Score_NPASS_Schmerz	\N	\N	1	1	\N	\N	\N
108403	Score_NPASS_Schmerz_Schwangerschaftwoche	\N	\N	27	108402	\N	\N	\N
108404	Score_NPASS_Schmerz_Extremitaeten	\N	\N	27	108402	\N	\N	\N
108405	Score_NPASS_Schmerz_Vitalzeichen	\N	\N	27	108402	\N	\N	\N
108406	Score_NPASS_Schmerz_Gesicht	\N	\N	27	108402	\N	\N	\N
108407	Score_NPASS_Schmerz_Wert	\N	\N	2	108402	\N	\N	\N
108408	Score_NPASS_Schmerz_Verhalten	\N	\N	27	108402	\N	\N	\N
108409	Score_NPASS_Schmerz_Schreien	\N	\N	27	108402	\N	\N	\N
108410	Score_NPASS_Sedierung	\N	\N	1	1	\N	\N	\N
108411	Score_NPASS_Sedierung_Schwangerschaftwoche	Schwangerschaftswoche	\N	27	108410	\N	\N	\N
108412	Score_NPASS_Sedierung_Extremitaeten	\N	\N	27	108410	\N	\N	\N
108413	Score_NPASS_Sedierung_Vitalzeichen	\N	\N	27	108410	\N	\N	\N
108414	Score_NPASS_Sedierung_Gesicht	\N	\N	27	108410	\N	\N	\N
108415	Score_NPASS_Sedierung_Wert	\N	\N	2	108410	\N	\N	\N
108416	Score_NPASS_Sedierung_Verhalten	\N	\N	27	108410	\N	\N	\N
108417	Score_NPASS_Sedierung_Schreien	\N	\N	27	108410	\N	\N	\N
108418	Score_Petrussa_Haut	\N	\N	27	108233	\N	\N	\N
108419	Score_Petrussa_schamlippe	\N	\N	27	108233	\N	\N	\N
108420	Score_Petrussa_Sohlenfalte	\N	\N	27	108233	\N	\N	\N
108421	Score_Petrussa_Brust	\N	\N	27	108233	\N	\N	\N
108422	Score_Petrussa_Hoden	\N	\N	27	108233	\N	\N	\N
108423	Score_Petrussa_Ohr	\N	\N	27	108233	\N	\N	\N
108424	Score_PRISMIII	\N	\N	1	1	\N	\N	\N
108425	Score_PRISMIII_TotalCO2	\N	\N	27	108424	\N	\N	\N
108426	Score_PRISMIII_Thrombozyten	\N	\N	27	108424	\N	\N	\N
108427	Score_PRISMIII_pCO2	\N	\N	27	108424	\N	\N	\N
108428	Score_PRISMIII_RR	\N	\N	27	108424	\N	\N	\N
108429	Score_PRISMIII_Temp	\N	\N	27	108424	\N	\N	\N
108430	Score_PRISMIII_Pupillenreaktion	\N	\N	27	108424	\N	\N	\N
108431	Score_PRISMIII_PTT	\N	\N	27	108424	\N	\N	\N
108432	Score_PRISMIII_PaO2	\N	\N	27	108424	\N	\N	\N
108433	Score_PRISMIII_Wert	\N	\N	2	108424	\N	\N	\N
108434	Score_PRISMIII_Leukozyten	\N	\N	27	108424	\N	\N	\N
108435	Score_PRISMIII_Herzfrequenz	\N	\N	27	108424	\N	\N	\N
108436	Score_PRISMIII_Bewusstsein	\N	\N	27	108424	\N	\N	\N
108437	Score_PRISMIII_Creatinin	\N	\N	27	108424	\N	\N	\N
108438	Score_PRISMIII_pH	\N	\N	27	108424	\N	\N	\N
108439	Score_PRISMIII_Acidose	\N	\N	27	108424	\N	\N	\N
108440	Score_PRISMIII_Harnstoff	\N	\N	27	108424	\N	\N	\N
108441	Score_SOS	\N	\N	1	1	\N	\N	\N
108442	Score_SOS_Tachykardie	\N	\N	27	108441	\N	\N	\N
108443	Score_SOS_Tachypnoe	\N	\N	27	108441	\N	\N	\N
108444	Score_SOS_Wert	\N	\N	2	108441	\N	\N	\N
108445	Score_SOS_Durchfall	\N	\N	27	108441	\N	\N	\N
108446	Score_SOS_Fieber	\N	\N	27	108441	\N	\N	\N
108447	Score_SOS_Erbrechen	\N	\N	27	108441	\N	\N	\N
108448	Score_SOS_Schwitzen	\N	\N	27	108441	\N	\N	\N
108449	Score_SOS_Halluzination	\N	\N	27	108441	\N	\N	\N
108450	Score_SOS_Motorik	\N	\N	27	108441	\N	\N	\N
108451	Score_SOS_Muskeltonus	\N	\N	27	108441	\N	\N	\N
101423	CO2	\N	\N	6	1	\N	\N	\N
108452	Score_SOS_Tremor	\N	\N	27	108441	\N	\N	\N
108453	Score_SOS_Schlaflosigkeit	\N	\N	27	108441	\N	\N	\N
108454	Score_SOS_Angst	\N	\N	27	108441	\N	\N	\N
108455	Score_SOS_Grimassieren	\N	\N	27	108441	\N	\N	\N
108456	Score_SOS_Schreien	\N	\N	27	108441	\N	\N	\N
108457	Score_SOS_Agitation	\N	\N	27	108441	\N	\N	\N
108458	Score_SOS_PD	\N	\N	1	1	\N	\N	\N
108459	Score_SOS_PD_Aufmerksamkeit	\N	\N	27	108458	\N	\N	\N
108460	Score_SOS_PD_Symptome	\N	\N	27	108458	\N	\N	\N
108461	Score_SOS_PD_Symptomschwankung	\N	\N	27	108458	\N	\N	\N
108462	Score_SOS_PD_Augenkontakt	\N	\N	27	108458	\N	\N	\N
108463	Score_SOS_PD_Wert	\N	\N	2	108458	\N	\N	\N
108464	Score_SOS_PD_Orientierung	\N	\N	27	108458	\N	\N	\N
108465	Score_SOS_PD_Handeln	\N	\N	27	108458	\N	\N	\N
108466	Score_SOS_PD_Sprechen	\N	\N	27	108458	\N	\N	\N
108467	Score_SOS_PD_Schwitzen	\N	\N	27	108458	\N	\N	\N
108468	Score_SOS_PD_Halluzinationen	\N	\N	27	108458	\N	\N	\N
108469	Score_SOS_PD_Motorik	\N	\N	27	108458	\N	\N	\N
108470	Score_SOS_PD_Muskeltonus	\N	\N	27	108458	\N	\N	\N
108471	Score_SOS_PD_Tremor	\N	\N	27	108458	\N	\N	\N
108472	Score_SOS_PD_Schlaflosigkeit	\N	\N	27	108458	\N	\N	\N
108473	Score_SOS_PD_Angst	\N	\N	27	108458	\N	\N	\N
108474	Score_SOS_PD_Grimassieren	\N	\N	27	108458	\N	\N	\N
108475	Score_SOS_PD_Schreien	\N	\N	27	108458	\N	\N	\N
108476	Score_SOS_PD_Agitation	\N	\N	27	108458	\N	\N	\N
108477	Komplexbehandlung_Kind_Datum	\N	\N	5	108283	\N	\N	\N
108478	Pflegekategorie	\N	\N	1	1	\N	\N	\N
108479	Betreuungsverhaeltnis_Neonatologie	Betreuung nach AWMF bei Kindern mit Geb. Gew. unter 1500g 	\N	1	1	\N	\N	\N
108480	Score_BradenQ_Date	\N	\N	5	108377	\N	\N	\N
108481	Score_SOS_PD_Datum	\N	\N	5	108458	\N	\N	\N
108482	Score_SOS_Date	\N	\N	5	108441	\N	\N	\N
108483	Score_Thompson	\N	\N	1	1	\N	\N	\N
108484	Score_Finnigan	\N	\N	1	1	\N	\N	\N
108485	Score_ComfortSkala_Date	\N	\N	5	102794	\N	\N	\N
108486	Score_FLACC_Date	\N	\N	5	108395	\N	\N	\N
108487	Score_Berner_Date	\N	\N	5	102789	\N	\N	\N
108488	Score_NPASS_Schmerz_Date	\N	\N	5	108402	\N	\N	\N
108489	Score_NPASS_Sedierung_Date	\N	\N	5	108410	\N	\N	\N
108490	Score_PRISMIII_Datum	\N	\N	5	108424	\N	\N	\N
108491	Pflegekategorie_Wert	\N	\N	2	108478	\N	\N	\N
101461	Patient_Familienst	Familienstand des Patienten	\N	3	1	\N	\N	\N
101462	Angehoerige1_TelefonMobil	Handy Nummer der Angehörigen des Patienten	\N	3	1	\N	\N	Angehörige (Handy)
101463	Angehoerige1_TelefonArbeit	Berufliche Telefonnummer der Angehörigen des Patienten	\N	3	1	\N	\N	\N
101467	Patient_Beruf	Beruf des Patienten	\N	3	1	\N	\N	\N
101468	Patient_Arbeitgeber	Arbeitgeber des Patienten	\N	3	1	\N	\N	\N
108492	Pflegekategorie_Datum	\N	\N	5	108478	\N	\N	\N
108493	Betreuungsverhaeltnis_Neonatologie_Wert	\N	\N	2	108479	\N	\N	\N
108494	Betreuungsverhaeltnis_Neonatologie_Datum	\N	\N	5	108479	\N	\N	\N
108495	Score_Thompson_Wert	\N	\N	2	108483	\N	\N	\N
108496	Score_Thompson_Date	\N	\N	5	108483	\N	\N	\N
108497	Score_Finnigan_Wert	\N	\N	2	108484	\N	\N	\N
108498	Score_Finnigan_Date	\N	\N	5	108484	\N	\N	\N
108499	Waermesysteme_Waermepaddel_Doku_Temperatur	\N	°C	6	1	\N	\N	\N
108500	Hypothermie_Kuehlmatte_Doku_Temperatur	\N	°C	6	1	\N	\N	\N
108501	Fontanelle_Beurteilung	\N	\N	3	1	\N	\N	\N
108502	Patient_Kopfumfang_bit	Kopfumfang bit cm	cm	6	1	\N	\N	\N
108503	P_NBP_liBein	Nichtinvaiver Blutdruck linkes Bein	mmHg	12	1	\N	\N	\N
108504	P_NBP_reBein	Nichtinvasiver Blutdruck rechtes Bein	mmHg	12	1	\N	\N	\N
108505	P_NBP_liArm	Nichtinvasiver Blutdruck linker Arm	mmHg	12	1	\N	\N	\N
108506	P_NBP_reArm	Nichtinvasiver Blutdruck rechter Arm	mmHg	12	1	\N	\N	\N
108507	NBP1_Messung_Ort1	Ort der Messung NBP1	\N	19	1	\N	\N	\N
108508	tcpO2	transcutan gemessener pO2 Wert.	\N	6	1	\N	\N	\N
108509	SpO2_2	\N	\N	6	1	\N	\N	\N
108510	Atmung_Stimulation	\N	\N	3	1	\N	\N	\N
108511	Messsonden_Wechsel_geplant	\N	\N	5	101683	\N	\N	\N
108512	Dekubitus_Wechsel_geplant	\N	\N	5	100182	\N	\N	\N
108513	Wunddokumentation_Wechsel_geplant	\N	\N	5	100189	\N	\N	\N
108514	Drainagen_Wechsel_geplant	\N	\N	5	100135	\N	\N	\N
108515	Darm_Wechsel_geplant	\N	\N	5	102444	\N	\N	\N
108516	HarnwegeDarm_Wechsel_geplant	\N	\N	5	100134	\N	\N	\N
108517	Enteralesonden_Wechsel_geplant	\N	\N	5	100133	\N	\N	\N
108518	EnteraleSonden_Magensaft_resondiert_ml	\N	ml	6	100165	\N	\N	\N
108519	Atemwege_Wechsel_geplant	\N	\N	5	100132	\N	\N	\N
108520	Zugaenge_Wechsel_geplant	\N	\N	5	100131	\N	\N	\N
108521	IstBesucherregelung	\N	\N	3	20	\N	\N	Besuchsrechte
108522	IstSoziale_Besonderheit	Soziale_Besonderheiten, z.B. Familiensituation	\N	3	20	\N	\N	Soziale / kulturelle Besonderheiten
108523	Score_GCS_Child_Aufnahme	\N	\N	1	30	\N	\N	\N
108524	GCS_Child_Wert_Aufnahme	\N	\N	2	108523	\N	\N	\N
108525	Beatmung_ES_G5_Flow	Parameter im Modus Highflow - ab 08.06.2017	l/min	6	1	\N	\N	\N
108526	Aufnahme_allgemein_stark_beeintraechtigt	\N	\N	2	30	\N	\N	\N
108527	Aufnahme_allgemein_leicht_beeintraechtigt	\N	\N	2	30	\N	\N	\N
108528	Aufnahme_allgemein_stabil	\N	\N	2	30	\N	\N	\N
108529	Elternanleitung	Elternanleitung	\N	21	20	\N	\N	\N
108530	Elternanleitung_Wert	\N	\N	25	108529	\N	\N	\N
108531	Elternanleitung_Wert_Notsituation	\N	\N	3	108530	\N	\N	Elternanleitung - Verhalten Notsituationen (Wert)
108532	Elternanleitung_Wert_Medikamentengabe	\N	\N	3	108530	\N	\N	Elternanleitung - Verabreichen Medikamente (Wert)
108533	Elternanleitung_Wert_VW_BroviacHickman	\N	\N	3	108530	\N	\N	Elternanleitung - VW Broviac/Hickman Kath. (Wert)
108534	Elternanleitung_Wert_Einmalkatheter	\N	\N	3	108530	\N	\N	Elternanleitung - Einmalkatheterisierung (Wert)
108535	Elternanleitung_Wert_APPflege	\N	\N	3	108530	\N	\N	Elternanleitung - AP-Pflege (Wert)
108536	Elternanleitung_Wert_UmgangEPumpe	\N	\N	3	108530	\N	\N	Elternanleitung - Umgang Ernährungspumpe (Wert)
108537	Elternanleitung_Wert_Magensonde	\N	\N	3	108530	\N	\N	Elternanleitung - Pflege Magensinde/PEG (Wert)
108538	Elternanleitung_Wert_ManuelleBeatmung	\N	\N	3	108530	\N	\N	Elternanleitung - Manuelle Beutelbeat. TK (Wert)
108539	Elternanleitung_Wert_AbsaugenTK	\N	\N	3	108530	\N	\N	Elternanleitung - Absaugen TK (Wert)
108540	Elternanleitung_Wert_TKWechsel	\N	\N	3	108530	\N	\N	Elternanleitung - TK Wechsel (Wert)
108541	Elternanleitung_Wert_TKPflege	\N	\N	3	108530	\N	\N	Elternanleitung - TK Pflege (Wert)
108542	Elternanleitung_Wert_Inhalation	\N	\N	3	108530	\N	\N	Elternanleitung - Inhalation (Wert)
108543	Elternanleitung_Wert_AbsaugenNNR	\N	\N	3	108530	\N	\N	Elternanleitung - Absaugen NNR (Wert)
108544	Elternanleitung_Wert_O2App	\N	\N	3	108530	\N	\N	Elternanleitung - O2 Applikation (Wert)
108545	Elternanleitung_Wert_Fuettern	\N	\N	3	108530	\N	\N	Elternanleitung - Stillanleitung/Füttern (Wert)
108546	Elternanleitung_Wert_Sondieren	\N	\N	3	108530	\N	\N	Elternanleitung - Sondieren von Nahrung (Wert)
108547	Elternanleitung_Wert_Hautpflege	\N	\N	3	108530	\N	\N	Elternanleitung - Hautpflege (Wert)
108548	Elternanleitung_Wert_WaschenBaden	\N	\N	3	108530	\N	\N	Elternanleitung - Waschen/Baden (Wert)
108549	Elternanleitung_Wert_Mundpflege	\N	\N	3	108530	\N	\N	Elternanleitung - Mund-/Zahnpflege (Wert)
108550	Elternanleitung_Wert_Wickeln	\N	\N	3	108530	\N	\N	Elternanleitung - Wickeln (Wert)
108551	Komplexbehandlung_Kind_Vorerkrankungen	\N	\N	27	108283	\N	\N	\N
108552	Betreuungsverhaeltnis_Neonatologie_Verhaeltnis	\N	\N	27	108479	\N	\N	\N
108553	Pflegekategorie_Stufe	\N	\N	27	108478	\N	\N	\N
108554	Score_Thompson_Atmung	\N	\N	27	108483	\N	\N	\N
108555	Score_Thompson_Saugreflex	\N	\N	27	108483	\N	\N	\N
108556	Score_Thompson_Greifreflex	\N	\N	27	108483	\N	\N	\N
108557	Score_Thompson_Haltung	\N	\N	27	108483	\N	\N	\N
108558	Score_Thompson_Moro	\N	\N	27	108483	\N	\N	\N
108559	Score_Thompson_Fontanelle	\N	\N	27	108483	\N	\N	\N
108560	Score_Thompson_Krampfanfall	\N	\N	27	108483	\N	\N	\N
108561	Score_Thompson_Muskeltonus	\N	\N	27	108483	\N	\N	\N
108562	Score_Thompson_Bewusstsein	\N	\N	27	108483	\N	\N	\N
108563	B_Aufnahme_Pupillenform_li	Pupillenform links bei Aufnahme	\N	3	30	\N	\N	Aufnahme (Augen - Pupillenform links)
108564	B_Aufnahme_Pupillenform_re	Pupillenform rechts bei Aufnahme	\N	3	30	\N	\N	Aufnahme (Augen - Pupillenform rechts)
108565	B_Aufnahme_Cornealreflex_li	Cornealreflex links bei Aufnahme	\N	3	30	\N	\N	Aufnahme (Augen - Cornealreflex links)
108566	B_Aufnahme_Cornealreflex_re	Cornealreflex rechts bei Aufnahem	\N	3	30	\N	\N	Aufnahme (Augen - Cornealreflex rechts)
108567	B_Aufnahme_Pupillenkontrolle_li	Pupillenkontrolle links bei Aufnahme (Pupillenweite | Pupillenrekation)	\N	3	30	\N	\N	Aufnahme (Augen - Pupillenkontrolle links)
108568	B_Aufnahme_Pupillenkontrolle_re	Pupillenkontrolle rechts bei Aufnahme (Pupillenweite | Pupillenreaktion)	\N	3	30	\N	\N	Aufnahme (Augen - Pupillenkontrolle rechts)
108569	B_VO_Intervention_Stuhl_kont	Stuhlgang Intervention	\N	39	30	\N	\N	\N
108570	Ernaehren_Kostform_Magenrest_verworfen	\N	\N	6	100447	\N	\N	\N
108571	Ernaehren_Kostform_MS_Beschaffenheit	\N	\N	3	100447	\N	\N	Pflegedoku - Kostform (MS Beschaffenheit)
108572	Ernaehren_Kostform_Magenrest_resondiert	\N	\N	6	100447	\N	\N	\N
108573	Bewegen_Bewegungen_LagerungKi_Balken	\N	\N	19	100360	\N	\N	\N
108574	B_VO_Magensonde_kont	Magensonde Intervention	\N	39	30	\N	\N	\N
108575	B_VO_Messintervall_Stuhlgang_kont	Stuhlgang Messintervall	\N	39	30	\N	\N	\N
108576	B_VO_Therapie_Stuhlgang_kont	Stuhltherapie Intervention	\N	39	30	\N	\N	\N
108577	B_VO_Messintervall_UrinStix_kont	Urinstix Messinterval 	\N	39	30	\N	\N	\N
108578	B_VO_Drainagen_Einstellung_kont	Drainagen/Sog Intervention	\N	39	30	\N	\N	\N
108579	B_VO_Fototherapie_kont	Fototherapie Intervention Wert	\N	39	30	\N	\N	\N
108580	B_VO_Fototherapie_Massnahme	Fototherapie Intervention Maßnahme	\N	39	30	\N	\N	\N
108581	B_VO_Magenrestersatz_kont	Magenrestersatz Intervention	\N	39	30	\N	\N	\N
108582	B_VO_Nahrungsersatz_kont	Nahrungsersatz Intervention	\N	39	30	\N	\N	\N
108583	B_VO_AP_Ersatz_kont	AP_Ersatz Intervention	\N	39	30	\N	\N	\N
108584	B_VO_Intervention_sonstige_kont	Sonstige Intervention	\N	39	30	\N	\N	\N
108585	B_Grenzwert_HF_kont	Herzfrequenz Grenzwert	\N	39	30	\N	\N	\N
108586	B_VO_Messintervall_HF_kont	Herzfrequenz Messintervall	\N	39	30	\N	\N	\N
108587	B_Grenzwert_Respiration_kont	Respiration Grenzwert	\N	39	30	\N	\N	\N
108588	B_VO_Messintervall_Respiration_kont	Respiration Messintervall	\N	39	30	\N	\N	\N
108589	B_ZW_Respiration_kont	Respiration Zielwert	\N	39	30	\N	\N	\N
108590	B_VO_Messintervall_SpO2_kont	SpO2 Messintervall	\N	39	30	\N	\N	\N
108591	B_GW_SpO2_kont	SpO2 Grenzwert	\N	39	30	\N	\N	\N
108592	B_VO_Messintervall_tcpO2_kont	tcpO2 Messintervall	\N	39	30	\N	\N	\N
101592	VerlPfl_Beweg_Handicaps2	\N	\N	3	30	\N	\N	Bewegen - Handicaps
101593	IstPflege_Bewegen_Handicaps2	\N	\N	3	30	\N	\N	Bewegung (Handicaps)
108593	B_ZW_tcpO2_kont	tcpO2 Zielwert	\N	39	30	\N	\N	\N
108594	B_ZW_tcpCO2_kont	tcpCO2 Zielwert 	\N	39	30	\N	\N	\N
108595	B_GW_tcpO2	tcpO2 Grenzwert	\N	39	30	\N	\N	\N
108596	B_GW_tcpCO2_kont	tcpCO2 Grenzwert	\N	39	30	\N	\N	\N
108598	B_GW_etCO2_kont	etCO2 Grenzwert	\N	39	30	\N	\N	\N
108599	B_VO_Messintervall_etCO2_kont	etCO2 Messintervall	\N	39	30	\N	\N	\N
108600	B_ZW_etCO2_kont	etCO2 Zielwert 	\N	39	30	\N	\N	\N
108601	B_GW_ABP_kont	ABP Grenzwert	\N	39	30	\N	\N	\N
108602	B_VO_Messintervall_ABP_kont	ABP Messintervall	\N	39	30	\N	\N	\N
108603	B_ZW_ABP_kont	ABP Zielwert 	\N	39	30	\N	\N	\N
108604	B_GW_NBP_kont	NBP Grenzwert	\N	39	30	\N	\N	\N
108605	B_VO_Messintervall_NBP_kont	NBP Messintervall	\N	39	30	\N	\N	\N
108606	B_ZW_NBP_kont	NBP Zielwert 	\N	39	30	\N	\N	\N
108607	B_GW_PAP_kont	PAP Grenzwert	\N	39	30	\N	\N	\N
108608	B_VO_Messintervall_PAP_kont	PAP Messintervall 	\N	39	30	\N	\N	\N
108609	B_ZW_PAP_kont	PAP Zielwert 	\N	39	30	\N	\N	\N
108610	B_GW_LAP_kont	LAP Grenzwert	\N	39	30	\N	\N	\N
108611	B_VO_Messintervall_LAP_kont	LAP Messintervall 	\N	39	30	\N	\N	\N
108612	B_ZW_LAP_kont	LAP Zielwert 	\N	39	30	\N	\N	\N
108613	B_GW_Temp_kont	Temperatur Grenzwert 	\N	39	30	\N	\N	\N
108614	B_VO_Messintervall_Temp_kont	Temperatur Messintervall	\N	39	30	\N	\N	\N
108615	B_GW_Gewicht_kont	Gewicht Grenzwert	\N	39	30	\N	\N	\N
108616	B_VO_Messintervall_Gewicht_kont	Gewicht Messintervall	\N	39	30	\N	\N	\N
108617	B_ZW_GewichtKg_kont	Gewicht Zielwert	\N	39	30	\N	\N	\N
108618	B_GW_Bilanz_kont	Bilanz Grenzwert	\N	39	30	\N	\N	\N
108619	B_GW_ZVD_kont	ZVD Grenzwert	\N	39	30	\N	\N	\N
108620	B_GW_ICP_kont	ICP Grenzwert	\N	39	30	\N	\N	\N
108621	B_VO_Messintervall_Scoreerhebung_kont	Scoreerhebung Messintervall	\N	39	30	\N	\N	\N
108622	B_VO_Messintervall_Sonst_kont	Sonstige Messintervall	\N	39	30	\N	\N	\N
108623	P_Therapiebetten_Doku_Lifetherm_ES_Strahler	\N	°C	6	1	\N	\N	\N
108624	P_Therapiebetten_VO_Lifetherm_Temperatur	\N	°C	6	1	\N	\N	\N
108625	P_Therapiebetten_Doku_Lifetherm_ES_Neigung	Einstellung des Neigungswinkels	\N	6	1	\N	\N	\N
108626	P_Therapiebetten_VO_Lifetherm_Neigung	Verordnung des Neigungswinkels	\N	6	1	\N	\N	\N
108627	P_Temperaturregulation_Variotherm_VO_Temp	\N	\N	6	1	\N	\N	\N
108628	P_Temperaturregulation_Variotherm_Doku_Temp	\N	\N	6	1	\N	\N	\N
101609	Score_Braden	Score-Variablen zur Erfassung des Braden-Scores zu einem beliebigen Zeitpunkt in der Zeitachse	\N	1	1	\N	\N	\N
101610	Score_Braden_Wert	\N	\N	2	101609	\N	\N	\N
108629	P_Therapiebetten_VO_Lifetherm_Strahler	\N	%	6	1	\N	\N	\N
108630	P_Therapiebetten_Doku_Lifetherm_ES_Temperatur	\N	\N	6	1	\N	\N	\N
108631	Waermesysteme_BairHugger_VO_Geblaese	\N	Stufe	3	1	\N	\N	\N
108632	Waermesysteme_BairHugger_VO_Temperatur	Liste	° C	3	1	\N	\N	\N
108633	P_Waermesysteme_BarkeyWaermepaddels_VO_Temperatur	\N	\N	6	1	\N	\N	\N
108634	P_Waermesysteme_BarkeyWaermepaddels_Doku_Temp	\N	\N	6	1	\N	\N	\N
108635	P_Waermesysteme_InfantWarmer_Doku_Power	\N	%	6	1	\N	\N	\N
108636	P_Waermesysteme_InfantWarmer_VO_Power	\N	%	6	1	\N	\N	\N
108637	P_Waermesysteme_InfantWarmer_Doku_SkinTemp	\N	°C	6	1	\N	\N	\N
108638	P_Waermesysteme_InfantWarmer_VO_SkinTemp	\N	°C	6	1	\N	\N	\N
108639	P_Temperaturregulation_Blankettrol_Doku_Temp	\N	\N	6	1	\N	\N	\N
108640	P_Temperaturregulation_Blankettrol_VO_Temp	\N	\N	6	1	\N	\N	\N
108641	Score_Finnegan	\N	\N	1	1	\N	\N	\N
108642	Score_Finnegan_Date	\N	\N	5	108641	\N	\N	\N
108643	Score_Finnegan_Wert	\N	\N	2	108641	\N	\N	\N
108644	Score_Finnegan_Stuhl	\N	\N	27	108641	\N	\N	\N
108645	Score_Finnegan_Trinken	\N	\N	27	108641	\N	\N	\N
108646	Score_Finnegan_Erbrechen	\N	\N	27	108641	\N	\N	\N
108647	Score_Finnegan_Atmen	\N	\N	27	108641	\N	\N	\N
108648	Score_Finnegan_Saugen	\N	\N	27	108641	\N	\N	\N
108649	Score_Finnegan_Nase	\N	\N	27	108641	\N	\N	\N
108650	Score_Finnegan_Niesen	\N	\N	27	108641	\N	\N	\N
108651	Score_Finnegan_Gaehnen	\N	\N	27	108641	\N	\N	\N
108652	Score_Finnegan_MarmorHaut	\N	\N	27	108641	\N	\N	\N
108653	Score_Finnegan_Schwitzen	\N	\N	27	108641	\N	\N	\N
108654	Score_Finnegan_Fieber	\N	\N	27	108641	\N	\N	\N
108655	Score_Finnegan_Haut	\N	\N	27	108641	\N	\N	\N
108656	Score_Finnegan_Krampfanfall	\N	\N	27	108641	\N	\N	\N
108657	Score_Finnegan_TremorStoerung	\N	\N	27	108641	\N	\N	\N
108658	Score_Finnegan_Muskeltonus	\N	\N	27	108641	\N	\N	\N
108659	Score_Finnegan_Moro	\N	\N	27	108641	\N	\N	\N
108660	Score_Finnegan_TremorRuhe	\N	\N	27	108641	\N	\N	\N
108661	Score_Finnegan_Schreien	\N	\N	27	108641	\N	\N	\N
108662	Score_Finnegan_Schlafen	\N	\N	27	108641	\N	\N	\N
108663	Score_Finnegan_Myokloni	\N	\N	27	108641	\N	\N	\N
108664	P_Waermesysteme_FisherPaykel_VO_Prozent	\N	%	6	1	\N	\N	\N
101653	TabelleVerlaufAerzte	\N	\N	1	30	\N	\N	Tabelle Verlauf Ärzte
101655	TabelleVerlaufAerzte_Bereich	\N	\N	3	101653	\N	\N	Arzt - Verlauf (Bereich)
101656	TabelleVerlaufAerzte_Gruppe	\N	\N	3	101653	\N	\N	Arzt - Verlauf (Gruppe)
101657	TabelleVerlaufAerzte_Dokumentation	\N	\N	3	101653	\N	\N	Arzt - Verlauf (Dokumentation)
101658	TabelleVerlaufAerzte_VeratwMitarbeiter	\N	\N	3	101653	\N	\N	Arzt - Verlauf (Durchgeführt von)
101659	TabelleVerlaufPflege	\N	\N	1	30	\N	\N	\N
101661	TabelleVerlaufPflege_Bereich	\N	\N	3	101659	\N	\N	Verlaufsdoku Pflege (Bereich)
101662	TabelleVerlaufPflege_Gruppe	\N	\N	3	101659	\N	\N	Verlaufsdoku Pflege (Gruppe)
101663	TabelleVerlaufPflege_Dokumentation	\N	\N	3	101659	\N	\N	Verlaufsdoku Pflege (Dokumentation)
101664	TabelleVerlaufPflege_VerantwMitarbeiter	\N	\N	3	101659	\N	\N	Verlaufsdoku Pflege (Mitarbeiter)
101687	Messsonden_lage	\N	\N	3	101683	\N	\N	Messsonden (Lage)
101688	Messsonden_typ	\N	\N	3	101683	\N	\N	Messsonden (Typ)
108665	P_Waermesysteme_FisherPaykel_Doku_Prozent	\N	\N	6	1	\N	\N	\N
108666	P_Intervention_Balken	Dokumentation von Interventionen (Operationen, andere Maßnahmen)	\N	19	1	\N	\N	\N
108667	F_Untersuchung_Beatmung	\N	\N	3	105203	\N	\N	\N
108668	F_Untersuchung_CaseManagement	\N	\N	3	105203	\N	\N	Befunddokumentation (Case Management)
108669	F_Untersuchung_Hautkolorit	\N	\N	3	105203	\N	\N	Befunddokumentation (Hautkolorit)
108670	F_Untersuchung_Allgemeinzustand	\N	\N	3	105203	\N	\N	Befunddokumentation (Allgemeinzustand)
108671	F_Untersuchung_PreviousDataSet_Allgemeinzustand	\N	\N	3	105212	\N	\N	\N
108672	F_Untersuchung_PreviousDataSet_Beatmung	\N	\N	3	105212	\N	\N	\N
108673	F_Untersuchung_PreviousDataSet_CaseManagement	\N	\N	3	105212	\N	\N	\N
108674	F_Untersuchung_PreviousDataSet_Hautkolorit	\N	\N	3	105212	\N	\N	\N
108675	P_Antikoerper_Mutter	\N	\N	3	1	\N	\N	Mutter (Antikörper)
108676	P_Spezifitaet_Mutter	Blutgruppenspezifität der Mutter	\N	3	1	\N	\N	Mutter (Blutgruppenspezifität)
101690	Messsonden_Pflege	\N	\N	3	101684	\N	\N	Messsonden (Pflege)
101691	Messsonden_ESS	\N	\N	3	101684	\N	\N	Messsonden (Beobachtung)
108677	B_Aufnahme_Neutrabs	Neutrophile Granulozyten absolut	%	3	30	\N	\N	Aufnahme (NEUTRabs)
108678	B_Aufnahme_CRP	\N	mg/l	3	30	\N	\N	Aufnahme (CRP)
108679	B_Aufnahme_Leukozyten	\N	\N	3	30	\N	\N	Aufnahme (Leukozyten)
108680	Score_NACA	\N	\N	1	1	\N	\N	\N
108681	Score_NACA_Date	\N	\N	5	108680	\N	\N	\N
108682	Score_NACA_Naca	\N	\N	27	108680	\N	\N	\N
108683	Score_NACA_Wert	\N	\N	2	108680	\N	\N	\N
108684	Score_ISS	\N	\N	1	1	\N	\N	\N
108685	Score_ISS_Date	\N	\N	5	108684	\N	\N	\N
108686	Score_ISS_Wert	\N	\N	2	108684	\N	\N	\N
108687	Score_ISS_Wirbelsaeule	\N	\N	27	108684	\N	\N	\N
108688	Score_ISS_Gesicht	\N	\N	27	108684	\N	\N	\N
108689	Score_ISS_Thorax	\N	\N	27	108684	\N	\N	\N
108690	Score_ISS_Cerebrum	\N	\N	27	108684	\N	\N	\N
108691	Score_ISS_Haut	\N	\N	27	108684	\N	\N	\N
108692	Score_ISS_Abdomen	\N	\N	27	108684	\N	\N	\N
108693	Score_ISS_Bewegungsapparat	\N	\N	27	108684	\N	\N	\N
108694	B_Aufnahme_Atmung_HighFlow	\N	\N	2	30	\N	\N	\N
108695	B_Aufnahme_Neurologie_Reflexe_unauffaellig	\N	\N	2	30	\N	\N	\N
108696	B_Aufnahme_Trauma_Kopf	\N	\N	2	30	\N	\N	\N
108697	B_Aufnahme_Trauma_Hals	\N	\N	2	30	\N	\N	\N
108698	B_Aufnahme_Trauma_Thorax	\N	\N	2	30	\N	\N	\N
108699	B_Aufnahme_Trauma_Abdomen	\N	\N	2	30	\N	\N	\N
108700	B_Aufnahme_Trauma_Becken	\N	\N	2	30	\N	\N	\N
108701	B_Aufnahme_Trauma_Extremitaeten	\N	\N	2	30	\N	\N	\N
108702	B_Aufnahme_HNO_auffaellig	\N	\N	2	30	\N	\N	\N
108703	B_Aufnahme_HNO_unauffaellig	\N	\N	2	30	\N	\N	\N
108704	B_Aufnahme_HNO_auffaellig_beschr	\N	\N	3	30	\N	\N	Aufnahme (HNO - auffällig)
108705	B_Aufnahme_BatteredChild_Beschreibung	\N	\N	3	30	\N	\N	Aufnahme (Hinweise Battered Child - Beschreibung)
108706	B_Aufnahme_Battered_Child_ja	\N	\N	2	30	\N	\N	\N
108707	B_Aufnahme_Battered_Child_nein	\N	\N	2	30	\N	\N	\N
108708	B_Aufnahme_Neurologie_Hirnnerven_unauffaellig	\N	\N	2	30	\N	\N	\N
108709	B_Aufnahme_Neurologie_GrobeKraft_unauffaellig	\N	\N	2	30	\N	\N	\N
108710	B_Aufnahme_Neurologie_Sensibilitaet_unauffaellig	\N	\N	2	30	\N	\N	\N
108711	B_Aufnahme_Bewusstsein_ungetruebt	\N	\N	2	30	\N	\N	\N
108712	B_Aufnahme_Bewusstsein_benommen	\N	\N	2	30	\N	\N	\N
104128	Behandlung_DIVI_VerlegungNach	\N	\N	3	30	\N	\N	\N
101766	Betreuer_Vorname	\N	\N	3	1	\N	\N	Betreuer (Vorname)
101767	Betreuer_Strasse	\N	\N	3	1	\N	\N	Betreuer (Straße)
101768	Betreuer_PLZ	\N	\N	3	1	\N	\N	Betreuer (PLZ)
101769	Betreuer_Ort	\N	\N	3	1	\N	\N	Betreuer (Ort)
101771	Betreuer_TelefonMobil	\N	\N	3	1	\N	\N	\N
101774	Patient_Versicherung	\N	\N	3	1	\N	\N	\N
101775	Patient_Versicherungsnummer	\N	\N	3	1	\N	\N	\N
108713	B_Aufnahme_Bewusstsein_somnolent	\N	\N	2	30	\N	\N	\N
108714	B_Aufnahme_Bewusstsein_soporoes	\N	\N	2	30	\N	\N	\N
108715	B_Aufnahme_Bewusstsein_comatoes	\N	\N	2	30	\N	\N	\N
108716	P_CSF_MS_LiquoGuard_Liquorfluss	automatisch berechnet aus Pset ml/h 	\N	6	1	\N	\N	\N
108717	P_CSF_MS_LiqouGuard_Pcsf	\N	mmHg	6	1	\N	\N	\N
108718	P_CSF_MS_LiqouGuard_ICP	\N	mmHg	6	1	\N	\N	\N
108719	P_CSF_ES_LiquoGuard_Pset	\N	mmHg	6	1	\N	\N	\N
108720	P_CSF_Doku_Balken	\N	\N	26	1	\N	\N	\N
108721	P_Beatmung_MS_AnaConDa_inspGaskonz	\N	%Fi	6	1	\N	\N	\N
108722	P_Beatmung_MS_AnaConDa_etGaskonz	\N	% Fet	6	1	\N	\N	\N
108723	P_Beatmung_MS_AnaConDa_AF	\N	1/min	6	1	\N	\N	\N
108724	P_Beatmung_MS_AnaConDa_etCo2	\N	mmHg	6	1	\N	\N	\N
108725	P_Beatmung_Doku_AnaConDa_System	\N	\N	3	1	\N	\N	\N
108726	P_Beatmung_Doku_AnaConDa_volAnaesthetika	Listenauswahl	\N	19	1	\N	\N	\N
108727	P_Impella_Impella_MS_LVDruck	\N	mmHg	12	1	\N	\N	\N
108728	P_Impella_Impella_ES_Leistungsstufe	\N	\N	3	1	\N	\N	\N
108729	P_Impella_Impella_MS_Flow	\N	l/min	6	1	\N	\N	\N
108730	P_Impella_Impella_MS_PurgeFlow	\N	ml/h	6	1	\N	\N	\N
108731	P_Impella_Impella_Spuelloesung	\N	\N	3	1	\N	\N	\N
108732	P_Impella_Impella_Doku_Verschlusssystem	Liste Ja Nein	\N	3	1	\N	\N	\N
108733	P_Impella_Impella_Doku_Ort	Liste Gefäßauswahl	\N	3	1	\N	\N	\N
108734	P_Impella_Impella_Doku_Zugang	\N	\N	3	1	\N	\N	\N
108735	P_Impella_Doku_Balken	\N	\N	26	1	\N	\N	\N
108736	B_Aufnahme_Neurologie_Spontanmotorik_seitengleich	\N	\N	2	30	\N	\N	\N
108737	B_Aufnahme_Neurologie_Tonus_altersgemaess	\N	\N	2	30	\N	\N	\N
108738	P_Celestangabe	\N	\N	1	1	\N	\N	\N
101777	Angehoerige1_Vorname	\N	\N	3	1	\N	\N	Angehörige (Vorname)
101785	Betreuer_Land	\N	\N	3	1	\N	\N	\N
101791	Betreuer_Status	\N	\N	3	1	\N	\N	\N
101792	Angehoerige1_Verwandschaftsgrad	\N	\N	3	1	\N	\N	Angehörige (Verwandschaftsgrad)
108739	P_Celestangabe_Datum	\N	\N	5	108738	\N	\N	\N
108740	B_IstPflege_SozVersorgung_Familie	\N	\N	2	30	\N	\N	\N
108741	B_IstPflege_SozVersorgung_Pflegefamilie	\N	\N	2	30	\N	\N	\N
108742	P_Temperatur_DeltaT	Delta Temperatur zentral/Temperatur peripher	°C	6	1	\N	\N	\N
108743	Ramsay_Verlauf_Sedierung	\N	\N	27	107969	\N	\N	\N
109743	TabelleVerordnungMischbeutel	\N	\N	1	30	\N	\N	\N
109744	TabelleVerordnungMischbeutel_Dokumentation	\N	\N	3	109743	\N	\N	\N
109745	TabelleVerordnungMischbeutel_Bereich	\N	\N	3	109743	\N	\N	\N
109746	TabelleVerordnungMischbeutel_Gruppe	\N	\N	3	109743	\N	\N	\N
109747	TabelleVerordnungMischbeutel_VeantwMA	Verantwortlicher Mitarbeiter	\N	3	109743	\N	\N	\N
109748	TabelleVerordnungMischbeutel_Datum	\N	\N	5	109743	\N	\N	\N
109749	Score_ComfortB_beatmet_Skala	\N	\N	1	1	\N	\N	\N
109750	Score_ComfortB_beatmet_Skala_Agitation	\N	\N	27	109749	\N	\N	\N
109751	Score_ComfortB_beatmet_Skala_Beatmungstoleranz	\N	\N	27	109749	\N	\N	\N
109752	Score_ComfortB_beatmet_Skala_Koerperbewegung	\N	\N	27	109749	\N	\N	\N
109753	Score_ComfortB_beatmet_Skala_Mimik	\N	\N	27	109749	\N	\N	\N
109754	Score_ComfortB_beatmet_Skala_Muskeltonus	\N	\N	27	109749	\N	\N	\N
109755	Score_ComfortB_beatmet_Skala_Wachheit	\N	\N	27	109749	\N	\N	\N
109756	Score_ComfortB_beatmet_Skala_Weinen	\N	\N	27	109749	\N	\N	\N
109757	Score_ComfortB_beatmet_Skala_Date	\N	\N	5	109749	\N	\N	\N
109758	Score_ComfortB_beatmet_Skala_Wert	\N	\N	2	109749	\N	\N	\N
110743	Score_ComfortB_spontan_Skala	\N	\N	1	1	\N	\N	\N
110744	Score_ComfortB_spontan_Skala_Agitation	\N	\N	27	110743	\N	\N	\N
110745	Score_ComfortB_spontan_Skala_Weinen	\N	\N	27	110743	\N	\N	\N
110746	Score_ComfortB_spontan_Skala_Koerperbewegungen	\N	\N	27	110743	\N	\N	\N
110747	Score_ComfortB_spontan_Skala_Mimik	\N	\N	27	110743	\N	\N	\N
110748	Score_ComfortB_spontan_Skala_Muskeltonus	\N	\N	27	110743	\N	\N	\N
110749	Score_ComfortB_spontan_Skala_Wachheit	\N	\N	27	110743	\N	\N	\N
110750	Score_ComfortB_spontan_Skala_Date	\N	\N	5	110743	\N	\N	\N
110751	Score_ComfortB_spontan_Skala_Wert	\N	\N	2	110743	\N	\N	\N
110752	P_Therapiebetten_VO_DraegerBabytherm_Strahler	\N	%	6	1	\N	\N	\N
101845	Behandlungsstrategie_ZielvorgabenBesonder_Freitext	\N	\N	3	30	\N	\N	Besonderheiten
110753	P_Therapiebetten_VO_DraegerBabytherm_Temperatur	\N	°C	6	1	\N	\N	\N
110754	P_Therapiebetten_Doku_DraegerBabytherm_ES_Temp	\N	\N	6	1	\N	\N	\N
110755	P_Therapiebetten_Doku_DraegerBabytherm_ES_Strahler	\N	\N	6	1	\N	\N	\N
110756	Ernaehren_Kostform_Wert_Magenrest_insgesamt	\N	\N	6	100447	\N	\N	\N
110757	F_Therapieeinschraenkung	\N	\N	3	20	\N	\N	Therapieeinschränkung
110758	P_Beatmung_ES_Anfeuchtung_Temperatur	\N	\N	6	1	\N	\N	\N
110759	B_VO_Messintervall_Koerperlaenge_kont	Körperlänge Messintervall 	\N	39	30	\N	\N	\N
110760	VO_Messintervall_UmfangKopf_kont	Kopfumfang Messintervall 	\N	39	30	\N	\N	\N
110761	B_VO_Messintervall_tcpCO2_kont	tcpCO2 Messintervall	\N	39	30	\N	\N	\N
110762	Arztbriefunterstuetzung_InstruktionRueckkehr	\N	\N	3	106725	\N	\N	\N
110763	Arztbriefunterstuetzung_InstruktionNachkontrolle	\N	\N	3	106725	\N	\N	\N
110764	B_Proceder_Instruktion_Rueckkehr	\N	\N	3	30	\N	\N	\N
110765	B_Proceder_Instruktion_Nachkontrolle	\N	\N	3	30	\N	\N	\N
110766	Sicherheit_Wechsel_Ambubeutel	\N	\N	3	100494	\N	\N	Pflegedoku - Wechsel (AMBU Beutel)
110767	F_Reakarte_Dokumentationszeitpunkt	\N	\N	5	20	\N	\N	\N
110768	F_Reakarte_VerantwortlicherArzt	Die/Der verantwortliche Arzt/Ärztin der/die die Reakarte freigibt.	\N	3	20	\N	\N	\N
110769	Aufnahme_Geburtslage_andere	\N	\N	2	1	\N	\N	\N
110770	F_Reakarte_VerantwortlichePflegekraft	Der/Die verantwortliche Pflegekraft der/die die Reakarte freigibt	\N	3	20	\N	\N	\N
110771	F_Reakarte_VerantwortlicherMitarbeiter	\N	\N	3	20	\N	\N	\N
110772	P_NEV_HD_MS_5008onl_Rest_Zeit_min	\N	min	6	1	\N	\N	\N
110773	P_NEV_HD_MS_5008onl_SubBolusVolKum	\N	\N	6	1	\N	\N	\N
110774	P_NEV_HD_MS_5008onl_SubVolKum	\N	\N	6	1	\N	\N	\N
110775	P_NEV_HD_MS_5008onl_IsoUFVolKum	\N	\N	6	1	\N	\N	\N
110776	P_NEV_HD_MS_5008onl_BlutvolKum	\N	\N	6	1	\N	\N	\N
110778	P_NEV_HD_MS_5008onl_Leitfaehigkeit	\N	\N	6	1	\N	\N	\N
110779	P_NEV_HD_MS_5008onl_SollNa	\N	\N	6	1	\N	\N	\N
110780	P_NEV_HD_MS_5008onl_TMP	\N	\N	6	1	\N	\N	\N
110781	P_NEV_HD_MS_5008onl_venDruck	\N	\N	6	1	\N	\N	\N
110782	P_NEV_HD_MS_5008onl_artDruck	\N	\N	6	1	\N	\N	\N
110783	P_NEV_HD_MS_5008_onl_Ultrafiltratmengekum_ml	\N	\N	6	1	\N	\N	\N
110784	P_NEV_HD_ES_5008onl_Fluss	\N	ml/min	6	1	\N	\N	\N
110785	P_NEV_HD_ES_5008onl_Temperatur	\N	\N	6	1	\N	\N	\N
110786	P_NEV_HD_ES_5008onl_Bicarbonat	\N	\N	6	1	\N	\N	\N
110787	P_NEV_HD_ES_5008onl_SollNa	\N	mmol/l	6	1	\N	\N	\N
110788	P_NEV_HD_ES_5008onl_StartNa	\N	mmol/l	6	1	\N	\N	\N
110789	P_NEV_HD_ES_5008onl_BasisNa	\N	\N	6	1	\N	\N	\N
110790	P_NEV_HD_ES_5008onl_NaProfil	Auswahl von nummerisch einzugebenden Profilen	\N	6	1	\N	\N	\N
110791	P_NEV_HD_ES_5008onl_UFProfil	\N	\N	6	1	\N	\N	\N
110792	P_NEV_HD_ES_5008onl_Substituatbolus	\N	\N	6	1	\N	\N	\N
110793	P_NEV_HD_ES_5008onl_Substituatrate	\N	\N	6	1	\N	\N	\N
110794	P_NEV_HD_ES_5008onl_Substituat	\N	\N	6	1	\N	\N	\N
110795	P_NEV_HD_ES_5008onl_BlutflussSNPumpe	\N	\N	6	1	\N	\N	\N
110797	P_NEV_HD_ES_5008onl_IsoUFRate	\N	\N	6	1	\N	\N	\N
110798	P_NEV_HD_ES_5008onl_IsoUFZeit	\N	\N	3	1	\N	\N	\N
110799	P_NEV_HD_ES_5008onl_IsoUFZiel	\N	\N	6	1	\N	\N	\N
110800	P_NEV_HD_ES_5008onl_UFRate	\N	\N	6	1	\N	\N	\N
110801	P_NEV_HD_ES_5008onl_UFZiel	\N	\N	6	1	\N	\N	\N
110802	P_NEV_HD_ES_5008onl_Dialyse_Zeit	\N	\N	3	1	\N	\N	\N
110803	NEV_HD_ES_4008onl_IsoUFRate	\N	\N	6	1	\N	\N	\N
110804	P_NEV_HD_VO_5008onl_Fluss	\N	\N	6	1	\N	\N	\N
110805	P_NEV_HD_VO_5008onl_Temperatur	\N	\N	6	1	\N	\N	\N
110806	P_NEV_HD_VO_5008onl_Bicarbonat	\N	\N	6	1	\N	\N	\N
110807	P_NEV_HD_VO_5008onl_SollNa	\N	\N	6	1	\N	\N	\N
110808	P_NEV_HD_VO_5008onl_StartNa	\N	\N	6	1	\N	\N	\N
110809	P_NEV_HD_VO_5008onl_NaProfil	\N	\N	6	1	\N	\N	\N
110810	P_NEV_HD_VO_5008onl_UFProfil	\N	\N	6	1	\N	\N	\N
110811	P_NEV_HD_VO_5008onl_Substituatbolus	\N	\N	6	1	\N	\N	\N
110812	P_NEV_HD_VO_5008onl_Substituatrate	\N	\N	6	1	\N	\N	\N
110813	P_NEV_HD_VO_5008onl_BlutflussSNPumpe	\N	\N	6	1	\N	\N	\N
110814	P_NEV_HD_VO_5008onl_BlutflussMax	\N	\N	6	1	\N	\N	\N
110815	P_NEV_HD_VO_5008onl_IsoUFZiel	\N	\N	6	1	\N	\N	\N
110816	P_NEV_HD_VO_5008onl_IsoUFZeit	\N	\N	3	1	\N	\N	\N
110817	P_NEV_HD_VO_5008onl_UFZiel	\N	\N	6	1	\N	\N	\N
110818	P_NEV_HD_VO_5008onl_Dialyse_Zeit	\N	\N	3	1	\N	\N	\N
110796	P_NEV_HD_ES_5008onl_Blutfluss	\N	mL/min	6	1	\N	\N	\N
110819	Aufnahme_Genitale_Hoden_deszendiert	\N	\N	2	30	\N	\N	\N
110820	P_Beatmung_ES_C3_PEEP_CPAP	\N	\N	6	1	\N	\N	\N
110821	P_Beatmung_ES_C3_ProzentVol	\N	\N	6	1	\N	\N	\N
110822	P_Beatmung_ES_C3_Pkontrol	\N	\N	6	1	\N	\N	\N
110823	P_Beatmung_ES_C3_Phoch	\N	\N	6	1	\N	\N	\N
110824	P_Beatmung_ES_C3_Pmax	\N	\N	6	1	\N	\N	\N
110826	P_Beatmung_ES_C3_Freq	\N	\N	6	1	\N	\N	\N
110827	Beatmung_ES_C3_F_SIMV	\N	\N	3	1	\N	\N	\N
110828	P_Beatmung_ES_C3_IEVerhaeltnis	\N	\N	3	1	\N	\N	\N
110829	P_Beatmung_ES_C3_Drucktrigger	\N	\N	6	1	\N	\N	\N
110830	P_Beatmung_ES_C3_Apnoezeit_Backup	\N	\N	6	1	\N	\N	\N
110831	P_Beatmung_ES_C3_IEVerhaeltnis_Backup	\N	\N	3	1	\N	\N	\N
110832	P_Beatmung_Atemgas	Gabe von Atemgasen	\N	19	1	\N	\N	\N
110833	P_Beatmung_ES_3100A_BiasFlow	Eingestellter Basisfluss im Beatmungssystem	l/min	6	1	\N	\N	\N
110834	P_Beatmung_ES_3100A_Frequenz	Eingestellte Oszillationsfrequenz	Hz	6	1	\N	\N	\N
110835	P_Beatmung_ES_3100A_Inspirationszeit	Prozentualer Anteil der Insp.Zeit bezogen auf den gesamten Atemzyklus	%	6	1	\N	\N	\N
110836	P_Beatmung_ES_3100A_Leistung	Prozentuale Kolbenauslenkung	%	6	1	\N	\N	\N
110837	P_Beatmung_ES_3100A_Mitteldruck	Eingestellter mittlerer Atemwegsdruck	cmH2O	6	1	\N	\N	\N
110838	P_Beatmung_ES_3100A_O2Konzentration	O2 Konzentration des Gasgemisches	\N	6	1	\N	\N	\N
110839	P_Beatmung_MS_3100A_Amplitude	gemessene Druckamplitude	cmH2O	6	1	\N	\N	\N
110840	P_Beatmung_MS_3100A_O2Konzentration	Gemessene O2 Konzentration	\N	6	1	\N	\N	\N
110841	P_Beatmung_ES_CoughAssist_Verschreibung	\N	\N	3	1	\N	\N	\N
110842	P_Beatmung_ES_CoughAssist_CoughTrak	Ein/Aus	\N	3	1	\N	\N	\N
110843	P_Beatmung_ES_CoughAssist_Einatmungsdruck	\N	cmH2O	6	1	\N	\N	\N
110844	P_Beatmung_ES_CoughAssist_Einatmungsflow	\N	\N	3	1	\N	\N	\N
110845	P_Beatmung_ES_CoughAssist_Einatmungszeit	\N	sec	6	1	\N	\N	\N
110846	P_Beatmung_ES_CoughAssist_Ausatemdruck	\N	cmH2O	6	1	\N	\N	\N
110847	P_Beatmung_ES_CoughAssist_Ausatemzeit	\N	sec	6	1	\N	\N	\N
110848	P_Beatmung_ES_CoughAssist_Pausendauer	\N	sec	6	1	\N	\N	\N
110849	P_Beatmung_ES_CoughAssist_Oszillation	\N	\N	3	1	\N	\N	\N
110850	P_Beatmung_ES_CoughAssist_Frequenz	\N	Hz	6	1	\N	\N	\N
110851	P_Beatmung_ES_CoughAssist_Amplitude	\N	cmH2O	6	1	\N	\N	\N
110852	P_Beatmung_ES_RTX_FrequencyVibratin	\N	\N	6	1	\N	\N	\N
110853	P_Beatmung_ES_RTX_InspPressure	\N	cmH2O	6	1	\N	\N	\N
110854	P_Beatmung_ES_RTX_Time	\N	min	6	1	\N	\N	\N
110855	P_Beatmung_ES_RTX_FrequencyCough	\N	cpm	6	1	\N	\N	\N
110856	P_Beatmung_ES_RTX_ExpPressure	\N	cmH2O	6	1	\N	\N	\N
110857	P_Beatmung_ES_RTX_IE	\N	\N	3	1	\N	\N	\N
110858	P_Beatmung_ES_RTX_TimeCough	\N	min	6	1	\N	\N	\N
110859	P_Beatmung_ES_RTX_RepeatCount	\N	\N	3	1	\N	\N	\N
110860	P_Beatmung_ES_RTX_MinBackup	\N	\N	6	1	\N	\N	\N
110861	P_Beatmung_ES_RTX_TriggerSource	\N	\N	3	1	\N	\N	\N
110862	P_Beatmung_ES_RTX_Sensitivity	\N	\N	3	1	\N	\N	\N
110863	P_Beatmung_ES_RTX_Frequenz	\N	cpm	6	1	\N	\N	\N
110864	P_Beatmung_ES_RTX_NegativePressure	\N	cmH2O	6	1	\N	\N	\N
110865	Beatmung_Doku_Heimbeatmung_Beatmungsmodus	\N	\N	3	1	\N	\N	\N
110866	Beatmung_ES_Heimbeatmung_Sauerstoff	\N	\N	6	1	\N	\N	\N
110867	Beatmung_ES_Heimbeatmung_Psupport	\N	\N	6	1	\N	\N	\N
110868	Beatmung_ES_Heimbeatmung_Pcontrol	\N	\N	6	1	\N	\N	\N
101947	Score_TISS28	\N	\N	1	1	\N	\N	\N
101973	Score_SAPS2	\N	\N	1	1	\N	\N	\N
110869	Beatmung_ES_T1_Thoch	\N	\N	6	1	\N	\N	\N
110870	Beatmung_ES_T1_Frequenz_Backup	\N	AZ/min	6	1	\N	\N	\N
110871	Beatmung_ES_T1_passiver_Patient	Liste ein aus	\N	3	1	\N	\N	\N
110872	Beatmung_ES_T1_Oxygen_Target_Shift	\N	\N	3	1	\N	\N	\N
110873	Beatmung_ES_T1_Kein_Recruitment	Liste ein aus	\N	3	1	\N	\N	\N
110874	Beatmung_ES_T1_HLI	Liste ein aus	\N	3	1	\N	\N	\N
110875	Beatmung_ES_T1_Quick_Wean	Liste ein aus	\N	3	1	\N	\N	\N
110876	Beatmung_ES_T1_Zeit_zw2_SBT	Zeit zwischen 2 SBT	min	6	1	\N	\N	\N
110877	Beatmung_ES_T1_ZeitStartSBT	Zeit bis zum Start SBT	min	6	1	\N	\N	\N
110878	Beatmung_ES_T1_Peep_Grenzwert	\N	mbar	3	1	\N	\N	\N
110879	Beatmung_ES_T1_Pmax	\N	mbar	6	1	\N	\N	\N
110880	Beatmung_ES_Heimbeatmung_Vt	Einstellung Tidalvolumen	ml	6	1	\N	\N	\N
110881	Beatmung_ES_Heimbeatmung_Ti	\N	sek	6	1	\N	\N	\N
110882	Beatmung_ES_Heimbeatmung_Timax	eingestellte maximale Inspirationszeit 	sek	6	1	\N	\N	\N
110883	Beatmung_ES_Heimbeatmung_Frequenz_Backup	\N	\N	6	1	\N	\N	AZ/min
110884	Beatmung_ES_Heimbeatmung_Ti_Backup	\N	s	6	1	\N	\N	\N
110885	Beatmung_ES_Heimbeatmung_Pkontrol_Backup	\N	mbar	6	1	\N	\N	\N
110886	P_Patient_Gewicht_WaageBezeichnung	Die Nummer der Waage, mit der das Gewicht ermittelt wurde.	\N	3	1	\N	\N	\N
110887	B_VO_Messintervall_MAD_kont	MAD Messintervall	\N	39	30	\N	\N	\N
110888	B_ZW_MAD_kont	MAD Zielwert 	\N	39	30	\N	\N	\N
110889	B_GW_MAD_kont	MAD Grenzwert 	\N	39	30	\N	\N	\N
110890	P_Beatmung_ES_C3_SHT	\N	\N	3	1	\N	\N	\N
110891	P_Beatmung_ES_C3_ARDS	\N	\N	3	1	\N	\N	\N
110892	P_Beatmung_ES_C3_chronHyperkapnie	\N	\N	3	1	\N	\N	\N
110893	P_Beatmung_ES_C3_CO2Elim_Target_Shift	\N	\N	3	1	\N	\N	\N
110894	P_Beatmung_ES_C3_Peep_Grenzwert	\N	\N	6	1	\N	\N	\N
110895	P_Beatmung_ES_C3_ZeitStartSBT	\N	\N	6	1	\N	\N	\N
110896	P_Beatmung_ES_C3_SBT_Frequenz	\N	\N	6	1	\N	\N	\N
110897	P_Beatmung_ES_C3_SBT_Support_min	\N	\N	6	1	\N	\N	\N
110898	P_Beatmung_ES_C3_SBT_Psupp_max	\N	\N	6	1	\N	\N	\N
110899	P_Beatmung_ES_C3_SBT_Zeitraum_bevor	\N	\N	3	1	\N	\N	\N
110900	P_Beatmung_ES_C3_SBT_Zeitraum_nach	\N	\N	3	1	\N	\N	\N
110901	P_Beatmung_MS_C3_ProzentMinVol	\N	\N	6	1	\N	\N	\N
110902	Ernaehren_Ausscheiden_Windel_Inhalt	Gibt an welchen Inhalt die Windel hat	\N	3	100453	\N	\N	Pflegedoku - Windel (Inhalt)
110903	Ernaehren_Ausscheiden_APoral_Menge_umgef_aboral	Menge des Stuhlgangs der vom AP oral in den AP aboral umgefüllt wird. Der Wert wird in der Bilanz als "Plus" verrechnet	ml	6	100453	\N	\N	\N
101992	Score_SOFA	\N	\N	1	1	\N	\N	\N
110904	P_Patient_Gewicht_Differenz	Differenz zwischen dem aktuellen Gewicht und dem Gewicht des letzten Eintrags	\N	6	1	\N	\N	\N
110905	Score_GCS_Child_Aufnahme_Augen	\N	\N	27	108523	\N	\N	\N
110906	Score_GCS_Child_Aufnahme_Motorik	\N	\N	27	108523	\N	\N	\N
110907	Score_GCS_Child_Aufnahme_Sprache	\N	\N	27	108523	\N	\N	\N
110908	B_Aufnahmebefund_ErfolgteDiagnostik	\N	\N	3	30	\N	\N	\N
110909	B_Aufnahmebefund_Fokus	\N	\N	3	30	\N	\N	\N
110910	B_Aufnahmebefund_Lactatwert	\N	\N	3	30	\N	\N	\N
110911	B_Aufnahmebefund_Infusionsvolumen	\N	\N	3	30	\N	\N	\N
110912	B_Aufnahmebefund_Antibiose	\N	\N	3	30	\N	\N	\N
110913	Beatmung_ES_Servoi_Psupport	\N	mbar	6	1	\N	\N	\N
110914	Beatmung_ES_Servoi_Pkontrol_Backup	\N	mbar	6	1	\N	\N	\N
110915	Beatmung_MS_Servoi_I_E	I:E Verhältnis (Messung)	\N	3	1	\N	\N	\N
110916	Beatmung_ES_Servoi_Pkontrol_Phoch	\N	\N	6	1	\N	\N	\N
110917	Beatmung_MS_Servoi_Ti_Tges	\N	s	6	1	\N	\N	\N
110918	B_Medikation_validiert_durch_diskont	Validierender Mitarbeiter der Verordnung Medikation für den Zeitraum 06:00 bis 06:00 am aktuellen Tag. Diskontinuierlich.	\N	39	30	\N	\N	\N
110919	LAP1	linksartrialer Druck	mmHg	12	1	\N	\N	\N
110920	RCWI	\N	\N	6	1	\N	\N	\N
110921	RAP1	rechtsartrialer Druck	mmHg	12	1	\N	\N	\N
110922	LCWI	Left Cardiac Work Index 	\N	6	1	\N	\N	\N
110923	ICP1	intracranieller Druck	mmHg	12	1	\N	\N	\N
110924	P_Temperatur_Venoes	Anlage im Rahmen PhilipsMonitoring	°C	6	1	\N	\N	\N
110925	P_Temperatur_Arteriell	Anlage im Rahmen PhilipsMonitoring	°C	6	1	\N	\N	\N
110926	P_Temperatur_Haut	Anlage im Rahmen PhilipsMonitoring	°C	6	1	\N	\N	\N
110927	P_Temperatur_Naso	Anlage im Rahmen PhilipsMonitoring	°C	6	1	\N	\N	\N
110928	P_Temperatur_Oesophagial	Anlage im Rahmen PhilipsMonitoring	°C	6	1	\N	\N	\N
110929	P_Temperatur_Tympanal	Anlage im Rahmen PhilipsMonitoring	°C	6	1	\N	\N	\N
110930	P_Temperatur_Rektal	Anlage im Rahmen Philips Monitoring	°C	6	1	\N	\N	\N
110931	P_Temperatur_Messung_OrtAllg	Temperatur iat keinem spezieelnMessort über das Monitoring zugeordnet.	\N	19	1	\N	\N	\N
110932	TempDelta	Anlage im Rahmen PhilipsMonitoring	°C	6	1	\N	\N	\N
110933	P_Temperatur_Kern	Anlage für Philips Monitoring	°C	6	1	\N	\N	\N
110934	P_Temperatur_generic	Anlage für Philips Monitoring	°C	6	1	\N	\N	\N
110935	ART	2. artereille Messung, ab 201712 im Rahmen Umstellung Philips Monitoring	mmHg	12	1	\N	\N	\N
110936	P_Temperatur_Messung_OrtKern	\N	\N	19	1	\N	\N	\N
110937	P_Beatmung_MS_AnaConDa_MAC	Umstellung PhilipsMonitoring	Vol%	6	1	\N	\N	\N
110938	P_Beatmung_MS_NO2	\N	ppm	6	1	\N	\N	\N
110939	P_Beatmung_ES_NO	\N	ppm	6	1	\N	\N	\N
102054	Bewegen_Bewegungen_Fingertest	\N	\N	3	100360	\N	\N	Pflegedoku - Druckgefährdung (Fingertest)
110940	P_CSF_MS_LiquoGuard_Fuellstand	\N	ml	6	1	\N	\N	\N
110941	P_CSF_ES_LiquoGuard_Vset	\N	ml/h	6	1	\N	\N	\N
110980	Score_FOUR_motorischeReaktion	\N	\N	27	110976	\N	\N	\N
110956	B_Entlassmanag_EntlassplanAktualisiert_J_Ar	\N	\N	2	30	\N	\N	\N
110957	B_Entlassmanag_EntlassplanAktualisiert_J_Pf	\N	\N	2	30	\N	\N	\N
110958	B_Entlassmanag_EntlassplanAktualisiert_N_Ar	\N	\N	2	30	\N	\N	\N
110959	B_Entlassmanag_EntlassplanAktualisiert_N_Pf	\N	\N	2	30	\N	\N	\N
110960	B_Entlassmanag_FolgendeDokumente_Briefe_Ar	\N	\N	2	30	\N	\N	\N
110961	B_Entlassmanag_FolgendeDokumente_Gespraeche_Ar	\N	\N	2	30	\N	\N	\N
110962	B_Entlassmanag_Poststat_Versorgungsbedarf_J_Ar	\N	\N	2	30	\N	\N	\N
110963	B_Entlassmanag_Poststat_Versorgungsbedarf_J_Pf	\N	\N	2	30	\N	\N	\N
110964	B_Entlassmanag_Poststat_Versorgungsbedarf_N_Ar	\N	\N	2	30	\N	\N	\N
110965	B_Entlassmanag_Poststat_Versorgungsbedarf_N_Pf	\N	\N	2	30	\N	\N	\N
110966	B_Entlassmanag_weitereBerufsgruppenf_J_Ar	\N	\N	2	30	\N	\N	\N
110967	B_Entlassmanag_weitereBerufsgruppenf_J_Pf	\N	\N	2	30	\N	\N	\N
110968	B_Entlassmanag_weitereBerufsgruppenf_N_Ar	\N	\N	2	30	\N	\N	\N
110969	B_Entlassmanag_weitereBerufsgruppenf_N_Pf	\N	\N	2	30	\N	\N	\N
110970	F_Doku_Mutter_Erkrankungen	\N	\N	1	20	\N	\N	\N
110971	F_Doku_Vater_Erkrankungen	\N	\N	1	20	\N	\N	\N
110972	F_Doku_Mutter_Erkrankungen_Eintrag	\N	\N	3	110970	\N	\N	Mutter (Vorerkrankung)
110973	F_Doku_Vater_Erkrankungen_Eintrag	\N	\N	3	110971	\N	\N	Vater (Vorerkrankung)
110975	ECMO_Kanuelen_Wechsel_geplant	\N	\N	5	106698	\N	\N	\N
110976	Score_FOUR	Score FOUR = Full Outline of UnResponsiveness.	\N	1	1	\N	\N	\N
110977	Score_FOUR_Wert	\N	\N	2	110976	\N	\N	\N
110978	Score_FOUR_Date	\N	\N	5	110976	\N	\N	\N
110979	Score_FOUR_Respiration	\N	\N	27	110976	\N	\N	\N
110981	Score_FOUR_Hirnstammreflexe	\N	\N	27	110976	\N	\N	\N
110982	Score_FOUR_Augenreaktion	\N	\N	27	110976	\N	\N	\N
110983	Ernaehren_Ausscheiden_StuhlGeruch	\N	\N	3	100453	\N	\N	Pflegedoku - Stuhl (Geruch)
110985	CO_tempObject_BehEnde	Hinweis bei abgeschlossener Behandlung - Anzeige Datum behandlungsende	\N	37	0	\N	\N	\N
110987	B_ZW_Kalium_kont	Kalium Zielwert	mmol/l	39	30	\N	\N	Zielwert Kalium
110988	B_ZW_24hUrin_kont	24h_Urin Zielwert	ml	39	30	\N	\N	Zielwert 24 h Urin in ml
110989	B_ZW_paO2_kont	paO2 Zielwert	mmHg	39	30	\N	\N	Zielwert paO2
110990	B_ZW_PEEP_kont	PEEP Zielwert	mbar	39	30	\N	\N	Zielwert PEEP
110991	B_ZW_RASS_kont	RASS Zielwert	\N	39	30	\N	\N	Zielwert RASS
110992	B_ZW_NRS_kont	NRS Zielwert	\N	39	30	\N	\N	Zielwert NRS
110993	B_ZW_Beatmungsmodus_kont	Beatmungsmodus Zielwert	\N	39	30	\N	\N	Zielwert Beatmungsmodus
110994	B_ZW_Sedierung_kont	Sedierung Zielwert	\N	39	30	\N	\N	Zielwert Sedierung
110995	B_ZW_RRT_kont	RRT Zielwert	\N	39	30	\N	\N	Zielwert RRT (renal replacement therapy)
110996	B_ZW_Kost_kont	Kost Zielwert	\N	39	30	\N	\N	Zielwert Kost
110997	B_ZW_Mobilisation_kont	Mobilisation Zielwert	\N	39	30	\N	\N	Zielwert Mobilisation
110998	B_ZW_Freitext_kont	Freitext Zielwert	\N	39	30	\N	\N	Zielwert Freitext
110999	Drainagen_Pcsf	Parameter Cerebrospinales Fluidmanagement	mmHg	6	100157	\N	\N	\N
111000	Drainagen_Pset	Parameter Cerebrospinales Fluidmanagement	mmHg	6	100157	\N	\N	\N
111001	Drainagen_Vset	Parameter Cwerebrospinales Fluidmanagement	ml/h	6	100157	\N	\N	\N
111002	Drainagen_CSF_Geraet	Auswahl Gerätetyp Cerebrospinales Fluidmanagement	\N	3	100157	\N	\N	\N
111003	Drainagen_CSF_Liqourfluss	\N	ml/h	6	100157	\N	\N	\N
111004	Drainagen_CSF_Geraet_Balken	\N	\N	19	100157	\N	\N	\N
112000	B_Entlassmanag_Poststat_Versorgungsbedarf_U_Pf	\N	\N	2	30	\N	\N	\N
112001	B_Entlassmanag_weitereBerufsgruppenf_U_Pf	\N	\N	2	30	\N	\N	\N
112002	B_Entlassmanag_Poststat_Versorgungsbedarf_U_Ar	\N	\N	2	30	\N	\N	\N
112003	B_Entlassmanag_weitereBerufsgruppenf_U_Ar	\N	\N	2	30	\N	\N	\N
112004	P_CerebraleOxymetrie_Doku_Geraet_Balken	\N	\N	26	1	\N	\N	Dokumentation Cerebrale Oxymetrie
112005	P_CerebraleOxymetrie_VO_Geraet_Balken	\N	\N	26	1	\N	\N	Verordnung Cerebrale Oxymetrie
112006	P_INVOS_Doku_rSO2_links	cerebrale Sauerstoffsättigung links	%	6	1	\N	\N	rSO2 links
112007	P_INVOS_Doku_rSO2_rechts	cerbebrale Sauerstoffsättigung rechts	%	6	1	\N	\N	rSO2 rechts
112008	P_VO_Indikation_cerebraleOxySyst	\N	\N	3	1	\N	\N	\N
112009	Atemwege_CuffmanagerKont	\N	\N	19	100150	\N	\N	\N
112010	F_spezGew_Refraktometer	spezifische Gewicht Refraktometer	\N	6	20	\N	\N	\N
112011	Ramsay_Aufnahme_Wert	\N	\N	2	107972	\N	\N	\N
112012	Ramsay_Aufnahme_Sedierung	\N	\N	27	107972	\N	\N	\N
112013	Ramsay_Aufnahme_Datum	\N	\N	5	107972	\N	\N	\N
112014	P_Beatmung_ES_Option_intelli	Listenauswahl Beatmungsoption intelli	\N	19	1	\N	\N	\N
112015	Behandlung_VO_MessintervallPupillenkontrolle_kont	\N	\N	39	30	\N	\N	Verordnung Messintervall Pupillenkontrolle
112016	CO6_Filter_ToDo_BehOrt	\N	\N	3	650	\N	\N	\N
112017	P_SEF	Spectral Edge Frequency	Hz	6	1	\N	\N	Spectral Edge Frequency
112018	P_SEF1	EEG - Spectral Edge Frequency Channel 1	Hz	6	1	\N	\N	EEG - Spectral Edge Frequency Channel 1
112019	P_SEF2	EEG - Spectral Edge Frequency Channel 2	Hz	6	1	\N	\N	EEG - Spectral Edge Frequency Channel 2
112020	P_TP1	EEG - Total Power - Channel 1	nW	6	1	\N	\N	EEG - Total Power - Channel 1
112021	P_TP2	EEG - Total Power - Channel 2	nW	6	1	\N	\N	EEG - Total Power - Channel 2
112022	Score_NIHSS_Wert	\N	\N	2	102806	\N	\N	\N
112023	Score_NIHSS_Date	\N	\N	5	102806	\N	\N	\N
112024	Score_NIHSS_Aufforderungen	\N	\N	27	102806	\N	\N	\N
112025	Score_NIHSS_Blickbewegungen	\N	\N	27	102806	\N	\N	\N
112026	Score_NIHSS_Dysarthrie	\N	\N	27	102806	\N	\N	\N
112027	Score_NIHSS_Extremitaetenataxie	\N	\N	27	102806	\N	\N	\N
112028	Score_NIHSS_Facialisparese	\N	\N	27	102806	\N	\N	\N
112029	Score_NIHSS_Gesichtsfeld	\N	\N	27	102806	\N	\N	\N
112030	Score_NIHSS_MotorikArmLinks	\N	\N	27	102806	\N	\N	\N
112031	Score_NIHSS_MotorikArmRechts	\N	\N	27	102806	\N	\N	\N
112032	Score_NIHSS_MotorikBeinLinks	\N	\N	27	102806	\N	\N	\N
112033	Score_NIHSS_MotorikBeinRechts	\N	\N	27	102806	\N	\N	\N
112034	Score_NIHSS_Neglect	\N	\N	27	102806	\N	\N	\N
112035	Score_NIHSS_Orientierung	\N	\N	27	102806	\N	\N	\N
112036	Score_NIHSS_Sprache	\N	\N	27	102806	\N	\N	\N
112037	Score_NIHSS_Vigilanz	\N	\N	27	102806	\N	\N	\N
112038	Score_NIHSS_Sensibilitaet	\N	\N	27	102806	\N	\N	\N
112039	Sicherheit_Fixierung_Wert	\N	\N	25	100470	\N	\N	\N
112040	Sicherheit_Fixierung_Grund	Fixierungsgrund	\N	19	112039	\N	\N	Fixierungsgrund
112041	Sicherheit_Fixierung_ArtUmfang	Art und Umfang der Fixierung	\N	3	112039	\N	\N	Art und Umfang der Fixierung
112042	P_AssistenzBeiPflegerischenMassnahmen	Dokumentierte Dauer der pflegerischen Assistenz bei pflegerischen Maßnahmen - Interventionen mit Zeitaufwand	\N	19	1	\N	\N	Assistenz bei pflegerischen Massnahmen
112043	Sicherheit_Gefaehrdung_Wert	\N	\N	25	100470	\N	\N	\N
112044	Sicherheit_Gefaehrdung_Wert_Status	\N	\N	19	112043	\N	\N	\N
112045	Sicherheit_Fixierung_Massnahme	\N	\N	19	112039	\N	\N	\N
113043	Sicherheit_Fixierung_Betreuungsverhaeltnis	\N	\N	19	112039	\N	\N	\N
113044	Sicherheit_Fixierung_Art	\N	\N	3	112039	\N	\N	\N
113045	P_EEG_Monitoring	Balken für Kontinuierliches EEG Monitoring	\N	19	1	\N	\N	EEG Monitoring
113046	Beatmung_ES_T1_Flow	Einstellung Sauerstoff Flow	L/min	6	1	\N	\N	Einstellung Sauerstoff Flow
113047	NEV_CRRT_ES_Multi_praeF	\N	mmHg	6	1	\N	\N	\N
113048	NEV_CRRT_VO_Multi_praeF	\N	mmHg	6	1	\N	\N	\N
113049	Behandlung_KLAT_Temp	Objekt für Speicherung der temporären Daten des klinischen Auftrags	\N	37	30	\N	\N	\N
113050	Behandlung_KLAT_Temp_Diagnose	Diagnose für klinischen Auftrag	\N	3	113049	\N	\N	\N
113051	Arztbriefunterstuetzung_Verlaufsgewicht	letzter Eintrag Verlaufsgewicht innerhalb der Behandlung	\N	6	106725	\N	\N	\N
113052	Arztbriefunterstuetzung_Dekubitus	\N	\N	3	106725	\N	\N	\N
113053	Arztbriefunterstuetzung_Wunden	\N	\N	3	106725	\N	\N	\N
113054	Arztbriefunterstuetzung_ZugangAbleitung	\N	\N	3	106725	\N	\N	\N
113055	Arztbriefunterstuetzung_BilanzVortag	\N	\N	6	106725	\N	\N	\N
113056	Arztbriefunterstuetzung_Herzunterstuetzung	\N	\N	3	106725	\N	\N	\N
113057	Arztbriefunterstuetzung_ECMO_ECLS	Lungenersatzverfahren	\N	3	106725	\N	\N	\N
113058	Arztbriefunterstuetzung_ADVOS	Leberersatztherapie	\N	3	106725	\N	\N	\N
113059	Arztbriefunterstuetzung_Nierenersatzverfahren	\N	\N	3	106725	\N	\N	\N
113060	Arztbriefunterstuetzung_Beatmung	\N	\N	3	106725	\N	\N	\N
113061	Arztbriefunterstuetzung_Airwaymanagement	\N	\N	3	106725	\N	\N	\N
113062	Arztbriefunterstuetzung_Transf_ICU_gesamt	\N	\N	3	106725	\N	\N	\N
113063	Arztbriefunterstuetzung_Transf_OP_INT_gesamt	\N	\N	3	106725	\N	\N	\N
113064	Arztbriefunterstuetzung_VerlaufsberichtIntervent	\N	\N	3	106725	\N	\N	\N
113065	Arztbriefunterstuetzung_Verlaufsbericht_OP	\N	\N	3	106725	\N	\N	\N
113066	Arztbriefunterstuetzung_Infektion	\N	\N	3	106725	\N	\N	\N
113067	Arztbriefunterstuetzung_Allergie	\N	\N	3	106725	\N	\N	\N
113068	Arztbriefunterstuetzung_Epikrise	\N	\N	3	106725	\N	\N	\N
113069	Arztbriefunterstuetzung_Untersuchung_Aufnahme	\N	\N	3	106725	\N	\N	\N
113070	Arztbriefunterstuetzung_Aufnahmeart	\N	\N	3	106725	\N	\N	\N
113071	F_MedDoku_OperationRevisionEingriff_inOP_TK	\N	ml	6	105228	\N	\N	\N
113072	F_MedDoku_OperationRevisionEingriff_inOP_FFP	\N	\N	6	105228	\N	\N	\N
113073	F_MedDoku_OperationRevisionEingriff_inOP_EK	\N	\N	6	105228	\N	\N	\N
113074	B_Epikrise	\N	\N	3	30	\N	\N	\N
114051	F_Untersuchung_EKGVerlauf	\N	\N	3	105203	\N	\N	\N
114052	NEV_CRRT_MS_Multi_praeF	\N	\N	6	1	\N	\N	\N
115052	P_Betreuungsverhaeltnis	\N	\N	19	1	\N	\N	\N
115053	Behandlungsort_alternativerName	alternative Bezeichnung für den Behandlungsort (z.B. Langbezeichung)	\N	3	40	\N	\N	\N
115054	Organisationseinheit_Typ	0-Klinik, 1-fachliche OE, 2-pflegerische OE	\N	2	80	\N	\N	\N
115055	Organisationseinheit_ParentID	\N	\N	15	80	\N	\N	\N
115056	Organisationseinheit_Kopierstatus	Gibt an, ob Ao aus Vorbehandlungen in eine behandlung dieser OE kopiert werden sollen	\N	2	80	\N	\N	\N
116053	B_NotfallAnlage_VMA	wer hat die Akte angelegt	\N	3	30	\N	\N	\N
117094	B_VerlegungZeit930_1000	\N	\N	2	30	\N	\N	\N
117053	Behandlung_Arztkontakt	Arztkontakt erfolgt !	\N	2	30	\N	\N	Behandlung_Arztkontakt
117054	B_ZW_ScVO2_kont	ScVO2 Zielwert	\N	39	30	\N	\N	\N
117055	B_ZW_SAP_kont	SAP Zielwert	\N	39	30	\N	\N	\N
117056	B_ZW_RASSNacht_kontinuierl	Rass Nacht Zielwert	\N	39	30	\N	\N	\N
117057	B_ZW_PTT_kont	\N	\N	39	30	\N	\N	\N
117058	B_ZW_pH-art_kontinuierlich	pH-art Zielwert	\N	39	30	\N	\N	\N
117059	B_ZW_paCO2_kont	\N	\N	39	30	\N	\N	\N
117060	B_ZW_Monitoring_kontinuierl	Monitoring Zielwert	\N	39	30	\N	\N	\N
117061	B_ZW_Massnahmen_kont	Massnahmen Zielwert	\N	39	30	\N	\N	\N
117062	B_ZW_Hb_kontinuierlich	\N	\N	39	30	\N	\N	\N
117063	B_ZW_DiagnostikLaborPoC_kont	Diagnostik Labor PoC Zielwert	\N	39	30	\N	\N	\N
117064	B_ZW_CI_kontinuierlich	Cl Zielwert	\N	39	30	\N	\N	\N
117065	B_ZW_AntiXa_kontinuierlich	\N	\N	39	30	\N	\N	\N
117066	B_ZW_ACT_kontinuierlich	ACT Zielwert	\N	39	30	\N	\N	\N
117067	F_MedDoku_OperationRevisionEingriff_ATDoku	\N	\N	3	105228	\N	\N	\N
102199	HZV_VigileoGeraet	\N	\N	3	1	\N	\N	ZV-Gerät - HZV Vigileo Gerät
102200	HZV_PICCOGeraet	\N	\N	3	1	\N	\N	HZV-Gerät - PICCO Gerät
102201	HZV_VigilanceCGeraet	\N	\N	3	1	\N	\N	HZV Gerät - HZV VilgilanceC Gerät
117068	Patient_Risikofaktoren	\N	\N	1	1	\N	\N	\N
117069	Patient_schwierigerAtemweg	\N	\N	1	20	\N	\N	\N
117070	Patient_Allergie_Reaktion	\N	\N	3	103591	\N	\N	\N
117071	Patient_Risikofaktoren_Ende	\N	\N	5	117068	\N	\N	\N
117072	Patient_Risikofaktoren_Beginn	\N	\N	5	117068	\N	\N	\N
117073	Patient_Risikofaktoren_Text	\N	\N	3	117068	\N	\N	\N
117074	Patient_schwierigerAtemweg_Bemerkung	\N	\N	3	117069	\N	\N	\N
117075	Patient_schwierigerAtemweg_Ende	\N	\N	5	117069	\N	\N	\N
117076	Patient_schwierigerAtemweg_Beginn	\N	\N	5	117069	\N	\N	\N
117077	Patient_schwierigerAtemweg_Eintrag	\N	\N	3	117069	\N	\N	\N
117078	B_VerlegungArzt	\N	\N	3	30	\N	\N	\N
117079	B_VerlegungSonstiges3	\N	\N	3	30	\N	\N	\N
117080	B_VerlegungSonstiges2	\N	\N	3	30	\N	\N	\N
117081	B_VerlegungSonstiges1	\N	\N	3	30	\N	\N	\N
117082	B_VerlegungO2Menge	\N	\N	2	30	\N	\N	\N
117083	B_VerlegungBDK	\N	\N	2	30	\N	\N	\N
117084	B_VerlegungTSD	\N	\N	2	30	\N	\N	\N
117085	B_VerlegungDrainagen	\N	\N	2	30	\N	\N	\N
117086	B_VerlegungBraunuele	\N	\N	2	30	\N	\N	\N
117087	B_VerlegungShaldon	\N	\N	2	30	\N	\N	\N
117088	B_VerlegungZVK	\N	\N	2	30	\N	\N	\N
117089	B_VerlegungO2Flasche	\N	\N	2	30	\N	\N	\N
117090	B_VerlegungO2	\N	\N	2	30	\N	\N	\N
117091	B_VerlegungAbspracheDurch	\N	\N	3	30	\N	\N	\N
117092	B_VerlegungDatumAnkuendigung	\N	\N	5	30	\N	\N	\N
117093	B_VerlegungPflegekraft	\N	\N	3	30	\N	\N	\N
117095	B_VerlegungZeit900_930	\N	\N	2	30	\N	\N	\N
117096	B_VerlegungZeit800_900	\N	\N	2	30	\N	\N	\N
117097	B_VerlegungNachrichtlichASD	\N	\N	2	30	\N	\N	\N
117098	B_VerlegungNachACPatientenmanagement	\N	\N	2	30	\N	\N	\N
117099	B_VerlegungNachTC6_bWZ	\N	\N	2	30	\N	\N	\N
117100	B_VerlegungNachTC6_b	\N	\N	2	30	\N	\N	\N
117101	B_VerlegungNachNC2_b	\N	\N	2	30	\N	\N	\N
117102	B_VerlegungNachNC3_b	\N	\N	2	30	\N	\N	\N
117103	B_VerlegungNachNC3_a	\N	\N	2	30	\N	\N	\N
117104	B_VerlegungNachMSZ8_b	\N	\N	2	30	\N	\N	\N
117105	B_VerlegungNachMSZ8_a	\N	\N	2	30	\N	\N	\N
117106	B_VerlegungNachMSZ6_a	\N	\N	2	30	\N	\N	\N
117107	B_VerlegungNachMSZ4_b	\N	\N	2	30	\N	\N	\N
117108	B_VerlegungNachMSZ8_bWZ	\N	\N	2	30	\N	\N	\N
117109	B_VerlegungNachMSZ4_a	\N	\N	2	30	\N	\N	\N
117110	B_VerlegungNachHTG5_bWZ	\N	\N	2	30	\N	\N	\N
117111	B_VerlegungNachHTG5_b	\N	\N	2	30	\N	\N	\N
117112	B_VerlegungNachHTG5_aWZ	\N	\N	2	30	\N	\N	\N
117113	B_VerlegungNachHTG5_a	\N	\N	2	30	\N	\N	\N
117114	B_VerlegungNachHTG2_a	\N	\N	2	30	\N	\N	\N
117115	B_VerlegungDatum	\N	\N	5	30	\N	\N	\N
117116	B_Verlegunsplan_Zeitpunkt	geplanter Verlegungszeitpunkt	\N	5	30	\N	\N	\N
117117	B_Verlegungsplan_toDo	Verlegungsplanung to do	\N	3	30	\N	\N	\N
117118	B_Verlegungsplan_Station	geplante Verlegung - Station	\N	3	30	\N	\N	\N
117119	B_ZW_AntiXa_kont	\N	\N	39	30	\N	\N	\N
117120	F_MedDoku_OperationRevisionEingriff_Anaesthesie	\N	\N	3	105228	\N	\N	\N
117121	Dekubitus_Instillation_ml_VAC	\N	\N	6	100186	\N	\N	\N
117122	Dekubitus_Wert_VAC_Geraet	\N	\N	19	100186	\N	\N	\N
117123	Wunddokumentation_Instillation_ml_VAC	\N	\N	6	100193	\N	\N	\N
117124	Wunddokumentation_Wert_VAC_Geraet	\N	\N	19	100193	\N	\N	\N
117125	Atemwege_Wert_AtmungDevice	\N	\N	19	100150	\N	\N	\N
117126	Score_CAM_ICU_Punktwert_GesamtAktualisierung2020	\N	\N	1	1	\N	\N	\N
117127	Score_CAM_ICU_Punktwert_Gesamt_WertAktual2020	\N	\N	2	117126	\N	\N	\N
117128	Score_CAM_ICU_Punktwert_DatumAktualisierung2020	\N	\N	5	117126	\N	\N	\N
117129	Score_CAM_ICU_Punktwert_Gesamt_SubScoreAktuali2020	\N	\N	27	117126	\N	\N	\N
117130	B_Dauereinwilligung	\N	\N	3	30	\N	\N	\N
117131	DIVI_Visite	\N	\N	1	1	\N	\N	\N
117132	DIVI_Visite_Date	\N	\N	5	117131	\N	\N	\N
117133	DIVI_Visite_Wert	\N	\N	2	117131	\N	\N	\N
117134	CO6_Filter_Infektionsvisite	\N	\N	37	0	\N	\N	\N
117135	CO6_Filter_Infektionsvisite_Show	\N	\N	3	117134	\N	\N	\N
117136	CO6_Filter_PflegeVerlauf	\N	\N	37	0	\N	\N	\N
117137	CO6_Filter_PflegeVerlauf_Show	\N	\N	3	117136	\N	\N	\N
117138	CO6_Filter_Visite	\N	\N	37	0	\N	\N	\N
117139	CO6_Filter_Visite_Show	\N	\N	3	117138	\N	\N	\N
117140	Beatmung_ES_Servoi_Flow	Parameter im Modus Highflow	\N	6	1	\N	\N	\N
117141	F_MedDoku_OperationRevisionEingriff_inOP_Kristallo	\N	\N	6	105228	\N	\N	\N
117142	F_MedDoku_OperationRevisionEingriff_inOP_Kolloidal	\N	\N	6	105228	\N	\N	\N
117143	F_MedDoku_OperationRevisionEingriff_inOP_Diurese	\N	ml	6	105228	\N	\N	\N
117144	F_MedDoku_OperationRevisionEingriff_inOP_Blutverlu	Blutverlust intraoperativ	ml	6	105228	\N	\N	\N
117145	Drainagen_Wert_NPWT_Ausfuhr	\N	\N	6	100157	\N	\N	\N
117146	Drainagen_Wert_NPWT_IntensitaetString	\N	\N	3	100157	\N	\N	\N
117147	Drainagen_Wert_NPWT_Sog	\N	\N	6	100157	\N	\N	\N
117148	Drainagen_Wert_NPWT_Instillation	\N	\N	6	100157	\N	\N	\N
117149	Drainagen_Wert_NPWT_Fuellstand	\N	\N	6	100157	\N	\N	\N
117150	Drainagen_Wert_NPWT_Geraet	\N	\N	19	100157	\N	\N	\N
117151	Patient_SpO2po	\N	\N	6	1	\N	\N	\N
117152	Patient_SpO2pr	\N	\N	6	1	\N	\N	\N
117153	Patient_SpO2r	\N	\N	6	1	\N	\N	\N
117154	Patient_SpO2_l	\N	\N	6	1	\N	\N	\N
117155	P_NEV_HD_MS_Genius_UF_Time	\N	\N	3	1	\N	\N	\N
117156	P_NEV_HD_MS_Genius_Leitfaehigkeit	\N	\N	6	1	\N	\N	\N
117157	P_NEV_HD_MS_Genius_TemperaturIst	\N	\N	6	1	\N	\N	\N
117158	P_NEV_HD_MS_Genius_Systempressure	\N	\N	6	1	\N	\N	\N
117159	P_NEV_HD_MS_Genius_Ultrafiltratmengekum	\N	\N	6	1	\N	\N	\N
117160	P_NEV_HD_ES_Genius_UFGoal	\N	\N	6	1	\N	\N	\N
117161	P_NEV_HD_ES_Genius_TemperaturZiel	\N	\N	6	1	\N	\N	\N
117162	P_NEV_HD_ES_Genius_UFRate	\N	\N	6	1	\N	\N	\N
117163	P_NEV_HD_ES_Genius_Blutfluss	\N	\N	6	1	\N	\N	\N
117164	P_HD_Doku_Genius_Geraetenummer	\N	\N	19	1	\N	\N	\N
117165	P_NEV_HD_Doku_Genius_DSKonzentrat	\N	\N	19	1	\N	\N	\N
117166	P_NEV_HD_Doku_Genius_HCKonzentrat	\N	\N	19	1	\N	\N	\N
117167	P_Beatmung_ES_O2Flow	l/min	\N	6	1	\N	\N	\N
117168	P_Beatmung_ES_O2Konzentration	\N	%	6	1	\N	\N	\N
117169	P_Beatmung_ES_PeepCPAPPtief	\N	mbar	6	1	\N	\N	\N
117170	Datenuebernahme_TestvariableDec	\N	\N	6	1	\N	\N	\N
117171	F_Untersuchung_PreviousDataSet_EKGVerlauf	\N	\N	3	105212	\N	\N	\N
117172	B_TransportInnerkliniscOhneMonitor	\N	\N	2	30	\N	\N	\N
117173	B_TransportInnerklinischMitMonitor	\N	\N	2	30	\N	\N	\N
117174	B_TransportAusserklinischOhneMonitor	\N	\N	2	30	\N	\N	\N
117175	B_TransportAusserklinischMitMonitor	\N	\N	2	30	\N	\N	\N
117176	P_Weaning_Abbruchgrund	\N	\N	3	1	\N	\N	\N
117177	P_Weaning	\N	\N	19	1	\N	\N	\N
117178	P_Spontanatemtest	Dokumentation ob der Spontanatemtest bestanden wurde.	\N	3	1	\N	\N	\N
117179	P_SpontanatemtestVoraussetzung	\N	\N	3	1	\N	\N	\N
117180	F_Weaning	\N	\N	1	20	\N	\N	\N
117181	F_Weaning_RescueDauer	\N	\N	3	117180	\N	\N	\N
117182	F_Weaning_RescueFiO2	\N	\N	6	117180	\N	\N	\N
117183	F_Weaning_RescuePEEP	\N	\N	6	117180	\N	\N	\N
117184	F_Weaning_RescueFluss	\N	\N	6	117180	\N	\N	\N
117185	F_Weaning_RescuePsupport	\N	\N	6	117180	\N	\N	\N
117186	F_Weaning_RescuePmax	\N	\N	6	117180	\N	\N	\N
117187	F_Weaning_RescueModus	\N	\N	3	117180	\N	\N	\N
117188	F_Weaning_EntwoehnungZeitvorgabe	Verordnung der Zeitvorgabe der Entwöhnungsphase	\N	3	117180	\N	\N	\N
100004	Diagnose_Nr.	Diagnosennummer	\N	6	1278	\N	\N	\N
117189	F_Weaning_EntwoehnungFiO2	Verordnung der Einstellung des FiO2 während der Entwöhnungsphase	\N	6	117180	\N	\N	\N
117190	F_Weaning_EntwoehnungPEEP	Verordnung der Einstellung des PEEP/CPAP während der Entwöhnungsphase	\N	6	117180	\N	\N	Einstellung PEEP/CPAP Entwöhnungsphase
117191	F_Weaning_EntwoehnungFluss	Verordnung der Einstellung des Flusses während der Entwöhnungsphase	\N	6	117180	\N	\N	Verordnung Fluss in Entwöhnungsphase
117192	F_Weaning_EntwoehnungPsupport	Verordnung der Einstellung des Psupport während der Entwöhnungsphase	\N	6	117180	\N	\N	\N
117193	F_Weaning_EntwoehnungModus	Verordnung der Einstellung des Beatmungsmodus während der Entwöhnungsphase	\N	3	117180	\N	\N	\N
117194	F_Weaning_EntwoehnungMethode	Verordnung der Entwöhnungsmethode während der Entwöhnungsphase	\N	3	117180	\N	\N	Entwöhnungsmethode in der Entwöhnungsphase
117195	F_Weaning_Datum	\N	\N	5	117180	\N	\N	\N
117196	F_Weaning_Verantwortlicher	\N	\N	3	117180	\N	\N	\N
117197	DIVI_Visite_AnwesenheitFacharzt	\N	\N	27	117131	\N	\N	\N
117198	DIVI_Visite_MobilisationMoeglich	\N	\N	27	117131	\N	\N	\N
117199	DIVI_Visite_DiagnosenAktuell	\N	\N	27	117131	\N	\N	\N
117200	DIVI_Visite_MiBiBefunde	\N	\N	27	117131	\N	\N	\N
117201	DIVI_Visite_ABXIndikationGeprueft	\N	\N	27	117131	\N	\N	\N
117202	DIVI_Visite_Patientengespraech	\N	\N	27	117131	\N	\N	\N
117203	DIVI_Visite_Angehoerigengespraech	\N	\N	27	117131	\N	\N	\N
117204	DIVI_Visite_Nebendiagnosen	\N	\N	27	117131	\N	\N	\N
117205	DIVI_Visite_Vorsorgevollmacht	\N	\N	27	117131	\N	\N	\N
117206	DIVI_Visite_Ernaehrung	\N	\N	27	117131	\N	\N	\N
117207	DIVI_Visite_RASS	\N	\N	27	117131	\N	\N	\N
117208	DIVI_Visite_NRSBPS	\N	\N	27	117131	\N	\N	\N
117209	DIVI_Visite_SATBestanden	\N	\N	27	117131	\N	\N	\N
117210	DIVI_Visite_SATVoraussetzungen	\N	\N	27	117131	\N	\N	\N
117211	DIVI_Visite_PEEPFIO2	FIO2 passt zu PEEP	\N	27	117131	\N	\N	\N
117212	DIVI_Visite_VT6	\N	\N	27	117131	\N	\N	\N
117213	DIVI_Visite_Pmax	\N	\N	27	117131	\N	\N	\N
117219	Beatmung_Einstellung_Balken_ICU_IMC	Gerätekonfiguration DokumentationVentilation ICU_IMC	\N	26	1	\N	\N	\N
117220	VO_Messintervall_Diurese_kont	VO Monitoring Auscheidung/Intervall	\N	39	30	\N	\N	Monitoring Diurese
117221	Score_Rankin	\N	\N	1	1	\N	\N	\N
117222	Score_Rankin_Rankin	\N	\N	27	117221	\N	\N	\N
117223	Score_Rankin_Wert	\N	\N	2	117221	\N	\N	\N
117224	Score_Rankin_Date	\N	\N	5	117221	\N	\N	\N
117225	Score_Race	\N	\N	1	1	\N	\N	\N
117226	Score_Race_Date	\N	\N	5	117225	\N	\N	\N
117227	Score_Race_Wert	\N	\N	2	117225	\N	\N	\N
117228	Score_Race_AphasieAgnosie	\N	\N	27	117225	\N	\N	\N
117229	Score_Race_ArmBeinmotorik	\N	\N	27	117225	\N	\N	\N
117230	Score_Race_Gesichtslaehmung	\N	\N	27	117225	\N	\N	\N
117231	Score_Race_KopfAugenbewegungen	\N	\N	27	117225	\N	\N	\N
117232	P_LEV_ES_BFQ1	Zusatzgerät bei einer ECMO Therapie	\N	6	1	\N	\N	BFQ1 [l/min]
117233	P_LEV_ES_BFQ2	\N	\N	6	1	\N	\N	BFQ2
117234	P_LEV_ES_BFQ3	\N	\N	6	1	\N	\N	BFQ3
117235	P_LEV_Doku_LokalisationBFQ1	\N	\N	3	1	\N	\N	LokalisationBFQ1
117236	P_LEV_Doku_LokalisationBFQ2	\N	\N	3	1	\N	\N	Lokalisation BFQ2
117237	P_LEV_Doku_LokalisationBFQ3	\N	\N	3	1	\N	\N	Lokalisation BFQ3
117238	F_BildstudienCheck_Temp	\N	\N	37	20	\N	\N	BildstudienCheck
117239	F_BildstudienCheck_Temp_StudieVorhandenBool	\N	\N	2	117238	\N	\N	\N
117240	F_BildstudienCheck_Temp_Pruefungszeitpunkt	\N	\N	5	117238	\N	\N	\N
117241	P_PtiO2_Decimal	\N	mmHg	6	1	\N	\N	\N
117242	NEV_CRRT_ES_Multi_FilterO2Flow	Filter - O2Flow zur Ausspülung CO2	l/min	6	1	\N	\N	\N
9	COPRA_Patient_Schwangerschaftswoche	Schwangerschaftswoche zum Zeitpunkt der Geburt in ganzen Tagen	d	2	1	\N	\N	\N
10	COPRA_Patient_errechneter_Geburtstermin	errechneter Geburtstermin	\N	17	1	\N	\N	\N
11	COPRA_Patient_Kopfumfang	Kopfumfang des Patienten in Zentimetern	cm	6	1	\N	\N	\N
12	COPRA_Patient_Perzentile	Zuletzt selektierter Perzentilendatensatz des Patienten	\N	2	1	\N	\N	\N
13	COPRA_Patient_Bezugsgewicht	Bezugsgewicht des Patienten in kg	kg	6	1	\N	\N	\N
14	COPRA_Patient_Geburtsgewicht	Geburtsgewicht des Patienten in Kilogramm	kg	6	1	\N	\N	\N
15	CO_Patient_MergeSource	\N	\N	53	1	\N	\N	\N
16	CO_Patient_MergeTarget	\N	\N	54	1	\N	\N	\N
24	CO_Fall_MergeSource	\N	\N	53	20	\N	\N	\N
25	CO_Fall_MergeTarget	\N	\N	54	20	\N	\N	\N
31	Behandlung_BewegungsNummer	Bewegungsnummer für die eindeutige Identifizierung der Behandlung	\N	3	30	\N	\N	\N
33	Behandlung_Geschlossen	Behandlungabschluß	\N	2	30	\N	\N	\N
34	Behandlung_Geschlossen_medizinisch	Medizinischer Behandlungsabschluss	\N	2	30	\N	\N	\N
35	Behandlung_LEP_Ereignis	Behandlung_LEP_Ereignis	\N	50	30	\N	\N	\N
36	Behandlung_LEP_Information	Behandlung_LEP_Information	\N	51	30	\N	\N	\N
37	Behandlung_LEP_Zeitstrahl	Behandlung_LEP_Zeitstrahl	\N	52	30	\N	\N	\N
38	Behandlung_Typ	Typ der Behandlung	\N	34	30	\N	\N	\N
39	Behandlung_Druckstatus	Status des Ausdrucks	\N	3	30	\N	\N	\N
41	Behandlungsort_Name	Name des Behandlungsortes	\N	3	40	\N	\N	\N
42	Behandlungsort_Zentralplatz	Der Behandlungsort ist kein Bettplatz	\N	2	40	\N	\N	\N
51	Belegung_von	Anfangszeitpunkt der Belegung eines Behandlungsortes	\N	5	50	\N	\N	\N
52	Belegung_bis	Endzeitpunkt der Belegung eines Behandlungsortes	\N	5	50	\N	\N	\N
53	Belegung_durch	Grund der Belegung eines Behandlungsortes	\N	15	50	\N	\N	\N
60	Medikamentenmischung	Medikamentenmischung	\N	16	1	\N	\N	\N
64	Medikamentenmischung_Vorschlagsrate	Rate der ersten Gabe. Ist die Rate 0, dann ist das Medikament diskontinuierlich.	\N	6	60	\N	\N	\N
67	Medikamentenmischung_Volumen	Gesamtvolumen der Mischung.	\N	6	60	\N	\N	\N
100008	Vormedikation	\N	\N	3	20	\N	\N	\N
68	Medikamentenmischung_COPRARang	DSer COPRArang der Mischung. Dieser ist gleich dem Rang des ersten Medikamentes in der Mischung.	\N	2	60	\N	\N	\N
69	Medikamentenmischung_Name	Name der Mischung. Dieser ergibt sich aus der Liste der Medikamente.	\N	3	60	\N	\N	\N
71	Medikamentengabe_VolumenRate	Volumenrate bei kontinuierlichen Medikamentengabe.	\N	6	70	\N	\N	\N
72	Medikamentengabe_Applikationsform	Form der Gabe.	\N	3	70	\N	\N	\N
73	Medikamentengabe_Menge	Menge bei diskontinuierlichen Medikamentengaben.	\N	6	70	\N	\N	\N
74	Medikamentengabe_DateTimeTo	Zeitpunkt der Medikamentengabe	\N	5	70	\N	\N	\N
77	Medikamentengabe_Einheit	Einheit des Medikamentengabe-Objektes	\N	3	70	\N	\N	\N
78	Medikamentengabe_Wirkstoff_Name	Name des Wirkstoffes, auf den sich die Gabe bezieht. Wird für den Event "Schnelle Medikamentengabe V2" benötigt.	\N	3	70	\N	\N	\N
81	Organisationseinheit_Name	Name der Organisationseinheit	\N	3	80	\N	\N	\N
82	Organisationseinheit_Beschreibung	Beschreibung der Organisationseinheit	\N	3	80	\N	\N	\N
83	Gerätedaten-Schreibintervall	Automatendaten werden in diesem Intervall an den Patienten geschrieben	\N	2	80	\N	\N	\N
100	Laborwert	\N	\N	18	1	\N	\N	\N
110	Zuordnung	Zuordnung Ort zu Organisationseinheit	\N	1	80	\N	\N	\N
111	Zuordnung_von	Zuordnung Beginn	\N	5	110	\N	\N	\N
112	Zuordnung_bis	Zuordnung Ende	\N	5	110	\N	\N	\N
113	Zuordnung_Ort	Zuordnung Link auf Ort	\N	15	110	\N	\N	\N
121	Computer_Name	Name des Clients (Workstation)	\N	3	120	\N	\N	\N
122	Computer_Behandlungsort	Zuordnung Computer zu Behandlungsort	\N	15	120	\N	\N	\N
123	Computer_Zugeordneter_Drucker	Zuordnung Computer zu Drucker	\N	3	120	\N	\N	\N
124	Computer_Berechtigung	Wert wird bei die Berechtigungsfunktion 'Unbegrenzter Zeitraum, wenn Computerberechtigung' verwendet. Wert ungleich 0, dann gesetzt.	\N	2	120	\N	\N	\N
144	Medikamente_gestellt_pro_Tag	Information über gestellte Medikamente pro Tag	\N	3	1	\N	\N	\N
171	COPRA_Leistungen	Leistungsobjekt	\N	1	0	\N	\N	\N
172	COPRA_Leistungen_ExtLeistungsID	ExtLeistungsID	\N	3	171	\N	\N	\N
173	COPRA_Leistungen_Leistungstext	Leistungstext	\N	3	171	\N	\N	\N
174	COPRA_Leistungen_ExtMaterialNr	ExtMaterialNr	\N	3	171	\N	\N	\N
175	COPRA_Leistungen_Einrichtung	Einrichtung	\N	3	171	\N	\N	\N
176	COPRA_Leistungen_LeistKlasse	Leistungsklasse	\N	3	171	\N	\N	\N
177	COPRA_Leistungen_ExtNR	Extetrne Nummer	\N	3	171	\N	\N	\N
178	COPRA_Leistungen_ExtNRSchweiz	Extetrne Nummer Schweiz	\N	3	171	\N	\N	\N
179	COPRA_Leistungen_EANNR	EANNR	\N	3	171	\N	\N	\N
180	COPRA_Leistungen_Gueltig_ab	Leistung gueltig ab	\N	5	171	\N	\N	\N
181	COPRA_Leistungen_Gueltig_bis	Leistung gueltig bis	\N	5	171	\N	\N	\N
182	COPRA_Leistungen_Loeschen_am	Leistung loeschen am	\N	5	171	\N	\N	\N
183	COPRA_Leistungen_Leistungstyp	Leistungstyp	\N	3	171	\N	\N	\N
184	COPRA_Leistungen_AbrechnungStationaer	Abrechnung-Stationaer	\N	2	171	\N	\N	\N
185	COPRA_Leistungen_AbrechnungAmbulant	Abrechnung-Ambulant	\N	2	171	\N	\N	\N
186	COPRA_Leistungen_TextAbweichungErlaubt	Textabweichung erlaubt	\N	2	171	\N	\N	\N
187	COPRA_Leistungen_LeistungEinheit	Leistungseinheit	\N	3	171	\N	\N	\N
188	COPRA_Leistungen_FlagHauskatalog	Flag-Hauskatalog	\N	2	171	\N	\N	\N
189	COPRA_Leistungen_BasisMengenEinheit	Basis-Mengeneinheit	\N	3	171	\N	\N	\N
190	COPRA_Leistungen_EinzelabgabeMoeglich	Einzelabgabe moeglich	\N	2	171	\N	\N	\N
191	COPRA_Leistungserbringer	Leistungserbringer-Objekt	\N	1	0	\N	\N	\N
192	COPRA_Leistungserbringer_ExtLeisterbringerID	ExtLeisterbringerID	\N	3	191	\N	\N	\N
193	COPRA_Leistungserbringer_Nachname	Nachname	\N	3	191	\N	\N	\N
194	COPRA_Leistungserbringer_Vorname	Vorname	\N	3	191	\N	\N	\N
195	COPRA_Leistungserbringer_Titel	Titel	\N	3	191	\N	\N	\N
196	COPRA_Leistungserbringer_Anrede	Anrede	\N	3	191	\N	\N	\N
197	COPRA_Leistungserbringer_Mitarbeitertyp	Mitarbeitertyp	\N	3	191	\N	\N	\N
198	COPRA_Leistungserbringer_Geschlecht	Geschlecht	\N	3	191	\N	\N	\N
199	COPRA_Leistungserbringer_Geburtsdatum	Geburtsdatum	\N	5	191	\N	\N	\N
200	COPRA_Leistungserbringer_Sprache	Sprache	\N	3	191	\N	\N	\N
201	COPRA_Leistungserbringer_Telefonnummer	Telefonnummer	\N	3	191	\N	\N	\N
202	COPRA_Leistungserbringer_Strasse	Strasse	\N	3	191	\N	\N	\N
203	COPRA_Leistungserbringer_PLZ	PLZ	\N	3	191	\N	\N	\N
204	COPRA_Leistungserbringer_Ort	Ort	\N	3	191	\N	\N	\N
205	COPRA_Leistungserbringer_Land	Land	\N	3	191	\N	\N	\N
206	COPRA_Leistungserbringer_EMail	EMail	\N	3	191	\N	\N	\N
207	COPRA_Leistungserbringer_Vertretung	Vertretung	\N	3	191	\N	\N	\N
208	COPRA_Leistungserbringer_Aktiv	Aktiv	\N	3	191	\N	\N	\N
209	COPRA_Leistungserbringer_Gueltig_ab	Leistungserbringer gueltig ab	\N	5	191	\N	\N	\N
210	COPRA_Leistungserbringer_Gueltig_bis	Leistungserbringer gueltig bis	\N	5	191	\N	\N	\N
211	COPRA_Leistungserbringer_Dienststellung	Dienststellung	\N	3	191	\N	\N	\N
220	Patient_Archivdruck	Archivdruck	\N	1	1	\N	\N	\N
221	Patient_Archivdruck_Pfad	Archivdruck-Pfad	\N	3	220	\N	\N	\N
222	Patient_Archivdruck_Hash	Archivdruck-Hash	\N	3	220	\N	\N	\N
223	Patient_Archivdruck_Hashalgorithmus	Archivdruck-Hashalgorithmus	\N	3	220	\N	\N	\N
224	Patient_Archivdruck_Beginn	Archivdruck-Beginn	\N	5	220	\N	\N	\N
225	Patient_Archivdruck_Ende	Archivdruck-Ende	\N	5	220	\N	\N	\N
226	Patient_Archivdruck_Intervall	Archivdruck-Intervall	\N	2	220	\N	\N	\N
102442	TabelleAerzteMassnahBildKonsilDokumentation	\N	\N	3	102438	\N	\N	Arzt - Maßn, Diag, Bild, Kons (Dokumentation)
100005	Diagnostizierender	Person die die Diagnose erhoben hat	\N	3	1278	\N	\N	\N
102443	TabelleAerzteMassnahBildKonsilDurchgefuertVon	\N	\N	3	102438	\N	\N	Arzt - Maßn, Diag, Bild, Kons (eingetragen von)
102444	Darm	\N	\N	21	1	\N	\N	\N
102445	Darm_Groesse	\N	\N	3	102444	\N	\N	Darmentleerung (Größe)
102446	Darm_Lage	\N	\N	3	102444	\N	\N	Darmentleerung (Lage)
102447	Darm_Typ	\N	\N	3	102444	\N	\N	Darmentleerung (Typ)
102451	Darm_Wert	\N	\N	25	102444	\N	\N	\N
102452	Darm_Beobachtung	\N	\N	3	102451	\N	\N	Darm (Beobachtung)
102453	Darm_Pflege	\N	\N	3	102451	\N	\N	Darm (Pflege)
102454	Darm_MengeMl	\N	\N	6	102451	\N	\N	\N
102455	Darm_SekretBeobachtung	\N	\N	3	102451	\N	\N	Darm (Stuhlbeschaffenheit)
227	Patient_Archivdruck_Container	Archivdruck-Container	\N	3	220	\N	\N	\N
228	Patient_Archivdruck_ContainerVersion	Archivdruck-ContainerVersion	\N	3	220	\N	\N	\N
229	Patient_Archivdruck_Fehlernachricht	Archivdruck-Fehlernachricht	\N	3	220	\N	\N	\N
230	Patient_Archivdruck_Druckdatum	Archivdruck-Druckdatum	\N	5	220	\N	\N	\N
602	COPRA_Pflege_Symptom	\N	\N	44	600	\N	\N	\N
603	COPRA_Pflege_Ressource	\N	\N	44	600	\N	\N	\N
604	COPRA_Pflege_Faktor	\N	\N	44	600	\N	\N	\N
605	COPRA_Pflege_Ziel	\N	\N	42	600	\N	\N	\N
606	COPRA_Pflege_Etappenziel	\N	\N	42	605	\N	\N	\N
607	COPRA_Pflege_Intervention	\N	\N	43	30	\N	\N	\N
608	COPRA_Pflege_Intervention_Link	\N	\N	47	600	\N	\N	\N
609	COPRA_Pflege_Ziel_Intervention_Link	\N	\N	47	605	\N	\N	\N
610	COPRA_Pflege_Etappenziel_Intervention_Link	\N	\N	47	606	\N	\N	\N
620	COPRA_Pflege_Ziel_Evaluierung	\N	\N	46	605	\N	\N	\N
621	COPRA_Pflege_Etappenziel_Evaluierung	\N	\N	46	606	\N	\N	\N
630	COPRA_Pflege_Intervention_Durchführung	\N	\N	45	607	\N	\N	\N
631	COPRA_Pflege_Intervention_Unterbrechung	\N	\N	48	607	\N	\N	\N
104390	AT_Waermematte	\N	\N	2	30	\N	\N	\N
650	CO6_Filter_ToDo	Transientes Objekt für Filterkriterien	\N	37	0	\N	\N	\N
651	CO6_Filter_ToDo_Beginn	Filtervariable für ein Beginndatum	\N	5	650	\N	\N	\N
652	CO6_Filter_ToDo_Dauer	Filtervariable für die Dauer in Stunden	\N	2	650	\N	\N	\N
670	COPRA_Pflege_Fall	\N	\N	41	20	\N	\N	\N
671	COPRA_Pflege_Fall_Ätiologie	\N	\N	44	670	\N	\N	\N
672	COPRA_Pflege_Fall_Symptom	\N	\N	44	670	\N	\N	\N
673	COPRA_Pflege_Fall_Ressource	\N	\N	44	670	\N	\N	\N
674	COPRA_Pflege_Fall_Faktor	\N	\N	44	670	\N	\N	\N
675	COPRA_Pflege_Fall_Ziel	\N	\N	42	670	\N	\N	\N
676	COPRA_Pflege_Fall_Etappenziel	\N	\N	42	675	\N	\N	\N
677	COPRA_Pflege_Fall_Intervention	\N	\N	43	20	\N	\N	\N
678	COPRA_Pflege_Fall_Intervention_Link	\N	\N	47	670	\N	\N	\N
679	COPRA_Pflege_Fall_Ziel_Intervention_Link	\N	\N	47	675	\N	\N	\N
680	COPRA_Pflege_Fall_Etappenziel_Intervention_Link	\N	\N	47	676	\N	\N	\N
681	COPRA_Pflege_Fall_Ziel_Evaluierung	\N	\N	46	675	\N	\N	\N
682	COPRA_Pflege_Fall_Etappenziel_Evaluierung	\N	\N	46	676	\N	\N	\N
683	COPRA_Pflege_Fall_Intervention_Durchführung	\N	\N	45	677	\N	\N	\N
684	COPRA_Pflege_Fall_Intervention_Unterbrechung	\N	\N	48	677	\N	\N	\N
1000	Zusatzinfo	Variable kann als Attribut verwendet werden	\N	3	0	\N	\N	\N
1001	Referenz	Variable kann als Attribut verwendet werden	\N	15	0	\N	\N	\N
1258	CO_Behandlung_MergeSource	Verweis von der Ziel-Behandlung auf die Quell-Behandlung einer Zusammenführung	\N	53	30	\N	\N	\N
1259	CO_Behandlung_MergeTarget	Verweis von der Quell-Behandlung auf die Ziel-Behandlung einer Zusammenführung	\N	54	30	\N	\N	\N
1266	HF	Herzfrequenz	1/min	6	1	\N	\N	\N
1267	AF	Atemfrequenz	1/min	6	1	\N	\N	\N
1268	Puls	Puls	1/min	6	1	\N	\N	\N
1269	ZVD	Zentralvenöser Druck	mmHg	6	1	\N	\N	\N
1270	T_K	Körpertemperatur	°C	6	1	\N	\N	\N
1271	T_K2	Körpertemperatur Messkanal 2	°C	6	1	\N	\N	\N
1272	SO2	Sauerstoffsättigung	%	6	1	\N	\N	\N
1273	SaO2	arterielle Sauerstoffsättigung	%	6	1	\N	\N	\N
1274	SvO2	venöse Sauerstoffsättigung	%	6	1	\N	\N	\N
1275	NBP	nichtinvasiver Blutdruck	mmHg	12	1	\N	\N	\N
1276	ABP	arterielle Blutdruck	mmHg	12	1	\N	\N	\N
1277	Risiko_ASA	ASA-Klassifikation (Behandlungsrisiko)	\N	2	30	\N	\N	\N
1278	Diagnose	Diagnosen des Patienten	\N	1	20	\N	\N	\N
1282	Diagnose_Erhebungszeitpunkt	Erhebungszeitpunkt der Diagnose	\N	5	1278	\N	\N	\N
1284	Lagerung	\N	\N	3	1	\N	\N	\N
1298	Mitarbeiter	Liste der medizinisch/pflegerischen Fachkräfte	\N	23	0	\N	\N	\N
1299	Mitarbeiter_Name	Familienname des Mitarbeiters	\N	3	1298	\N	\N	\N
102540	VerlPfl_verlegt_am	\N	\N	3	30	\N	\N	\N
102546	TabelleVerlaufPtErgoLogo	\N	\N	1	30	\N	\N	\N
102547	TabelleVerlaufPtErgoLogo_Bereich	\N	\N	3	102546	\N	\N	Physioth/Ergoth/Logop (Bereich)
102548	TabelleVerlaufPtErgoLogo_Gruppe	\N	\N	3	102546	\N	\N	Physioth/Ergoth/Logop (Gruppe)
102549	TabelleVerlaufPtErgoLogo_Dokumentation	\N	\N	3	102546	\N	\N	Physioth/Ergoth/Logop (Dokumentation)
102550	TabelleVerlaufPtErgoLogo_VerantwortlicherMitarbeit	\N	\N	3	102546	\N	\N	Physioth/Ergoth/Logop (Mitarbeiter)
102524	Datum	\N	\N	5	102523	\N	\N	\N
1300	Mitarbeiter_Vorname	Vorname des Mitarbeiters	\N	3	1298	\N	\N	\N
1301	Mitarbeiter_Titel	Titel des Mitarbeiters	\N	3	1298	\N	\N	\N
1316	NYHA	NYHA-Kalassifikation für Anaesthesie	\N	2	1	\N	\N	\N
1343	Behandlung_Praemedikation	Verweis auf die für diese Behandlung gültige Prämedikation	\N	15	30	\N	\N	\N
1442	Konservennummer	Chargen-Nummer der Blutkonserve	\N	3	0	\N	\N	\N
100042	TISS28_TS_InotropikaGabe	\N	\N	27	100000	\N	\N	\N
100002	GCS_CHILD	\N	\N	1	30	\N	\N	\N
100003	Massnahmen	\N	\N	1	20	\N	\N	\N
100009	Besonderheiten	\N	\N	3	20	\N	\N	\N
100010	Massnahmen_Nr.	Nummer der Massnahme	\N	3	100003	\N	\N	\N
100011	Massnahmen_Eintrag	\N	\N	3	100003	\N	\N	\N
100012	Massnahmen_Code	\N	\N	3	100003	\N	\N	\N
100013	Massnahmen_Arzt	\N	\N	3	100003	\N	\N	\N
100014	Massnahmen_Typ	\N	\N	3	100003	\N	\N	\N
100015	Massnahmen_Dok.-Zeit	Dokumentationszeit	\N	17	100003	\N	\N	\N
100016	GCS_CHILD_Motorik	\N	\N	27	100002	\N	\N	\N
100018	GCS_ADULT_Augen	\N	\N	27	100001	\N	\N	\N
100019	GCS_ADULT_Sprache	\N	\N	27	100001	\N	\N	\N
100020	GCS_CHILD_Sprache	\N	\N	27	100002	\N	\N	\N
100021	GCS_CHILD_Wert	\N	\N	2	100002	\N	\N	\N
100022	GCS_CHILD_Augen	\N	\N	27	100002	\N	\N	\N
100023	Patient_Strasse	Adresse des Patienten: Strasse + Hausnummer	\N	3	1	\N	\N	\N
100024	Patient_Nationalitaet	Nationalität des Patienten	\N	3	1	\N	\N	\N
100025	Verlegung_wo	Der Patient wurde 'wohin?' verlegt? 	\N	3	1	\N	\N	\N
100026	Patient_Organspenderausweis	hat der Patient einen Organspenderausweis?	\N	3	1	\N	\N	\N
100027	Patient_Verfuegung	Patientenverfügung	\N	3	1	\N	\N	\N
100030	Betreuer_Anschrift	Anschrift des Patientenbetreuers	\N	3	1	\N	\N	\N
100036	Patient_Telefon	Telefonnummer des Patienten	\N	3	1	\N	\N	\N
100037	akt._Schwangerschaftwoche	aktuelle Schwangerschaftswoche des Babys	\N	6	1	\N	\N	\N
100038	Schwangerschaftswoche	Schwangerschaftswoche, in welcher das Baby geboren wurde	\N	6	1	\N	\N	\N
100041	TISS28_TS_Tubuspflege	\N	\N	27	100000	\N	\N	\N
100044	TISS28_TS_InterventionAufICU	\N	\N	27	100000	\N	\N	\N
100045	TISS28_TS_artKatheter	\N	\N	27	100000	\N	\N	\N
100046	TISS28_TS_intravFluessTh	\N	\N	27	100000	\N	\N	\N
100047	TISS28_TS_ICPMessung	\N	\N	27	100000	\N	\N	\N
100048	TISS28_TS_mediNierenunterstützung	\N	\N	27	100000	\N	\N	\N
100049	TISS28_TS_Bilanzierung	\N	\N	27	100000	\N	\N	\N
100050	TISS28_TS_extrakorpNierenersatz	\N	\N	27	100000	\N	\N	\N
100051	TISS28_TS_enteraleErn	\N	\N	27	100000	\N	\N	\N
100052	TISS28_TS_parentErnaehrung	\N	\N	27	100000	\N	\N	\N
100053	TISS28_TS_AzidoseAlkalose	\N	\N	27	100000	\N	\N	\N
100054	TISS28_TS_TransIntensivP	\N	\N	27	100000	\N	\N	\N
100055	TISS28_TS_ReanimationDefibr	\N	\N	27	100000	\N	\N	\N
100056	TISS28_TS_zentralvZugang	\N	\N	27	100000	\N	\N	\N
100057	TISS28_TS_erweitHaemoynMonit	\N	\N	27	100000	\N	\N	\N
100058	TISS28_TS_StandMonit	\N	\N	27	100000	\N	\N	\N
100059	TISS28_TS_Beatmung	\N	\N	27	100000	\N	\N	\N
100060	TISS28_TS_Routineverbandwechsel	\N	\N	27	100000	\N	\N	\N
100061	TISS28_TS_Drainagenpflege	\N	\N	27	100000	\N	\N	\N
100062	TISS28_TS_Medikamentengabe	\N	\N	27	100000	\N	\N	\N
100063	TISS28_TS_VerbesserungLufu	\N	\N	27	100000	\N	\N	\N
100064	TISS28_TS_LaborMidi	\N	\N	27	100000	\N	\N	\N
100065	Allergie	\N	\N	3	1	\N	\N	\N
100066	OP-Tag	OP-Tag	\N	6	1	\N	\N	\N
100067	Klinik	Auswahl der Kliniken	\N	3	1	\N	\N	\N
100068	EVLW/EV	Extravasales Lungenwasser	\N	6	1	\N	\N	\N
100069	ITBV	Intrathorakales Blutvolumen	\N	6	1	\N	\N	\N
100070	SVV	Schlagvolumenabweichung 	%	6	1	\N	\N	\N
100072	CI	Herzindex	l/min/m2	6	1	\N	\N	\N
100073	SVRI	Index des systemischen Gefäßwiderstandes 	dynes x sek/cm-5/m2	6	1	\N	\N	\N
100074	SVR	Systemischer Gefäßwiderstand	dynes x sek/cm-5	6	1	\N	\N	\N
100075	HZVGeraet_Auswahl	\N	\N	26	1	\N	\N	\N
100076	IABP_Auswahl	\N	\N	26	1	\N	\N	\N
100077	SM_AV_Intervall	Schrittmacher AV-Intervall	ms	6	1	\N	\N	\N
100078	SM_Frequenz	Schrittmacher Frequenz	1/min	6	1	\N	\N	\N
100079	SM_Empfindlichkeit	Schrittmacher Empfindlichkeit	mV	6	1	\N	\N	\N
100080	SM-Output_Ventrikel	Schrittmacher Ausgangsleistung (Output) Ventrikel	mA	6	1	\N	\N	\N
100081	SM_Output_Atrium	Schrittmacher Ausgangsleistung (Output) Atrium	mA	6	1	\N	\N	\N
100082	SM-Draehte	Schrittmacherdrähte	\N	3	1	\N	\N	\N
100083	SM_Modus	Schrittmachermodus	\N	3	1	\N	\N	\N
100084	SM_Art	Schrittmacher Art	\N	3	1	\N	\N	\N
100085	Pacergeräte_Balken	\N	\N	26	1	\N	\N	\N
100086	CPP	Zerebraler Perfusionsdruck	mmHg	6	1	\N	\N	\N
100088	ICP	Intrakranialer Druck	mmHg	6	1	\N	\N	\N
100089	ABP_2	zweiter arterieller Blutdruck	mmHg	12	1	\N	\N	\N
100090	NBP_2	zweiter nichtinvasiver Blutdruck 	mmHg	12	1	\N	\N	\N
100091	LAP	Linksatrial  Mitteldruck	mmHg	6	1	\N	\N	\N
100092	Ereignisse Vitlaparameter Graphisch	Ereignisse Vitlaparameter Graphisch als Listenauswahl	\N	3	1	\N	\N	\N
100093	ABP_1	arterieller Blutdruck 1	mmHg	12	1	\N	\N	\N
100095	Herzrhythmus	Herzrhythmus	\N	3	1	\N	\N	\N
100096	Beatmung_Messung_VTeMl	VTe / ex. Atemzugvolumen (Tidal Volumen expir.)	ml	6	1	\N	\N	\N
100097	Beatmung_Messung_MVSpontan	Mindest Volumen sp	L/min	6	1	\N	\N	\N
100098	Beatmung_Messung_MV	Mindest Volumen tot.	L/min	6	1	\N	\N	\N
100099	Beatmung_Messung_Frequenz	Frequenz tot.	1/min	6	1	\N	\N	\N
100100	Beatmung_Messung_FiO2	FiO2	%	6	1	\N	\N	\N
100101	Beatmung_Einstellung_VT	Atemzugvolumen/Atemhubvolumen [Tidal volume] (VT)	ml	6	1	\N	\N	\N
100102	Beatmung_Einstellung_PEEP	Positiver endexspiratorischer Druck (PEEP)	mbar	6	1	\N	\N	\N
100103	Beatmung_Einstellung_I:E	Atemzeitverhältnis (I:E)	\N	6	1	\N	\N	\N
100104	Beatmung_Einstellung_Flow	Inspiratorische Flowrate	l/min	6	1	\N	\N	\N
100105	Beatmung_Einstellung_FiO2	O²- Konzentration im Inspirationsgemisch (FiO2)	%	6	1	\N	\N	\N
100106	Beatmung_Einstellung_ASB	Inspiratorische Druckunterstützung [inspiratory pressure support] (IPS) bzw. assisted spontaneuous breathig (ASB)	mbar	6	1	\N	\N	\N
100107	Beatmung_Einstellung_AMV	Atemminutenvolumen (AMV)	l/min.	6	1	\N	\N	\N
100108	Beatmung_Einstellung_AF	Beatmungsfrequenz (f/AF)	1/min	6	1	\N	\N	\N
100109	Beatmung_Einstellung_Balken	\N	\N	26	1	\N	\N	\N
100110	Beatmung_Anordnung_VT	Anordnung Atemzugvolumen/Atemhubvolumen [Tidal volume] (VT)	ml	6	1	\N	\N	\N
100111	Beatmung_Anordnung_PEEP	Anordnung Positiver endexspiratorischer Druck (PEEP)	mbar	6	1	\N	\N	\N
100112	Beatmung_Anordnung_I:E	Anordnung Atemzeitverhältnis (I:E)	\N	6	1	\N	\N	\N
100113	Beatmung_Anordnung_Flow	Anordnung Inspiratorische Flowrate	l/min	6	1	\N	\N	\N
100115	Beatmung_Anordnung_ASB	Anordnung Inspiratorische Druckunterstützung [inspiratory pressure support] (IPS) bzw. assisted spontaneuous breathig (ASB)	mbar	6	1	\N	\N	\N
100116	Beatmung_Anordnung_AMV	Anordnung Atemminutenvolumen (AMV)	l/min.	6	1	\N	\N	\N
100117	Beatmung_Anordnung_AF	Anordnung Beatmungsfrequenz (f/AF)	1/min	6	1	\N	\N	\N
100118	Beatmung_Anordnung_BV	beatmungs-Verordung	\N	3	1	\N	\N	\N
100119	Beatmung_Anordnung_Balken	\N	\N	26	1	\N	\N	\N
100128	Beatmung_Anordnung_FiO2	Anordnung O² Konzentration im Inspirationsgemisch (FiO2)	%	6	1	\N	100114	\N
100131	Zugaenge	\N	\N	21	1	\N	\N	\N
100132	Atemwege	\N	\N	21	1	\N	\N	\N
100133	Enteralesonden	\N	\N	21	1	\N	\N	\N
100134	HarnwegeDarm	\N	\N	21	1	\N	\N	\N
100135	Drainagen	\N	\N	21	1	\N	\N	\N
100150	Atemwege_Wert	\N	\N	25	100132	\N	\N	\N
100156	Drainagen_gelegt_am	\N	\N	5	100135	\N	\N	\N
100157	Drainagen_Wert	\N	\N	25	100135	\N	\N	\N
100163	Enteralesonden_Lage	\N	\N	3	100133	\N	\N	\N
100164	Enteralesonden_gelegt_am	\N	\N	5	100133	\N	\N	\N
100165	Enteralesonden_Wert	\N	\N	25	100133	\N	\N	\N
100171	HarnwegeDarm_gelegt_am	\N	\N	5	100134	\N	\N	\N
100172	HarnwegeDarm_Wert	\N	\N	25	100134	\N	\N	\N
100179	Zugaenge_Wert	\N	\N	25	100131	\N	\N	\N
100180	Zugaenge_Wert_Num	\N	\N	6	100179	\N	\N	\N
100183	Dekubitus_Ort	\N	\N	3	100182	\N	\N	\N
100184	Dekubitus_Grad	\N	\N	3	100182	\N	\N	\N
100185	Dekubitus_ErstesAuftreten	\N	\N	5	100182	\N	\N	\N
100186	Dekubitus_Wert	\N	\N	25	100182	\N	\N	\N
100192	Wunddokumentation_ErstesAuftreten	\N	\N	5	100189	\N	\N	\N
100193	Wunddokumentation_Wert	\N	\N	25	100189	\N	\N	\N
100194	Wunddokumentation_Wert_Num	\N	\N	6	100193	\N	\N	\N
100196	Zugaenge_gelegt_am	\N	\N	5	100131	\N	\N	\N
100199	Verlauf_Pflege	\N	\N	3	1	\N	\N	\N
100202	Verlauf_Arzt	\N	\N	3	1	\N	\N	\N
100203	Verlauf_PT	\N	\N	3	1	\N	\N	\N
100204	Verlauf_Konsil	\N	\N	3	1	\N	\N	\N
100233	Beatmung_Einstellung_Okklusiondruck	\N	mbar	6	1	\N	\N	\N
100234	Beatmung_Einstellung_PAW	\N	mbar	6	1	\N	\N	\N
100235	Beatmung_Einstellung_Druckanstieg	\N	sek	6	1	\N	\N	\N
100236	Beatmung_Einstellung_PASB	\N	mbar	6	1	\N	\N	\N
100237	Beatmung_Einstellung_FlowAssist	\N	mbar/L/s	6	1	\N	\N	\N
100238	Beatmung_Einstellung_VolAssist	\N	mbar/L	6	1	\N	\N	\N
100239	Beatmung_Einstellung_TApnoe	\N	sek	6	1	\N	\N	\N
100240	Beatmung_Einstellung_Pinsp	Oberer Druckniveau	mbar	6	1	\N	\N	\N
100242	Beatmung_Einstellung_AutoTubuskompentationEin	\N	%	6	1	\N	\N	\N
100243	Beatmung_Einstellung_AutoTubuskompentationAus	\N	\N	6	1	\N	\N	\N
100245	Beatmung_Einstellung_Biasflow	\N	l/min	6	1	\N	\N	\N
102703	UeberwiesenVonFOE	\N	\N	3	30	\N	\N	\N
100246	Beatmung_Einstellung_CPAP	\N	mbar	6	1	\N	\N	\N
100247	Beatmung_Einstellung_DruckHoch	\N	cmH2o	6	1	\N	\N	\N
100248	Beatmung_Einstellung_DruckNiedrig	\N	cmH2O	6	1	\N	\N	\N
100249	Beatmung_Einstellung_FlowTrigger	\N	l/min	6	1	\N	\N	\N
100250	Beatmung_Einstellung_FrequenzHFOV	HFOV Frequenz	Hz	6	1	\N	\N	\N
100251	Beatmung_Einstellung_idealesKoerpergewicht	\N	KG	6	1	\N	\N	\N
100253	Beatmung_Einstellung_IMVFrequenz	\N	1/min	6	1	\N	\N	\N
100254	Beatmung_Einstellung_Inspirationszeit	Inspirationszeit in %	%	6	1	\N	\N	\N
100257	Beatmung_Einstellung_InspiratorischePause	Inspiratorische Pause (I:E)	sec:sec	6	1	\N	\N	\N
100258	Beatmung_Einstellung_intermPEEP	Interm PEEP	mbar	6	1	\N	\N	\N
100259	Beatmung_Einstellung_IPPVFrequenz	\N	1/min	6	1	\N	\N	\N
100261	Beatmung_Einstellung_Leistung	\N	DeltaP-cmH2O	6	1	\N	\N	\N
100262	Beatmung_Einstellung_MitteldruckHFOV	HFOV Mitteldruck	Paw-cmH2O	6	1	\N	\N	\N
100263	Beatmung_Einstellung_Peakflow	\N	l/min	6	1	\N	\N	\N
100264	Beatmung_Einstellung_Pmax	Pmax, Maximaldruck	mbar	6	1	\N	\N	\N
100265	Beatmung_Einstellung_Power	HFOV Powereinstellung	Watt	6	1	\N	\N	\N
100267	Beatmung_Einstellung_PSV	\N	cmH2O	6	1	\N	\N	\N
100268	Beatmung_Einstellung_ZeitHoch	\N	sec	6	1	\N	\N	\N
100269	Beatmung_Einstellung_ZeitNiedrig	\N	sec	6	1	\N	\N	\N
100270	Beatmung_Messung_AFSpontan	Respiratory Rate (spontan)	1/min	6	1	\N	\N	\N
100271	Beatmung_Messung_AMV	Respiratory Minute Volume	L/min	6	1	\N	\N	\N
100272	Beatmung_Messung_ASB	\N	mbar	6	1	\N	\N	\N
100273	Beatmung_Messung_Flow	Respiratory Rate (Volume/Flow)	1/min	6	1	\N	\N	\N
100274	Beatmung_Messung_IE	\N	\N	6	1	\N	\N	\N
100275	Beatmung_Messung_PEEP	\N	mbar	6	1	\N	\N	\N
100276	Beatmung_Messung_VTeL	\N	L	6	1	\N	\N	\N
100278	Beatmung_Messung_CPAP	\N	mbar	6	1	\N	\N	\N
100279	Beatmung_Messung_AutoTubuskompentationAus	\N	\N	6	1	\N	\N	\N
100280	Beatmung_Messung_AutoTubuskompentationEin	\N	%	6	30	\N	\N	\N
100281	Beatmung_Messung_Biasflow	\N	l/min	6	1	\N	\N	\N
100282	Beatmung_Messung_Druckanstieg	\N	sek	6	1	\N	\N	\N
100283	Beatmung_Messung_DruckHoch	\N	cmH2O	6	1	\N	\N	\N
100284	Beatmung_Messung_DruckNiedrig	\N	cmH2O	6	1	\N	\N	\N
100285	Beatmung_Messung_FlowAssist	\N	l/min	6	1	\N	\N	\N
100286	Beatmung_Messung_FlowTrigger	\N	l/min	6	1	\N	\N	\N
100287	Beatmung_Messung_AFKontrol	\N	Hz	6	1	\N	\N	\N
100288	Beatmung_Messung_IMVFrequenz	\N	1/min	6	1	\N	\N	\N
100289	Beatmung_Messung_Inspirationszeit	\N	%	6	1	\N	\N	\N
100290	Beatmung_Messung_InspirationszeitI:E	\N	sec:sec	6	1	\N	\N	\N
100291	Beatmung_Messung_InspiratorischePause	\N	sec:sec	6	1	\N	\N	\N
100292	Beatmung_Messung_intermPEEP	\N	mbar	6	1	\N	\N	\N
100293	Beatmung_Messung_IPPVFrequenz	\N	1/min	6	1	\N	\N	\N
100294	Beatmung_Messung_Leistung	\N	DeltaP-cmH2O	6	1	\N	\N	\N
100295	Beatmung_Messung_MitteldruckHFOV	\N	Paw-cmH2O	6	1	\N	\N	\N
100296	Beatmung_Messung_Okklussionsdruck	\N	mbar	6	1	\N	\N	\N
100297	Beatmung_Messung_PASB	\N	mbar	6	1	\N	\N	\N
100298	Beatmung_Messung_Peakflow	\N	l/min	6	1	\N	\N	\N
100299	Beatmung_Messung_Pinsp	\N	mbar	6	1	\N	\N	\N
100300	Beatmung_Messung_Pmax	Peak Airway Pressure	mmHg	6	1	\N	\N	\N
100301	Beatmung_Messung_Power	\N	Watt	6	1	\N	\N	\N
100302	Beatmung_Messung_PSV	\N	cmH2O	6	1	\N	\N	\N
100303	Beatmung_Messung_TApnoe	Apnea Duration	M:SS	6	1	\N	\N	\N
100304	Beatmung_Messung_VolAssist	\N	mbar/L	6	1	\N	\N	\N
100305	Beatmung_Messung_ZeitHoch	\N	sec	6	1	\N	\N	\N
100306	Beatmung_Messung_ZeitNiedrig	\N	sec	6	1	\N	\N	\N
100311	Dekubitus_Pflege	\N	\N	3	100186	\N	\N	\N
100312	Dekubitus_Beobachtung	\N	\N	3	100186	\N	\N	\N
100314	Dekubitus_Sekretmenge	\N	\N	3	100186	\N	\N	\N
100320	Dekubitus_VacWechsel	\N	\N	3	100186	\N	\N	\N
100321	Dekubitus_VacPflege	\N	\N	3	100186	\N	\N	\N
100322	Dekubitus_VacSog	\N	mmHg	6	100186	\N	\N	\N
100327	Drainagen_Sekretmenge	\N	\N	3	100157	\N	\N	\N
100334	Enteralesonden_Magenrestbestimmung	\N	\N	3	100165	\N	\N	\N
100336	HarnwegeDarm_IntraabdominalerDruck	\N	\N	3	100172	\N	\N	\N
100341	Wunddokumentation_Sekretmenge	\N	\N	3	100193	\N	\N	\N
100342	Wunddokumentation_VacSog	\N	\N	6	100193	\N	\N	\N
100343	Wunddokumentation_VacPflege	\N	\N	3	100193	\N	\N	\N
100344	Wunddokumentation_VacWechsel	\N	\N	3	100193	\N	\N	\N
100345	KlinikKopf	\N	\N	21	1	\N	\N	\N
100346	KlinikKopf_Gesichtshaut_Wert	\N	\N	25	100345	\N	\N	\N
100347	KlinikKopf_Gesichtshaut_Befragung	\N	\N	3	100346	\N	\N	\N
100348	KlinikKopf_Gesichtshaut_Inspektion	\N	\N	3	100346	\N	\N	\N
100349	KlinikKopf_Gesichtshaut_Verletzung	\N	\N	3	100346	\N	\N	\N
100350	KlinikKopf_Gesichtshaut_Allgemein	\N	\N	3	100346	\N	\N	\N
100356	Koerperpflege	\N	\N	21	1	\N	\N	\N
100357	Koerperpflege_Augen_Wert	\N	\N	25	100356	\N	\N	\N
100360	Bewegen_Bewegungen_Wert	\N	\N	25	100359	\N	\N	\N
100361	Bewegen_Bewegungen _Art	\N	\N	3	100360	\N	\N	\N
102764	Score_ARDS	\N	\N	1	1	\N	\N	\N
102771	Score_TISS10	\N	\N	1	1	\N	\N	\N
102787	Score_APACHE2	\N	\N	1	1	\N	\N	\N
102788	Score_Apgar	\N	\N	1	1	\N	\N	\N
102789	Score_BernerSchmerzscore	\N	\N	1	1	\N	\N	\N
102791	Score_BPS	\N	\N	1	1	\N	\N	\N
102794	Score_ComfortSkala	\N	\N	1	1	\N	\N	\N
100364	Koerperpflege_Nase_Wert	\N	\N	25	100356	\N	\N	\N
100368	Koerperpflege_Mund_Wert	\N	\N	25	100356	\N	\N	\N
100375	Koerperpflege_Haare_Wert	\N	\N	25	100356	\N	\N	\N
100378	Koerperpflege_Ohren_Wert	\N	\N	25	100356	\N	\N	\N
100381	Koerperpflege_Nabel_Wert	\N	\N	25	100356	\N	\N	\N
100384	Koerperpflege_Haut_Wert	\N	\N	25	100356	\N	\N	\N
100389	Koerperpflege_Waschen_Wert	\N	\N	25	100356	\N	\N	\N
100394	Koerperpflege_Betten_Wert	\N	\N	25	100356	\N	\N	\N
100396	Bewegen_Bewegungen_Kopf	\N	\N	3	100360	\N	\N	\N
100397	Bewegen_Bewegungen_Rumpf	\N	\N	3	100360	\N	\N	\N
100398	Bewegen_Bewegungen_Armre	\N	\N	3	100360	\N	\N	\N
100399	Bewegen_Bewegungen_Armli	\N	\N	3	100360	\N	\N	\N
100400	Bewegen_Bewegungen_Beinre	\N	\N	3	100360	\N	\N	\N
100401	Bewegen_Bewegungen_Beinli	\N	\N	3	100360	\N	\N	\N
100402	Bewegen_Bewegungen_Gelenke	\N	\N	3	100360	\N	\N	\N
100403	Bewegen_Bewegungen_Handre	\N	\N	3	100360	\N	\N	\N
100404	Bewegen_Bewegungen_Handli	\N	\N	3	100360	\N	\N	\N
100405	Bewegen_Bewegungen_Fussre	\N	\N	3	100360	\N	\N	\N
100406	Bewegen_Bewegungen_Fussli	\N	\N	3	100360	\N	\N	\N
100409	Bewegen_Bewegungen_Lagerungallgem	\N	\N	3	100360	\N	\N	\N
100414	Bewegen_Bewegungen_Bettensystem	\N	\N	3	100360	\N	\N	\N
100415	Bewegen_Bewegungen_Matraze	\N	\N	3	100360	\N	\N	\N
100418	Befinden	beinhaltet Ruhen und Schlafen, Befinden, Krampfanfälle, Sedierung, Schmerzdiagnose	\N	21	1	\N	\N	\N
100419	Befinden_Schlafen_Wert	\N	\N	25	100418	\N	\N	\N
100421	Befinden_NeurolStatus_Wert	\N	\N	25	100418	\N	\N	\N
100426	Befinden_Befinden_PupillenReaktionLi	\N	\N	3	100421	\N	\N	\N
100427	Befinden_Befinden_Pup_WeiteLi	\N	\N	3	100421	\N	\N	\N
100428	Befinden_Befinden_PupillenFormLi	\N	\N	3	100421	\N	\N	\N
100430	Befinden_Krampfanfall_Wert	\N	\N	25	100418	\N	\N	\N
102797	Score_Dubois	\N	\N	1	1	\N	\N	\N
102798	Score_GDS	\N	\N	1	1	\N	\N	\N
102799	Score_KarnofskyIndex	\N	\N	1	1	\N	\N	\N
102800	Score_Kuss	\N	\N	1	1	\N	\N	\N
102806	Score_NIHSS	\N	\N	1	1	\N	\N	\N
102808	Score_NORTON	\N	\N	1	1	\N	\N	\N
102832	Score_Barthel	\N	\N	1	1	\N	\N	\N
100434	Befinden_Schmerzen_Wert	\N	\N	25	100418	\N	\N	\N
100439	Befinden_Schmerzen_AnalgesieHoehe	\N	\N	3	100434	\N	\N	\N
100440	Befinden_Schmerzen_AnalgesieBeinbeweg	\N	\N	3	100434	\N	\N	\N
100441	Befinden_Schmerzen_AnalgesieBromage	\N	\N	3	100434	\N	\N	\N
100442	Befinden_Sedierung_Wert	\N	\N	25	100418	\N	\N	\N
100443	Befinden_Sedierung_Sedierung	\N	\N	3	100442	\N	\N	\N
100444	Befinden_Sedierung_RamseyScore	\N	\N	3	100442	\N	\N	\N
100445	Befinden_Sedierung_KomfortBSkala	\N	\N	3	100442	\N	\N	\N
100447	Ernaehren_Kostform_Wert	\N	\N	25	100446	\N	\N	\N
100449	Ernaehren_Kostform_Kinder	\N	\N	3	100447	\N	\N	\N
100458	Ernaehren_Ausscheiden_StuhlMenge	\N	\N	3	100453	\N	\N	\N
100459	Ernaehren_Ausscheiden_MagensaftAussehen	\N	\N	3	100453	\N	\N	\N
100461	Ernaehren_Ausscheiden_MagensaftMenge	\N	\N	3	100453	\N	\N	\N
100464	Ernaehren_Ausscheiden_ErbrechenMenge	\N	\N	3	100453	\N	\N	\N
100471	Sicherheit_Infektionsprophlaxe_Wert	\N	\N	25	100470	\N	\N	\N
100473	Sicherheit_MikrobioProbe_Wert	\N	\N	25	100470	\N	\N	\N
100475	Sicherheit_Propylaxen_Wert	\N	\N	25	100470	\N	\N	\N
100479	Sicherheit_Propylaxen_Sturzpropylaxe	\N	\N	3	100475	\N	\N	\N
100480	Sicherheit_Geraeteueberpruef_Wert	\N	\N	25	100470	\N	\N	\N
100486	Sicherheit_Geraeteueberpruef_Patientenplatz	\N	\N	3	100480	\N	\N	\N
100488	Sicherheit_Geraeteueberpruef_Notfallmedi	\N	\N	3	100480	\N	\N	\N
100492	KomfortBSkala	\N	\N	1	30	\N	\N	\N
100493	KomfortBSkala_Wert	\N	\N	2	100492	\N	\N	\N
100494	Sicherheit_Wechsel_Wert	\N	\N	25	100470	\N	\N	\N
100496	Sicherheit_Wechsel_AquaPak	\N	\N	3	100494	\N	\N	\N
100497	Sicherheit_Wechsel_KuenstlNase	\N	\N	3	100494	\N	\N	\N
100508	Sicherheit_Wechsel_TempSensorHaut	\N	\N	3	100494	\N	\N	\N
100509	Sicherheit_Wechsel_InfusionsystemEndstueck	\N	\N	3	100494	\N	\N	\N
102848	Score_Braden_Verlauf	\N	\N	1	1	\N	\N	\N
100510	Sicherheit_Wechsel_InfusionsystemKomplett	\N	\N	3	100494	\N	\N	\N
100511	Sicherheit_Wechsel_MSAblauf	\N	\N	3	100494	\N	\N	\N
100513	Sicherheit_Wechsel_BKSystem	\N	\N	3	100494	\N	\N	\N
100515	Sicherheit_Wechsel_PAKSystem	\N	\N	3	100494	\N	\N	\N
100516	Sicherheit_Wechsel_LAKSystem	\N	\N	3	100494	\N	\N	\N
100517	Sicherheit_Wechsel_HZVSystem	\N	\N	3	100494	\N	\N	\N
100518	Sicherheit_Wechsel_PDSystem	\N	\N	3	100494	\N	\N	\N
100519	Sicherheit_Wechsel_HFSystem	\N	\N	3	100494	\N	\N	\N
100520	Sicherheit_Wechsel_Pacerbatterie	\N	\N	3	100494	\N	\N	\N
100521	Sicherheit_Wechsel_ThoraydrainEinweg	\N	\N	3	100494	\N	\N	\N
100522	Sicherheit_Wechsel_Redonflasche	\N	\N	3	100494	\N	\N	\N
100524	PersoenlicheAspekte	\N	\N	21	1	\N	\N	\N
100525	PersoenlAspekte_Besucher_Wert	\N	\N	25	100524	\N	\N	\N
100527	PersoenlAspekte_Taufe_Wert	\N	\N	25	100524	\N	\N	\N
100529	PersoenlAspekte_Nottaufe_Wert	\N	\N	25	100524	\N	\N	\N
100531	PersoenlAspekte_Krankensalbung_Wert	\N	\N	25	100524	\N	\N	\N
100534	PT_Massnahme_Wert	\N	\N	25	100533	\N	\N	\N
100539	PT_Massnahmen_BewegungstherapieMasseure	\N	\N	3	100534	\N	\N	\N
100540	PT_Massnahmen_Dokumentation	\N	\N	3	100534	\N	\N	\N
100541	PT_Massnahmen_Elektrotherapie	\N	\N	3	100534	\N	\N	\N
100542	PT_Massnahmen_Gespräch	\N	\N	3	100534	\N	\N	\N
100544	PT_Massnahmen_Hydrotherapie	\N	\N	3	100534	\N	\N	\N
100545	PT_Massnahmen_InterdisziplinaereHilfestellung	\N	\N	3	100534	\N	\N	\N
100552	PT_Massnahmen_PhysiotherapieAmGeraet	\N	\N	3	100534	\N	\N	\N
100556	PT_Massnahmen_SpezielleBehandlungsmethoden	\N	\N	3	100534	\N	\N	\N
100557	PT_Massnahmen_Therapieausfall	\N	\N	3	100534	\N	\N	\N
100559	PT_Massnahmen_UntersuchungenTests	\N	\N	3	100534	\N	\N	\N
100560	PT_AllgBefund	\N	\N	21	1	\N	\N	\N
100561	PT_AllgBefund_Partizipation_Wert	\N	\N	25	100560	\N	\N	\N
100564	PT_AllgBefund_Partizipation_Adl	\N	\N	3	100561	\N	\N	\N
100565	PT_AllgBefund_Partizipation	\N	\N	3	100561	\N	\N	\N
100566	PT_AllgBefund_Partizipation_Mobilitaet	\N	\N	3	100561	\N	\N	\N
100567	PT_AllgBefund_Partizipation_AdlHilfe	\N	\N	3	100561	\N	\N	\N
100569	PT_AllgBefund_Partizipation_MobilitaetHilfe	\N	\N	3	100561	\N	\N	\N
100570	PT_AllgBefund_Partizipation_Fortbewegung	\N	\N	3	100561	\N	\N	\N
100571	PT_AllgBefund_Partizipation_FortbewegungHilfe	\N	\N	3	100561	\N	\N	\N
100575	PT_AllgBefund_Partizipation_Hilfsmittel	\N	\N	3	100561	\N	\N	\N
100578	PT_AllgBefund_Allgemein_Wert	\N	\N	25	100560	\N	\N	\N
100579	PT_AllgBefund_Allgemein_AZ	\N	\N	3	100578	\N	\N	\N
100580	PT_AllgBefund_Allgemein_Bewusstseinslage	\N	\N	3	100578	\N	\N	\N
100581	PT_AllgBefund_Koerper_Wert	\N	\N	25	100560	\N	\N	\N
100583	PT_AllgBefund_Koerper_Bewegsys_Bewegungssystem	\N	\N	3	100581	\N	\N	\N
100584	PT_AllgBefund_Koerper_Bewegsys_Bewegungsqualitaet	\N	\N	3	100581	\N	\N	\N
100585	PT_AllgBefund_Koerper_Bewegsys_Beweglichkeit	\N	\N	3	100581	\N	\N	\N
100586	PT_AllgBefund_Koerper_Bewegsys_Belastbarkeit	\N	\N	3	100581	\N	\N	\N
100588	PT_AllgBefund_Koerper_Bewegsys_SchmerzReiz	\N	\N	3	100581	\N	\N	\N
100589	PT_AllgBefund_Koerper_Bewegsys_HypermobilitaetInst	\N	\N	3	100581	\N	\N	\N
100590	PT_AllgBefund_Koerper_Bewegsys_BindegewHaut	\N	\N	3	100581	\N	\N	\N
100601	PT_AllgBefund_Koerper_Organe_Atmung	\N	\N	3	100581	\N	\N	\N
100602	PT_AllgBefund_Koerper_Organe_BelastbarkeitAF	\N	\N	3	100581	\N	\N	\N
100603	PT_AllgBefund_Koerper_Organe_BelastbarkeitHF	\N	\N	3	100581	\N	\N	\N
100604	PT_AllgBefund_Koerper_Organe_BelastbarkeitRR	\N	\N	3	100581	\N	\N	\N
100605	PT_AllgBefund_Koerper_Organe_Durchblutung	\N	\N	3	100581	\N	\N	\N
100606	PT_AllgBefund_Koerper_Organe_Herz	\N	\N	3	100581	\N	\N	\N
100607	PT_AllgBefund_Koerper_Organe_HerzPuls	\N	\N	3	100581	\N	\N	\N
100608	PT_AllgBefund_Koerper_Organe_HerzRR	\N	\N	3	100581	\N	\N	\N
100609	PT_AllgBefund_Koerper_Organe_Oedeme	\N	\N	3	100581	\N	\N	\N
100610	PT_AllgBefund_Koerper_Bewegkont	\N	\N	3	100581	\N	\N	\N
100611	PT_AllgBefund_Koerper_Bewegkont_ZNSPNSMotorik	\N	\N	3	100581	\N	\N	\N
100612	PT_AllgBefund_Koerper_Bewegkont_ZNSPNSSensibilit	\N	\N	3	100581	\N	\N	\N
100613	PT_AllgBefund_Koerper_Bewegkont_ZNSPNSGleichgewi	\N	\N	3	100581	\N	\N	\N
100614	PT_AllgBefund_Koerper_Bewegkont_ZNSPNSKoordina	\N	\N	3	100581	\N	\N	\N
100615	PT_AllgBefund_Koerper_Bewegkont_ZNSPNSSchwindel	\N	\N	3	100581	\N	\N	\N
100616	PT_AllgBefund_Koerper_Bewegkont_ZNSPNSSprache	\N	\N	3	100581	\N	\N	\N
100617	PT_AllgBefund_Koerper_Bewegkont_ZNSPNSNeuropsycho	\N	\N	3	100581	\N	\N	\N
100618	PT_AllgBefund_Koerper_Bewegsys_BelastbarkeitKg	\N	\N	3	100581	\N	\N	\N
100620	PT_AllgBefund_Koerper_Bewegkont_SensoSpontanAlter	\N	\N	3	100132	\N	\N	\N
100622	PT_AllgBefund_Koerper_Bewegkont_SensoSponAlter	\N	\N	3	100581	\N	\N	\N
100623	PT_AllgBefund_Koerper_Bewegkont_SensoSpontanQualit	\N	\N	3	100581	\N	\N	\N
100625	PT_AllgBefund_Koerper_Bewegkont_SensoWahrnehmung	\N	\N	3	100581	\N	\N	\N
100626	PT_AllgBefund_Koerper_Bewegkont_SensoSprache	\N	\N	3	100581	\N	\N	\N
100627	PT_AllgBefund_Koerper_Bewegkont_SensoSozial	\N	\N	3	100581	\N	\N	\N
100628	PT_AllgBefund_Koerper_ErlebenVerhalten	\N	\N	3	100581	\N	\N	\N
100629	PT_AllgBefund_Koerper_ErlebenVerhalten_Schmerzen	\N	\N	3	100581	\N	\N	\N
100630	PT_AllgBefund_Kontextfatoren_Wert	\N	\N	25	100560	\N	\N	\N
100631	PT_AllgBefund_Kontextfatoren_Kontextfatoren	\N	\N	3	100630	\N	\N	\N
100632	PT_AllgBefund_Partizipation_FortbewegungMeter	\N	\N	6	100561	\N	\N	\N
100633	PT_AllgBefund_Partizipation_FortbewegungStockwerk	\N	\N	6	100561	\N	\N	\N
100634	PT_AllgBefund_Partizipation_FortbewegungStufen	\N	\N	6	100561	\N	\N	\N
100635	PT_AllgBefund_Koerper_Bewegsys_Trainingszustand	\N	\N	3	100581	\N	\N	\N
100636	PT_AllgBefund_Koerper_Organe_Organe	\N	\N	3	100581	\N	\N	\N
100637	PT_Bewegungskontrolle	\N	\N	21	1	\N	\N	\N
100638	PT_Bewegungskontrolle_Wert	\N	\N	25	100637	\N	\N	\N
100640	Dekubitus_vorhanden	\N	\N	2	100182	\N	\N	\N
100641	Behandlungsort_Monitorname	Für Monitoringdatenübernahme	\N	3	40	\N	\N	\N
100643	IstPflege_Atmung_Spontan	\N	\N	2	30	\N	\N	\N
100644	IstPflege_Beatmung	\N	\N	2	30	\N	\N	\N
100645	PersoenAspekte_SeelsGespraech_Wert	\N	\N	25	100524	\N	\N	\N
100647	PersoenAspekte_Ethikkonsil_Wert	\N	\N	25	100524	\N	\N	\N
100649	AtmungKreislaufTemp	\N	\N	21	1	\N	\N	\N
100650	AtmenKreislaufTemp-Atmung_Wert	\N	\N	25	100649	\N	\N	\N
100663	AtmenKreislaufTemp_Kreisl_Wert	\N	\N	25	100649	\N	\N	\N
100665	AtmenKreislaufTemp_Kreisl_Shuntkontr	\N	\N	3	100663	\N	\N	\N
100666	AtmenKreislaufTemp_Kreisl_Lappenkontr	\N	\N	3	100663	\N	\N	\N
100668	AtmenKreislaufTemp_Temp_Wert	\N	\N	25	100649	\N	\N	\N
100671	AtmenKreislaufTemp_Temp_TempWaermegeraet	\N	\N	3	100668	\N	\N	\N
100672	AtmenKreislaufTemp_Temp_TempWaermebett	\N	\N	3	100668	\N	\N	\N
100673	AtmenKreislaufTemp_Temp_TempInkubator	\N	\N	3	100668	\N	\N	\N
100674	AtmenKreislaufTemp_Temp_TempStrahler	\N	\N	3	100668	\N	\N	\N
100675	AtmenKreislaufTemp_Temp_TempKuehlmatte	\N	\N	3	100668	\N	\N	\N
100676	PT_Befund	\N	\N	21	1	\N	\N	\N
100677	PT_Befund_Allg_Wert	\N	\N	25	100676	\N	\N	\N
100678	PT_Befund_Allg_AZ	\N	\N	3	100677	\N	\N	\N
100679	PT_Befund_Allg_Bewustseinslage	\N	\N	3	100677	\N	\N	\N
100680	PT_Partizipation	\N	\N	21	1	\N	\N	\N
100681	PT_Partizipation_Wert	\N	\N	25	100680	\N	\N	\N
100682	PT_Partizipation_Status	\N	\N	3	100681	\N	\N	\N
100683	PT_Partizipation_ADL	\N	\N	3	100681	\N	\N	\N
100684	PT_Partizipation_Mobilitaet	\N	\N	3	100681	\N	\N	\N
100685	PT_Partizipation_Fortbewegung	\N	\N	3	100681	\N	\N	\N
100686	PT_Partizipation_Hilfsmittel	\N	\N	3	100681	\N	\N	\N
100687	PT_Partizipation_Hilfsmittel_Art	\N	\N	3	100681	\N	\N	\N
100688	PT_Partizipation_ADLHilfe	\N	\N	3	100681	\N	\N	\N
100689	PT_Partizipation_MobilitaetHilfe	\N	\N	3	100681	\N	\N	\N
100690	PT_Partizipation_FortbewegungHilfe	\N	\N	3	100681	\N	\N	\N
100691	PT_Partizipation_FortbewegungMeter	\N	\N	6	100681	\N	\N	\N
100692	PT_Partizipation_FortbewegungStufen	\N	\N	6	100681	\N	\N	\N
100693	PT_Partizipation_FortbewegungStockwerke	\N	\N	6	100681	\N	\N	\N
100694	PT_Koerperstruktur	\N	\N	21	1	\N	\N	\N
100695	PT_KoerperstrukturBewegungssystem_Wert	\N	\N	25	100694	\N	\N	\N
100696	PT_KoerperstrukturBewegungssystem_Status	\N	\N	3	100695	\N	\N	\N
100698	PT_KoerperstrukturBewegungssystem_Bewegungsqua	\N	\N	3	100695	\N	\N	\N
100699	PT_KoerperstrukturBewegungssystem_Beweglichkeit	\N	\N	3	100695	\N	\N	\N
100700	PT_KoerperstrukturBewegungssystem_Belastbarkeit	\N	\N	3	100695	\N	\N	\N
100701	PT_KoerperstrukturBewegungssystem_SchmerzReiz	\N	\N	3	100695	\N	\N	\N
100702	PT_KoerperstrukturBewegungssystem_Hypermobilitaet	\N	\N	3	100695	\N	\N	\N
100703	PT_KoerperstrukturBewegungssystem_Trainingszustand	\N	\N	3	100695	\N	\N	\N
100704	PT_KoerperstrukturBindegewebe_Wert	\N	\N	25	100694	\N	\N	\N
100705	PT_KoerperstrukturBindegewebe_Status	\N	\N	3	100704	\N	\N	\N
100707	PT_KoerperstrukturInnereOrgane_Wert	\N	\N	25	100694	\N	\N	\N
100708	PT_KoerperstrukturInnereOrgane_Status	\N	\N	3	100707	\N	\N	\N
100709	PT_KoerperstrukturInnereOrgane_Oedeme	\N	\N	3	100707	\N	\N	\N
100710	PT_KoerperstrukturInnereOrgane_Herz	\N	\N	3	100707	\N	\N	\N
100711	PT_KoerperstrukturInnereOrgane_HerzPuls	\N	\N	6	100707	\N	\N	\N
100712	PT_KoerperstrukturInnereOrgane_HerzRR	\N	\N	6	100707	\N	\N	\N
100713	PT_KoerperstrukturInnereOrgane_Atmung	\N	\N	3	100707	\N	\N	\N
100714	PT_KoerperstrukturInnereOrgane_BelastbarkeitHF	\N	\N	6	100707	\N	\N	\N
100717	PT_KoerperstrukturBewegKontrolle_Wert	\N	\N	25	100694	\N	\N	\N
100718	PT_KoerperstrukturBewegKontrolle_Status	\N	\N	3	100717	\N	\N	\N
100719	PT_KoerperstrukturBewegKontrolle_Motorik	\N	\N	3	100717	\N	\N	\N
100720	PT_KoerperstrukturBewegKontrolle_Sensibilitaet	\N	\N	3	100717	\N	\N	\N
100721	PT_KoerperstrukturBewegKontrolle_Gleichgewicht	\N	\N	3	100638	\N	\N	\N
100722	Ernaehren_Ausscheiden_Nahr_Mengeml	\N	ml	6	100447	\N	\N	\N
100724	PT_KoerperstrukturBewegKontrolle_Gleichgewich	\N	\N	3	100717	\N	\N	\N
100725	PT_KoerperstrukturBewegKontrolle_Koordination	\N	\N	3	100717	\N	\N	\N
100726	PT_KoerperstrukturBewegKontrolle_Schwindel	\N	\N	3	100717	\N	\N	\N
100727	PT_KoerperstrukturBewegKontrolle_Sprache	\N	\N	3	100717	\N	\N	\N
100728	PT_KoerperstrukturBewegKontrolle_Neuropsychologie	\N	\N	3	100717	\N	\N	\N
100729	PT_KoerperstrukturBewegSensoEntwicklung_Wert	\N	\N	25	100694	\N	\N	\N
100733	PT_KoerperstrukturBewegSensoEntwicklung_Spomotalt	\N	\N	3	100729	\N	\N	\N
100735	PT_KoerperstrukturBewegSensoEntwicklung_Wahrneh	\N	\N	3	100729	\N	\N	\N
100736	PT_KoerperstrukturBewegSensoEntwicklung_Sprache	\N	\N	3	100729	\N	\N	\N
100737	PT_KoerperstrukturBewegSensoEntwicklung_Sozial	\N	\N	3	100729	\N	\N	\N
100738	PT_KoerperstrukturBewegSensoEntwicklung_Spomotqua	\N	\N	3	100729	\N	\N	\N
100739	PT_KoerperstrukturErleben_Wert	\N	\N	25	100694	\N	\N	\N
100740	PT_KoerperstrukturErleben_Status	\N	\N	3	100739	\N	\N	\N
100741	PT_KoerperstrukturErleben_Schmerzen	\N	\N	3	100739	\N	\N	\N
100742	PT_Kontextfaktoren	\N	\N	21	1	\N	\N	\N
100743	Ernaehren_Ausscheiden_Magensaft_Mengeml	\N	ml	6	100453	\N	\N	\N
100745	PT_Kontextfaktoren_Wert	\N	\N	25	100742	\N	\N	\N
100746	PT_Kontextfaktoren_Status	\N	\N	3	100745	\N	\N	\N
100747	Ernaehren_Ausscheiden_Erbrechen_Mengeml	\N	ml	6	100453	\N	\N	\N
100748	Ernaehren_Ausscheiden_Urin_Mengeml	\N	ml	6	100453	\N	\N	\N
100749	Ernaehren_Ausscheiden_APoral_Mengeml	\N	ml	6	100453	\N	\N	\N
100750	Ernaehren_Ausscheiden_APaboral_Mengeml	\N	ml	6	100453	\N	\N	\N
100751	PT_KoerperstrukturBewegungssystem_BelastbarkeitKg	\N	\N	6	100695	\N	\N	\N
100752	EnteraleSonden_MagensaftMengeml	\N	ml	6	100165	\N	\N	\N
100753	PT_KoerperstrukturInnereOrgane_Durchblutung	\N	\N	3	100707	\N	\N	\N
100754	PT_KoerperstrukturInnereOrgane_BelastbarkeitRR	\N	\N	6	100707	\N	\N	\N
100755	PT_KoerperstrukturInnereOrgane_BelastbarkeitAF	\N	\N	6	100707	\N	\N	\N
100757	Drainagen_SekretMengeml	\N	ml	6	100157	\N	\N	\N
100758	Wundedokumentation_Sekretmengeml	\N	ml	6	100193	\N	\N	\N
100759	Dekubitus_Sekretmengeml	\N	ml	6	100186	\N	\N	\N
100760	HarnwegeDarm_Mengeml	\N	ml	6	100172	\N	\N	\N
100761	IstPflege_02Bedarf	\N	\N	2	30	\N	\N	\N
100762	IstPflege_Beatmung_invasiv	\N	\N	2	30	\N	\N	\N
100763	IstPflege_Beatmung_nichtinvasiv	\N	\N	2	30	\N	\N	\N
100764	Wunde_vorhanden	\N	\N	2	100189	\N	\N	\N
100766	Atemwege_vorhanden	Atemwegszugang	\N	2	100132	\N	\N	\N
100767	Drainage_vorhanden	\N	\N	2	100135	\N	\N	\N
100768	HarnwegeDarm_vorhanden	\N	\N	2	100134	\N	\N	\N
100769	EnteraleSonde_vorhanden	\N	\N	2	100133	\N	\N	\N
100770	Zugaenge_vorhanden	\N	\N	2	100131	\N	\N	\N
100771	IstPflege_intubiert	\N	\N	2	30	\N	\N	\N
100772	IstPflege_tracheotomiert	\N	\N	2	30	\N	\N	\N
100773	IstPflege_SchrittImplanti	\N	\N	2	30	\N	\N	\N
100774	Istpflege_Shuntvorhanden	\N	\N	2	30	\N	\N	\N
100775	IstPflege_Shuntkontrolle	\N	\N	3	30	\N	\N	\N
100779	Beatmung_Inhalation_Balken	\N	\N	26	1	\N	\N	\N
100781	Beatmung_Anfeuchtung_Balken	\N	\N	26	1	\N	\N	\N
100782	IstPflege_Pupillenweite_li	\N	\N	3	30	\N	\N	\N
100783	IstPflege_Pupillenreaktion_Li	\N	\N	3	30	\N	\N	\N
100784	IstPflege_Pupillenform_Li	\N	\N	3	30	\N	\N	\N
100786	IstPflege_RamseyScore	\N	\N	3	30	\N	\N	\N
100790	IstPflege_Befind_Brille	\N	\N	2	30	\N	\N	\N
100791	IstPflege_Befind_Kontaktlinsen	\N	\N	2	30	\N	\N	\N
100795	Beatmung_Anordnung_Beatmungsform	\N	\N	3	1	\N	\N	\N
100796	Beatmung_Anordnung_Beatmungsgeraet	\N	\N	3	1	\N	\N	\N
100797	Beatmung_Anordnung_pmax	\N	\N	6	1	\N	\N	\N
100798	Beatmung_Anordnung_pPlateau	\N	\N	6	1	\N	\N	\N
100800	Beatmung_Anordnung_O2Lmin	\N	l/min	6	1	\N	\N	\N
100801	Beatmung_Anordnung_AbbruchkriterienAllgemein	\N	\N	3	1	\N	\N	\N
100802	Beatmung_Anordnung_SauerstoffFlow	\N	\N	6	1	\N	\N	\N
100803	Beatmung_Anordnung_DruckluftFlow	\N	\N	6	1	\N	\N	\N
100804	Beatmung_Anordnung_O2Konzentration	\N	\N	6	1	\N	\N	\N
100805	Beatmung_Anordnung_BedingteVerordnung	\N	\N	3	1	\N	\N	\N
100807	Beatmung_O2_Balken	\N	\N	26	1	\N	\N	\N
100809	Anfeuchtung_Balken	\N	\N	19	1	\N	\N	\N
100813	Atemform_Balken	\N	\N	19	1	\N	\N	\N
100814	Atemwege_Intubation	\N	\N	5	100132	\N	\N	\N
100815	Atemwege_Extubation	mit SQL select getdate()	\N	5	100132	\N	\N	\N
100820	IstPflege_ErnaehrAussch_parenteral	\N	\N	2	30	\N	\N	\N
100821	IstPflege_ErnaehrAussch_enteral	\N	\N	2	30	\N	\N	\N
100822	IstPflege_ErnaehrAussch_beides	\N	\N	2	30	\N	\N	\N
100824	IstPflege_ErnaehrAusschei_SpontUrin	\N	\N	2	30	\N	\N	\N
100825	IstPflege_ErnaehrAusschei_Blasenkath	\N	\N	2	30	\N	\N	\N
100826	IstPflege_ErnaehrAusschei_Stuhlspont	\N	\N	2	30	\N	\N	\N
100827	IstPflege_ErnaehrAusschei_AnusPraeter	\N	\N	2	30	\N	\N	\N
100834	IstPflege_Koerperpfl_Bemerkungen 	\N	\N	3	30	\N	\N	\N
100837	HarnwegeDarm_Blasensp_menge	\N	\N	6	100172	\N	\N	\N
100838	Befinden_Befinden_Pup_Weite_re	\N	\N	3	30	\N	\N	\N
100839	IstPflege_Pupillenweite_Re	\N	\N	3	30	\N	\N	\N
100840	IstPflege_Pupillenreaktion_Re	\N	\N	3	30	\N	\N	\N
100841	IstPflege_Pupillenform_Re	\N	\N	3	30	\N	\N	\N
100842	ZuUndAbleitendeSystem	\N	\N	1	30	\N	\N	\N
100843	IstPflege_Befind_Wertsachen	\N	\N	2	30	\N	\N	\N
100844	IstPflege_Atmung_Atemtyp	\N	\N	3	30	\N	\N	\N
100845	IstPflege_Atmen_Abhusten	\N	\N	3	30	\N	\N	\N
100846	IstPflege_Atmen_TrachSekret	\N	\N	3	30	\N	\N	\N
100847	VerlegPfl_Atmung_Spontan	\N	\N	2	30	\N	\N	\N
100848	VerlegPfl_Atm_Beatmung	\N	\N	2	30	\N	\N	\N
100849	VerlegPfl_Atm_intubiert	\N	\N	2	30	\N	\N	\N
100850	VerlegPfl_Atm_O2Bedarf	\N	\N	2	30	\N	\N	\N
100851	VerlegPfl_Atm_Beatm_invasiv	\N	\N	2	30	\N	\N	\N
100852	VerlegPfl_Atm_tracheoto	\N	\N	2	30	\N	\N	\N
100853	VerlegPfl_Atm_Beatm_nichtinvasiv	\N	\N	2	30	\N	\N	\N
100855	VerlegPfl_Atm_Abhusten	\N	\N	3	30	\N	\N	\N
100856	VerlegPfl_Atm_Trachsekret	\N	\N	3	30	\N	\N	\N
100858	VerlegPfl_Atm_Shuntvorhanden	\N	\N	2	30	\N	\N	\N
100859	VerlegPfl_Atm_SchrittmImplant	\N	\N	2	30	\N	\N	\N
100860	VerlegPfl_Atm_Shuntkontr	\N	\N	3	30	\N	\N	\N
100862	VerlegPfl_Atm_O2_L	\N	\N	3	30	\N	\N	\N
100865	VerlPfl_Befind_Pupillenweite_li	\N	\N	3	30	\N	\N	\N
100866	VerlPfl_Befind_Pupillenweite_Re	\N	\N	3	30	\N	\N	\N
100867	VerlPfl_Befind_Pupillenreakt_li	\N	\N	3	30	\N	\N	\N
100868	VerlPfl_Befind_Pupillenreakt_Re	\N	\N	3	30	\N	\N	\N
100869	VerlPfl_Befind_Pupillenform_li	\N	\N	3	30	\N	\N	\N
100870	VerlPfl_Befind_Pupillenform_re	\N	\N	3	30	\N	\N	\N
100873	VerlPfl_Befind_RamseyScore	\N	\N	3	30	\N	\N	\N
100874	VerlPfl_Befind_Schmerzen	\N	\N	3	30	\N	\N	\N
100875	VerlPfl_Befind_Schmerz_Lokalisat	\N	\N	3	30	\N	\N	\N
100877	VerlPfl_Befind_Brillevorhanden	\N	\N	2	30	\N	\N	\N
100878	VerlPfl_Befind_Kontaktlinsen	\N	\N	2	30	\N	\N	\N
100881	VerlPfl_Befind_Wertsachen	\N	\N	2	30	\N	\N	\N
100889	VerlPfl_Beweg_Dekugefahr	\N	\N	3	30	\N	\N	\N
100890	VerlPfl_ErnaehrAussch_parenteral	\N	\N	2	30	\N	\N	\N
100891	VerlPfl_ErnaehrAussch_enteral	\N	\N	2	30	\N	\N	\N
100892	VerlPfl_ErnaehrAussch_beides	\N	\N	2	30	\N	\N	\N
100893	VerlPfl_ErnaehrAussch_SpontUrin	\N	\N	2	30	\N	\N	\N
100894	VerlPfl_ErnaehrAussch_BK	\N	\N	2	30	\N	\N	\N
100895	VerlPfl_ErnaehrAussch_Stuhlspont	\N	\N	2	30	\N	\N	\N
100896	VerlPfl_ErnaehrAussch_AnusPraeter	\N	\N	2	30	\N	\N	\N
100898	VerlPfl_ErnaehrAussch_KostKinder	\N	\N	3	30	\N	\N	\N
100899	VerlPfl_ErnaehrAussch_NahrMenge	\N	\N	3	30	\N	\N	\N
100901	VerlPfl_ErnaehrAussch_LetzStuhl	\N	\N	3	30	\N	\N	\N
100902	VerlPfl_ErnaehrAussch_GewKG	\N	\N	3	30	\N	\N	\N
100905	PflVerleg_verlegt_am	Verlegungszeit im Verlegungsprotokoll mit Datum und Uhrzeit	\N	5	1	\N	\N	\N
100907	VerlegPfl_Koerperpfl_Hautstatus	\N	\N	3	30	\N	\N	\N
100908	VerlegPfl_Koerperpfl_Hautkolorit	\N	\N	3	30	\N	\N	\N
100914	VerlegPfl_PersoenlAspekte	\N	\N	3	30	\N	\N	\N
100915	VerlPfl_Koerperpfl_Bemerkung 	\N	\N	3	30	\N	\N	\N
100916	VerlegPfl_Befinden_RamseyScore	\N	\N	3	30	\N	\N	\N
100917	IstPflege_Koerperpfl_Verband	\N	\N	3	30	\N	\N	\N
100922	KlinikKopf_Gesichtshaut_Verband	\N	\N	3	100346	\N	\N	\N
100923	KlinikKopf_Gesichtshaut_Drainagen	\N	\N	3	100346	\N	\N	\N
100924	KlinikKopf_Gesichtshaut_Sekret	\N	\N	3	100346	\N	\N	\N
100925	KlinikKopf_Gesichtshaut_Palpation	\N	\N	3	100346	\N	\N	\N
100926	KlinikKopf_Gesichtshaut_Sensibilitaet	\N	\N	3	100346	\N	\N	\N
100927	KlinikKopf_Auge_Wert	\N	\N	25	100345	\N	\N	\N
100928	KlinikKopf_Auge_Allgemein	\N	\N	3	100927	\N	\N	\N
100929	KlinikKopf_Auge_Augenhintergrund	\N	\N	3	100927	\N	\N	\N
100930	KlinikKopf_Auge_Befragung	\N	\N	3	100927	\N	\N	\N
100931	KlinikKopf_Auge_Inspektion	\N	\N	3	100927	\N	\N	\N
100932	KlinikKopf_Auge_Palpation	\N	\N	3	100927	\N	\N	\N
100933	KlinikKopf_Auge_Pupillen	\N	\N	3	100927	\N	\N	\N
100934	KlinikKopf_Auge_Lichtreaktion	\N	\N	3	100927	\N	\N	\N
100935	KlinikKopf_Auge_Sekret	\N	\N	3	100927	\N	\N	\N
100936	KlinikKopf_Nase_Wert	\N	\N	25	100345	\N	\N	\N
100937	KlinikKopf_Nase_Allgemein	\N	\N	3	100936	\N	\N	\N
100938	KlinikKopf_Nase_Befragung	\N	\N	3	100936	\N	\N	\N
100939	KlinikKopf_Nase_Inspektion	\N	\N	3	100936	\N	\N	\N
100940	KlinikKopf_Nase_Palpation	\N	\N	3	100936	\N	\N	\N
100941	KlinikKopf_Nase_Sekret	\N	\N	3	100936	\N	\N	\N
100942	KlinikKopf_Mund_Wert	\N	\N	25	100345	\N	\N	\N
100943	KlinikKopf_Mund_Allgemein	\N	\N	3	100942	\N	\N	\N
100944	KlinikKopf_Mund_Befragung	\N	\N	3	100942	\N	\N	\N
100945	KlinikKopf_Mund_Foetor	\N	\N	3	100942	\N	\N	\N
100946	KlinikKopf_Mund_Inspektion	\N	\N	3	100942	\N	\N	\N
100947	KlinikKopf_Mund_Drainage	\N	\N	3	100942	\N	\N	\N
100948	KlinikKopf_Mund_Sekret	\N	\N	3	100942	\N	\N	\N
100949	KlinikKopf_Mund_Palpation	\N	\N	3	100942	\N	\N	\N
100950	KlinikKopf_Mund_Sensibilitaet	\N	\N	3	100942	\N	\N	\N
100951	KlinikKopf_Mund_Motorik	\N	\N	3	100942	\N	\N	\N
100965	KlinikThorax	\N	\N	21	1	\N	\N	\N
100966	KlinikThorax_Haut_Wert	\N	\N	25	100965	\N	\N	\N
100967	KlinikThorax_Haut_Allgemein	\N	\N	3	100966	\N	\N	\N
100968	KlinikThorax_Haut_Befragung	\N	\N	3	100966	\N	\N	\N
100969	KlinikThorax_Haut_Drainage	\N	\N	3	100966	\N	\N	\N
100970	KlinikThorax_Haut_Inspektion	\N	\N	3	100966	\N	\N	\N
100971	KlinikThorax_Haut_Palpation	\N	\N	3	100966	\N	\N	\N
100972	KlinikThorax_Haut_Sekret	\N	\N	3	100966	\N	\N	\N
100973	KlinikThorax_Haut_Sensibilitaet	\N	\N	3	100966	\N	\N	\N
100974	KlinikThorax_Haut_Verband	\N	\N	3	100966	\N	\N	\N
100975	KlinikThorax_Haut_Verletzung	\N	\N	3	100966	\N	\N	\N
100976	KlinikThorax_Thoraxwand_Wert	\N	\N	25	100965	\N	\N	\N
100977	KlinikThorax_Thoraxwand_Allgemein	\N	\N	3	100976	\N	\N	\N
100978	KlinikThorax_Thoraxwand_Atmung	\N	\N	3	100976	\N	\N	\N
100979	KlinikThorax_Thoraxwand_Befragung	\N	\N	3	100976	\N	\N	\N
100980	KlinikThorax_Thoraxwand_Inspektion	\N	\N	3	100976	\N	\N	\N
100981	KlinikThorax_Thoraxwand_Palpation	\N	\N	3	100976	\N	\N	\N
100982	KlinikThorax_Lungen_Wert	\N	\N	25	100965	\N	\N	\N
100983	KlinikThorax_Lungen_Allgemein	\N	\N	3	100982	\N	\N	\N
100984	KlinikThorax_Lungen_Auskultation	\N	\N	3	100982	\N	\N	\N
100985	KlinikThorax_Lungen_Befragung	\N	\N	3	100982	\N	\N	\N
100986	KlinikThorax_Lungen_Grenzen	\N	\N	3	100982	\N	\N	\N
100987	KlinikThorax_Lungen_Inspektion	\N	\N	3	100982	\N	\N	\N
100988	KlinikThorax_Lungen_Perkussion	\N	\N	3	100982	\N	\N	\N
100989	KlinikThorax_Herz_Wert	\N	\N	25	100965	\N	\N	\N
100990	KlinikThorax_Herz_Auskultation	\N	\N	3	100989	\N	\N	\N
100991	KlinikThorax_Herz_Allgemein	\N	\N	3	100989	\N	\N	\N
100992	KlinikThorax_Herz_Befragung	\N	\N	3	100989	\N	\N	\N
100993	KlinikThorax_Herz_Palpation	\N	\N	3	100989	\N	\N	\N
100994	KlinikThorax_Herz_Perkussion	\N	\N	3	100989	\N	\N	\N
100995	KlinikThorax_Herz_Reizleitung	\N	\N	3	100989	\N	\N	\N
100996	KlinikThorax_Herz_Ektopie	\N	\N	3	100989	\N	\N	\N
100997	KlinikThorax_Herz_Erregungsrueckbildung	\N	\N	3	100989	\N	\N	\N
100999	KlinikStamm	\N	\N	21	1	\N	\N	\N
101000	KlinikExtraemitaeten	\N	\N	21	1	\N	\N	\N
101007	KlinikTemperaturstatus	\N	\N	21	1	\N	\N	\N
101008	KlinikVegetativeFunktion	\N	\N	21	1	\N	\N	\N
101009	KlinikNervensys	Nervensysteme	\N	21	1	\N	\N	\N
101010	KlinikPeriNervenFunkt	\N	\N	21	1	\N	\N	\N
101013	KlinikStamm_Bauchhaut_Wert	\N	\N	25	100999	\N	\N	\N
101014	KlinikStamm_Ruecken_Wert	\N	\N	25	100999	\N	\N	\N
101015	KlinikStamm_Bauchwand_Wert	\N	\N	25	100999	\N	\N	\N
101016	KlinikStamm_Leber_Wert	\N	\N	25	100999	\N	\N	\N
101018	KlinikStamm_Uretra_Wert	\N	\N	25	100999	\N	\N	\N
101019	KlinikExtraemitaeten_obere_Wert	\N	\N	25	101000	\N	\N	\N
101030	KlinikTemperaturstatus_Kerntemperatur_Wert	\N	\N	25	101007	\N	\N	\N
101031	KlinikVegetativeFunktion_Schweiss_Wert	\N	\N	25	101008	\N	\N	\N
101032	KlinikNervensys_ZNSBewusstsein_Wert	\N	\N	25	101009	\N	\N	\N
101033	KlinikNervensys_ZNSOrientierung_Wert	\N	\N	25	101009	\N	\N	\N
101034	KlinikNervensys_ZNSReflexstatus_Wert	\N	\N	25	101009	\N	\N	\N
101035	KlinikNervensys_ZNSHirnnerven_Wert	\N	\N	25	101009	\N	\N	\N
101036	KlinikPeriNervenFunkt_Motorik_Wert	\N	\N	25	101010	\N	\N	\N
101037	KlinikPeriNervenFunkt_Sensibilitaet_Wert	\N	\N	25	101010	\N	\N	\N
101038	KlinikPeriNervenFunkt_Vegetativum_Wert	\N	\N	25	101010	\N	\N	\N
101329	Fall_Art	\N	\N	3	20	\N	\N	\N
101325	Patient_PLZ	Patientenadresse: PLZ	\N	3	1	\N	\N	\N
101205	KlinikThorax_Herz_Reizbildung	\N	\N	3	100989	\N	\N	\N
101206	KlinikStamm_Bauchhaut_Allgemein	\N	\N	3	101013	\N	\N	\N
101207	KlinikStamm_Bauchhaut_Befragung	\N	\N	3	101013	\N	\N	\N
101208	KlinikStamm_Bauchhaut_Drainage	\N	\N	3	101013	\N	\N	\N
101209	KlinikStamm_Bauchhaut_Inspektion	\N	\N	3	101013	\N	\N	\N
101210	KlinikStamm_Bauchhaut_Palpation	\N	\N	3	101013	\N	\N	\N
101211	KlinikStamm_Bauchhaut_Sekret	\N	\N	3	101013	\N	\N	\N
101212	KlinikStamm_Bauchhaut_Stoma	\N	\N	3	101013	\N	\N	\N
101213	KlinikStamm_Bauchhaut_Urinableitung	\N	\N	3	101013	\N	\N	\N
101214	KlinikStamm_Bauchhaut_Verband	\N	\N	3	101013	\N	\N	\N
101215	KlinikStamm_Bauchhaut_Verletzung	\N	\N	3	101013	\N	\N	\N
101217	KlinikStamm_Bauchwand_Allgemein	\N	\N	3	101015	\N	\N	\N
101218	KlinikStamm_Bauchwand_Befragung	\N	\N	3	101015	\N	\N	\N
101219	KlinikStamm_Bauchwand_Inspektion	\N	\N	3	101015	\N	\N	\N
101220	KlinikStamm_Bauchwand_Palpation	\N	\N	3	101015	\N	\N	\N
101221	KlinikStamm_Bauchwand_Perkussion	\N	\N	3	101015	\N	\N	\N
101222	KlinikStamm_Leber_Allgemein	\N	\N	3	101016	\N	\N	\N
101223	KlinikStamm_Leber_Befragung	\N	\N	3	101016	\N	\N	\N
101224	KlinikStamm_Leber_Drainage	\N	\N	3	101016	\N	\N	\N
101225	KlinikStamm_Leber_Palpation	\N	\N	3	101016	\N	\N	\N
101226	KlinikStamm_Leber_Perkussion	\N	\N	3	101016	\N	\N	\N
101227	KlinikStamm_Leber_Sekret	\N	\N	3	101016	\N	\N	\N
101228	KlinikStamm_Leber_Ultraschall	\N	\N	3	101016	\N	\N	\N
101229	KlinikStamm_Uretra_Allgemein	\N	\N	3	101018	\N	\N	\N
101230	KlinikStamm_Uretra_Befragung	\N	\N	3	101018	\N	\N	\N
101231	KlinikStamm_Uretra_Inspektion	\N	\N	3	101018	\N	\N	\N
101232	KlinikStamm_Uretra_Urin	\N	\N	3	101018	\N	\N	\N
101233	KlinikExtraemitaeten_obere_Allgemein	\N	\N	3	101019	\N	\N	\N
101234	KlinikExtraemitaeten_obere_Befragung	\N	\N	3	101019	\N	\N	\N
101235	KlinikExtraemitaeten_obere_DrainageZugaenge	\N	\N	3	101019	\N	\N	\N
101236	KlinikExtraemitaeten_obere_Inspektion	\N	\N	3	101019	\N	\N	\N
101237	KlinikExtraemitaeten_obere_Palpation	\N	\N	3	101019	\N	\N	\N
101238	KlinikExtraemitaeten_obere_Schienung	\N	\N	3	101019	\N	\N	\N
101239	KlinikExtraemitaeten_obere_Sekret	\N	\N	3	101019	\N	\N	\N
101240	KlinikExtraemitaeten_obere_Sensibilitaet	\N	\N	3	101019	\N	\N	\N
101241	KlinikExtraemitaeten_obere_Verband	\N	\N	3	101019	\N	\N	\N
101242	KlinikExtraemitaeten_obere_Verletzung	\N	\N	3	101019	\N	\N	\N
101274	KlinikTemperaturstatus_Kerntemperatur_Kerntemp	\N	\N	3	101030	\N	\N	\N
101275	KlinikVegetativeFunktion_Schweiss_Schweiss	\N	\N	3	101031	\N	\N	\N
101276	KlinikNervensys_ZNSBewusstsein_Sedierung	\N	\N	3	101032	\N	\N	\N
101277	KlinikNervensys_ZNSBewusstsein_GlasgowKomaScore	\N	\N	3	101032	\N	\N	\N
101278	KlinikNervensys_ZNSBewusstsein_Ramsey	\N	\N	3	101032	\N	\N	\N
101279	KlinikNervensys_ZNSOrientierung_Orientierung	\N	\N	3	101033	\N	\N	\N
101280	KlinikNervensys_ZNSReflexstatus_Allgemein	\N	\N	3	101034	\N	\N	\N
101281	KlinikNervensys_ZNSReflexstatus_Hirnstammreflexe	\N	\N	3	101034	\N	\N	\N
101282	KlinikNervensys_ZNSReflexstatus_Muskeleigenreflexe	\N	\N	3	101034	\N	\N	\N
101283	KlinikNervensys_ZNSReflexstatus_VegetativeReflexe	\N	\N	3	101034	\N	\N	\N
101284	KlinikNervensys_ZNSReflexstatus_Fluchtreaktion	\N	\N	3	101034	\N	\N	\N
101287	KlinikPeriNervenFunkt_Motorik_Allgemein	\N	\N	3	101036	\N	\N	\N
101288	KlinikPeriNervenFunkt_Sensibilitaet_Allgemein	\N	\N	3	101037	\N	\N	\N
101289	KlinikNervensys_ZNSHirnnerven_Hirnnerven	\N	\N	3	101035	\N	\N	\N
101290	KlinikStamm_Bauchwand_Auskultation	\N	\N	3	101015	\N	\N	\N
101303	KlinikStamm_Ruecken_Ruecken	\N	\N	3	101014	\N	\N	\N
101311	KlinikNervensys_ZNSReflexstatus_Pyramidenbahnz	\N	\N	3	101034	\N	\N	\N
101312	KlinikNervensys_ZNSReflexstatus_PatholoReflexe	\N	\N	3	101034	\N	\N	\N
101313	KlinikWasserhaushalt_Wasserhaushalt_Wasserhaushalt	\N	\N	3	100132	\N	\N	\N
101316	KlinikPeriNervenFunkt_Vegetativum_Vegetativum	\N	\N	3	101038	\N	\N	\N
101317	Patient_Alter	Alter des Patienten in Jahren	Jahre	2	1	\N	\N	\N
101318	Spuelung	\N	\N	6	100157	\N	\N	\N
101321	EnteraleSonde_Markierung	\N	\N	3	100165	\N	\N	\N
101323	Patient_AufnGroesse	Größe Patient (fallbezogen)	\N	6	20	\N	\N	\N
101324	Patient_AufnKO	Körperoberfläche des Patienten (fallbezogen)	\N	6	20	\N	\N	\N
101326	Patient_Ort	Patientenadresse: Ort	\N	3	1	\N	\N	\N
101327	Patient_Land	Patientenadresse: Land	\N	3	1	\N	\N	\N
101328	Patient_Pseudonym	\N	\N	3	1	\N	\N	\N
101331	Befinden_Reflexe_Wert	\N	\N	25	100418	\N	\N	\N
101332	Befinden_Reflexe_Hustenreflex	\N	\N	3	101331	\N	\N	\N
101333	Befinden_Reflexe_Wuergereflex	\N	\N	3	101331	\N	\N	\N
101334	Befinden_Reflex_Schluckreflex	\N	\N	3	101331	\N	\N	\N
101337	MassnahmeArzt	\N	\N	1	20	\N	\N	\N
101339	MassnahmeArzt_DokuZeit	\N	\N	5	101337	\N	\N	\N
101340	MassnahmeArzt_Art	\N	\N	3	101337	\N	\N	\N
101341	AtmenKreislTemp_AT_Hustenreflex	\N	\N	3	100650	\N	\N	\N
101342	MassnahmeArzt_Gruppe	\N	\N	3	101337	\N	\N	\N
101343	MassnahmeArzt_Text	\N	\N	3	101337	\N	\N	\N
101344	Befinden_Befinden_Pup_WeiteRe	\N	\N	3	100421	\N	\N	\N
101345	Befinden_Befinden_PupillenFormRe	\N	\N	3	100421	\N	\N	\N
101346	Befinden_Befinden_PupillenReaktionRe	\N	\N	3	100421	\N	\N	\N
101350	MassnahmeArzt_Name	\N	\N	3	101337	\N	\N	\N
101351	MassnahmeArzt_DurchgefuehrtVon	\N	\N	3	101337	\N	\N	\N
101352	BefindenNeurolCornealreflexLi	\N	\N	3	100421	\N	\N	\N
101353	BefindenNeurolCornealreflexRe	\N	\N	3	100421	\N	\N	\N
101354	Dekubitus_verheilt_am	\N	\N	5	100182	\N	\N	\N
101355	Wunddokumentation_verheilt_am	\N	\N	5	100189	\N	\N	\N
101356	Drainage_entfernt_am	\N	\N	5	100135	\N	\N	\N
101357	HarnwegeDarm_entfernt_am	\N	\N	5	100134	\N	\N	\N
101358	Enteralesonden_entfernt_am	\N	\N	5	100133	\N	\N	\N
101359	Atemwege_entfernt_am	\N	\N	5	100132	\N	\N	\N
101360	Zugaenge_entfernt_am	\N	\N	5	100131	\N	\N	\N
101362	VerlegPfl_Schrittmacher	\N	\N	3	30	\N	\N	\N
101363	VerlPfl_Befind_HoergeraetRechts	\N	\N	2	30	\N	\N	\N
101364	IstPflege_Befind_Hoergeraetlinks	\N	\N	2	30	\N	\N	\N
101365	VerlPfl_Befind_ZahnprotheseUnten	\N	\N	2	30	\N	\N	\N
101366	VerlPfl_Befind_ZahnspangeUnten	\N	\N	2	30	\N	\N	\N
101367	IstPflege_Befind_Hoergeraetrechts	\N	\N	2	30	\N	\N	\N
101368	IstPflege_Befind_Zahnspangeunten	\N	\N	2	30	\N	\N	\N
101370	IstPflege_Befind_Zahnspangeoben	\N	\N	2	30	\N	\N	\N
101371	IstPflege_Befind_ZahnProtheseoben	\N	\N	2	30	\N	\N	\N
101372	IstPflege_Befind_ZahnProtheseunten	\N	\N	2	30	\N	\N	\N
101373	VerlPfl_Befind_Zahnprotheseoben	\N	\N	2	30	\N	\N	\N
101374	VerlPfl_Befind_Zahnspangeoben	\N	\N	2	30	\N	\N	\N
101375	VerlPfl_Befind_Hoergeraetlinks	\N	\N	2	30	\N	\N	\N
101377	Nierenersatzverfahren_VO_Verfahren	\N	\N	3	1	\N	\N	\N
101378	Nierenersatzverfahren_VO_Option	\N	\N	3	1	\N	\N	\N
101379	Nierenersatzverfahren_VO_Startzeit	\N	\N	5	1	\N	\N	\N
101380	Nierenersatzverfahren_VO_Antikoagulanz	\N	\N	3	1	\N	\N	\N
101381	Nierenersatzverfahren_VO_Bolus	\N	\N	3	1	\N	\N	\N
101382	Nierenersatzverfahren_VO_FuellenMit	\N	\N	3	1	\N	\N	\N
101383	Nierenersatzverfahren_VO_BlutflussMax	\N	\N	6	1	\N	\N	\N
101384	Nierenersatzverfahren_VO_Umsatz	\N	\N	6	1	\N	\N	\N
101385	Nierenersatzverfahren_VO_AbnahmeMax	\N	\N	6	1	\N	\N	\N
101386	Nierenersatzverfahren_VO_Bilanzziel	\N	\N	6	1	\N	\N	\N
101387	Nierenersatzverfahren_VO_HarnstoffZiel	\N	\N	6	1	\N	\N	\N
101388	Nierenersatzverfahren_VO_CreaZiel	\N	\N	6	1	\N	\N	\N
101389	Nierenersatzverfahren_VO_KaliumZiel	\N	\N	6	1	\N	\N	\N
101390	Nierenersatzverfahren_VO_HFLoesung	\N	\N	3	1	\N	\N	\N
101391	Nierenersatzverfahren_Dokumentation_Verfahren	\N	\N	3	1	\N	\N	\N
101393	Nierenersatzverfahren_Einstell_Umsatz	\N	\N	6	1	\N	\N	\N
101395	Nierenersatzverfahren_Mess_UmsatzKumulati	\N	\N	6	1	\N	\N	\N
101397	Nierenersatzverfahren_Mess_AbnahmeKumulat	\N	\N	6	1	\N	\N	\N
101398	Nierenersatzverfahren_Dokumentation_Blutfluss	\N	\N	6	1	\N	\N	\N
101399	Nierenersatzverfahren_Mess_DruckVorFilter	\N	\N	6	1	\N	\N	\N
101400	Nierenersatzverfahren_Dokumentation_Filtratdruck	\N	\N	6	1	\N	\N	\N
101401	Nierenersatzverfahren_Mess_ArteriellDruck	\N	\N	6	1	\N	\N	\N
101402	Nierenersatzverfahren_Mess_VenDruck	\N	\N	6	1	\N	\N	\N
101404	Nierenersatzverfahren_Dokumentation_Antikoagulatio	\N	\N	3	1	\N	\N	\N
101405	Nierenersatzverfahren_Dokumentation_Option	\N	\N	3	1	\N	\N	\N
101406	Nierenersatzverfahren_Dokumentation_HFLoesung	\N	\N	3	1	\N	\N	\N
101407	Lungenersatzverfahren_Anordnung_ECMOAirFlow	\N	\N	6	1	\N	\N	\N
101408	Lungenersatzverfahren_Anordnung_ECMOBlutfluss	\N	\N	6	1	\N	\N	\N
101409	Lungenersatzverfahren_Anordnung_ECMOPumpendrehzahl	\N	\N	6	1	\N	\N	\N
101410	Lungenersatzverfahren_Anordnung_ECMOAntikogulation	\N	\N	3	1	\N	\N	\N
101411	Lungenersatzverfahren_Anordnung_ECMOInspiratioSaO2	\N	\N	6	1	\N	\N	\N
101453	Stationsuebersicht_Wert	\N	\N	25	101425	\N	\N	\N
101412	Lungenersatzverfahren_Doku_ECMOInspiratorischSaO2	\N	\N	6	1	\N	\N	\N
101413	Lungenersatzverfahren_Doku_ECMOAirFlow	\N	\N	6	1	\N	\N	\N
101414	Lungenersatzverfahren_Doku_ECMOBlutfluss	\N	\N	6	1	\N	\N	\N
101415	Lungenersatzverfahren_Doku_ECMOPumpendrehzahl	\N	\N	6	1	\N	\N	\N
101416	Lungenersatzverfahren_Doku_ECMOAntikoagulation	\N	\N	3	1	\N	\N	\N
101417	Nierenersatzverfahren_Dokumentation_Balken	\N	\N	26	1	\N	\N	\N
101418	Nierenersatzverfahren_VO_Balken	\N	\N	26	1	\N	\N	\N
101419	Lungenersatzverfahren_Doku_Balken	\N	\N	26	1	\N	\N	\N
101420	Lungenersatzverfahren_Anordnung_Balken	\N	\N	26	1	\N	\N	\N
101422	Patient_KO	Körperoberfläche des Patienten ohne Fallbezug	\N	6	1	\N	\N	\N
101424	Behandlungstage	\N	\N	2	30	\N	\N	\N
101425	Stationsuebersicht	\N	\N	21	80	\N	\N	\N
101430	TabelleA_Stationsuebersicht	\N	\N	1	80	\N	\N	\N
101433	Beatmung_Messung_Compliance	Compliance	ml/mbar	6	1	\N	\N	\N
101434	Beatmung_Messung_CO2	CO2-Production	ml/min	6	1	\N	\N	\N
101435	Beatmung_Messung_Resistance	Resistance	mbar/L/s	6	1	\N	\N	\N
101436	Beatmung_Messung_AMVSpontan	Spont Minute Volume	L/min	6	1	\N	\N	\N
101437	Beatmung_Messung_Expirationszeit	\N	%	6	1	\N	\N	\N
101438	Beatmung_Messung_O2Konzentration	\N	%	6	1	\N	\N	\N
101439	Beatmung_Messung_SauerstoffFlow	\N	\N	6	1	\N	\N	\N
101440	Beatmung_Messung_DruckluftFlow	\N	\N	6	1	\N	\N	\N
101441	Beatmung_Messung_Pmean	Mean Airway Pressure	mbar	6	1	\N	\N	\N
101442	Beatmung_Messung_AF	Breathing Frequency	1/min	6	1	\N	\N	\N
101443	Beatmung_Messung_Pmin	Minimum Airway Pressure	mbar	6	1	\N	\N	\N
101444	Beatmung_Messung_IntrinsicPEEP	Intrinsic PEEP	mbar	6	1	\N	\N	\N
101446	Beatmung_Einstellung_ApnoeZeit	\N	sec	6	1	\N	\N	\N
101447	Beatmung_Messung_Pplateau	Plateau Druck	mbar	6	1	\N	\N	\N
101448	Patient_Verlusst_ExtrakorporaleAbnahme	Patient_Verlusst_ExtrakorporaleAbnahme	\N	6	1	\N	\N	\N
104391	AT_Lagerung_RechterArm	\N	\N	3	30	\N	\N	\N
101449	Patient_Blutverlusst	Patient_Blutverlusst	\N	6	1	\N	\N	\N
101455	Stationsuebersicht_erreichbarZustOberArzt	\N	\N	3	101453	\N	\N	\N
101456	Stationsuebersicht_PiepserZustOberArzt	\N	\N	3	101453	\N	\N	\N
101457	Stationsuebersicht_zustaendigerOberArzt	\N	\N	3	101453	\N	\N	\N
101459	TabelleA_Stomatha	\N	\N	3	101430	\N	\N	\N
101460	Besonderheiten_Station	\N	\N	3	20	\N	\N	\N
101472	Patient_Blutgruppe	Blutgruppe des Patienten	\N	3	1	\N	\N	\N
101473	Patient_BMI	\N	\N	6	1	\N	\N	\N
101475	VerlaufGesamt	\N	\N	1	30	\N	\N	\N
101476	VerlaufGesamt_Datum	\N	\N	5	101475	\N	\N	\N
101477	VerlaufGesamt_VerantwMitarbeiter	\N	\N	3	101475	\N	\N	\N
101478	VerlaufGesamt_Gruppe	\N	\N	3	101475	\N	\N	\N
101479	VerlaufGesamt_Bereich	\N	\N	3	101475	\N	\N	\N
101480	VerlaufGesamt_Dokumentation	\N	\N	3	101475	\N	\N	\N
101481	Beatmung_Einstellung_Sauerstoff	\N	l/min	6	1	\N	\N	\N
101482	Beatmung_Einstellung_Anfeuchtung	\N	\N	3	1	\N	\N	\N
101483	VO_Diagnostik	\N	\N	21	1	\N	\N	\N
101487	VOD_Radiologie	\N	\N	25	101483	\N	\N	\N
101488	VODRadKonventionell	\N	\N	3	101487	\N	\N	\N
101489	VODRadCT	\N	\N	3	101487	\N	\N	\N
101490	VODRadAngio	\N	\N	3	101487	\N	\N	\N
101491	VODRadSono	\N	\N	3	101487	\N	\N	\N
101492	VODRadMRT	\N	\N	3	101487	\N	\N	\N
101493	VODRadSzinti	\N	\N	3	101487	\N	\N	\N
101497	VODNeuroRad	\N	\N	3	101487	\N	\N	\N
101499	VOD_Labor	\N	\N	25	101483	\N	\N	\N
101500	VODLABRoutBGA	\N	\N	3	101499	\N	\N	\N
101501	VODLABSerumDiagnostik	\N	\N	3	101499	\N	\N	\N
101502	VODLABMedikamentenSpiegel	\N	\N	3	101499	\N	\N	\N
101503	VODLABVirusLuesDiagnostik	\N	\N	3	101499	\N	\N	\N
101504	VODLABHormonDiagnostiki.S.	\N	\N	3	101499	\N	\N	\N
101505	VODLABBlutgruppenDiagnostik	\N	\N	3	101499	\N	\N	\N
101506	VODLABGerrinnungsDiagnostik	\N	\N	3	101499	\N	\N	\N
101507	VODLABSonstiges	\N	\N	3	101499	\N	\N	\N
101508	VOD_Mikrobiologie	\N	\N	25	101483	\N	\N	\N
101509	VODMIKROBUrin	\N	\N	3	101508	\N	\N	\N
101510	VODMIKROBAtemwege	\N	\N	3	101508	\N	\N	\N
101511	VODMIKROBMagenDarm	\N	\N	3	101508	\N	\N	\N
101512	VODMIKROBSekrete	\N	\N	3	101508	\N	\N	\N
101513	VODMIKROBKatheterDrainagen	\N	\N	3	101508	\N	\N	\N
101514	VODMIKROBAbstriche	\N	\N	3	101508	\N	\N	\N
101515	VODMIKROBBlut	\N	\N	3	101508	\N	\N	\N
101516	VODMIKROBSonstiges	\N	\N	3	101508	\N	\N	\N
101517	VOD_Sonstiges	\N	\N	25	101483	\N	\N	\N
101518	VODSONSTKonsile	\N	\N	3	101517	\N	\N	\N
101519	VODSONSTEcho	\N	\N	3	101517	\N	\N	\N
101520	VODSONSTEkg	\N	\N	3	101517	\N	\N	\N
101521	VODSONSTNeurochrirurgieTCD	\N	\N	3	101517	\N	\N	\N
101522	VODSONSTEndoskopie	\N	\N	3	101517	\N	\N	\N
101523	VODSONSTElektrophysiologie	\N	\N	3	101517	\N	\N	\N
101530	TabeIntensivDiagnosen	\N	\N	1	20	\N	\N	\N
101531	TabeIntensivDiagnosen_Datum	\N	\N	5	101530	\N	\N	\N
101533	TabeIntensivDiagnosen_Dokumentation	\N	\N	3	101530	\N	\N	\N
101534	TabelleVormedikamente	\N	\N	1	20	\N	\N	\N
101535	TabelleVormedikamente_Medikament	\N	\N	3	101534	\N	\N	\N
101536	TabelleVormedikamente_Dosierung	\N	\N	3	101534	\N	\N	\N
101537	TabelleVormedikamente_Rhytmus	\N	\N	3	101534	\N	\N	\N
101538	TabelleVormedikamente_LetzteEinnahme	\N	\N	3	101534	\N	\N	\N
101539	TabelleOPSAnaesthesie	\N	\N	1	20	\N	\N	\N
101540	TabeOPSAnaesthesie_Datum	\N	\N	5	101539	\N	\N	\N
101541	TabeOPSAnaesthesie_Arzt	\N	\N	3	101539	\N	\N	\N
101542	TabeOPSAnaesthesie_Op	\N	\N	3	101539	\N	\N	\N
101543	TabeOPSAnaesthesie_AnaesthesieArt	\N	\N	3	101539	\N	\N	\N
101544	TabeOPSAnaesthesie_AnaesthesieDauer	\N	\N	3	101539	\N	\N	\N
101545	TabeOPSAnaesthesie_AnaesthesieVolumenVerlust	\N	\N	3	101539	\N	\N	\N
101546	TabeOPSAnaesthesie_AnaesthesieVolumenErsatz	\N	\N	3	101539	\N	\N	\N
101547	TabeOPSAnaesthesie_AnaesthesieAusscheidung	\N	\N	3	101539	\N	\N	\N
101548	TabeOPSAnaesthesie_AnaesthesieKomplikationen	\N	\N	3	101539	\N	\N	\N
101577	TabelleAerzteAnamnese	\N	\N	1	20	\N	\N	\N
101579	TabelleAerzteAnamnese_VerantwMitarbeiter	\N	\N	3	101577	\N	\N	\N
101580	TabelleAerzteAnamnese_Dokumentation	\N	\N	3	101577	\N	\N	\N
101581	TabelleAerzteAnamnese_Gruppe	\N	\N	3	101577	\N	\N	\N
101627	Beatmung_Proc_AMV	\N	\N	32	1	\N	\N	\N
101583	TabelleAerzteAnamnese_Bereich	\N	\N	3	101577	\N	\N	\N
101584	TabeIntensivDiagnosen_VerantwMitarbeiter	\N	\N	3	101530	\N	\N	\N
101585	TabelleAerzteAufnahmestatus	\N	\N	1	20	\N	\N	\N
101586	TabelleAerzteAufnahmestatus_Datum	\N	\N	3	101585	\N	\N	\N
101587	TabelleAerzteAufnahmestatus_VerantwMitarbeiter	\N	\N	3	101585	\N	\N	\N
101588	TabelleAerzteAufnahmestatus_Vitalfunktionstoerung	\N	\N	3	101585	\N	\N	\N
101589	TabelleAerzteAufnahmestatus_Grundkrankheit	\N	\N	3	101585	\N	\N	\N
101590	TabelleAerzteAufnahmestatus_Verletzung	\N	\N	3	101585	\N	\N	\N
101591	TabelleAerzteAufnahmestatus_Begleitkrankheit	\N	\N	3	101585	\N	\N	\N
101594	TabelleAerzteAnamnese_Datum	\N	\N	5	101577	\N	\N	\N
101595	Beatmung_VO_AF	Verordnung Ziel-Atemfrequenz	1/min	30	1	\N	\N	\N
101596	Beatmung_Proc_AF	Angeordnete Ziel-Atemfrequenz für Pflege	1/min	32	1	\N	\N	\N
101597	VerlegPfl_Koerperpfl_Hautstatus2	\N	\N	3	30	\N	\N	\N
101598	Beatmung_Anordnung_AbbruchkriterienAF	\N	\N	3	1	\N	\N	\N
101599	Beatmung_Anordnung_AbbruchkriterienAMV	\N	\N	3	1	\N	\N	\N
101600	Beatmung_Anordnung_AbbruchkriterienPzvCO2	\N	\N	3	1	\N	\N	\N
101601	Beatmung_Anordnung_AbbruchkriterienAFVt	\N	\N	3	1	\N	\N	\N
101602	Beatmung_Anordnung_AbbruchkriterienSpO2	\N	\N	3	1	\N	\N	\N
101603	Beatmung_Anordnung_AbbruchkriterienFiO2	\N	\N	3	1	\N	\N	\N
101604	Beatmung_Anordnung_AbbruchkriterienSAP	\N	\N	3	1	\N	\N	\N
101605	Beatmung_Anordnung_AbbruchkriterienMAP	\N	\N	3	1	\N	\N	\N
101606	Beatmung_Anordnung_AbbruchkriterienHR	\N	\N	3	1	\N	\N	\N
101607	Beatmung_Anordnung_AbbruchkriterienNeurologie	\N	\N	3	1	\N	\N	\N
101608	Beatmung_Anordnung_AbbruchkriterienPHzv	\N	\N	3	1	\N	\N	\N
101611	Score_Braden_ReibungUScherkraefte	\N	\N	27	101609	\N	\N	\N
101612	Score_Braden_Mobilitaet	\N	\N	27	101609	\N	\N	\N
101613	Score_Braden_Ernaehrung	\N	\N	27	101609	\N	\N	\N
101614	Score_Braden_Feuchtigkeit	\N	\N	27	101609	\N	\N	\N
101615	Score_Braden_Aktivitaet	\N	\N	27	101609	\N	\N	\N
101616	Score_Braden_SensorischesEmpfindungsvermoegen	\N	\N	27	101609	\N	\N	\N
101617	Beatmung_VO_AMV	\N	\N	30	1	\N	\N	\N
101618	Beatmung_VO_ASB	\N	\N	30	1	\N	\N	\N
101619	Beatmung_VO_FiO2	\N	\N	30	1	\N	\N	\N
101620	Beatmung_VO_Flow	\N	\N	30	1	\N	\N	\N
101621	Beatmung_VO_IzuE	\N	\N	30	1	\N	\N	\N
101622	Beatmung_VO_PEEP	\N	\N	30	1	\N	\N	\N
101623	Beatmung_VO_VT	\N	\N	30	1	\N	\N	\N
101624	Beatmung_VO_O2	\N	\N	30	1	\N	\N	\N
101625	Beatmung_VO_Pmax	\N	\N	30	1	\N	\N	\N
101626	Beatmung_VO_PPlateau	\N	\N	30	1	\N	\N	\N
101628	Beatmung_Proc_ASB	\N	\N	32	1	\N	\N	\N
101629	Beatmung_Proc_FiO2	\N	\N	32	1	\N	\N	\N
101630	Beatmung_Proc_Flow	\N	\N	32	1	\N	\N	\N
101631	Beatmung_Proc_IzuE	\N	\N	32	1	\N	\N	\N
101632	Beatmung_Proc_PEEP	\N	\N	32	1	\N	\N	\N
101633	Beatmung_Proc_VT	\N	\N	32	1	\N	\N	\N
101634	Beatmung_Proc_O2	\N	\N	32	1	\N	\N	\N
101635	Beatmung_Proc_Pmax	\N	\N	32	1	\N	\N	\N
101636	Beatmung_Proc_PPlateau	\N	\N	32	1	\N	\N	\N
101641	Beatmung_VO_BedingteVerordnung	\N	\N	29	1	\N	\N	\N
101642	Beatmung_Proc_BedingteVerordnung	\N	\N	31	1	\N	\N	\N
101644	Beatmung_VO_GeraetForm	\N	\N	29	1	\N	\N	\N
101645	Beatmung_Proc_GeraetForm	\N	\N	31	1	\N	\N	\N
101646	Score_Braden_Datum	\N	\N	5	101609	\N	\N	\N
101652	Zugaenge_Ausfuhr	\N	ml	6	100179	\N	\N	\N
101654	TabelleVerlaufAerzte_Datum	\N	\N	5	101653	\N	\N	\N
101660	TabelleVerlaufPflege_Datum	\N	\N	5	101659	\N	\N	\N
101665	TabelleDiagnostik	\N	\N	1	30	\N	\N	\N
101666	TabelleDiagnostik_Datum	\N	\N	5	101665	\N	\N	\N
101667	TabelleDiagnostik_Gruppe	\N	\N	3	101665	\N	\N	\N
101668	TabelleDiagnostik_Bereich	\N	\N	3	101665	\N	\N	\N
101669	TabelleDiagnostik_Dokumentation	\N	\N	3	101665	\N	\N	\N
101670	TabelleDiagnostik_VerantwMitarbeiter	\N	\N	3	101665	\N	\N	\N
101671	TabelleKonsile	\N	\N	1	30	\N	\N	\N
101672	TabelleKonsile_Datum	\N	\N	5	101671	\N	\N	\N
101673	TabelleKonsile_Gruppe	\N	\N	3	101671	\N	\N	\N
101674	TabelleKonsile_Bereich	\N	\N	3	101671	\N	\N	\N
101675	TabelleKonsile_Dokumentation	\N	\N	3	101671	\N	\N	\N
101676	TabelleKonsile_VerantwMitarbeiter	\N	\N	3	101671	\N	\N	\N
101677	TabelleMassnahmenEingriffeAerzte	\N	\N	1	30	\N	\N	\N
101678	TabelleMassnahmenEingriffeAerzte_Datum	\N	\N	5	101677	\N	\N	\N
101679	TabelleMassnahmenEingriffeAerzte_Gruppe	\N	\N	3	101677	\N	\N	\N
101680	TabelleMassnahmenEingriffeAerzte_Bereich	\N	\N	3	101677	\N	\N	\N
101681	TabelleMassnahmenEingriffeAerzte_Dokumentation	\N	\N	3	101677	\N	\N	\N
101682	TabelleMassnahmenEingriffeAerzte_VerantwMitarbeite	\N	\N	3	101677	\N	\N	\N
101683	Messsonden	\N	\N	21	1	\N	\N	\N
101684	Messsonden_Wert	\N	\N	25	101683	\N	\N	\N
101685	Messsonden_gelegt_am	\N	\N	5	101683	\N	\N	\N
101686	Messsonden_entfernt_am	\N	\N	5	101683	\N	\N	\N
101689	Messsonden_vorhanden	\N	\N	2	101683	\N	\N	\N
101692	Messsonden_Beobachtung	\N	\N	3	101684	\N	\N	\N
101696	Mikrobio	\N	\N	1	20	\N	\N	\N
101698	Mikrobio_Pyrazinamid	\N	\N	3	101696	\N	\N	\N
101699	Mikrobio_Ethambutol	\N	\N	3	101696	\N	\N	\N
101700	Mikrobio_Rifampicin	\N	\N	3	101696	\N	\N	\N
101701	Mikrobio_Streptomycin	\N	\N	3	101696	\N	\N	\N
101702	Mikrobio_Caspofungin	\N	\N	3	101696	\N	\N	\N
101703	Mikrobio_Voriconazol	\N	\N	3	101696	\N	\N	\N
101704	Mikrobio_Fluconazol	\N	\N	3	101696	\N	\N	\N
101705	Mikrobio_AmphotericinB	\N	\N	3	101696	\N	\N	\N
101706	Mikrobio_ESBL	\N	\N	3	101696	\N	\N	\N
101707	Mikrobio_Metronidazol	\N	\N	3	101696	\N	\N	\N
101708	Mikrobio_Colistin	\N	\N	3	101696	\N	\N	\N
101709	Mikrobio_Tigecyclin	\N	\N	3	101696	\N	\N	\N
101710	Mikrobio_Daptomycin	\N	\N	3	101696	\N	\N	\N
101711	Mikrobio_Linezolid	\N	\N	3	101696	\N	\N	\N
101712	Mikrobio_Fusidinsaeure	\N	\N	3	101696	\N	\N	\N
101713	Mikrobio_Fosfomycin	\N	\N	3	101696	\N	\N	\N
101714	Mikrobio_Vancomycin	\N	\N	3	101696	\N	\N	\N
101715	Mikrobio_Teicoplanin	\N	\N	3	101696	\N	\N	\N
101716	Mikrobio_Clindamycin	\N	\N	3	101696	\N	\N	\N
101717	Mikrobio_Erythromycin	\N	\N	3	101696	\N	\N	\N
101718	Mikrobio_Cotrimoxazol	\N	\N	3	101696	\N	\N	\N
101719	Mikrobio_Tobramycin	\N	\N	3	101696	\N	\N	\N
101720	Mikrobio_KanamycinHL	\N	\N	3	101696	\N	\N	\N
101721	Mikrobio_StreptomycinHL	\N	\N	3	101696	\N	\N	\N
101722	Mikrobio_GentamicinHL	\N	\N	3	101696	\N	\N	\N
101723	Mikrobio_Gentamicin	\N	\N	3	101696	\N	\N	\N
101724	Mikrobio_Moxifloxacin	\N	\N	3	101696	\N	\N	\N
101725	Mikrobio_Levofloxacin	\N	\N	3	101696	\N	\N	\N
101726	Mikrobio_Ciprofloxacin	\N	\N	3	101696	\N	\N	\N
101727	Mikrobio_Ertapenem	\N	\N	3	101696	\N	\N	\N
101728	Mikrobio_Metropenem	\N	\N	3	101696	\N	\N	\N
101729	Mikrobio_Imipenem	\N	\N	3	101696	\N	\N	\N
101730	Mikrobio_Aztreonam	\N	\N	3	101696	\N	\N	\N
101731	Mikrobio_Ceftobiprol	\N	\N	3	101696	\N	\N	\N
101732	Mikrobio_Cefoxitin	\N	\N	3	101696	\N	\N	\N
101733	Mikrobio_Cefepim	\N	\N	3	101696	\N	\N	\N
101734	Mikrobio_Ceftazidim	\N	\N	3	101696	\N	\N	\N
101735	Mikrobio_Ceftriaxon	\N	\N	3	101696	\N	\N	\N
101736	Mikrobio_Cefotaxim	\N	\N	3	101696	\N	\N	\N
101737	Mikrobio_Cefuroxim	\N	\N	3	101696	\N	\N	\N
101738	Mikrobio_Cefotiam	\N	\N	3	101696	\N	\N	\N
101739	Mikrobio_Cefazolin	\N	\N	3	101696	\N	\N	\N
101740	Mikrobio_Mezlocillin	\N	\N	3	101696	\N	\N	\N
101741	Mikrobio_PipTazo	\N	\N	3	101696	\N	\N	\N
101742	Mikrobio_Piperacillin	\N	\N	3	101696	\N	\N	\N
101743	Mikrobio_AmoxiCalv	\N	\N	3	101696	\N	\N	\N
101744	Mikrobio_Amoxicillin	\N	\N	3	101696	\N	\N	\N
101745	Mikrobio_AmpiSulb	\N	\N	3	101696	\N	\N	\N
101746	Mikrobio_Ampicillin	\N	\N	3	101696	\N	\N	\N
101747	Mikrobio_Oxacillin	\N	\N	3	101696	\N	\N	\N
101748	Mikrobio_PenicillinG	\N	\N	3	101696	\N	\N	\N
101749	Mikrobio_Erreger	\N	\N	3	101696	\N	\N	\N
101750	Mikrobio_Isoniazid	\N	\N	3	101696	\N	\N	\N
101751	Mikrobio_EntnahmeOrt	\N	\N	3	101696	\N	\N	\N
101752	Mikrobio_DokuZeit	\N	\N	5	101696	\N	\N	\N
101753	Mikrobio_AnforderungsID	\N	\N	3	101696	\N	\N	\N
101754	Mikrobio_AntibiotikumNeu	\N	\N	3	101696	\N	\N	\N
101755	Mikrobio_AntibiotikumAlt	\N	\N	3	101696	\N	\N	\N
101756	Mikrobio_Verdachtsdiagnose	\N	\N	3	101696	\N	\N	\N
101757	Mikrobio_DurchgefuehrtVon	\N	\N	3	101696	\N	\N	\N
101759	TabelleA_ArztA	Verantwortlicher Arzt für den zugeordneten Bettplatz	\N	15	101430	\N	\N	\N
101760	TabelleA_BettplatzA	Bettplatz für Zuordnung der verantwortlichen Mitarbeiter	\N	15	101430	\N	\N	\N
101761	TabelleA_PflegekraftA	Verantwortliche Pflegekraft für den zugeordneten Bettplatz	\N	15	101430	\N	\N	\N
101762	TabelleA_PhysiotherapieA	Physiotherapie	\N	15	101430	\N	\N	\N
101763	Patient_Kopfumfang	Kopfumfang des Patienten (Kinder)	\N	3	1	\N	\N	\N
101773	Patient_Verfügung	\N	\N	3	1	\N	\N	\N
101778	Angehoerige1_Strasse	\N	\N	3	1	\N	\N	\N
101779	Angehoerige1_PLZ	\N	\N	3	1	\N	\N	\N
101780	Angehoerige1_Ort	\N	\N	3	1	\N	\N	\N
101781	Angehoerige1_Land	\N	\N	3	1	\N	\N	\N
101786	Hausarzt_Name	\N	\N	3	1	\N	\N	\N
101787	Hausarzt_Strasse	\N	\N	3	1	\N	\N	\N
101788	Hausarzt_PLZ	\N	\N	3	1	\N	\N	\N
101789	Hausarzt_Ort	\N	\N	3	1	\N	\N	\N
101790	Hausarzt_Land	\N	\N	3	1	\N	\N	\N
101793	Hausarzt_Telefon	\N	\N	3	1	\N	\N	\N
101794	Hausarzt_Fax	\N	\N	3	1	\N	\N	\N
101795	Hausarzt_Email	\N	\N	3	1	\N	\N	\N
101798	TabelleB_Stationsuebersicht	\N	\N	1	80	\N	\N	\N
101800	TabelleB_ArztB	\N	\N	15	101798	\N	\N	\N
101801	TabelleB_BettplatzB	\N	\N	15	101798	\N	\N	\N
101802	TabelleB_PflegekraftB	\N	\N	15	101798	\N	\N	\N
101803	TabelleB_PhysiotherapieB	\N	\N	15	101798	\N	\N	\N
101804	TabelleB_Stomatha	\N	\N	3	101798	\N	\N	\N
101805	TabelleA_AT02_1	\N	\N	2	101430	\N	\N	\N
101806	TabelleA_AT02_2	\N	\N	2	101430	\N	\N	\N
101807	TabelleA_AT02_3	\N	\N	2	101430	\N	\N	\N
101808	TabelleA_AT02_4	\N	\N	2	101430	\N	\N	\N
101809	TabelleA_AT02_5	\N	\N	2	101430	\N	\N	\N
101810	TabelleA_AT02_6	\N	\N	2	101430	\N	\N	\N
101811	TabelleA_AT03_1	\N	\N	2	101430	\N	\N	\N
101812	TabelleA_AT03_2	\N	\N	2	101430	\N	\N	\N
101813	TabelleA_AT03_3	\N	\N	2	101430	\N	\N	\N
101814	Mikrobio_Sonstige1	\N	\N	3	101696	\N	\N	\N
101815	Mikrobio_Sonstige2	\N	\N	3	101696	\N	\N	\N
101816	Mikrobio_Sonstige3	\N	\N	3	101696	\N	\N	\N
101817	Mikrobio_Sonstige4	\N	\N	3	101696	\N	\N	\N
101820	Behandlungsstrategie_MessintervalleHF	\N	\N	6	30	\N	\N	\N
101821	Behandlungsstrategie_MessintervalleRR	\N	\N	6	30	\N	\N	\N
101822	Behandlungsstrategie_MessintervalleMAP	\N	\N	6	30	\N	\N	\N
101823	Behandlungsstrategie_MessintervalleTemp	\N	\N	6	30	\N	\N	\N
101824	Behandlungsstrategie_MessintervalleAF	\N	\N	6	30	\N	\N	\N
101825	Behandlungsstrategie_MessintervalleSaO2	\N	\N	6	30	\N	\N	\N
101826	Behandlungsstrategie_ZielvorgabenRR	\N	\N	6	30	\N	\N	\N
101827	Behandlungsstrategie_ZielvorgabenMAP	\N	\N	6	30	\N	\N	\N
101828	Behandlungsstrategie_ZielvorgabenPaCO2	\N	\N	6	30	\N	\N	\N
101829	Behandlungsstrategie_ZielvorgabenSPO2	\N	\N	6	30	\N	\N	\N
101830	Behandlungsstrategie_ZielvorgabenCO2	\N	\N	6	30	\N	\N	\N
101831	Behandlungsstrategie_ZielvorgabenPH	\N	\N	6	30	\N	\N	\N
101832	Behandlungsstrategie_ZielvorgabenRamsay	\N	\N	6	30	\N	\N	\N
101833	Behandlungsstrategie_ZielvorgabenRASS	\N	\N	6	30	\N	\N	\N
101834	Behandlungsstrategie_ZielvorgabenUrinH	\N	\N	6	30	\N	\N	\N
101835	Behandlungsstrategie_ZielvorgabenZielD	\N	\N	6	30	\N	\N	\N
101836	Behandlungsstrategie_ZielvorgabenBZ	\N	\N	6	30	\N	\N	\N
101837	Behandlungsstrategie_ZielvorgabenKostform	\N	\N	3	30	\N	\N	\N
101838	Behandlungsstrategie_ZielvorgabenBesonderheiten	\N	\N	3	30	\N	\N	\N
101839	Behandlungsstrategie_MessintervalleAF_Freitext	\N	\N	3	30	\N	\N	\N
101840	Behandlungsstrategie_MessintervalleHF_Freitext	\N	\N	3	30	\N	\N	\N
101841	Behandlungsstrategie_MessintervalleMAP_Freitext	\N	\N	3	30	\N	\N	\N
101842	Behandlungsstrategie_MessintervalleRR_Freitext	\N	\N	3	30	\N	\N	\N
101843	Behandlungsstrategie_MessintervalleSaO2_Freitext	\N	\N	3	30	\N	\N	\N
101844	Behandlungsstrategie_MessintervalleTemp_Freitext	\N	\N	3	30	\N	\N	\N
101846	Behandlungsstrategie_ZielvorgabenBZ_Freitext	\N	\N	3	30	\N	\N	\N
101847	Behandlungsstrategie_ZielvorgabenCO2_Freitext	\N	\N	3	30	\N	\N	\N
101848	Behandlungsstrategie_ZielvorgabenKostform_Freitext	\N	\N	3	30	\N	\N	\N
101849	Behandlungsstrategie_ZielvorgabenMAP_Freitext	\N	\N	3	30	\N	\N	\N
101850	Behandlungsstrategie_ZielvorgabenPaCO2_Freitext	\N	\N	3	30	\N	\N	\N
101851	Behandlungsstrategie_ZielvorgabenPH_Freitext	\N	\N	3	30	\N	\N	\N
101852	Behandlungsstrategie_ZielvorgabenRamsay_Freitext	\N	\N	3	30	\N	\N	\N
101853	Behandlungsstrategie_ZielvorgabenRASS_Freitext	\N	\N	3	30	\N	\N	\N
101854	Behandlungsstrategie_ZielvorgabenRR_Freitext	\N	\N	3	30	\N	\N	\N
101855	Behandlungsstrategie_ZielvorgabenSaO2	\N	\N	3	30	\N	\N	\N
101856	Behandlungsstrategie_ZielvorgabenUrinH_Freitext	\N	\N	3	30	\N	\N	\N
101857	Behandlungsstrategie_ZielvorgabenZielD_Freitext	\N	\N	3	30	\N	\N	\N
101858	Behandlungsstrategie_ZielvorgabenPaO2	\N	\N	6	30	\N	\N	\N
101859	Behandlungsstrategie_ZielvorgabenPaO2_Freitext	\N	\N	3	30	\N	\N	\N
101860	KlinikKopf_HalsHaut_Wert	\N	\N	25	100345	\N	\N	\N
101861	KlinikKopf_HalsHaut_Allgemein	\N	\N	3	101860	\N	\N	\N
101862	KlinikKopf_HalsHaut_Befragung	\N	\N	3	101860	\N	\N	\N
101863	KlinikKopf_HalsHaut_DrainageKatheter	\N	\N	3	101860	\N	\N	\N
101864	KlinikKopf_HalsHaut_Inspektion	\N	\N	3	101860	\N	\N	\N
101865	KlinikKopf_HalsHaut_Palpation	\N	\N	3	101860	\N	\N	\N
101866	KlinikKopf_HalsHaut_Sekret	\N	\N	3	101860	\N	\N	\N
101867	KlinikKopf_HalsHaut_Tracheostoma	\N	\N	3	101860	\N	\N	\N
101871	KlinikKopf_HalsHaut_Verletzungen	\N	\N	3	101860	\N	\N	\N
101872	KlinikKopf_HalsHaut_Verband	\N	\N	3	101860	\N	\N	\N
101873	KlinikStamm_LeisteHaut_Wert	\N	\N	25	100999	\N	\N	\N
101875	KlinikStamm_LeisteHaut_Allgemein	\N	\N	3	101873	\N	\N	\N
101876	KlinikStamm_LeisteHaut_Befragung	\N	\N	3	101873	\N	\N	\N
101877	KlinikStamm_LeisteHaut_Drainage	\N	\N	3	101873	\N	\N	\N
101878	KlinikStamm_LeisteHaut_Inspektion	\N	\N	3	101873	\N	\N	\N
101879	KlinikStamm_LeisteHaut_Palpation	\N	\N	3	101873	\N	\N	\N
101880	KlinikStamm_LeisteHaut_Sekret	\N	\N	3	101873	\N	\N	\N
101881	KlinikStamm_LeisteHaut_Sensibilitaet	\N	\N	3	101873	\N	\N	\N
101882	KlinikStamm_LeisteHaut_Verband	\N	\N	3	101873	\N	\N	\N
101883	KlinikStamm_LeisteHaut_Verletzung	\N	\N	3	101873	\N	\N	\N
101885	KlinikHerzKreislaufFunktion	\N	\N	21	1	\N	\N	\N
101887	KlinikHerzKreislaufFunktion_ATAtemform_Wert	\N	\N	25	101885	\N	\N	\N
101888	KlinikHerzKreislaufFunktion_ATAtemform_Atemform	\N	\N	3	101887	\N	\N	\N
101890	KlinikHerzKreislaufFunktion_ATCO2_Wert	\N	\N	25	101885	\N	\N	\N
101891	KlinikHerzKreislaufFunktion_ATCO2_Allgemein	\N	\N	3	101890	\N	\N	\N
101892	KlinikHerzKreislaufFunktion_ATCO2_PaCO2	\N	\N	3	101890	\N	\N	\N
101893	KlinikHerzKreislaufFunktion_ATOXY_Wert	\N	\N	25	101885	\N	\N	\N
101894	KlinikHerzKreislaufFunktion_ATOXY_Allgemein	\N	\N	3	101893	\N	\N	\N
101895	KlinikHerzKreislaufFunktion_ATOXY_OxyIndexPaO2FiO2	\N	\N	3	101893	\N	\N	\N
101896	KlinikHerzKreislaufFunktion_ATOXY_PaO2	\N	\N	3	101893	\N	\N	\N
101897	KlinikHerzKreislaufFunktion_ATOXY_pulsOxySAO2	\N	\N	3	101893	\N	\N	\N
101899	KlinikHerzKreislaufFunktion_HFKammerF_Wert	Herz Funktion Kammerfüllung	\N	25	101885	\N	\N	\N
101900	KlinikHerzKreislaufFunktion_HFKammerF_PulKapiDruck	\N	\N	3	101899	\N	\N	\N
101901	KlinikHerzKreislaufFunktion_HFKammerF_LiArtriEDiaD	Linksartrialer enddiastolischer Druck	\N	3	101899	\N	\N	\N
101902	KlinikHerzKreislaufFunktion_HFKammerF_ZVD	\N	\N	3	101899	\N	\N	\N
101903	KlinikHerzKreislaufFunktion_HFReizbild_Wert	Herz Funktion Reizbildung	\N	25	101885	\N	\N	\N
101904	KlinikHerzKreislaufFunktion_HFReizbild_Reizbildung	\N	\N	3	101903	\N	\N	\N
101906	KlinikHerzKreislaufFunktion_KMakrozirkulation_Wert	\N	\N	25	101885	\N	\N	\N
101909	KlinikHerzKreislaufFunktion_KMikrozirkulation_Wert	\N	\N	25	101885	\N	\N	\N
101910	KlinikHerzKreislaufFunktion_KMakrozirkulation_Allg	\N	\N	3	101906	\N	\N	\N
103592	Patient_Allergie_Zusatz	\N	\N	3	1	\N	\N	Patient Allergie (Zusatz-Informationen)
103593	Patient_Allergie_Text	\N	\N	3	103591	\N	\N	Patient Allergie (Text)
103596	Patient_Besonderheit_Text	\N	\N	3	103595	\N	\N	Besonderheiten
103601	Patient_Infektion_Text	\N	\N	3	103598	\N	\N	Patient Infektion (Text)
103605	Atemwege_Lage_Aufnahme	Lokalisation des Atemwegszuganges	\N	3	100132	\N	\N	Atemwege (Lage)
103606	EnteraleSonden_Lage_Aufnahme	Lokalisation der enteralen Sonde	\N	3	100133	\N	\N	Gastroenterale Sonden (Lage)
103614	Wunddokumentation_Beobachtung_Aufnahme	Beschreibung der Wunde, mit Listenauswahl	\N	3	100189	\N	\N	Wunden u. Defekte (1. Beobachtung)
103620	Dekubitus_Wert_VACPumpe	Gerät zur Sekretmobilisation, Listenanhang	\N	3	100186	\N	\N	Dekubitus (VAC Pumpe)
101911	KlinikHerzKreislaufFunktion_KMakrozirkulation_DiaD	Diastolischer Druck	\N	3	101906	\N	\N	\N
101912	KlinikHerzKreislaufFunktion_KMakrozirkulation_Hf	Herzfrequenz	\N	3	101906	\N	\N	\N
101913	KlinikHerzKreislaufFunktion_KMakrozirkulation_Puls	Pulse	\N	3	101906	\N	\N	\N
101914	KlinikHerzKreislaufFunktion_KMakrozirkulation_SysD	Systolischer Druck	\N	3	101906	\N	\N	\N
101915	KlinikHerzKreislaufFunktion_KMikrozirkulation_Allg	\N	\N	3	101909	\N	\N	\N
101916	KlinikHerzKreislaufFunktion_Wasserhaush_Wert	Wasserhaushalt	\N	25	101885	\N	\N	\N
101917	KlinikHerzKreislaufFunktion_Wasserhaush_Wasser	\N	\N	3	101916	\N	\N	\N
101918	KlinikExtraemitaeten_untere_Wert	\N	\N	25	101000	\N	\N	\N
101919	KlinikExtraemitaeten_untere_Allgemein	\N	\N	3	101918	\N	\N	\N
101920	KlinikExtraemitaeten_untere_Befragung	\N	\N	3	101918	\N	\N	\N
101921	KlinikExtraemitaeten_untere_Doppleruntersuchung	\N	\N	3	101918	\N	\N	\N
101922	KlinikExtraemitaeten_untere_DrainageZugaenge	\N	\N	3	101918	\N	\N	\N
101923	KlinikExtraemitaeten_untere_Inspektion	\N	\N	3	101918	\N	\N	\N
101924	KlinikExtraemitaeten_untere_Palpation	\N	\N	3	101918	\N	\N	\N
101925	KlinikExtraemitaeten_untere_Schienung	\N	\N	3	101918	\N	\N	\N
101926	KlinikExtraemitaeten_untere_Sekret	\N	\N	3	101918	\N	\N	\N
101927	KlinikExtraemitaeten_untere_Sensibilitaet	\N	\N	3	101918	\N	\N	\N
101928	KlinikExtraemitaeten_untere_Verband	\N	\N	3	101918	\N	\N	\N
101929	KlinikExtraemitaeten_untere_Verletzung	\N	\N	3	101918	\N	\N	\N
101930	KlinikNervensys_VegetativeFunktion_Wert	\N	\N	25	101009	\N	\N	\N
103621	EnteraleSonden_Systemwechsel	Dokumentation von durchgeführten Systemwechseln bei Enteralen Sonden	\N	3	100165	\N	\N	Enterale Sonden (Systemwechsel)
103627	Wunddokumentation_VACModus	Dokumentation des eingestellten Modus der V.A.C. Pumpe	\N	3	100193	\N	\N	Wunden u. Defekte (VAC Modus)
103628	Wunddokumentation_VACIntensitaet	Dokumentation der eingestellten Intensität der V.A.C. Pumpe	\N	3	100193	\N	\N	Wunden u. Defekte (VAC Intensität)
103629	Dekubitus_Grad_Verlauf	Verlaufsdokumentation bzgl. des Dekubitusgrades	\N	3	100186	\N	\N	Dekubitus (Grad)
103631	Dekubitus_Beobachtung_Verlauf	Verlaufdokumentation der Beobachtung bzgl. des Dekubitus	\N	3	100186	\N	\N	Dekubitus (Beobachtung)
103632	Dekubitus_VACModus	Dokumentation des V.A.C. Pumpen Modus bei Dekubiti	\N	3	100186	\N	\N	Dekubitus (VAC Modus)
103633	Dekubitus_VACIntensitaet	Dokumentation der V.A.C. Pumpen Einstellung bzgl. der Intensität	\N	3	100186	\N	\N	Dekubitus (VAC Intensität)
101931	KlinikNervensys_VegetativeFunktion_Schweiss	\N	\N	3	101930	\N	\N	\N
101934	KlinikNervensys_Kerntemperatur_Wert	\N	\N	25	101009	\N	\N	\N
101935	KlinikNervensys_Kerntemperatur_Temp	Kerntemperatur	\N	3	101934	\N	\N	\N
101936	KlinikNervensys_PeriMotorik_Wert	\N	\N	25	101009	\N	\N	\N
101938	KlinikNervensys_PeriSensibilitaet_Wert	\N	\N	25	101009	\N	\N	\N
101941	KlinikNervensys_PeriVegetativum_Wert	\N	\N	25	101009	\N	\N	\N
101942	KlinikNervensys_PeriMotorik_Allgemein	\N	\N	3	101936	\N	\N	\N
101944	KlinikNervensys_PeriSensibilitaet_Allgemein	\N	\N	3	101938	\N	\N	\N
101945	KlinikNervensys_PeriVegetativum_Vegetativum	\N	\N	3	101941	\N	\N	\N
101946	TISS28_TS_Datum	\N	\N	5	100000	\N	\N	\N
101948	Score_TISS28_Wert	\N	\N	2	101947	\N	\N	\N
101949	Score_TISS28_InterventionAufICU	\N	\N	27	101947	\N	\N	\N
101950	Score_TISS28_InotropikaGabe	\N	\N	27	101947	\N	\N	\N
101951	Score_TISS28_Beatmung	\N	\N	27	101947	\N	\N	\N
101952	Score_TISS28_Routineverbandswechsel	\N	\N	27	101947	\N	\N	\N
101953	Score_TISS28_Medikamentengabe	\N	\N	27	101947	\N	\N	\N
101954	Score_TISS28_artKatheter	\N	\N	27	101947	\N	\N	\N
101955	Score_TISS28_intravFluessTh	intrav. Flüss.-Therapie	\N	27	101947	\N	\N	\N
101956	Score_TISS28_ICPMessung	\N	\N	27	101947	\N	\N	\N
101957	Score_TISS28_mediNierenunterstuetzung	\N	\N	27	101947	\N	\N	\N
101958	Score_TISS28_Bilanzierung	\N	\N	27	101947	\N	\N	\N
103658	Enteralesonden_Markierung_Aufnahme	\N	\N	3	100133	\N	\N	Gastroenterale Sonden (Markierung)
103659	Atemwege_Markierung_Aufnahme	\N	\N	3	100132	\N	\N	Atemwege (Markierung)
103662	Messsonden_ersteBeobachtung	Dokumentation der ersten Beobachtung bzgl. Messsonden bei Aufnahme oder Anlage	\N	3	101683	\N	\N	Messsonden (1. Beobachtung)
103663	Drainagen_Beobachtung_Aufnahme	Dokumentation der Erstbeobachtung bzgl. Drainagen bei Anlage oder Aufnahme	\N	3	100135	\N	\N	Drainage (1. Beobachtung)
103664	Darm_Beobachtung_Aufnahme	Dokumentation bei Anlege oder Aufnahme	\N	3	102444	\N	\N	Darmentleerung (1. Beobachtung)
103665	HarnwegeDarm_Beobachtung_Aufnahme	Dokumentation der Erstbeobachtung bzgl. Harnwege bei Anlage oder Aufnahme	\N	3	100134	\N	\N	Urinausscheidung (1. Beobachtung)
103666	Enteralesonden_Beobachtung_Aufnahme	\N	\N	3	100133	\N	\N	Gastroenterale Sonden (1. Beobachtung)
103667	Atemwege_Beobachtung_Aufnahme	\N	\N	3	100132	\N	\N	Atemwege (1. Beobachtung)
103668	Zugaenge_Beobachtung_Aufnahme	\N	\N	3	100131	\N	\N	Zugänge (1. Beobachtung)
103670	Dekubitus_Beobachtung_Aufnahme	Erste Beobachtungbzgl. des Dekubitus bei Aufnahme oder erstem Erkennen	\N	3	100182	\N	\N	Dekubitus (1. Beobachtung)
103671	Dekubitus_Tiefe_Aufnahme	Beschreibung der Dekubitustiefe bei Aufnahme oder Erstbeobachtung	\N	3	100182	\N	\N	Dekubitus (Tiefe)
103714	UeberwiesenVonPOE	\N	\N	3	30	\N	\N	\N
101959	Score_TISS28_extrakorpNierenersatz	\N	\N	27	101947	\N	\N	\N
101960	Score_TISS28_enteraleErn	enterale Ernährung (Sonde)	\N	27	101947	\N	\N	\N
101961	Score_TISS28_parentErnaehrung	parentale Ernährung	\N	27	101947	\N	\N	\N
101962	Score_TISS28_AzidoseAlkalose	\N	\N	27	101947	\N	\N	\N
101963	Score_TISS28_TransIntensivP	Transpoort eines Intensivpatienten	\N	27	101947	\N	\N	\N
101964	Score_TISS28_ReanimationDefibr	\N	\N	27	101947	\N	\N	\N
101965	Score_TISS28_zentralvZugang	zentralvenöser Zugang	\N	27	101947	\N	\N	\N
101966	Score_TISS28_erweitHaemoynMonit	\N	\N	27	101947	\N	\N	\N
101967	Score_TISS28_VerbesserungLufu	Verbesserung der Lufu.	\N	27	101947	\N	\N	\N
101968	Score_TISS28_Tubuspflege	\N	\N	27	101947	\N	\N	\N
101969	Score_TISS28_Drainagenpflege	\N	\N	27	101947	\N	\N	\N
101970	Score_TISS28_LaborMibi	Labor / Midi	\N	27	101947	\N	\N	\N
101971	Score_TISS28_StandMonit	Standard Monitoring	\N	27	101947	\N	\N	\N
101972	Score_TISS28_Datum	\N	\N	5	101947	\N	\N	\N
101974	Score_SAPS2_Wert	\N	\N	2	101973	\N	\N	\N
101975	Score_SAPS2_Zuweisung	\N	\N	27	101973	\N	\N	\N
101976	Score_SAPS2_Urin	\N	\N	27	101973	\N	\N	\N
101977	Score_SAPS2_VKrank	\N	\N	27	101973	\N	\N	\N
101978	Score_SAPS2_SystBD	\N	\N	27	101973	\N	\N	\N
101979	Score_SAPS2_Temp	\N	\N	27	101973	\N	\N	\N
101980	Score_SAPS2_Natrium	\N	\N	27	101973	\N	\N	\N
101981	Score_SAPS2_PaO2	\N	\N	27	101973	\N	\N	\N
101982	Score_SAPS2_Kalium	\N	\N	27	101973	\N	\N	\N
101983	Score_SAPS2_Leuko	\N	\N	27	101973	\N	\N	\N
101984	Score_SAPS2_HCO3	\N	\N	27	101973	\N	\N	\N
101985	Score_SAPS2_HF	\N	\N	27	101973	\N	\N	\N
101986	Score_SAPS2_Harnstoff	\N	\N	27	101973	\N	\N	\N
101987	Score_SAPS2_HarnstStickst	\N	\N	27	101973	\N	\N	\N
101988	Score_SAPS2_Bili	\N	\N	27	101973	\N	\N	\N
101989	Score_SAPS2_GCS	\N	\N	27	101973	\N	\N	\N
101990	Score_SAPS2_Alter	\N	\N	27	101973	\N	\N	\N
101991	Score_SAPS2_Datum	\N	\N	5	101973	\N	\N	\N
101993	Score_SOFA_Wert	\N	\N	2	101992	\N	\N	\N
101994	Score_SOFA_Creatinine	\N	\N	27	101992	\N	\N	\N
101995	Score_SOFA_Hypotension	\N	\N	27	101992	\N	\N	\N
101996	Score_SOFA_GCS	\N	\N	27	101992	\N	\N	\N
101997	Score_SOFA_Thrombo	\N	\N	27	101992	\N	\N	\N
101998	Score_SOFA_Bilirubin	\N	\N	27	101992	\N	\N	\N
101999	Score_SOFA_PaO2	\N	\N	27	101992	\N	\N	\N
102000	Score_SOFA_Datum	\N	\N	5	101992	\N	\N	\N
103738	AtmenKreislaufTemp_At_NRSekretMenge	Dokumentation der Mege des Nasen- und Rachensekrets	\N	3	100650	\N	\N	Pflegedoku - Atmung (NR Sekretmenge)
103742	Befinden_Befinden_Sprache	Beschreibung des Sprachverhaltens des Patienten	\N	3	100421	\N	\N	Pflegedoku - Befinden (Sprache)
103743	IstPflege_Sprache	Dokumentation des Sprachverhaltens des Patienten bei Aufnahme	\N	3	30	\N	\N	Sprache
103760	Patient_Pupillen_Cornealreflex_Links_Wert	\N	\N	3	103755	\N	\N	Pupillenkontrolle (Cornealreflex links)
102001	IstPflege_Shunt_Art	\N	\N	3	30	\N	\N	\N
102002	VerlegPfl_Atm_Shunt_Art	\N	\N	3	30	\N	\N	\N
102004	Temp1a	Temperatur 1a	°C	6	1	\N	\N	\N
102005	Temp1b	Temperatur 1b	°C	6	1	\N	\N	\N
102006	Temp2a	Temperatur 2a	°C	6	1	\N	\N	\N
102007	Temp2b	Temperatur 2b	°C	6	1	\N	\N	\N
102008	Temp3a	Temperatur 3a	°C	6	1	\N	\N	\N
102009	Temp3b	Temperatur 3b	°C	6	1	\N	\N	\N
102010	SpO2	Sauerstoffsättigung Pulsoxymetrie	%	6	1	\N	\N	\N
102011	PLS	Pulsrate errechnet aus der SpO2 Messung	1/min	6	1	\N	\N	\N
102012	etCO2	End-tidales CO2	%	6	1	\N	\N	\N
102013	PACED	\N	%	3	1	\N	\N	\N
102016	RAP	Rechtsatrial Mitteldruck	mmHg	6	1	\N	\N	\N
102018	PWP	Pulmunaler Wedgedruck	mmHg	6	1	\N	\N	\N
102132	Untersuchung_Kopf_Hals	\N	\N	3	20	\N	\N	\N
102019	PAM	Mittlerer pulmonale arterieller Druck	mmHg	6	1	\N	\N	\N
102021	CO	Herzleistung	\N	6	1	\N	\N	\N
102022	LHCPP	Linksseitiger Herzkranzperfusionsdruck 	mmHg	6	1	\N	\N	\N
102023	LVSA	Linksventrikulärer Schlagarbeit 	g x m	6	1	\N	\N	\N
102024	LVSAI	Linksventrikulärer Schlagarbeitsindex 	g x m/m2	6	1	\N	\N	\N
102025	PVR	Pulmunaler Gefäßwiderstand 	dynes x sek/cm-5	6	1	\N	\N	\N
102026	PVRI	Pulmunaler Gefäßwiderstandsindex 	dynes x sek/cm-5/m2	6	1	\N	\N	\N
102027	RPP	Rate-/Druck-Produkt 	mmHg/min	6	1	\N	\N	\N
102028	RVSA	Rechtsvetrikulärer Schlagarbeit 	g x m	6	1	\N	\N	\N
102029	RVSAI	Rechtsvetrikulärer Schlagarbeitsindex 	g x m/m2	6	1	\N	\N	\N
102030	SV	Schlagvolumen 	ml	3	1	\N	\N	\N
102031	SVI	Index des Schlagvolumens 	ml/m2	3	100134	\N	\N	\N
102032	TPR	Pulmonaler Gesamtgefäßwiderstand 	dynes x sek/cm-5	6	1	\N	\N	\N
102033	TVR	Gesamtgefäßwiderstand 	dynes x sek/cm-5	6	1	\N	\N	\N
103766	Patient_Pupillen_Cornealreflex_Rechts_Wert	\N	\N	3	103756	\N	\N	Pupillenkontrolle (Cornealreflex rechts)
103772	Patient_Pupillen_Anisokorie_Wert	\N	\N	3	103757	\N	\N	Pupillenkontrolle (Isokorie / Anisokkorie)
103788	Patient_Pupillen_Rechts_Wert	\N	\N	3	103758	\N	\N	Pupillenkontrolle (rechts)
103797	Patient_Pupillen_Links_Wert	\N	\N	3	103759	\N	\N	Pupillenkontrolle (links)
102034	PCCO	Pulskontur-Herzzeitvolumen 	l/min	6	1	\N	\N	\N
102035	PCCI	Herzindex (kontinuirlich) 	l/min/m2	6	1	\N	\N	\N
102036	p-SVI	Schlagvolumenindex  (PICCO Modul Dräger Monitoring)	ml/m2	6	1	\N	\N	\N
102037	p-SVR	Systemischer Gefäßwiderstand (PICCO Modul Dräger Monitoring) 	dynes x sek/cm-5	6	1	\N	\N	\N
102038	p-SVRI	Index des systemischen Gefäßwiderstandes (PICCO Modul Dräger Monitoring)  	dynes x sek/cm-5/m2	6	1	\N	\N	\N
102039	dPmax	Index der linken Ventrikelkontraktilität  	mmHg/s	6	1	\N	\N	\N
102040	p-CO	Herzzeitvolumen (PICCO Modul Dräger Monitoring) 	l/min	6	1	\N	\N	\N
102041	GEDV	Globales enddiastolisches Volumen 	ml	6	1	\N	\N	\N
102042	GEDVI	Index des enddiastolisches Volumen 	ml/m2	6	1	\N	\N	\N
102043	EVLW	Extravaskuläres Lungenwasser 	ml	6	1	\N	\N	\N
102044	EVLWI	Extravaskuläres Lungenwasserindex 	ml/Kg	6	1	\N	\N	\N
102045	GEF	Globale Auswurffraktion 	%	6	1	\N	\N	\N
102046	ETVI	Index des extravaskulären Thermovolumens 	ml/Kg	6	1	\N	\N	\N
102047	PVPI	Pulmonalvaskuläer Permeabilitätsindex 	\N	6	1	\N	\N	\N
102050	PAP	Pulmunalarterieller Druck	mmHg	12	1	\N	\N	\N
102053	PC	Pulmonalkapillardruck	mmHg	6	1	\N	\N	\N
102055	LVP	Linksventrikulärer Mitteldruck	mmHg	12	1	\N	\N	\N
102056	RVP	Rechtsventrikulärer Mitteldruck	mmHg	12	1	\N	\N	\N
102057	ARR	Arrhythmie Drägermonitoring, VES/min	1/min	6	1	\N	\N	\N
102058	Beatmung_Einstellung_Inspirationsflow	\N	l/min	6	1	\N	\N	\N
102059	Beatmung_Einstellung_ASBAnstieg	\N	sec.	6	1	\N	\N	\N
102060	Beatmung_Einstellung_InspirationszeitIE	Inspirationszeit I:E	sec:sec	3	1	\N	\N	\N
102061	Beatmung_Messung_ExpirationszeitI:E	\N	sec:sec	6	1	\N	\N	\N
102062	Beatmung_Einstellung_PAW/Pinspiration	\N	mbar	6	1	\N	\N	\N
102063	Beatmung_Einstellung_BIPAPP1	\N	mbar	6	1	\N	\N	\N
102064	Beatmung_Einstellung_BIPAPP2	\N	mbar	6	1	\N	\N	\N
102065	Beatmung_Einstellung_BIPAPT1	\N	sec.	6	1	\N	\N	\N
102066	Beatmung_Einstellung_BIPAPT2	\N	sec.	6	1	\N	\N	\N
102067	Beatmung_Einstellung_Beatmungsmodus	\N	\N	3	1	\N	\N	\N
103830	AtmenKreislaufTemp_Kreisl_PulskontrLi	\N	\N	3	100663	\N	\N	Pflegedoku - Kreislauf (Pulskontrolle links)
102068	Beatmung_Einstellung_DruckTrigger	\N	%	6	1	\N	\N	\N
102069	Beatmung_Messung_I:EVerhaeltnisI	\N	\N	6	1	\N	\N	\N
102070	Beatmung_Messung_I:EVerhaeltnisE	\N	\N	6	1	\N	\N	\N
102071	Beatmung_Messung_O2KonzentrationG5	\N	\N	6	1	\N	\N	\N
102072	Beatmung_Einstellung_DruckFlow	\N	\N	6	1	\N	\N	\N
102073	Beatmung_Einstellung_O2Konzentration	\N	\N	6	1	\N	\N	\N
102074	Beatmung_Einstellung_SauerstoffFlow	\N	\N	6	1	\N	\N	\N
102075	Behandlung_GCS_ADULT	GCS Erwachsene	\N	1	1	\N	\N	\N
102076	Behandlung_GCS_ADULT_Wert	\N	\N	2	102075	\N	\N	\N
102077	Behandlung_GCS_ADULT_Datum	\N	\N	5	102075	\N	\N	\N
102078	Behandlung_GCS_ADULT_Augen	\N	\N	27	102075	\N	\N	\N
102079	Behandlung_GCS_ADULT_Motorik	\N	\N	27	102075	\N	\N	\N
102080	Behandlung_GCS_ADULT_Sprache	\N	\N	27	102075	\N	\N	\N
102081	Behandlung_GCS_CHILD	GCS Kinder	\N	1	1	\N	\N	\N
102082	Behandlung_GCS_CHILD_Datum	\N	\N	5	102081	\N	\N	\N
102083	Behandlung_GCS_CHILD_Wert	\N	\N	2	102081	\N	\N	\N
102084	Behandlung_GCS_CHILD_Augen	\N	\N	27	102081	\N	\N	\N
102085	Behandlung_GCS_CHILD_Motorik	\N	\N	27	102081	\N	\N	\N
102086	Behandlung_GCS_CHILD_Sprache	\N	\N	27	102081	\N	\N	\N
102087	Lungenersatzverfahren_Doku_ECMOFiO2	\N	\N	6	1	\N	\N	\N
102088	Lungenersatzverfahren_Doku_ECMOATZ	\N	\N	6	1	\N	\N	\N
102089	Lungenersatzverfahren_Anordnung_ECMOATZ	\N	\N	6	1	\N	\N	\N
102090	Lungenersatzverfahren_Anordnung_ECMOFiO2	\N	\N	6	1	\N	\N	\N
102091	Lungenersatzverfahren_Anordnung_ILAQ1Flow	\N	\N	6	1	\N	\N	\N
102092	Lungenersatzverfahren_Anordnung_ILAQ2Flow	\N	\N	6	1	\N	\N	\N
102093	Lungenersatzverfahren_Anordnung_ILAPressure	\N	\N	6	1	\N	\N	\N
102094	Lungenersatzverfahren_Anordnung_ILAAnalogIn	\N	\N	6	1	\N	\N	\N
102096	Lungenersatzverfahren_Doku_ILASystem	\N	\N	3	1	\N	\N	\N
102097	Lungenersatzverfahren_Doku_ILAQ1Flow	\N	lpm	6	1	\N	\N	\N
102098	Lungenersatzverfahren_Doku_ILAQ2Flow	\N	lpm	6	1	\N	\N	\N
102099	Lungenersatzverfahren_Doku_ILAPressure	\N	mmHg	6	1	\N	\N	\N
102100	Lungenersatzverfahren_Doku_ILAAnalogIn	\N	V	6	1	\N	\N	\N
102101	Lungenersatzverfahren_Doku_ILACuppling	\N	\N	6	1	\N	\N	\N
102102	Nierenersatzverfahren_Einstell_Blutfluss	\N	\N	6	1	\N	\N	\N
102103	Nierenersatzverfahren_Einstell_FlussratePBP	\N	\N	6	1	\N	\N	\N
102104	Nierenersatzverfahren_Einstell_SubstituatRate	\N	\N	6	1	\N	\N	\N
102106	Nierenersatzverfahren_Einstell_Dialysatfluß	\N	\N	6	1	\N	\N	\N
103865	Koerperpflege_Ohren_Pflege_li	Dokumentation der Ohrenpflege rechts ab dem 22.02.2010	\N	3	100378	\N	\N	Pflegedoku - Ohren (Pflege links)
103866	Koerperpflege_Ohren_Status_li	Dokumentation des Ohrenstatus links ab dem 22.02.2010	\N	3	100378	\N	\N	Pflegedoku - Ohren (Status links)
103867	Koerperpflege_Nase_Pflege_li	Dokumentation der Nasenpflege links ab dem 22.02.2010.	\N	3	100364	\N	\N	Pflegedoku - Nase (Pflege links)
103868	Koerperpflege_Nase_Status_li	Dokumentation des Nasenstatus links ab dem 22.02.2010.	\N	3	100364	\N	\N	Pflegedoku - Nase (Status links)
103869	Koerperpflege_Augen_Pflege_li	Dokumentation der Augenpflege links ab dem 22.02.2010	\N	3	100357	\N	\N	Pflegedoku - Augen (Pflege links)
103870	Koerperpflege_Augen_Sekret_li	Dokumentation des Augensekrets links ab dem 22.02.2010	\N	3	100357	\N	\N	Pflegedoku - Augen (Sekret links)
103871	Koerperpflege_Augen_Status_li	Beschreibung des AugenStatus links ab 23.02.2010	\N	3	100357	\N	\N	Pflegedoku - Augen (Status links)
103872	PersoenAspekte_Patient_Gespraech	Dokumentation von Angehörigengesprächen.	\N	3	103864	\N	\N	Pflegedoku - Patient (Gespräch)
102107	Nierenersatzverfahren_Einstell_PatFluessigkeitRate	\N	\N	6	1	\N	\N	\N
102108	Nierenersatzverfahren_Mess_Blutfluss	\N	\N	6	1	\N	\N	\N
102110	Nierenersatzverfahren_Mess_FlussratePBP	\N	\N	6	1	\N	\N	\N
102112	Nierenersatzverfahren_Mess_SubstituatRate	\N	\N	6	1	\N	\N	\N
102113	Nierenersatzverfahren_Mess_PatFluessigkeitRate	\N	\N	6	1	\N	\N	\N
102114	Nierenersatzverfahren_Mess_Dialysatfluß	\N	\N	6	1	\N	\N	\N
102117	Nierenersatzverfahren_Mess_FilterDruck	\N	\N	6	1	\N	\N	\N
102118	Nierenersatzverfahren_Mess_FiltratDruck	\N	\N	6	1	\N	\N	\N
102119	Nierenersatzverfahren_Mess_TMP	TransmembranDruck	\N	6	1	\N	\N	\N
102120	IABP_Trigger	\N	\N	3	1	\N	\N	\N
102121	IABP_Frequenz	\N	\N	3	1	\N	\N	\N
102122	IABP_Unterstützung	\N	\N	3	1	\N	\N	\N
102123	IABP_Aufblasen	\N	\N	3	1	\N	\N	\N
102124	IABP_Leersaugen	\N	\N	3	1	\N	\N	\N
102125	IABP_EKG	\N	\N	6	1	\N	\N	\N
102126	IABP_RR	\N	\N	12	1	\N	\N	\N
102127	IABP_Unterstützungsdruck	\N	\N	6	1	\N	\N	\N
102128	Untersuchung_Kopf_Haut	\N	\N	3	20	\N	\N	\N
103873	PersoenAspekte_Angehoerige_Betreuung	Dokumentation von Angehörigenbetreuung	\N	3	103863	\N	\N	Pflegedoku - Angehörige (Betreuung)
103874	PersoenAspekte_Angehoerige_Gespraech	Dokumentation eines Angehörigengesprächs	\N	3	103863	\N	\N	Pflegedoku - Angehörige (Gespräch)
103876	PersoenAspekte_Sterbebegleitung_VersVerstorbener	Dokumenttion der Versorgung verstorbener Patienten.	\N	3	103862	\N	\N	Pflegedoku - Sterbebegleitung (V. d. Verstorbenen)
103904	Koerperpflege_Waschen_Assist_Wert	\N	\N	3	100389	\N	\N	Pflegedoku - Körperpflege (assistiert)
103905	Koerperpflege_Waschen_selbststaendig_Wert	\N	\N	3	100389	\N	\N	Pflegedoku - Körperpflege (selbstständig)
103906	Bewegen_Bewegungen_Handicap	Liste	\N	3	100360	\N	\N	Pflegedoku - Bewegungen (Handicap)
102129	Untersuchung_Kopf_Augen	\N	\N	3	20	\N	\N	\N
102130	Untersuchung_Kopf_Ohren	\N	\N	3	20	\N	\N	\N
102131	Untersuchung_Kopf_Nas_Mund	\N	\N	3	20	\N	\N	\N
102133	Untersuchung_Thorax_Haut	\N	\N	3	20	\N	\N	\N
102134	Untersuchung_Thorax_Wand	\N	\N	3	20	\N	\N	\N
102135	Untersuchung_Thorax_Pulmo	\N	\N	3	20	\N	\N	\N
102136	Untersuchung_Thorax_Cor	\N	\N	3	20	\N	\N	\N
102137	Untersuchung_Abdomen_Haut	\N	\N	3	20	\N	\N	\N
102138	Untersuchung_Abdomen_Bauchwand	\N	\N	3	20	\N	\N	\N
102139	Untersuchung_Abdomen_Nieren	\N	\N	3	20	\N	\N	\N
102140	Untersuchung_Abdomen_Leber	\N	\N	3	20	\N	\N	\N
102141	Untersuchung_Abdomen_Gallenblase	\N	\N	3	20	\N	\N	\N
102142	Untersuchung_ExtremitaetenLeiste_Haut	\N	\N	3	20	\N	\N	\N
102143	Untersuchung_ExtremitaetenLeiste_ObereExtremitaet	\N	\N	3	20	\N	\N	\N
102144	Untersuchung_ExtremitaetenLeiste_UntereExtremitaet	\N	\N	3	20	\N	\N	\N
102145	Untersuchung_ZNS_Bewusstsein	\N	\N	3	20	\N	\N	\N
102146	Untersuchung_ZNS_Reflexe	\N	\N	3	20	\N	\N	\N
102147	Untersuchung_ZNS_Hirnnerven	\N	\N	3	20	\N	\N	\N
102148	Untersuchung_ZNS_Motorik	\N	\N	3	20	\N	\N	\N
102149	Untersuchung_ZNS_Sensibilitaet	\N	\N	3	20	\N	\N	\N
102150	Untersuchung_ZNS_Vegetativum	\N	\N	3	20	\N	\N	\N
102151	Untersuchung_Status_Reizbildung	\N	\N	3	20	\N	\N	\N
102152	Untersuchung_Status_Makrozirkulation	\N	\N	3	20	\N	\N	\N
102153	Untersuchung_Status_Mikrozirkulation	\N	\N	3	20	\N	\N	\N
103937	VerlPfl_Befind_Sprache	Beurteilung der Sprache im Verlegungsbericht Pflege	\N	3	30	\N	\N	Befinden - Sprache
103939	VerlPfl_Beweg_Dekubitus_Zusatzrisiko	Dokumentation des Dekubitus Zusatzrisikos bei Verlegung	\N	3	30	\N	\N	Bewegen - Dekubitus Zusatzrisiko
103940	VerlPfl_Beweg_Lagerung	Dokumentation des Status der Lagerungsmaßnahmen bei Verlegung	\N	3	30	\N	\N	Bewegen - Lagerung
103941	VerlPfl_Beweg_Mobilisationsgrad	Dokumentation des Mobilisationsgrad zum Zeitpunkt der Verlegung	\N	3	30	\N	\N	Bewegen - Mobilisation
103942	VerlPfl_ErnaehrAussch_Schluckakt	Dokumentation des Status des Schluckaktes	\N	3	30	\N	\N	Ernährung / Ausscheidung - Schluckskt
103945	VerlegPfl_Koerperpfl_Nasenstatusre	Dokumentation des Nasenstatus im Pflegeverlegungsbericht	\N	3	30	\N	\N	Körperpflege - Nasenstatus rechts
103946	VerlegPfl_Koerperpfl_Nasenstatusli	Dokumentation des Nasenstus links im Pflegeverlegungsbericht	\N	3	30	\N	\N	Körperpflege - Nasenstatus links
102154	Untersuchung_Status_Oxygenierung	\N	\N	3	20	\N	\N	\N
102155	Untersuchung_Status_Ventilation	\N	\N	3	20	\N	\N	\N
102156	Untersuchung_Status_Atemform	\N	\N	3	20	\N	\N	\N
102157	Untersuchung_Status_Wasserhaushalt	\N	\N	3	20	\N	\N	\N
102158	Untersuchung_Status_Koerpertemperatur	\N	\N	3	20	\N	\N	\N
102159	Untersuchung_Status_Urin	\N	\N	3	20	\N	\N	\N
102160	Untersuchung_Status_Stuhl	\N	\N	3	20	\N	\N	\N
102161	IABP_Balken	\N	\N	19	1	\N	\N	\N
102162	PICCO_ABP	Arterieller Druck	\N	12	1	\N	\N	\N
102163	PICCO_ZVD	Zentraler Venendruck	\N	6	1	\N	\N	\N
102164	PICCO_SVR	Systemic vascular resistance	\N	6	1	\N	\N	\N
102165	PICCO_SVRI	Systemic vascular resistance index	\N	6	1	\N	\N	\N
102166	PICCO_PC	Pulmonalkapillardruck	\N	6	1	\N	\N	\N
102167	PICCO_HI	HerzindexHerzindex	\N	6	1	\N	\N	\N
102168	PICCO_HF	HerzfrequenzHerzfrequenz	\N	6	1	\N	\N	\N
102169	PICCO_SVV	Schlagvolumen-Variation	\N	6	1	\N	\N	\N
102170	PICCO_ITBV	Intrathorakales Blutvolumen	\N	6	1	\N	\N	\N
102171	PICCO_ITBVI	Intrathorakaler Blutvolumenindex	\N	6	1	\N	\N	\N
102172	PICCO_EVLW/EV	\N	\N	6	1	\N	\N	\N
102173	PICCO_HZV	Herzzeitvolumen	\N	6	1	\N	\N	\N
102176	Vigileo_SV	ml/b	\N	6	1	\N	\N	\N
103947	VerlegPfl_Koerperpfl_Ohrenstatusre	Dokumentation des Ohrenstatus rechts im Pflegeverlegungsbericht	\N	3	30	\N	\N	Körperpflege - Ohrenstatus rechts
103948	VerlegPfl_Koerperpfl_Ohrenstatusli	Dokumentation des Ohrenstatus links im Pflegeverlegungsbericht	\N	3	30	\N	\N	Körperpflege - Ohrenstatus links
103949	VerlegPfl_Koerperpfl_KPUebernahme	Dokumentation der Körperpflege des Patienten, die durch das Pflegepersonal übernommen wird.	\N	3	30	\N	\N	Körperpflege - Übernahme
103950	VerlegPfl_Koerperpfl_KPassistiert	Dokumentation der assistierten Körperpflege im Pflegeverlegungsbericht.	\N	3	30	\N	\N	Körperpflege - KP assistiert
103951	VerlegPfl_Koerperpfl_KPselbststaendig	Dokumentation der selbstständigen Körperpflege des Pat. im Pflegeverlegungsbericht.	\N	3	30	\N	\N	Körperpflege - KP selbstständig
103952	VerlegPfl_Koerperpfl_Zahnstatus	Dokumentation des Zahnstatus zum Zeitpunkt der Verlegung im Pflegeverlegungsbericht.	\N	3	30	\N	\N	Körperpflege - Zahnstatus
103953	VerlegPfl_Koerperpfl_Haarstatus	Dokumentation des Haarstatus bei Verlegung im Pflegeverlegungsbericht.	\N	3	30	\N	\N	Körperpflege - Haarstatus
103954	VerlegPfl_Koerperpfl_Lippenstatus	Dokumentation des Lippenstatus zum Zeitpunkt der Verlegung im Pflegeverlegungsbericht.	\N	3	30	\N	\N	Körperpflege - Lippenstatus
103955	VerlegPfl_Koerperpfl_Urogenitalstatus	Dokumentation des Urogenitalstatus zum Zeitpunkt der Verlegung im Pflegeverlegungsbericht.	\N	3	30	\N	\N	Körperpflege - Urogenitalstatus
102345	PROCDiagnosMassnahm_Sonstiges_Endoskopie	\N	\N	31	101517	\N	\N	\N
103956	VerlPfl_Beweg_Braden	Der letzte in der Verlaufsdokumentation ermittelter Braden Score, der in den Pflegeverlegungsbericht gespiegelt wird.	\N	3	30	\N	\N	Bewegen - Braden
102178	Vigileo_COCI	Cardiac output / -index	l/min;l/min	3	1	\N	\N	\N
102179	Vigileo_SVI	SchlagvolumenindexSchlagvolumenindex	ml/b/m²ml/b/m²	6	1	\N	\N	\N
102180	Vigileo_SVR	Systemic vascular resistance	dyne-s/cm5	6	1	\N	\N	\N
102181	Vigileo_SVRI	Systemic vascular resistance index	dyne-s-m²/cm5	6	1	\N	\N	\N
102182	Vigileo_SVV	\N	%	6	1	\N	\N	\N
102183	Vigileo_ScvO2	\N	%	6	1	\N	\N	\N
102185	VigilanceC_CI	Herzindex	\N	6	1	\N	\N	\N
102186	VigilanceC_SV	Schlagvolumen	\N	6	1	\N	\N	\N
102187	VigilanceC_SVI	Schlagvolumenindex	\N	6	1	\N	\N	\N
102188	VigilanceC_SVV	Schlagvolumen Variation	\N	6	1	\N	\N	\N
102189	VigilanceC_SVR	Systemischer Gefäßwiderstand	\N	6	1	\N	\N	\N
102190	VigilanceC_SVRI	Systemischer Gefäßwiderstandsindex	\N	6	1	\N	\N	\N
102191	VigilanceC_PVR	Pulmonaler vasculärer Widerstand	\N	6	1	\N	\N	\N
102192	VigilanceC_PVRI	Pulmonaler vasculärer Widerstandsindex	\N	6	1	\N	\N	\N
102193	VigilanceC_ITBV	Intrathorakales Blutvolumen	\N	6	1	\N	\N	\N
102194	VigilanceC_EVLW	Extravasales Lungenwasser	\N	6	1	\N	\N	\N
102195	VigilanceC_LCWI	\N	\N	6	1	\N	\N	\N
102184	VigilanceC_HZV	Herzzeitvolumen	L/min	6	1	\N	\N	\N
102196	VigilanceC_RCWI	\N	\N	6	1	\N	\N	\N
102197	VigilanceC_SI	\N	\N	6	1	\N	\N	\N
102198	VigilanceC_O2	\N	\N	6	1	\N	\N	\N
102290	VODiagnosMassnahm_Labor_BlutgruppenDiagnostikVODia	\N	\N	29	101499	\N	\N	\N
102291	VODiagnosMassnahm_Labor_GerrinungsDiagnostik	\N	\N	29	101499	\N	\N	\N
102294	VODiagnosMassnahm_Labor_HormonDiagnostik	\N	\N	29	101499	\N	\N	\N
102295	VODiagnosMassnahm_Labor_Med.Spiegel	\N	\N	29	101499	\N	\N	\N
102296	VODiagnosMassnahm_Labor_RoutineBGA	\N	\N	29	101499	\N	\N	\N
102297	VODiagnosMassnahm_Labor_SerumDiagnostik	\N	\N	29	101499	\N	\N	\N
102298	VODiagnosMassnahm_Labor_Sonstiges	\N	\N	29	101499	\N	\N	\N
102299	VODiagnosMassnahm_Labor_VirusLuesDiagnostik	\N	\N	29	101499	\N	\N	\N
102300	VODiagnosMassnahm_MiBi_Abstriche	\N	\N	29	101508	\N	\N	\N
102301	VODiagnosMassnahm_MiBi_Atemwege	\N	\N	29	101508	\N	\N	\N
102302	VODiagnosMassnahm_MiBi_Blut	\N	\N	29	101508	\N	\N	\N
102303	VODiagnosMassnahm_MiBi_MagenDarm	\N	\N	29	101508	\N	\N	\N
102304	VODiagnosMassnahm_MiBi_KatheterDrainagen	\N	\N	29	101508	\N	\N	\N
102305	VODiagnosMassnahm_MiBio_Urin	\N	\N	29	101508	\N	\N	\N
102306	VODiagnosMassnahm_MiBi_Sonstiges	\N	\N	29	101508	\N	\N	\N
102307	VODiagnosMassnahm_MiBi_Sekrete	\N	\N	29	101508	\N	\N	\N
102308	VODiagnosMassnahm_Radio_Angiografie	\N	\N	29	101487	\N	\N	\N
102309	VODiagnosMassnahm_Radio_CT	\N	\N	29	101487	\N	\N	\N
102310	VODiagnosMassnahm_Radio_MRT	\N	\N	29	101487	\N	\N	\N
102311	VODiagnosMassnahm_Radio_KonventionelleVerfahren	\N	\N	29	101487	\N	\N	\N
102312	VODiagnosMassnahm_Radio_Neuroradiologie	\N	\N	29	101487	\N	\N	\N
102313	VODiagnosMassnahm_Radio_Sonografie	\N	\N	29	101487	\N	\N	\N
102314	VODiagnosMassnahm_Radio_Szintigrafie	\N	\N	29	101487	\N	\N	\N
102315	VODiagnosMassnahm_Sonstiges_Echo	\N	\N	29	101517	\N	\N	\N
102316	VODiagnosMassnahm_Sonstiges_Endoskopie	\N	\N	29	101517	\N	\N	\N
102317	VODiagnosMassnahm_Sonstiges_EEG	\N	\N	29	101517	\N	\N	\N
102318	VODiagnosMassnahm_Sonstiges_Elektrophysiologie	\N	\N	29	101517	\N	\N	\N
102319	VODiagnosMassnahm_Sonstiges_HinrtodDiagnostik	\N	\N	29	101517	\N	\N	\N
104018	VerlPfl_ErnaehrAussch_Urinbeschaffenheit	Dokumentation der Urinbeschaffenheit zum zeitpunkt der Verlegung	\N	3	30	\N	\N	Ernährung / Ausscheidung - Urinbeschaffenheit
104019	VerlPfl_ErnaehrAussch_Stuhlbeschaffenheit	Dokumentation der Stuhlbeschaffenheit zum zeitpunkt der Verlegung	\N	3	30	\N	\N	Ernährung / Ausscheidung - Stuhlbeschaffenheit
104020	VerlegPfl_Atm_Ventilation	Dokumentation des Ventilationsstatus zum Zeitpunkt der Verlegung	\N	3	30	\N	\N	Atmen, Kreislauf, Körpertemp. - Ventilation
104021	VerlPfl_ErnaehrAussch_LetzStuhlDate	\N	\N	5	30	\N	\N	Ernährung / Ausscheidung - letzte Defäkation
104041	Score_TISS28_Aufnahme	\N	\N	1	30	\N	\N	\N
102320	VODiagnosMassnahm_Sonstiges_Konsile	\N	\N	29	101517	\N	\N	\N
102321	VODiagnosMassnahm_Sonstiges_NerochirurgieTCD	\N	\N	29	101517	\N	\N	\N
102322	VOD_Massnahmen	\N	\N	25	101483	\N	\N	\N
102323	VODiagnosMassnahm_Massnah_Angehörigengespraech	\N	\N	29	102322	\N	\N	\N
102324	VODiagnosMassnahm_Massnah_Bronschoskopie	\N	\N	29	102322	\N	\N	\N
102325	VODiagnosMassnahm_Massnah_EKG	\N	\N	29	102322	\N	\N	\N
102326	VODiagnosMassnahm_Massnah_Inhalation	\N	\N	29	102322	\N	\N	\N
102327	VODiagnosMassnahm_Massnah_Mobilisation	\N	\N	29	102322	\N	\N	\N
102328	VODiagnosMassnahm_Massnah_Neurokontrolle	\N	\N	29	102322	\N	\N	\N
102329	VODiagnosMassnahm_Massnah_Pulskontrollen	\N	\N	29	102322	\N	\N	\N
102330	VODiagnosMassnahm_Massnah_Sammelurin	\N	\N	29	102322	\N	\N	\N
102331	VODiagnosMassnahm_Massnah_Schluckversuch	\N	\N	29	102322	\N	\N	\N
102332	VODiagnosMassnahm_Massnah_ZVD	\N	\N	29	102322	\N	\N	\N
102334	PROCDiagnosMassnahm_Labor_GerrinungsDiagnostik	\N	\N	31	101499	\N	\N	\N
102335	PROCDiagnosMassnahm_Labor_BlutgruppenDiagnostik	\N	\N	31	101499	\N	\N	\N
102336	PROCDiagnosMassnahm_Labor_HormonDiagnostik	\N	\N	31	101499	\N	\N	\N
102337	PROCDiagnosMassnahm_Labor_Med.Spiegel	\N	\N	31	101499	\N	\N	\N
102338	PROCDiagnosMassnahm_Labor_RoutineBGA	\N	\N	31	101499	\N	\N	\N
102339	PROCDiagnosMassnahm_Labor_SerumDiagnostik	\N	\N	31	101499	\N	\N	\N
102340	PROCDiagnosMassnahm_Labor_Sonstiges	\N	\N	31	101499	\N	\N	\N
102341	PROCDiagnosMassnahm_Sonstiges_NerochirurgieTCD	\N	\N	31	101517	\N	\N	\N
102342	PROCDiagnosMassnahm_Sonstiges_Konsile	\N	\N	31	101517	\N	\N	\N
102343	PROCDiagnosMassnahm_Radio_CT	\N	\N	31	101487	\N	\N	\N
102344	PROCDiagnosMassnahm_Sonstiges_HinrtodDiagnostik	\N	\N	31	101517	\N	\N	\N
102346	PROCDiagnosMassnahm_Radio_Szintigrafie	\N	\N	31	101487	\N	\N	\N
104091	AtmenKreislaufTemp_Kreisl_Perfusion	Liste	\N	3	100663	\N	\N	Pflegedoku - Kreislauf (Perfusion)
102347	PROCDiagnosMassnahm_Radio_MRT	\N	\N	31	101487	\N	\N	\N
102348	PROCDiagnosMassnahm_Massnah_Angehörigengespraech	\N	\N	31	102322	\N	\N	\N
102349	PROCDiagnosMassnahm_Sonstiges_Elektrophysiologie	\N	\N	31	101517	\N	\N	\N
102350	PROCDiagnosMassnahm_Sonstiges_EEG	\N	\N	31	101517	\N	\N	\N
102351	PROCDiagnosMassnahm_Radio_Sonografie	\N	\N	31	101487	\N	\N	\N
102352	PROCDiagnosMassnahm_Radio_Neuroradiologie	\N	\N	31	101487	\N	\N	\N
102353	PROCDiagnosMassnahm_Sonstiges_Echo	\N	\N	31	101517	\N	\N	\N
102354	PROCDiagnosMassnahm_Radio_KonventionelleVerfahren	\N	\N	31	101487	\N	\N	\N
102355	PROCDiagnosMassnahm_MiBi_Abstriche	\N	\N	31	101508	\N	\N	\N
102356	PROCDiagnosMassnahm_Labor_VirusLuesDiagnostik	\N	\N	31	101499	\N	\N	\N
102357	PROCDiagnosMassnahm_Massnah_Bronschoskopie	\N	\N	31	102322	\N	\N	\N
102358	PROCDiagnosMassnahm_Massnah_EKG	\N	\N	31	102322	\N	\N	\N
102359	PROCDiagnosMassnahm_Massnah_Inhalation	\N	\N	31	102322	\N	\N	\N
102360	PROCDiagnosMassnahm_Radio_Angiografie	\N	\N	31	101487	\N	\N	\N
102361	PROCDiagnosMassnahm_Massnah_Mobilisation	\N	\N	31	102322	\N	\N	\N
102362	PROCDiagnosMassnahm_Massnah_Neurokontrolle	\N	\N	31	102322	\N	\N	\N
102363	PROCDiagnosMassnahm_Massnah_ZVD	\N	\N	31	102322	\N	\N	\N
102364	PROCDiagnosMassnahm_MiBi_MagenDarm	\N	\N	31	101508	\N	\N	\N
102365	PROCDiagnosMassnahm_Massnah_Pulskontrollen	\N	\N	31	102322	\N	\N	\N
102366	PROCDiagnosMassnahm_MiBi_KatheterDrainagen	\N	\N	31	101508	\N	\N	\N
102367	PROCDiagnosMassnahm_Massnah_Schluckversuch	\N	\N	31	102322	\N	\N	\N
102368	PROCDiagnosMassnahm_Massnah_Sammelurin	\N	\N	29	102322	\N	\N	\N
102369	PROCDiagnosMassnahm_MiBi_Atemwege	\N	\N	31	101508	\N	\N	\N
102370	PROCDiagnosMassnahm_MiBi_Blut	\N	\N	31	101508	\N	\N	\N
102371	PROCDiagnosMassnahm_MiBi_Sekrete	\N	\N	31	101508	\N	\N	\N
102372	PROCDiagnosMassnahm_MiBi_Sonstiges	\N	\N	31	102322	\N	\N	\N
102373	PROCDiagnosMassnahm_MiBi_Urin	\N	\N	31	101508	\N	\N	\N
102374	TabelleAerzte_Grunderkrankung	\N	\N	1	20	\N	\N	\N
102375	TabelleAerzte_VorErkranungOpertion	\N	\N	1	20	\N	\N	\N
102376	TabelleAerzte_PrimarerAufnahmeGrund/Vitalfunktions	\N	\N	1	20	\N	\N	\N
102377	TabelleAerzte_ICUDiagnosen	\N	\N	1	20	\N	\N	\N
102378	TabelleAerzte_Verletzungen	\N	\N	1	20	\N	\N	\N
102380	TabelleAerzte_AnamneseVorAufnahme	\N	\N	1	20	\N	\N	\N
102381	TabelleAerzte_AngehörigeBetreuungPatVerfuegung	\N	\N	1	20	\N	\N	\N
102382	TabelleAerzte_BesonderheitenICUVerlaufs	\N	\N	1	20	\N	\N	\N
102383	TabelleAerzte_Grunderkrankung_Datum	\N	\N	5	102374	\N	\N	\N
102384	TabelleAerzte_Grunderkrankung_Arzt	\N	\N	3	102374	\N	\N	\N
104095	Koerperpflege_Umfaenge_Bauch	\N	\N	3	104092	\N	\N	Pflegedoku - Umfang (Abdomen)
104100	Koerperpflege_Umfaenge_HalsNeu	\N	\N	3	104092	\N	\N	Pflegedoku - Umfang (Hals)
104113	Verlegung_Wohin	\N	\N	3	30	\N	\N	\N
104116	SpO2_Messung_Ort	Liste	\N	19	1	\N	\N	\N
102385	TabelleAerzte_Grunderkrankung_Doku	\N	\N	3	102374	\N	\N	\N
102386	TabelleAerzte_VorErkranungOpertion_Datum	\N	\N	5	102375	\N	\N	\N
102387	TabelleAerzte_VorErkranung_Arzt	\N	\N	3	102375	\N	\N	\N
102388	TabelleAerzte_VorErkranungOpertion_Dokumentation	\N	\N	3	102375	\N	\N	\N
102389	TabelleAerzte_PrimarerAufnahmeGrund_Datum	\N	\N	5	102376	\N	\N	\N
102390	TabelleAerzte_PrimarerAufnahmeGrund_Arzt	\N	\N	3	102376	\N	\N	\N
102391	TabelleAerzte_PrimarerAufnahmeGrund_Dokumentat	\N	\N	3	102376	\N	\N	\N
102392	TabelleAerzte_ICUDiagnosen_Datum	\N	\N	5	102377	\N	\N	\N
102393	TabelleAerzte_ICUDiagnosen_Dokumentation	\N	\N	3	102377	\N	\N	\N
102394	TabelleAerzte_ICUDiagnosen_Arzt	\N	\N	3	102377	\N	\N	\N
102395	TabelleAerzte_Verletzungen_Datum	\N	\N	5	102378	\N	\N	\N
102397	TabelleAerzte_Verletzungen_Dokumentation	\N	\N	3	102378	\N	\N	\N
102398	TabelleAerzte_Verletzungen_Arzt	\N	\N	3	102378	\N	\N	\N
102399	TabelleAerzte_BesonderheitenICUVerlaufs_Datum	\N	\N	5	102382	\N	\N	\N
102400	TabelleAerzte_BesonderheitenICUVerlaufs_Arzt	\N	\N	3	102382	\N	\N	\N
102401	TabelleAerzte_BesonderheitenICUVerlaufs_Dokumentat	\N	\N	3	102382	\N	\N	\N
102402	TabelleAerzte_AnamneseVorAufnahme_Datum	\N	\N	5	102380	\N	\N	\N
102403	TabelleAerzte_AnamneseVorAufnahme_Arzt	\N	\N	3	102380	\N	\N	\N
102404	TabelleAerzte_AnamneseVorAufnahme_Dokumentation	\N	\N	3	102380	\N	\N	\N
102405	TabelleAerzte_AngehörigeBetreuPatVerfueg_Datum	\N	\N	5	102381	\N	\N	\N
102406	TabelleAerzte_AngehörigeBetreuPatVerfueg_Arzt	\N	\N	3	102381	\N	\N	\N
102407	TabelleAerzte_AngehörigeBetreuPatVerfueg_Dokumenta	\N	\N	3	102381	\N	\N	\N
102408	p-SV	Schlagvolumen	ml	6	1	\N	\N	\N
102409	TabelleAerzte_Labor	\N	\N	1	20	\N	\N	\N
102410	TabelleAerzte_Labor_Parameter	\N	\N	3	102409	\N	\N	\N
102411	TabelleAerzte_Labor_Dokumentation	\N	\N	3	102409	\N	\N	\N
102412	TabelleAerzte_Labor_Arzt	\N	\N	3	102409	\N	\N	\N
102413	TabelleAerzte_Labor_Datum	\N	\N	5	102409	\N	\N	\N
102419	TabelleAerzte_Bedarfsmedikation	\N	\N	1	20	\N	\N	\N
102420	TabelleAerzte_Bedarfsmedikation_Medikament	\N	\N	3	102419	\N	\N	\N
102421	TabelleAerzte_Bedarfsmedikation_Dokumentation	\N	\N	3	102419	\N	\N	\N
104392	AT_Lagerung_LinkerArm	\N	\N	3	30	\N	\N	\N
104158	Koerperpflege_Nagel_Status	\N	\N	3	104157	\N	\N	Pflegedoku - Nägel (Status)
104159	Koerperpflege_Nagel_Pflege	\N	\N	3	104157	\N	\N	Pflegedoku - Nägel (Pflege)
102422	TabelleAerzte_Bedarfsmedikation_Arzt	\N	\N	3	102419	\N	\N	\N
102423	TabelleAerzte_Bedarfsmedikation_Datum	\N	\N	5	102419	\N	\N	\N
102424	Behandlungsstrategie_ZielvorgabenSedierun_Freitext	\N	\N	3	30	\N	\N	\N
102425	Behandlungsstrategie_ZielvorgabenSedierun	\N	\N	3	30	\N	\N	\N
102426	Behandlungsstrategie_ZielvorgabenLagerung_Freitext	\N	\N	3	30	\N	\N	\N
102803	Score_MOF	\N	\N	1	1	\N	\N	\N
102427	Behandlungsstrategie_ZielvorgabenTemp_Freitext	\N	\N	3	30	\N	\N	\N
102428	Behandlungsstrategie_ZielvorgabenLagerung_Arzt	\N	\N	3	30	\N	\N	\N
102429	Behandlungsstrategie_ZielvorgabenBesonder_Arzt	\N	\N	3	30	\N	\N	\N
102430	Behandlungsstrategie_ZielvorgabenHf_Freitext	\N	\N	3	30	\N	\N	\N
102431	AnordnungSedierungPCAPDA	\N	\N	3	20	\N	\N	\N
102438	TabelleAerzteMassnahBildKonsil	\N	\N	1	30	\N	\N	\N
102439	TabelleAerzteMassnahBildKonsil_DokuZeit	\N	\N	5	102438	\N	\N	\N
102440	TabelleAerzteMassnahBildKonsil_Gruppe	\N	\N	3	102438	\N	\N	\N
102441	TabelleAerzteMassnahBildKonsil_Bereich	\N	\N	3	102438	\N	\N	\N
102449	Darm_Gelegt_Am	\N	\N	5	102444	\N	\N	\N
102450	Darm_Vorhanden	\N	\N	2	102444	\N	\N	\N
102460	PROCDiagnosMassnahm_Massnah_Sonstige	\N	\N	31	102322	\N	\N	\N
102461	VODiagnosMassnahm_Massnah_Sonstige	\N	\N	29	102322	\N	\N	\N
102462	VONierenersatzverfahren_Anordnung_Antikoagulanz	\N	\N	29	1	\N	\N	\N
102463	PROCNierenersatzverfahren_Anordnung_Antikoagulanz	\N	\N	31	1	\N	\N	\N
102464	VONierenersatzverfahren_Anordnung_Bolus	\N	\N	29	1	\N	\N	\N
102465	PROCNierenersatzverfahren_Anordnung_Bolus	\N	\N	31	1	\N	\N	\N
102469	VONierenersatzverfahren_Anordnung_Bilanzziel	\N	\N	29	1	\N	\N	\N
102470	PROCNierenersatzverfahren_Anordnung_Bilanzziel	\N	\N	31	1	\N	\N	\N
102473	VONierenersatzverfahren_Anordnung_CreaZiel	\N	\N	29	1	\N	\N	\N
102474	PROCNierenersatzverfahren_Anordnung_CreaZiel	\N	\N	31	1	\N	\N	\N
102475	VONierenersatzverfahren_Anordnung_FuellenMit	\N	\N	29	1	\N	\N	\N
102476	PROCNierenersatzverfahren_Anordnung_FuellenMit	\N	\N	31	1	\N	\N	\N
102477	VONierenersatzverfahren_Anordnung_HarnstoffZiel	\N	\N	29	1	\N	\N	\N
102478	PROCNierenersatzverfahren_Anordnung_HarnstoffZiel	\N	\N	31	1	\N	\N	\N
102479	VONierenersatzverfahren_Anordnung_HFLoesung	\N	\N	29	1	\N	\N	\N
102480	PROCNierenersatzverfahren_Anordnung_HFLoesung	\N	\N	31	1	\N	\N	\N
102481	VONierenersatzverfahren_Anordnung_KaliumZiel	\N	\N	29	1	\N	\N	\N
102482	PROCNierenersatzverfahren_Anordnung_KaliumZiel	\N	\N	31	1	\N	\N	\N
104393	AT_Kopfschale	\N	\N	2	30	\N	\N	\N
102483	VONierenersatzverfahren_Anordnung_Option	\N	\N	29	1	\N	\N	\N
102484	PROCNierenersatzverfahren_Anordnung_Option	\N	\N	31	1	\N	\N	\N
102487	VONierenersatzverfahren_Anordnung_Verfahren	\N	\N	29	1	\N	\N	\N
102488	PROCNierenersatzverfahren_Anordnung_Verfahren	\N	\N	31	1	\N	\N	\N
102489	Vigileo_CO	\N	\N	6	1	\N	\N	\N
102490	Vigileo_CI	\N	\N	6	1	\N	\N	\N
102491	Oxidationswasser	Oxidationswasser in ml (einfuhrrelevant)	ml	6	1	\N	\N	\N
102493	PerspiratioInsensibilis	Perspiratio Insensibilis in ml (Ausfuhrrelevant in der Bilanz)	ml	6	1	\N	\N	\N
102494	PerspiratioSensibilis	Perspiratio Sensibilis in ml (ausfuhrrelevant in der Bilanz)	ml	6	1	\N	\N	\N
102495	VONierenersatzverfahren_Anordnung_Umsatz	\N	\N	30	1	\N	\N	\N
102496	VONierenersatzverfahren_Anordnung_BlutflussMax	\N	\N	30	1	\N	\N	\N
102497	VONierenersatzverfahren_Anordnung_AbnahmeMax	\N	\N	30	1	\N	\N	\N
102498	PROCNierenersatzverfahren_Anordnung_AbnahmeMax	\N	\N	32	1	\N	\N	\N
102499	PROCNierenersatzverfahren_Anordnung_BlutflussMax	\N	\N	32	1	\N	\N	\N
102500	PROCNierenersatzverfahren_Anordnung_Umsatz	\N	\N	32	1	\N	\N	\N
102503	Nierenersatzverfahren_Dokumentation_BlutflussEinst	\N	\N	6	1	\N	\N	\N
102504	Nierenersatzverfahren_Dokumentation_Abschluss	\N	\N	3	1	\N	\N	\N
102505	HZV_Platzhalter	\N	\N	3	1	\N	\N	\N
102506	PICCODraegerModul_Platzhalter	\N	\N	3	1	\N	\N	\N
102508	WeitereBlutdruecke_Platzhalter	\N	\N	3	1	\N	\N	\N
102509	Transport_Balken	\N	\N	19	1	\N	\N	\N
102523	Tabelle mit Fehlermeldungen	\N	\N	1	1	\N	\N	\N
102525	Gruppe	\N	\N	3	102523	\N	\N	\N
102526	Bereich	\N	\N	3	102523	\N	\N	\N
102527	Dokumentation	\N	\N	3	102523	\N	\N	\N
102528	Status	\N	\N	3	102523	\N	\N	\N
102529	Beatmung_Einstellung_I:EInsp	I:E Inspiration	\N	6	1	\N	\N	\N
102530	Beatmung_Einstellung_I:EExsp	I:E Exspiration	\N	6	1	\N	\N	\N
102531	Beatmung_Einstellung_InspirationsflowMax	\N	l/min	6	1	\N	\N	\N
102532	PPV	Pulsdruckabweichung	%	6	1	\N	\N	\N
102533	CFI	Herzfunktionsindex	l/min	6	1	\N	\N	\N
102535	p-CI	Herzindex	l/min/m2	6	1	\N	\N	\N
102536	ITBVI	Index des intrathorakalen Blutvolumens	ml/m2	6	1	\N	\N	\N
102538	Beatmung_Messung_ASV	\N	\N	6	1	\N	\N	\N
102539	Beatmung_Einstellung_ASV	\N	\N	6	1	\N	\N	\N
102541	VerlegPfl_Name_Verlegender	\N	\N	3	30	\N	\N	\N
102542	VerlegPfl_StationstelNr	\N	\N	3	30	\N	\N	\N
102543	Beatmung_Einstellung_Beatmungsgeraet	\N	\N	3	1	\N	\N	\N
102544	TISS28_TS_Haeufigerverbandwechsel	\N	\N	27	100000	\N	\N	\N
102545	Score_TISS28_Haeufigerverbandswechsel	\N	\N	27	101947	\N	\N	\N
104222	Bewegen_Bewegungen_LagerungKomplikationen	\N	\N	3	100360	\N	\N	Pflegedoku - Positionsunterstützung (Komplikation)
102551	TabelleVerlaufPtErgoLogo_Datum	\N	\N	5	102546	\N	\N	\N
102552	Score_SOFA_Date	\N	\N	5	101992	\N	\N	\N
102553	Nierenersatztherapie_Doku_OptionBalken	\N	\N	19	1	\N	\N	\N
102554	Nierenersatztherapie_Doku_AntikoagulationBalken	\N	\N	19	1	\N	\N	\N
102555	Nierenersatztherapie_Doku_HFLoesungBalken	\N	\N	19	1	\N	\N	\N
102556	PflegedokumentationI_Matratzen_Balken	\N	\N	19	1	\N	\N	\N
102557	PflegedokumentationI_MatratzenDruck_Balken	\N	\N	19	1	\N	\N	\N
102558	PflegedokumentationI_Infektionsprophylaxe_Balken	\N	\N	19	1	\N	\N	\N
102559	Inpuls_Erfassung_Kriterien_zusätzliche	\N	\N	3	1	\N	\N	\N
102560	Inpuls_Erfassung_Kategorie	\N	\N	3	1	\N	\N	\N
102561	Inpuls_Erfassung_Kriterien_4	\N	\N	3	1	\N	\N	\N
102562	Inpuls_Erfassung_Kriterien_3	\N	\N	3	1	\N	\N	\N
102563	Inpuls_Erfassung_Kriterien_2	\N	\N	3	1	\N	\N	\N
102564	Inpuls_Erfassung_Kriterien_1	\N	\N	3	1	\N	\N	\N
102565	Inpuls_Erfassung_Transporte_Dauer	\N	\N	3	1	\N	\N	\N
102566	Inpuls_Erfassung_Transporte_Anzahl	\N	\N	3	1	\N	\N	\N
102567	Inpuls_Erfassung_Beatmungszeit	\N	min	3	1	\N	\N	\N
102568	Beatmung_Einstellung_Ptief	\N	\N	6	1	\N	\N	\N
102569	Beatmung_Einstellung_Phoch	\N	\N	6	1	\N	\N	\N
102570	Beatmung_Einstellung_Pkontrol	Pkontrol (mbar/frequenz/AZ/min)	\N	6	1	\N	\N	\N
102571	Beatmung_Einstellung_Thoch	\N	\N	6	1	\N	\N	\N
102572	Beatmung_Einstellung_Ttief	\N	\N	6	1	\N	\N	\N
102573	Beatmung_Einstellung_Druckrampe	\N	\N	6	1	\N	\N	\N
102575	Beatmung_Einstellung_Plateau	\N	\N	6	1	\N	\N	\N
102576	Beatmung_Einstellung_Psupport	\N	\N	6	1	\N	\N	\N
102577	Beatmung_Einstellung_TiMax	\N	\N	6	1	\N	\N	\N
102578	Beatmung_Einstellung_ProzentMinVol	\N	\N	6	1	\N	\N	\N
102580	Beatmung_Messung_AFTotal	\N	\N	6	1	\N	\N	\N
102581	Nierenersatzverfahren_Einstell_Plasmavolumen	\N	\N	6	1	\N	\N	\N
102582	Nierenersatzverfahren_Einstell_Austausch	\N	\N	6	1	\N	\N	\N
102583	Nierenersatzverfahren_Einstell_SollTemperatur	\N	\N	6	1	\N	\N	\N
102585	Nierenersatzverfahren_Einstell_Plasmarate	\N	\N	6	1	\N	\N	\N
102586	Nierenersatzverfahren_Einstell_SubBolus	\N	\N	6	1	\N	\N	\N
102587	Nierenersatzverfahren_Einstell_UFR	\N	\N	6	1	\N	\N	\N
102589	Nierenersatzverfahren_Einstell_Austauschrate	\N	\N	6	1	\N	\N	\N
102590	Nierenersatzverfahren_Einstell_EffektiverEntzug	\N	\N	6	1	\N	\N	\N
102591	Nierenersatzverfahren_Einstell_UFZiel	\N	\N	6	1	\N	\N	\N
102596	Nierenersatzverfahren_Einstell_SollNatrium	\N	\N	6	1	\N	\N	\N
102597	Nierenersatzverfahren_Einstell_Bicarbonat	\N	\N	6	1	\N	\N	\N
102602	Nierenersatzverfahren_Einstell_Filter	\N	\N	3	1	\N	\N	\N
102610	Nierenersatzverfahren_Einstell_Temperatur	\N	\N	6	1	\N	\N	\N
102611	Nierenersatzverfahren_Einstell_SubstituatVolumen	\N	\N	6	1	\N	\N	\N
102614	Nierenersatzverfahren_Einstell_Fluss	\N	\N	6	1	\N	\N	\N
102615	Nierenersatzverfahren_Mess_Plasmavolumen	\N	\N	6	1	\N	\N	\N
102617	Beatmung_Messung_FrequenzHFOV	\N	\N	6	1	\N	\N	\N
102622	Nierenersatzverfahren_Mess_SollTemperatur	\N	\N	6	1	\N	\N	\N
102623	Nierenersatzverfahren_Mess_Temperatur	\N	\N	6	1	\N	\N	\N
102624	Nierenersatzverfahren_Mess_BehandlungsZeit	\N	\N	6	1	\N	\N	\N
102625	Nierenersatzverfahren_Mess_UFRBFRVerhaeltnis	\N	\N	6	1	\N	\N	\N
102626	Nierenersatzverfahren_Mess_UFR	\N	\N	6	1	\N	\N	\N
102627	Nierenersatzverfahren_Mess_SubstituatVolumen	\N	\N	6	1	\N	\N	\N
102628	Nierenersatzverfahren_Mess_Bilanz	\N	\N	6	1	\N	\N	\N
102629	Nierenersatzverfahren_Mess_SubBolusVolumen	\N	\N	6	1	\N	\N	\N
102630	Nierenersatzverfahren_Mess_UFVolumenKumulativ	\N	\N	6	1	\N	\N	\N
102631	Nierenersatzverfahren_Mess_Dialysatvolumen	\N	\N	6	1	\N	\N	\N
102632	Nierenersatzverfahren_Mess_BilanzGleichUFVolumen	\N	\N	6	1	\N	\N	\N
102634	Nierenersatzverfahren_Mess_UFZiel	\N	\N	6	1	\N	\N	\N
102635	Nierenersatzverfahren_Mess_RestZeit	\N	\N	6	1	\N	\N	\N
102638	Nierenersatzverfahren_Mess_SollNatrium	\N	\N	6	1	\N	\N	\N
102639	Nierenersatzverfahren_Mess_Bicarbonat	\N	\N	6	1	\N	\N	\N
102642	Nierenersatzverfahren_Mess_ISOUFZiel	\N	\N	6	1	\N	\N	\N
102643	Nierenersatzverfahren_Mess_ISOUFZeit	\N	\N	6	1	\N	\N	\N
102644	Nierenersatzverfahren_Mess_ISOUFRate	\N	\N	6	1	\N	\N	\N
102649	Nierenersatzverfahren_Mess_KumuliertesBlutvolumen	\N	\N	6	1	\N	\N	\N
102650	Nierenersatzverfahren_Mess_Fluss	\N	\N	6	1	\N	\N	\N
102651	Nierenersatzverfahren_Einstell_DialyseZeit	\N	\N	6	1	\N	\N	\N
102652	Nierenersatzverfahren_Einstell_StartNatrium	\N	\N	6	1	\N	\N	\N
102736	PT_Massnahmen_Atemtherapie7	\N	\N	3	100534	\N	\N	\N
102655	Nierenersatzverfahren_Mess_ZufuhrSubstituat	\N	\N	6	1	\N	\N	\N
102656	Nierenersatzverfahren_Einstell_ZufuhrSubstituat	\N	\N	3	1	\N	\N	\N
102657	Beatmung_Einstellung_ETS	Exspiratorische Triggersensibilität	%	6	1	\N	\N	\N
102658	Beatmung_Messung_Amplitude	Amplitude bei HFOV	mbar	6	1	\N	\N	\N
102659	Nierenersatzverfahren_Einstell_UFProfil	\N	\N	6	1	\N	\N	\N
102660	Nierenersatzverfahren_Einstell_NatriumProfil	\N	\N	6	1	\N	\N	\N
102661	Nierenersatzverfahren_Einstell_ISOUFZiel	\N	\N	6	1	\N	\N	\N
102662	Nierenersatzverfahren_Einstell_ISOUFZeit	\N	\N	6	1	\N	\N	\N
104289	Score_CAM_ICU_Punktwert_Gesamt	\N	\N	1	1	\N	\N	\N
102663	Nierenersatzverfahren_Einstell_ISOUFRate	\N	\N	6	1	\N	\N	\N
102664	Nierenersatzverfahren_Einstell_BlutflussSNPumpe	\N	\N	6	1	\N	\N	\N
102665	Nierenersatzverfahren_Mess_Dialysekonzentrat	\N	\N	6	1	\N	\N	\N
102666	Nierenersatzverfahren_Mess_DialyseZeit	\N	\N	6	1	\N	\N	\N
102667	Nierenersatzverfahren_Mess_SubBolus	\N	\N	6	1	\N	\N	\N
102668	Nierenersatzverfahren_Mess_UltrafiltrationsVolumen	\N	\N	6	1	\N	\N	\N
102669	Nierenersatzverfahren_Mess_AktuellesNatrium	\N	\N	6	1	\N	\N	\N
102670	Nierenersatzverfahren_Mess_BasisNatrium	\N	\N	6	1	\N	\N	\N
102671	Nierenersatzverfahren_Mess_BlutflussSNPumpe	\N	\N	6	1	\N	\N	\N
102795	Score_CRIB	\N	\N	1	1	\N	\N	\N
102672	Nierenersatzverfahren_VO_DialysekonzentratALT	\N	\N	6	1	\N	\N	\N
102674	Nierenersatzverfahren_VO_UFZiel	\N	\N	6	1	\N	\N	\N
102675	Nierenersatzverfahren_VO_DialyseZeit	\N	\N	6	1	\N	\N	\N
102676	Nierenersatzverfahren_VO_SollNatrium	\N	\N	6	1	\N	\N	\N
102677	Nierenersatzverfahren_VO_Bicarbonat	\N	\N	6	1	\N	\N	\N
102678	Nierenersatzverfahren_VO_Temperatur	\N	\N	6	1	\N	\N	\N
102679	Nierenersatzverfahren_VO_Filter	\N	\N	3	1	\N	\N	\N
102680	Nierenersatzverfahren_VO_NatriumProfil	\N	\N	6	1	\N	\N	\N
102681	Nierenersatzverfahren_VO_StartNatrium	\N	\N	6	1	\N	\N	\N
102682	Nierenersatzverfahren_VO_BasisNatrium	\N	\N	6	1	\N	\N	\N
102686	Nierenersatzverfahren_VO_BlutflussSNPumpe	\N	\N	6	1	\N	\N	\N
102687	Nierenersatzverfahren_VO_SubstituatVolumen	\N	\N	6	1	\N	\N	\N
102688	Nierenersatzverfahren_VO_SubBolus	\N	\N	6	1	\N	\N	\N
102689	Nierenersatzverfahren_VO_SpueloesungAntikoagulanz	\N	\N	3	1	\N	\N	\N
102690	Nierenersatzverfahren_VO_Dialysatloesung	\N	\N	3	1	\N	\N	\N
102691	Nierenersatzverfahren_VO_PlasmaVolumen	\N	\N	6	1	\N	\N	\N
102692	Nierenersatzverfahren_VO_UFProfil	\N	\N	6	1	\N	\N	\N
102695	Nierenersatzverfahren_Einstell_Dialysekonzentrat	\N	\N	6	1	\N	\N	\N
102696	Nierenersatzverfahren_Einstell_Abnahme	\N	\N	6	1	\N	\N	\N
102697	Nierenersatzverfahren_Einstell_BasisNatrium	\N	\N	6	1	\N	\N	\N
102698	Nierenersatzverfahren_Einstell_Substituat	\N	\N	6	1	\N	\N	\N
102699	Nierenersatzverfahren_Einstell_Dialysierfluessigke	\N	\N	6	1	\N	\N	\N
102700	Nierenersatzverfahren_Mess_Austauschrate	\N	\N	6	1	\N	\N	\N
102702	Nierenersatzverfahren_Mess_EffektiverEntzug	\N	\N	6	1	\N	\N	\N
102704	Nierenersatzverfahren_VO_Fluß	\N	\N	6	1	\N	\N	\N
102707	Nierenersatzverfahren_Doku_SpuelbeutelInitialdosis	\N	\N	3	1	\N	\N	\N
102708	Nierenersatzverfahren_Mess_GBV	\N	\N	6	1	\N	\N	\N
102710	Nierenersatzverfahren_VO_Zugang	\N	\N	3	1	\N	\N	\N
102711	Nierenersatzverfahren_Doku_Zugang	\N	\N	19	1	\N	\N	\N
102712	Nierenersatzverfahren_Doku_AbschlussBeurteilung	\N	\N	3	1	\N	\N	\N
102713	Nierenersatzverfahren_Doku_Schlauchsystem	\N	\N	19	1	\N	\N	\N
102714	Nierenersatzverfahren_Doku_Filter	\N	\N	19	1	\N	\N	\N
102716	Nierenersatzverfahren_Doku_Verfahren	\N	\N	19	1	\N	\N	\N
102721	Nierenersatzverfahren_Einstell_Calcium	\N	\N	6	1	\N	\N	\N
102723	Nierenersatzverfahren_Mess_iCaPostFilter	\N	\N	6	1	\N	\N	\N
102724	Nierenersatzverfahren_Mess_iCasystemBGA	\N	\N	6	1	\N	\N	\N
102725	Nierenersatzverfahren_Mess_iCaGesammt	\N	\N	6	1	\N	\N	\N
102726	Nierenersatzverfahren_Mess_StartNatrium	\N	\N	6	1	\N	\N	\N
102727	Nierenersatzverfahren_Mess_Abnahme	\N	\N	6	1	\N	\N	\N
102729	Nierenersatzverfahren_Einstell_Citrat	\N	\N	6	1	\N	\N	\N
102730	PT_Massnahmen_Atemtherapie1	\N	\N	3	100534	\N	\N	\N
102731	PT_Massnahmen_Atemtherapie2	\N	\N	3	100534	\N	\N	\N
102732	PT_Massnahmen_Atemtherapie3	\N	\N	3	100534	\N	\N	\N
102733	PT_Massnahmen_Atemtherapie4	\N	\N	3	100534	\N	\N	\N
102734	PT_Massnahmen_Atemtherapie5	\N	\N	3	100534	\N	\N	\N
102735	PT_Massnahmen_Atemtherapie6	\N	\N	3	100534	\N	\N	\N
102737	Nierenersatzverfahren_Doku_SpueloesungAntikoagulan	\N	\N	19	1	\N	\N	\N
102738	Nierenersatzverfahren_Mess_Leitfähigkeit	\N	\N	6	1	\N	\N	\N
102739	Nierenersatzverfahren_VO_SubstituatRate	\N	\N	6	1	\N	\N	\N
102740	Nierenersatzverfahren_VO_Plasma	\N	\N	6	1	\N	\N	\N
102741	Nierenersatzverfahren_VO_Spueldauer	\N	\N	6	1	\N	\N	\N
102742	Nierenersatzverfahren_VO_CitratLoesung	\N	\N	6	1	\N	\N	\N
102743	Nierenersatzverfahren_VO_Calcium	\N	\N	6	1	\N	\N	\N
102744	Nierenersatzverfahren_VO_CitratDosis	angeordnete Citratdosis	mmol/l	6	1	\N	\N	\N
102745	Nierenersatzverfahren_VO_Austauschrate	\N	\N	6	1	\N	\N	\N
102746	Nierenersatzverfahren_VO_EffektiverEntzug	\N	\N	6	1	\N	\N	\N
102747	Nierenersatzverfahren_Einstell_Spueldauer	\N	\N	6	1	\N	\N	\N
102748	Nierenersatzverfahren_Einstell_CitratLoesung	\N	\N	6	1	\N	\N	\N
102749	Nierenersatzverfahren_Einstell_CalciumLoesung	\N	\N	6	1	\N	\N	\N
102750	Nierenersatzverfahren_Mess_AustauschrateKumulativ	\N	\N	6	1	\N	\N	\N
102751	Nierenersatzverfahren_Mess_PF	\N	\N	6	1	\N	\N	\N
102752	Nierenersatzverfahren_Mess_CitratFluss	\N	\N	6	1	\N	\N	\N
102753	Nierenersatzverfahren_Mess_CalciumFluss	\N	\N	6	1	\N	\N	\N
102754	Nierenersatzverfahren_VO_Austausch	\N	\N	6	1	\N	\N	\N
102755	Nierenersatzverfahren_VO_Dialysat	\N	\N	6	1	\N	\N	\N
102756	Nierenersatzverfahren_Mess_VenoeserDruck	\N	\N	6	1	\N	\N	\N
102758	Nierenersatzverfahren_VO_UFR	\N	\N	6	1	\N	\N	\N
102760	Nierenersatzverfahren_VO_ISOUF	\N	\N	6	1	\N	\N	\N
102763	Nierenersatzverfahren_VO_CalciumLoesung	Bezeichnug der Calcium Lösung	\N	3	1	\N	\N	\N
102765	Score_ARDS_Wert	\N	\N	2	102764	\N	\N	\N
102766	Score_ARDS_Compliance	\N	\N	27	102764	\N	\N	\N
102767	Score_ARDS_PEEPScore	\N	\N	27	102764	\N	\N	\N
102768	Score_ARDS_RoentgenbefundLunge	\N	\N	27	102764	\N	\N	\N
102769	Score_ARDS_HypoxieScoreFio2	\N	\N	27	102764	\N	\N	\N
102770	Score_ARDS_Date	\N	\N	5	102764	\N	\N	\N
102772	Score_TISS10_Date	\N	\N	5	102771	\N	\N	\N
102773	Score_TISS10_InotropikaGabe	\N	\N	27	102771	\N	\N	\N
102774	Score_TISS10_InterventionAufICU	\N	\N	27	102771	\N	\N	\N
102775	Score_TISS10_ICPMessung	\N	\N	27	102771	\N	\N	\N
102776	Score_TISS10_extrakorpNierenersatz	\N	\N	27	102771	\N	\N	\N
102777	Score_TISS10_TransIntensivP	\N	\N	27	102771	\N	\N	\N
102778	Score_TISS10_Wert	\N	\N	2	102771	\N	\N	\N
102779	Score_TISS10_artKatheter	\N	\N	27	102771	\N	\N	\N
102780	Score_TISS10_erweitHaemoynMonit	\N	\N	27	102771	\N	\N	\N
102781	Score_TISS10_intravFluessTh	\N	\N	27	102771	\N	\N	\N
102782	Score_TISS10_AzidoseAlkalose	\N	\N	27	102771	\N	\N	\N
102783	Score_TISS10_Beatmung	\N	\N	27	102771	\N	\N	\N
102784	Score_RASS	\N	\N	1	1	\N	\N	\N
102785	Score_AIS	\N	\N	1	1	\N	\N	\N
102786	Score_Aldrete	\N	\N	1	1	\N	\N	\N
102790	Score_Besinger	\N	\N	1	1	\N	\N	\N
102792	Score_CIWA	\N	\N	1	1	\N	\N	\N
102793	Score_Cleveland	\N	\N	1	1	\N	\N	\N
102796	Score_DRS	\N	\N	1	1	\N	\N	\N
102801	Score_MAAS	\N	\N	1	1	\N	\N	\N
102802	Score_MMS	\N	\N	1	1	\N	\N	\N
102805	Score_MukositisSkala	\N	\N	1	1	\N	\N	\N
102807	Score_NIPS	\N	\N	1	1	\N	\N	\N
102810	Score_RSS	\N	\N	1	1	\N	\N	\N
102811	Score_RTS	\N	\N	1	1	\N	\N	\N
102812	Score_SAS	\N	\N	1	1	\N	\N	\N
102813	Score_Lachs	\N	\N	1	1	\N	\N	\N
102814	Score_Tinetti	\N	\N	3	102813	\N	\N	\N
102815	Score_VICS	\N	\N	1	1	\N	\N	\N
102816	Score_Waterlow	\N	\N	1	1	\N	\N	\N
102817	Score_APACHE2_Wert	\N	\N	2	102787	\N	\N	\N
102818	Score_APACHE2_Date	\N	\N	5	102787	\N	\N	\N
102819	Score_APACHE2_GCS	\N	\N	27	102787	\N	\N	\N
102820	Score_APACHE2_Hkrit	\N	\N	27	102787	\N	\N	\N
102821	Score_APACHE2_Leuk	\N	\N	27	102787	\N	\N	\N
102822	Score_APACHE2_Ka	\N	\N	27	102787	\N	\N	\N
102823	Score_APACHE2_Krea	\N	\N	27	102787	\N	\N	\N
102824	Score_APACHE2_pH	\N	\N	27	102787	\N	\N	\N
102825	Score_APACHE2_Na	\N	\N	27	102787	\N	\N	\N
102826	Score_APACHE2_PaO2	\N	\N	27	102787	\N	\N	\N
102827	Score_APACHE2_PaO2_kPa	\N	\N	27	102787	\N	\N	\N
102828	Score_APACHE2_HF	\N	\N	27	102787	\N	\N	\N
102829	Score_APACHE2_AF	\N	\N	27	102787	\N	\N	\N
102830	Score_APACHE2_Temp	\N	\N	27	102787	\N	\N	\N
102831	Score_APACHE2_MAD	\N	\N	27	102787	\N	\N	\N
102833	Score_Barthel_Wert	\N	\N	2	102832	\N	\N	\N
102834	Score_Barthel_Ankleiden	\N	\N	27	102832	\N	\N	\N
102835	Score_Barthel_Date	\N	\N	5	102832	\N	\N	\N
102836	Score_Barthel_Harnkontrolle	\N	\N	27	102832	\N	\N	\N
102837	Score_Barthel_Stuhlkontrolle	\N	\N	27	102832	\N	\N	\N
102838	Score_Barthel_Bewegung	\N	\N	27	102832	\N	\N	\N
102839	Score_Barthel_Treppensteigen	\N	\N	27	102832	\N	\N	\N
102840	Score_Barthel_Toilette	\N	\N	27	102832	\N	\N	\N
102841	Score_Barthel_Baden	\N	\N	27	102832	\N	\N	\N
102842	Score_Barthel_AufsetzenUmsetzen	\N	\N	27	102832	\N	\N	\N
102843	Score_Barthel_persoenlichePflege	\N	\N	27	102832	\N	\N	\N
102844	Score_Barthel_Essen	\N	\N	27	102832	\N	\N	\N
102845	Score_RASS_Wert	\N	\N	2	102784	\N	\N	\N
102846	Score_RASS_Date	\N	\N	5	102784	\N	\N	\N
102847	Score_RASS_RASS	\N	\N	27	102784	\N	\N	\N
102850	Braden_Verlauf_Aktivitaet	\N	\N	27	102848	\N	\N	\N
102851	Braden_Verlauf_Datum	\N	\N	5	102848	\N	\N	\N
102852	Braden_Verlauf_Ernaehrung	\N	\N	27	102848	\N	\N	\N
102853	Braden_Verlauf_Feuchtigkeit	\N	\N	27	102848	\N	\N	\N
102854	Braden_Verlauf_Mobilitaet	\N	\N	27	102848	\N	\N	\N
102855	Braden_Verlauf_ReibungUScherkraefte	\N	\N	27	102848	\N	\N	\N
102856	Braden_Verlauf_SensorischesEmpfindungsvermoegen	\N	\N	27	102848	\N	\N	\N
102857	Braden_Verlauf_Wert	\N	\N	2	102848	\N	\N	\N
102858	Beatmung_Einstellung_CPAPcmH2O	CPAP Einstellung in der Maßeinheit cm H2O; Verwendung bei F120 und CF 800	cm H2O	6	1	\N	\N	\N
102859	Nierenersatzverfahren_VO_ISOUFZeit	Isolierte Ultrafiltration/Bergström	h	6	1	\N	\N	\N
102860	Beatmung_Messung_CPAPcmH2O	gemessener CPAP in der Maßeinheit cm H2O	cm H2O	6	1	\N	\N	\N
102861	Beatmung_MS_BiPAPV_Pimax	Pimax (Maximaler inspiratorischer Atemwegsdruck)  	cm H2O	6	1	\N	\N	\N
102862	Beatmung_MS_BiPAPV_IPAP	gemeesener IPAP (Inspiratorisch Positiver Atemwegsdruck) 	cm H2O	6	1	\N	\N	\N
102863	Beatmung_MS_BiPAPV_EPAP	 gemessener EPAP (=Expiratorisch Positiver Atemwegsdruck)  	cm H2O	6	1	\N	\N	\N
102864	Beatmung_MS_BiPAPV_TiTtot	Ti/Ttot (Inspirationszeit/Dauer des ganzen Zyklus) 	%	6	1	\N	\N	\N
102865	Beatmung_MS_BiPAPV_Patientenleckage	Patientenleck - Die Leckage die aufgrund Masken- bzw. Helmleckage unabhängig der Sollleckage gemessen wird  	l/min	6	1	\N	\N	\N
102866	Beatmung_MS_BiPAPV_Gesamtleckage	Die gemessene Gesamtleckage inclusive der bestehenden Sollleckage	l/min	6	1	\N	\N	\N
102867	Beatmung_MS_BiPAPV_PatientenTrigger	Pat.Trig (Prozentsatz der vom Patienten ausgelösten Atemzüge) 	%	6	1	\N	\N	\N
102868	Beatmung_ES_BiPAPV_IPAP	 eingestellter IPAP Wert	cm H2O	6	1	\N	\N	\N
102869	Beatmung_ES_BiPAPV_EPAP	 eingestellter EPAP Wert	cm H2O	6	1	\N	\N	\N
102870	Beatmung_ES_BiPAPV_IPAPAnstiegszeit	IPAP-Anstiegszeit in Sekunden eingestellt 	Sek.	6	1	\N	\N	\N
102871	Nierenersatzverfahren_Einstellung_FuellenMit	System vorfüllen mit Flüssigkeiten aus einer Auswahlliste	\N	3	1	\N	\N	\N
102872	Beatmung_ES_VisionA_Oszillationsfrequenz	Oszillationsfrequenz Gerät: Alpha Vision Modus: HFO	Hz	6	1	\N	\N	\N
102873	Beatmung_ES_VisionA_MAP	Mittlerer Atemwegsdruck (MAP)	cm H2O	6	1	\N	\N	\N
102874	Beatmung_ES_VisionA_Schlagvolumen	Schlagvolumen (SV) in engl. (cycle volume)	ml	6	1	\N	\N	\N
102876	Beatmung_ES_VisionA_HFOBaseFlow	Basis Continousflow	l/min	6	1	\N	\N	\N
102877	Beatmung_ES_VisionA_SISetting	Druckeinstellung für manuell ausgelösten Atemhub	cm H2O	6	1	\N	\N	\N
102878	Beatmung_MS_VisionA_MAP	gemessener Mittlerer Atemwegsdruck unter HFO bei Alpha Vision	cm H2O	6	1	\N	\N	\N
102880	Beatmung_MS_VisionA_SISetting	Dauer des manuell durchgeführten Atemhubs	s	6	1	\N	\N	\N
102881	Beatmung_MS_VisionA_HFOBaseFlow	gemessener Basis Continousflow	l/min	6	1	\N	\N	\N
102882	Nierenersatzverfahren_VO_Schlauchsystem	Verordnung Schlauchsystem	\N	3	1	\N	\N	\N
102883	Beatmung_ES_VisionA_PS	Pressure Support ; Alpha Vision	cm H2O	6	1	\N	\N	\N
102884	Beatmung_ES_VisionA_RiseTime	Anstiegszeit (Rampenzeit) Alpha Vision	s	6	1	\N	\N	\N
102885	Beatmung_MS_VisionA_PIP	positiv inspiratorischer Druck	cm H2O	6	1	\N	\N	\N
102886	Beatmung_ES_G5_Timax	eingestellte maximale Inspirationszeit beim G5 im Modus NIV	s	6	1	\N	\N	\N
102887	Beatmung_ES_G5_Ti	Einstelungswert für die Inspirationszeit	s	6	1	\N	\N	\N
102888	Beatmung_ES_G5_Thoch	Einstellwert: Zeiteinstellung des oberes Druckniveau beim G 5 im Modus DuoPAP	mbar	6	1	\N	\N	\N
102889	Beatmung_ES_G5_Plateau	prozentualer Anteil der Inspiration, der Plateauphase bestimmt wird	%	6	1	\N	\N	\N
102890	Beatmung_ES_G5_Phoch	Einstellwert oberes Druckniveau im beim G 5 im Modus DuoPAP	mbar	6	1	\N	\N	\N
102891	Beatmung_ES_G5_Pkontrol	Einstellwert oberes Druckniveau beim G 5 im Modus P SIMV	mbar	6	1	\N	\N	\N
102892	Beatmung_ES_G5_Psupport	Einstellwert: Druckunterstützung beim G 5  bei Spontanatemzügen	mbar	6	1	\N	\N	\N
102893	Beatmung_ES_G5_PeepCPAP	Einstellwert: Peep bzw. CPAP Niveau in verschiedenen Modi beim G 5	mbar	6	1	\N	\N	\N
102894	Beatmung_ES_G5_Ttief	Einstellwert: Zeiteinstellung für das untere Druckniveau beim G5 im Modus APRV	mbar	6	1	\N	\N	\N
102895	Beatmung_ES_G5_Ptief	Einstellwert: unteres Druckniveau beim G 5 im Modus APRV	mbar	6	1	\N	\N	\N
102897	Nierenersatzverfahren_VO_DialysatMultifiltrate	appliziertes Dialysat für Multifiltrate	\N	3	1	\N	\N	\N
102898	Beatmung_ES_G5_IEVerhaeltnis	Einstellwert: I:E Verhältnis	\N	3	1	\N	\N	\N
102899	Beatmung_MS_G5_Ppeak	Messwert: Beatmungsspitzendruck	mbar	6	1	\N	\N	\N
102900	Beatmung_MS_G5_Pmittel	Messwert: Beatmungsmitteldruck	mbar	6	1	\N	\N	\N
102901	Beatmung_MS_G5_PeepCPAP	Messwert: Beatmungsdruck Peep / CPAP	mbar	6	1	\N	\N	\N
102902	Beatmung_MS_G5_VTE	Messwert; exspiratorisches Tidalvolumen Einheit: ml	ml	6	1	\N	\N	\N
102903	Beatmung_MS_G5_InspFlow	Inspiratorischer Peakflow, ein Monitoring-Parameter	l/min	6	1	\N	\N	\N
102904	Beatmung_MS_G5_TI	Inspirationszeit in Sekunden, Monitoring-Parameter	s	6	1	\N	\N	\N
102905	Beatmung_MS_G5_Rinsp	Inspiratorische Flow-Resistance, ein Monitoring-Parameter	mbar/l/s	6	1	\N	\N	\N
102906	Beatmung_MS_G5_Rexsp	Exspiratorische Flow-Resistance, ein Monitoring-Parameter	mbar/l/s	6	1	\N	\N	\N
102907	Beatmung_MS_G5_Cstat	Statische Compliance, ein Monitoringwert	ml/mbar	6	1	\N	\N	\N
102908	Beatmung_MS_G5_RCinsp	Inspiratorische Zeitkonstante, ein Monitoring Parameter	s	6	1	\N	\N	\N
102909	Beatmung_MS_G5_RCexsp	Exspiratorische Zeitkonstante, ein Monitoring-Parameter	s	6	1	\N	\N	\N
102910	Beatmung_MS_G5_RSB	Index für schnelle Flachatmung (Rapid Shallow Breathing Index), Monitoring Parameter	\N	6	1	\N	\N	\N
102911	Beatmung_MS_G5_WOBimp	Zusätzlich auferlegte Atemarbeit, ein Monitoring Parameter	J/l	6	1	\N	\N	\N
102912	Beatmung_MS_G5_AutoPeep	Unerwarteter positiver endexspiratorischer Druck, ein Monitoring-Parameter	mbar	6	1	\N	\N	\N
102913	Beatmung_MS_G5_PTP	Druck Zeit Produkt (Pressure Time Product), ein Monitoring Parameter	mbar X s	6	1	\N	\N	\N
102914	Beatmung_MS_G5_VLeckage	Leckagevolumen, ein Monitoring-Parameter	l/min	6	1	\N	\N	\N
102915	Beatmung_MS_G5_ExspFlow	Exspiratorischer Peakflow, ein Monitoring-Parameter	l/min	6	1	\N	\N	\N
102916	Beatmung_MS_G5_TE	Exspirationzeit, ein Monitoring-Parameter	s	6	1	\N	\N	\N
102919	Nierenersatzverfahren_Doku_Dialysekonzentrat	Dialysekonzentrat mit Listenauswahl	\N	3	1	\N	\N	\N
102921	Nierenersatzverfahren_VO_Dialysekonzentrat	Dialysekonzentrat Verordnung String	\N	3	1	\N	\N	\N
102922	Beatmung_Einstellung_SauerstoffVolG5	Sauerstoffeinstellung in der Maßeinheit Vol %	Vol %	6	1	\N	\N	\N
102923	Beatmung_Messung_O2VolG5	Messwert des Sauerstoffgehalt in der Maßeinheit Vol %	Vol %	6	1	\N	\N	\N
102926	Beatmung_MS_G5_IEVerhaeltnis	gemessenes I:E Verhältnis	\N	3	1	\N	\N	\N
102927	Nierenverfahren_VO_Zugang	VO Gefäßzugang extracorporale Verfahren	\N	3	1	\N	\N	\N
102928	Nierenverfahren_VO_Filter	Filter  für extrakorporale Verfahren	\N	3	1	\N	\N	\N
102929	Nierenverfahren_VO_HFLoesung	Hämofiltrationslösung extrakorporale Verfahren	\N	3	1	\N	\N	\N
102930	Nierenverfahren_VO_Option	Predilution Postdilution extrakorporale Verfahren	\N	3	1	\N	\N	\N
102931	Beatmung_ES_G5_ETS	Exspiratorische Triggersensitivität, eine Parametereinstellung	%	6	1	\N	\N	\N
102932	Nierenverfahren_VO_Antikoagulanz	Antikoagulation Medikament	\N	3	1	\N	\N	\N
102933	Nierenverfahren_VO_SpülloesungAntikoagulanz	Spüllösung zum Vorbereiten des extrakorporalen Verfahrens	\N	3	1	\N	\N	\N
102934	Nierenverfahren_VO_FüllenMit	Liste hinterlegt mit Lösungen zum Befüllen des Systems vor Anschluss	\N	3	1	\N	\N	\N
104129	Behandlung_DIVI_EntlassenderArzt	\N	\N	3	30	\N	\N	\N
102935	Beatmung_ES_G5_Druckrampe	Eine Parametereinstellung. Anstiegszeit des Drucks bei druckkontrollierten und druckunterstützten Atemzyklus.	ms	6	1	\N	\N	\N
102937	Nierenverfahren_VO_Multi_BlutflussMax	max Blutpumpengeschwindigkeit VO	\N	6	1	\N	\N	\N
102938	Beatmung_ES_G5_Frequenz	Anzahl der Atemzyklen pro Minute, Parametereinstellung	AZ/min	6	1	\N	\N	\N
102939	Nierenverfahren_VO_Multi_UltrafiltrationMax	Ultrafiltrationsrate	ml/h	6	1	\N	\N	\N
102940	Nierenverfahren_VO_Multi_Substituat	Substituat in ml/h	\N	6	1	\N	\N	\N
102941	Nierenverfahren_VO_Multi_SubstituatBolus	Substituatbolus in ml	\N	6	1	\N	\N	\N
102942	Beatmung_ES_G5_Sauerstoff	Sauerstoffeinstellung	Vol%	6	1	\N	\N	\N
102943	Nierenverfahren_VO_Multi_Temperatur	Temperatur in Celsius	\N	6	1	\N	\N	\N
102944	Beatmung_ES_G5_ProzentMinVol	Przentsatz des Minutenvolumens, eine Parametereinstellung im ASV Modus	%	6	1	\N	\N	\N
102946	Beatmung_ES_G5_Groeße	Eine Parametereinstellung im ASV Modus. Sie wird zur Berechnnug des idealen Körpergewichts (IBW) des Patienten verwendet	cm	6	1	\N	\N	\N
102953	Nierenverfahren_VO_BM25_BlutflussMax	Blutpumpengeschwindigkeit	\N	6	1	\N	\N	\N
102954	Nierenverfahren_VO_BM25_AbnahmeMax	Ultrafiltrationsrate	ml/h	6	1	\N	\N	\N
102955	Nierenverfahren_VO_BM25_Umsatz	Umsatz ml/h	\N	6	1	\N	\N	\N
102956	Nierenverfahren_VO_BM25_Temperatur	Temperatur in Celsius	\N	6	1	\N	\N	\N
102965	Nierenverfahren_VO_ADM_BlutflussMax	Blutpumpengeschwindigkeit	\N	6	1	\N	\N	\N
102966	Nierenverfahren_VO_ADM_effEntzug	Entzugsrate ml/h	\N	6	1	\N	\N	\N
102967	Nierenverfahren_VO_ADM_Austauschrate	Umsatz, Austausch; Substituat ml/h	\N	6	1	\N	\N	\N
102968	Nierenverfahren_VO_ADM_Temperatur	Temperatur Celcius	\N	6	1	\N	\N	\N
102976	Nierenverfahren_ES_Multi_Blutfluss	Blutpumpengeschwindigkeit ml/min	\N	6	1	\N	\N	\N
102977	Nierenverfahren_ES_Multi_Ultrafiltration	Ultrafiltrationsrate ml/h	ml/h	6	1	\N	\N	\N
103076	Nierenverfahren_VO_ADM_Spueldauer	\N	h/min	6	1	\N	\N	\N
102979	Nierenverfahren_ES_Multi_SubstituatBolus	Substituatbolus ml	\N	6	1	\N	\N	\N
102980	Nierenverfahren_ES_Multi_Temperatur	Tempertatu Celsius	\N	6	1	\N	\N	\N
102990	Nierenverfahren_ES_BM25_Blutfluss	Blutpumpengeschwindigkeit	\N	6	1	\N	\N	\N
102991	Nierenverfahren_ES_BM25_Abnahme	Ultrafiltrationsrate	\N	6	1	\N	\N	\N
102993	Nierenverfahren_ES_BM25_Temperatur	Temperatur Celcius	\N	6	1	\N	\N	\N
103004	Nierenverfahren_ES_ADM_Blutfluss	Blutpumpengeschwindigkeit	ml/min	6	1	\N	\N	\N
103005	Nierenverfahren_ES_ADM_effEntzug	Entzugsrate, Ultrafiltrationsrate	ml/h	6	1	\N	\N	\N
103006	Nierenverfahren_ES_ADM_Austauschrate	Umsatz, Substituat	ml/h	6	1	\N	\N	\N
103007	Nierenverfahren_ES_ADM_Temperatur	\N	celsius	6	1	\N	\N	\N
103010	Nierenverfahren_MS_Multi_artDruck	arterieller Druck	mmHg	6	1	\N	\N	\N
103340	IABP_Doku_Ballonvolumen	\N	ml	6	1	\N	\N	\N
103011	Nierenverfahren_MS_Multi_venDruck	venöser Druck	mmHg	6	1	\N	\N	\N
103012	Nierenverfahren_MS_Multi_TMPDruck	Transmembrandruck	mmHg	6	1	\N	\N	\N
103013	Nierenverfahren_MS_Multi_DruckvorFilterDruck	\N	mmHg	6	1	\N	\N	\N
103014	Nierenverfahren_MS_Multi_Bilanz	Kumulativwert	liter	6	1	\N	\N	\N
103015	Nierenverfahren_MS_Multi_SubvolumenKumulativ	\N	liter	6	1	\N	\N	\N
103016	Nierenverfahren_MS_Multi_SubbolusvolumenKumulativ	\N	liter	6	1	\N	\N	\N
103017	Nierenverfahren_MS_Multi_UFRBFRVerhaeltnis	\N	Prozent	6	1	\N	\N	\N
103018	Nierenverfahren_MS_Multi_Behandlungszeit	\N	H/min	6	1	\N	\N	\N
103019	Nierenverfahren_MS_BM25_artDruck	\N	mmHg	6	1	\N	\N	\N
103020	Nierenverfahren_MS_BM25_venDruck	\N	mmHg	6	1	\N	\N	\N
103021	Nierenverfahren_MS_BM25_TMPDruck	\N	mmHg	6	1	\N	\N	\N
103022	Nierenverfahren_MS_BM25_DruckvorFilter	\N	mmHg	6	1	\N	\N	\N
103023	Nierenverfahren_MS_BM25_Bilanz	\N	mmHg	6	1	\N	\N	\N
103024	Nierenverfahren_MS_BM25_UmsatzvolumenKumulativ	\N	Liter	6	1	\N	\N	\N
103025	Nierenverfahren_MS_BM25_Behandlungszeit	\N	h/min	6	1	\N	\N	\N
103026	Nierenverfahren_MS_ADM_artDruck	\N	mmHg	6	1	\N	\N	\N
103027	Nierenverfahren_MS_ADM_TMPDruck	\N	mmHg	6	1	\N	\N	\N
103028	Nierenverfahren_MS_ADM_Bilanz	\N	liter	6	1	\N	\N	\N
103029	Nierenverfahren_MS_ADM_AustauschKumulativ	\N	liter	6	1	\N	\N	\N
103030	Nierenverfahren_MS_ADM_Behandlungszeit	\N	h/min	6	1	\N	\N	\N
103031	Nierenverfahren_MS_ADM_venDruck	\N	mmHg	6	1	\N	\N	\N
103032	Beatmung_MS_G5_Pplateau	Plateau-Atemwegsdruck, ein Monitoring-Parameter	mbar	6	1	\N	\N	\N
103033	Beatmung_MS_G5_Pmin	Minimaler Atemwegsdruck, ein Monitoring Parameter	mbar	6	1	\N	\N	\N
103034	Beatmung_MS_G5_ExpMinVol	Exspiratorisches Minutenvolumen, Monitoring-Parameter 	l/min	6	1	\N	\N	\N
102992	Nierenverfahren_ES_BM25_Umsatz	Austausch, Substituat, ml/h	mL/h	6	1	\N	\N	\N
103035	Beatmung_MS_G5_ftotal	Gesamtatemfrequenz, ein Monitoring Parameter	AZ/min	6	1	\N	\N	\N
103036	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz	AZ/min	6	1	\N	\N	\N
103037	Beatmung_MS_G5_O2VolProzent	Sauerstoffkonzentration des abgegebenen Gasgemisches	%	6	1	\N	\N	\N
103040	Beatmung_MS_G5_Pinsp	Inspiratorischer Druck; mit Pinsp wird der Zieldruck (zusätzlich zu PEEP/CPAP) bezeichnet, der im Modus ASV während der Inspirationsphase abgegeben wird	mbar	6	1	\N	\N	\N
103041	Beatmung_MS_G5_P01	Atemweg-Okklusionsdruck, ein Monitoring-Parameter	mbar	6	1	\N	\N	\N
103042	Nierenverfahren_VO_Dialysatlösung	Dialysatlösung, Beutel	\N	3	1	\N	\N	\N
103043	Nierenverfahren_VO_Multi_Dialysat	Dialysatrate	ml/h	6	1	\N	\N	\N
103045	Nierenverfahren_VO_BM25_Dialysat	Gialysatrate	ml/h	6	1	\N	\N	\N
103049	Nierenverfahren_MS_Multi_DialysatvolumenKumulativ	kumulatives Dialysatvol	liter	6	1	\N	\N	\N
103050	Nierenverfahren_MS_BM25_DialysatvolumenKumulativ	\N	liter	6	1	\N	\N	\N
103051	Nierenverfahren_VO_Citratloesung	Citratbeutel	\N	3	1	\N	\N	\N
103052	Nierenverfahren_VO_Calciumloesung	Calciumbeutel	\N	3	1	\N	\N	\N
103053	Nierenverfahren_VO_Multi_Citrat	Dosierung	mmol/l	6	1	\N	\N	\N
103054	Nierenverfahren_VO_Multi_Calcium	Ca-rate	mmol/l	6	1	\N	\N	\N
103055	Nierenverfahren_ES_Multi_Calciumloesung	Beutel	\N	3	1	\N	\N	\N
103056	Nierenverfahren_ES_Multi_Citratloesung	Beutel	\N	3	1	\N	\N	\N
103057	Nierenverfahren_ES_Multi_CitratBlut	Citratrate	mmol/l	6	1	\N	\N	\N
103058	Nierenverfahren_ES_Multi_CalciumFiltrat	Calciumrate	mmol/l	6	1	\N	\N	\N
103059	Nierenverfahren_MS_Multi_CitratvolumenKumulativ	kumulativ Citrat	ml	6	1	\N	\N	\N
103060	Nierenverfahren_MS_Multi_CalciumvolumenKumulativ	kumulativ	ml	6	1	\N	\N	\N
103061	Nierenverfahren_MS_Multi_Citratfluss	Citratrate	ml/h	6	1	\N	\N	\N
103062	Nierenverfahren_MS_Multi_Calciumfluss	Calciumrate	ml/h	6	1	\N	\N	\N
103063	Nierenverfahren_VO_MultiPlasmavolumen	\N	ml	6	1	\N	\N	\N
103064	Nierenverfahren_VO_BM25_Plasmavolumen	\N	ml	6	1	\N	\N	\N
103065	Nierenverfahren_ES_Multi_Plasmavolumen	\N	ml	6	1	\N	\N	\N
103066	Nierenverfahren_ES_Multi_Plasma	Plasmarate	ml/h	6	1	\N	\N	\N
103067	Nierenverfahren_ES_BM25_Plasmavolumen	\N	ml	6	1	\N	\N	\N
103068	Nierenverfahren_ES_BM25_Plasma	Plasmarate	ml/h	6	1	\N	\N	\N
103069	Nierenverfahren_ES_ADM_Plasmavolumen	\N	ml	6	1	\N	\N	\N
103070	Nierenverfahren_ES_ADM_PlasmaAustausch	Plasmarate	ml/h	6	1	\N	\N	\N
103071	Nierenverfahren_MS_Multi_PlasmavolumenKumulativ	Kumulativ	liter	6	1	\N	\N	\N
103072	Nierenverfahren_MS_BM25_verabreichtesPlasma	Kumulativ	liter	6	1	\N	\N	\N
103073	Nierenverfahren_MS_ADM_verabreichtesPlasma	kumulativ	liter	6	1	\N	\N	\N
103074	Nierenverfahren_VO_BM25_Spueldauer	\N	H/min	6	1	\N	\N	\N
103075	Nierenverfahren_VO_Spueldauer	\N	h/min	6	1	\N	\N	\N
103077	Beatmung_ES_VisionA_O2Konzentration	Eingestellte Sauerstoffzufuhr	%	6	1	\N	\N	\N
103078	Beatmung_MS_VisionA_Amplitude	gemessene Druckdifferenz im HFOV Modus	cm H2O	6	1	\N	\N	\N
103079	Beatmung_MS_VisionA_O2Konzentration	gemessene Sauerstoffgehalt des Gasgemisches	%	6	1	\N	\N	\N
103080	Beatmung_ES_VisionA_Trigger	Einstellgrösse: Druck bzw. Flowtrigger	cm H2O bzw. l/min	3	1	\N	\N	\N
103081	Beatmung_ES_VisionA_ETS	Exspirationserkennung 10 - 45% des Peak Flow	%	6	1	\N	\N	\N
103082	Beatmung_MS_VisionA_AFSpontan	Messwert: Anzahl der gemessenen spontanen Atemzüge	AZ/min	6	1	\N	\N	\N
103083	Beatmung_MS_VisionA_SpontanAMV	gemessenes spontanes Atemminutenvolumen	l/min	6	1	\N	\N	\N
103084	Beatmung_MS_VisionA_Tidalvolumen	gemessenes Tidalvolumen	ml	6	1	\N	\N	\N
103085	Nierenverfahren_VO_ADM_Plasmavolumen	Plasmaaustauschvolumen kumulativ	ml	6	1	\N	\N	\N
103086	Beatmung_ES_F120_CPAP	Eingestelltes CPAP Niveau	cm H20	6	1	\N	\N	\N
103087	Beatmung_ES_F120_Flow	Einstellwert: Größe des Gasflusses beim F 120	l/min	6	1	\N	\N	\N
103088	Beatmung_ES_F120_O2Konzentration	Einstellparameter: Sauerstoffgehalt des Gasgemisches	%	6	1	\N	\N	\N
103089	Nierenverfahren_ES_Multi_ZugangBalken	\N	\N	19	1	\N	\N	\N
103090	Nierenverfahren_ES_Multi_FilterBalken	\N	\N	19	1	\N	\N	\N
103091	Beatmung_ES_CF800_SauerstoffFlow	Einstellgröße Gasfluss Sauerstoff	l/min	6	1	\N	\N	\N
103092	Beatmung_ES_CF800_DruckluftFlow	Einstellgröße: Gasfluss Druckluft	l/min	6	1	\N	\N	\N
103093	Beatmung_ES_CF800_O2Konzentration	Sauerstoffgehalt des eingestellten Gasgemisches CF 800	%	6	1	\N	\N	\N
103094	Beatmung_ES_CF800_CPAP	eingestelltes CPAP Niveau	cm H2O	6	1	\N	\N	\N
103095	Nierenverfahren_Doku_Dialysatlösung	Dialysatlösung	ml	19	1	\N	\N	\N
103097	Nierenverfahren_Doku_SpuellösungAntikoagulanz	Spülung zur Vorbereitung	ml	3	1	\N	\N	\N
103098	Nierenverfahren_MS_Multi_pFDruck	Druck vor Filter Hämoperfusion	mmHg	6	1	\N	\N	\N
103107	Nierenverfahren_Doku_Zugang	\N	\N	19	1	\N	\N	\N
103108	Nierenverfahren_Doku_Filter	Filter	\N	19	1	\N	\N	\N
103109	Nierenverfahren_Doku_HFLoesung	HFLösung	\N	19	1	\N	\N	\N
103110	Nierenverfahren_Doku_Option	Option	\N	19	1	\N	\N	\N
103111	Nierenverfahren_Doku_Antikoagulation	\N	\N	19	1	\N	\N	\N
103114	Nierenverfahren_Doku_Spueldauer	Spüldauer	h:min	6	1	\N	\N	\N
103115	Nierenverfahren_Doku_FüllenMit	Füllen des Systems	\N	3	1	\N	\N	\N
103116	Nierenverfahren_MS_Bilanz	Variable wird verwendet für Multifiltrate und ADM 08	liter	6	1	\N	\N	\N
103117	Nierenverfahren_Doku_AbschlussBeurteilung	\N	\N	3	1	\N	\N	\N
103118	Nierenverfahren_Doku_Abschlussbegruendung	\N	\N	3	1	\N	\N	\N
103121	Nierenverfahren_Doku_Calciumloesung	Calciumlösung	\N	19	1	\N	\N	\N
103122	Nierenverfahren_Doku_Citratloesung	Citratlösung	\N	19	1	\N	\N	\N
103526	Score_DGAI_EntlInfoHFOV	\N	\N	2	1	\N	\N	\N
103123	Nierenverfahren_ES_Multi_Dialysat	\N	ml/h	6	1	\N	\N	\N
103124	Nierenverfahren_ES_BM25_Dialysat	\N	ml/h	6	1	\N	\N	\N
103125	Beatmung_ES_BiPAPV_CPAP	Einstellparameter CPAP im Modus CPAP	cm H2O	6	1	\N	\N	\N
103126	Beatmung_ES_BiPAPV_O2Konzentration	Einstellparameter: O2 Konzentration des Gasgemisches	%	6	1	\N	\N	\N
103127	Beatmung_MS_BiPAPV_AF	Messparameter: gemessene Atemfrequenz	AZ/min	6	1	\N	\N	\N
103128	Beatmung_MS_BiPAPV_CPAP	Messwert: gemessenes CPAP Niveau	cm H2O	6	1	\N	\N	\N
103129	Beatmung_MS_BiPAPV_AMV	Messwert: gemessenes AMV	l/min	6	1	\N	\N	\N
103130	Beatmung_MS_BiPAPV_O2Konzentration	Messwert: gemessene O2 Konzentration des Gasgemisches	%	6	1	\N	\N	\N
103132	Beatmung_MS_BiPAPV_Vt	Messwert: gemessenes Tidalvolumen	ml	6	1	\N	\N	\N
103133	Beatmung_ES_BiPAPV_Inspirationszeit	Einstellwert: Zeiteinstellung für die Inspirationszeit	s	6	1	\N	\N	\N
103134	Beatmung_ES_BiPAPV_AF	Einstellwert: eingestellte Mindestatemfrequenz im ST Moodus	AZ/min	6	1	\N	\N	\N
103135	Nierenverfahren_VO_Bolus	Medikament	\N	3	1	\N	\N	\N
103136	Nierenverfahren_Doku_Bolus	Medikament	\N	3	1	\N	\N	\N
103139	Beatmung_ES_VisionA_PEEPCPAP	Einstellwert: eingestelltes Peep bzw. CPAP Niveau	cmH2O	6	1	\N	\N	\N
103142	Beatmung_MS_VisionA_PEEP	Messwert: gemessener positiver endexspiratorischer Druck	cmH2O	6	1	\N	\N	\N
103143	Nierenverfahren_VO_Plasmaloesung	\N	\N	3	1	\N	\N	\N
103145	Nierenverfahren_Doku_Plasmalösung	\N	\N	19	1	\N	\N	\N
103146	Nierenverfahren_ES_4008HS_DialyseZeit	\N	h:min	6	1	\N	\N	\N
103147	Nierenverfahren_ES_4008HS_UFZiel	Ultrafiltrationsziel	ml	6	1	\N	\N	\N
103148	Nierenverfahren_ES_4008HS_UFRate	Ultrafiltrationsrate	ml/h	6	1	\N	\N	\N
103149	Nierenverfahren_ES_4008HS_IsoUFZiel	\N	ml	6	1	\N	\N	\N
103150	Nierenverfahren_ES_4008HS_IsoUFZeit_	Isolierte Ultrafiltration	h:min	6	1	\N	\N	\N
103151	Nierenverfahren_ES_4008HS_IsoUFRate	Isolierte Ultrafiltration	ml/h	6	1	\N	\N	\N
103152	Nierenverfahren_ES_4008HS_Blutfluss	\N	ml/min	6	1	\N	\N	\N
103153	Nierenverfahren_ES_4008HS_BlutflussSNPumpe	\N	ml/min	6	1	\N	\N	\N
103154	Beatmung_Doku_NIV_Applikationsform	Auswahl für die Applikationsform von NIV Anwendungen	\N	19	1	\N	\N	\N
103155	Nierenverfahren_ES_4008HS_NaProfil	\N	Zahl	6	1	\N	\N	\N
103156	Nierenverfahren_ES_4008HS_StartNa	\N	mmol/l	6	1	\N	\N	\N
103157	Nierenverfahren_ES_4008HS_BasisNa	\N	mmol/l	6	1	\N	\N	\N
103158	Nierenverfahren_ES_4008HS_SollNa	\N	mmol/l	6	1	\N	\N	\N
104077	SAPS2_Leuko_Aufnahme	\N	\N	27	104068	\N	\N	\N
103159	Nierenverfahren_ES_4008HS_UFProfil	\N	Zahl	6	1	\N	\N	\N
103160	Nierenverfahren_ES_4008HS_Bicarbonat	\N	mmol/l	6	1	\N	\N	\N
103161	Nierenverfahren_ES_4008HS_Temperatur	\N	°C	6	1	\N	\N	\N
103162	Nierenverfahren_ES_4008HS_Fluss	\N	ml/min	6	1	\N	\N	\N
103163	Nierenverfahren_MS_4008HS_artDruck	\N	mmHg	6	1	\N	\N	\N
103164	Nierenverfahren_MS_4008HS_venDruck	\N	mmHg	6	1	\N	\N	\N
103165	Nierenverfahren_MS_4008HS_TMP	\N	mmHg	6	1	\N	\N	\N
103166	Nierenverfahren_MS_4008HS_Restzeit	\N	h:min	6	1	\N	\N	\N
103167	Nierenverfahren_MS_4008HS_SollNatrium	\N	mmol/l	6	1	\N	\N	\N
103168	Nierenverfahren_MS_4008HS_Leitfähigkeit	\N	mS/cm	6	1	\N	\N	\N
103169	Nierenverfahren_MS_4008HS_effBlutfluss	\N	ml/min	6	1	\N	\N	\N
103170	Nierenverfahren_MS_4008HS_BlutvolumenKum	\N	Liter	6	1	\N	\N	\N
103171	Nierenverfahren_MS_4008HS_ISOUFVolumenKum	\N	Liter	6	1	\N	\N	\N
103172	Nierenverfahren_Doku_Dialysekonzentrat	\N	\N	19	1	\N	\N	\N
103174	Nierenvwerfahren_ES_4008onl_Dialysezeit	\N	h:min	6	1	\N	\N	\N
103175	Nierenverfahren_ES_4008onl_UFZiel	\N	ml	6	1	\N	\N	\N
103176	Nierenverfahren_ES_4008onl_UFRate	\N	ml/h	6	1	\N	\N	\N
103177	Nierenverfahren_ES_4008onl_ISOUFZiel	\N	ml	6	1	\N	\N	\N
103178	Nierenverfahren_ES_4008onl_ISOUFZeit	\N	\N	6	1	\N	\N	\N
103179	Nierenverfahren_ES_4008onl_ISOUFRate	\N	ml/h	6	1	\N	\N	\N
103180	Nierenverfahren_ES_4008onl_Blutfluss	\N	ml/min	6	1	\N	\N	\N
103181	Nierenverfahren_ES_4008onl_BlutflussSNPumpe	\N	ml/min	6	1	\N	\N	\N
103182	Nierenverfahren_ES_4008onl_Substituat	\N	ml/h	6	1	\N	\N	\N
103183	Nierenverfahren_ES_4008onl_Substituatbolus	\N	ml/min	6	1	\N	\N	\N
103184	Nierenverfahren_ES_4008onl_Substituatrate	\N	ml/min	6	1	\N	\N	\N
103185	Nierenverfahren_ES_4008onl_UFProfil	\N	Zahl	6	1	\N	\N	\N
103186	Nierenverfahren_ES_4008onl_NaProfil	\N	Zahl	6	1	\N	\N	\N
103801	Patient_Pupillen_Links_v	\N	\N	2	103759	\N	\N	\N
103188	Nierenverfahren_ES_4008onl_StartNa	\N	mmol/l	6	1	\N	\N	\N
103189	Nierenverfahren_ES_4008onl_BasisNa	\N	mmol/l	6	1	\N	\N	\N
103190	Nierenverfahren_ES_4008onl_SollNa	\N	mmol/l	6	1	\N	\N	\N
103191	Nierenverfahren_ES_4008onl_Bicarbonat	\N	mmol/l	6	1	\N	\N	\N
103192	Nierenverfahren_ES_4008onl_Temperatur	\N	°C	6	1	\N	\N	\N
103193	Nierenverfahren_ES_4008onl_Fluss	\N	ml/min	6	1	\N	\N	\N
103194	Nierenverfahren_MS_4008onl_artDruck	\N	mmHg	6	1	\N	\N	\N
103195	Nierenverfahren_MS_4008onl_venDruck	\N	mmHg	6	1	\N	\N	\N
103196	Nierenverfahren_MS_4008onl_TMP	\N	\N	6	1	\N	\N	\N
103197	Nierenverfahren_MS_4008onl_Restzeit	\N	h:min	6	1	\N	\N	\N
103198	Nierenverfahren_MS_4008onl_SollNa	\N	mmol/l	6	1	\N	\N	\N
103199	Nierenverfahren_MS_4008onl_Leitfähigkeit	\N	mS/cm	6	1	\N	\N	\N
103200	Nierenverfahren_MS_4008onl_effBlutfluss	\N	ml/min	6	1	\N	\N	\N
103201	Nierenverfahren_MS_4008onl_BlutvolumenKumulativ	\N	Liter	6	1	\N	\N	\N
103202	Nierenverfahren_MS_4008onl_IsoUFVolumenKumulativ	\N	Liter	6	1	\N	\N	\N
103203	Nierenverfahren_MS_4008onl_SubtvolumenKumulativ	\N	Liter	6	1	\N	\N	\N
103204	Nierenverfahren_MS_4008onl_SubtbolusvolKumulativ	\N	Liter	6	1	\N	\N	\N
103205	Nierenverfahren_ES_4008onl_Dialysezeit	\N	h:min	6	1	\N	\N	\N
103206	Nierenverfahren_MS_UltrafiltratmengeKum	Kumulativer Entzug, bilanzrelevant	ml	6	1	\N	\N	\N
103209	Beatmung_ES_3100B_BiasFlow	Einstellwert: eingestellter Basisfluss im Beatmungssystem	l/min	6	1	\N	\N	\N
103210	Beatmung_ES_3100B_Frequenz	Einstellwert: eingestellte Oszillationsfrequenz 	Hz	6	1	\N	\N	\N
103211	Beatmung_ES_3100B_Inspirationszeit	Einstellwert: prozentualer Anteil der Inspirationszeit bezogen auf den gesamtem Atemzyklus	%	6	1	\N	\N	\N
103212	Beatmung_ES_3100B_Leistung	Einstellwert: prozentuale Kolbenauslenkung	%	6	1	\N	\N	\N
103213	Beatmung_ES_3100B_Mitteldruck	Einstellwert: eingestellter mittlerer Atemwegsdruck	cmH2O	6	1	\N	\N	\N
103214	Beatmung_ES_3100B_O2Konzentration	Einstellwert: O2 Konzentration des Gasgemisches	%	6	1	\N	\N	\N
103215	Beatmung_MS_3100B_Amplitude	Messwert: gemessene Druckamplitude	cmH2O	6	1	\N	\N	\N
103216	Beatmung_MS_3100B_O2Konzentration	Messwert: gemessene O2 Konzentration des Gasgemisches	%	6	1	\N	\N	\N
103218	Nierenverfahren_VO_4008onl_Dialysezeit	\N	h:min	6	1	\N	\N	\N
103219	Nierenverfahren_VO_4008onl_UFZiel	\N	ml	6	1	\N	\N	\N
103220	Nierenverfahren_VO_4008onl_Blutfluss	\N	ml/min	6	1	\N	\N	\N
103221	Nierenverfahren_VO_4008onl_UFProfil	\N	Zahl	6	1	\N	\N	\N
103222	Nierenverfahren_VO_4008onl_StartNatrium	\N	mmol/l	6	1	\N	\N	\N
103224	Nierenverfahren_VO_4008onl_Dialysekonzentrat	Dialysekonzentrat 6 liter gesamt	\N	3	1	\N	\N	\N
103226	Nierenverfahren_VO_4008onl_SollNatrium	\N	mmol/l	6	1	\N	\N	\N
103227	Nierenverfahren_VO_4008onl_Bicarbonat	\N	mmol/l	6	1	\N	\N	\N
103228	Nierenverfahren_VO_4008onl_NatriumProfil	\N	Zahl	6	1	\N	\N	\N
103229	Nierenverfahren_VO_4008onl_Temperatur	\N	°C	6	1	\N	\N	\N
103230	Nierenverfahren_VO_4008onl_Fluss	\N	ml/min	6	1	\N	\N	\N
103231	Nierenverfahren_VO_4008onl_Substituat	\N	ml/h	6	1	\N	\N	\N
103232	Nierenverfahren_VO_4008onl_Substituatbolus	\N	ml	6	1	\N	\N	\N
103233	Nierenverfahren_VO_4008onl_ISOUFZiel	\N	ml	6	1	\N	\N	\N
103234	Nierenverfahren_VO_4008onl_ISOUFZeit	\N	h:min	6	1	\N	\N	\N
103235	Nierenverfahren_VO_4008onl_BlutflussSNPumpe	\N	ml/min	6	1	\N	\N	\N
103237	Nierenverfahren_VO_4008HS_UFZiel	\N	ml	6	1	\N	\N	\N
103238	Nierenverfahren_VO_4008HS_BlutflussMax	\N	ml/min	6	1	\N	\N	\N
103239	Nierenverfahren_VO_4008HS_UFProfil	\N	Zahl	6	1	\N	\N	\N
103240	Nierenverfahren_VO_4008HS_NaProfil	\N	Zahl	6	1	\N	\N	\N
103241	Patient_Nierenverfahren_VO_4008HS_StartNatrium	\N	mmol/l	6	1	\N	\N	\N
103242	Nierenverfahren_VO_4008HS_SollNatrium	\N	mmol/l	6	1	\N	\N	\N
103243	Nierenverfahren_VO_4008HS_Bicarbonat	\N	mmol/l	6	1	\N	\N	\N
103244	Nierenverfahren_VO_4008HS_Temperatur	\N	°C	6	1	\N	\N	\N
103245	Nierenverfahren_VO_4008HS_Fluss	\N	ml/min	6	1	\N	\N	\N
103246	Nierenverfahren_VO_4008HS_BlutflussSNPumpe	\N	ml/min	6	1	\N	\N	\N
103247	Nierenverfahren_VO_4008HS_ISOUFZiel	\N	ml	6	1	\N	\N	\N
103248	Nierenverfahren_VO_4008HS_ISOUFZeit	\N	h:min	6	1	\N	\N	\N
103250	Nierenverfahren_VO_Dialysekonzentrat	Dialyskonzentratbehälter	\N	3	1	\N	\N	\N
103253	Nierenverfahren_VO_4008HS_StartNatrium	\N	mmol/l	6	1	\N	\N	\N
103254	Nierenverfahren_VO_4008HS_Dialysezeit	\N	h:min	6	1	\N	\N	\N
103255	Beatmung_ES_VisionA_Vt	Einstellwert: eingestelltes Tidalvolumen	ml	6	1	\N	\N	\N
103256	Beatmung_ES_VisionA_Peakflow	Einstellwert: eingestellter Spitzenfluss	l/min	6	1	\N	\N	\N
103257	Beatmung_ES_VisionA_Frequenz	Einstellwert: eingestellte Atemfrequenz	f/min	6	1	\N	\N	\N
103258	Beatmung_ES_VisionA_ApneaRate	Einstellwert: eingestellte Apnoefrequenz	f/min	6	1	\N	\N	\N
103259	Beatmung_ES_VisionA_Plateau	Einstellwert: Plateauphase in Sekunden	sec.	6	1	\N	\N	\N
103260	Beatmung_ES_VisionA_Ti	Einstellwert: Inspirationszeit in Sekunden	sec.	6	1	\N	\N	\N
103802	Patient_Pupillen_Links_p	\N	\N	2	103759	\N	\N	\N
103261	Beatmung_ES_VisionA_DeltaP	Einstellwert: eingestellte Druckdifferenz	cm H2O	6	1	\N	\N	\N
103262	Beatmung_MS_VisionA_Plateau	Messwert: gemessener Plateaudruck	cm H2O	6	1	\N	\N	\N
103264	Beatmung_MS_VisionA_AMVtotal	Messwert: gemessenes Atemminutenvolumen	L	6	1	\N	\N	\N
103265	Beatmung_MS_VisionA_BreathRate	Messwert: gemessene Atemfrequenz	AZ/min	6	1	\N	\N	\N
103266	Beatmung_MS_VisionA_IEVerhaeltnis	Messwert: gemessenes I:E Verhältnis	\N	3	1	\N	\N	\N
103267	Beatmung_ES_Evita2_O2Konzentration	eingestellte O2 Konzentration des Gases	Vol %	6	1	\N	\N	\N
103268	Beatmung_ES_Evita2_InspFlow	eingestellter Inspirationfluss	L/min	6	1	\N	\N	\N
103269	Beatmung_ES_Evita2_Frequenz	eingestellt mandatorische Atemfrquenz	bpm	6	1	\N	\N	\N
103270	Beatmung_ES_Evita2_VerhaeltnisTiTe	eingestelltes Verhältnis zwischen Inspiration und Exspiration	I:E	3	1	\N	\N	\N
103339	IABP_Doku_Ballonkatheter	Kathetertyp	\N	3	1	\N	\N	\N
103271	Beatmung_ES_Evita2_Anstiegszeit	eingestellte Zeit für den Anstieg zwischen unterem und oberen Druckniveau	s	6	1	\N	\N	\N
103272	Beatmung_ES_Evita2_Vt	eingestelltes Tidalvolumen	L	6	1	\N	\N	\N
103273	Beatmung_ES_Evita2_Pmax	eingestellte Druckbegrenzung	mbar	6	1	\N	\N	\N
103274	Beatmung_ES_Evita2_Frequenzimv	einstellte IMV Frequenz im SIMV Modus	bpm	6	1	\N	\N	\N
103275	Beatmung_ES_Evita2_PEEP	eingestelltes PEEP Niveau	mbar	6	1	\N	\N	\N
103276	Beatmung_ES_Evita2_CPAP	eingestelltes CPAP Niveau	mbar	6	1	\N	\N	\N
103277	Beatmung_ES_Evita2_ASB	eingestellte Druckunterstüzung	mbar	6	1	\N	\N	\N
103278	Beatmung_ES_Evita2_Pinsp	eingestelltes oberes Druckniveau	mbar	6	1	\N	\N	\N
103279	Beatmung_ES_Evita2_Flowtrigger	eingestellte Triggerschwelle (Flowtrigger)	L/min	6	1	\N	\N	\N
103280	Beatmung_MS_Evita2_AMV	gemessenes Atemminutenvolumen	L/min	6	1	\N	\N	\N
103281	Beatmung_MS_Evita2_O2Konzentration	gemessene O2 Konzentration im Inspirationsgas	Vol %	6	1	\N	\N	\N
103282	Beatmung_MS_Evita2_Pmax	gemessener Beatmungsspitzendruck	mbar	6	1	\N	\N	\N
103283	Beatmung_MS_Evita2_Pplat	gemessener Plateaudruck (inspiratorischer Beatmungsdruck)	mbar	6	1	\N	\N	\N
103284	Beatmung_MS_Evita2_Ppeep	gemessener positer endexspiratorischer Druck	mbar	6	1	\N	\N	\N
103285	Beatmung_MS_Evita2_Pmittel	gemessener Beatmungsmitteldruck	mbar	6	1	\N	\N	\N
103286	Beatmung_MS_Evita2_Vte	gemessenes exspiratorisches Tidalvolumen	L	6	1	\N	\N	\N
103287	Beatmung_MS_Evita2_frequenz	gemessene Atemfrequenz	bpm	6	1	\N	\N	\N
103288	Beatmung_MS_Evita2_Resistance	gemessener Atemwegswiderstand	mbar/l/s	6	1	\N	\N	\N
103289	Beatmung_MS_Evita2_Compliance	gemessene Lungencompliance	ml/mbar	6	1	\N	\N	\N
103290	Beatmung_MS_Evita2_MVspon	gemessenes spontanes Atemminutenvolumen	L/min	6	1	\N	\N	\N
103291	Beatmung_MS_Evita2_frequenzspon	gemessene spontane Atemfrequenz	bpm	6	1	\N	\N	\N
103292	Beatmung_MS_Evita2_CPAP	gemessenes CPAP Niveau	mbar	6	1	\N	\N	\N
103293	Beatmung_MS_Evita2_Pmin	kleinster gemessener Beatmungsdruck während des Atemzyklus 	mbar	6	1	\N	\N	\N
103294	Beatmung_MS_Evita2_IntrinsicPEEP	Ergebnis eines Messmanövers im Modus IPPV, IPPV assist	mbar	6	1	\N	\N	\N
103295	Beatmung_MS_Evita2_OkklusionsdruckP01	Messergebnis eines Messmanövers im ASB Spontan Modus 	mbar	6	1	\N	\N	\N
103296	Beatmung_ES_Evita4_O2Konzentration	eingestellte O2 Konzentration des Frischgases	%	6	1	\N	\N	\N
103297	Beatmung_ES_Evita4_Tinsp	eingestellte absolute Inspirationszeit	s	6	1	\N	\N	\N
103298	Beatmung_ES_Evita4_frequenz	eingestellte Atemfrequenz	bpm	6	1	\N	\N	\N
103299	Beatmung_ES_Evita4_Rampe	eingestellte Anstiegszeit vom unteren zum oberen Druckniveau	s	6	1	\N	\N	\N
103300	Beatmung_ES_Evita4_Pinsp	eingestelltes oberes Druckniveau	mbar	6	1	\N	\N	\N
103301	Beatmung_ES_Evita4_PEEP	eingestelltes PEEP Niveau	mbar	6	1	\N	\N	\N
103302	Beatmung_ES_Evita4_ASB	eingestellte Druckunterstützung	mbar	6	1	\N	\N	\N
103303	Beatmung_ES_Evita4_Flowtrigger	Einstellgröße des Flowtriggers	L/min	6	1	\N	\N	\N
103304	Beatmung_ES_Evita4_Vt	Einstellgröße für das Tidalvolumen	L	6	1	\N	\N	\N
103305	Beatmung_ES_Evita4_VtApnoe	Einstellgröße für das Tidalvolumen in der Apnoeeinstellung	L	6	1	\N	\N	\N
103306	Beatmung_ES_Evita4_fApnoe	eingestellte Atemfrequenz in der Apnoeventilation	bpm	6	1	\N	\N	\N
103307	Beatmung_ES_Evita4_Tubuskompensation	Einstellgröße für die Tubuskompensation	%	6	1	\N	\N	\N
103308	Beatmung_ES_Evita4_FlowAssist	Einstellgröße für den Flowassist im Modus PPS	mbar*s/l	6	1	\N	\N	\N
103309	Beatmung_ES_Evita4_VolAssist	Einstellgröße für den VolAssist im PPS Modus	mbar/L	6	1	\N	\N	\N
103400	Schrittmacher_Defi_ES_Empfindlichkeit	\N	mV	6	1	\N	\N	\N
103310	Beatmung_ES_Evita4_Thoch	Zeiteinstellung für das obere Druckniveau im APRV Modus	s	6	1	\N	\N	\N
103311	Beatmung_ES_Evita4_Ttief	Zeiteinstellung für das untere Druckniveau im APRV Modus	s	6	1	\N	\N	\N
103312	Beatmung_ES_Evita4_Phoch	Druckeinstellung für das obere Druckniveau im APRV Modus	mbar	6	1	\N	\N	\N
103313	Beatmung_ES_Evita4_Ptief	Druckeinstellung für das untere Druckniveau im APRV Modus	mbar	6	1	\N	\N	\N
103314	Beatmung_MS_Evita4_FiO2	gemessene O2 Konzentration des inspiratorischen Atemgasgemisches	Vol%	6	1	\N	\N	\N
103315	Beatmung_MS_Evita4_Ppeak	gemessener Atemwegsspitzendruck	mbar	6	1	\N	\N	\N
103316	Beatmung_MS_Evita4_Pplat	gemessener Plataeudruck wähend der Inspiration	mbar	6	1	\N	\N	\N
103317	Beatmung_MS_Evita4_Pmean	gemessener Atemwegsmitteldruck	mbar	6	1	\N	\N	\N
103318	Beatmung_MS_Evita4_PEEP	gemessener positiver endexspiratorischer Druck	mbar	6	1	\N	\N	\N
103319	Beatmung_MS_Evita4_Pmin	gemessener minimaler Atemwegsdruck während des Atemzyklus	mbar	6	1	\N	\N	\N
103320	Beatmung_MS_Evita4_MV	gemessenes Atemminutenvolumen	L/min	6	1	\N	\N	\N
103321	Beatmung_MS_Evita4_MVspn	gemessenes spontanes Atemminutenvolumen	L/min	6	1	\N	\N	\N
103322	Beatmung_MS_Evita4_Mvleck	gemessenes Leckagevolumen pro Minute	L/min	6	1	\N	\N	\N
103323	Beatmung_MS_Evita4_frequenz	gemessene Gesamtatemfrequenz	bpm	6	1	\N	\N	\N
103324	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz	bpm	6	1	\N	\N	\N
103325	Beatmung_MS_Evita4_fmand	gemessene mandatorische Atemfrequenz	bpm	6	1	\N	\N	\N
103326	Beatmung_MS_Evita4_Vte	gemessenes exspiratorisches Tidalvolumen	L	6	1	\N	\N	\N
103327	Beatmung_MS_Evita4_Vt	gemessenes inspiratorisches Tidalvolumen	L	6	1	\N	\N	\N
103328	Beatmung_MS_Evita4_Resistance	gemessener Atemwegswiderstand	mbar/l/s	6	1	\N	\N	\N
103329	Beatmung_MS_Evita4_Compliance	gemessene Lungencompliance	ml/mbar	6	1	\N	\N	\N
103330	Beatmung_MS_Evita4_PEEPi	gemessener Intrinsic Peep nach Meßmanöver	mbar	6	1	\N	\N	\N
104130	Behandlung_DIVI_ObduktionDurchgef	\N	\N	2	30	\N	\N	\N
103331	Beatmung_MS_Evita4_Vtrap	gemessenes getrapptes Luftvolumen nach Meßmanöver	L	6	1	\N	\N	\N
103332	Beatmung_MS_Evita4_P01	gemessener P0.1 Druck nach Meßmanöver	mbar	6	1	\N	\N	\N
103333	Beatmung_ES_G5_Vt	Einstellwert: Tidalvolumen	ml	6	1	\N	\N	\N
103334	Beatmung_ES_G5_Pmax	Hochdruckalarmgrenze im 'ASV Modus	mbar	6	1	\N	\N	\N
103335	Nierenverfahren_VO_ZielKalium	\N	mmol	6	1	\N	\N	\N
103336	Nierenverfahren_ES_GeräteDesinfektion	Desinfektionsprogramme Gerät 	\N	3	1	\N	\N	\N
103338	Nierenverfahren_MS_BM25_AbnahmeKumulativ	\N	Liter	6	1	\N	\N	\N
103341	IABP_ACAT_ES_Triggerauswahl	Listenauswahl	\N	3	1	\N	\N	\N
103343	IABP_ACAT_ES_Unterstützungsdruck	\N	mmHg	6	1	\N	\N	\N
103344	IABP_ACAT_ES_EKGAbleitung	Listenanhang	\N	3	1	\N	\N	\N
103347	IABP_ACAT_ES_Inflation	\N	%	6	1	\N	\N	\N
103348	IABP_ACAT_ES_Deflation	\N	\N	6	1	\N	\N	\N
103349	IABP_AutoCat_ES_Modus	Liste	\N	3	1	\N	\N	\N
103350	IABP_AutoCat_ES_Triggerauswahl	Liste	\N	3	1	\N	\N	\N
103352	IABP_AutoCat_ES_Unterstützungsdruck	\N	mmHg	6	1	\N	\N	\N
103353	IABP_AutoCat_ES_EKGAbleitung	Liste	\N	3	1	\N	\N	\N
103356	IABP_AutoCat_ES_Arrhythmietiming	Liste	\N	3	1	\N	\N	\N
103357	IABP_AutoCat_ES_Inflation	\N	%	6	1	\N	\N	\N
103358	IABP_AutoCat_ES_Deflation	\N	%	6	1	\N	\N	\N
103359	IABP_Datascope_ES_Triggerauswahl	Liste	\N	3	1	\N	\N	\N
103361	IABP_Datascope_ES_Unterstützungsdruck	\N	mmHg	6	1	\N	\N	\N
103365	IABP_Datascope_ES_IABPAufblasen	\N	%	6	1	\N	\N	\N
103366	IABP_Datascope_ES_IABPLeersaugen	\N	%	6	1	\N	\N	\N
103367	IABP_Datascope_ES_EKGAbleitung	Liste	\N	3	1	\N	\N	\N
103368	IABP_ACAT_MS_SystoleDiastole	\N	mmHg	12	1	\N	\N	\N
103369	IABP_ACAT_MS_Mitteldruck	\N	mmHg	12	1	\N	\N	\N
103370	IABP_AutoCat_MS_SystoleDiastole	\N	mmHg	12	1	\N	\N	\N
103371	IABP_AutoCat_MS_Mitteldruck	\N	mmHg	12	1	\N	\N	\N
103372	IABP_Datascope_MS_SystoleDiastole	\N	mmHg	12	1	\N	\N	\N
103373	IABP_Datascope_MS_Mitteldruck	\N	mmHg	12	1	\N	\N	\N
103374	Schrittmacher_Doku_Modus	\N	\N	3	1	\N	\N	\N
103375	Schrittmacher_Doku_Art	\N	\N	3	1	\N	\N	\N
103376	Schrittmacher_Doku_Drähte	\N	\N	3	1	\N	\N	\N
103380	Schrittmacher_Eins_ES_RAPFrequenz	Medtronic 5348	1/min	6	1	\N	\N	\N
103381	Schrittmacher_Eins_ES_Frequenz	Medtronic 5348	1/min	6	1	\N	\N	\N
103382	Schrittmacher_Eins_ES_Ausgang	Medtronic 5348	mA	6	1	\N	\N	\N
103383	Schrittmacher_Eins_ES_Empfindlichkeit	Medtronic 5348	mV	6	1	\N	\N	\N
103386	Schrittmacher_zwei_ES_Frequenz	Medtronic 5375	1/min	6	1	\N	\N	\N
103387	Schrittmacher_zwei_ES_Ausgang	Medtronic 5375	mA	6	1	\N	\N	\N
103388	Schrittmacher_zwei_ES_Empfindlichkeit	Medtronic 5375	mV	6	1	\N	\N	\N
103389	Schrittmacher_drei_ES_Basisfrequenz	Medtronic 5388	1/min	6	1	\N	\N	\N
103390	Schrittmacher_drei_ES_FrequenzMax	Medtronic 5388	1/min	6	1	\N	\N	\N
103391	Schrittmacher_drei_ES_AusgangA	Medtronic 5388	mA	6	1	\N	\N	\N
103392	Schrittmacher_drei_ES_AusgangV	Medtronic 5388	mA	6	1	\N	\N	\N
103393	Schrittmacher_drei_ES_EmpfindlichkeitA	Medtronic 5388	mV	6	1	\N	\N	\N
103394	Schrittmacher_drei_ES_EmpfindlichkeitV	Medtronic 5388	mV	6	1	\N	\N	\N
103395	Schrittmacher_drei_ES_VentrikelintervallAV	Medtronic 5388	ms	6	1	\N	\N	\N
103396	Schrittmacher_drei_ES_ÜberstimulationsFreq	\N	1/min	6	1	\N	\N	\N
103397	Schrittmacher_Siemens_ES_Frequenz	\N	1/min	6	1	\N	\N	\N
103398	Schrittmacher_Siemens_ES_Empfindlichkeit	\N	mV	6	1	\N	\N	\N
103399	Schrittmacher_Defi_ES_Frequenz	\N	1/min	6	1	\N	\N	\N
103401	Schrittmacher_Siemens_ES_Ausgang	\N	mA	6	1	\N	\N	\N
103402	Schrittmacher_Defi_ES_Ausgang	\N	mA	6	1	\N	\N	\N
103403	Beatmung_ES_G5_Drucktrigger	Inspiratorische Bemühung des Patienten, die das Beatmungsgerät veranlasst, einen Atemhub abzugeben	mbar	6	1	\N	\N	\N
103404	Beatmung_ES_G5_Flowtrigger	Die inspiratorische Bemühung des Patienten ( Flow),  die das Beatmungsgerät veranlässt, einen Atemhub abzugeben	L/min	6	1	\N	\N	\N
103406	IABP_Geraet_Doku	\N	\N	26	1	\N	\N	\N
103407	Beatmung_ES_Avea_Frequenz	eingestellte mandatorische AF	bpm	6	1	\N	\N	\N
103408	Beatmung_ES_Avea_Volumen	eingestelltes Tidalvolumen	L	6	1	\N	\N	\N
103409	Beatmung_ES_Avea_PeakFlow	eingestellter Spitzengasfluss	L/min	6	1	\N	\N	\N
103410	Beatmung_ES_Avea_InspPause	Zeiteinstellung für die Plateauphase im Modus CMV und SIMV	sek.	6	1	\N	\N	\N
103411	Beatmung_ES_Avea_PEEP	eingestelltes PEEP Niveau	cmH2O	6	1	\N	\N	\N
103412	Beatmung_ES_Avea_FlowTrigger	eingestellter Flowtrigger: Schwellenwertt für die inspiratorische Bemühung des Patienten um die Druckunterstützung auszulösen	L/min	6	1	\N	\N	\N
103413	Beatmung_ES_Avea_FiO2	eingestellte Sauerstoffkonzentration des inspiratorischen Atemgases	%	6	1	\N	\N	\N
103414	Beatmung_ES_Avea_InspDruck	eingestelltes oberes Druckniveau im Modus P-CMV und P-SIMV	cmH2O	6	1	\N	\N	\N
103415	Beatmung_ES_Avea_InspZeit	eingestellte Inspirationszeit eines Atemzuges	sek.	6	1	\N	\N	\N
103416	Beatmung_ES_Avea_PSV	eingestellte Druckunterstützung bei dem Gerät Avea	cmH2O	6	1	\N	\N	\N
103417	Beatmung_ES_Avea_ZeitHoch	Zeiteinstellung des oberen Druckniveaus im Modus APRV / BiPhasisch	sek.	6	1	\N	\N	\N
103418	Beatmung_ES_Avea_ZeitNiedrig	Zeiteinstellung für das untere Druckniveau im Modus APRV / BiPhasisch	sek.	6	1	\N	\N	\N
103419	Beatmung_ES_Avea_DruckHoch	eingestelltes oberes Druckniveau im Modus APRV / BiPhasisch	cmH2O	6	1	\N	\N	\N
103420	Beatmung_ES_Avea_DruckNiedrig	eingestelltes unteres Druckniveau im Modus APRV / BiPhasisch	cmH2O	6	1	\N	\N	\N
103421	Beatmung_MS_Avea_Vte	gemessenes Tidalvolumen	L	6	1	\N	\N	\N
103422	Beatmung_MS_Avea_PIP	gemessener Atemwegsspitzendruck	cmH2O	6	1	\N	\N	\N
103423	Beatmung_MS_Avea_Ve	gemessenes exspiratorisches Volumen	L	6	1	\N	\N	\N
103424	Beatmung_MS_Avea_Ti	gemessene Inspirationszeit	sek.	6	1	\N	\N	\N
103425	Beatmung_MS_Avea_PEEP	gemessenes PEEP Niveau	cmH2O	6	1	\N	\N	\N
103426	Beatmung_MS_Avea_IE	gemessenes I zu E Verhältnis	Verhältnis	3	1	\N	\N	\N
103427	Beatmung_MS_Avea_Te	gemessene Exspirationszeit	sek.	6	1	\N	\N	\N
103428	Beatmung_MS_Avea_fVt	errechneter Quotient zwischen Frequenz und Tidalvolumen	Quotient	6	1	\N	\N	\N
103429	Beatmung_MS_Avea_Mitteldruck	gemessener Atemwegsmitteldruck	cm H2O	6	1	\N	\N	\N
103430	Beatmung_MS_Avea_Frequenz	gemessene Atemfrequenz	bpm	6	1	\N	\N	\N
103431	Beatmung_MS_Avea_MandVte	gemessenes mandatorisches Tidalvolumen	L	6	1	\N	\N	\N
103432	Beatmung_MS_Avea_SpontVte	gemessenes spontanes Tidalvolumen	L	6	1	\N	\N	\N
103433	Beatmung_MS_Avea_Vti	gemessenes inspiratorisches Tidalvolumen	L	6	1	\N	\N	\N
103434	Beatmung_MS_Avea_SpontVe	gemessenes spontanes Atemminutenvolumen	L	6	1	\N	\N	\N
103435	Beatmung_MS_Avea_SpontAF	gemessene spontane Atemfrequenz	bpm	6	1	\N	\N	\N
103436	Beatmung_MS_Avea_MandAF	gemessene mandatorische Atemfrequenz	bpm	6	1	\N	\N	\N
103438	Beatmung_MS_Avea_Pplat	gemessener Plateaudruck	cmH2O	6	1	\N	\N	\N
103439	Beatmung_MS_Avea_FiO2	gemessene Sauerstoffkonzentration im Atemgas	%	6	1	\N	\N	\N
103440	Beatmung_MS_Avea_Cstat	gemessene statische Compliance	ml/cmH2O	6	1	\N	\N	\N
103441	Beatmung_MS_Avea_WOBp	\N	\N	6	1	\N	\N	\N
103442	Beatmung_MS_Avea_WOBi	\N	\N	6	1	\N	\N	\N
103443	Beatmung_MS_Avea_AutoPEEP	gemessener AutoPEEP	cmH2O	6	1	\N	\N	\N
103444	Score_DGAI_AufnArzt	\N	\N	3	1	\N	\N	\N
103458	Score_DGAI_AufnBeatmungsstundenbiszurAufnahme	\N	\N	6	1	\N	\N	\N
103462	Score_DGAI_EntlDatum	\N	\N	5	1	\N	\N	\N
103463	Score_DGAI_EntlZeit	\N	\N	5	1	\N	\N	\N
103464	Score_DGAI_EntlArzt	\N	\N	3	1	\N	\N	\N
104078	SAPS2_Natrium_Aufnahme	\N	\N	27	104068	\N	\N	\N
103492	Score_DGAI_EntlPostVisiteDatum	\N	\N	5	1	\N	\N	\N
103504	Score_DGAI_AufnChronischeAIDS	\N	\N	2	1	\N	\N	\N
103506	Score_DGAI_AufnChronischeHaematologischeNeoplasie	\N	\N	2	1	\N	\N	\N
103507	Score_DGAI_AufnChronischeMetastasierenNeoplasie	\N	\N	2	1	\N	\N	\N
103508	Score_DGAI_AufnIndikationBeatmungsfall	\N	\N	2	1	\N	\N	\N
103509	Score_DGAI_AufnIndikationIntensivBehandlung	\N	\N	2	1	\N	\N	\N
103510	Score_DGAI_AufnIndikationIntensivUeberwachung	\N	\N	2	1	\N	\N	\N
103511	Score_DGAI_AufnIndikationSchwerstkrankerPatient	\N	\N	2	1	\N	\N	\N
103512	Score_DGAI_AufnVonIntensivstationWachstation	\N	\N	2	1	\N	\N	\N
103513	Score_DGAI_AufnNachOperation	\N	\N	2	1	\N	\N	\N
103514	Score_DGAI_AufnTraumaPolytrauma	\N	\N	2	1	\N	\N	\N
103515	Score_DGAI_AufnVonExterneKlinik	\N	\N	2	1	\N	\N	\N
103516	Score_DGAI_AufnVonNotaufnahmeNAW	\N	\N	2	1	\N	\N	\N
103517	Score_DGAI_AufnVonOPAWR	\N	\N	2	1	\N	\N	\N
103518	Score_DGAI_AufnVonPeriphererStation	\N	\N	2	1	\N	\N	\N
103519	Score_DGAI_AufnWiederaufnahmeGroesser48h	\N	\N	2	1	\N	\N	\N
103520	Score_DGAI_AufnWiederaufnahmeKleiner48h	\N	\N	2	1	\N	\N	\N
103521	Score_DGAI_EntlInfoANV	\N	\N	2	1	\N	\N	\N
103522	Score_DGAI_EntlInfoARDSALI	\N	\N	2	1	\N	\N	\N
103523	Score_DGAI_EntlInfoBarthelIndexErhoben	\N	\N	2	1	\N	\N	\N
103524	Score_DGAI_EntlInfoECMOILA	\N	\N	2	1	\N	\N	\N
103525	Score_DGAI_EntlInfoESBL	\N	\N	2	1	\N	\N	\N
103527	Score_DGAI_EntlInfoMaximaleTherapieAufStation	\N	\N	2	1	\N	\N	\N
103528	Score_DGAI_EntlInfoMODMOV	\N	\N	2	1	\N	\N	\N
103529	Score_DGAI_EntlInfoMRSA	\N	\N	2	1	\N	\N	\N
103530	Score_DGAI_EntlInfoNET	\N	\N	2	1	\N	\N	\N
103531	Score_DGAI_EntlInfoObduktionDurchgefuehrt	\N	\N	2	1	\N	\N	\N
103532	Score_DGAI_EntlInfoPolytrauma	\N	\N	2	1	\N	\N	\N
103533	Score_DGAI_EntlInfoSepsis	\N	\N	2	1	\N	\N	\N
103534	Score_DGAI_EntlInfoTherapieMinima	\N	\N	2	1	\N	\N	\N
103535	Score_DGAI_EntlInfoVRE	\N	\N	2	1	\N	\N	\N
103536	Score_DGAI_EntlNachAndereIntensivstation	\N	\N	2	1	\N	\N	\N
103537	Score_DGAI_EntlNachExterneNormalklinik	\N	\N	2	1	\N	\N	\N
103538	Score_DGAI_EntlNachExterneSpezialklinik	\N	\N	2	1	\N	\N	\N
103539	Score_DGAI_EntlNachHause	\N	\N	2	1	\N	\N	\N
103540	Score_DGAI_EntlNachKeineVerlegungExitus	\N	\N	2	1	\N	\N	\N
103541	Score_DGAI_EntlNachNormalstation	\N	\N	2	1	\N	\N	\N
103542	Score_DGAI_EntlNachWachstation	\N	\N	2	1	\N	\N	\N
103543	Score_DGAI_EntlPostVisiteBeeintraechtigungDauerhaf	\N	\N	2	1	\N	\N	\N
103544	Score_DGAI_EntlPostVisiteBeeintraechtigungPassager	\N	\N	2	1	\N	\N	\N
103545	Score_DGAI_EntlPostVisiteExitusImKrankenhaus	\N	\N	2	1	\N	\N	\N
103546	Score_DGAI_EntlPostVisiteKeineDurchgefuehrt	\N	\N	2	1	\N	\N	\N
103547	Score_DGAI_EntlPostVisiteRestitutioAdIntegrum	\N	\N	2	1	\N	\N	\N
103548	Score_DGAI_EntlZustandExitus	\N	\N	2	1	\N	\N	\N
103549	Score_DGAI_EntlZustandGeringBeeintraechtigungDauer	\N	\N	2	1	\N	\N	\N
103550	Score_DGAI_EntlZustandGeringBeeintraechtigungPassa	\N	\N	2	1	\N	\N	\N
103551	Score_DGAI_EntlZustandRestitutioAdIntegrum	\N	\N	2	1	\N	\N	\N
103552	Score_DGAI_EntlZustandUeberlebenErheblicherDefekt	\N	\N	2	1	\N	\N	\N
103553	Score_DGAI_AufnGeplantChirurgisch	\N	\N	2	1	\N	\N	\N
103554	Score_DGAI_AufnUngeplantChirurgisch	\N	\N	2	1	\N	\N	\N
103555	Score_DGAI_AufnMedizinisch	\N	\N	2	1	\N	\N	\N
103556	Score_DGAI_AufnASA1	\N	\N	2	1	\N	\N	\N
104993	NEV_CRRT_Doku_Balken	\N	\N	26	1	\N	\N	\N
103557	Score_DGAI_AufnASA2	\N	\N	2	1	\N	\N	\N
103558	Score_DGAI_AufnASA3	\N	\N	2	1	\N	\N	\N
103559	Score_DGAI_AufnASA4	\N	\N	2	1	\N	\N	\N
103560	Score_DGAI_AufnASA5	\N	\N	2	1	\N	\N	\N
103561	Score_DGAI_AufnBeatmet	\N	\N	2	1	\N	\N	\N
103562	Score_DGAI_EntlPostVisiteUeberlebenErheblicherDefe	\N	\N	2	1	\N	\N	\N
103563	PCWP	\N	mmHg	6	1	\N	\N	\N
103564	Schrittmacher_Doku_Reizschwelle	\N	V	6	1	\N	\N	\N
103565	Schrittmacher_Doku_Wahrnehmung	\N	mV	6	1	\N	\N	\N
103567	IABPneu_Datascope_ES_IABPFrequenz	\N	\N	3	1	\N	\N	\N
103568	IABP_ACAT_ES_Unterstuetzungsverhaeltnis	Liste	\N	3	1	\N	\N	\N
103571	IABP_AutoCat_ES_Unterstützungsverhältnis	Liste	\N	3	1	\N	\N	\N
103572	IABP_Datascope_ES_IABPFrequenz	LIste	\N	3	1	\N	\N	\N
103573	IABP_Abiomed_Impella_Spuelloesung	Liste	\N	3	1	\N	\N	\N
103574	IABP_Abiomed_Impella_Zugang	Liste	\N	3	1	\N	\N	\N
103575	IABP_Abiomed_Impella_PurgeFR	\N	ml/h	6	1	\N	\N	\N
103576	IABP_Abiomed_Impella_Flow	Liste	l/min	6	1	\N	\N	\N
103577	IABP_Abiomed_Impella_Leistungsstufe	Liste	\N	3	1	\N	\N	\N
103578	IABP_Abiomed_Impella_LVDruck	\N	mmHg	12	1	\N	\N	\N
103580	IstPflege_Datum	\N	\N	5	30	\N	\N	\N
103582	IstPflege_Aufnehmender	\N	\N	3	30	\N	\N	\N
103653	Braden_ReibungUScherkraefte_Aufnahme	\N	\N	27	103648	\N	\N	\N
103585	Drainagen_SekretmlKum	Drainagen_SekretmlKum: Drainagen-Sekret Kumulativ zur Dokumentation, nicht bilanzrelevant	ml	6	100157	\N	\N	\N
103586	Lungenersatzverfahren_MS_ECMO_ACT	\N	sek	6	1	\N	\N	\N
103587	Lungenersatzverfahren_VO_Zugang	Gefäßdefinition	\N	3	1	\N	\N	\N
103588	Lungenersatzverfahren_Kathetertyp	Katheterart	\N	3	1	\N	\N	\N
103589	Lungenersatzverfahren_ECMO_Oxygenator	Bezeichnung	\N	3	1	\N	\N	\N
103590	Lungenersatzverfahren_Schlauchsystem	Bezeichnung	\N	3	1	\N	\N	\N
103591	Patient_Allergie	\N	\N	1	1	\N	\N	\N
103594	Patient_Allerige_Datum	Patient Allergie - Datum	\N	5	103591	\N	\N	\N
103595	Patient_Besonderheit	\N	\N	1	1	\N	\N	\N
103597	Patient_Besonderheit_Datum	Patient Besonderheit Datum	\N	5	103595	\N	\N	\N
103598	Patient_Infektion	\N	\N	1	1	\N	\N	\N
103599	Patient_Infektion_Ende	\N	\N	5	103598	\N	\N	\N
103600	Patient_Infektion_Beginn	\N	\N	5	103598	\N	\N	\N
103602	Zugaenge_Markierung	Dokumentation der Markierung des Katheters bzgl. der Lage bzw. Tiefe	cm	6	100131	\N	\N	\N
103604	Atemwege_Markierung_AufnahmeAlt	Dokumentation der Markierung des Atemwegszugang bzgl. der Tiefe bezogen auf die Anlagedokumentation	cm	6	100132	\N	\N	\N
105047	Sicherheit_Geraeteueberpruef_DialyseHFgeraet	Dokumentationsmöglichkeit für den Qualitätscheck (Kontrollle der eingestellten Verfahrensparameter) des Dialyse- bzw. Hämofiltrationsgerät.	\N	3	100480	\N	\N	Pflegedoku - Qualitätschecks (Dialyse- / HFgerät)
106485	Hausarzt_Vorname	\N	\N	3	1	\N	\N	\N
103607	Enteralesonden_Markierung_AufnahmeAlt	Dokumentation der Markierung der enteralen Sonde	cm	6	100133	\N	\N	\N
103610	Wunddokumentation_VACPumpe	Gerät zur Sekretmobilisation	\N	3	100193	\N	\N	\N
103613	Wunddokumentation_Tiefe_Aufnahme_alt	Wunddokumentation der Tiefe bei Aufnahme oder erstem AUftreten	cm	6	100189	\N	\N	\N
103615	Wunddokumentation_Groeße_Aufnahme	\N	cm x cm	3	100189	\N	\N	\N
103616	Dekubitus_Größe_Aufnahme	Dekubitusgröße bei Aufnahme	cm	3	100182	\N	\N	\N
103617	Dekubitus_Tiefe_Aufnahme_alt	Decubitustiefe bei Aufnahme	cm	6	100182	\N	\N	\N
103618	Dekubitus_Beobachtung_Aufnahme_alt	Beobachtungsbeschreibung mit Liste hinterlegt	\N	6	100182	\N	\N	\N
103622	Lungenersatzverfahren_Doku_Zugang	Gefäßzugang	\N	3	1	\N	\N	\N
103623	Lungenersatzverfahren_Doku_Schlauchsystem	Schlauchsystembeschichtung relevant	\N	3	1	\N	\N	\N
103624	Lungenersatzverfahren_Doku_Kathetertyp	Kathetertyp	\N	3	1	\N	\N	\N
103626	Drainagen_FüllstandAuffang	Dokumentation des aktuellen Füllstandes vom Auffangbehälter	ml	6	100157	\N	\N	\N
103630	Lungenerstazverfahren_Doku_ECMO_Oxygenator	Gerätetyp	\N	3	1	\N	\N	\N
103634	SonsitgeVerfahren_VO_Balken	Gerät auswählen	\N	26	1	\N	\N	\N
103636	SonstVerfahren_VO_Hypothermiegerät_Zieltemperatur	Hypothermiebehandlung	°C	6	1	\N	\N	\N
103637	SonstVerfahren_VO_Hypothermiegerä_Kuehlrate	Hypothermiebehandlung	°C/H	6	1	\N	\N	\N
103640	SonstVerfahren_VO_Hypothermiegerät_Kuehlverfahren	Liste	\N	3	1	\N	\N	\N
103641	SonstVerfahren_VO_Hypothermiegerät_Kathetertyp	Liste	\N	3	1	\N	\N	\N
103642	Wunddokumentation_Sekretmenge_VAC	Bilanzrelevante Dokumentation der Sekretmenge, gefördert über die V.A.C. Pumpe	ml	6	100193	\N	\N	\N
103643	Wunddokumentation_Fuellstand_VAC	Dokumentation des Füllstandes vom Auffangbehälter der VAC Pumpe	ml	6	100193	\N	\N	\N
103644	Dekubitus_Fuellstand_VAC	Dokumentation des Füllstandes des Auffangbehälters der V.A.C. Pumpe im Rahmen der Dekubitusversorgung	ml	6	100186	\N	\N	\N
103645	Dekubitus_Sekretmenge_VAC	Bilanzrelevante Dokumentation der Sekretfördermenge im Rahmen der Dekubitusversorgung	ml	6	100186	\N	\N	\N
103646	internerPacer_Balken	Dokumentation eines internen Pacer	\N	19	1	\N	\N	\N
103648	Score_Braden_Aufnahme	\N	\N	1	30	\N	\N	\N
103649	Braden_Wert_Aufnahme	\N	\N	2	103648	\N	\N	\N
103650	Braden_Aktivitaet_Aufnahme	\N	\N	27	103648	\N	\N	\N
103651	Braden_Feuchtigkeit_Aufnahme	\N	\N	27	103648	\N	\N	\N
103652	Braden_Ernaehrung_Aufnahme	\N	\N	27	103648	\N	\N	\N
103654	Braden_SensorischesEmpfindungsvermo_Aufnahme	\N	\N	27	103648	\N	\N	\N
103655	Braden_Mobilitaet_Aufnahme	\N	\N	27	103648	\N	\N	\N
103656	Braden_Datum_Aufnahme	\N	\N	5	103648	\N	\N	\N
103661	NeurochirurgischeMessungen_Platzhalter	\N	\N	3	1	\N	\N	\N
103680	Score_GCS_Adult_Aufnahme	GCS Aufnahme	\N	1	30	\N	\N	\N
103681	GCS_Adult_Wert_Aufnahme	\N	\N	2	103680	\N	\N	\N
103682	GCS_Adult_Datum_Aufnahme	\N	\N	5	103680	\N	\N	\N
103683	GCS_Adult_Motorik_Aufnahme	\N	\N	27	103680	\N	\N	\N
103684	GCS_Adult_Augen_Aufnahme	\N	\N	27	103680	\N	\N	\N
103685	GCS_Adult_Sprache_Aufnahme	\N	\N	27	103680	\N	\N	\N
103686	Hypothermie_Coolgard_VO_Rate	\N	°C/h	6	1	\N	\N	\N
103687	Hypothermie_Coolgard_VO_Zieltemperatur	\N	°C	6	1	\N	\N	\N
103688	Hypothermie_Coolgard_VO_Behandlungsmodi	\N	\N	3	1	\N	\N	\N
103689	Hypothermie_ArticSun_VO_KuehlWaermeRate	Hypothermiebehandlung	°C/H	6	1	\N	\N	\N
103690	Hypothermie_ArticSun_VO_Zieltemperatur	Hypothermiebehandlung	°C	6	1	\N	\N	\N
103691	Hypothermie_VO_Kuehlverfahren	Liste	\N	3	1	\N	\N	\N
103692	Hypothermie_VO_Gerät	Gerät auswählen	\N	26	1	\N	\N	\N
103693	Hypothermie_Coolgard_Doku_Patiententemperatur	\N	°C	6	1	\N	\N	\N
103694	Hypothermie_Coolgard_Doku-Rate	\N	°c/h	6	1	\N	\N	\N
103695	Hypothermie_Coolgard_Doku_Zieltemperatur	\N	°C	6	1	\N	\N	\N
103696	Hypothemie_Coolgard_Doku_Behandlungsmodi	Listenauswahl	\N	3	1	\N	\N	\N
103697	Hypothermie_ArticSun_Doku_KuehlWaermerate	\N	C°/h	6	1	\N	\N	\N
103698	Hypothermie_ArticSun_Doku_Zieltemperatur	\N	°C	6	1	\N	\N	\N
103699	Hypothermie_Doku_Kühlverfahren_Balken	\N	\N	19	1	\N	\N	\N
103700	Hypothermie_Doku_Kathetertyp-Balken	\N	\N	19	1	\N	\N	\N
103701	Hypothermie_Doku_Gerät_Balken	Geräteauswahl	\N	26	1	\N	\N	\N
103702	Hypothermie_ArticSun_Doku_Patiententemperatur	\N	°C	6	1	\N	\N	\N
103703	TabeOPSAnaesthesie_EintragsDatum	\N	\N	5	101539	\N	\N	\N
103704	Diagnose_Ranking	0=Vorerkrankungen, 1=Hauptdiagnose, ab 2 sonstige Diagnosen	\N	2	1278	\N	\N	\N
103706	Diagnose_Arzt	\N	\N	3	1278	\N	\N	\N
103707	Patient_Antikoerper	\N	\N	3	1	\N	\N	\N
103708	Patient_Spezifitaet	\N	\N	3	1	\N	\N	\N
103709	Patient_GekreuzteEKs	\N	\N	6	1	\N	\N	\N
103710	Patient_BlutKreuzprobe_Datum	\N	\N	5	1	\N	\N	\N
103711	Patient_BlutKreuzprobe_Arzt	\N	\N	3	1	\N	\N	\N
103712	Patient_Kreuzprobe_Besonderheit	\N	\N	3	1	\N	\N	\N
103715	TempPBT	Temperatur bei der PICCO Messung	°C	6	1	\N	\N	\N
103716	TempBT	Bluttemperatur bei der HZV Messung	°C	6	1	\N	\N	\N
103717	IABP_DatascopeCS100_ES_Triggerauswahl	\N	\N	3	1	\N	\N	\N
103718	IABP_DatascopeCS100_ES_IABPFrequenz	\N	\N	3	1	\N	\N	\N
103720	IABP_DatascopeCS100_ES_Unterstützungsdruck	\N	\N	6	1	\N	\N	\N
103721	IABP_DatascopeCS100_ES_EKGAbleitung	\N	\N	3	1	\N	\N	\N
105122	F_Dekanuelierungsplan	Dekanülierungsplan des Patienten. Anlage mehrerer Pläne ist möglich. 	\N	1	20	\N	\N	\N
103722	IABP_DatascopeCS100_ES_IABPAufblasen	\N	\N	6	1	\N	\N	\N
103723	IABP_DatascopeCS100_ES_IABPLeersaugen	\N	\N	6	1	\N	\N	\N
103724	IABP_DatascopeCS100_MS_SystoleMittelDiastole	\N	mmHg	12	1	\N	\N	\N
103728	Enteralesonden_MSBeschaffenheit	Beschreibung der Magensaftes	\N	3	100165	\N	\N	\N
103729	HarnwegeDarm_UrinBeschaffenheit	\N	\N	3	100172	\N	\N	\N
103731	Lungenersatzverfahren_Doku_Temperatur	Dokumentation der eingestellten Temperatur am ECMO Gerät	Grad Celsius	3	1	\N	\N	\N
103733	Enteralesonden_FüllstandAuffang	Dokumentationsmöglichkeit des Füllstandes des Auffangbehältnisses für den Magensaft	ml	3	100165	\N	\N	\N
103734	Lungenersatzverfahren_Doku_ECMOTemperatur	Eingestellter Temperaturwert an der ECMO (Gerät)	Grad Celsius	3	1	\N	\N	\N
103735	Lungenersatzverfahren_Doku_ECMOFlushen	Dokumentation der Tätigkeit "Flushen" bei Einsatz eines ECMO Verfahrens	\N	3	1	\N	\N	\N
103736	Lungenersatzverfahren_Doku_ILAFlushen	Dokumentation der Tätigkeit "Flushen" bei Einsatz eines ILA Verfahrens	\N	3	1	\N	\N	\N
103737	Lungenersatzverfahren_Anordnung_ECMOTemperatur	Angeordnete Temperatureinstellung bei ECMO Verfahren	Grad Celsius	3	1	\N	\N	\N
103739	AICD_Balken	Statusdokumentation eines implantierten AICD	\N	19	1	\N	\N	\N
103740	Behandlung_TestBehandlung	\N	\N	2	30	\N	\N	\N
103741	Behandlung_TestFallnummer	\N	\N	3	30	\N	\N	\N
103895	Therapiebetten_Doku_Rotorest_Position	\N	Liste	19	1	\N	\N	\N
103744	Hypothermie_Doku_Kuehlverfahren	Listenauswahl	\N	3	1	\N	\N	\N
103745	Nierenverfahren_ES_BM25_Temperaturstufe	Liste	Stufe	3	1	\N	\N	\N
103746	Nierenverfahren_VO_BM25_Temperaturstufe	Liste	Stufe	3	1	\N	\N	\N
103747	Organisationseinheit_NC_ArztBP1	\N	\N	3	80	\N	\N	\N
103748	Beatmung_ES_G5_Tubuskompensation	Dokumentation der eingestellten Tubuskompensation	%	3	1	\N	\N	\N
103749	GewichtGroeße_Platzhalter	\N	\N	3	1	\N	\N	\N
103750	Reanimation_Balken	Dokumentation der zeitlichen Dauer der CPR.	\N	19	1	\N	\N	\N
103751	Assistenz_bei_Eingriffen_Diagnostik	Dokumentierte Dauer der pflegerischen Assistenz bei therapeutischen, diagnostischen und oder operativen Interventionen.	\N	19	1	\N	\N	\N
103752	Diagnostik	Dokumentation durchgeführter diagnostischer Maßnahmen.	\N	3	1	\N	\N	\N
103753	Patient_Pupillen	\N	\N	1	1	\N	\N	\N
103755	Patient_Pupillen_Cornealreflex_Links	\N	\N	1	103753	\N	\N	\N
103756	Patient_Pupillen_Cornealreflex_Rechts	\N	\N	1	103753	\N	\N	\N
103757	Patient_Pupillen_Anisokorie	\N	\N	1	103753	\N	\N	\N
103758	Patient_Pupillen_Rechts	\N	\N	1	103753	\N	\N	\N
103759	Patient_Pupillen_Links	\N	\N	1	103753	\N	\N	\N
103761	Patient_Pupillen_Cornealreflex_Links_NichtBeurtei	\N	\N	2	103755	\N	\N	\N
103762	Patient_Pupillen_Cornealreflex_Links_Negativ	\N	\N	2	103755	\N	\N	\N
103800	Patient_Pupillen_Links_k	\N	\N	2	103759	\N	\N	\N
103763	Patient_Pupillen_Cornealreflex_Links_Traege	\N	\N	2	103755	\N	\N	\N
103764	Patient_Pupillen_Cornealreflex_Links_Datum	\N	\N	5	103755	\N	\N	\N
103765	Patient_Pupillen_Cornealreflex_Links_Positiv	\N	\N	2	103755	\N	\N	\N
103767	Patient_Pupillen_Cornealreflex_Rechts_NichtBeurtei	\N	\N	2	103756	\N	\N	\N
103768	Patient_Pupillen_Cornealreflex_Rechts_Negativ	\N	\N	2	103756	\N	\N	\N
103769	Patient_Pupillen_Cornealreflex_Rechts_Traege	\N	\N	2	103756	\N	\N	\N
103770	Patient_Pupillen_Cornealreflex_Rechts_Datum	\N	\N	5	103756	\N	\N	\N
103771	Patient_Pupillen_Cornealreflex_Rechts_Positiv	\N	\N	2	103756	\N	\N	\N
103773	Patient_Pupillen_Anisokorie_Datum	\N	\N	5	103757	\N	\N	\N
103774	Patient_Pupillen_Anisokorie_re_groesser_li	\N	\N	2	103757	\N	\N	\N
103775	Patient_Pupillen_Anisokorie_re_kleiner_li	\N	\N	2	103757	\N	\N	\N
103776	Patient_Pupillen_Anisokorie_vorbestehend	\N	\N	2	103757	\N	\N	\N
103777	Patient_Pupillen_Rechts_negativ	indirekte Lichtreaktion	\N	2	103758	\N	\N	\N
103778	Patient_Pupillen_Rechts_positiv	indirekte Lichtreaktion	\N	2	103758	\N	\N	\N
103779	Patient_Pupillen_Rechts_Datum	Zeitpunkt für den die Pupillenreaktion erfasst wurde.	\N	5	103758	\N	\N	\N
103780	Patient_Pupillen_Rechts_x	\N	\N	2	103758	\N	\N	\N
103781	Patient_Pupillen_Rechts_w	\N	\N	2	103758	\N	\N	\N
103782	Patient_Pupillen_Rechts_m	\N	\N	2	103758	\N	\N	\N
103783	Patient_Pupillen_Rechts_e	\N	\N	2	103758	\N	\N	\N
103784	Patient_Pupillen_Rechts_r	\N	\N	2	103758	\N	\N	\N
103785	Patient_Pupillen_Rechts_k	\N	\N	2	103758	\N	\N	\N
103786	Patient_Pupillen_Rechts_v	\N	\N	2	103758	\N	\N	\N
103787	Patient_Pupillen_Rechts_p	\N	\N	2	103758	\N	\N	\N
103789	Patient_Pupillen_Rechts_GA	\N	\N	2	103758	\N	\N	\N
103790	Patient_Pupillen_Links_negativ	indirekte Lichtreaktion	\N	2	103759	\N	\N	\N
103791	Patient_Pupillen_Links_positiv	indirekte Lichtreaktion	\N	2	103759	\N	\N	\N
103792	Patient_Pupillen_Links_Datum	Zeitpunkt für den die Pupillenreaktion erfasst wurde.	\N	5	103759	\N	\N	\N
103793	Patient_Pupillen_Links_x	\N	\N	2	103759	\N	\N	\N
103794	Patient_Pupillen_Links_w	\N	\N	2	103759	\N	\N	\N
103795	Patient_Pupillen_Links_m	\N	\N	2	103759	\N	\N	\N
103796	Patient_Pupillen_Links_e	\N	\N	2	103759	\N	\N	\N
103798	Patient_Pupillen_Links_GA	\N	\N	2	103759	\N	\N	\N
103799	Patient_Pupillen_Links_r	\N	\N	2	103759	\N	\N	\N
103804	Hypothermie_ArticSun_VO_Behandlungsmodi	Liste	\N	3	1	\N	\N	\N
103805	Hypothermie_ArticSun_Doku_Behandlungsmodi	Liste	\N	3	1	\N	\N	\N
103807	NIRS	Über eine Messsonde transcutan gemessener Prozentwert	%	6	1	\N	\N	\N
103808	rCBF	Über eine Sonde gemessener regionaler cerebraler Blutfluss.	ml/min	6	1	\N	\N	\N
103809	tcpCO2	transcutan gemessener pCO2 Wert.	mmHg	6	1	\N	\N	\N
103814	Behandlungsstrategie_ZielvorgabenICP_Freitext	Zielwert für den ICP Wert unter Hirndrucktherapie	mmHg	3	30	\N	\N	\N
103815	Behandlungsstrategie_ZielvorgabenCPP_Freitext	Zielwert für den CPP unter Hirndrucktherapie	mmHg	3	30	\N	\N	\N
106482	EinweisenderArzt_Vorname	\N	\N	3	20	\N	\N	\N
103816	Behandlungsstrategie_ZielvorgabenPtiO2_Freitext	Zielwert für den intraparenchymen Sauerstoffpartialdruck ermittelt über PtiO2 Sonde	mmHg	3	30	\N	\N	\N
103817	PtiO2Druck	Gemessener Sauerstoffpartialdruck im Parenchym	mmHg	12	1	\N	\N	\N
103818	NIRSlinks_MS	Über eine Messsonde transcutan gemessener Prozentwert	%	6	1	\N	\N	\N
103819	NIRSrechts_MS	\N	%	6	1	\N	\N	\N
103820	Behandlungsstrategie_ZielvorgabenNatrium_Freitext	Dokumentationsmöglichkeit für die Zielvorgabe des Natriumwertes	mmol/l	3	30	\N	\N	\N
103821	Behandlungsstrategie_ZielvorgabenKalium_Freitext	Dokumentationsmöglichkeit für die Zielvorgabe des Kaliumwertes	mmol/l	3	30	\N	\N	\N
103822	Behandlungsstrategie_ZielvorgabenDrahoehe_Freitext	Anordnungsmöglichkeit bzgl. der Drainagenhöhe 	\N	3	30	\N	\N	\N
103823	Behandlungsstrategie_ZielvorgabenDrainSog_Freitext	Anordnungsmöglichkeit für den Sog einer Drainage	\N	3	30	\N	\N	\N
103826	Beatmung_Doku_EzPAP_Applikationsform	Dokumentation der Applikationsform bei Atemtherapie mittels EzPAP	\N	19	1	\N	\N	\N
103827	Beatmung_MS_EzPAP_PAP	Messung des PAP unter der Atemtherapie EzPAP	mmHg	6	1	\N	\N	\N
103828	Waermesysteme_Warmtouch_Doku_Geblaese	Liste	Stufe	3	1	\N	\N	\N
103829	Waermesysteme_Warmtouch_Doku_Temperatur	Liste	°C	3	1	\N	\N	\N
103831	Lungenersatzverfahren_Doku_ILA_Gasfluss	\N	\N	6	1	\N	\N	\N
103832	Lungenersatzverfahren_Doku_ILA_Blutfluss	\N	\N	6	1	\N	\N	\N
103833	Lungenersatzverfahren_VO_ILA_KontrolleExtremitaete	\N	\N	3	1	\N	\N	\N
103834	Lungenersatzverfahren_VO_ILA_GasflussMax	\N	\N	6	1	\N	\N	\N
103835	Lungenersatzverfahren_VO_ILA_GasflussMin	\N	\N	6	1	\N	\N	\N
103836	Lungenersatzverfahren_VO_ILA_BlutflussMin	\N	\N	6	1	\N	\N	\N
103837	Therapiebetten_Doku_Triadyne_reDrehWinkel	Rotationswinkel	°	19	1	\N	\N	\N
103838	Therapiebetten_Doku_Triadyne_liDrehWinkel	Rotationswinkel	\N	19	1	\N	\N	\N
103839	Therapiebetten_Doku_Triadyne_rePause	\N	min	19	1	\N	\N	\N
103841	Therapiebetten_Doku_Triadyne_liPause	Rotationszeit/Haltezeit	min	19	1	\N	\N	\N
103842	Therapiebetten_Doku_Triadyne_mittePause	Haltedauer	min	19	1	\N	\N	\N
103843	Therapiebetten_Doku_Triadyne_IntensPerkussion	\N	\N	19	1	\N	\N	\N
103844	Therapiebetten_Doku_Triadyne_SchlägePerkussion	Schläge /sek	sek	19	1	\N	\N	\N
103845	Therapiebetten_Doku_Triadyne_StaerkePulsation	Listeneintrag	\N	19	1	\N	\N	\N
103847	Therapiebetten_Doku_Triadyne_Lagerung	Listenauswahl	\N	19	1	\N	\N	\N
103848	Therapiebetten_Doku_Triadyne_DruckKopf	\N	mmHg	6	1	\N	\N	\N
103850	Therapiebetten_Doku_Triadyne_DruckSchulter	\N	mmHg	6	1	\N	\N	\N
103851	Therapiebetten_Doku_Triadyne_DruckKoerper	\N	mmHg	6	1	\N	\N	\N
103852	Therapiebetten_Doku_Triadyne_DruckBeine	\N	mmHg	6	1	\N	\N	\N
103857	Lungenersatzverfahren_VO_ILA_Flushmanoever	\N	\N	3	1	\N	\N	\N
103858	Therapiebetten_Doku_Triadyne_FrequenzPulsation	\N	\N	19	1	\N	\N	\N
104131	Behandlung_DIVI_TherapiaMinima	\N	\N	2	30	\N	\N	\N
105203	F_Untersuchung	Objekt für die Tabelle der körperlichen Untersuchung der ärztlichen Dokumentation	\N	1	20	\N	\N	\N
105204	F_Untersuchung_Abdomen	\N	\N	3	105203	\N	\N	Befunddokumentation (Abdomen)
105206	F_Untersuchung_Extremitaeten	\N	\N	3	105203	\N	\N	Befunddokumentation (Extremitäten)
105207	F_Untersuchung_Herz	\N	\N	3	105203	\N	\N	Befunddokumentation (Herz)
105208	F_Untersuchung_Lunge	\N	\N	3	105203	\N	\N	Befunddokumentation (Lunge / Beatmung)
105209	F_Untersuchung_Neurologie	\N	\N	3	105203	\N	\N	Befunddokumentation (Neurologie)
105210	F_Untersuchung_Sonstiges	\N	\N	3	105203	\N	\N	Befunddokumentation (Sonstiges)
105221	Diagnose_Bemerkung	Bemerkung zu einer Diagnose	\N	3	1278	\N	\N	Diagnosen / Vorerkrankung (Bemerkung)
105222	Score_NRS_Verlauf	\N	\N	1	1	\N	\N	\N
105223	Score_BPS_Verlauf	\N	\N	1	1	\N	\N	\N
105229	B_Aufnahmegrund	Dokumentation des Aufnahmegrunds in der Dokumentation Medizinischer Dienst.	\N	3	30	\N	\N	Aufnahmegrund
105234	B_Aufnahmebefund_aufnArzt	\N	\N	3	30	\N	\N	Aufnahmebefund (aufn. Arzt)
103859	Therapiebetten_Doku_Triadyne_Position	Einstellung der Lage	\N	19	1	\N	\N	\N
103860	Therapiebetten_Doku_Triadyne_Temp	Liste	°C	19	1	\N	\N	\N
103861	Therapiebetten_Doku_Geraet_Balken	\N	\N	26	1	\N	\N	\N
103862	PersoenAspekte_Sterbebegleitung_Wert	\N	\N	25	100524	\N	\N	\N
103863	PersoenAspekte_Angehoerige_Wert	\N	\N	25	100524	\N	\N	\N
103864	PersoenAspekte_Patient_Wert	\N	\N	25	100524	\N	\N	\N
103909	Therapiematratze_Doku_TheraKair_IntensPulsation	Liste	\N	19	1	\N	\N	\N
103875	PersoenAspekte_Sterbebegleitung_VersSterbender	Dokumentation der Versorgung von einen sterbenden Patienten.	\N	3	103862	\N	\N	\N
103877	Therapiebetten_Doku_BariAir_reDrehwinkel	\N	°	19	1	\N	\N	\N
103878	Therapiebetten_Doku_BariAir_liDrehwinkel	\N	°	19	1	\N	\N	\N
103880	Therapiebetten_Doku_BariAir_rePause	\N	min	19	1	\N	\N	\N
103881	Therapiebetten_Doku_BariAir_liPause	\N	min	19	1	\N	\N	\N
105240	B_Aufnahmebefund_Anamnese	\N	\N	3	30	\N	\N	Aufnahmebefund (Anamnese)
105242	B_Aufnahmegewicht	Dokumentation des Patientengewichtes bei Aufnahme.	\N	3	30	\N	\N	Aufnahmegewicht (Methode)
105243	B_Aufnahmegroesse	Dokumentation der Patientengröße bei Aufnahme.	\N	3	30	\N	\N	Aufnahmegröße (Methode)
105244	B_Aufnahmeart	Dokumentation der Aufnahmeart.	\N	3	30	\N	\N	Aufnahmeart
105248	F_MedDoku_Vormedikation_Anmerkung	\N	\N	3	105241	\N	\N	Vormedikation (Anmerkung)
105249	F_MedDoku_Vormedikation_pausiert_seit	\N	\N	3	105241	\N	\N	Vormedikation (pausiert seit)
105250	F_MedDoku_Vormedikation_Dosierung_nachts	\N	\N	3	105241	\N	\N	Vormedikation (nachts)
105251	F_MedDoku_Vormedikation_Dosierung_abends	\N	\N	3	105241	\N	\N	Vormedikation (abends)
105252	F_MedDoku_Vormedikation_Dosierung_mittags	\N	\N	3	105241	\N	\N	Vormedikation (mittags)
105253	F_MedDoku_Vormedikation_Dosierung_morgens	\N	\N	3	105241	\N	\N	Vormedikation (morgens)
105254	F_MedDoku_Vormedikation_Dosierung	\N	\N	3	105241	\N	\N	Vormedikation (Dosis)
105255	F_MedDoku_Vormedikation_Medikamentenname	\N	\N	3	105241	\N	\N	Vormedikation (Medikamentenname)
105264	Diagnose_Katalogtext	ICD-Katalogtext wie er aus SAP übermittelt wird	\N	3	1278	\N	\N	Diagnose / Vorerkrankung (ICD - Katalogtext)
103882	Therapiebetten_Doku_BariAir_mittePause	\N	min	19	1	\N	\N	\N
103883	Therapiebetten_Doku_BariAir_FrequenzPulsation	\N	min	19	1	\N	\N	\N
103884	Therapiebetten_Doku_BariAir_Staerke_Pulsation	\N	Liste	19	1	\N	\N	\N
103885	Therapiebetten_Doku_BariAir_SchlägePerkussion	\N	sec	19	1	\N	\N	\N
103886	Therapiebetten_Doku_BariAir_IntenPerkussion	\N	Liste	19	1	\N	\N	\N
103887	Therapiebetten_Doku_BariAir_Position	\N	Liste	19	1	\N	\N	\N
103888	Therapiebetten_Doku_BariAir_Temp	\N	°C	19	1	\N	\N	\N
103889	Therapiebetten_Doku_Rotorest_reRotWinkel	\N	°C	19	1	\N	\N	\N
103890	Therapiebetten_Doku_Rotorest_liRotWinkel	\N	°C	19	1	\N	\N	\N
106278	Ernaehren_Ausscheiden_UrinPflege	Hilfsmittel	\N	3	100453	\N	\N	Pflegedoku - Urin (Pflege)
106279	Ernaehren_Ausscheiden_StuhlPflege	Listenauswahl	\N	3	100453	\N	\N	Pflegedoku - Stuhl (Pflege)
103891	Therapiebetten_Doku_Rotorest_liVerweildauer	\N	min	19	1	\N	\N	\N
103892	Therapiebetten_Doku_Rotorest_reVerweildauer	\N	min	19	1	\N	\N	\N
103896	Therapiebetten_Doku_TheraPulse_Lagerung	\N	Liste	19	1	\N	\N	\N
103897	Therapiebetten_Doku_TheraPulse_IntensitaetPulsatio	\N	Liste	19	1	\N	\N	\N
103898	Therapiebetten_Doku_TheraPulse_ZyklusPulsation	\N	min	19	1	\N	\N	\N
103899	Koerperpflege_Waschen_Wert_	\N	\N	3	100389	\N	\N	\N
103907	Therapiematratze_Doku_TheraKair_Festigkeit	Liste	\N	19	1	\N	\N	\N
103908	Therapiematratze_Doku_TheraKair_ZyklusPulsation	Liste	sec	19	1	\N	\N	\N
103910	Therapiematratze_Doku_TheraKair_Waermefunktion	Liste	\N	19	1	\N	\N	\N
103911	Therapiebetten_VO_Geraet_Balken	\N	\N	19	1	\N	\N	\N
103912	Therapiebetten_VO_Triadyne_reDrehWinkel	\N	°	3	1	\N	\N	\N
103913	Therapiebetten_VO_Triadyne_liDrehWinkel	\N	°	3	1	\N	\N	\N
103914	Therapiebetten_VO_Triadyne_rePause	\N	°	3	1	\N	\N	\N
103915	Therapiebetten_VO_Triadyne_liPause	\N	°	3	1	\N	\N	\N
103916	Therapiebetten_VO_Triadyne_mittePause	\N	\N	3	1	\N	\N	\N
103917	Therapiebetten_VO_Triadyne_Lagerung	\N	\N	3	1	\N	\N	\N
103920	Therapiebetten_VO_BariAir_reDrehwinkel	\N	°	3	1	\N	\N	\N
103921	Therapiebetten_VO_BariAir_liDrehwinkel	\N	°	3	1	\N	\N	\N
103922	Therapiebetten_VO_BariAir_rePause	\N	min	3	1	\N	\N	\N
103923	Therapiebetten_VO_BariAir_liPause	\N	min	3	1	\N	\N	\N
103924	Therapiebetten_VO_BariAir_mittePause	\N	min	3	1	\N	\N	\N
103925	Therapiebetten_VO_Rotorest_reRotWinkel	\N	°	3	1	\N	\N	\N
103926	Therapiebetten_VO_Rotorest_liRotWinkel	\N	°	3	1	\N	\N	\N
103927	Therapiebetten_VO_Rotorest_liVerweildauer	\N	\N	3	1	\N	\N	\N
103928	Therapiebetten_VO_Rotorest_reVerweildauer	\N	min	3	1	\N	\N	\N
103931	Therapiebetten_VO_Geraete_Balken	\N	\N	26	1	\N	\N	\N
103933	Behandlungsstrategie_ZielvorgabenOraleFlu_Freitext	\N	\N	3	30	\N	\N	\N
103934	VerlegPfl_Atm_SekretNRR	Beschreibung der Eigenschaft des Sekrets NRR	\N	3	30	\N	\N	\N
103935	VerlegPfl_Atm_TrachsekretMenge	Beschreibung der Menge des Trachealsekrets im Verlegungsbericht.	\N	3	30	\N	\N	\N
103936	VerlegPfl_Atm_SekretNRR_Menge	Beschreibung der Menge des Sekrets NRR im Verlegungsbericht.	\N	3	30	\N	\N	\N
103938	VerlPfl_Befind_RASS	Rchmond Atation Sedtion Sale bei Vrlegung	\N	3	30	\N	\N	\N
103943	Beatmung_ES_Heimbeatmung_Peep	\N	mbar	6	1	\N	\N	\N
106483	EinweisenderArzt_Name	\N	\N	3	20	\N	\N	\N
103944	Beatmung_Doku_Heimbeatmung_Name	Freitext	\N	3	1	\N	\N	\N
103957	VerlegPfl_SchrittmacherZugang	Dokumentation des Zugangswegs bei Schrittmachertherapie im Pflegeverlegungsbericht	\N	3	30	\N	\N	\N
103958	VerlPfl_Befind_Pupillenkontrolle_re	Pupillendokumentation im Pflegeverlegungsbericht.	\N	3	30	\N	\N	\N
103959	VerlPfl_Befind_Pupillenkontrolle_li	Pupillendokumentation im Pflegeverlegungsbericht.	\N	3	30	\N	\N	\N
103960	VerlPfl_Befind_Pupillenkontrolle_Isokorie	Dokumentation der Pupillenisokorie im Pflegeverlegungsbericht.	\N	3	30	\N	\N	\N
103961	VerlPfl_Befind_Cornealreflex_re	Dokumentation des Cornealreflexes im Pflegeverlegungsbericht.	\N	3	30	\N	\N	\N
103962	VerlPfl_Befind_Cornealreflex_li	Dokumentation de4s Cornealreflexes im Pflegeverlegungsbericht.	\N	3	30	\N	\N	\N
103963	Behandlungsstrategie_MessintervalleZVD_Freitext	\N	\N	3	30	\N	\N	\N
103964	Behandlungsstrategie_MessintervalleUrinau_Freitext	\N	\N	3	30	\N	\N	\N
103965	Behandlungsstrategie_MessintervalleGesabilanz_Frei	\N	\N	3	30	\N	\N	\N
103966	Behandlungsstrategie_MessintervalleBGAarteriell	\N	\N	3	30	\N	\N	\N
103967	Behandlungsstrategie_MessintervalleBZ_Freitext	\N	\N	3	30	\N	\N	\N
103968	Behandlungsstrategie_MessintervalleGewicht_Frei	\N	\N	3	30	\N	\N	\N
103969	Behandlungsstrategie_MessintervalleGCS_Freitext	\N	\N	3	30	\N	\N	\N
103970	Behandlungsstrategie_MessintervalleRamsay_Freitext	\N	\N	3	30	\N	\N	\N
103971	Behandlungsstrategie_MessintervalleRASS_Freitext	\N	\N	3	30	\N	\N	\N
103972	Behandlungsstrategie_MessintervalleNatrium_Frei	\N	\N	3	30	\N	\N	\N
103973	Behandlungsstrategie_MessintervalleKalium_Freitext	\N	\N	3	30	\N	\N	\N
103974	Behandlungsstrategie_MessintervallePH_Freitext	\N	\N	3	30	\N	\N	\N
103975	Behandlungsstrategie_MessintervalleCPP_Freitext	\N	\N	3	30	\N	\N	\N
103976	Behandlungsstrategie_MessintervalleICP_Freitext	\N	\N	3	30	\N	\N	\N
103977	Behandlungsstrategie_MessintervalleEtCO2_Freitext	\N	\N	3	30	\N	\N	\N
103978	Behandlungsstrategie_MessintervallePupillenko_Frei	\N	\N	3	30	\N	\N	\N
103979	Behandlungsstrategie_MessintervalleSpezifGewi_Frei	\N	\N	3	30	\N	\N	\N
103980	Behandlungsstrategie_MessintervalleUntereGI_Frei	\N	\N	3	30	\N	\N	\N
103981	Behandlungsstrategie_MessintervalleAtmung_Frei	\N	\N	3	30	\N	\N	\N
103982	Behandlungsstrategie_MessintervalleHZV_Frei	\N	\N	3	30	\N	\N	\N
103983	Behandlungsstrategie_MessintervallePAP_Frei	\N	\N	3	30	\N	\N	\N
103984	Behandlungsstrategie_MessintervalleBewustsein_Frei	\N	\N	3	30	\N	\N	\N
103985	Behandlungsstrategie_MessintervalleHerzschrit_Frei	\N	\N	3	30	\N	\N	\N
103986	Behandlungsstrategie_MessintervalleACT_Frei	\N	\N	3	30	\N	\N	\N
103987	Behandlungsstrategie_MessintervalleptiO2_Frei	\N	\N	3	30	\N	\N	\N
103988	Computer_Ort	\N	\N	3	120	\N	\N	\N
103989	Behandlungsstrategie_Messintervalleintraabddruck	\N	freitext	3	30	\N	\N	\N
103990	Behandlungsstrategie_ZielvorgabenZVD	\N	text	3	30	\N	\N	\N
103991	Behandlungsstrategie_ZielvorgabenAF	\N	text	3	30	\N	\N	\N
103992	Therapiebetten_Doku_FluidAirPlus_Temperatur	\N	°C	19	1	\N	\N	\N
103994	Therapiebetten_Doku_FluidAirPlus_Fluidation	\N	Zahl	19	1	\N	\N	\N
103995	Behandlungsstrategie_ZielvorgabenScvO2	\N	\N	3	30	\N	\N	\N
103996	Behandlungsstrategie_ZielvorgabenSpo2Pulsoxy	\N	%	3	30	\N	\N	\N
103997	Behandlungsstrategie_Messintervalle_BGAzvenös	\N	\N	3	30	\N	\N	\N
103998	Behandlungsstrategie_Messintervalle_Drainage	\N	\N	3	30	\N	\N	\N
103999	Patient_Score_Dubois_Wert	\N	\N	2	102797	\N	\N	\N
104000	Patient_Score_Dubois_Date	\N	\N	5	102797	\N	\N	\N
104001	Patient_Score_Dubois_Bewusstsein	\N	\N	27	102797	\N	\N	\N
104002	Patient_Score_Dubois_Schlafrythmus	\N	\N	27	102797	\N	\N	\N
104003	Patient_Score_Dubois_Desorientiertheit	\N	\N	27	102797	\N	\N	\N
104004	Patient_Score_Dubois_Stimme	\N	\N	27	102797	\N	\N	\N
104005	Patient_Score_Dubois_Aufmerksamkeit	\N	\N	27	102797	\N	\N	\N
104006	Patient_Score_Dubois_Halluzination	\N	\N	27	102797	\N	\N	\N
104007	Patient_Score_Dubois_Stupor	\N	\N	27	102797	\N	\N	\N
104008	Patient_Score_Dubois_Symptome	\N	s	27	102797	\N	\N	\N
104009	Beatmung_Messung_Horrowitz	\N	\N	6	1	\N	\N	\N
104010	Behandlungsstrategie_ZielvorgabenCI	\N	ml/min/m²	3	30	\N	\N	\N
104011	Behandlungsstrategie_MessintervalleLiqourdrainage	\N	\N	3	30	\N	\N	\N
104012	Pflegepersonalaufwand_erhöht	Listendoku zusätzl. Personal	\N	19	1	\N	\N	\N
104014	Isolationsmaßnahmen_Balken	\N	\N	19	100471	\N	\N	\N
104016	Behandlungsstrategie_ZielvorgabenMPAP_Freitext	\N	mmHg	3	30	\N	\N	\N
104017	Behandlungsstrategie_ZielvorgabenSvO2_Freitext	\N	\N	3	30	\N	\N	\N
104022	Bewegen_Bewegungen_LagerungBalken	\N	\N	19	100360	\N	\N	\N
104023	Umkehrisolation_Balken	\N	\N	19	100471	\N	\N	\N
104024	Dekubitus_Sekretmenge_ml	Dokumentation des Sekretverlustes über den Dekubitus in ml.	ml	6	100186	\N	\N	\N
104025	Wunddokumentation_Sekretmenge_ml	Dokumentation des Sekretverlustes über die Wunden und Defekte in ml.	ml	6	100193	\N	\N	\N
104026	VAD_Gerät_Doku	\N	\N	26	1	\N	\N	\N
104027	VAD_Blutfluss_Doku	\N	l/min	6	1	\N	\N	\N
104028	VAD_Vakuum_Doku	\N	mmHg	6	1	\N	\N	\N
104029	VAD_Weaning_Doku	\N	\N	19	1	\N	\N	\N
104030	PersoenAspekte_Sterbebegleitung_INPULS	Zeile für einen automatisierten Eintrag, für das Merkmal Sterbebegleitung in INPULS.	\N	3	103862	\N	\N	\N
104031	Patient_Datum_letzte_Transplantation	\N	\N	5	1	\N	\N	\N
104032	Beatmung_MS_HorowitzINPULS	Messung des Horowitz-Indexes	\N	6	1	\N	\N	\N
104033	Beatmung_ES_NO	Einstellwert des NO bei NO Beatmung	ppm	6	1	\N	\N	\N
104034	Beatmung_MS_NO	Messwert der  NO Konzentration bei NO Beatmung	\N	6	1	\N	\N	\N
104035	Beatmung_MS_NO2	Messwert der NO2 Konzentration bei NO Beatmung	\N	6	1	\N	\N	\N
104036	Beatmung_ES_G5_Pasvlimit	\N	mbar	6	1	\N	\N	\N
104037	Beatmung_MS_G5_Mvspont	\N	l/min	6	1	\N	\N	\N
104039	Beatmung_ES_G5_Pinsp	\N	mbar	6	1	\N	\N	\N
104040	Beatmung_MS_G5_VTi	\N	ml	6	1	\N	\N	\N
104042	TISS28_artKatheter_Aufnahme	\N	\N	27	104041	\N	\N	\N
104043	TISS28_AzidoseAlkalose_Aufnahme	\N	\N	27	104041	\N	\N	\N
104044	TISS28_Beatmung_Aufnahme	\N	\N	27	104041	\N	\N	\N
104045	TISS28_Bilanzierung_Aufnahme	\N	\N	27	104041	\N	\N	\N
104046	TISS28_StandardMonit_Aufnahme	\N	\N	27	104041	\N	\N	\N
104047	TISS28_Drainagenpflege_Aufnahme	\N	\N	27	104041	\N	\N	\N
104048	TISS28_enteraleErn_Aufnahme	\N	\N	27	104041	\N	\N	\N
104049	TISS28_erweitHaemoynMonit_Aufnahme	\N	\N	27	104041	\N	\N	\N
104050	TISS28_extrakorpNierenersatz_Aufnahme	\N	\N	27	104041	\N	\N	\N
104051	TISS28_Haeufigerverbandswechsel_Aufnahme	\N	\N	27	104041	\N	\N	\N
104052	TISS28_ICPMessung_Aufnahme	\N	\N	27	104041	\N	\N	\N
104053	TISS28_InotropikaGabe_Aufnahme	\N	\N	27	104041	\N	\N	\N
104054	TISS28_InterventionAufICU_Aufnahme	\N	\N	27	104041	\N	\N	\N
104055	TISS28_intravFluessTh_Aufnahme	\N	\N	27	104041	\N	\N	\N
104056	TISS28_LaborMibi_Aufnahme	\N	\N	27	104041	\N	\N	\N
104057	TISS28_Medikamentengabe_Aufnahme	\N	\N	27	104041	\N	\N	\N
104058	TISS28_mediNierenunterstuetzung_Aufnahme	\N	\N	27	104041	\N	\N	\N
104059	TISS28_parentErnaehrung_Aufnahme	\N	\N	27	104041	\N	\N	\N
104060	TISS28_ReanimationDefibr_Aufnahme	\N	\N	27	104041	\N	\N	\N
104061	TISS28_Routineverbandswechsel_Aufnahme	\N	\N	27	104041	\N	\N	\N
104062	TISS28_TransIntensivP_Aufnahme	\N	\N	27	104041	\N	\N	\N
104063	TISS28_Tubuspflege_Aufnahme	\N	\N	27	104041	\N	\N	\N
104064	TISS28_VerbesserungLufu_Aufnahme	\N	\N	27	104041	\N	\N	\N
104065	TISS28_zentralvZugang_Aufnahme	\N	\N	27	104041	\N	\N	\N
104066	TISS28_Wert_Aufnahme	\N	\N	2	104041	\N	\N	\N
104067	TISS28_Datum_Aufnahme	\N	\N	5	104041	\N	\N	\N
104068	Score_SAPS2_Aufnahme	\N	\N	1	30	\N	\N	\N
104069	SAPS2_Alter_Aufnahme	\N	\N	27	104068	\N	\N	\N
104070	SAPS2_Bili_Aufnahme	\N	\N	27	104068	\N	\N	\N
104071	SAPS2_GCS_Aufnahme	\N	\N	27	104068	\N	\N	\N
104072	SAPS2_Harnstoff_Aufnahme	\N	\N	27	104068	\N	\N	\N
104073	SAPS2_HarnstStickst_Aufnahme	\N	\N	27	104068	\N	\N	\N
104074	SAPS2_HCO3_Aufnahme	\N	\N	27	104068	\N	\N	\N
104075	SAPS2_HF_Aufnahme	\N	\N	27	104068	\N	\N	\N
104076	SAPS2_Kalium_Aufnahme	\N	\N	27	104068	\N	\N	\N
104079	SAPS2_PaO2_Aufnahme	\N	\N	27	104068	\N	\N	\N
104080	SAPS2_SystBD_Aufnahme	\N	\N	27	104068	\N	\N	\N
104081	SAPS2_Temp_Aufnahme	\N	\N	27	104068	\N	\N	\N
106442	ZW_HF_kont	Herzfrequenz Zielwert	1/min	39	30	\N	\N	Zielwertdefinition für HF
106443	ZW_RR_kont	RR Zielwert	mmHg	39	30	\N	\N	Zielwertdefinition für RR
106444	ZW_MAP_kont	MAP Zielwert	mmHg	39	30	\N	\N	Zielwertdefinition für MAP
106445	ZW_ZVD_kont	ZVD Zielwert	\N	39	30	\N	\N	Zielwertdefinition für ZVD
106446	ZW_Temp_kont	Temperatur Zielwert	°C	39	30	\N	\N	Zielwertdefnition für Temp
106484	EinweisenderArzt_Titel	\N	\N	3	20	\N	\N	\N
104082	SAPS2_Urin_Aufnahme	\N	\N	27	104068	\N	\N	\N
104083	SAPS2_VKrank_Aufnahme	\N	\N	27	104068	\N	\N	\N
104084	SAPS2_Zuweisung_Aufnahme	\N	\N	27	104068	\N	\N	\N
104085	SAPS2_Datum_Aufnahme	\N	\N	5	104068	\N	\N	\N
104086	SAPS2_Wert_Aufnahme	\N	\N	2	104068	\N	\N	\N
104088	Koerperpflege_Umfang_Hals	\N	\N	3	104087	\N	\N	\N
104092	Koerperpflege_Umfaenge_Wert	\N	\N	25	100356	\N	\N	\N
104093	Koerperpflege_Umfaenge_Arm_li	\N	\N	3	104092	\N	\N	\N
104094	Koerperpflege_Umfaenge_Arm_re	\N	\N	3	104092	\N	\N	\N
104096	Koerperpflege_Umfaenge_Bein_li	\N	\N	3	104092	\N	\N	\N
104097	Koerperpflege_Umfaenge_Bein_re	\N	\N	3	104092	\N	\N	\N
104101	Ort_Temperatur1a_Messung	Liste	\N	3	1	\N	\N	\N
104102	Ort_Temperatur1b_Messung	Liste	\N	3	1	\N	\N	\N
104103	Ort_Temperatur2a_Messung	Liste	\N	3	1	\N	\N	\N
104104	Ort_Temperatur2b_Messung	\N	\N	3	1	\N	\N	\N
104105	Ort_Temperatur3a_Messung	\N	\N	3	1	\N	\N	\N
104106	Ort_Temperatur3b_Messung	\N	\N	3	1	\N	\N	\N
104107	Temperatur_Messung_Ort1a	Liste	\N	19	1	\N	\N	\N
104108	Temperatur_Messung_Ort2a	Liste	\N	19	1	\N	\N	\N
104109	Temperatur_Messung_Ort2b	Liste	\N	19	1	\N	\N	\N
104110	Temperatur_Messung_Ort1b	Liste	\N	19	1	\N	\N	\N
104111	Temperatur_Messung_Ort3a	Liste	\N	19	1	\N	\N	\N
104112	Temperatur_Messung_Ort3b	Liste	\N	19	1	\N	\N	\N
104115	PersoenAspekte_Sterbebegleitung_INPULSMARKER	Marker für die Sterbebegleitung in Inpuls 48 h prä Exitus	\N	19	103862	\N	\N	\N
104117	Lungenersatzverfahren_MS_ILA_SpO2	\N	%	6	1	\N	\N	\N
104118	Lungenersatzverfahren_Doku_ILA_SpO2Messort	Liste	\N	19	1	\N	\N	\N
104119	Score_TISS28_TISS10_Wert	\N	\N	2	101947	\N	\N	\N
106651	Score_UStix	\N	\N	1	20	\N	\N	\N
106723	Arztbriefunterstuetzung_G	\N	\N	3	0	2016-09-13 06:30:41.927	\N	\N
106724	Arztbriefunterstuetzung_D	\N	\N	3	0	2016-09-13 06:30:37.800	\N	\N
106763	testtest	\N	\N	1	20	2016-11-02 15:14:15.500	\N	\N
106764	testtest_Test	\N	\N	3	106763	2016-11-02 15:14:11.857	\N	\N
106765	testtest_zeit	\N	\N	5	106763	2016-11-02 15:13:59.723	\N	\N
106767	UStix_DateTime	\N	\N	5	106749	\N	\N	\N
107827	Beatmung_ES_Leoni_FrequenzRec	\N	1/min	3	1	2017-04-25 13:28:16.543	\N	\N
107896	Beatmung_ES_T1_Timax	eingestellte maximale Inspirationszeit im Modus NIV	s	3	1	2017-04-27 06:41:59.877	\N	\N
107916	NEV_HD_VO_ADVOS_UF_Rate	\N	ml/h	6	1	2017-05-23 14:08:02.490	\N	\N
107917	NEV_HD_VO_ADVOS_Temp	\N	°C	6	1	2017-05-23 14:07:51.410	\N	\N
107918	NEV_HD_VO_ADVOS_Blutfluss	\N	ml/min	6	1	2017-05-23 14:07:28.630	\N	\N
107919	NEV_HD_VO_ADVOS_Citrat	\N	ml/h	6	1	2017-05-23 14:07:44.870	\N	\N
107920	NEV_HD_VO_ADVOS_Calcium	\N	ml/h	6	1	2017-05-23 14:07:38.587	\N	\N
107921	NEV_HD_ES_ADVOS_UF_Rate	\N	ml/h	6	1	2017-05-23 14:07:00.697	\N	\N
107922	NEV_HD_ES_ADVOS_Temp	\N	°C	6	1	2017-05-23 14:06:43.240	\N	\N
107923	NEV_HD_ES_ADVOS_Blutfluss	\N	ml/min	6	1	2017-05-23 14:04:02.640	\N	\N
107924	NEV_HD_ES_ADVOS_Citrat	\N	ml/h	6	1	2017-05-23 14:04:30.477	\N	\N
107925	NEV_HD_ES_ADVOS_Calcium	\N	ml/h	6	1	2017-05-23 14:04:17.760	\N	\N
107926	NEV_HD_MS_ADVOS_CalciumKonzentration	Calcium-Konzentration nach dem Filter (mmol/l)	mmol/l	6	1	2017-05-23 14:07:21.957	\N	\N
107941	P_ADVOS_Doku_CitratLoesung1	\N	\N	3	1	2017-05-24 11:28:48.900	\N	\N
107942	P_ADVOS_Doku_CalciumLoesung1	\N	\N	3	1	2017-05-24 11:28:53.977	\N	\N
107944	P_ADVOS_Doku_Antikoagulation1	\N	\N	3	1	2017-05-24 11:28:58.353	\N	\N
107945	P_ADVOS_Doku_Dialysatloesung1	\N	\N	3	1	2017-05-24 11:28:42.890	\N	\N
107946	P_ADVOS_Doku_Zugang1	Liste	\N	3	1	2017-05-24 11:28:16.980	\N	\N
107947	P_ADVOS_Doku_Filter1	\N	\N	3	1	2017-05-24 11:28:35.617	\N	\N
108003	P_Beatmung_ES_C3_Peep_Grenzwert_max	\N	\N	3	1	2017-05-30 13:02:02.790	\N	\N
108048	GW_LAP_kont	\N	\N	39	30	2017-06-20 08:53:00.090	\N	\N
108049	GW_PAP_kont	\N	\N	39	30	2017-06-20 06:07:10.480	\N	\N
108050	GW_ABP_kont	Grenzwert ABP	\N	39	30	2017-06-20 06:02:02.087	\N	\N
108051	GW_ICP_kont	Grenzwert ICP	\N	39	30	2017-06-20 09:12:27.967	\N	\N
108052	GW_Gewicht_kont	Grenzwert Gewicht	\N	39	30	2017-06-20 08:58:03.090	\N	\N
108055	GW_NBP_kont	Grenzwert NBP	\N	39	30	2017-06-20 06:05:13.850	\N	\N
108056	GW_etCO2_kont	Grenzwert etCO2	\N	39	30	2017-06-20 05:59:40.930	\N	\N
108057	GW_Bilanz_kont	Grenzwert Bilanz	\N	39	30	2017-06-20 09:09:57.967	\N	\N
108058	GW_spo2_kont	\N	\N	39	30	2017-06-20 05:49:27.113	\N	\N
108059	GW_Respiration_kont	\N	\N	39	30	2017-06-20 05:45:11.790	\N	\N
108060	GW_tcpCO2_kont	Grenzwert tcpCO2	\N	39	30	2017-06-20 05:58:26.383	\N	\N
108061	GW_Temp_kont	\N	\N	39	30	2017-06-20 08:56:28.543	\N	\N
108062	GW_ZVD_kont	Grenzwert ZVD	\N	39	30	2017-06-20 09:11:18.513	\N	\N
108063	GW_HF_kont	Grenzwert Herzfrequenz	\N	39	30	2017-06-20 05:43:14.037	\N	\N
108064	VO_Messintervall_LAP_kont	\N	\N	39	30	2017-06-20 08:55:13.157	\N	\N
108065	ZW_LAP_kont	\N	\N	39	30	2017-06-20 08:55:08.180	\N	\N
108066	VO_Messintervall_PAP_kont	\N	\N	39	30	2017-06-20 06:08:26.233	\N	\N
108067	ZW_PAP_kont	\N	\N	39	30	2017-06-20 08:49:59.677	\N	\N
108068	VO_Messintervall_Respiration_kont	\N	\N	39	30	2017-06-20 05:45:55.120	\N	\N
108069	VO_Intervent_sonstige_kont	\N	\N	39	30	2017-06-20 09:15:15.400	\N	\N
108077	VO_Messintervall_Sonst_kont	\N	\N	39	30	2017-06-20 09:15:02.010	\N	\N
108078	VO_Messintervall_Scoreerhebung_kont	\N	\N	39	30	2017-06-20 09:13:53.447	\N	\N
108079	VO_Messintervall_etCO2	\N	\N	39	30	2017-06-20 06:00:15.897	\N	\N
108080	VO_Messintervall_SaO2_kont	\N	\N	39	30	2017-06-20 05:47:02.460	\N	\N
108081	VO_Messintervall_ABP_kont	\N	\N	39	30	2017-06-20 06:02:41.670	\N	\N
108082	VO_Messintervall_tcpCO2	\N	\N	39	30	2017-06-20 05:56:11.757	\N	\N
108084	ZW_ABP_kont	\N	\N	39	30	2017-06-20 06:03:14.760	\N	\N
108086	VO_Messintervall_NBP_kont	\N	\N	39	30	2017-06-20 06:05:19.477	\N	\N
108087	VO_Messintervall_Temp_kont	\N	\N	39	30	2017-06-20 08:57:02.037	\N	\N
108088	VO_Messintervall_HF_kont	\N	\N	39	30	2017-06-20 05:44:07.700	\N	\N
108092	ZW_NBP_kont	\N	\N	39	30	2017-06-20 06:05:24.000	\N	\N
108093	ZW_etCO2_kont	\N	\N	39	30	2017-06-20 06:00:56.357	\N	\N
108095	ZW_Respiration_kont	\N	\N	39	30	2017-06-20 05:46:29.227	\N	\N
108096	ZW_tcpCO2_kont	\N	\N	39	30	2017-06-20 05:55:26.710	\N	\N
108597	B_VO_Messintevall_tcpCO2_kont	\N	\N	39	30	2017-09-27 07:04:28.463	\N	\N
110825	P_Beatmung_ES_C3_Frequenz	\N	\N	3	1	2017-10-24 10:20:36.083	\N	\N
110942	Entlassmanagement_Poststat_Versorgungsbedarf_Ja_Pf	\N	\N	3	30	2018-06-05 11:14:10.400	\N	\N
110943	Entlassmanagement_Poststat_Versorgungsbedarf_Ne_Pf	\N	\N	3	30	2018-06-05 11:14:20.930	\N	\N
110944	Entlassmanagement_Poststat_Versorgungsbedarf_Ja_Ar	\N	\N	3	30	2018-06-05 11:14:05.240	\N	\N
110945	Entlassmanagement_Poststat_Versorgungsbedarf_Ne_Ar	\N	\N	3	30	2018-06-05 11:14:15.930	\N	\N
110946	Entlassmanagement_weitereBerufsgruppenf_Ja_Pf	\N	\N	3	30	2018-06-05 11:14:33.863	\N	\N
110947	Entlassmanagement_weitereBerufsgruppenf_Ne_Pf	\N	\N	3	30	2018-06-05 11:14:43.030	\N	\N
110948	Entlassmanagement_weitereBerufsgruppenf_Ja_Ar	\N	\N	3	30	2018-06-05 11:14:29.400	\N	\N
110949	Entlassmanagement_weitereBerufsgruppenf_Ne_Ar	\N	\N	3	30	2018-06-05 11:14:38.397	\N	\N
110950	Entlassmanagement_EntlassplanAktualisiert_Ja_Pf	\N	\N	3	30	2018-06-05 11:13:37.737	\N	\N
110951	Entlassmanagement_EntlassplanAktualisiert_Ne_Pf	\N	\N	3	30	2018-06-05 11:13:48.837	\N	\N
110952	Entlassmanagement_EntlassplanAktualisiert_Ja_Ar	\N	\N	3	30	2018-06-05 11:13:32.727	\N	\N
110953	Entlassmanagement_EntlassplanAktualisiert_Ne_Ar	\N	\N	3	30	2018-06-05 11:13:42.193	\N	\N
110954	Entlassmanagement_FolgendeDokumente_Brief_Ar	\N	\N	3	30	2018-06-05 11:13:54.273	\N	\N
110955	Entlassmanagement_FolgendeDokumente_Gespraech_Ar	\N	\N	3	30	2018-06-05 11:13:58.983	\N	\N
110974	_CO_Filter	\N	\N	37	0	2019-04-15 13:52:04.890	\N	\N
110984	_CO_Filter_Freitext	Filtervariable für Freitextsuche	\N	3	110974	2019-04-15 13:51:53.670	\N	\N
110986	B_CPP_kont	\N	\N	39	30	2018-05-16 09:14:17.530	\N	\N
111999	Entlassmanagement_Poststat_Versorgungsbedarf_U_Pf	\N	\N	3	30	2018-06-05 11:14:25.163	\N	\N
117214	DIVI_Visite_Beatmung	\N	\N	27	117131	\N	\N	\N
117215	DIVI_Visite_CAMICU	\N	\N	27	117131	\N	\N	\N
117216	DIVI_Visite_VMA	\N	\N	3	117131	\N	\N	\N
117217	Datenuebernahme_TestvariableBarVal	dient ausschließlich zu Testzwecken	\N	19	1	\N	\N	\N
117218	Beatmung_ES_G5_Body_Weight	\N	\N	6	1	\N	\N	\N
63	Medikamentenmischung_Einheit	Anzuzeigende Einheit für die Mischung. Danach richtet sich auch bei weiteren Gaben die Einstellmöglichkeit.	\N	3	60	2011-05-10 13:24:32.670	\N	\N
161	Del_Behandlung_INPULS_Beatmung_DRG_Minuten	zusätzliche Minuten der DRG-Beatmung	\N	2	130	2010-07-09 12:58:42.050	\N	\N
1344	DELETED_CO_Behandlung_MergeSource	\N	\N	53	30	2016-11-22 15:03:48.843	\N	\N
1345	DELETED_CO_Behandlung_MergeTarget	\N	\N	54	30	2016-11-22 15:03:48.843	\N	\N
100006	_UeberwiesenVonPOE	\N	\N	3	20	2009-08-17 16:05:56.170	\N	\N
100007	Ueberw.Von	\N	\N	3	20	2009-08-17 15:37:46.590	\N	\N
100039	KO	Körperoberfläche des Patienten	\N	6	1	2007-10-10 17:25:59.753	\N	\N
100040	Aufn.-Gewicht	Aufnahmegewicht des Patienten	kg	6	1	2007-10-10 17:18:47.073	\N	\N
100071	PC	Pulmonalkapillardruck	\N	12	1	2007-12-12 16:33:59.203	\N	\N
100087	PAP	Pulmunalarterieller Mitteldruck	mmHg	12	1	2007-12-12 14:26:32.130	\N	\N
100114	Beatmung_Anordnung_FiO2	Anordnung O²- Konzentration im Inspirationsgemisch (FiO2)	%	6	1	2007-08-28 07:20:40.897	\N	\N
100120	Katheter	\N	\N	21	1	2007-08-30 11:15:37.730	\N	\N
100121	Katheter_gelegt_am	\N	\N	5	100120	2007-08-30 11:15:29.213	\N	\N
100122	Katheter_Herkunft	\N	\N	3	100120	2007-08-30 11:15:25.197	\N	\N
100123	Katheter_Lage	\N	\N	3	100120	2007-08-30 11:15:33.713	\N	\N
100124	Katheter_Bezeichnung	\N	\N	3	100120	2007-08-30 11:15:20.853	\N	\N
100125	Katheter_Wert	\N	\N	25	100120	2007-08-30 11:15:16.010	\N	\N
100126	Katheter_Wert_String	\N	\N	3	100125	2007-08-30 11:15:12.493	\N	\N
100127	Beatmung_Anordnung_Beatmungsform	Anordnung der Beatmungsform	keine	3	1	2007-08-28 07:18:37.540	\N	\N
100130	_alt_Dekubitus	\N	\N	21	1	2007-08-30 09:37:47.340	\N	\N
100136	Dekubitus_Ort	\N	\N	3	100130	2007-08-30 09:37:47.340	\N	\N
100137	Dekubitus_Grad	\N	\N	3	100130	2007-08-30 09:37:47.357	\N	\N
100138	Dekubitus_Auftreten_Datum	\N	\N	5	100130	2007-08-30 09:37:47.373	\N	\N
100139	Dekubitus_Anordnung	\N	\N	3	100130	2007-08-30 09:37:47.390	\N	\N
100140	Dekubitus_Pflege	\N	\N	3	100130	2007-08-30 09:37:47.390	\N	\N
100141	Dekubitus_Beobachtung	\N	\N	3	100130	2007-08-30 09:37:47.403	\N	\N
100142	Dekubitus_Bilddokument_Vorhanden	\N	\N	3	100130	2007-08-30 09:37:47.420	\N	\N
100143	Dekubitus_Bildokument_Beschreibung	\N	\N	3	100130	2007-08-30 09:37:47.437	\N	\N
100144	Dekubitus_Sekretmenge	\N	\N	3	100130	2007-08-30 09:37:47.450	\N	\N
100145	Dekubitus_Wert	\N	\N	25	100130	2007-08-30 09:37:47.450	\N	\N
100148	st_Atemwege_Lage	\N	\N	3	100132	2007-09-06 11:23:23.353	\N	\N
100149	Atemwege_gelegt_am	\N	\N	5	100132	2007-09-26 10:36:44.300	\N	\N
100152	Atemwege_Wert_Num	\N	\N	3	100150	2007-08-30 10:35:32.870	\N	\N
100158	de_Drainagen_Sog	\N	cm H2O	6	100157	2007-09-06 11:53:18.600	\N	\N
100160	de_Atemwege_Wert_Num	\N	\N	6	100150	2007-09-06 11:19:00.623	\N	\N
100166	de_Enterale_Sonden_Wert_Num	\N	\N	6	100165	2007-09-06 12:38:30.953	\N	\N
100173	de_HarnwegeDarm_Wert_Num	\N	\N	6	100172	2007-09-06 12:38:21.690	\N	\N
100178	st_Zugaenge_gelegt_am	\N	\N	3	100131	2007-08-31 11:26:34.177	\N	\N
100187	de_Dekubitus_Wert_Num	\N	\N	6	100186	2007-09-06 11:46:11.093	\N	\N
100188	st_Dekubitus_Wert_String	\N	\N	3	100186	2007-09-06 11:46:00.513	\N	\N
100200	\N	\N	\N	3	0	2007-09-05 15:59:27.277	\N	\N
100205	de_Beatmung_Einstellung_IPPVFrequenz	\N	1/min	3	1	2007-09-05 16:34:37.220	\N	\N
100206	de_Beatmung_Einstellung_IE	:E (Atemzeitverhältnis	sek	3	0	2007-09-05 15:51:11.910	\N	\N
100207	de_Beatmung_Einstellung_Pmax	Pmax, Maximaldruck	mbar	3	0	2007-09-05 15:51:51.067	\N	\N
100208	de_Beatmung_Einstellung_intermPEEP	Interm PEEP	mbar	3	1	2007-09-05 16:34:12.503	\N	\N
100209	de_Beatmung_Einstellung_IE	I:E, Atemzeitvolumen	\N	3	1	2007-09-05 16:31:41.927	\N	\N
100210	de_Beatmung_Einstellung_Pmax	Pmax, Maximaldruck	mbar	3	0	2007-09-05 15:57:38.187	\N	\N
100211	de_Beatmung_Einstellung_IMVFrequenz	\N	1/min	3	1	2007-09-05 16:32:06.240	\N	\N
100212	de_Beatmung_Einstellung_CPAP	\N	mbar	3	1	2007-09-05 16:28:17.260	\N	\N
100213	de_Beatmung_Einstellung_MitteldruckHFOV	HFOV Mitteldruck	Paw-cmH2O	3	1	2007-09-05 16:35:36.033	\N	\N
100214	de_Beatmung_Einstellung_Leistung	\N	DeltaP-cmH2O	3	1	2007-09-05 16:35:07.237	\N	\N
100215	de_Beatmung_Einstellung_Inspirationszeit	Inspirationszeit in %	%	3	1	2007-09-05 16:32:40.100	\N	\N
100216	de_Beatmung_Einstellung_Pmax	Pmax, Maximaldruck	mbar	3	1	2007-09-05 16:36:31.593	\N	\N
100217	de_Beatmung_Einstellung_FrequenzHFOV	HFOV Frequenz	Hz	3	1	2007-09-05 16:30:12.150	\N	\N
100218	de_Beatmung_Einstellung_Power	HFOV Powereinstellung	Watt	3	1	2007-09-05 16:37:28.860	\N	\N
100219	de_Beatmung_Einstellung_Biasflow	HFOV	l/min	3	1	2007-09-05 16:27:04.310	\N	\N
100220	de_Beatmung_Einstellung_Peakflow	\N	l/min	3	1	2007-09-05 16:36:02.907	\N	\N
100221	de_Beatmung_Einstellung_FlowTrigger	\N	l/min	3	1	2007-09-05 16:29:36.570	\N	\N
100222	de_Beatmung_Einstellung_InspiratorischePause	I:E, Inspiratorische Pause	sec:sec	3	0	2007-09-05 16:06:08.690	\N	\N
100224	de_Beatmung_Einstellung_InspirationszeitIE	Inspirationszeit in Sekunden (I:E)	sec:sec	3	1	2007-09-05 16:33:14.800	\N	\N
100225	de_Beatmung_Einstellung_PSV	\N	cm/H2O	3	0	2007-09-05 16:06:46.580	\N	\N
100226	de_Beatmung_Einstellung_InspiratorischePause	Inspiratorische Pause (I:E)	sec:sec	3	1	2007-09-05 16:33:46.253	\N	\N
100227	de_Beatmung_Einstellung_PSV	\N	cmH2O	3	1	2007-09-05 16:38:13.670	\N	\N
100228	de_Beatmung_Einstellung_DruckHoch	\N	cmH2o	3	1	2007-09-05 16:28:46.307	\N	\N
100229	de_Beatmung_Einstellung_DruckNiedrig	\N	cmH2O	3	1	2007-09-05 16:29:11.710	\N	\N
100230	de_Beatmung_Einstellung_ZeitHoch	\N	sec	3	1	2007-09-05 16:38:58.077	\N	\N
100231	de_Beatmung_Einstellung_ZeitNiedrig	\N	sec	3	1	2007-09-05 16:39:24.200	\N	\N
100232	de_Beatmung_Einstellung_idealesKoerpergewicht	\N	KG	3	1	2007-09-05 16:31:13.930	\N	\N
100252	de_Beatmung_Einstellung_IE	I:E, Atemzeitvolumen	\N	6	1	2007-09-05 16:48:58.423	\N	\N
100256	Beatmung_Einstellung_InspirationszeitIE	Inspirationszeit in Sekunden (I:E)	sec:sec	6	1	2007-12-15 12:37:25.040	\N	\N
100308	st_Atemwege_Pflege	\N	\N	6	100150	2007-09-06 12:05:36.273	\N	\N
100310	st_Drainagen_Nullpunkt	\N	cm	3	100186	2007-09-06 11:46:17.373	\N	\N
100355	KlinikKopf_Auge_Inspektion	\N	\N	3	100346	2007-10-04 09:01:22.703	\N	\N
100316	12345678901234567890123456789012345678901234567890	\N	\N	3	1	2007-09-06 11:37:54.023	\N	\N
100317	123456789012345678901234	\N	\N	1	0	2007-09-06 11:39:41.850	\N	\N
100328	de_Drainagen_Beobachtung_Sekret	\N	\N	3	100157	2007-09-06 12:27:02.983	\N	\N
100329	st_Atemwege_Pflege	\N	\N	3	30	2007-09-06 12:23:53.673	\N	\N
100351	KlinikKopf_Auge_Allgemein	\N	\N	3	100346	2007-10-04 08:53:49.790	\N	\N
100352	KlinikKopf_Auge_Hintergurnd	\N	\N	3	100346	2007-10-04 08:54:10.053	\N	\N
100353	st_KlinikKopf_Auge_Befragung	\N	\N	3	100345	2007-09-10 11:36:31.353	\N	\N
100354	KlinikKopf_Auge_Befragung	\N	\N	3	100346	2007-10-04 09:01:17.327	\N	\N
100367	\N	\N	\N	3	0	2007-09-12 12:51:23.180	\N	\N
100562	PT_AllgBefund_AZ	Allgemeinzustand	\N	3	100561	2007-09-14 15:52:32.963	\N	\N
100563	PT_AllgBefund_Bewusstseinslage	\N	\N	3	100561	2007-09-14 15:55:01.350	\N	\N
100568	PT_AllgBefund_PartizipationMobilitaetHilfe	\N	\N	3	0	2007-09-14 15:44:45.670	\N	\N
100572	PT_AllgBefund_Partizipation_FortbewegungMeter	\N	\N	3	100561	2007-09-17 08:58:31.160	\N	\N
100573	PT_AllgBefund_Partizipation_FortbewegungStufen	\N	\N	3	100561	2007-09-17 08:59:47.143	\N	\N
100574	PT_AllgBefund_Partizipation_FortbewegungStockwerk	\N	\N	3	100561	2007-09-17 08:59:07.940	\N	\N
100587	PT_AllgBefund_Koerper_BelastbarkeitKg	\N	\N	3	0	2007-09-14 16:31:57.027	\N	\N
100591	PT_AllgBefund_Organe_Wert	\N	\N	25	100560	2007-09-14 16:25:40.200	\N	\N
100592	PT_AllgBefund_Organe_Oedeme	\N	\N	3	100591	2007-09-14 16:25:40.200	\N	\N
100593	PT_AllgBefund_Organe_Herz	\N	\N	3	100591	2007-09-14 16:25:40.230	\N	\N
100594	PT_AllgBefund_Organe_HerzPuls	\N	\N	3	100591	2007-09-14 16:25:40.260	\N	\N
100595	PT_AllgBefund_Organe_HerzRR	\N	\N	3	100591	2007-09-14 16:25:40.277	\N	\N
100596	PT_AllgBefund_Organe_Atmung	\N	\N	3	100591	2007-09-14 16:22:23.683	\N	\N
100597	PT_AllgBefund_Organe_Durchblutung	\N	\N	3	100591	2007-09-14 16:25:40.310	\N	\N
100598	PT_AllgBefund_Organe_BelastbarkeitHF	\N	\N	3	100591	2007-09-14 16:25:40.340	\N	\N
100599	PT_AllgBefund_Organe_BelastbarkeitRR	\N	\N	3	100591	2007-09-14 16:25:40.357	\N	\N
100600	PT_AllgBefund_Organe_BelastbarkeitAF	\N	\N	3	100591	2007-09-14 16:22:27.873	\N	\N
100624	PT_AllgBefund_Koerper_Bewegkont_SensoWahrnehmung	\N	\N	3	0	2007-09-14 16:53:15.080	\N	\N
100639	Dekubitus_vorhanden	\N	\N	2	1	2007-09-18 11:24:16.923	\N	\N
100706	PT_KoerperstrukturInnereOrgane_Wert	\N	\N	3	100694	2007-09-24 07:47:48.010	\N	\N
100715	PT_KoerperstrukturInnereOrgane_BelastbarkeitRR	\N	\N	3	100707	2007-09-24 09:02:53.167	\N	\N
100716	PT_KoerperstrukturInnereOrgane_BelastbarkeitAF	\N	\N	3	100707	2007-09-24 09:03:27.700	\N	\N
100744	PT_Kontextfaktoren_Wert	\N	\N	3	100742	2007-09-24 08:08:39.840	\N	\N
100756	HarnwegeDarm_Mengeml	\N	ml	6	100165	2007-09-24 10:09:07.217	\N	\N
100765	Atemwege_vorhanden	\N	\N	3	100132	2007-09-25 08:45:42.733	\N	\N
100780	Beatmung_O2_Balken	\N	%	3	1	2007-09-25 14:57:04.310	\N	\N
100789	IstPflege_Befind_Hoergeraetrechts	\N	\N	2	30	2007-10-24 12:28:22.760	\N	\N
100792	IstPflege_Befind_Zahnspangeoben	\N	\N	2	30	2007-10-24 12:31:46.023	\N	\N
100793	IstPflege_Befind_ZahnProthese	\N	\N	2	30	2007-10-24 12:39:57.530	\N	\N
100810	Atmung_Intubation	\N	\N	3	1	2007-09-26 10:33:12.237	\N	\N
100811	Atmung_Extubation	\N	\N	3	1	2007-09-26 10:36:04.953	\N	\N
100812	Atmung_Atemform	\N	\N	3	1	2007-09-26 10:33:19.017	\N	\N
100808	Sauerstoff_Balken	\N	\N	19	1	\N	\N	\N
100876	VerlPfl_Befind_HoergeraetLi	\N	\N	2	30	2007-10-24 13:35:41.027	\N	\N
100879	VerlPfl_Befind_ZahnspangeOben	\N	\N	2	30	2007-10-24 13:35:30.607	\N	\N
100880	VerlPfl_Befind_ZahnprotheseOben	\N	\N	2	30	2007-10-24 13:35:18.357	\N	\N
100904	VerlegPfl_StationstelNr	Tel.nr.angabe wg. Rückfragen zu Verleg.Bericht Pflege	\N	3	1	2008-01-03 11:21:06.867	\N	\N
100906	VerlegPfl_Name_Verlegender	"Unterschriftsfeld" unter Verlegungsformular Pflege	\N	3	1	2008-01-03 11:20:32.850	\N	\N
100913	PflVerleg_persoenlAspekte_Bemerk	\N	\N	3	0	2007-10-02 06:38:07.657	\N	\N
100952	KlinikHals	\N	\N	21	1	2007-12-10 07:21:33.903	\N	\N
100953	KlinikHals_Haut_Wert	\N	\N	25	100952	2007-12-10 07:21:14.450	\N	\N
100954	KlinikHals_Haut_Allgemein	\N	\N	3	100952	2007-10-04 09:35:03.320	\N	\N
100955	KlinikHals_Haut_Inspektion	\N	\N	3	100952	2007-10-04 09:35:22.553	\N	\N
100956	KlinikHals_Haut_Befragung	\N	\N	3	100953	2007-12-10 07:21:14.450	\N	\N
100957	KlinikHals_Haut_Allgemein	\N	\N	3	100953	2007-12-10 07:21:14.527	\N	\N
100958	KlinikHals_Haut_Inspektion	\N	\N	3	100953	2007-12-10 07:21:14.573	\N	\N
100959	KlinikHals_Haut_Tracheostoma	\N	\N	3	100953	2007-12-10 07:21:14.717	\N	\N
100960	KlinikHals_Haut_Verletzungen	\N	\N	3	100953	2007-12-10 07:21:14.760	\N	\N
100961	KlinikHals_Haut_Verband	\N	\N	3	100953	2007-12-10 07:21:14.823	\N	\N
100962	KlinikHals_Haut_DrainageKatheter	\N	\N	3	100953	2007-12-10 07:21:14.870	\N	\N
100963	KlinikHals_Haut_Sekret	\N	\N	3	100953	2007-12-10 07:21:14.933	\N	\N
100964	KlinikHals_Haut_Palpation	\N	\N	3	100953	2007-12-10 07:21:14.980	\N	\N
100998	KlinikThorax_Stamm	\N	\N	25	1	2007-10-04 10:30:19.273	\N	\N
101001	KlinikUntereExtraemitaet	\N	\N	21	1	2007-12-10 09:27:59.900	\N	\N
101002	KlinikLeiste	\N	\N	21	1	2007-12-10 07:40:14.927	\N	\N
101003	KlinikHerzFunktion	\N	\N	21	1	2007-12-10 08:44:58.683	\N	\N
101004	KlinikKreislaufFunktion	\N	\N	21	1	2007-12-10 08:45:12.760	\N	\N
101005	KlinikAtmungsFunktion	\N	\N	21	1	2007-12-10 08:44:50.277	\N	\N
101006	KlinikWasserhaushalt	\N	\N	21	1	2007-12-10 08:45:20.433	\N	\N
101011	KlinikStamm_Bauchhaut_Wert	\N	\N	3	100999	2007-10-04 10:43:14.023	\N	\N
101020	KlinikUntereExtraemitaet_Haut_Wert	\N	\N	25	101001	2007-12-10 09:27:59.900	\N	\N
101021	KlinikLeiste_Haut_Wert	\N	\N	25	101002	2007-12-10 07:40:14.927	\N	\N
101022	KlinikHerzFunktion_Reizbildung_Wert	\N	\N	25	101003	2007-12-10 08:44:58.683	\N	\N
101023	KlinikHerzFunktion_Kammerfuellung_Wert	\N	\N	25	101003	2007-12-10 08:45:01.323	\N	\N
101024	KlinikKreislaufFunktion_Makrozirkulation_Wert	\N	\N	25	101004	2007-12-10 08:45:12.760	\N	\N
101025	KlinikKreislaufFunktion_Mikrozirkulation_Wert	\N	\N	25	101004	2007-12-10 08:45:13.200	\N	\N
101026	KlinikAtmungsFunktion_Oxygenation_Wert	\N	\N	25	101005	2007-12-10 08:44:50.310	\N	\N
101027	KlinikAtmungsFunktion_CO2_Wert	\N	\N	25	101005	2007-10-05 13:02:44.337	\N	\N
101028	KlinikAtmungsFunktion_Atemform_Wert	\N	\N	25	101005	2007-12-10 08:44:50.700	\N	\N
101029	KlinikWasserhaushalt_Wasserhaushalt_Wert	\N	\N	25	101006	2007-12-10 08:45:20.433	\N	\N
101039	KlinikKopf_Halshaut_Wert	\N	\N	25	100345	2007-10-05 12:34:51.570	\N	\N
101040	KlinikKopf_Halshaut_Allgemein	\N	\N	3	101039	2007-10-05 12:34:51.570	\N	\N
101041	KlinikKopf_Halshaut_Inspektion	\N	\N	3	101039	2007-10-05 12:34:51.617	\N	\N
101042	KlinikKopf_Halshaut_Befragung	\N	\N	3	101039	2007-10-05 12:34:51.663	\N	\N
101043	KlinikKopf_Halshaut_Tracheostoma	\N	\N	3	101039	2007-10-05 12:34:51.697	\N	\N
101044	KlinikKopf_Halshaut_Verletzungen	\N	\N	3	101039	2007-10-05 12:34:51.743	\N	\N
101045	KlinikKopf_Halshaut_Verband	\N	\N	3	100953	2007-12-10 07:20:35.340	\N	\N
101046	KlinikKopf_Halshaut_DrainagenKatheter	\N	\N	3	101039	2007-10-05 12:34:51.790	\N	\N
101047	KlinikKopf_Halshaut_Sekret	\N	\N	3	101039	2007-10-05 12:34:51.837	\N	\N
101048	KlinikKopf_Halshaut_Palpation	\N	\N	3	101039	2007-10-05 12:34:51.867	\N	\N
101049	KlinikKopf_ThoraxHaut_Wert	\N	\N	25	100345	2007-10-05 12:36:59.600	\N	\N
101050	KlinikKopf_ThoraxHaut_Allgemein	\N	\N	3	101049	2007-10-05 12:36:59.600	\N	\N
101051	KlinikKopf_ThoraxHaut_Befragung	\N	\N	3	101049	2007-10-05 12:36:59.647	\N	\N
101052	KlinikKopf_ThoraxHaut_Drainage	\N	\N	3	101049	2007-10-05 12:36:59.693	\N	\N
101053	KlinikKopf_ThoraxHaut_Inspektion	\N	\N	3	101049	2007-10-05 12:36:59.740	\N	\N
101054	KlinikKopf_ThoraxHaut_Palpation	\N	\N	3	101049	2007-10-05 12:36:59.770	\N	\N
101055	KlinikKopf_ThoraxHaut_Sekret	\N	\N	3	101049	2007-10-05 12:36:59.817	\N	\N
101056	KlinikKopf_ThoraxHaut_Sensibilitaet	\N	\N	3	101049	2007-10-05 12:36:59.880	\N	\N
101057	KlinikKopf_ThoraxHaut_Verband	\N	\N	3	101049	2007-10-05 12:36:59.927	\N	\N
101058	KlinikKopf_ThoraxHaut_Verletzung	\N	\N	3	101049	2007-10-05 12:36:59.973	\N	\N
101059	KlinikKopf_Thoraxwand_Wert	\N	\N	25	100345	2007-10-05 12:37:04.973	\N	\N
101060	KlinikKopf_Thoraxwand_Allgemein	\N	\N	3	101059	2007-10-05 09:21:38.517	\N	\N
101061	KlinikKopf_Thoraxwand_Allgemein	\N	\N	3	101059	2007-10-05 12:37:04.973	\N	\N
101062	KlinikKopf_Thoraxwand_Atmung	\N	\N	3	101059	2007-10-05 12:37:05.037	\N	\N
101063	KlinikKopf_Thoraxwand_Befragung	\N	\N	3	101059	2007-10-05 12:37:05.083	\N	\N
101064	KlinikKopf_Thoraxwand_Inspektion	\N	\N	3	101059	2007-10-05 12:37:05.113	\N	\N
101065	KlinikKopf_Thoraxwand_Palpation	\N	\N	3	101059	2007-10-05 12:37:05.147	\N	\N
101066	KlinikKopf_Lungen_Wert	\N	\N	25	100345	2007-10-05 12:08:31.227	\N	\N
101067	KlinikKopf_Lungen_Allgemein	\N	\N	3	101066	2007-10-05 12:08:31.243	\N	\N
101068	KlinikKopf_Lungen_Auskultation	\N	\N	3	101066	2007-10-05 12:08:31.273	\N	\N
101069	KlinikKopf_Lungen_Befragung	\N	\N	3	101066	2007-10-05 12:08:31.320	\N	\N
101070	KlinikKopf_Lungen_Grenzen	\N	\N	3	101066	2007-10-05 12:08:31.367	\N	\N
101071	KlinikKopf_Lungen_Inspektion	\N	\N	3	101066	2007-10-05 12:08:31.400	\N	\N
101072	KlinikKopf_Lungen_Perkussion	\N	\N	3	101066	2007-10-05 12:08:31.447	\N	\N
101073	KlinikKopf_Herz_Wert	\N	\N	25	100345	2007-10-05 12:35:02.760	\N	\N
101074	KlinikKopf_Herz_Allgemein	\N	\N	3	101073	2007-10-05 12:35:02.760	\N	\N
101075	KlinikKopf_Herz_Auskultation	\N	\N	3	101073	2007-10-05 12:35:02.807	\N	\N
101076	KlinikKopf_Herz_Befragung	\N	\N	3	101073	2007-10-05 12:35:02.853	\N	\N
101077	KlinikKopf_Herz_Palpation	\N	\N	3	101073	2007-10-05 12:35:02.883	\N	\N
101078	KlinikKopf_Herz_Perkussion	\N	\N	3	101073	2007-10-05 12:35:02.960	\N	\N
101079	KlinikKopf_Herz_Reizbildung	\N	\N	3	101073	2007-10-05 12:35:02.993	\N	\N
101082	KlinikKopf_Herz_Reizleitung	\N	\N	3	101073	2007-10-05 12:35:03.040	\N	\N
101083	KlinikKopf_Herz_Ektopie	\N	\N	3	101073	2007-10-05 12:35:03.070	\N	\N
101084	KlinikKopf_Herz_Erregungsrueckbildung	\N	\N	3	101073	2007-10-05 12:35:03.117	\N	\N
101085	KlinikKopf_Bauchhaut_Wert	\N	\N	25	100345	2007-10-05 12:34:11.273	\N	\N
101086	KlinikKopf_Bauchhaut_Allgemein	\N	\N	3	101085	2007-10-05 12:34:11.273	\N	\N
101087	KlinikKopf_Bauchhaut_Befragung	\N	\N	3	101085	2007-10-05 12:34:11.337	\N	\N
101088	KlinikKopf_Bauchhaut_Drainage	\N	\N	3	101085	2007-10-05 12:34:11.383	\N	\N
101089	KlinikKopf_Bauchhaut_Inspektion	\N	\N	3	101085	2007-10-05 12:34:11.430	\N	\N
101090	KlinikKopf_Bauchhaut_Palpation	\N	\N	3	101085	2007-10-05 12:34:11.493	\N	\N
101091	KlinikKopf_Bauchhaut_Sekret	\N	\N	3	101085	2007-10-05 12:34:11.540	\N	\N
101093	KlinikKopf_Bauchhaut_Stoma	\N	\N	3	101085	2007-10-05 12:34:11.587	\N	\N
101094	KlinikKopf_Bauchhaut_Urinableitung	\N	\N	3	101085	2007-10-05 12:34:11.633	\N	\N
101095	KlinikKopf_Bauchhaut_Verband	\N	\N	3	101085	2007-10-05 12:34:11.663	\N	\N
101096	KlinikKopf_Bauchhaut_Verletzung	\N	\N	3	101085	2007-10-05 12:34:11.710	\N	\N
101097	KlinikKopf_Bauchwand_Wert	\N	\N	25	100345	2007-10-05 12:34:16.603	\N	\N
101098	KlinikKopf_Bauchwand_Allgemein	\N	\N	3	101097	2007-10-05 12:34:16.617	\N	\N
101099	KlinikKopf_Bauchwand_Auskultation	\N	\N	3	101097	2007-10-05 12:34:16.663	\N	\N
101100	KlinikKopf_Bauchwand_Befragung	\N	\N	3	101097	2007-10-05 12:34:16.697	\N	\N
101101	KlinikKopf_Bauchwand_Inspektion	\N	\N	3	101097	2007-10-05 12:34:16.773	\N	\N
101102	KlinikKopf_Bauchwand_Palpation	\N	\N	3	101097	2007-10-05 12:34:16.820	\N	\N
101103	KlinikKopf_Bauchwand_Perkussion	\N	\N	3	101097	2007-10-05 12:34:16.867	\N	\N
101104	KlinikKopf_Leber_Wert	\N	\N	25	100345	2007-10-05 12:35:33.100	\N	\N
101105	KlinikKopf_Leber_Allgemein	\N	\N	3	101104	2007-10-05 12:35:33.100	\N	\N
101106	KlinikKopf_Leber_Befragung	\N	\N	3	101104	2007-10-05 12:35:33.163	\N	\N
101107	KlinikKopf_Leber_Drainage	\N	\N	3	101104	2007-10-05 12:35:33.210	\N	\N
101108	KlinikKopf_Leber_Palpation	\N	\N	3	101104	2007-10-05 12:35:33.257	\N	\N
101109	KlinikKopf_Leber_Perkussion	\N	\N	3	101104	2007-10-05 12:35:33.290	\N	\N
101110	KlinikKopf_Leber_Sekret	\N	\N	3	101104	2007-10-05 12:35:33.337	\N	\N
101111	KlinikKopf_Leber_Ultraschall	\N	\N	3	101104	2007-10-05 12:35:33.367	\N	\N
101112	KlinikKopf_Ureta_Wert	\N	\N	25	100345	2007-10-05 12:37:09.570	\N	\N
101113	KlinikKopf_Ureta_Allgemein	\N	\N	3	101112	2007-10-05 12:37:09.570	\N	\N
101114	KlinikKopf_Ureta_Befragung	\N	\N	3	101112	2007-10-05 12:37:09.617	\N	\N
101115	KlinikKopf_Ureta_Inspektion	\N	\N	3	101112	2007-10-05 12:37:09.663	\N	\N
101116	KlinikKopf_Ureta_Urin	\N	\N	3	101112	2007-10-05 12:37:09.693	\N	\N
101117	KlinikKopf_ObereExtraemHaut_Wert	\N	\N	25	100345	2007-10-05 12:36:27.727	\N	\N
101118	KlinikKopf_obereExtraem.Haut_Allgemein	\N	\N	3	101117	2007-10-05 12:36:27.727	\N	\N
101119	KlinikKopf_obereExtraem.Haut_Befragung	\N	\N	3	101117	2007-10-05 12:36:27.773	\N	\N
101120	KlinikKopf_obereExtraem.Haut_DrainageZugaenge	\N	\N	3	101117	2007-10-05 12:36:27.803	\N	\N
101121	KlinikKopf_obereExtraem.Haut_Inspektion	\N	\N	3	101117	2007-10-05 12:36:27.850	\N	\N
101122	KlinikKopf_obereExtraem.Haut_Palpation	\N	\N	3	101117	2007-10-05 12:36:27.897	\N	\N
101123	KlinikKopf_obereExtraem.Haut_Schienung	\N	\N	3	101117	2007-10-05 12:36:27.943	\N	\N
101124	KlinikKopf_obereExtraem.Haut_Sekret	\N	\N	3	101117	2007-10-05 12:36:27.977	\N	\N
101125	KlinikKopf_obereExtraem.Haut_Sensibilitaet	\N	\N	3	101117	2007-10-05 12:36:28.023	\N	\N
101126	KlinikKopf_obereExtraem.Haut_Verband	\N	\N	3	101117	2007-10-05 12:36:28.070	\N	\N
101127	KlinikKopf_obereExtraem.Haut_Verletzung	\N	\N	3	101117	2007-10-05 12:36:28.100	\N	\N
101128	KlinikKopf_Haut_Wert	\N	\N	25	100345	2007-10-05 12:34:57.850	\N	\N
101129	KlinikKopf_Haut_Allgemein	\N	\N	3	101128	2007-10-05 12:34:57.867	\N	\N
101130	KlinikKopf_Haut_Befragung	\N	\N	3	101128	2007-10-05 12:34:57.913	\N	\N
101131	KlinikKopf_Haut_Doppleruntersuchung	\N	\N	3	101128	2007-10-05 12:34:57.960	\N	\N
101132	KlinikKopf_Haut_DrainageZugaenge	\N	\N	3	101128	2007-10-05 12:34:57.990	\N	\N
101133	KlinikKopf_Haut_Inspektion	\N	\N	3	101128	2007-10-05 12:34:58.040	\N	\N
101134	KlinikKopf_Haut_Palpation	\N	\N	3	101128	2007-10-05 12:34:58.087	\N	\N
101135	KlinikKopf_Haut_Schienung	\N	\N	3	101128	2007-10-05 12:34:58.133	\N	\N
101136	KlinikKopf_Haut_Sekret	\N	\N	3	101128	2007-10-05 12:34:58.163	\N	\N
101137	KlinikKopf_Haut_Sensibilitaet	\N	\N	3	101128	2007-10-05 12:34:58.227	\N	\N
101138	KlinikKopf_Haut_Verband	\N	\N	3	101128	2007-10-05 12:34:58.257	\N	\N
101139	KlinikKopf_Haut_Verletzung	\N	\N	3	101128	2007-10-05 12:34:58.303	\N	\N
101140	KlinikKopf_LeisteHaut_Wert	\N	\N	25	100345	2007-10-05 12:35:47.397	\N	\N
101141	KlinikKopf_LeisteHaut_Allgemein	\N	\N	3	101140	2007-10-05 12:35:47.397	\N	\N
101142	KlinikKopf_LeisteHaut_Befragung	\N	\N	3	101140	2007-10-05 12:35:47.460	\N	\N
101143	KlinikKopf_LeisteHaut_Drainage	\N	\N	3	101140	2007-10-05 12:35:47.490	\N	\N
101144	KlinikKopf_LeisteHaut_Inspektion	\N	\N	3	101140	2007-10-05 12:35:47.537	\N	\N
101145	KlinikKopf_LeisteHaut_Palpation	\N	\N	3	101140	2007-10-05 12:35:47.570	\N	\N
101146	KlinikKopf_LeisteHaut_Sekret	\N	\N	3	101140	2007-10-05 12:35:47.617	\N	\N
101147	KlinikKopf_LeisteHaut_Sensibilitaet	\N	\N	3	101140	2007-10-05 12:35:47.663	\N	\N
101148	KlinikKopf_LeisteHaut_Verband	\N	\N	3	101140	2007-10-05 12:35:47.693	\N	\N
101150	KlinikKopf_LeisteHaut_Verletzung	\N	\N	3	101140	2007-10-05 12:35:47.757	\N	\N
101151	KlinikKopf_ReizbildungReizleitung_Wert	\N	\N	25	100345	2007-10-05 12:36:48.380	\N	\N
101152	KlinikKopf_ReizbildungReizleitung_Allgemein	\N	\N	3	101151	2007-10-05 12:36:48.397	\N	\N
101153	KlinikKopf_Makrozirkulation_Wert	\N	\N	25	100345	2007-10-05 12:35:50.367	\N	\N
101154	KlinikKopf_Makrozirkulation_SystolischerBlutdruck	\N	\N	3	101153	2007-10-05 12:35:50.383	\N	\N
101155	KlinikKopf_Makrozirkulation_DiastolischerBlutdruck	\N	\N	3	101153	2007-10-05 12:35:50.413	\N	\N
101156	KlinikKopf_Makrozirkulation_Allgemein	\N	\N	3	101153	2007-10-05 12:35:50.460	\N	\N
101157	KlinikKopf_Makrozirkulation_Herzfrequenz	\N	\N	3	101153	2007-10-05 12:35:50.490	\N	\N
101158	KlinikKopf_Makrozirkulation_Pulse	\N	\N	3	101153	2007-10-05 12:35:50.553	\N	\N
101159	KlinikKopf_Kammerfuellung_Wert	\N	\N	25	100345	2007-10-05 12:35:13.697	\N	\N
101162	KlinikKopf_Kammerfuellung_ZVD	\N	\N	3	101159	2007-10-05 12:35:13.697	\N	\N
101163	KlinikKopf_Mikrozirkulation_Wert	\N	\N	25	100345	2007-10-05 12:35:53.443	\N	\N
101164	KlinikKopf_Mikrozirkulation_Allgemein	\N	\N	3	101163	2007-10-05 12:35:53.443	\N	\N
101165	KlinikKopf_Oxygenation_Wert	\N	\N	25	100345	2007-10-05 12:36:31.460	\N	\N
101166	KlinikKopf_Oxygenation_Allgemein	\N	\N	3	101165	2007-10-05 12:36:31.460	\N	\N
101167	KlinikKopf_Oxygenation_paO2	\N	\N	3	101165	2007-10-05 12:36:31.507	\N	\N
101168	KlinikKopf_Oxygenation_OxygenierungsindexpaO2fiO2	\N	\N	3	101165	2007-10-05 12:36:31.553	\N	\N
101170	KlinikKopf_Atemform_Wert	\N	\N	25	100345	2007-10-05 12:34:01.963	\N	\N
101171	KlinikKopf_Atemform_Atemform	\N	\N	3	101170	2007-10-05 12:34:01.963	\N	\N
101172	KlinikKopf_Schweissproduktion_Wert	\N	\N	25	100345	2007-10-05 12:36:56.723	\N	\N
101173	KlinikKopf_Schweissproduktion_Schweissproduktion	\N	\N	3	101172	2007-10-05 12:36:56.740	\N	\N
101174	KlinikKopf_CO2Elimination_Wert	\N	\N	25	100345	2007-10-05 12:34:42.477	\N	\N
101175	KlinikKopf_CO2Elimination_Allgemein	\N	\N	3	101174	2007-10-05 12:34:42.477	\N	\N
101176	KlinikKopf_CO2Elimination_paCO2	\N	\N	3	101174	2007-10-05 12:34:42.523	\N	\N
101177	KlinikKopf_Kerntemperatur_Wert	\N	\N	25	100345	2007-10-05 12:35:29.540	\N	\N
101178	KlinikKopf_Kerntemperatur_Kerntemperatur	\N	\N	3	101177	2007-10-05 12:35:29.540	\N	\N
101179	KlinikKopf_ZNSBewusstsein_Wert	\N	\N	25	100345	2007-10-05 12:37:12.270	\N	\N
101180	KlinikKopf_ZNSBewusstsein_Sedierung	\N	\N	3	101179	2007-10-05 12:37:12.270	\N	\N
101181	KlinikKopf_ZNSBewusstsein_GlasgowKomaScore	\N	\N	3	101179	2007-10-05 12:37:12.333	\N	\N
101182	KlinikKopf_ZNSBewusstsein_Ramsey	\N	\N	3	101179	2007-10-05 12:37:12.363	\N	\N
101183	KlinikKopf_ZNSOrientierung_Wert	\N	\N	25	100345	2007-10-05 12:37:21.380	\N	\N
101184	KlinikKopf_ZNSOrientierung_Orientierung	\N	\N	3	101183	2007-10-05 12:37:21.380	\N	\N
101185	KlinikKopf_ZNSReflexstatus_Wert	\N	\N	25	100345	2007-10-05 12:37:24.553	\N	\N
101186	KlinikKopf_ZNSReflexstatus_Allgemein	\N	\N	3	101185	2007-10-05 12:37:24.553	\N	\N
101187	KlinikKopf_ZNSReflexstatus_Hirnstammreflexe	\N	\N	3	101185	2007-10-05 12:37:24.613	\N	\N
101188	KlinikKopf_ZNSReflexstatus_Muskeleigenreflexe	\N	\N	3	101185	2007-10-05 12:37:24.660	\N	\N
101189	KlinikKopf_ZNSReflexstatus_VegetativeReflexe	\N	\N	3	101185	2007-10-05 12:37:24.693	\N	\N
101190	\N	\N	\N	3	0	2007-10-05 10:41:55.553	\N	\N
101191	KlinikKopf_ZNSReflexstatus_Fluchtreaktion	\N	\N	3	101185	2007-10-05 12:37:24.723	\N	\N
101192	KlinikKopf_ZNSReflexstatus_Pyramidenbahnzeichen	\N	\N	3	101185	2007-10-05 12:37:24.803	\N	\N
101193	KlinikKopf_ZNSReflexstatus_PathologischeReflexe	\N	\N	3	101185	2007-10-05 12:37:24.850	\N	\N
101194	KlinikKopf_ZNSHirnnerven_Wert	\N	\N	25	100345	2007-10-05 12:37:15.693	\N	\N
101195	KlinikKopf_ZNSHirnnerven_Allgemein	\N	\N	3	101194	2007-10-05 12:37:15.710	\N	\N
101196	KlinikKopf_PeriphereNervenMotorik_Wert	\N	\N	25	100345	2007-10-05 12:36:37.380	\N	\N
101197	KlinikKopf_periphereNervenMotorik_Allgemein	\N	\N	3	101196	2007-10-05 12:36:37.380	\N	\N
101198	KlinikKopf_PeriphereNervenSensibilitaet_Wert	\N	\N	25	100345	2007-10-05 12:36:44.240	\N	\N
101199	KlinikKopf_periphereNervenSensibilitaet_Allgemein	\N	\N	3	101198	2007-10-05 12:36:44.240	\N	\N
101201	KlinikKopf_Oxygenation_PulsoxyO2saettigung	\N	\N	3	101165	2007-10-05 12:36:31.600	\N	\N
101202	KlinikKopf_Kammerfuellung_LiArtDiastolischerDruck	\N	\N	3	101159	2007-10-05 12:35:13.760	\N	\N
101204	KlinikKopf_Kammerfuellung_PulmoKapillaererVerdruck	\N	\N	3	101159	2007-10-05 12:35:13.790	\N	\N
101243	KlinikLeiste_Haut_Allgemein	\N	\N	3	101021	2007-12-10 07:40:14.927	\N	\N
101244	KlinikLeiste_Haut_Befragung	\N	\N	3	101021	2007-12-10 07:40:14.973	\N	\N
101245	KlinikLeiste_Haut_Drainage	\N	\N	3	101021	2007-12-10 07:40:15.037	\N	\N
101246	KlinikLeiste_Haut_Inspektion	\N	\N	3	101021	2007-12-10 07:40:15.083	\N	\N
101247	KlinikLeiste_Haut_Palpation	\N	\N	3	101021	2007-12-10 07:40:15.143	\N	\N
101248	KlinikLeiste_Haut_Sekret	\N	\N	3	101021	2007-12-10 07:40:15.207	\N	\N
101249	KlinikLeiste_Haut_Sensibilitaet	\N	\N	3	101021	2007-12-10 07:40:15.253	\N	\N
101250	KlinikLeiste_Haut_Verband	\N	\N	3	101021	2007-12-10 07:40:15.317	\N	\N
101251	KlinikLeiste_Haut_Verletzung	\N	\N	3	101021	2007-12-10 07:40:15.363	\N	\N
101252	KlinikHerzFunktion_Kammerfuellung_ZVD	\N	\N	3	101023	2007-12-10 08:45:01.323	\N	\N
101253	KlinikKreislaufFunktion_Makrozirkulation_Allgemein	\N	\N	3	101024	2007-12-10 08:45:12.760	\N	\N
101258	KlinikKreislaufFunktion_Makrozirkulation_Pulse	\N	\N	3	101024	2007-12-10 08:45:12.840	\N	\N
101259	KlinikKreislaufFunktion_Mikrozirkulation_Allgemein	\N	\N	3	101025	2007-12-10 08:45:13.213	\N	\N
101260	KlinikAtmungsFunktion_Atemform_Atemform	\N	\N	3	101028	2007-12-10 08:44:50.870	\N	\N
101261	KlinikAtmungsFunktion_CO2_Allgemein	\N	\N	3	101005	2007-10-05 12:56:53.623	\N	\N
101262	KlinikAtmungsFunktion_CO2_PaCO2	\N	\N	3	101027	2007-10-05 13:02:44.337	\N	\N
101263	KlinikAtmungsFunktion_CO2_Allgemein	\N	\N	3	101027	2007-10-05 13:02:44.383	\N	\N
101264	KlinikAtmungsFunktion_Oxygenation_Allgemein	\N	\N	3	101026	2007-12-10 08:44:50.323	\N	\N
101265	KlinikAtmungsFunktion_Oxygenation_PaCO2	\N	\N	3	101027	2007-10-05 13:02:44.413	\N	\N
101268	KlinikAtmungsFunktion_CO2_Wert	\N	\N	3	101005	2007-10-05 13:03:26.833	\N	\N
101269	KlinikAtmungsFunktion_CO2_Wert	\N	\N	25	101005	2007-12-10 08:44:51.010	\N	\N
101270	KlinikAtmungsFunktion_CO2_Allgemein	\N	\N	3	101269	2007-12-10 08:44:51.010	\N	\N
101271	KlinikAtmungsFunktion_CO2_PaCO2	\N	\N	3	101269	2007-12-10 08:44:51.073	\N	\N
101272	KlinikAtmungsFunktion_Oxygenation_PaO2	\N	\N	3	101026	2007-12-10 08:44:50.450	\N	\N
101291	KlinikUntereExtraemitaet_Haut_Allgemein	\N	\N	3	101020	2007-12-10 09:27:59.900	\N	\N
101292	KlinikUntereExtraemitaet_Haut_Befragung	\N	\N	3	101020	2007-12-10 09:27:59.963	\N	\N
101293	KlinikUntereExtraemitaet_Haut_Doppleruntersuchung	\N	\N	3	101020	2007-12-10 09:28:00.027	\N	\N
101294	KlinikUntereExtraemitaet_Haut_DrainageZugaenge	\N	\N	3	101020	2007-12-10 09:28:00.087	\N	\N
101295	KlinikUntereExtraemitaet_Haut_Inspektion	\N	\N	3	101020	2007-12-10 09:28:00.167	\N	\N
101296	KlinikUntereExtraemitaet_Haut_Palpation	\N	\N	3	101020	2007-12-10 09:28:00.260	\N	\N
101297	KlinikUntereExtraemitaet_Haut_Schienung	\N	\N	3	101020	2007-12-10 09:28:00.353	\N	\N
101298	KlinikUntereExtraemitaet_Haut_Sekret	\N	\N	3	101020	2007-12-10 09:28:00.400	\N	\N
101299	KlinikUntereExtraemitaet_Haut_Sensibilitaet	\N	\N	3	101020	2007-12-10 09:28:00.463	\N	\N
101300	KlinikUntereExtraemitaet_Haut_Verband	\N	\N	3	101020	2007-12-10 09:28:00.527	\N	\N
101301	KlinikUntereExtraemitaet_Haut_Verletzung	\N	\N	3	101020	2007-12-10 09:28:00.603	\N	\N
101302	KlinikHerzFunktion_Reizbildung_Reizbildung	\N	\N	3	101022	2007-12-10 08:44:58.683	\N	\N
101304	KlinikHerzFunktion_Kammerfuellung_LiArtriaDiaDruck	\N	\N	3	101023	2007-12-10 08:45:01.387	\N	\N
101305	KlinikHerzFunktion _Kammerfuellung_PulmoKapiDruck	\N	\N	3	101023	2007-12-10 08:45:01.433	\N	\N
101306	KlinikKreislaufFunktion_Makrozirkulation_SysDruck	\N	\N	3	101024	2007-12-10 08:45:12.900	\N	\N
101307	KlinikKreislaufFunktion_Makrozirkulation_DiaDruck	\N	\N	3	101024	2007-12-10 08:45:12.950	\N	\N
101308	KlinikKreislaufFunktion_Makrozirkulation_Hf	\N	\N	3	101024	2007-12-10 08:45:13.060	\N	\N
101309	KlinikAtmungsFunktion_Oxygenation_OxyIndexPaO2FiO2	\N	\N	3	101026	2007-12-10 08:44:50.510	\N	\N
101310	KlinikAtmungsFunktion_Oxygenation_pulsoxySaO2	\N	\N	3	101026	2007-12-10 08:44:50.590	\N	\N
101315	KlinikWasserhaushalt_Wasserhaushalt_Wasser	\N	\N	3	101029	2007-12-10 08:45:20.433	\N	\N
101330	Befinden_Reflexe_Wert	\N	\N	21	1	2007-10-12 13:13:15.280	\N	\N
101338	MassnahmeArzt_DurchgefuehrtVon	\N	\N	3	101337	2007-10-15 10:03:48.567	\N	\N
101349	MassnahmeArzt_DurchgefuehrtVon	\N	\N	3	101337	2007-10-15 10:06:54.250	\N	\N
101369	IstPflege_Befind_Zahnspangeoben	\N	\N	3	30	2007-10-24 12:34:19.207	\N	\N
101376	TISS28_TS_StringWERT	\N	\N	3	100000	2007-10-29 12:04:23.990	\N	\N
101392	Nierenersatzverfahren_Dokumentation_Abschlussgrund	\N	\N	3	1	2007-12-23 07:32:21.120	\N	\N
101396	Nierenersatzverfahren_VO_Abnahme	\N	\N	6	1	2008-06-04 05:43:32.420	\N	\N
101403	Nierenersatzverfahren_Dokumentation_HFLoesung	\N	\N	6	1	2007-10-29 16:08:32.160	\N	\N
101421	Patient_Groesse_old	Größe des Patienten ohne Fallbezug	\N	6	1	2007-10-10 17:20:56.273	\N	\N
101426	Stationsuebersicht_Spalte1	\N	\N	1	101425	2007-11-02 13:30:12.960	\N	\N
101427	Stationsuebersicht_Spalte2	\N	\N	3	101426	2007-10-31 11:37:03.360	\N	\N
101429	Stationsuebersicht_Spalte2	\N	\N	1	101425	2007-11-02 13:30:15.773	\N	\N
101431	Bettplatz	\N	\N	3	101430	2007-11-29 08:50:53.820	\N	\N
101432	Arzt	\N	\N	3	101430	2007-11-29 08:49:58.587	\N	\N
101450	Stationsuebersicht_zustObArzt	\N	\N	3	101425	2007-11-02 13:43:52.657	\N	\N
101451	Stationsuebersicht_erreichbarZustOArzt	\N	\N	3	101425	2007-11-02 13:42:56.300	\N	\N
101452	Stationsuebersicht_PiepserZustObArzt	\N	\N	3	101425	2007-11-02 13:43:48.203	\N	\N
101458	Pflegepersonal	\N	\N	3	101430	2007-11-29 08:51:41.337	\N	\N
101464	Patient_Hausarzt	Hausarzt des Patienten	\N	3	1	2007-12-03 17:15:52.300	\N	\N
101465	Versicherung_Name	\N	\N	3	1	2007-12-03 17:18:13.830	\N	\N
101466	Versicherung_Nummer	\N	\N	3	1	2007-12-03 17:18:22.503	\N	\N
101471	Patient_BMI	\N	\N	3	1	2007-11-05 07:42:11.920	\N	\N
101474	Verlaufgesamt_Datum	\N	\N	5	30	2007-11-06 17:35:23.673	\N	\N
101484	\N	\N	\N	3	101483	2007-11-08 14:49:25.373	\N	\N
101485	VO_Therapie	\N	\N	21	1	2007-12-20 12:45:09.607	\N	\N
101486	VO_Ueberwachung	\N	\N	21	1	2007-12-20 12:45:17.200	\N	\N
101494	VOD_NeuroRadiologie	\N	\N	25	101483	2007-11-08 15:46:04.493	\N	\N
101495	\N	\N	\N	3	101494	2007-11-08 15:46:04.493	\N	\N
101496	VODNeuroRad	\N	\N	25	101487	2007-11-08 15:46:42.850	\N	\N
101498	VOD_	\N	\N	25	101487	2007-11-09 10:17:04.693	\N	\N
101524	TabeIststatusArzt	\N	\N	1	20	2007-11-13 11:25:58.970	\N	\N
101525	TabeIststatusArzt_Datum	\N	\N	5	101524	2007-11-13 11:25:58.987	\N	\N
101526	TabeIststatusArzt_VerantwMitarbeiter	\N	\N	3	101524	2007-11-13 11:25:59.033	\N	\N
101527	TabeIststatusArzt_Grundkrankheit	\N	\N	3	101524	2007-11-13 11:25:59.080	\N	\N
101528	TabeIststatusArzt_Vitalfunktionsstoerung	\N	\N	3	101524	2007-11-13 11:25:59.143	\N	\N
101529	TabeIststatusArzt_Verletzung	\N	\N	3	101524	2007-11-13 11:25:59.203	\N	\N
101532	TabeIntensivDiagnosen_VerantwMitarbeiter	\N	\N	3	101530	2007-11-14 08:18:30.393	\N	\N
101549	TabeIKrankheitsanamnese	\N	\N	1	20	2007-11-13 10:26:50.727	\N	\N
101550	TabeIKrankheitsanamnese_Datum	\N	\N	3	101549	2007-11-13 10:26:50.727	\N	\N
101551	TabeIKrankheitsanamnese_VerantwMitarbeiter	\N	\N	3	101549	2007-11-13 10:26:50.807	\N	\N
101552	TabeIKrankheitsanamnese_Gruppe	\N	\N	3	101549	2007-11-13 10:26:50.853	\N	\N
101553	TabeIKrankheitsanamnese_Bereich	\N	\N	3	101549	2007-11-13 10:26:50.917	\N	\N
101554	TabeIKrankheitsanamnese_Dokumentation	\N	\N	3	101549	2007-11-13 10:26:50.977	\N	\N
101555	TabeIanamnese	\N	\N	1	20	2007-11-13 11:26:04.940	\N	\N
101556	TabeIanamnese_Datum	\N	\N	3	101555	2007-11-13 11:26:04.940	\N	\N
101557	TabeIanamnese_VerantwMitarbeiter	\N	\N	3	101555	2007-11-13 11:26:05.017	\N	\N
101558	TabeIanamnese_Gruppe	\N	\N	3	101555	2007-11-13 11:26:05.063	\N	\N
101559	TabeIanamnese_Bereich	\N	\N	3	101555	2007-11-13 11:26:05.127	\N	\N
101560	TabeIanamnese_Dokumentation	\N	\N	3	101555	2007-11-13 11:26:05.190	\N	\N
101561	TabeISozialanamnese	\N	\N	1	101555	2007-11-12 13:45:29.260	\N	\N
101562	TabeISozialanamnese_Datum	\N	\N	3	101561	2007-11-12 13:45:29.260	\N	\N
101563	TabeISozialanamnese	\N	\N	1	20	2007-11-13 10:26:56.617	\N	\N
101564	TabeISozialanamnese_Datum	\N	\N	3	101563	2007-11-13 10:26:56.617	\N	\N
101565	TabeISozialanamnese_VerantwMitarbeiter	\N	\N	3	101563	2007-11-13 10:26:56.680	\N	\N
101566	TabeISozialanamnese_Gruppe	\N	\N	3	101563	2007-11-13 10:26:56.727	\N	\N
101567	TabeISozialanamnese_Bereich	\N	\N	3	101563	2007-11-13 10:26:56.773	\N	\N
101568	TabeISozialanamnese_Dokumentation	\N	\N	3	101563	2007-11-13 10:26:56.837	\N	\N
101569	TabeIlestatusArztt_Begleitkrankheit	\N	\N	3	101524	2007-11-13 11:25:59.250	\N	\N
101570	Tabelleanamnese	\N	\N	1	20	2007-11-13 11:23:59.097	\N	\N
101571	Tabelleanamnese_Datum	\N	\N	3	101570	2007-11-13 11:23:59.097	\N	\N
101572	Tabelleanamnese_Bereich	\N	\N	3	101570	2007-11-13 11:23:59.160	\N	\N
101573	Tabelleanamnese_Gruppe	\N	\N	3	101570	2007-11-13 11:23:59.220	\N	\N
101574	Tabelleanamnese_Dokumentation	\N	\N	3	101570	2007-11-13 11:23:59.270	\N	\N
101575	Tabelleanamnese_VerantwMitarbeiter	\N	\N	3	101570	2007-11-13 11:23:59.330	\N	\N
101576	TabelleAerzteAnamnese	\N	\N	1	101555	2007-11-13 11:24:36.440	\N	\N
101578	TabelleAerzteAnamnese_Datum	\N	\N	3	101577	2007-11-15 08:20:21.327	\N	\N
101582	TabelleAerzteAnamnese_Verlet	\N	\N	3	101577	2007-11-14 08:20:37.283	\N	\N
101637	Beatmung_Proc_GeraetForm	\N	\N	32	1	2007-11-23 11:55:52.267	\N	\N
101638	Beatmung_VO_GeraetForm	\N	\N	30	1	2007-11-23 11:56:08.657	\N	\N
101639	Beatmung_Proc_BedingteVerordnung	\N	\N	32	1	2007-11-23 11:55:30.173	\N	\N
101640	Beatmung_VO_BedingteVerordnung	\N	\N	30	1	2007-11-23 11:55:10.297	\N	\N
101643	Beatmung_Proc_GeraetForm	\N	\N	29	1	2007-11-23 11:56:34.123	\N	\N
101647	TEST_VO_EKG_12	\N	\N	29	101517	2007-12-17 03:21:10.893	\N	\N
101649	TEST_PROC_EKG_12	\N	\N	31	101517	2007-12-17 03:21:06.787	\N	\N
101650	Zugaenge_Ausfuhr	\N	ml	6	100131	2007-11-27 08:11:34.427	\N	\N
101693	Patient_Leuko	Vitalparameter/Labor Leuko (5-10 G/l)	\N	6	1	2007-12-03 12:46:59.140	\N	\N
101694	Patient_PCT	Vitalparameter/Labor PCT	\N	6	1	2007-12-03 12:46:42.640	\N	\N
101695	Patient_CRP	\N	\N	6	1	2007-12-03 12:45:50.157	\N	\N
101758	\N	\N	\N	3	0	2007-11-29 07:15:59.920	\N	\N
101797	Patient_Versicherungnummer	\N	\N	3	1	2007-12-03 17:19:18.487	\N	\N
101818	Behandlungsstrategie_HF	\N	\N	3	30	2007-12-07 13:39:49.227	\N	\N
101819	Behandlungsstrategie_Messintervalle	\N	\N	6	30	2007-12-07 13:51:24.610	\N	\N
101870	KlinikKopf_HalsHaut_Verband1	\N	\N	3	101860	2007-12-10 07:20:46.763	\N	\N
101884	KlinikHerzKreislaufFunktion	\N	\N	21	101005	2007-12-10 07:50:59.173	\N	\N
101886	KlinikHerzKreislaufFunktion_ATAtemform_Wert	\N	\N	3	101885	2007-12-10 07:52:47.187	\N	\N
101889	KlinikHerzKreislaufFunktion_ATCO2_Wert	\N	\N	3	101885	2007-12-10 07:54:10.483	\N	\N
101898	KlinikHerzKreislaufFunktion_HFKammerfüllung_Wert	\N	\N	3	101885	2007-12-10 07:59:24.403	\N	\N
101905	KlinikHerzKreislaufFunktion_KMakrozirkulation_Wert	Kreislauf Makrozirkulation	\N	3	101885	2007-12-10 08:07:42.527	\N	\N
101907	KlinikHerzKreislaufFunktion_KMikrozirkulation_Wert	Kreislauf Mikrozirkulation	\N	21	101906	2007-12-10 08:09:09.743	\N	\N
101932	KlinikNervensys_Kerntemperatur_Wert	\N	\N	3	101009	2007-12-10 10:06:52.840	\N	\N
101937	KlinikNervensys_PeriSensibilitaet_Wert	\N	\N	3	101009	2007-12-10 10:10:28.430	\N	\N
101940	KlinikNervensys_PeriVegetativum_Wert	\N	\N	3	101009	2007-12-10 10:31:29.407	\N	\N
101943	KlinikNervensys_PeriSensibilitaet_Allgemein	\N	\N	3	101009	2007-12-10 10:34:42.937	\N	\N
102003	ARR	Arrhythmie Drägermonitoring	1/min	3	1	2007-12-14 22:39:24.353	\N	\N
102014	LVP	Linksventrikulärer Mitteldruck	mmHg	6	1	2007-12-14 21:45:02.873	\N	\N
102015	RVP	Rechtsventrikulärer Mitteldruck	mmHg	6	1	2007-12-14 21:45:34.780	\N	\N
102017	PAM	Mittlerer pulmonale arterieller Druck	mmHg	3	1	2007-12-12 13:56:07.780	\N	\N
102048	PAP	Pulmunalarterieller Mitteldruck	mmHg	6	1	2007-12-12 14:28:10.783	\N	\N
102049	PAP	Pulmunalarterieller Druck	mmHg	6	1	2007-12-12 16:03:59.950	\N	\N
102052	PCP	Pulmonalkapillardruck	mmHg	3	1	2007-12-12 16:34:38.580	\N	\N
102095	Lungenersatzverfahren_Doku_ILASystem	\N	\N	6	1	2007-12-15 17:43:38.047	\N	\N
102105	Nierenersatzverfahren_Einstell_ZufuhrSubstituat	\N	\N	3	1	2008-05-05 07:08:41.357	\N	\N
102109	Nierenersatzverfahren_Mess_ZufuhrSubstituat	\N	\N	3	1	2008-05-05 07:10:33.590	\N	\N
102115	Nierenersatzverfahren_Mess_ArtDruck	\N	\N	6	1	2008-06-04 06:25:34.620	\N	\N
102116	Nierenersatzverfahren_Mess_VenoeserDruck	\N	\N	6	1	2008-06-04 06:25:54.277	\N	\N
102174	Vigileo_CO	Cardiacoutput 	\N	6	1	2007-12-17 01:35:54.290	\N	\N
102175	Vigileo_CI	Cardiacindex	\N	6	1	2007-12-17 01:36:01.790	\N	\N
102177	Vigileo_COCI	Cardiac output / -index	l/min;l/min	6	1	2007-12-17 01:35:31.213	\N	\N
102202	VODiagnosMassnahm_Radio_KonventionelleVerfahren	\N	\N	29	1	2007-12-17 03:11:00.290	\N	\N
102204	VODiagnosMassnahm_Radio_Sonografie	\N	\N	29	1	2007-12-17 03:11:46.447	\N	\N
102205	VODiagnosMassnahm_Radio_CT	\N	\N	29	1	2007-12-17 03:10:17.370	\N	\N
102206	VODiagnosMassnahm_Radio_Neuroradiologie	\N	\N	29	1	2007-12-17 03:11:27.820	\N	\N
102207	VODiagnosMassnahm_Radio_MRT	\N	\N	29	1	2007-12-17 03:10:37.633	\N	\N
102208	VODiagnosMassnahm_Radio_Angiografie	\N	\N	29	1	2007-12-17 03:09:46.570	\N	\N
102209	VODiagnosMassnahm_Radio_Szintigrafie	\N	\N	29	1	2007-12-17 03:12:06.180	\N	\N
102210	VODiagnosMassnahm_Labor_RoutineBGA	\N	\N	29	1	2007-12-17 03:05:05.620	\N	\N
102211	VODiagnosMassnahm_Labor_SerumDiagnostik	\N	\N	29	1	2007-12-17 03:05:27.667	\N	\N
102212	VODiagnosMassnahm_Labor_Med.Spiegel	\N	\N	29	1	2007-12-17 03:04:34.917	\N	\N
102213	VODiagnosMassnahm_Labor_VirusLuesDiagnostik	\N	\N	29	1	2007-12-17 03:06:15.307	\N	\N
102214	VODiagnosMassnahm_Labor_HormonDiagnostik	\N	\N	29	1	2007-12-17 03:04:07.040	\N	\N
102215	VODiagnosMassnahm_Labor_BlutgruppenDiagnostik	\N	\N	29	1	2007-12-17 03:03:41.213	\N	\N
102216	VODiagnosMassnahm_Labor_GerrinungsDiagnostik	\N	\N	29	1	2007-12-17 03:02:43.247	\N	\N
102217	VODiagnosMassnahm_Labor_Sonstige	\N	\N	29	1	2007-12-17 02:39:06.507	\N	\N
102218	VODiagnosMassnahm_MiBio_Urin	\N	\N	29	1	2007-12-17 03:08:44.057	\N	\N
102219	VODiagnosMassnahm_MiBi_Atemwege	\N	\N	29	1	2007-12-17 03:07:11.027	\N	\N
102220	VODiagnosMassnahm_MiBi_MagenDarm	\N	\N	29	1	2007-12-17 03:08:01.273	\N	\N
102221	VODiagnosMassnahm_MiBi_Sekrete	\N	\N	29	1	2007-12-17 03:09:25.570	\N	\N
102222	VODiagnosMassnahm_MiBi_KatheterDrainagen	\N	\N	29	1	2007-12-17 03:08:24.633	\N	\N
102223	VODiagnosMassnahm_MiBi_Abstriche	\N	\N	29	1	2007-12-17 03:06:46.260	\N	\N
102224	VODiagnosMassnahm_MiBi_Blut	\N	\N	29	1	2007-12-17 03:07:32.667	\N	\N
102225	VODiagnosMassnahm_Labor_Sonstiges	\N	\N	29	1	2007-12-17 03:05:53.527	\N	\N
102226	VODiagnosMassnahm_Massnah_EKG	\N	\N	29	1	2007-12-17 03:16:54.100	\N	\N
102227	VODiagnosMassnahm_Massnah_Pulskontrollen	\N	\N	29	1	2007-12-17 03:18:13.083	\N	\N
102228	VODiagnosMassnahm_Massnah_ZVD	\N	\N	29	1	2007-12-17 03:19:31.787	\N	\N
102229	VODiagnosMassnahm_Massnah_Sammelurin	\N	\N	29	1	2007-12-17 03:18:40.647	\N	\N
102230	VODiagnosMassnahm_Massnah_Neurokontrolle	\N	\N	29	1	2007-12-17 03:17:53.880	\N	\N
102231	VODiagnosMassnahm_Massnah_Schluckversuch	\N	\N	29	1	2007-12-17 03:19:01.757	\N	\N
102232	VODiagnosMassnahm_Massnah_Inhalation	\N	\N	29	1	2007-12-17 03:17:12.270	\N	\N
102233	VODiagnosMassnahm_Massnah_Mobilisation	\N	\N	29	1	2007-12-17 03:17:34.757	\N	\N
102234	VODiagnosMassnahm_Sonstiges_Konsile	\N	\N	29	1	2007-12-17 03:14:19.570	\N	\N
102235	VODiagnosMassnahm_Sonstiges_Echo	\N	\N	29	1	2007-12-17 03:12:30.303	\N	\N
102236	VODiagnosMassnahm_Sonstiges_NerochirurgieTCD	\N	\N	29	1	2007-12-17 03:14:43.350	\N	\N
102237	VODiagnosMassnahm_Sonstiges_HinrtodDiagnostik	\N	\N	29	1	2007-12-17 03:13:56.710	\N	\N
102238	VODiagnosMassnahm_Sonstiges_Endoskopie	\N	\N	29	1	2007-12-17 03:12:48.867	\N	\N
102239	VODiagnosMassnahm_Sonstiges_Elektrophysiologie	\N	\N	29	1	2007-12-17 03:13:33.053	\N	\N
102240	VODiagnosMassnahm_Sonstiges_EEG	\N	\N	29	1	2007-12-17 03:13:08.303	\N	\N
102241	VODiagnosMassnahm_Massnah_Bronschoskopie	\N	\N	29	1	2007-12-17 03:16:32.850	\N	\N
102242	VODiagnosMassnahm_Massnah_Angehörigengespraech	\N	\N	29	1	2007-12-17 03:16:07.413	\N	\N
102243	PRODiagnosMassnahm_Labor_Abstriche	\N	\N	31	1	2007-12-17 02:35:41.710	\N	\N
102244	PROCDiagnosMassnahm_MiBi_Abstriche	\N	\N	31	1	2007-12-17 03:43:50.400	\N	\N
102245	PROCDiagnosMassnahm_Labor_Atemwege	\N	\N	29	1	2007-12-17 02:35:11.180	\N	\N
102246	PROCDiagnosMassnahm_Labor_Blut	\N	\N	29	1	2007-12-17 02:35:15.520	\N	\N
102248	PROCDiagnosMassnahm_Labor_BlutgruppenDiagnostik	\N	\N	29	1	2007-12-17 02:35:19.583	\N	\N
102249	PROCDiagnosMassnahm_Labor_GerrinungsDiagnostik	\N	\N	31	1	2007-12-17 03:36:35.607	\N	\N
102251	PROCDiagnosMassnahm_Labor_HormonDiagnostik	\N	\N	31	1	2007-12-17 03:37:30.170	\N	\N
102252	PROCDiagnosMassnahm_MiBi_Atemwege	\N	\N	31	1	2007-12-17 03:51:51.383	\N	\N
102253	PROCDiagnosMassnahm_MiBi_Blut	\N	\N	31	1	2007-12-17 03:52:18.290	\N	\N
102254	PROCDiagnosMassnahm_Labor_BlutgruppenDiagnostik	\N	\N	31	1	2007-12-17 03:36:05.107	\N	\N
102255	PROCDiagnosMassnahm_MiBi_KatheterDrainagen	\N	\N	31	1	2007-12-17 03:50:50.383	\N	\N
102256	PROCDiagnosMassnahm_MiBi_MagenDarm	\N	\N	31	1	2007-12-17 03:50:06.413	\N	\N
102257	PROCDiagnosMassnahm_Labor_Med.Spiegel	\N	\N	31	1	2007-12-17 03:37:49.793	\N	\N
102258	PROCDiagnosMassnahm_Labor_RoutineBGA	\N	\N	31	1	2007-12-17 03:38:15.123	\N	\N
102259	PROCDiagnosMassnahm_MiBi_Sekrete	\N	\N	31	1	2007-12-17 03:52:38.430	\N	\N
102260	PROCDiagnosMassnahm_Labor_SerumDiagnostik	\N	\N	31	1	2007-12-17 03:38:33.997	\N	\N
102261	PROCDiagnosMassnahm_Labor_Sonstiges	\N	\N	31	1	2007-12-17 03:38:52.857	\N	\N
102262	PROCDiagnosMassnahm_Labor_VirusLuesDiagnostik	\N	\N	31	1	2007-12-17 03:44:09.870	\N	\N
102263	PROCDiagnosMassnahm_Massnah_Angehörigengespraech	\N	\N	31	1	2007-12-17 03:41:26.920	\N	\N
102264	PROCDiagnosMassnahm_Massnah_Bronschoskopie	\N	\N	31	1	2007-12-17 03:44:32.153	\N	\N
102265	PROCDiagnosMassnahm_Massnah_EKG	\N	\N	31	1	2007-12-17 03:44:52.497	\N	\N
102266	PROCDiagnosMassnahm_Massnah_Inhalation	\N	\N	31	1	2007-12-17 03:45:15.073	\N	\N
102267	PROCDiagnosMassnahm_Massnah_Mobilisation	\N	\N	31	1	2007-12-17 03:49:14.213	\N	\N
102268	PROCDiagnosMassnahm_Massnah_Neurokontrolle	\N	\N	31	1	2007-12-17 03:49:30.667	\N	\N
102269	PROCDiagnosMassnahm_Massnah_Pulskontrollen	\N	\N	31	1	2007-12-17 03:50:28.570	\N	\N
102270	PROCDiagnosMassnahm_Massnah_Sammelurin	\N	\N	31	1	2007-12-17 03:51:32.040	\N	\N
102271	PROCDiagnosMassnahm_Massnah_Schluckversuch	\N	\N	31	1	2007-12-17 03:51:11.650	\N	\N
102272	PROCDiagnosMassnahm_Massnah_ZVD	\N	\N	31	1	2007-12-17 03:49:49.477	\N	\N
102273	PROCDiagnosMassnahm_MiBi_Urin	\N	\N	31	1	2007-12-17 03:53:20.350	\N	\N
102274	PROCDiagnosMassnahm_Radio_Angiografie	\N	\N	31	1	2007-12-17 03:48:54.900	\N	\N
102275	PROCDiagnosMassnahm_Radio_CT	\N	\N	29	1	2007-12-17 03:39:51.137	\N	\N
102276	PROCDiagnosMassnahm_Radio_KonventionelleVerfahren	\N	\N	31	1	2007-12-17 03:43:30.870	\N	\N
102277	PROCDiagnosMassnahm_Radio_MRT	\N	\N	31	1	2007-12-17 03:41:07.670	\N	\N
102278	PROCDiagnosMassnahm_Radio_Neuroradiologie	\N	\N	31	1	2007-12-17 03:42:45.700	\N	\N
102279	PROCDiagnosMassnahm_Radio_Sonografie	\N	\N	31	1	2007-12-17 03:42:25.997	\N	\N
102280	PROCDiagnosMassnahm_Radio_Szintigrafie	\N	\N	31	1	2007-12-17 03:40:47.997	\N	\N
102281	PROCDiagnosMassnahm_Sonstiges_Echo	\N	\N	31	1	2007-12-17 03:43:09.260	\N	\N
102282	PROCDiagnosMassnahm_Sonstiges_EEG	\N	\N	31	1	2007-12-17 03:42:06.060	\N	\N
102283	PROCDiagnosMassnahm_Sonstiges_Elektrophysiologie	\N	\N	31	1	2007-12-17 03:41:44.433	\N	\N
102284	PROCDiagnosMassnahm_Sonstiges_Endoskopie	\N	\N	31	1	2007-12-17 03:40:28.230	\N	\N
102285	PROCDiagnosMassnahm_Sonstiges_HinrtodDiagnostik	\N	\N	31	1	2007-12-17 03:40:10.980	\N	\N
102286	PROCDiagnosMassnahm_Sonstiges_Konsile	\N	\N	31	1	2007-12-17 03:39:31.137	\N	\N
102287	PROCDiagnosMassnahm_Sonstiges_NerochirurgieTCD	\N	\N	31	1	2007-12-17 03:39:14.433	\N	\N
102288	PROCDiagnosMassnahm_MiBi_Sonstiges	\N	\N	31	1	2007-12-17 03:52:59.727	\N	\N
102289	VODiagnosMassnahm_MiBi_Sonstiges	\N	\N	29	1	2007-12-17 03:09:05.197	\N	\N
102333	PROCDiagnosMassnahm_Labor_BlutgruppenDiagnostik	\N	\N	31	102322	2007-12-17 03:37:06.357	\N	\N
102379	TabelleAerzte_BesonderheitenICUVerlaufs	\N	\N	3	102378	2007-12-17 04:42:17.910	\N	\N
102396	TabelleAerzte_Verletzungen_Arzt	\N	\N	5	102378	2007-12-17 06:01:55.707	\N	\N
102414	TabelleAerzte_Bedarfsmedikation	\N	\N	1	102409	2007-12-20 11:04:17.890	\N	\N
102415	TabelleAerzte_Bedarfsmedikation_Medikament	\N	\N	3	102414	2007-12-20 11:04:17.890	\N	\N
102416	TabelleAerzte_Bedarfsmedikation_Dokumentation	\N	\N	3	102414	2007-12-20 11:04:17.983	\N	\N
102417	TabelleAerzte_Bedarfsmedikation_Arzt	\N	\N	3	102414	2007-12-20 11:04:18.063	\N	\N
102418	TabelleAerzte_Bedarfsmedikation_Datum	\N	\N	5	102414	2007-12-20 11:04:18.140	\N	\N
102432	TabelleAerzteMassnahBildKonsil	\N	\N	1	101677	2007-12-21 07:47:04.250	\N	\N
102433	TabelleAerzteMassnahBildKonsil_DokuZeit	\N	\N	5	102432	2007-12-21 07:47:04.267	\N	\N
102434	TabelleAerzteMassnahBildKonsil_Gruppe	\N	\N	3	102432	2007-12-21 07:47:04.343	\N	\N
102435	TabelleAerzteMassnahBildKonsil_Bereich	\N	\N	3	102432	2007-12-21 07:47:04.423	\N	\N
102436	TabelleAerzteMassnahBildKonsil_Dokumentation	\N	\N	3	102432	2007-12-21 07:47:04.517	\N	\N
102437	TabelleAerzteMassnahBildKonsil_DuchgefuehrtVon	\N	\N	3	102432	2007-12-21 07:47:04.593	\N	\N
102456	Untersuchung_Wasserhaushalt_PerspiratioSensibilis	\N	\N	6	20	2007-12-22 12:07:57.780	\N	\N
102457	Untersuchung_Wasserhaushalt_PerspiratioInsensibili	\N	\N	6	20	2007-12-22 12:08:04.230	\N	\N
102458	Untersuchung_Wasserhaushalt_Oxidationswasser	\N	\N	6	20	2007-12-22 12:08:09.887	\N	\N
102459	VODiagnosMassnahm_Massnah_Sonstige	\N	\N	3	102322	2007-12-21 16:55:58.527	\N	\N
102467	VONierenersatzverfahren_Anordnung_AbnahmeMax	\N	\N	29	1	2007-12-23 05:27:08.947	\N	\N
102468	PROCNierenersatzverfahren_Anordnung_AbnahmeMax	\N	\N	31	1	2007-12-23 05:28:25.917	\N	\N
102471	VONierenersatzverfahren_Anordnung_BlutflussMax	\N	\N	29	1	2007-12-23 05:26:44.713	\N	\N
102472	PROCNierenersatzverfahren_Anordnung_BlutflussMax	\N	\N	31	1	2007-12-23 05:28:44.070	\N	\N
102448	Darm_Entfernt_Am	\N	\N	5	102444	\N	\N	\N
102485	VONierenersatzverfahren_Anordnung_Umsatz	\N	\N	29	1	2007-12-23 05:26:19.027	\N	\N
102486	PROCNierenersatzverfahren_Anordnung_Umsatz	\N	\N	31	1	2007-12-23 05:29:02.260	\N	\N
102492	Perspiratio_Sensibilis	Perspiratio Sensibilis in ml (Ausfuhrrelevant in der Bilanz)	ml	6	1	2007-12-22 12:11:40.183	\N	\N
102507	NerochirurgischeMessungen_Platzhalter	\N	\N	3	1	2008-06-04 05:34:42.280	\N	\N
102510	Fehlertabelle	\N	\N	1	80	2007-12-23 11:55:17.987	\N	\N
102511	Datum	\N	\N	3	102510	2007-12-23 10:37:36.640	\N	\N
102512	Gruppe	\N	\N	3	102510	2007-12-23 11:55:17.987	\N	\N
102513	Bereich	\N	\N	3	102510	2007-12-23 11:55:18.063	\N	\N
102514	Dokumentation	\N	\N	3	102510	2007-12-23 11:55:18.140	\N	\N
102515	Status	\N	\N	3	102510	2007-12-23 11:55:18.237	\N	\N
102516	Datum	\N	\N	5	102510	2007-12-23 11:55:18.313	\N	\N
102517	Fehlertabelle	\N	\N	1	1	2007-12-23 12:30:50.840	\N	\N
102518	Datum	\N	\N	5	102517	2007-12-23 12:30:50.840	\N	\N
102519	Gruppe	\N	\N	3	102517	2007-12-23 12:30:50.917	\N	\N
102520	Bereich	\N	\N	3	102517	2007-12-23 12:30:50.997	\N	\N
102521	Dokumentation	\N	\N	3	102517	2007-12-23 12:30:51.090	\N	\N
102522	Status	\N	\N	3	102517	2007-12-23 12:30:51.167	\N	\N
102534	p-CI	Herzindex	l/min/m2	3	1	2007-12-25 12:27:16.850	\N	\N
102579	Beatmung_Messung_Ppeak	\N	\N	6	1	2008-05-02 09:06:33.357	\N	\N
102584	Nierenersatzverfahren_Einstell_PSu2S	\N	\N	6	1	2008-05-02 09:15:09.467	\N	\N
102588	Nierenersatzverfahren_Einstell_Substituat	\N	\N	3	1	2008-05-15 10:45:58.230	\N	\N
102593	Nierenersatzverfahren_Einstell_Dialysierfluessigke	\N	\N	3	1	2008-05-15 10:46:55.210	\N	\N
102594	Nierenersatzverfahren_Einstell_Kaliumkonzentrat	\N	\N	3	1	2008-05-15 07:11:57.020	\N	\N
102595	Nierenersatzverfahren_Einstell_DialyseZeit	\N	\N	3	1	2008-05-05 07:05:45.487	\N	\N
102598	Nierenersatzverfahren_Einstell_OptISOUF	\N	\N	3	1	2008-05-15 06:23:58.840	\N	\N
102599	Nierenersatzverfahren_Einstell_OptISOUFZiel	\N	\N	3	1	2008-05-15 06:24:44.180	\N	\N
102600	Nierenersatzverfahren_Einstell_OptISOUFZeit	\N	\N	3	1	2008-05-15 06:24:59.557	\N	\N
104224	CardiacAssistsysteme_Gerät_Doku	\N	\N	26	1	\N	\N	\N
102601	Nierenersatzverfahren_Einstell_OptISOUFRate	\N	\N	3	1	2008-05-15 06:25:30.680	\N	\N
102603	Nierenersatzverfahren_Einstell_NatriumProfil	\N	\N	3	1	2008-05-15 06:23:02.260	\N	\N
102604	Nierenersatzverfahren_Einstell_StartNatrium	\N	\N	3	1	2008-05-05 07:07:56.967	\N	\N
102605	Nierenersatzverfahren_Einstell_BasisNatrium	\N	\N	3	1	2008-05-15 10:36:59.907	\N	\N
102606	Nierenersatzverfahren_Einstell_UFProfil	\N	\N	3	1	2008-05-15 06:22:33.620	\N	\N
102607	Nierenersatzverfahren_Einstell_BlutflussSingleNeed	\N	\N	3	1	2008-05-05 07:02:53.083	\N	\N
102609	Nierenersatzverfahren_Einstell_DialyseFilter	\N	\N	3	1	2008-06-04 06:39:07.177	\N	\N
102612	Nierenersatzverfahren_Einstell_SubRate	\N	\N	6	1	2008-05-15 11:58:11.500	\N	\N
102616	Nierenersatzverfahren_Mess_Austauschrate	\N	\N	3	1	2008-05-15 10:50:43.130	\N	\N
102620	Nierenersatzverfahren_Mess_SollTemperatur	\N	\N	3	1	2008-05-02 09:58:20.793	\N	\N
102621	Nierenersatzverfahren_Mess_Temperatur	\N	\N	3	1	2008-05-02 09:58:43.467	\N	\N
102636	Nierenersatzverfahren_Mess_SollNatrium	\N	\N	3	1	2008-05-02 10:04:44.920	\N	\N
102637	Nierenersatzverfahren_Mess_Bicarbonat	\N	\N	3	1	2008-05-02 10:05:09.840	\N	\N
102641	Nierenersatzverfahren_Mess_OptISOUF	\N	\N	6	1	2008-05-15 10:43:47.073	\N	\N
102645	Nierenersatzverfahren_Mess_OptIStartNatrium	\N	\N	6	1	2008-05-15 10:44:13.700	\N	\N
102646	Nierenersatzverfahren_Mess_OptBasisNatrium	\N	\N	6	1	2008-05-15 10:44:03.073	\N	\N
102647	Nierenersatzverfahren_Mess_OptUFProfil	\N	\N	3	1	2008-05-15 10:43:39.247	\N	\N
102648	Nierenersatzverfahren_Mess_OptBlutflussSingleNeedl	\N	\N	3	1	2008-05-05 07:10:06.280	\N	\N
102653	Nierenersatzverfahren_Einstell_ZufuhrSubstituat	\N	\N	6	1	2008-05-05 08:06:27.187	\N	\N
102654	Nierenersatzverfahren_Mess_OptBlutflussSingleNeedl	\N	\N	6	1	2008-05-15 10:44:33.323	\N	\N
102673	Nierenersatzverfahren_VO_UFR	\N	\N	6	1	2008-06-04 05:10:16.697	\N	\N
102683	Nierenersatzverfahren_VO_ISOUFRate	\N	\N	6	1	2008-06-04 05:19:10.027	\N	\N
102684	Nierenersatzverfahren_VO_ISOUFZeit	\N	\N	6	1	2008-06-04 05:19:21.403	\N	\N
102685	Nierenersatzverfahren_VO_ISOUFZiel	\N	\N	6	1	2008-06-04 05:19:30.810	\N	\N
102705	Nierenersatzverfahren_Einstell_Spuelbeutel	\N	\N	3	1	2008-06-04 06:40:09.940	\N	\N
102706	Nierenersatzverfahren_VO_SpuelbeutelInitialdosis	\N	\N	3	1	2008-06-04 05:55:47.787	\N	\N
102709	Nierenersatzverfahren_VO_ISOProfil	\N	\N	3	1	2008-09-15 08:21:54.830	\N	\N
102717	Nierenersatzverfahren_Mess_Abnahme	\N	\N	6	1	2008-06-04 06:21:53.820	\N	\N
102718	Nierenersatzverfahren_VO_CADosis	\N	\N	3	1	2008-06-04 05:40:46.597	\N	\N
102719	Nierenersatzverfahren_Einstell_CADosis	\N	\N	3	1	2008-06-04 05:40:23.847	\N	\N
102720	Nierenersatzverfahren_Einstell_CADosis	\N	\N	6	1	2008-06-04 09:16:34.887	\N	\N
102722	Nierenersatzverfahren_VO_CADosis	\N	\N	6	1	2008-06-16 13:31:55.537	\N	\N
102757	Nierenersatzverfahren_VO_UFR	\N	\N	6	1	2008-06-17 15:13:06.323	\N	\N
102759	Mitarbeiter_222	\N	\N	3	1298	2008-09-03 08:56:07.733	\N	\N
102809	Score_PGCS	\N	\N	1	1	2008-10-06 14:36:50.660	\N	\N
102879	Beatmung_Messung_AmplitudeAlphaVision	gemessene Amplitude Vision Alpha	cm H2O	6	1	2008-10-21 08:55:48.933	\N	\N
102896	Beatmung_Einstellung_VerhaeltnisIEG5	Einstellwert: I:E Verhältnis	\N	6	1	2008-10-21 15:44:46.960	\N	\N
102917	Nierenersatzverfahren_Einstellung_Dialysatlösung	Dialysatbeutel für CVVHD	\N	3	1	2008-10-22 14:46:55.790	\N	\N
102924	Nierenersatzverfahren_VO_DKK	\N	\N	3	1	2008-10-24 11:45:20.530	\N	\N
102925	Beatmung_MS_G5_IEVerhaeltnis	gemessenes I:E Verhältnis	\N	6	1	2008-10-29 07:53:58.337	\N	\N
102936	Nierenverfahren_VO_Multi_Blutfluss	\N	\N	30	1	2008-10-29 14:31:57.370	\N	\N
102945	Nierenverfahren_VO_BM25_Zugang	Gefäßzugang extrakorporale Verfahren	\N	3	1	2008-12-09 10:18:31.983	\N	\N
102947	Nierenverfahren_VO_BM25_Filter	Filter für Extrakorp. Verfahren	\N	3	1	2008-12-09 10:16:55.107	\N	\N
102948	Nierenverfahren_VO_BM25_HFLoesung	Hämofiltrationslösung	\N	3	1	2008-12-09 10:17:21.950	\N	\N
102949	Nierenverfahren_VO_BM25_Option	Pre und Postdilution	\N	3	1	2008-12-09 10:17:36.967	\N	\N
102950	Nierenverfahren_VO_BM25_Antikoagulanz	Medikament für Antikoagulation mit Liste	\N	3	1	2008-12-09 10:16:08.933	\N	\N
102951	Nierenverfahren_VO_BM25_SpüllösungAntikoagulanz	Spüllösung zur Vorbereitung	\N	3	1	2008-12-09 10:17:48.060	\N	\N
102952	Nierenverfahren_VO_BM25_FüllenMit	Füllen mit Lösung aus Liste zum Vorbereiten	\N	3	1	2008-12-09 10:17:04.373	\N	\N
102957	Nierenverfahren_VO_ADM_Zugang	Gefäßzugang	\N	6	1	2008-10-29 15:02:34.903	\N	\N
102958	Nierenverfahren_VO_ADM_Zugang	Gefäßzugang	\N	3	1	2008-12-09 10:15:29.120	\N	\N
102959	Nierenverfahren_VO_ADM_Filter	Filter für extrakorporale Verfahren	\N	3	1	2008-12-09 10:14:00.620	\N	\N
102960	Nierenverfahren_VO_ADM_HFLoesung	Hämofiltrationslösung	\N	3	1	2008-12-09 10:14:46.450	\N	\N
102961	Nierenverfahren_VO_ADM_Option	Predilution Postdilution	\N	3	1	2008-12-09 10:15:02.620	\N	\N
102962	Nierenverfahren_VO_ADM_Antikoagulanz	Medikament für Antikoagulation	\N	3	1	2008-12-09 10:13:26.823	\N	\N
102963	Nierenverfahren_VO_ADM_SpüllösungAntikoagulanz	Spüllösung zur Vorbereitung	\N	3	1	2008-12-09 10:15:17.527	\N	\N
102964	Nierenverfahren_VO_ADM_FüllenMit	Füllen mit Lösung aus Liste vor Anschluss	\N	3	1	2008-12-09 10:14:29.167	\N	\N
102969	Nierenverfahren_ES_Multi_ZugangBalken	Gefäßzugang	\N	3	1	2008-11-05 16:17:06.800	\N	\N
102970	Nierenverfahren_ES_Multi_FilterBalken	\N	\N	3	1	2008-11-05 16:38:17.560	\N	\N
102971	Nierenverfahren_ES_Multi_HFLoesungBalken	Hämofiltrationslösung	\N	3	1	2008-11-06 12:43:52.130	\N	\N
102972	Nierenverfahren_ES_Multi_OptionBalken	Pre oder Postdilution	\N	3	1	2008-11-06 12:44:06.800	\N	\N
102973	Nierenverfahren_ES_Multi_AntikoagulanzBalken	Medikament für Antikoagulation	\N	3	1	2008-11-06 12:42:51.190	\N	\N
104225	Sicherheit_Geraeteueberpruef_Konnektionen	\N	\N	3	100480	\N	\N	\N
102974	Nierenverfahren_ES_Multi_SpüllösungAntikoag	Spülung zur Vorbereitung	\N	3	1	2008-11-06 12:44:27.003	\N	\N
102975	Nierenverfahren_ES_Multi_FüllenMit	Füllen mit Flüssigkeit aus Listeneintrag	\N	3	1	2008-11-06 12:43:37.330	\N	\N
102981	Nierenverfahren_ES_Multi_Abschlussbeurteilung	Beschreibung über Systemzustand	\N	3	1	2008-11-06 12:42:33.843	\N	\N
102982	Nierenverfahren_ES_Multi_Abschlussbegruendung	 Grund warum Abschluss erfolgt	\N	3	1	2008-11-06 12:42:22.530	\N	\N
102983	Nierenverfahren_ES_BM25_ZugangBalken	Gefäßzugang	\N	3	1	2008-11-06 12:42:03.637	\N	\N
102984	Nierenverfahren_ES_BM25_HFLoesungBalken	Hämofiltrationslösung	\N	3	1	2008-11-06 12:41:15.923	\N	\N
102985	Nierenverfahren_ES_BM25_FilterBalken	\N	\N	3	1	2008-11-06 12:40:50.233	\N	\N
102986	Nierenverfahren_ES_BM25_OptionBalken	Pre und Postdilution	\N	3	1	2008-11-06 12:41:28.833	\N	\N
102987	Nierenverfahren_ES_BM25_AntikoagulanzBalken	\N	\N	3	1	2008-11-06 12:40:22.730	\N	\N
102988	Nierenverfahren_ES_BM25_SpüllösungAntikoag	\N	\N	3	1	2008-11-06 12:41:45.790	\N	\N
102989	Nierenverfahren_ES_BM25_FüllenMit	\N	\N	3	1	2008-11-06 12:41:03.097	\N	\N
102994	Nierenverfahren_ES_BM25_Abschlussbeurteilung	\N	\N	3	1	2008-11-06 12:39:58.600	\N	\N
102995	Nierenverfahren_ES_BM25_Abschlussbegruendung	\N	\N	3	1	2008-11-06 12:39:46.363	\N	\N
102996	Nierenverfahren_ES_ADM_ZugangBalken	\N	\N	6	1	2008-10-29 15:43:51.970	\N	\N
102997	Nierenverfahren_ES_ADM_FilterBalken	\N	\N	3	1	2008-11-06 12:37:58.410	\N	\N
102998	Nierenverfahren_ES_ADM_ZugangBalken	\N	\N	3	1	2008-11-06 12:39:30.957	\N	\N
102999	nierenverfahren_ES_ADM_HFLoesung	\N	\N	3	1	2008-11-06 12:38:41.917	\N	\N
103000	Nierenverfahren_ES_ADM_OptionBalken	\N	\N	3	1	2008-11-06 12:38:59.640	\N	\N
103001	Nierenverfahren_ES_ADM_AntikoagulanzBalken	\N	\N	3	1	2008-11-06 12:35:32.913	\N	\N
103002	Nierenverfahren_ES_ADM_SpüllösungAntikoag	\N	\N	3	1	2008-11-06 12:39:13.783	\N	\N
103003	Nierenverfahren_ES_ADM_FüllenMit	\N	\N	3	1	2008-11-06 12:38:15.897	\N	\N
103008	Nierenverfahren_ES_ADM_Abschlussbeurteilung	\N	\N	3	1	2008-11-06 12:35:06.870	\N	\N
103009	Nierenverfahren_ES_ADM_Abschlussbegruendung	\N	\N	3	1	2008-11-06 12:34:49.510	\N	\N
103039	Beatmung_ES_G5_Drucktrigger	Die inspiratorische Bemühung des Patienten (Druck), die das Beatmungsgerät veranlasst, einen Atemhub abzugeben	\N	3	1	2008-12-23 10:29:14.877	\N	\N
103044	Nierenverfahren_VO_BM25_Dialysatlösung	Dialysat, Beutel	\N	3	1	2008-12-09 10:16:41.437	\N	\N
103046	Nierenverfahren_VO_Multi_DialysatlösungBalken	Dialysat Beutel	\N	3	1	2008-10-31 15:30:35.823	\N	\N
103047	Nierenverfahren_ES_Multi_DialysatlösungBalken	Dialysatbeutel	\N	3	1	2008-11-06 12:43:07.410	\N	\N
103048	Nierenverfahren_ES_BM25_DialysatlösungBalken	Dialysatbeutel	\N	3	1	2008-11-06 12:40:35.747	\N	\N
103096	Nierenverfahren_Doku_SpuelloesungAntikoagulanz	\N	ml	19	1	2008-11-06 15:23:12.857	\N	\N
103103	Nierenverfahren_MS_B25_DialysatvolumenKumulativ	\N	lliter	6	1	2008-11-13 13:15:28.667	\N	\N
103104	Nierenverfahren_Doku_Filter	\N	\N	19	1	2008-11-14 08:27:21.040	\N	\N
103105	Nierenverfahren_Doku_Filter	\N	\N	19	1	2008-11-14 08:37:51.707	\N	\N
103106	Nierenverfahren_Doku_Zugang	\N	\N	19	1	2008-11-14 08:38:27.207	\N	\N
103113	Nierenverfahren_Doku_Antikoagulati	Antikoagulation/Medikament	\N	19	1	2008-11-14 09:36:08.150	\N	\N
103119	Nierenverfahren_Doku_Citratloesung	Citratlösung	\N	3	1	2008-11-14 10:42:54.743	\N	\N
103120	Nierenverfahren_Doku_Calciumloesung	Calciumlösung	\N	3	1	2008-11-14 10:42:39.183	\N	\N
103131	Beatmung_MS_BiPAPV_Pimax	Messwert: maximal gemessener Inpirationsdruck	cm H2O	6	1	2008-11-20 09:01:26.250	\N	\N
103137	Nierenverfahren_VO_BM25_Bolus	Medikamnet	\N	3	1	2008-12-09 10:16:27.310	\N	\N
103138	Nierenverfahren_VO_ADM_Bolus	Medikament	\N	3	1	2008-12-09 10:10:23.870	\N	\N
103141	Nierenverfahren_Doku_Bolusab	Medikament	\N	3	1	2008-11-19 11:47:08.990	\N	\N
103144	Nierenverfahren_Doku_Plasmaloesung	\N	\N	3	1	2008-11-19 15:15:13.910	\N	\N
103173	Nierenverfahren_MS_UltrafiltratmengeKumulativ	Bilanzrelevant	ml	19	1	2008-11-21 11:02:12.287	\N	\N
103208	Nierenverfahren_ES_4008HS_Dialysezeit1	\N	h:min	6	1	2008-11-21 12:00:53.560	\N	\N
103217	Nierenverfahren_MS_4008HS_UltrafiltratmengeKum	kumulativer Entzug, bilanzrelevant	ml	6	1	2008-11-21 15:51:39.643	\N	\N
103223	Nierenverfahren_VO_4008onl_BasisNatrium	\N	mmol/l	6	1	2008-11-24 12:16:57.913	\N	\N
103236	Nierenverfahren_VO_4008HS_Dialysekonzentrat	\N	\N	6	1	2008-11-24 14:35:21.677	\N	\N
103249	Nierenverfahren_VO_4008HS_Dialysekonzentrat	Dialysekonzentratbehälter	\N	6	1	2008-11-24 14:38:39.593	\N	\N
103252	Nierenverfahren_VO_4008HS_SollNatrium1	\N	mmol/l	6	1	2008-11-24 14:47:04.080	\N	\N
103337	Nierenverfahren_MS_AbnahmeKumulativ	\N	Liter	6	1	2008-12-11 13:59:05.813	\N	\N
103342	IABP_ACAT_ES_Unterstützungsverhältnis	Frequenz	\N	6	1	2009-01-16 12:26:30.957	\N	\N
103345	IABP_ACAT_MS_SystoleDiastole	\N	mmHg	6	1	2008-12-22 08:31:06.663	\N	\N
103346	IABP_ACAT_MS_Mitteldruck	\N	mmHg	6	1	2008-12-22 08:31:36.947	\N	\N
103351	IABP_AutoCat_ES_Unterstützungsverhältnis	Liste	\N	6	1	2009-01-16 12:28:21.037	\N	\N
103354	IABP_AutoCat_MS_SystoleDiastole	\N	mmHg	6	1	2008-12-22 09:20:15.493	\N	\N
103355	IABP_AutoCat_ES_Mitteldruck	\N	mmHg	6	1	2008-12-22 09:20:30.527	\N	\N
103360	IABP_Datascope_ES_IABPFrequenz	Liste	\N	6	1	2009-01-16 12:29:55.787	\N	\N
103362	IABP_Datascope_ES_EKGAbleitung	Liste	\N	6	1	2008-12-19 14:53:13.313	\N	\N
103363	IABP_Datascope_MS_SystoleDiastole	\N	mmHg	6	1	2008-12-22 09:33:15.500	\N	\N
103364	IABP_Datascope_MS_Mitteldruck	\N	mmHg	6	1	2008-12-22 09:33:29.110	\N	\N
103377	Schrittmacher_Eins_ES_Frequenz	Medtronic 5348	1/min	3	1	2008-12-22 14:19:50.223	\N	\N
103378	Schrittmacher_Eins_ES_Ausgang	Medtronic 5348	mA	3	1	2008-12-22 14:20:28.990	\N	\N
103379	Schrittmacher_Eins_ES_Empfindlichkeit	Medtronic 5348	mV	3	1	2008-12-22 14:20:13.490	\N	\N
103445	Score_DGAI_AufnVonNotaufnahmeNAW	\N	\N	3	1	2008-12-30 10:25:18.947	\N	\N
103446	Score_DGAI_AufnVonPeriphererStation	\N	\N	3	1	2008-12-30 10:26:07.637	\N	\N
103447	Score_DGAI_AufnIntensivstationWachstation	\N	\N	3	1	2008-12-30 10:23:42.167	\N	\N
103448	Score_DGAI_AufnVonOPAWR	\N	\N	3	1	2008-12-30 10:25:45.917	\N	\N
103449	Score_DGAI_AufnVonExterneKlinik	\N	\N	3	1	2008-12-30 10:24:39.010	\N	\N
103450	Score_DGAI_AufnIndikationIntensivUeberwachung	\N	\N	3	1	2008-12-30 10:23:04.650	\N	\N
103451	Score_DGAI_AufnIndikationIntensivBehandlung	\N	\N	3	1	2008-12-30 10:22:42.730	\N	\N
103452	Score_DGAI_AufnIndikationBeatmungsfall	\N	\N	3	1	2008-12-30 10:22:23.633	\N	\N
103453	Score_DGAI_AufnIndikationSchwerstkrankerPatient	\N	\N	3	1	2008-12-30 10:23:24.167	\N	\N
103454	Score_DGAI_AufnNachOperation	\N	\N	3	1	2008-12-30 10:24:03.807	\N	\N
103455	Score_DGAI_AufnTraumaPolytrauma	\N	\N	3	1	2008-12-30 10:24:21.933	\N	\N
103456	Score_DGAI_AufnWiederaufnahmeKleiner48h	\N	\N	3	1	2008-12-30 10:26:45.073	\N	\N
103457	Score_DGAI_AufnWiederaufnahmeGroesser48h	\N	\N	3	1	2008-12-30 10:26:27.980	\N	\N
103459	Score_DGAI_AufnChronischeMetastasierenNeoplasie	\N	\N	3	1	2008-12-30 10:22:02.760	\N	\N
103460	Score_DGAI_AufnChronischeHaematologischeNeoplasie	\N	\N	3	1	2008-12-30 10:21:02.617	\N	\N
103461	Score_DGAI_AufnChronischeAIDS	\N	\N	3	1	2008-12-30 10:08:10.880	\N	\N
103465	Score_DGAI_EntlNachNormalstation	\N	\N	3	1	2008-12-30 10:55:14.773	\N	\N
103466	Score_DGAI_EntlNachWachstation	\N	\N	3	1	2008-12-30 10:55:33.350	\N	\N
103467	Score_DGAI_EntlNachAndereIntensivstation	\N	\N	3	1	2008-12-30 10:32:40.640	\N	\N
103468	Score_DGAI_EntlNachExterneSpezialklinik	\N	\N	3	1	2008-12-30 10:33:15.187	\N	\N
103469	Score_DGAI_EntlNachExterneNormalklinik	\N	\N	3	1	2008-12-30 10:32:58.700	\N	\N
103470	Score_DGAI_EntlNachKeineVerlegungExitus	\N	\N	3	1	2008-12-30 10:33:55.373	\N	\N
103471	Score_DGAI_EntlNachHause	\N	\N	3	1	2008-12-30 10:33:36.593	\N	\N
103472	Score_DGAI_EntlZustandRestitAdIntegr	\N	\N	3	1	2008-12-30 10:59:18.663	\N	\N
103473	Score_DGAI_EntlZustandGeringBeeintraechtigungPassa	\N	\N	3	1	2008-12-30 10:59:00.587	\N	\N
103474	Score_DGAI_EntlZustandGeringBeeintraechtigungDauer	\N	\N	3	1	2008-12-30 10:58:38.243	\N	\N
103475	Score_DGAI_EntlZustandUeberlebenErheblicherDefekt	\N	\N	3	1	2008-12-30 10:59:42.760	\N	\N
103476	Score_DGAI_EntlZustandExitus	\N	\N	3	1	2008-12-30 10:58:18.570	\N	\N
103477	Score_DGAI_EntlInfoARDSALI	\N	\N	3	1	2008-12-30 10:27:27.887	\N	\N
103478	Score_DGAI_EntlInfoANV	\N	\N	3	1	2008-12-30 10:27:08.870	\N	\N
103479	Score_DGAI_EntlInfoSepsis	\N	\N	3	1	2008-12-30 10:31:20.480	\N	\N
103480	Score_DGAI_EntlInfoMRSA	\N	\N	3	1	2008-12-30 10:30:02.107	\N	\N
103481	Score_DGAI_EntlInfoVRE	\N	\N	3	1	2008-12-30 10:32:23.217	\N	\N
103482	Score_DGAI_EntlInfoESBL	\N	\N	3	1	2008-12-30 10:28:32.073	\N	\N
103483	Score_DGAI_EntlInfoMODMOV	\N	\N	3	1	2008-12-30 10:29:42.200	\N	\N
103484	Score_DGAI_EntlInfoNET	\N	\N	3	1	2008-12-30 10:30:22.933	\N	\N
103485	Score_DGAI_EntlInfoECMOILA	\N	\N	3	1	2008-12-30 10:28:09.073	\N	\N
103486	Score_DGAI_EntlInfoHFOV	\N	\N	3	1	2008-12-30 10:28:56.793	\N	\N
103487	Score_DGAI_EntlInfoPolytrauma	\N	\N	3	1	2008-12-30 10:31:00.497	\N	\N
103488	Score_DGAI_EntlInfoMaximaleTherapieAufStation	\N	\N	3	1	2008-12-30 10:29:22.590	\N	\N
103489	Score_DGAI_EntlInfoTherapieMinima	\N	\N	3	1	2008-12-30 10:31:39.997	\N	\N
103490	Score_DGAI_EntlInfoObduktionDurchgefuehrt	\N	\N	3	1	2008-12-30 10:30:42.997	\N	\N
103491	Score_DGAI_EntlInfoBarthelIndexErhoben	\N	\N	3	1	2008-12-30 10:27:50.323	\N	\N
103493	Score_DGAI_EntlPostVisiteKeineDurchgefuehrt	\N	\N	5	1	2008-12-30 10:03:45.753	\N	\N
103494	Score_DGAI_EntlPostVisiteRestitutioAdIntegrum	\N	\N	5	1	2008-12-30 10:04:25.080	\N	\N
103495	Score_DGAI_EntlPostVisiteBeeintraechtigungPassager	\N	\N	5	1	2008-12-30 10:04:02.877	\N	\N
103496	Score_DGAI_EntlPostVisiteBeeintraechtigungDauerhaf	\N	\N	5	1	2008-12-30 10:03:05.737	\N	\N
103497	Score_DGAI_EntlPostVisiteUeberlebenErheblicherDefe	\N	\N	5	1	2008-12-30 10:03:26.470	\N	\N
103498	Score_DGAI_EntlPostVisiteExitusImKrankenhaus	\N	\N	3	1	2008-12-30 10:56:42.337	\N	\N
103499	Score_DGAI_EntlPostVisiteBeeintraechtigungDauerhaf	\N	\N	3	1	2008-12-30 10:55:53.490	\N	\N
103500	Score_DGAI_EntlPostVisiteUeberlebenErheblicherDefe	\N	\N	3	1	2008-12-30 10:57:54.993	\N	\N
103501	Score_DGAI_EntlPostVisiteKeineDurchgefuehrt	\N	\N	3	1	2008-12-30 10:57:02.833	\N	\N
103502	Score_DGAI_EntlPostVisiteBeeintraechtigungPassager	\N	\N	3	1	2008-12-30 10:56:17.960	\N	\N
103503	Score_DGAI_EntlPostVisiteRestitutioAdIntegrum	\N	\N	3	1	2008-12-30 10:57:23.460	\N	\N
103505	Score_DGAI_AufnChronischeHaematologischeNeoplasie	\N	\N	3	1	2008-12-30 10:21:23.820	\N	\N
103579	Patient_1234	\N	\N	3	1	2009-01-27 14:57:24.690	\N	\N
103581	IstPflege_Aufnehmender	\N	\N	5	30	2009-02-06 18:00:29.450	\N	\N
103583	Lungenersatzverfahren_Doku_ECMO_Zugang	Gefäßdefinition	\N	3	1	2009-03-18 15:13:43.713	\N	\N
103584	Drainagen_SekretmlKum	Drainagen_SekretmlKum: Dokumentationszeile (nicht bilanzrelevant)	ml	6	1	2009-03-19 16:02:34.223	\N	\N
103608	Wunddokumentaition_VACPumpe	Gerät zur Unterstützung der Wundheilung , Sekretabsaugung	\N	3	100189	2009-04-08 07:49:35.397	\N	\N
103609	Wunddokumentation_VACPumpe	Gerät zur Wundheilungsunterstützung, Sekretmobilisation	\N	3	100189	2009-04-08 07:55:13.717	\N	\N
103611	Wunddokumentation_Größe_Aufnahme	Wunddokumentation der Größe bei Aufnahme oder erstem Auftreten	cm	6	100189	2009-04-08 13:02:47.360	\N	\N
103619	Dekubitus_VACPumpe	Gerät zur Sekretmobilisation	\N	3	100182	2009-04-08 13:53:36.073	\N	\N
104226	Beatmung_MS_Servoi_Edi_min	Edi-Mindestwert 	[µV]	6	1	\N	\N	\N
103625	Lungenersatzverfahren_MS_ACT	Gerinnungsparameter über externes Messgerät 	s	6	1	2009-04-09 09:33:37.797	\N	\N
103635	SonstigeVerfahren_VO_ArticSun_Zieltemperatur	Hypothermiebehandlung 	°C	26	1	2009-04-17 13:36:08.457	\N	\N
103638	SonstigeVerfahren_VO_ArticSun_Kuehlverfahren	Hypothermiebehandlung Liste hinterlegt	\N	3	1	2009-04-17 14:01:12.587	\N	\N
103639	SonstigeVerfahren_VO_ArticSun_Kathetertyp	Liste Wärmeaustauschkatheter	\N	3	101992	2009-04-17 13:58:39.653	\N	\N
103647	Atemwege_Markierung_Aufnahme2	Dokumentation der Markierung des Atemwegszugangs zum Zeitpunkt der Aufnahme	\N	3	100132	2009-05-19 08:41:17.060	\N	\N
103660	NeurochirurgischeMessungen__Platzhalter	\N	\N	3	1	2009-06-09 09:08:03.287	\N	\N
103705	ZuweisendeAbtlg_	Dokumentenkopf , Abteilung aus der Pat. übernommen wird	\N	3	1	2009-08-17 15:36:28.600	\N	\N
103725	Enteralesonden_MSBeschaffenheit	Beschreibung des Magensaftsekretes	\N	3	100133	2009-09-21 08:39:35.497	\N	\N
103726	Enteralesonden_MSBeschaffenheit	Beschreibung der Magensaftes	\N	3	100165	2009-09-22 08:54:23.410	\N	\N
103727	HarnwegeDarm_UrinBeschaffenheit	Beschreibung der Urinbeschaffenheit	\N	3	100172	2009-09-22 09:00:30.880	\N	\N
103730	Bewegen_Bewegungen_Fixateur	Dokumentation eines Fixateur	\N	3	100360	2009-09-28 15:22:24.287	\N	\N
103806	PtiO2	Über eine PtiO2 Sonde gemessener Gewebssauerstoffpartialdruck.	mmHg	6	1	2010-02-04 12:15:29.193	\N	\N
103810	Behandlungsstrategie_ZielvorgabenICP	\N	mmHg	6	30	2010-01-20 13:36:23.853	\N	\N
103811	Behandlungsstrategie_ZielvorgabenCPP	Zielwert für den CPP unter Hirndrucktherapie	mmHg	6	30	2010-01-20 13:38:15.153	\N	\N
103812	Behandlungsstrategie_ZielvorgabenPtiO2	\N	mmHg	6	30	2010-01-20 13:40:13.900	\N	\N
103824	Hypothermie_Doku_Warmtouch_Temp	Liste	mmHg	19	1	2010-02-16 12:27:25.133	\N	\N
103825	Hypothermie_Doku_Warmtouch_Geblaese	Liste	Stufe	19	1	2010-02-16 12:27:52.953	\N	\N
103846	Therapiebetten_Doku_Triadyne_Temperatur	\N	°C	6	1	2010-02-22 13:24:50.257	\N	\N
103853	Therapiebetten_Doku_Triadyne_Rotation	an aus	\N	19	1	2010-02-22 13:20:50.353	\N	\N
103854	Therapiebetten_Doku_Triadyne_reRotwinkelZeit	\N	°/min	6	1	2010-02-22 13:22:57.370	\N	\N
103855	Therapiebetten_Doku_Triadyne_liRotwinkelZeit	\N	\N	6	1	2010-02-22 13:23:30.367	\N	\N
103856	Therapiebetten_Doku_Triadyne_miRotlZeit	\N	min	6	1	2010-02-22 13:24:28.430	\N	\N
103893	Therapiebetten_Doku_Rotorest_Stillstand	\N	min	19	1	2010-02-25 10:09:56.370	\N	\N
103894	Therapiebetten_Doku_Rotorest_EingewoehnModus	aktiv 	Liste	19	1	2010-02-25 10:12:02.307	\N	\N
103901	Koerperpflege_Waschen_Assistiert_Wert	\N	\N	25	100389	2010-02-25 13:46:43.857	\N	\N
103902	Koerperpflege_Waschen_selbst_Wert	\N	\N	25	103901	2010-02-25 13:43:07.760	\N	\N
103903	Koerperpflege_Waschen_selbstst_Wert	\N	\N	25	100389	2010-02-25 13:48:17.763	\N	\N
103929	Therapiebetten_VO_Rotorest_Position	\N	\N	3	1	2010-03-01 16:14:02.747	\N	\N
103932	test	\N	\N	15	1	2011-09-09 09:23:07.580	\N	\N
104013	Isolationsmaßnahmen_Pflege_Doku	\N	\N	19	1	2010-05-10 13:44:57.520	\N	\N
104015	Behandlungsstrategie_ZielvorgabenMPAP	\N	\N	6	30	2010-05-12 14:08:18.817	\N	\N
104087	Koerperpflege_Umfang_Wert	\N	\N	21	100356	2010-08-13 11:58:12.580	\N	\N
104089	Koerperpflege_Umfaenge_Wert_	\N	\N	25	100356	2010-08-16 15:11:37.460	\N	\N
104090	Koerperpflege_Umfaenge_Hals	\N	\N	3	104089	2010-08-16 15:11:32.220	\N	\N
104121	Infektionsprophylaxe_Schleuse_Standard	\N	\N	19	1	2010-11-02 15:35:18.197	\N	\N
104124	Koerperpflege_Haut_Nagelpflege_	\N	\N	3	100384	2010-12-13 14:18:34.580	\N	\N
104148	Beatmung_ES_Airvo_Applikationsweg	Beschreibung der Schnittstelle vom Gerät zum  Patienten	\N	3	1	2010-12-09 13:23:46.753	\N	\N
104154	Koerperpflege_Naegel_Wert_	\N	\N	21	100356	2010-12-13 15:23:56.193	\N	\N
104155	Koerperpflege_Naegel_Pflege	\N	\N	3	104154	2010-12-13 15:21:56.563	\N	\N
104156	Koerperpflege_Naegel_Status	\N	\N	3	104154	2010-12-13 15:21:43.417	\N	\N
104172	Beatmung_ES_Zephyros_Druckunterstützung	\N	cm H20	6	1	2010-12-22 13:36:51.917	\N	\N
104184	Beatmung_ES_Zephyros_Ppeak	\N	cm H2O	6	1	2010-12-22 10:40:41.633	\N	\N
104317	tets	\N	\N	1	1	2011-09-09 09:19:48.733	\N	\N
104318	tets_1	\N	\N	2	104317	2011-09-09 09:19:45.087	\N	\N
104293	VerlBericht_Arzt_Name	\N	\N	3	30	\N	\N	\N
104330	Wertsachen_Name	\N	\N	5	1	2011-06-09 12:51:34.973	\N	\N
104336	Behandlung_Wertsachen_AusgehaendigtNamePflege	\N	\N	5	30	2011-06-09 12:50:20.210	\N	\N
104337	Behandlung_Wertsachen_AusgehaendigtNameAngehoerige	\N	\N	5	30	2011-06-09 12:50:31.630	\N	\N
104344	IABP_DatascopeCS300_ES_EKGAbleitung	Dokumentation der gewählten EG Ableitung für den IABP Einsatz.	\N	6	1	2011-06-16 07:57:20.823	\N	\N
104346	IABP_DatascopeCS300_ES_IABPFrequenz	Dokumentation der IABP Frequenz.	\N	6	1	2011-06-16 07:59:20.177	\N	\N
104348	IABP_DatascopeCS300_ES_Triggerauswahl	Dokumentation des ausgewählten Triggers der IABP.	\N	6	1	2011-06-16 08:03:04.210	\N	\N
104350	IABP_DatascopeCS300_MS_SystoleMittelDiastole	Dokumentation des gemessenen Blutdruckes unter IABP.	\N	6	1	2011-06-16 08:04:39.480	\N	\N
104711	Beatmung_ES_Pallas_I_E	Dokumentation des eingestellten I:E.	\N	6	1	2011-06-21 10:01:00.527	\N	\N
104713	Beatmung_ES_Pallas_Pps	Dokumentation des eingestellten Pressure Support.	\N	6	1	2011-06-21 07:24:55.460	\N	\N
104744	Beatmung_MS_Pallas_Mindest_Flow	Mindestflow/Gasverbrauch (Uptake des Patienten, Leckagen, im Absorber umgesetztes CO2 Volumen.	l/min	6	1	2011-08-30 10:03:24.610	\N	\N
104755	Beatmung_ES_G5_IE_Backup	\N	s	6	1	2011-08-02 09:01:44.050	\N	\N
105037	Behandlungsstrategie_Zielvorgaben_etCO2	endexpiratorisches CO2	mmHg	6	30	2011-11-29 08:05:38.253	\N	\N
105276	Bewegen_Bewegungen_Grad	Grad Angabe bei spezieller Lagerung von z.B. Extrermitäten	°C	3	1	2014-05-05 10:27:40.997	\N	\N
104120	Score_SAPS2_WertOhneGCS	\N	\N	2	101973	\N	\N	\N
106304	Lungenersatzverfahren_Doku_ILAactivve_Zugang	Liste Lungenersatzverfahren_Zugang veno venös   oder veno arteriell	\N	3	1	2014-08-18 14:03:41.583	\N	\N
106305	Lungenersatzverfahren_Doku_ILAactivve_Kathetertyp	Liste Lungenersatzverfahren - Kathetertyp	\N	3	1	2014-08-18 14:05:24.607	\N	\N
106306	Lungenersatzverfahren_Doku_ILAactivve_Schlauchsys	Liste Lungenrsatzverfahren - Schlauchsystem	\N	3	1	2014-08-18 14:04:30.083	\N	\N
106350	CardioHelpMaquet_MS_Hb	\N	\N	3	1	2014-12-30 16:32:09.747	\N	\N
104132	Behandlung_DIVI_MaximaleTherapie	\N	\N	2	30	\N	\N	\N
104133	Behandlung_DIVI_AufnahmeVon	\N	\N	3	30	\N	\N	\N
104134	Behandlung_DIVI_AufnahmeGeplant	Ist eine Aufnahme geplant chirurgisch, ungeplant chirurgisch oder medizinisch	\N	3	30	\N	\N	\N
104135	Behandlung_DIVI_ASA	\N	\N	3	30	\N	\N	\N
104136	Behandlung_DIVI_AufnahmeIndikation	\N	\N	3	30	\N	\N	\N
104137	Behandlung_DIVI_AufnehmenderArzt	\N	\N	3	30	\N	\N	\N
104138	Behandlung_DIVI_ChrAIDS	\N	\N	2	30	\N	\N	\N
104139	Behandlung_DIVI_ChrHaemaNeoplasie	\N	\N	2	30	\N	\N	\N
104140	Behandlung_DIVI_ChrMetastNeoplasie	\N	\N	2	30	\N	\N	\N
104141	Behandlung_DIVI_VentHBisAufn	\N	\N	6	30	\N	\N	\N
104142	Behandlung_DIVI_WiederaufnahmeGr48	\N	\N	2	30	\N	\N	\N
104143	Behandlung_DIVI_WiederaufnahmeKl48	\N	\N	2	30	\N	\N	\N
104144	Behandlung_DIVI_AufnahmeBeatmet	\N	\N	2	30	\N	\N	\N
104145	Behandlung_DIVI_TraumaPolytrauma	\N	\N	2	30	\N	\N	\N
104146	Behandlung_DIVI_znOP	\N	\N	2	30	\N	\N	\N
104147	Beatmung_ES_Airvo_Temperatur	Temperatureinstellung am Gerät Airvo	Grad Celsius	6	1	\N	\N	\N
104149	Beatmung_ES_Airvo_FlowSetting	Einstellunggröße  des Flows am Gerät	L/min	6	1	\N	\N	\N
104150	Beatmung_ES_Airvo_O2Flow	Dokumentation des eingestellten O2 Flusses, welcher am Gerät Airvo angeschlossen ist.	L/min	6	1	\N	\N	\N
104151	Beatmung_ES_Airvo_O2Konzentration	Dokumentation der O2 Konzentration in Abhängigkeit der Einstellgrößen FlowSetting und O2 Flow.	%	6	1	\N	\N	\N
104152	Beatmung_ES_Airvo_Zugangsweg	Beschreibung der Schnittstelle vom Gerät zum Patienten	\N	19	1	\N	\N	\N
104153	Beatmung_ES_Airvo_Applikationsweg_Balken	Dokumentation des Apllikationsweges	\N	19	1	\N	\N	\N
104157	Koerperpflege_Nagel_Wert	\N	\N	25	100356	\N	\N	\N
104160	Beatmung_ES_Zephyros_Druckrampe	\N	ms	6	1	\N	\N	\N
104161	Beatmung_ES_Zephyros_FIO2	\N	%	6	1	\N	\N	\N
104163	Beatmung_ES_Zephyros_AF	\N	bpm	6	1	\N	\N	\N
104164	Beatmung_ES_Zephyros_Tinsp	\N	s	6	1	\N	\N	\N
104165	Beatmung_ES_Zephyros_Texp	\N	s	6	1	\N	\N	\N
104166	Beatmung_ES_Zephyros_IE	\N	\N	6	1	\N	\N	\N
104167	Beatmung_ES_Zephyros_Trigger	\N	l/min	6	1	\N	\N	\N
104168	Beatmung_ES_Zephyros_Peep	\N	mbar	6	1	\N	\N	\N
104169	Beatmung_ES_Zephyros_Pinsp	\N	cmH20	6	1	\N	\N	\N
104170	Beatmung_ES_Zephyros_By-Flow	\N	l/min	6	1	\N	\N	\N
104171	Beatmung_ES_Zephyros_CPAP	\N	cmH20	6	1	\N	\N	\N
104173	Beatmung_ES_Zephyros_Pmax	\N	cm H20	6	1	\N	\N	\N
104174	Beatmung_ES_Zephyros_Endflow	\N	%	6	1	\N	\N	\N
104175	Beatmung_ES_Zephyros_Tubuskompensation	\N	%	6	1	\N	\N	\N
104176	Beatmung_MS_Zephyros_Ppeak	\N	cmH20	6	1	\N	\N	\N
104177	Beatmung_MS_Zephyros_Pplat	\N	cmH2O	6	1	\N	\N	\N
104178	Beatmung_MS_Zephyros_Pmin	\N	cm H2O	6	1	\N	\N	\N
104179	Beatmung_MS_Zephyros_spAF	\N	bpm	6	1	\N	\N	\N
104180	Beatmung_MS_Zephyros_Tve	\N	ml	6	1	\N	\N	\N
104181	Beatmung_MS_Zephyros_MVe	\N	l/min	6	1	\N	\N	\N
104182	Beatmung_MS_Zephyros_O2	\N	vol%	6	1	\N	\N	\N
104183	Beatmung_ES_Zephyros_Ppsv	\N	cmH20	6	1	\N	\N	\N
104185	Beatmung_MS_Zephyros_C	\N	ml/cmH20	6	1	\N	\N	\N
104186	Beatmung_MS_Zephyros_R	\N	cmH20/ml/sec	6	1	\N	\N	\N
104187	Beatmung_MS_Zephyros_Pmean	\N	\N	6	1	\N	\N	\N
104188	Beatmung_MS_Zephyros_Tvi	\N	s	6	1	\N	\N	\N
104189	Beatmung_MS_Zephyros_Ppeep	\N	cm H2O	6	1	\N	\N	\N
104190	Beatmung_MS_Zephyros_Ppeepi	\N	cm H2O	6	1	\N	\N	\N
104192	Beatmung_Doku_Zephyros_Option	Liste Highflow Highflow CPAP	\N	3	1	\N	\N	\N
104193	Beatmung_ES_Zephyros_Flow	\N	l/min	6	1	\N	\N	\N
104195	Beatmung_ES_Zephyros_IE_Verhältnis	\N	\N	3	1	\N	\N	\N
104196	Therapiematratze_Doku_ProfiCare_Komfortlevel	\N	\N	19	1	\N	\N	\N
104197	Score_TISS10_Aufnahme	\N	\N	1	30	\N	\N	\N
104198	TISS10_artKatheter_Aufnahme	\N	\N	27	104197	\N	\N	\N
104199	TISS10_AzidoseAlkalose_Aufnahme	\N	\N	27	104197	\N	\N	\N
104200	TISS10_Beatmung_Aufnahme	\N	\N	27	104197	\N	\N	\N
104201	TISS10_erweitHaemoynMonit_Aufnahme	\N	\N	27	104197	\N	\N	\N
104202	TISS10_extrakorpNierenersatz_Aufnahme	\N	\N	27	104197	\N	\N	\N
104203	TISS10_ICPMessung_Aufnahme	\N	\N	27	104197	\N	\N	\N
104204	TISS10_InotropikaGabe_Aufnahme	\N	\N	27	104197	\N	\N	\N
104205	TISS10_InterventionAufICU_Aufnahme	\N	\N	27	104197	\N	\N	\N
104206	TISS10_intravFluessTh_Aufnahme	\N	\N	27	104197	\N	\N	\N
104207	TISS10_TransIntensivP_Aufnahme	\N	\N	27	104197	\N	\N	\N
104208	TISS10_Wert_Aufnahme	\N	\N	2	104197	\N	\N	\N
104209	TISS10_Datum_Aufnahme	\N	\N	5	104197	\N	\N	\N
104210	Score_SOFA_Aufnahme	\N	\N	1	30	\N	\N	\N
104211	SOFA_Bilirubin_Aufnahme	\N	\N	27	104210	\N	\N	\N
104212	SOFA_Creatinine_Aufnahme	\N	\N	27	104210	\N	\N	\N
104213	SOFA_GCS_Aufnahme	\N	\N	27	104210	\N	\N	\N
104214	SOFA_Hypotension_Aufnahme	\N	\N	27	104210	\N	\N	\N
104215	SOFA_PaO2_Aufnahme	\N	\N	27	104210	\N	\N	\N
104216	SOFA_Thrombo_Aufnahme	\N	\N	27	104210	\N	\N	\N
104217	SOFA_Wert_Aufnahme	\N	\N	2	104210	\N	\N	\N
104218	SOFA_Datum_Aufnahme	\N	\N	5	104210	\N	\N	\N
104219	SAPS2_WertOhneGCS_Aufnahme	\N	\N	2	104068	\N	\N	\N
104220	TISS28_TISS10_Wert_Aufnahme	\N	\N	2	104041	\N	\N	\N
104221	Nierenverfahren_MS_Cobespectra_BilanzwertKumulativ	\N	l	6	1	\N	\N	\N
104223	Behandlungsstrategie_Messintervalle_RASS_Freitext	\N	\N	3	30	\N	\N	\N
104227	Beatmung_MS_Servoi_Edi_peak	Edi-Spitzenwert 	[µV]	6	1	\N	\N	\N
104228	Beatmung_MS_Servoi_SBI	Shallow Breathing Index (Index für flache Atmung) 	\N	6	1	\N	\N	\N
104229	Beatmung_MS_Servoi_P0_1	P0.1 	[cmH2O]	6	1	\N	\N	\N
104230	Beatmung_MS_Servoi_E	Elastanz 	[cmH2O/ml]	6	1	\N	\N	\N
104231	Beatmung_MS_Servoi_WOBp	Atemarbeit, Patient 	\N	6	1	\N	\N	\N
104232	Beatmung_MS_Servoi_WOBv	Atemarbeit, Ventilator 	\N	6	1	\N	\N	\N
104233	Beatmung_MS_Servoi_Re	Exstiratorische Resistenz 	[cmH2O/l/s]	6	1	\N	\N	\N
104234	Beatmung_MS_Servoi_Ri	Inspiratorische Resistenz 	[cmH2O/l/s]	6	1	\N	\N	\N
104235	Beatmung_MS_Servoi_Cstatic	Statische Compliance 	[ml/cmH2O]	6	1	\N	\N	\N
104236	Beatmung_MS_Servoi_Cdyn	Dynamische Charakteristika 	[ml/cmH2O]	6	1	\N	\N	\N
104237	Beatmung_MS_Servoi_O2	Gemessene Sauerstoffkonzentration 	[%]	6	1	\N	\N	\N
104238	Beatmung_MS_Servoi_Vee	Endexspiratorischer Flow 	[l/min]	6	1	\N	\N	\N
104239	Beatmung_MS_Servoi_Vte	Exsp. Tidalvolumen 	[ml]	6	1	\N	\N	\N
104240	Beatmung_MS_Servoi_Vti	Insp. Tidalvolumen 	[ml]	6	1	\N	\N	\N
104241	Beatmung_MS_Servoi_Leckage	Leckage in % 	[%]	6	1	\N	\N	\N
104242	Beatmung_MS_Servoi_MVe	MVe [l/min] 	[l/min]	6	1	\N	\N	\N
104243	Beatmung_MS_Servoi_MVi	Insp. Minutenvolumen 	[l/min]	6	1	\N	\N	\N
104244	Beatmung_MS_Servoi_Mve_spont	Spontanes exsp. Minutenvolumen 	[l/min]	6	1	\N	\N	\N
104245	Beatmung_MS_Servoi_AF	Atemfrequenz 	[AZ/min]	6	1	\N	\N	\N
104246	Beatmung_MS_Servoi_Afspont	Spontane Atemzüge pro Minute 	[AZ/min]	6	1	\N	\N	\N
104247	Beatmung_MS_Servoi_CPAP	Continuous Positive Airway Pressure 	[cmH2O]	6	1	\N	\N	\N
104248	Beatmung_MS_Servoi_PEEP	Positiver Endexsp. Druck 	[cmH2O]	6	1	\N	\N	\N
104249	Beatmung_MS_Servoi_Pmean	Mittlerer Atemwegsdruck 	[cmH2O]	6	1	\N	\N	\N
104250	Beatmung_MS_Servoi_Pplat	Atemwegsdruck Pause 	[cmH2O]	6	1	\N	\N	\N
104251	Beatmung_MS_Servoi_Ppeak	Atemdruck Spitze 	[cmH2O]	6	1	\N	\N	\N
104252	Beatmung_ES_Servoi_Backup_Ti	Backup Ti [s] 	[s]	6	1	\N	\N	\N
104253	Beatmung_ES_Servoi_Backup_I_E	Backup I:E [Einstellung] 	\N	3	1	\N	\N	\N
104254	Beatmung_ES_Servoi_Backup_DK_ueber_PEEP	Backup DK über PEEP [cmH2O] 	[cmH2O]	6	1	\N	\N	\N
104255	Beatmung_ES_Servoi_Backup_Frequenz	Backup Frequenz [n/min] 	[n/min]	6	1	\N	\N	\N
104256	Beatmung_ES_Servoi_Backup_Vt	Backup Vt [ml] 	[ml]	6	1	\N	\N	\N
104257	Beatmung_ES_Servoi_Automode_Triggerfenster	Automode Triggerfenster (s) 	[s]	6	1	\N	\N	\N
104258	Beatmung_ES_Servoi_Gewicht	Gewicht (kg) 	[kg]	6	1	\N	\N	\N
104259	Beatmung_ES_Servoi_EDI_Trigger	EDI Trigger 	[µV]	6	1	\N	\N	\N
104260	Beatmung_ES_Servoi_Nava_Pegel	Nava Pegel 	[cmH2O/µV]	6	1	\N	\N	\N
104261	Beatmung_ES_Servoi_O2	Sauerstoffkonzentration 	[%]	6	1	\N	\N	\N
104262	Beatmung_ES_Servoi_Tpeep	zeit unteres Druckniveau (tniedrig) 	[s]	6	1	\N	\N	\N
104263	Beatmung_ES_Servoi_Thoch	zeit oberes Druckniveau (thoch) 	[s]	6	1	\N	\N	\N
104264	Beatmung_ES_Servoi_PEEP	PEEP 	[cmH2O]	6	1	\N	\N	\N
104265	Beatmung_ES_Servoi_DU_ueber_Phoch	Druckunterstüzung hoch (cmH2O) 	[cmH2O]	6	1	\N	\N	\N
104266	Beatmung_ES_Servoi_Pniedrig	Phoch (cmH2O) 	[cmH2O]	6	1	\N	\N	\N
104267	Beatmung_ES_Servoi_Phoch	Phoch (cmH2O) 	[cmH2O]	6	1	\N	\N	\N
104268	Beatmung_ES_Servoi_DU_ueber_PEEP	DU über PEEP 	[cmH2O]	6	1	\N	\N	\N
104269	Beatmung_ES_Servoi_DK_ueber_PEEP	DK über PEEP 	[cmH2O]	6	1	\N	\N	\N
104270	Beatmung_ES_Servoi_Drucktrigger	Drucktrigger 	cmH2O	6	1	\N	\N	\N
104271	Beatmung_ES_Servoi_Flowtrigger	Flowtrigger 	[Wert]	6	1	\N	\N	\N
104272	Beatmung_ES_Servoi_Tpause_Prozent	TPause (%) 	[%]	6	1	\N	\N	\N
104273	Beatmung_ES_Servoi_Tpause_s	TPause (s) 	[s]	6	1	\N	\N	\N
104274	Beatmung_ES_Servoi_I_E	I:E [Einstellung] 	\N	3	1	\N	\N	\N
104275	Beatmung_ES_Servoi_End_Insp_Zyklusende	End. Insp. Zyklusende (% des Spitzenflows) 	[%]	6	1	\N	\N	\N
104276	Beatmung_ES_Servoi_Insp_Anstiegszeit_Prozent	Insp.-Anstiegszeit (%) 	[%]	6	1	\N	\N	\N
104277	Beatmung_ES_Servoi_Insp_Anstiegszeit_s	Insp.-Anstiegszeit (s) 	[s]	6	1	\N	\N	\N
104278	Beatmung_ES_Servoi_Pausendauer_s	Pausendauer [s] 	[s]	6	1	\N	\N	\N
104279	Beatmung_ES_Servoi_Pausendauer_Prozent	Pausendauer 	[%]	6	1	\N	\N	\N
104280	Beatmung_ES_Servoi_Ti	Ti (s) 	[s]	6	1	\N	\N	\N
104281	Beatmung_ES_Servoi_CMV_Frequenz	CMV Frequenz 	[n/min]	6	1	\N	\N	\N
104282	Beatmung_ES_Servoi_SIMV_Frequenz	SIMV Frequenz 	[n/min]	6	1	\N	\N	\N
104283	Beatmung_ES_Servoi_Frequenz	Atemfrequenz 	[n/min]	6	1	\N	\N	\N
104284	Beatmung_ES_Servoi_Vt	Tidalvolumen 	[ml]	6	1	\N	\N	\N
104285	TabelleAerzte_Labor_Datum_Ende	\N	\N	5	102409	\N	\N	\N
104286	Hypothermie_ArticSun_VO_KuehlWaermeRate_neu	\N	°c/h	3	1	\N	\N	\N
104288	Hypothermie_ArticSun_Doku_KuehlWaermerate_neu	\N	°C/h	3	1	\N	\N	\N
104290	Score_CAM_ICU_Punktwert_Datum	\N	\N	5	104289	\N	\N	\N
104291	Score_CAM_ICU_Punktwert_Wert	\N	\N	2	104289	\N	\N	\N
104292	Score_CAM_ICU_Punktwert_Gesamt_SubScore	\N	\N	27	104289	\N	\N	\N
104294	VerlBericht_Arzt_ErstelltAm	\N	\N	5	30	\N	\N	\N
104295	VerlBericht_Arzt_Medikamente_Bedarf	\N	\N	3	30	\N	\N	\N
104296	VerlBericht_Arzt_Medikamente_EnteraleErnaehrung	\N	\N	3	30	\N	\N	\N
104297	VerlBericht_Arzt_Medikamente_ParenteraleErnaehrung	\N	\N	3	30	\N	\N	\N
104298	VerlBericht_Arzt_Medikamente_Infusionen	\N	\N	3	30	\N	\N	\N
104299	VerlBericht_Arzt_Medikamente_Antibiotika	\N	\N	3	30	\N	\N	\N
104300	VerlBericht_Arzt_Medikamente_Aktuell	\N	\N	3	30	\N	\N	\N
104301	VerlBericht_Arzt_Verlauf_Dekubiti	\N	\N	3	30	\N	\N	\N
104302	VerlBericht_Arzt_Verlauf_WundenDefekte	\N	\N	3	30	\N	\N	\N
104303	VerlBericht_Arzt_Verlauf_ZuUndAbleitendeSysteme	\N	\N	3	30	\N	\N	\N
104304	VerlBericht_Arzt_Verlauf_Transfusionsprodukte	\N	\N	3	30	\N	\N	\N
104305	VerlBericht_Arzt_Verlauf_Bilanz	\N	\N	3	30	\N	\N	\N
104306	VerlBericht_Arzt_Verlauf_CardiacAssistSysteme	\N	\N	3	30	\N	\N	\N
104307	VerlBericht_Arzt_Verlauf_Nierenersatztherapie	\N	\N	3	30	\N	\N	\N
104308	VerlBericht_Arzt_Verlauf_ExtrakorporaleLungenverfa	\N	\N	3	30	\N	\N	\N
104309	VerlBericht_Arzt_Verlauf_Beatmung	\N	\N	3	30	\N	\N	\N
104310	VerlBericht_Arzt_Verlauf_Epikrise	\N	\N	3	30	\N	\N	\N
104311	VerlBericht_Arzt_Befunde	\N	\N	3	30	\N	\N	\N
104312	VerlBericht_Arzt_Leistungen	\N	\N	3	30	\N	\N	\N
104313	Verlegungsbericht_Arzt_PatientenInfo	\N	\N	3	30	\N	\N	\N
104314	VerlBericht_Arzt_Diagnosen_Hauptdiagnose	\N	\N	3	30	\N	\N	\N
104315	Sicherheit_Propylaxen_Spitzfußprophylaxe	Dokumentation der durchgeführten Spitzfußprophylaxe.	\N	3	100475	\N	\N	\N
104316	VerlBericht_Arzt_Gesamt	\N	\N	3	30	\N	\N	\N
104319	Darm_FüllstandAuffang	Dokumentation der Füllstandsmenge des Auffandbehälters.	\N	6	102451	\N	\N	\N
104320	Wertsachen_Wertgegenstaende	\N	\N	3	1	\N	\N	\N
104321	Wertsachen_Papiere	\N	\N	3	1	\N	\N	\N
104322	Wertsachen_Pflegeuntensilien	\N	\N	3	1	\N	\N	\N
104323	Wertsachen_Kleidungsstuecke	\N	\N	3	1	\N	\N	\N
104324	Wertsachen_Prothese	\N	\N	3	1	\N	\N	\N
104325	Wertsachen_POE	\N	\N	3	1	\N	\N	\N
104326	Wertsachen_Kleidungsstuecke_Ort	\N	\N	3	1	\N	\N	\N
104327	Wertsachen_Papiere_Ort	\N	\N	3	1	\N	\N	\N
104328	Wertsachen_Wertgegenstaende_Ort	\N	\N	3	1	\N	\N	\N
104329	Wertsachen_Datum	\N	\N	5	1	\N	\N	\N
104331	Wertsachen_Pflegeuntensilien_Ort	\N	\N	3	1	\N	\N	\N
104332	Wertsachen_Prothese_Ort	\N	\N	3	1	\N	\N	\N
104333	Behandlung_Wertsachen_AusgehaendigtAn	\N	\N	3	30	\N	\N	\N
104334	Behandlung_Wertsachen_AusgehaendigtGegenstaende	\N	\N	3	30	\N	\N	\N
104335	Behandlung_Wertsachen_AusgehaendigtDatum	\N	\N	5	30	\N	\N	\N
104338	Behandlung_Wertsachen_AusgehaendigtNameAngehoerig	\N	\N	3	30	\N	\N	\N
104339	Behandlung_Wertsachen_AusgehaendigtNamePflegekraft	\N	\N	3	30	\N	\N	\N
104340	Wertsachen_Name_Pflegekraft	\N	\N	3	1	\N	\N	\N
104341	Wertsachen_Name_Angehoeriger	\N	\N	3	1	\N	\N	\N
104342	Sicherheit_Wechsel_Beatmungsbeutel	Dokumentation des Wechsels der Beatmungsbeutels.	\N	3	100494	\N	\N	\N
104343	Sicherheit_Wechsel_Beatmungsmaske	Dokumentation des Wechsels der Beatmungsmasken.	\N	3	100494	\N	\N	\N
104345	IABP_DatascopeCS300_ES_IABPAufblasen	Dokumentation des prozentualen Anteil des Aufblasens des Ballons.	\N	6	1	\N	\N	\N
104347	IABP_DatascopeCS300_ES_IABPLeersaugen	Dokumentation des prozentualen Anteils des Leersaugens des Ballons.	\N	6	1	\N	\N	\N
104349	IABP_DatascopeCS300_ES_Unterstützungsdruck	Dokumentation des Unterstützungsdruckes.	\N	6	1	\N	\N	\N
104351	IABP_DatascopeCS300_ES_Doku_Ballonkatheter	Dokumentation des verwendeten Ballonkatheters.	\N	3	1	\N	\N	\N
104352	IABP_DatascopeCS300_ES_Doku_Ballonvolumen	Dokumentation des Ballonvolumens.	\N	6	1	\N	\N	\N
104353	IABP_DatascopeCS300_ES_EKG_Ableitung	Dokumentation der gewählten EG Ableitung für den IABP Einsatz.	\N	3	1	\N	\N	\N
104354	IABP_DatascopeCS300_ES_IABP_Frequenz	Dokumentation der IABP Frequenz.	\N	3	1	\N	\N	\N
104355	IABP_DatascopeCS300_ES_Triggerauswahl_EKG_RR_Pacer	Dokumentation des ausgewählten Triggers der IABP.	\N	3	1	\N	\N	\N
104398	AT_ArmgelmatteTuch	\N	\N	2	30	\N	\N	\N
104357	AT_Name_Pflegekraft4	\N	\N	3	30	\N	\N	\N
104358	AT_Bemerkungen_Verlauf	\N	\N	3	30	\N	\N	\N
104359	AT_Name_Anaesthesist4	\N	\N	3	30	\N	\N	\N
104360	AT_Name_Pflegekraft3	\N	\N	3	30	\N	\N	\N
104361	AT_Name_Pflegekraft2	\N	\N	3	30	\N	\N	\N
104362	AT_Name_Anaesthesist3	\N	\N	3	30	\N	\N	\N
104363	AT_Name_AnaesthesistGastarzt	\N	\N	3	30	\N	\N	\N
104364	AT_Name_Anaesthesist2	\N	\N	3	30	\N	\N	\N
104365	AT_Name_Pflegekraft1	\N	\N	3	30	\N	\N	\N
104366	AT_Name_AnaesthesistChef	\N	\N	3	30	\N	\N	\N
104367	AT_Name_AnaesthesistOA2	\N	\N	3	30	\N	\N	\N
104368	AT_Name_AnaesthesistOA1	\N	\N	3	30	\N	\N	\N
104369	AT_Name_Anaesthesist1	\N	\N	3	30	\N	\N	\N
104370	AT_TEE	\N	\N	2	30	\N	\N	\N
104371	AT_Fiberoptik	\N	\N	2	30	\N	\N	\N
104372	AT_Bronchoskopie	\N	\N	2	30	\N	\N	\N
104373	AT_Relaxometrie	\N	\N	2	30	\N	\N	\N
104374	AT_SEP	\N	\N	2	30	\N	\N	\N
104375	AT_EEG	\N	\N	2	30	\N	\N	\N
104376	AT_SchwierigerAtemweg	\N	\N	2	30	\N	\N	\N
104377	AT_Cormack4	\N	\N	2	30	\N	\N	\N
104378	AT_Cormack3	\N	\N	2	30	\N	\N	\N
104379	AT_Cormack2	\N	\N	2	30	\N	\N	\N
104380	AT_Cormack1	\N	\N	2	30	\N	\N	\N
104381	AT_Cuffwaechter	\N	\N	2	30	\N	\N	\N
104382	AT_AugenBdsGepolstert	\N	\N	2	30	\N	\N	\N
104383	AT_Augengel	\N	\N	2	30	\N	\N	\N
104384	AT_Augensalben	\N	\N	2	30	\N	\N	\N
104385	AT_Augenpflaster	\N	\N	2	30	\N	\N	\N
104394	AT_Knierolle	\N	\N	2	30	\N	\N	\N
104395	AT_Fersenschoner	\N	\N	2	30	\N	\N	\N
104396	AT_Sandsack	\N	\N	2	30	\N	\N	\N
104397	AT_Schulterrolle	\N	\N	2	30	\N	\N	\N
104399	AT_Kopfgelring	\N	\N	2	30	\N	\N	\N
104400	AT_Ganzkörpergelmatte	\N	\N	2	30	\N	\N	\N
104401	Behandlung_AVB	\N	\N	1	30	\N	\N	\N
104402	Behandlung_AVB_Object_RefListValue	\N	\N	34	104401	\N	\N	\N
104403	Praemedikation	Inhalte der Prämedikation	\N	1	1	\N	\N	\N
104405	Praemedikation_Medikamenten_Tabelle	\N	\N	1	104403	\N	\N	\N
104406	Praemedikation_Präanästh_Anordnung_Option	Präanästhetische Anordnung Option.	\N	3	104403	\N	\N	\N
104474	Praemedikation_ASA_II	Doku ASA II.	\N	2	104403	\N	\N	\N
104407	Praemedikation_Präanästh_Anordnung_nüchtern_abUhr	Präanästhetische Anordnung nüchtern ab definiertertem Zeitpunkt.	\N	3	104403	\N	\N	\N
104408	Praemedikation_Präanästh_Anordnung_spez_Untersuchu	Präanästhetische Anordnung spezielle Untersuchung.	\N	2	104403	\N	\N	\N
104409	Praemedikation_Präanästh_Anordnung_BZ_Profil	Präanästhetische Anordnung BZ Tagesprofil.	\N	2	104403	\N	\N	\N
104410	Praemedikation_Präanästh_Anordnung_Gerinnung	Präanästhetische Anordnung Gerinnung.	\N	2	104403	\N	\N	\N
104411	Praemedikation_Präanästh_Anordnung_Wiedervorstellu	Präanästhetische Anordnung Wiedervorstellung.	\N	2	104403	\N	\N	\N
104412	Praemedikation_Präanästh_Anordnung_aktuelles_EKG	Präanästhetische Anordnung aktuelles EKG	\N	2	104403	\N	\N	\N
104413	Praemedikation_Präanästh_Anordnung_Schilddrüsen	Präanästhetische Anordnung Schilddrüsenwerte.	\N	2	104403	\N	\N	\N
104414	Praemedikation_Präanästh_Anordnung_aktuelles_Labor	Präanästhetische Anordnung aktuelles Labor.	\N	2	104403	\N	\N	\N
104415	Praemedikation_Präanästh_Anordnung_nüchtern_ja	Präanästhetische Anordnung nüchtern bleiben.	\N	2	104403	\N	\N	\N
104416	Praemedikation_Name_erstellende_Anästhesist	Name des Anästhesisten, der die Prämedikation erstellt.	\N	3	104403	\N	\N	\N
104417	Praemedikation_Erstell_Datum	\N	\N	5	104403	\N	\N	\N
104418	Praemedikation_Präanästh_Anordnung_Einheiten_EB	Präanästhetische Anordnung: Anzahl der anzufordernden Einheiten an Eigenblut.	\N	3	104403	\N	\N	\N
104419	Praemedikation_Präanästh_Anordnung_Einheiten_TK	Präanästhetische Anordnung: Anzahl der anzufordernden Einheiten an TKs.	\N	3	104403	\N	\N	\N
104420	Praemedikation_Präanästh_Anordnung_Einheiten_FFP	Präanästhetische Anordnung: Anzahl der anzufordernden Einheiten an FFPs.	\N	3	104403	\N	\N	\N
104421	Praemedikation_Präanästh_Anordnung_Einheiten_EK	Präanästhetische Anordnung: Anzahl der anzufordernden Einheiten an EKs.	\N	3	104403	\N	\N	\N
104422	Praemedikation_geplantes_OP_Datum	Dokumentation des geplanten OP Datums.	\N	5	104403	\N	\N	\N
104423	Praemedikation_Arztwahl	Dokumentation freier Arztwahl	\N	2	104403	\N	\N	\N
104424	Praemedikation_Zahnstatus_Befund	\N	\N	3	104403	\N	\N	\N
104425	Praemedikation_Zahnstatus_li_unten_7	\N	\N	3	104403	\N	\N	\N
104426	Praemedikation_Zahnstatus_li_ob_7	\N	\N	3	104403	\N	\N	\N
104427	Praemedikation_Zahnstatus_li_unten_6	\N	\N	3	104403	\N	\N	\N
104428	Praemedikation_Zahnstatus_li_ob_6	\N	\N	3	104403	\N	\N	\N
104429	Praemedikation_Zahnstatus_li_unten_5	\N	\N	3	104403	\N	\N	\N
104430	Praemedikation_Zahnstatus_li_ob_5	\N	\N	3	104403	\N	\N	\N
104431	Praemedikation_Zahnstatus_li_unten_4	\N	\N	3	104403	\N	\N	\N
104432	Praemedikation_Zahnstatus_li_ob_4	\N	\N	3	104403	\N	\N	\N
104433	Praemedikation_Zahnstatus_li_unten_3	\N	\N	3	104403	\N	\N	\N
104434	Praemedikation_Zahnstatus_li_ob_3	\N	\N	3	104403	\N	\N	\N
104435	Praemedikation_Zahnstatus_li_unten_2	\N	\N	3	104403	\N	\N	\N
104436	Praemedikation_Zahnstatus_li_ob_2	\N	\N	3	104403	\N	\N	\N
104437	Praemedikation_Zahnstatus_li_unten_1	\N	\N	3	104403	\N	\N	\N
104438	Praemedikation_Zahnstatus_li_ob_1	\N	\N	3	104403	\N	\N	\N
104439	Praemedikation_Zahnstatus_re_unten_1	\N	\N	3	104403	\N	\N	\N
104440	Praemedikation_Zahnstatus_re_ob_1	\N	\N	3	104403	\N	\N	\N
104441	Praemedikation_Zahnstatus_re_unten_2	\N	\N	3	104403	\N	\N	\N
104442	Praemedikation_Zahnstatus_re_ob_2	\N	\N	3	104403	\N	\N	\N
104443	Praemedikation_Zahnstatus_re_unten_3	\N	\N	3	104403	\N	\N	\N
104444	Praemedikation_Zahnstatus_re_ob_3	\N	\N	3	104403	\N	\N	\N
104445	Praemedikation_Zahnstatus_re_unten_4	\N	\N	3	104403	\N	\N	\N
104446	Praemedikation_Zahnstatus_re_ob_4	\N	\N	3	104403	\N	\N	\N
104447	Praemedikation_Zahnstatus_re_unten_5	\N	\N	3	104403	\N	\N	\N
104448	Praemedikation_Zahnstatus_re_ob_5	\N	\N	3	104403	\N	\N	\N
104449	Praemedikation_Zahnstatus_re_unten_6	\N	\N	3	104403	\N	\N	\N
104450	Praemedikation_Zahnstatus_re_ob_6	\N	\N	3	104403	\N	\N	\N
104451	Praemedikation_Zahnstatus_re_unten_7	\N	\N	3	104403	\N	\N	\N
104452	Praemedikation_Zahnstatus_re_ob_7	\N	\N	3	104403	\N	\N	\N
104453	Praemedikation_Vorläufige_Diagnose	Dokumentation der vorläufigen Diagnose	\N	3	104403	\N	\N	\N
104454	Praemedikation_Geplanter_Eingriff	Dokumentation der Art des geplanten Eingriffes.	\N	3	104403	\N	\N	\N
104455	Praemedikation_Klinik_der_OP	Dokumentation der klinischen Fachrichtung der OP	\N	3	104403	\N	\N	\N
104456	Praemedikation_CPAP_versorgt	Dokumentation, wenn OSAS CPAP versorgt ist.	\N	2	104403	\N	\N	\N
104457	Praemedikation_OSAS	Dokumentation, wenn OSAS vorliegt.	\N	2	104403	\N	\N	\N
104458	Praemedikation_Opiatgewöhnung	Dokumentation, wenn Opiatgewöhnung vorliegt.	\N	2	104403	\N	\N	\N
104459	Praemedikation_Infektion	Dokumentation, wenn eine Infektion vorliegt.	\N	2	104403	\N	\N	\N
104460	Praemedikation_bekannter_schwieriger_Atemweg	Dokumentation, wenn schwieriger Atemweg bekannt ist.	\N	2	104403	\N	\N	\N
104461	Praemedikation_PONV	Dokumentation, wenn PONV vorliegt.	\N	2	104403	\N	\N	\N
104462	Praemedikation_MH_Disposition	Dokumentation, wenn MH-Disposition vorliegt	\N	2	104403	\N	\N	\N
104463	Praemedikation_Reflux	Dokumentation, wenn Reflux besteht.	\N	2	104403	\N	\N	\N
104464	Praemedikation_Anästhesierelevante_Vorerkrankungen	Dokumentation Anästhesierelevanter Vorerkrankungen des Patienten.	\N	3	104403	\N	\N	\N
104465	Praemedikation_Frühere_Anästhesien	Dokumentation früherer durchgeführter Anästhesien	\N	3	104403	\N	\N	\N
104466	Praemedikation_Eingriff_Noteingriff	Doku Noteingriff.	\N	2	104403	\N	\N	\N
104467	Praemedikation_Eingriff_Dringlicher_Eingriff	Doku Dringlicher Eingriff.	\N	2	104403	\N	\N	\N
104468	Praemedikation_Eingriff_Wahleingriff	Doku Wahleingriff.	\N	2	104403	\N	\N	\N
104469	Praemedikation_Patientenverfügung_beachten	Doku einer vorliegenden Patientenverfügung.	\N	2	104403	\N	\N	\N
104470	Praemedikation_ASA_Hirntod	Doku ASA Hirntod.	\N	2	104403	\N	\N	\N
104471	Praemedikation_ASA_V	Doku ASA V.	\N	2	104403	\N	\N	\N
104472	Praemedikation_ASA_IV	Doku ASA IV.	\N	2	104403	\N	\N	\N
104473	Praemedikation_ASA_III	Doku ASA III.	\N	2	104403	\N	\N	\N
104475	Praemedikation_ASA_I	Doku ASA I.	\N	2	104403	\N	\N	\N
104476	Praemedikation_Einwilligung_DE	Doku Einwilligung DE.	\N	2	104403	\N	\N	\N
104477	Praemedikation_Einwilligung_ICU	Doku Einwilligung ICU.	\N	2	104403	\N	\N	\N
104478	Praemedikation_Einwilligung_BK	Doku Einwilligung BK.	\N	2	104403	\N	\N	\N
104479	Praemedikation_Einwilligung_DIB	Doku Einwilligung DIB.	\N	2	104403	\N	\N	\N
104480	Praemedikation_Einwilligung_Fem_Kath	Doku Einwilligung Fem. Katheter.	\N	2	104403	\N	\N	\N
104481	Praemedikation_Einwilligung_Art_Katheter	Doku Einwilligung Art. Katheter.	\N	2	104403	\N	\N	\N
104482	Praemedikation_Einwilligung_BTx	Doku Einwilligung BTx.	\N	2	104403	\N	\N	\N
104483	Praemedikation_Einwilligung_TEE	Doku Einwilligung TEE.	\N	2	104403	\N	\N	\N
104484	Praemedikation_Einwilligung_PAK	Doku Einwilligung PAK.	\N	2	104403	\N	\N	\N
104485	Praemedikation_Einwilligung_ZVK	Doku Einwilligung ZVK.	\N	2	104403	\N	\N	\N
104486	Praemedikation_Einwilligung_thPDA	Doku Einwilligung thorakale PDA.	\N	2	104403	\N	\N	\N
104487	Praemedikation_Einwilligung_Plexusanästhesie	Doku Einwilligung Plexusanästhesie.	\N	2	104403	\N	\N	\N
104488	Praemedikation_Einwilligung_Chefvertreter	Doku Einwilligung Chefvwertreter.	\N	2	104403	\N	\N	\N
104489	Praemedikation_Einwilligung_QEA	Doku Einwilligung QEA.	\N	2	104403	\N	\N	\N
104490	Praemedikation_Einwilligung_PDA	Doku Einwilligung PDA.	\N	2	104403	\N	\N	\N
104491	Praemedikation_Einwilligung_SpA	Doku Einwilligung SpA.	\N	2	104403	\N	\N	\N
104492	Praemedikation_Einwilligung_AS	Doku Einwilligung AS.	\N	2	104403	\N	\N	\N
104493	Praemedikation_Einwilligung_Deep_Sedierung	Doku Einwilligung Deep Sedierung.	\N	2	104403	\N	\N	\N
104494	Praemedikation_Einwilligung_Sedierung	Doku Einwilligung Sedierung.	\N	2	104403	\N	\N	\N
104495	Praemedikation_Einwilligung_FOI	Doku Einwilligung fieberoptische Intubation.	\N	2	104403	\N	\N	\N
104496	Praemedikation_Einwilligung_Kaudale	Doku Einwilligung Kaudale.	\N	2	104403	\N	\N	\N
104497	Praemedikation_Einwilligung_ITN	Doku Einwilligung ITN.	\N	2	104403	\N	\N	\N
104498	Praemedikation_Neurologie_Option_2	Doku Neurologie Option 2.	\N	3	104403	\N	\N	\N
104499	Praemedikation_Neurologie_ICP_Erhöhung	Doku Neurologie ICP Erhöhung.	\N	2	104403	\N	\N	\N
104500	Praemedikation_Neurologie_Krampfleiden	Doku Neurologie Krampfleiden.	\N	2	104403	\N	\N	\N
104501	Praemedikation_Neurologie_Parese	Doku Neurologie Parese.	\N	2	104403	\N	\N	\N
104502	Praemedikation_Neurologie_GCS_Wert	Doku Neurologie Wert.	\N	3	104403	\N	\N	\N
104503	Praemedikation_Neurologie_Option_1	Doku Neurologie Option 1.	\N	3	104403	\N	\N	\N
104504	Praemedikation_Neurologie_GCS	Doku Neurologie GCS.	\N	2	104403	\N	\N	\N
104505	Praemedikation_Neurologie_Ischämie	Doku Neurologie Ischämie.	\N	2	104403	\N	\N	\N
104506	Praemedikation_Neurologie_Ohne_path_Befund	Doku Neurologie ohne pathologischen Befund.	\N	2	104403	\N	\N	\N
104507	Praemedikation_Allergie_Option_2	Doku Allergien Option 2.	\N	3	104403	\N	\N	\N
104508	Praemedikation_Allergie_Kontrastmittel	Doku Allergie Kontrastmittel.	\N	2	104403	\N	\N	\N
104509	Praemedikation_Allergie_Kontakt	Doku Allergie Kontakt.	\N	2	104403	\N	\N	\N
104510	Praemedikation_Allergie_Allergiepass	Doku Allergie Allergiepass	\N	2	104403	\N	\N	\N
104511	Praemedikation_Allergie_Option_1	Doku Allergien Option 1.	\N	3	104403	\N	\N	\N
104512	Praemedikation_Allergie_Antibiotikum	Doku Allergie Antibiotikum.	\N	2	104403	\N	\N	\N
104513	Praemedikation_Allergie_Pollen	Doku Allergien Pollen.	\N	2	104403	\N	\N	\N
104514	Praemedikation_Allergie_Keine	Doku Allergie Keine	\N	2	104403	\N	\N	\N
104515	Praemedikation_Medikation_AT_Antagonist	Doku Medikation AT Antagonist.	\N	2	104403	\N	\N	\N
104516	Praemedikation_Medikation_Analgetikum	Doku Medikation Analgetikum.	\N	2	104403	\N	\N	\N
104517	Praemedikation_Medikation_Antidiabetikum	Doku Medikation Antidiabetikum.	\N	2	104403	\N	\N	\N
104518	Praemedikation_Medikation_Keine	Doku Medikation Keine.	\N	2	104403	\N	\N	\N
104519	Praemedikation_Medikation_Option_3	Doku Medikation Option 3.	\N	3	104403	\N	\N	\N
104520	Praemedikation_Medikation_Antikoagulans	Doku Medikation Antikoagulans.	\N	2	104403	\N	\N	\N
104521	Praemedikation_Medikation_Sartan	Doku Medikation Sartan.	\N	2	104403	\N	\N	\N
104522	Praemedikation_Medikation_ACE_Hemmer	Doku Medikation ACE Hemmer.	\N	2	104403	\N	\N	\N
104523	Praemedikation_Medikation_Option_1	Doku Medikation Option 1.	\N	3	104403	\N	\N	\N
104524	Praemedikation_Medikation_Nitrat	Doku Medikation Nitrat.	\N	2	104403	\N	\N	\N
104525	Praemedikation_Medikation_Antiarrhythmikum	Doku Medikation Antiarrhythmikum	\N	2	104403	\N	\N	\N
104526	Praemedikation_Medikation_NNR_Hormon	Doku Medikation NNR Hormon	\N	2	104403	\N	\N	\N
104527	Praemedikation_Medikation_Option_2	Doku Medikation Option 2.	\N	3	104403	\N	\N	\N
104528	Praemedikation_Medikation_Beta_Blocker	Doku Medikation Beta blocker.	\N	2	104403	\N	\N	\N
104529	Praemedikation_Medikation_Kalziumantagonist	Doku Medikation Kalziumantagonist	\N	2	104403	\N	\N	\N
104530	Praemedikation_Medikation_Diuretikum	Doku Medikation Diuretikum.	\N	2	104403	\N	\N	\N
104531	Praemedikation_Stoffwechsel_Option_1	Dokumentation Stoffwechsel Zusatzoption	\N	3	104403	\N	\N	\N
104532	Praemedikation_Stoffwechsel_Hyperthyreose	Doku Stoffwechsel Hyperthyreose.	\N	2	104403	\N	\N	\N
104533	Praemedikation_Stoffwechsel_Immobilisation	Doku Stoffwechsel Immobilisation.	\N	2	104403	\N	\N	\N
104534	Praemedikation_Stoffwechsel_Gravidität_Gestose	Doku Stoffwechsel Gravidität / Gestose.	\N	2	104403	\N	\N	\N
104535	Praemedikation_Stoffwechsel_C2H5OH_Tagesdosis	Doku Stoffwechsel C2H5OH Tagesdosis.	\N	3	104403	\N	\N	\N
104674	Praemedikation_BGA_pH	\N	\N	3	104403	\N	\N	\N
104536	Praemedikation_Stoffwechsel_Ohne_path_Befund	Doku Stoffwechsel ohne pathologischen Befund.	\N	2	104403	\N	\N	\N
104537	Praemedikation_Stoffwechsel_Niereninsuffizienz	Doku Stoffwechsel Niereninsuffizienz.	\N	2	104403	\N	\N	\N
104538	Praemedikation_Stoffwechsel_C2H5OH	Doku Stoffwechsel C2H5OH.	\N	2	104403	\N	\N	\N
104539	Praemedikation_Stoffwechsel_Hepatopathie	Doku Stoffwechsel Hepathopathie.	\N	2	104403	\N	\N	\N
104540	Praemedikation_Stoffwechsel_Diabetes	Doku Stoffwechsel Diabetes.	\N	2	104403	\N	\N	\N
104541	Praemedikation_Mallampati_nb	Dokumentation der Mallampati Klassifikation.	\N	2	104403	\N	\N	\N
104542	Praemedikation_Mallampati_IV	Dokumentation der Mallampati Klassifikation.	\N	2	104403	\N	\N	\N
104543	Praemedikation_Mallampati_III	Dokumentation der Mallampati Klassifikation.	\N	2	104403	\N	\N	\N
104647	Behandlung_AT_OPMaßnahmeEnde	\N	\N	5	30	\N	\N	\N
104544	Praemedikation_Mallampati_II	Dokumentation der Mallampati Klassifikation.	\N	2	104403	\N	\N	\N
104545	Praemedikation_Mallampati_I	Dokumentation der Mallampati Klassifikation.	\N	2	104403	\N	\N	\N
104546	Praemedikation_Kinnspitze_Kehlk_nb	Dokumentation des Abstandes Kinnspitze Kehlkopf.	\N	2	104403	\N	\N	\N
104547	Praemedikation_Kinnspitze_Kehlk_minus	Dokumentation des Abstandes Kinnspitze Kehlkopf.	\N	2	104403	\N	\N	\N
104548	Praemedikation_Kinnspitze_Kehlk_Fragezeichen	Dokumentation des Abstandes Kinnspitze Kehlkopf.	\N	2	104403	\N	\N	\N
104549	Praemedikation_Kinnspitze_Kehlk_plus	Dokumentation des Abstandes Kinnspitze Kehlkopf.	\N	2	104403	\N	\N	\N
104550	Praemedikation_Kopf_Reklination_nb	Dokumentation der Möglichkeit zur Kopfreklination	\N	2	104403	\N	\N	\N
104551	Praemedikation_Kopf_Reklination_minus	Dokumentation der Möglichkeit zur Kopfreklination	\N	2	104403	\N	\N	\N
104552	Praemedikation_Kopf_Reklination_Fragezeichen	Dokumentation der Möglichkeit zur Kopfreklination	\N	2	104403	\N	\N	\N
104553	Praemedikation_Kopf_Reklination_plus	Dokumentation der Möglichkeit zur Kopfreklination 	\N	2	104403	\N	\N	\N
104554	Praemedikation_Sauerstoffsättigung	Dokumentation der Sauerstoffsättigung.	\N	6	104403	\N	\N	\N
104555	Praemedikation_Blutdruck	Dokumentation des Blutdruckes.	\N	3	104403	\N	\N	\N
104556	Praemedikation_Pulsfrequenz	Dokumentation der Pulsfrequenz.	\N	6	104403	\N	\N	\N
104557	Praemedikation_Aufnahmeart_Ambulant	Dokumentation der Aufnahmeart.	\N	2	104403	\N	\N	\N
104558	Praemedikation_Aufnahmeart_Teilstationär	Dokumentation der Aufnahmeart.	\N	2	104403	\N	\N	\N
104559	Praemedikation_Aufnahmeart_Notaufnahme	Dokumentation der Aufnahmeart.	\N	2	104403	\N	\N	\N
104560	Praemedikation_Aufnahmeart_Stationär	Dokumentation der Aufnahmeart.	\N	2	104403	\N	\N	\N
104561	Praemedikation_Gewicht	Dokumentation des Patientengewichts.	\N	6	104403	\N	\N	\N
104562	Praemedikation_Größe	Dokumentation der Patienntengröße.	\N	6	104403	\N	\N	\N
104563	Praemedikation_Klinik_Station_desPatienten	Dokumentation der Klinik und der Station des Patienten	\N	3	104403	\N	\N	\N
104564	Praemedikation_Labor_BGA_anbei	Dokumentation einer BGA	\N	2	104403	\N	\N	\N
104565	Praemedikation_Labor_Thrombozyten	Doku des Thrombozyten Wertes.	\N	3	104403	\N	\N	\N
104566	Praemedikation_Labor_Hb	Doku des Hb Wertes.	\N	3	104403	\N	\N	\N
104567	Praemedikation_Labor_Leukozyten	Doku des Leukozyten Wertes.	\N	3	104403	\N	\N	\N
104784	Beatmung_MS_C2_Cstat	\N	\N	6	1	\N	\N	\N
104568	Praemedikation_Labor_Fibrinogen	Doku des Fibrinogen Wertes.	\N	3	104403	\N	\N	\N
104569	Praemedikation_Labor_APPT	Doku des APPT Wertes.	\N	3	104403	\N	\N	\N
104570	Praemedikation_Labor_INR	Doku des INR Wertes.	\N	3	104403	\N	\N	\N
104571	Praemedikation_Labor_Quick	Doku des Quick Wertes.	\N	3	104403	\N	\N	\N
104572	Praemedikation_Labor_TSH	Doku des TSH Wertes.	\N	3	104403	\N	\N	\N
104573	Praemedikation_Labor_Glucose	Doku des Glucose Wertes.	\N	3	104403	\N	\N	\N
104574	Praemedikation_Labor_Gamma_GT	Doku des Gamma GT Wertes.	\N	3	104403	\N	\N	\N
104575	Praemedikation_Labor_GOT	Doku des GOT Wertes.	\N	3	104403	\N	\N	\N
104576	Praemedikation_Labor_CRP	Doku des CRP Wertes.	\N	3	104403	\N	\N	\N
104577	Praemedikation_Labor_CK	Doku des CK Wertes.	\N	3	104403	\N	\N	\N
104578	Praemedikation_Labor_GPT	Doku des GPT Wertes.	\N	3	104403	\N	\N	\N
104579	Praemedikation_Labor_Harnstoff_N	Doku des Harnstoo N Wertes.	\N	3	104403	\N	\N	\N
104580	Praemedikation_Labor_Creatinin	Doku des Creatinin Wertes.	\N	3	104403	\N	\N	\N
104581	Praemedikation_Labor_Calcium	Doku des Calcium Wertes.	\N	3	104403	\N	\N	\N
104582	Praemedikation_Labor_Kalium	Doku des Kalium Wertes.	\N	3	104403	\N	\N	\N
104583	Praemedikation_Labor_Natrium	Doku des Natrium Wertes.	\N	3	104403	\N	\N	\N
104584	Praemedikation_Kreislauf_Ödeme	Doku Herz Kreislauf Ödeme.	\N	2	104403	\N	\N	\N
104585	Praemedikation_Kreislauf_AVK	Doku Herz Kreislauf AVK	\N	2	104403	\N	\N	\N
104586	Praemedikation_Kreislauf_Schrittmacher	Doku Herz Kreislauf Schrittmacher.	\N	2	104403	\N	\N	\N
104587	Praemedikation_Kreislauf_Arrhythmie	Doku Herz Kreislauf Arrhythmie	\N	2	104403	\N	\N	\N
104588	Praemedikation_Kreislauf_Vitium	Doku Herz Kreislauf Vitium.	\N	2	104403	\N	\N	\N
104589	Praemedikation_Kreislauf_Allen_Test_re	Doku Herz Kreislauf Allen Test rechts.	\N	2	104403	\N	\N	\N
104590	Praemedikation_Kreislauf_Allen_Test_li	Doku Herz Kreislauf Allen Test links.	\N	2	104403	\N	\N	\N
104591	Praemedikation_Kreislauf_Allen_Test	Doku Herz Kreislauf Allen Test.	\N	2	104403	\N	\N	\N
104592	Praemedikation_Kreislauf_Infarkt	Doku Herz Kreislauf Infarkt.	\N	2	104403	\N	\N	\N
104593	Praemedikation_Kreislauf_NYHA_IV	\N	\N	2	104403	\N	\N	\N
104594	Praemedikation_Kreislauf_NYHA_III	\N	\N	2	104403	\N	\N	\N
104595	Praemedikation_Kreislauf_NYHA_II	\N	\N	2	104403	\N	\N	\N
104596	Praemedikation_Kreislauf_NYHA_I	\N	\N	2	104403	\N	\N	\N
104597	Praemedikation_Kreislauf_APCCS_IV	\N	\N	2	104403	\N	\N	\N
104598	Praemedikation_Kreislauf_APCCS_III	\N	\N	2	104403	\N	\N	\N
104599	Praemedikation_Kreislauf_APCCS_II	\N	\N	2	104403	\N	\N	\N
104600	Praemedikation_Kreislauf_APCCS_I	\N	\N	2	104403	\N	\N	\N
104601	Praemedikation_Kreislauf_Herzinsuffizienz	Doku Herz Kreislauf Herzinsuffizinez.	\N	2	104403	\N	\N	\N
104602	Praemedikation_Kreislauf_KHK	Doku Herz Kreislauf KHK.	\N	2	104403	\N	\N	\N
104675	Praemedikation_BGA_Sauerstoffsättigung	\N	\N	3	104403	\N	\N	\N
104673	Praemedikation_BGA_pCO2	\N	\N	3	104403	\N	\N	\N
104603	Praemedikation_Kreislauf_Flüss_Vol_Defizit	Doku Herz Kreislauf Flüssigkeits / Volumen Defizit.	\N	2	104403	\N	\N	\N
104604	Praemedikation_Kreislauf_Hypotonieneigung	Doku Herz Kreislauf Hypotonieneigung.	\N	2	104403	\N	\N	\N
104605	Praemedikation_Kreislauf_Hypertonie	Doku Herz Kreislauf Hypertonie	\N	2	104403	\N	\N	\N
104606	Praemedikation_Kreislauf_Ohne_path_Befund	Doku Herz Kreislauf 	\N	2	104403	\N	\N	\N
104607	Praemedikation_Kreislauf_Ruhe_EKG	Doku Herz Kreislauf Ruhe EKG.	\N	3	104403	\N	\N	\N
104608	Praemedikation_Lunge_Röntgen_Thorax	Doku Lunge Röntgen Thorax.	\N	3	104403	\N	\N	\N
104609	Praemedikation_Lunge_Auskultation	Doku Lunge Auskultation.	\N	3	104403	\N	\N	\N
104610	Praemedikation_Lunge_FEV1	Doku Lunge FEV1.	\N	3	104403	\N	\N	\N
104611	Praemedikation_Lunge_FVC	Doku Lunge FVC.	\N	3	104403	\N	\N	\N
104612	Praemedikation_Lunge_Beatmung_Doku	Doku Lunge Beatmungseinstellung.	\N	3	104403	\N	\N	\N
104613	Praemedikation_Lunge_Anzahl_Pack_Years	Doku Lunge Anzahle der Pack Years.	\N	3	104403	\N	\N	\N
104614	Praemedikation_Lunge_Pack_Years	Doku Lunge Pack Years.	\N	2	104403	\N	\N	\N
104615	Praemedikation_Lunge_Beatmung	Doku Lunge Beatmung vorhanden ja/nein.	\N	2	104403	\N	\N	\N
104616	Praemedikation_Lunge_COPD	Doku Lunge COPD.	\N	2	104403	\N	\N	\N
104617	Praemedikation_Lunge_Ohne_path_Befund	Doku Lunge ohne pathologischen Befund.	\N	2	104403	\N	\N	\N
104618	Praemedikation_Lunge_Asthma_Bronchiale	Doku Lunge Asthma Bronchiale.	\N	2	104403	\N	\N	\N
104619	Praemedikation_Lunge_Insp_Stridor	Doku Lunge Inspiratorischer Stridor.	\N	2	104403	\N	\N	\N
104620	Praemedikation_Lunge_Restriktion	Doku Lunge Restriktion.	\N	2	104403	\N	\N	\N
104621	Praemedikation_Lunge_Infekt	Doku Lunge Infekt.	\N	2	104403	\N	\N	\N
104622	Praemedikation_Kardio_Diag_P_LV	Doku Kardiologische Diagnostik P LV.	\N	3	104403	\N	\N	\N
104623	Praemedikation_Kardio_Diag_RL_Shunt	Doku Kardiologische Diagnostik R/L Shunt.	\N	3	104403	\N	\N	\N
104624	Praemedikation_Kardio_Diag_EF	Doku Kardiologische Diagnostik EF.	\N	3	104403	\N	\N	\N
104625	Praemedikation_Kardio_Diag_LR_Shunt	Doku Kardiologische Diagnostik L/R Shunt.	\N	3	104403	\N	\N	\N
104626	Praemedikation_Kardio_Diag_dP	Doku Kardiologische Diagnostik dP.	\N	3	104403	\N	\N	\N
104627	Praemedikation_Kardio_Diag_P_AO	Doku Kardiologische Diagnostik P AO.	\N	3	104403	\N	\N	\N
104628	Praemedikation_Kardio_Diag_P_LA	Doku Kardiologische Diagnostik P LA.	\N	3	104403	\N	\N	\N
104629	Praemedikation_Kardio_Diag_CI	Doku kardiologische Diagnostik CI.	\N	3	104403	\N	\N	\N
104630	Praemedikation_Kardio_Diag_PCWP	Doku Kardiologische Diagnostik PCWP.	\N	3	104403	\N	\N	\N
104631	Praemedikation_Kardio_Diag_P_PA	Doku Kardiologische Diagnostik P PA.	\N	3	104403	\N	\N	\N
104632	Praemedikation_Kardio_Diag_P_RV	Doku Kardiologische Diagnostik P RV.	\N	3	104403	\N	\N	\N
104633	Praemedikation_Kardio_Diag_P_RA	Doku Kardiologische Diagnostik P RA.	\N	3	104403	\N	\N	\N
104634	Praemedikation_Kardio_Diag_Option_2	Doku Kardilogische Diagnostik Option 2.	\N	3	104403	\N	\N	\N
104635	Praemedikation_Kardio_Diag_Option_1	Doku Kardiologische Diagnostik Option 1.	\N	3	104403	\N	\N	\N
104636	Praemedikation_Kardio_Diag_bel_EKG	\N	\N	3	104403	\N	\N	\N
104637	Praemedikation_Kardio_Diag_UKGAngio	Doku Kardiologische Diagnostik UKG / Angio	\N	3	104403	\N	\N	\N
104638	Praemedikation_Medikamenten_Tabelle_verabreichtvon	Dokumentation von welcher Person das Medikament verabreicht wurde.	\N	3	104405	\N	\N	\N
104639	Praemedikation_Medikamenten_Tabelle_Applikation	Dokumentation der Applikationsform des verordneten Medikaments.	\N	3	104405	\N	\N	\N
104799	Beatmung_MS_C2_AutoPeep	\N	\N	6	1	\N	\N	\N
104640	Praemedikation_Medikamenten_Tabelle_Dosis	Dokumentation der Dosis des verordneten Medikaments.	\N	3	104405	\N	\N	\N
104641	Praemedikation_Medikamenten_Tabelle_Medikament	Dokumentation des Medikamentes, welche als Prämedikation appliziert werden soll.	\N	3	104405	\N	\N	\N
104642	Praemedikation_Medikamenten_Tabelle_Uhrzeit	Dokumentation der Uhrzeit zu der  die Prämedikation appliziert werden soll.	\N	3	104405	\N	\N	\N
104643	Praemedikation_Medikamenten_Tabelle_Tag	Dokumentation des Tages an dem die Prämedikation appliziert werden soll. In der Regel Vorabend des OP Tages oder OP Tag.	\N	3	104405	\N	\N	\N
104644	Behandlung_AT_AWREnde	\N	\N	5	30	\N	\N	\N
104645	Behandlung_AT_AWRBeginn	\N	\N	5	30	\N	\N	\N
104646	Behandlung_AT_ATEnde	\N	\N	5	30	\N	\N	\N
104648	Behandlung_AT_OPEnde	\N	\N	5	30	\N	\N	\N
104649	Behandlung_AT_OPBeginn	\N	\N	5	30	\N	\N	\N
104650	Behandlung_AT_OPMaßnahmeBeginn	\N	\N	5	30	\N	\N	\N
104651	Behandlung_AT_OPFreigabe	\N	\N	5	30	\N	\N	\N
104652	Behandlung_AT_ATBeginn	\N	\N	5	30	\N	\N	\N
104653	Praemedikation_BGA_Methämoglobin	\N	\N	3	104403	\N	\N	\N
104654	Praemedikation_BGA_Carboxyhämoglobin	\N	\N	3	104403	\N	\N	\N
104655	Praemedikation_BGA_Chlorid	\N	\N	3	104403	\N	\N	\N
104656	Praemedikation_BGA_Plasma_Osmolalität	\N	\N	3	104403	\N	\N	\N
104657	Praemedikation_BGA_Standard_Basenüberschuss	\N	\N	3	104403	\N	\N	\N
104658	Praemedikation_BGA_aktueller_BE	\N	\N	3	104403	\N	\N	\N
104659	Praemedikation_BGA_cHCO3	\N	\N	3	104403	\N	\N	\N
104660	Praemedikation_BGA_pO2_temperatur_korrigiert	\N	\N	3	104403	\N	\N	\N
104661	Praemedikation_BGA_pCO2_temperatur_korrigiert	\N	\N	3	104403	\N	\N	\N
104662	Praemedikation_BGA_pH_temperatur_korrigiert	\N	\N	3	104403	\N	\N	\N
104663	Praemedikation_BGA_cLac	\N	\N	3	104403	\N	\N	\N
104664	Praemedikation_BGA_cGluc	\N	\N	3	104403	\N	\N	\N
104665	Praemedikation_BGA_cCa	\N	\N	3	104403	\N	\N	\N
104666	Praemedikation_BGA_cNa	\N	\N	3	104403	\N	\N	\N
104667	Praemedikation_BGA_cK	\N	\N	3	104403	\N	\N	\N
104668	Praemedikation_BGA_Hct	\N	\N	3	104403	\N	\N	\N
104669	Praemedikation_BGA_Oxyhämoglobin	\N	\N	3	104403	\N	\N	\N
104670	Praemedikation_BGA_sO2	\N	\N	3	104403	\N	\N	\N
104671	Praemedikation_BGA_ctHB	\N	\N	3	104403	\N	\N	\N
104672	Praemedikation_BGA_pO2	\N	\N	3	104403	\N	\N	\N
104676	Praemedikation_BGA_Körpertemperatur	\N	\N	3	104403	\N	\N	\N
104677	Praemedikation_BGA_Abnahmetyp	\N	\N	3	104403	\N	\N	\N
104678	Patient_Spezifitaet_Liste	\N	\N	34	1	\N	\N	\N
104679	Patient_Antikoerper_Liste	\N	\N	34	1	\N	\N	\N
104680	Patient_Blutggruppe_Liste	\N	\N	34	1	\N	\N	\N
104681	Regionalanaesthesien	\N	\N	21	30	\N	\N	\N
104682	Regionalanaesthesien_EinstichtiefeHautniveau	\N	\N	3	104681	\N	\N	\N
104683	Regionalanaesthesien_ZahlPunktionen	\N	\N	3	104681	\N	\N	\N
104684	Regionalanaesthesien_StimulierterNerv_Msec	\N	\N	3	104681	\N	\N	\N
104685	Regionalanaesthesien_StimulierterNerv_MA	\N	\N	3	104681	\N	\N	\N
104686	Regionalanaesthesien_StimulierterNerv	\N	\N	3	104681	\N	\N	\N
104687	Regionalanaesthesien_Liquor_Blutig	\N	\N	2	104681	\N	\N	\N
104688	Regionalanaesthesien_Liquor_Akzidentell	\N	\N	2	104681	\N	\N	\N
104689	Regionalanaesthesien_Liquor_Klar	\N	\N	2	104681	\N	\N	\N
104690	Regionalanaesthesien_Lagerung_Zeitmessung	\N	\N	3	104681	\N	\N	\N
104691	Regionalanaesthesien_Lagerung_Kopftieflage	\N	\N	2	104681	\N	\N	\N
104692	Regionalanaesthesien_Lagerung_Liegen	\N	\N	2	104681	\N	\N	\N
104693	Regionalanaesthesien_Lagerung_Sitzen	\N	\N	2	104681	\N	\N	\N
104694	Regionalanaesthesien_Test_Injektionsschmerz	\N	\N	2	104681	\N	\N	\N
104695	Regionalanaesthesien_Test_Paraesthesie	\N	\N	2	104681	\N	\N	\N
104696	Regionalanaesthesien_Test_Blutaspiration	\N	\N	2	104681	\N	\N	\N
104697	Regionalanaesthesien_Zusatzverfahren	\N	\N	3	104681	\N	\N	\N
104698	Regionalanaesthesien_Punktionsort_Ultraschallgeste	\N	\N	2	104681	\N	\N	\N
104699	Regionalanaesthesien_Punktionsort_Lateral	\N	\N	2	104681	\N	\N	\N
104700	Regionalanaesthesien_Punktionsort_Median	\N	\N	2	104681	\N	\N	\N
104701	Regionalanaesthesien_KanueleStaerke	\N	\N	3	104681	\N	\N	\N
104702	Regionalanaesthesien_Methode	\N	\N	3	104681	\N	\N	\N
104703	Regionalanaesthesien_Bemerkungen	\N	\N	3	104681	\N	\N	\N
104704	AT_Diens	\N	\N	3	30	\N	\N	\N
104705	AT_VerlegtNach	\N	\N	3	30	\N	\N	\N
104706	AT_Arztwahl	\N	\N	2	30	\N	\N	\N
104707	AT_Eingriff	\N	\N	3	30	\N	\N	\N
104708	Beatmung_ES_Pallas_PEEP	Dokumentation des eingestellten PEEP.	mbar	6	1	\N	\N	\N
104709	Beatmung_ES_Pallas_Alter	Dokumentation des Alters des Patienten.	\N	6	1	\N	\N	\N
104710	Beatmung_ES_Pallas_Pmax	Dokumentation des eingestellten Pmax.	mbar	6	1	\N	\N	\N
104712	Beatmung_ES_Pallas_Trigger	Dokumentation des eingestellten Triggers.	L/min	6	1	\N	\N	\N
104782	Beatmung_ES_C2_Ti	\N	\N	6	1	\N	\N	\N
104714	Beatmung_ES_Pallas_T_Rampe	Dokumentation der eingestellten Rampenzeit.	s	6	1	\N	\N	\N
104715	Beatmung_ES_Pallas_Inspirationspause_Tip_Tinsp	Dokumentation der Inspirationszeit. Verhältnis zwischen Tip und Tinsp. 0 bis 60 %.	%	6	1	\N	\N	\N
104716	Beatmung_ES_Pallas_Tinsp	Dokumentation der Inspirationszeit.	s	6	1	\N	\N	\N
104717	Beatmung_ES_Pallas_PS	Dokumentation des eingestellten Pressure Support.	mbar	6	1	\N	\N	\N
104718	Beatmung_ES_Pallas_Frequenz	Dokumentation der eingestellten Frequenz.	1/min	6	1	\N	\N	\N
104719	Beatmung_ES_Pallas_Vt	Dokumentation ders eingestellten Vt.	\N	6	1	\N	\N	\N
104720	Beatmung_MS_Pallas_Ppeak	Dokumentation des gemessenen Beatmungsspitzendruck.	mbar	6	1	\N	\N	\N
104721	Beatmung_MS_Pallas_Pplat	Dokumentation des gemessenen Plateaudruckes.	mbar	6	1	\N	\N	\N
104722	Beatmung_MS_Pallas_PEEP	Dokumentation des gemessenen PEEPs.	mbar	6	1	\N	\N	\N
104723	Beatmung_MS_Pallas_etCO2	Dokumention des gemessenen endtidalen	mmHg	6	1	\N	\N	\N
104724	Beatmung_MS_Pallas_inCO2	Inspiratorisch gemessenes CO2.	mmHg	6	1	\N	\N	\N
104725	Beatmung_MS_Pallas_MV	Gemessenes Atemminutenvolumen.	L/min	6	1	\N	\N	\N
104804	Beatmung_MS_C2_Sauerstoff	\N	\N	6	1	\N	\N	\N
104726	Beatmung_MS_Pallas_Vt	Gemessenes Tidalvolumen.	ml	6	1	\N	\N	\N
104727	Beatmung_MS_Pallas_Frequenz	Gemessene Atemfrequenz.	1/min	6	1	\N	\N	\N
104728	Beatmung_MS_Pallas_MV_Leck	Gemessene Leckage.	ml/min	6	1	\N	\N	\N
104729	Beatmung_MS_Pallas_Cpat	Die gemessene Gesamtcompliance abzüglich der im Selbsttest ermittelten System- und Schlauchcompliance ergibt die Lungencompliance.	ml/mbar	6	1	\N	\N	\N
104730	Beatmung_MS_Pallas_O2_insp	Gemessene inspiratorische O2 Konzentration.	%	6	1	\N	\N	\N
104731	Beatmung_MS_Pallas_O2_exsp	Gemessene exspiratorische O2 Konzentration.	%	6	1	\N	\N	\N
104732	Beatmung_MS_Pallas_MAC_exsp	Gemessener MAC Wert. (endexspiratorische mittlere alveoläre Konzentration)	\N	6	1	\N	\N	\N
104733	Beatmung_MS_Pallas_Halothan_insp	Inspiratorisch gemessene Halothan Konzentration. 	%	6	1	\N	\N	\N
104734	Beatmung_MS_Pallas_Halothan_exsp	Exspiratorisch gemessene Halothankonzentration.	%	6	1	\N	\N	\N
104735	Beatmung_MS_Pallas_Enfluran_insp	Inspiratorisch gemessene Enfluran Konzentration.	%	6	1	\N	\N	\N
104736	Beatmung_MS_Pallas_Enfluran_exsp	Exspiratorisch gemessene Enfluran Kozentration.	%	6	1	\N	\N	\N
104737	Beatmung_MS_Pallas_Isofluran_insp	Inspiratorisch gemessene Isofluran.	%	6	1	\N	\N	\N
104738	Beatmung_MS_Pallas_Isofluran_exsp	Exspiratorisch gemessene Isofluran Konzentration.	%	6	1	\N	\N	\N
104739	Beatmung_MS_Pallas_Desfluran_insp	Inspiratorisch gemessene Desfluran Konzentration.	%	6	1	\N	\N	\N
104740	Beatmung_MS_Pallas_Desfluran_exsp	Exspiratorisch gemessene Desfluran Konzentration.	%	6	1	\N	\N	\N
104741	Beatmung_MS_Pallas_Sevofluran_insp	Inspiratorisch gemessene Sevofluran Konzentration.	%	6	1	\N	\N	\N
104742	Beatmung_MS_Pallas_Sevofluran_exsp	Exspiratorisch gemessene Sevofluran Konzentration.	%	6	1	\N	\N	\N
104743	Beatmung_MS_Pallas_Frischgas_Flow_gesamt	Gemessener Frischgas Flow.	L/min	6	1	\N	\N	\N
104783	Beatmung_ES_C2_Frequenz	\N	\N	6	1	\N	\N	\N
104745	Beatmung_ES_Pallas_Frischgas_O2	An der Flowröhre eingestellter O2 Frischgasflow.	L/min	6	1	\N	\N	\N
104840	NEV_Apherese_Doku_Plasmaloesung	\N	\N	19	1	\N	\N	\N
104746	Beatmung_ES_Pallas_Frischgas_Air	An der Flowröhre eingestellter Frischgas Flow für Air.	L/min	6	1	\N	\N	\N
104747	Beatmung_ES_Pallas_Pinsp	Eingestellter Inspiration Druck.	mbar	6	1	\N	\N	\N
104748	Beatmung_ES_Pallas_Frequenz_Min	Eingestellte Mindestfrequenz (Apnoeventilation) in dme Modus Pressure Support.	1/min	6	1	\N	\N	\N
104749	Beatmung_ES_Pallas_IzuE	Dokumentation des eingestellten I : E.	\N	3	1	\N	\N	\N
104750	Lagerung_AT	\N	\N	19	30	\N	\N	\N
104751	Untersuchung_Kontrolle_Laufraten	Arztdoku S. 10	\N	3	20	\N	\N	\N
104752	Beatmung_ES_G5_Vt_Backup	Vt in der Backupeinstellung	ml	6	1	\N	\N	\N
104800	Beatmung_MS_C2_PeepCPAP	\N	\N	6	1	\N	\N	\N
104753	Beatmung_ES_G5_Frequenz_Backup	Frequenzeinstellung inder Backupeinstellung.	AZ / min	6	1	\N	\N	\N
104754	Beatmung_ES_G5_Apnoezeit_Backup	Apnoezeiteinstellung in der Backupeinstellung.	s	6	1	\N	\N	\N
104756	Beatmung_ES_G5_Pkontrol_Backup	\N	mbar	6	1	\N	\N	\N
104757	Beatmung_ES_G5_IEVerhältnis_Backup	\N	s	3	1	\N	\N	\N
104758	Schlagvolumen	gemessenes Schlagvolumen	ml	6	1	\N	\N	\N
104760	Schlagvolumenindex	Wert des gemessenen Schlagvolumenindex.	ml/m2	6	1	\N	\N	\N
104761	Behandlung_Verlegung_WohinAT	\N	\N	3	30	\N	\N	\N
104762	AT_AT_Zeiten	\N	\N	1	30	\N	\N	\N
104763	AT_AT_Zeiten_Wert	\N	\N	3	104762	\N	\N	\N
104764	AT_AT_Zeiten_Datum	\N	\N	5	104762	\N	\N	\N
104765	Lagerung_ImOP	\N	\N	3	1	\N	\N	\N
104767	Beatmung_ES_NarkosegasSevofluran	\N	%	6	1	\N	\N	\N
104768	Regionalanaesthesien_Erfolg_WaehrendDerOP	\N	\N	3	104681	\N	\N	\N
104769	Regionalanaesthesien_Effekt_VorDerOP	\N	\N	3	104681	\N	\N	\N
104770	Beatmung_ES_Pallas_FrischgasFlow	Gesamt Frischgasfluss (Summe aus O2 + AIR)	L/min	6	1	\N	\N	\N
104771	Beatmung_ES_Pallas_PatGewicht	Eingestelter Patientengewicht am Pallas	kg	6	1	\N	\N	\N
104772	Beatmung_MS_Pallas_Pmean	Gemesener Atemwegsmitteldruck	mbar	6	1	\N	\N	\N
104773	Beatmung_TM_Pallas_TEST	Test	\N	3	1	\N	\N	\N
104774	AT_OraleNahrun	\N	\N	3	30	\N	\N	\N
104775	Regionalanaesthesien_KathetertiefeImVerteilungsrau	\N	\N	3	104681	\N	\N	\N
104776	AT_Telefon_Anaesthesist	Freitext	\N	3	30	\N	\N	\N
104777	AT_Piepser_Anaesthesist	\N	\N	3	30	\N	\N	\N
104778	VolatileAnaesthetika_Einstellung_Balken	\N	\N	26	1	\N	\N	\N
104779	VolatileAnaesthetika_Balken	\N	\N	19	1	\N	\N	\N
104780	AT_O2_Balken	\N	\N	19	1	\N	\N	\N
104781	AT_Air_Balken	\N	\N	19	1	\N	\N	\N
104785	Beatmung_MS_C2_RCexsp	\N	\N	6	1	\N	\N	\N
104786	Beatmung_MS_C2_Rinsp	\N	\N	6	1	\N	\N	\N
104787	Beatmung_MS_C2_IEVerhaeltnis	\N	\N	3	1	\N	\N	\N
104788	Beatmung_MS_C2_TE	\N	\N	6	1	\N	\N	\N
104789	Beatmung_MS_C2_TI	\N	\N	6	1	\N	\N	\N
104790	Beatmung_MS_C2_fSpontan	\N	\N	6	1	\N	\N	\N
104791	Beatmung_MS_C2_fTotal	\N	\N	6	1	\N	\N	\N
104792	Beatmung_MS_C2_ExspFlow	\N	\N	6	1	\N	\N	\N
104793	Beatmung_MS_C2_InsFlow	\N	\N	6	1	\N	\N	\N
104794	Beatmung_MS_C2_VLeckage	\N	\N	6	1	\N	\N	\N
104795	Beatmung_MS_C2_Pinsp	\N	\N	6	1	\N	\N	\N
104796	Beatmung_MS_C2_Mvspont	\N	l	6	1	\N	\N	\N
104797	Beatmung_MS_C2_ExpMinVol	\N	\N	6	1	\N	\N	\N
104798	Beatmung_MS_C2_VTE	\N	\N	6	1	\N	\N	\N
104801	Beatmung_MS_C2_Pmittel	\N	\N	6	1	\N	\N	\N
104802	Beatmung_MS_C2_Pplateau	\N	\N	6	1	\N	\N	\N
104803	Beatmung_MS_C2_Ppeak	\N	mbar	6	1	\N	\N	\N
104805	Beatmung_ES_C2_Flowtrigger	\N	\N	6	1	\N	\N	\N
104806	Beatmung_ES_C2_Groeße	\N	\N	6	1	\N	\N	\N
104807	Beatmung_ES_C2_ProzentVol	\N	\N	6	1	\N	\N	\N
104808	Beatmung_ES_C2_Sauerstoff	\N	vol%	6	1	\N	\N	\N
104809	Beatmung_ES_C2_ETS	\N	\N	6	1	\N	\N	\N
104810	Beatmung_ES_C2_Druckrampe	\N	s	6	1	\N	\N	\N
104811	Beatmung_ES_C2_Ttief	\N	\N	6	1	\N	\N	\N
104812	Beatmung_ES_C2_Thoch	\N	s	6	1	\N	\N	\N
104813	Beatmung_ES_C2_Timax	Inspirationszeit maximal	s	6	1	\N	\N	\N
104814	Beatmung_ES_C2_Pasvlimit	\N	mbar	6	1	\N	\N	\N
104815	Beatmung_ES_C2_Plateau	\N	mbar	6	1	\N	\N	\N
104816	Beatmung_ES_C2_Ptief	\N	\N	6	1	\N	\N	\N
104817	Beatmung_ES_C2_Phoch	\N	mbar	6	1	\N	\N	\N
104818	Beatmung_ES_C2_Pkontrol	\N	mbar	6	1	\N	\N	\N
104819	Beatmung_ES_C2_Psupport	\N	\N	6	1	\N	\N	\N
104820	Beatmung_ES_C2_Pinsp	\N	mbar	6	1	\N	\N	\N
104821	Beatmung_ES_C2_PeepCPAP	\N	mbar	6	1	\N	\N	\N
104822	Beatmung_ES_C2_IEVerhaeltnis	\N	\N	3	1	\N	\N	\N
104823	Beatmung_ES_C2_Vt	\N	ml	6	1	\N	\N	\N
104824	NEV_Apherese_MS_Multi_Behandlungs_Zeit	\N	\N	3	1	\N	\N	\N
104825	NEV_Apherese_MS_Multi_UFRBFRVerhältnis	\N	\N	6	1	\N	\N	\N
104826	NEV_Apherese_MS_Multi_PlasmaVolKum	\N	\N	6	1	\N	\N	\N
104827	NEV_Apherese_MS_Multi_pFDruck	\N	\N	6	1	\N	\N	\N
104828	NEV_Apherese_MS_Multi_TMP	\N	\N	6	1	\N	\N	\N
104829	NEV_Apherese_MS_Multil_venDruck	\N	\N	6	1	\N	\N	\N
104830	NEV_Apherese_MS_Multi_artDruck	\N	\N	6	1	\N	\N	\N
104831	NEV_Apherese_ES_Multi_Temperatur	\N	\N	6	1	\N	\N	\N
104832	NEV_Apherese_ES_Multi_Blutfluss	\N	\N	6	1	\N	\N	\N
104833	NEV_Apherese_ES_Multi_Plasma	\N	\N	6	1	\N	\N	\N
104834	NEV_Apherese_ES_Multi_PlasmaVolumen	\N	\N	6	1	\N	\N	\N
104835	NEV_Apherese_Doku_Spuel_Dauer	\N	\N	3	1	\N	\N	\N
104836	NEV_Apherese_Doku_Fuellen_Mit	\N	\N	3	1	\N	\N	\N
104837	NEV_Apherese_Doku_SpülloesungAntikoag	\N	\N	3	1	\N	\N	\N
104838	NEV_Apherese_Doku_Bolus_Antikoag	\N	\N	3	1	\N	\N	\N
104839	NEV_Apherese_Doku_Antikoagulation	\N	\N	19	1	\N	\N	\N
104841	NEV_Apherese_Doku_Filter	\N	\N	19	1	\N	\N	\N
104842	NEV_Apherese_Doku_Zugang	\N	\N	19	1	\N	\N	\N
104843	NEV_Apherese_Doku_Balken	\N	\N	26	1	\N	\N	\N
104844	NEV_Apherese_VO_Multi_Temperatur	\N	\N	6	1	\N	\N	\N
104845	NEV_Apherese_VO_Multi_BlutflussMax	\N	\N	6	1	\N	\N	\N
104846	NEV_Apherese_VO_Multi_Plasma_Volumen	\N	\N	6	1	\N	\N	\N
104847	NEV_Apherese_VO_Spuel_Dauer	\N	\N	3	1	\N	\N	\N
104848	NEV_Apherese_VO_Fuellen_Mit	\N	\N	3	1	\N	\N	\N
104849	NEV_Apherese_VO_SpülloesungAntikoag	\N	\N	3	1	\N	\N	\N
104850	NEV_Apherese_VO_Bolus_Antikoag	\N	\N	3	1	\N	\N	\N
104851	NEV_Apherese_VO_Antikoagulation	\N	\N	3	1	\N	\N	\N
104852	NEV_Apherese_VO_Plasmaloesung	\N	\N	3	1	\N	\N	\N
104853	NEV_Apherese_VO_Filter	\N	\N	3	1	\N	\N	\N
104854	NEV_Apherese_VO_Zugang	\N	\N	3	1	\N	\N	\N
104855	NEV_Apherese_VO_Balken	\N	\N	26	1	\N	\N	\N
104856	NEV_HD_Doku_Abschlussbegründung	\N	\N	3	1	\N	\N	\N
104857	NEV_HD_Doku_Abschlussbeurteilung	\N	\N	3	1	\N	\N	\N
104858	NEV_HD_MS_4008onl_Rest_Zeit	\N	\N	3	1	\N	\N	\N
104859	NEV_HD_MS_4008onl_SubBolusVolKum	\N	\N	6	1	\N	\N	\N
104860	NEV_HD_MS_4008onl_SubVolKum	\N	\N	6	1	\N	\N	\N
104861	NEV_HD_MS_4008onl_IsoUFVolKum	\N	\N	6	1	\N	\N	\N
104862	NEV_HD_MS_4008onl_BlutvolKum	\N	\N	6	1	\N	\N	\N
104863	NEV_HD_MS_4008onl_effBlutfluss	\N	\N	6	1	\N	\N	\N
104864	NEV_HD_MS_4008onl_Leitfähigkeit	\N	\N	6	1	\N	\N	\N
104865	NEV_HD_MS_4008onl_SollNa	\N	\N	6	1	\N	\N	\N
104866	NEV_HD_MS_4008onl_TMP	\N	\N	6	1	\N	\N	\N
104867	NEV_HD_MS_4008onl_venDruck	\N	\N	6	1	\N	\N	\N
104868	NEV_HD_MS_4008onl_artDruck	\N	\N	6	1	\N	\N	\N
104869	NEV_HD_MS_4008HS_Rest_Zeit	\N	\N	3	1	\N	\N	\N
104870	NEV_HD_MS_4008HS_IsoUFVolKum	\N	\N	6	1	\N	\N	\N
104871	NEV_HD_MS_4008HS_BlutvolKum	\N	\N	6	1	\N	\N	\N
104873	NEV_HD_MS_4008HS_Leitfähigkeit	\N	\N	6	1	\N	\N	\N
104874	NEV_HD_MS_4008HS_SollNa	\N	\N	6	1	\N	\N	\N
104875	NEV_HD_MS_4008HS_TMP	\N	\N	6	1	\N	\N	\N
104876	NEV_HD_MS_4008HS_venDruck	\N	\N	6	1	\N	\N	\N
104877	NEV_HD_MS_4008HS_artDruck	\N	\N	6	1	\N	\N	\N
104878	NEV_HD_MS_4008_HS_onl_Ultrafiltratmengekum	\N	\N	6	1	\N	\N	\N
104879	NEV_HD_ES_4008HS_Fluss	\N	\N	6	1	\N	\N	\N
104880	NEV_HD_ES_4008HS_Temperatur	\N	\N	6	1	\N	\N	\N
104881	NEV_HD_ES_4008HS_Bicarbonat	\N	\N	6	1	\N	\N	\N
104882	NEV_HD_ES_4008HS_SollNa	\N	\N	6	1	\N	\N	\N
104883	NEV_HD_ES_4008HS_BasisNa	\N	\N	6	1	\N	\N	\N
104884	NEV_HD_ES_4008HS_StartNa	\N	\N	6	1	\N	\N	\N
104885	NEV_HD_ES_4008HS_NaProfil	\N	\N	6	1	\N	\N	\N
104886	NEV_HD_ES_4008HS_UFProfil	\N	\N	6	1	\N	\N	\N
104887	NEV_HD_ES_4008HS_BlutflussSNPumpe	\N	\N	6	1	\N	\N	\N
104889	NEV_HD_ES_4008HS_IsoUF_Rate	\N	\N	6	1	\N	\N	\N
104890	NEV_HD_ES_4008HS_IsoUFZeit	\N	\N	6	1	\N	\N	\N
104891	NEV_HD_ES_4008HS_IsoUFZiel	\N	\N	6	1	\N	\N	\N
104892	NEV_HD_ES_4008HS_UFRate	\N	\N	6	1	\N	\N	\N
104893	NEV_HD_ES_4008HS_UFZiel	\N	\N	6	1	\N	\N	\N
104894	NEV_HD_ES_4008HS_Dialysezeit	\N	\N	3	1	\N	\N	\N
104895	NEV_HD_ES_4008onl_Fluss	\N	\N	6	1	\N	\N	\N
104896	NEV_HD_ES_4008onl_Temperatur	\N	\N	6	1	\N	\N	\N
104897	NEV_HD_ES_4008onl_Bicarbonat	\N	\N	6	1	\N	\N	\N
104898	NEV_HD_ES_4008onl_SollNa	\N	\N	6	1	\N	\N	\N
104899	NEV_HD_ES_4008onl_StartNa	\N	\N	6	1	\N	\N	\N
104900	NEV_HD_ES_4008onl_BasisNa	\N	\N	6	1	\N	\N	\N
104872	NEV_HD_MS_4008HS_effBlutfluss	\N	mL/min	6	1	\N	\N	\N
104888	NEV_HD_ES_4008HS_Blutfluss	\N	mL/min	6	1	\N	\N	\N
104901	NEV_HD_ES_4008onl_NaProfil	\N	\N	6	1	\N	\N	\N
104902	NEV_HD_ES_4008onl_UFProfil	\N	\N	6	1	\N	\N	\N
104903	NEV_HD_ES_4008onl_Substituatbolus	\N	\N	6	1	\N	\N	\N
104904	NEV_HD_ES_4008onl_Substituatrate	\N	\N	6	1	\N	\N	\N
104905	NEV_HD_ES_4008onl_Substituat	\N	\N	6	1	\N	\N	\N
104906	NEV_HD_ES_4008onl_BlutflussSNPumpe	\N	\N	6	1	\N	\N	\N
104907	NEV_HD_ES_4008onll_Blutfluss	\N	\N	6	1	\N	\N	\N
104908	NEV_HD_ES_4008onl_UFRate	\N	\N	6	1	\N	\N	\N
104909	NEV_HD_ES_4008onl_IsoUFZiel	\N	\N	6	1	\N	\N	\N
104910	NEV_HD_ES_4008onl_UFZiel	\N	\N	6	1	\N	\N	\N
104911	NEV_HD_Doku_Bolusgabe	\N	\N	3	1	\N	\N	\N
104912	NEV_HD_Doku_FuellenMit	\N	\N	3	1	\N	\N	\N
104913	NEV_HD_ES_4008onl_Dialyse_Zeit	\N	\N	3	1	\N	\N	\N
104914	NEV_HD_Doku_SpüllösungAntikoag	\N	\N	3	1	\N	\N	\N
104915	NEV_HD_Doku_Antikoagulation	\N	\N	19	1	\N	\N	\N
104916	NEV_HD_Doku_Konzentrat	\N	\N	19	1	\N	\N	\N
104917	NEV_HD_Doku_Filter	\N	\N	19	1	\N	\N	\N
104918	NEV_HD_Doku_Zugang	\N	\N	19	1	\N	\N	\N
104919	NEV_HD_Doku_Balken	\N	\N	26	1	\N	\N	\N
104920	NEV_HD_VO_4008onl_Fluss	\N	\N	6	1	\N	\N	\N
104921	NEV_HD_VO_4008onl_Temperatur	\N	\N	6	1	\N	\N	\N
104922	NEV_HD_VO_4008onl_Bicarbonat	\N	\N	6	1	\N	\N	\N
104923	NEV_HD_VO_4008onl_SollNa	\N	\N	6	1	\N	\N	\N
104924	NEV_HD_VO_4008onl_StartNa	\N	\N	6	1	\N	\N	\N
104925	NEV_HD_VO_4008onl_NaProfil	\N	\N	6	1	\N	\N	\N
104926	NEV_HD_VO_4008onl_UFProfil	\N	\N	6	1	\N	\N	\N
104927	NEV_HD_VO_4008onl_Substituatbolus	\N	\N	6	1	\N	\N	\N
104928	NEV_HD_VO_4008onl_Substituat	\N	\N	6	1	\N	\N	\N
104929	NEV_HD_VO_4008onl_BlutflussSNPumpe	\N	\N	6	1	\N	\N	\N
104930	NEV_HD_VO_4008onl_BlutflussMax	\N	\N	6	1	\N	\N	\N
104931	NEV_HD_VO_4008onl_UFZiel	\N	\N	6	1	\N	\N	\N
104932	NEV_HD_VO_4008onl_Iso_UFZeit	\N	\N	3	1	\N	\N	\N
104933	NEV_HD_VO_4008onl_IsoUFZiel	\N	\N	6	1	\N	\N	\N
104934	NEV_HD_VO_4008onl_Dialysezeit	\N	\N	3	1	\N	\N	\N
104935	NEV_HD_VO_4008HS_Fluss	\N	\N	6	1	\N	\N	\N
104936	NEV_HD_VO_4008HS_Temperatur	\N	\N	6	1	\N	\N	\N
104937	NEV_HD_VO_4008HS_Bicarbonat	\N	\N	6	1	\N	\N	\N
104938	NEV_HD_VO_4008HS_Soll_Na	\N	\N	6	1	\N	\N	\N
104939	NEV_HD_VO_4008HS_Start_Na	\N	\N	6	1	\N	\N	\N
104940	NEV_HD_VO_4008HS_Na_Profil	\N	\N	6	1	\N	\N	\N
104941	NEV_HD_VO_4008HS_UF_Profil	\N	\N	6	1	\N	\N	\N
104942	NEV_HD_VO_4008HS_Blutfluss_SN_Pumpe	\N	\N	6	1	\N	\N	\N
104943	NEV_HD_VO_4008HS_Blutfluss_Max	\N	\N	6	1	\N	\N	\N
104944	NEV_HD_VO_4008HS_UF_Ziel	\N	\N	6	1	\N	\N	\N
104945	NEV_HD_VO_4008HS_IsoUFZiel	\N	\N	6	1	\N	\N	\N
104946	NEV_HD_VO_4008HS_Iso_UFZeit	\N	\N	6	1	\N	\N	\N
104947	NEV_HD_VO_4008HS_Dialysezeit	\N	\N	3	1	\N	\N	\N
104948	NEV_HD_VO_FuellenMit	\N	\N	3	1	\N	\N	\N
104949	NEV_HD_VO_SpüllösungAntikoag	\N	\N	3	1	\N	\N	\N
104950	NEV_HD_VO_Bolus	\N	\N	3	1	\N	\N	\N
104951	NEV_HD_VO_Antikoagulation	\N	\N	3	1	\N	\N	\N
104952	NEV_HD_VO_Konzentrat	\N	\N	3	1	\N	\N	\N
104953	NEV_HD_VO_Option	\N	\N	3	1	\N	\N	\N
104954	NEV_HD_VO_Filter	\N	\N	3	1	\N	\N	\N
104955	NEV_HD_VO_Zugang	\N	\N	3	1	\N	\N	\N
104956	NEV_HD_VO_Balken	\N	\N	26	1	\N	\N	\N
104957	NEV_CRRT_Doku_AbschlussUrteil	\N	\N	3	1	\N	\N	\N
104958	NEV_CRRT_Doku_AbschlussBegruendung	\N	\N	3	1	\N	\N	\N
104959	NEV_CRRT_MS_Multi_BehandlungszeitAktuell	\N	\N	3	1	\N	\N	\N
104960	NEV_HD_ES_4008onl_IsoUFZeit	\N	\N	6	1	\N	\N	\N
104961	NEV_CRRT_MS_Multi_UFR_BFRVerhaeltnis	\N	\N	6	1	\N	\N	\N
104962	NEV_CRRT_MS_Multi_CalciumVolKum	\N	\N	6	1	\N	\N	\N
104963	NEV_CRRT_MS_Multi_CitratvolKum	\N	\N	6	1	\N	\N	\N
104964	NEV_CRRT_MS_Multi_SubBolusVolKum	\N	\N	6	1	\N	\N	\N
104965	NEV_CRRT_MS_Multi_SubVolKum	\N	\N	6	1	\N	\N	\N
104966	NEV_CRRT_MS_Multi_DialysatvolKum	\N	\N	6	1	\N	\N	\N
104967	NEV_CRRT_MS_Multi_Bilanz	\N	\N	6	1	\N	\N	\N
104968	NEV_CRRT_MS_Multi_Calciumfluss	\N	\N	6	1	\N	\N	\N
104969	NEV_CRRT_MS_Multi_Citratfluss	\N	\N	6	1	\N	\N	\N
104970	NEV_CRRT_MS_Multi_TMP	\N	\N	6	1	\N	\N	\N
104971	NEV_CRRT_MS_Multi_venDruck	\N	\N	6	1	\N	\N	\N
104972	NEV_CRRT_MS_Multi_artDruck	\N	\N	6	1	\N	\N	\N
104973	NEV_CRRT_ES_Multi_Temperatur	\N	\N	6	1	\N	\N	\N
104975	NEV_CRRT_ES_Multi_CitratBlut	\N	\N	6	1	\N	\N	\N
104976	NEV_CRRT_ES_Multi_SubstituatBolus	\N	\N	6	1	\N	\N	\N
104977	NEV_CRRT_ES_Multi_Substituat	\N	\N	6	1	\N	\N	\N
104978	NEV_CRRT_ES_Multi_Dialysat	\N	\N	6	1	\N	\N	\N
104979	NEV_CRRT_ES_Multi_Ultrafiltration	\N	\N	6	1	\N	\N	\N
104980	NEV_CRRT_ES_Multi_Blutfluss	\N	\N	6	1	\N	\N	\N
104981	NEV_CRRT_Doku_Fuellen_Mit	\N	\N	3	1	\N	\N	\N
104982	NEV_CRRT_Doku_SpülloesungAntikoag	\N	\N	3	1	\N	\N	\N
104974	NEV_CRRT_ES_Multi_CalciumFiltrat	\N	mmol/L	6	1	\N	\N	\N
104983	NEV_CRRT_Doku_BolusAntikoag	\N	\N	3	1	\N	\N	\N
104984	NEV_CRRT_Doku_Antikoagulation	\N	\N	19	1	\N	\N	\N
104985	NEV_CRRT_Doku_CalciumLoesung	\N	\N	19	1	\N	\N	\N
104986	NEV_CRRT_Doku_CitratLoesung	\N	\N	19	1	\N	\N	\N
104987	NEV_CRRT_Doku_HFLoesung	\N	\N	19	1	\N	\N	\N
104988	NEV_CRRT_Doku_Dialysatloesung	\N	\N	19	1	\N	\N	\N
104989	NEV_CRRT_Doku_Option	\N	\N	19	1	\N	\N	\N
104990	NEV_CRRT_Doku_Spuel_Dauer	\N	\N	3	1	\N	\N	\N
104991	NEV_CRRT_Doku_Filter	\N	\N	19	1	\N	\N	\N
104992	NEV_CRRT_Doku_Zugang	\N	\N	19	1	\N	\N	\N
104994	NEV_CRRT_VO_Multi_Temperatur	\N	\N	6	1	\N	\N	\N
104995	NEV_CRRT_VO_Multi_CalciumFiltrat	\N	\N	6	1	\N	\N	\N
104996	NEV_CRRT_VO_Multi_CitratBlut	\N	\N	6	1	\N	\N	\N
104997	NEV_CRRT_VO_Multi_SubstituatBolus	\N	\N	6	1	\N	\N	\N
104998	NEV_CRRT_VO_Multi_Substituat	\N	\N	6	1	\N	\N	\N
104999	NEV_CRRT_VO_Multi_Dialysat	\N	\N	6	1	\N	\N	\N
105000	NEV_CRRT_VO_Multi_Ultrafiltration	\N	\N	6	1	\N	\N	\N
105001	NEV_CRRT_VO_Multi_BlutflussMax	\N	\N	6	1	\N	\N	\N
105002	NEV_CRRT_VO_Fuellen_Mit	\N	\N	3	1	\N	\N	\N
105003	NEV_CRRT_VO_SpülloesungAntikoag	\N	\N	3	1	\N	\N	\N
105004	NEV_CRRT_VO_BolusAntikoag	\N	\N	3	1	\N	\N	\N
105005	NEV_CRRT_VO_Antikoagulation	\N	\N	3	1	\N	\N	\N
105006	NEV_CRRT_VO_CalciumLoesung	\N	\N	3	1	\N	\N	\N
105007	NEV_CRRT_VO_CitratLoesung	\N	\N	3	1	\N	\N	\N
105008	NEV_CRRT_VO_HFLoesung	\N	\N	3	1	\N	\N	\N
105009	NEV_CRRT_VO_Dialysatloesung	\N	\N	3	1	\N	\N	\N
105010	NEV_CRRT_VO_Option	\N	\N	3	1	\N	\N	\N
105011	NEV_CRRT_VO_Filter	\N	\N	3	1	\N	\N	\N
105012	NEV_CRRT_VO_Zugang	\N	\N	3	1	\N	\N	\N
105013	NEV_CRRT_VO_Balken	\N	\N	26	1	\N	\N	\N
105014	Schrittmacher_Osypka101H_ES_Rate	Grundfrequenz	ppm	6	1	\N	\N	\N
105015	Schrittmacher_Osypka101H_ES_Sense	Empfindlichkeit	mV	6	1	\N	\N	\N
105016	Schrittmacher_Osypka101H_ES_STIM	Stimulation	V	6	1	\N	\N	\N
105017	Schrittmacher_Osypka101H_ES_Betriebsart	Listenauswahl	\N	3	1	\N	\N	\N
105018	Schrittmacher_Osypka101H_ES_HighRateSTIM	Listenauswahl	\N	3	1	\N	\N	\N
105019	Schrittmacher_Osypka203H_ES_Rate	Grundfrequenz	ppm	6	1	\N	\N	\N
105020	Schrittmacher_Osypka203H_ES_A_Sense	Empfindlichkeit	mV	6	1	\N	\N	\N
105021	Schrittmacher_Osypka203H_ES_V_Sense	Empfindlichkeit Ventrikel	mV	6	1	\N	\N	\N
105022	Schrittmacher_Osypka203H_ES_A_STIM	Stimulation Vorhof	V	6	1	\N	\N	\N
105023	Schrittmacher_Osypka203H_ES_V_STIM	Stimulation Ventrikel	V	6	1	\N	\N	\N
105024	Schrittmacher_Osypka203H_ES_AV_DLY	AV Überleitungszeit	ms	6	1	\N	\N	\N
105025	Schrittmacher_Osypka203H_ES_Highrate_StimRate	Überstimulationsfrequenz Vorhof	ppm	6	1	\N	\N	\N
105026	Schrittmacher_Osypka203H_ES_V_RapidPacing	Rapid Pacing Stimulationsfrequenz	ppm	6	1	\N	\N	\N
105027	Schrittmacher_Osypka203H_ES_PVARP	postventrikuläre atriale Refraktärzeit	ms	6	1	\N	\N	\N
105028	Schrittmacher_Osypka203H_ES_ARP	atriale Refraktärzeit	ms	6	1	\N	\N	\N
105029	Schrittmacher_Osypka203H_ES_VRP	ventrikuläre Stimulationsfrequenz	ms	6	1	\N	\N	\N
105030	Schrittmacher_Osypka203H_ES_MTR	obere Frequenzbegrenzung	ppm	6	1	\N	\N	\N
105031	Schrittmacher_Osypka203H_ES_Betriebsart	Liste	\N	3	1	\N	\N	\N
105033	Schrittmacher_Osypka203H_ES_A-Sense	\N	mV	3	1	\N	\N	\N
105034	Schrittmacher_Osypka203H_ES_V-Sense	\N	\N	3	1	\N	\N	\N
105035	Schrittmacher_Osypka203H_ES_result_Betriebsart	abhängig in ES der Sense-Liste	\N	3	1	\N	\N	\N
105038	Behandlungsstrategie_Zielvorgaben_endexp_CO2	\N	\N	3	30	\N	\N	\N
105039	AT_Dienst	\N	\N	2	30	\N	\N	\N
105040	AT_Letzte_OraleNahrung	\N	\N	5	30	\N	\N	\N
105041	AT_O2Flow	\N	l/min	26	1	\N	\N	\N
105042	AT_volatile_AnaesthetikAuswahl_Balken	Art d.Narkosegas	\N	19	1	\N	\N	\N
105043	Hypothermie_ArticSun_MS_Wassertemperatur	kontrollierte Wassertemperatur, gemessener Wert	°C	6	1	\N	\N	\N
105044	AT_Name_Anaesthesist_entlassender	Name des Anästhesisten, der als entlassender Anästhesist auf dem Ausdruck des Anästhesieprotokolls erscheint.	\N	3	30	\N	\N	\N
105045	BIS	Der Bispectral Index (BIS) ist ein verarbeiteter EEG Parameter und zeigt die Auswirkungen der Sedierung auf das Gehirn an.	\N	6	1	\N	\N	\N
105046	BSR	entspricht der SR Anzeige am Gerät. Burst Supression Ratio	%	6	1	\N	\N	\N
105117	Patient_Befunde_Fremd_MessageID	\N	\N	2	105104	\N	\N	\N
105049	NEV_CRRT_ES_Multi_Temp	neu angelegt am 18.05.2012	°C	3	1	\N	\N	\N
105050	NEV_CRRT_VO_Multi_Temp	Neuanlage 18.05.2012 String	°C	3	1	\N	\N	\N
105051	NEV_Apherese_VO_Multi_Temp	Anlage 18.05.2012 String	°C	3	1	\N	\N	\N
105052	NEV_Apherese_ES_Multi_Temp	Anlage 18.05.2012	°C	3	1	\N	\N	\N
105053	NEV_Apherese_Doku_AbschlussBegruendung	Listenauswahl	\N	3	1	\N	\N	\N
105054	NEV_Apherese_Doku_AbschlussUrteil	Listenauswahl	\N	3	1	\N	\N	\N
105055	Konfiguration1	\N	\N	37	0	\N	\N	\N
105056	Mitarbeitersuche_Name	\N	\N	3	105055	\N	\N	\N
105057	Atemwege_subglott_Fuellstand	Der dokumentierte Füllstand des Auffangbehälters der subglotischen Absaugung.	ml	6	100150	\N	\N	\N
105058	Atemwege_subglott_Menge	Dokumentierte Menge des extrahierten subglottischen Sekrets.	ml	6	100150	\N	\N	\N
105059	Atemwege_subglott_Sog_MS	Der am Gerät gemessene Sog bei der Verwendung eines Gerätes zur subglottischen Absaugung.	mmHg	6	100150	\N	\N	\N
105060	Atemwege_subglott_Modus	Der eingestellte Modus am Gerät beim Einsatz der subglottischen Absaugung.	\N	19	100150	\N	\N	\N
105061	NEV_Apherese_MS_Cobe_PlasmaVolKum	\N	\N	6	1	\N	\N	\N
105062	NEV_Apherese_MS_OctoNova_PlasmaVolKum	\N	l	6	1	\N	\N	\N
105063	Behandlung_Aufwachversuch	\N	\N	1	30	\N	\N	\N
105064	Behandlung_Aufwachversuch_Object_RefListValue	\N	\N	34	105063	\N	\N	\N
105065	Behandlung_Aufwachversuch_Abruch_Zeitpunkt	Dokumentierter Zeitpunkt, zu dem der Aufwachversuch abgebrochen wurde.	\N	5	105063	\N	\N	\N
105066	Behandlung_Aufwachversuch_Abbruch	Gründe für den Abbruch des dokumentierten Aufwachversuches.	\N	3	105063	\N	\N	\N
105067	Behandlung_Aufwachversuch_Freitext	Möglichkeit Freitext zu einem Aufwachversuch zu dokumentieren.	\N	3	105063	\N	\N	\N
105068	Behandlung_Aufwachversuch_CAM_ICU	CAM ICU Einschätzung des dokumentierten Aufwachversuches.	\N	3	105063	\N	\N	\N
105069	Behandlung_Aufwachversuch_Motorik	Beurteilung der Motorik im dokumentierten Aufwachversuches.	\N	3	105063	\N	\N	\N
105070	Behandlung_Aufwachversuch_Augen_oeffnen	Beurteilung des Augen öffnens im dokumentierten Aufwachversuches.	\N	3	105063	\N	\N	\N
105071	Behandlung_Aufwachversuch_Schutzreflexe	Beurteilung der Schutzreflexe im dokumentierten Aufwachversuches.	\N	3	105063	\N	\N	\N
105072	Behandlung_Aufwachversuch_Vegetative_Reaktion	Beurteilung der Vegetativen Reaktion im dokumentierten Aufwachversuches.	\N	3	105063	\N	\N	\N
105073	Behandlung_Aufwachversuch_Durchgefuehrt	Dokumentation des  Aufwachversuches. Dürchführung Ja /Nein.	\N	3	105063	\N	\N	\N
105074	Behandlung_Aufwachversuch_Datum	Datum des dokumentierten Aufwachversuches.	\N	5	105063	\N	\N	\N
105075	Beatmung_ES_C2_Body_Wt	Eingestelltes Körpergewicht beim respirator C2.	\N	3	1	\N	\N	\N
105076	Beatmung_ES_C2_Drucktrigger	Inspiratorische Bemühung des Patienten, die das Beatmungsgerät veranlasst, einen Atemhub abzugeben.	mbar	6	1	\N	\N	\N
105077	Beatmung_ES_C2_Pmax	Eingestellte Alarmhochdruckgrenze. Einstellung erfolgtdirekt über die Alarmeinstellung aber auch indirekt über die Einstellung Pasvlimit. Die Alarmhochdruckgrenze liegt automatisch 10 mbar über der Pasvlimit Einstellung.	mbar	6	1	\N	\N	\N
105078	Beatmung_ES_C2_PEEP_CPAP_Ptief	Eingestellter PEEP, CPAP oder Ptief am C2.	mbar	6	1	\N	\N	\N
105079	Beatmung_ES_C2_Pkontrol_Phoch	Eingestellter Pkontrol oder Phoch am C2.	mbar	6	1	\N	\N	\N
105080	Beatmung_ES_C2_F_CMV	Eingestellte CMV Frequenz bei dem Respirator C2  in den Beatmungsmodi DUOPAP, APVcmv, Pcmv, 	\N	3	1	\N	\N	\N
105081	Beatmung_ES_C2_F_SIMV	Eingestellt SIMV Frequenz bei dne Respiratoren C2 5 in den Beatmungsmodi APVsimv, Psimv.	\N	3	1	\N	\N	\N
105082	Beatmung_ES_G5_Body_Wt	Eingestelltes Körpergewicht.	kg	3	1	\N	\N	\N
105083	Beatmung_ES_G5_F_CMV	Eingestellte CMV Frequenz bei dem Respirator G5 in den Beatmungsmodi DUOPAP, APVcmv, Pcmv, 	b/min	3	1	\N	\N	\N
105084	Beatmung_ES_G5_F_SIMV	Eingestellt SIMV Frequenz bei dem Respirator G5 in den Beatmungsmodi APVsimv, Psimv.	b/min	3	1	\N	\N	\N
105085	Beatmung_ES_G5_PEEP_CPAP_Ptief	Eingestelltes unteres Druckniveau bei den Respirator G5 in verschiedenen Beatmungsmodis.	mbar	6	1	\N	\N	\N
105086	Beatmung_ES_G5_Pkontrol_Phoch	Eingestelltes oberes Druckniveau bei dem Respirator  G5 in verschiedenen Beatmungsmodi.	mbar	6	1	\N	\N	\N
105087	Behandlung_Wertsachen_Angenommen_Von	Person, die die Wertsachen angenommen hat	\N	3	30	\N	\N	\N
105125	Dekanuelierungsplan_Dekanuelierung_ja	\N	\N	2	105122	\N	\N	\N
105088	Fall_Wertsachen_ausgehaendigt_komplett	Ob alle Wertsachen vollständig ausgehändigt wurden (Ja/Nein)	\N	2	20	\N	\N	\N
105089	Behandlung_Wertsachen_POE	\N	\N	3	30	\N	\N	\N
105090	Fall_Wertsachen_Wertgegenstaende	\N	\N	3	20	\N	\N	\N
105091	Behandlung_Wertsachen_Datum	\N	\N	5	30	\N	\N	\N
105092	Fall_Wertsachen_Prothese	\N	\N	3	20	\N	\N	\N
105093	Fall_Wertsachen_Pflegeuntensilien_Ort	\N	\N	3	20	\N	\N	\N
105094	Fall_Wertsachen_Pflegeuntensilien	\N	\N	3	20	\N	\N	\N
105095	Fall_Wertsachen_Prothese_Ort	\N	\N	3	20	\N	\N	\N
105096	Fall_Wertsachen_Kleidungsstuecke	\N	\N	3	20	\N	\N	\N
105097	Fall_Wertsachen_Kleidungsstuecke_Ort	\N	\N	3	20	\N	\N	\N
105098	Fall_Wertsachen_Papiere	\N	\N	3	20	\N	\N	\N
105099	Fall_Wertsachen_Papiere_Ort	\N	\N	3	20	\N	\N	\N
105100	Fall_Wertsachen_Wertgegenstaende_Ort	\N	\N	3	20	\N	\N	\N
105101	VerlegPfl_postOP_Empfehlung	post operative Empfehlung der Pflege bei Verlegung AWR 24h	\N	3	30	\N	\N	\N
105103	Sauerstoff_RespirationBarValue	\N	\N	20	1	\N	\N	\N
105104	Patient_Befunde	\N	\N	1	1	\N	\N	\N
105105	Patient_Befunde_Fremd_Aktuell	\N	\N	2	105104	\N	\N	\N
105106	Patient_Befunde_Fremd_Art	\N	\N	3	105104	\N	\N	\N
105107	Patient_Befunde_Fremd_Auftragsdatum	\N	\N	5	105104	\N	\N	\N
105108	Patient_Befunde_Fremd_Auftragsnummer	\N	\N	3	105104	\N	\N	\N
105109	Patient_Befunde_Fremd_BefArzt1	\N	\N	3	105104	\N	\N	\N
105110	Patient_Befunde_Fremd_Befundtext	\N	\N	3	105104	\N	\N	\N
105111	Patient_Befunde_Fremd_Beurteilung	\N	\N	3	105104	\N	\N	\N
105112	Patient_Befunde_Fremd_Eingangsdatum	\N	\N	5	105104	\N	\N	\N
105113	Patient_Befunde_Fremd_Fall	Verknüpfung zum entsprechenden Fall zu dem ein Befund erhoben wurde (muss also ggf. bei Abfrage immer mit berücksichtigt werden!)	\N	15	105104	\N	\N	\N
105114	Patient_Befunde_Fremd_FreigArzt	freigebender Arzt der übermittelnden Einrichtung	\N	3	105104	\N	\N	\N
105115	Patient_Befunde_Fremd_FreigDate	\N	\N	5	105104	\N	\N	\N
105116	Patient_Befunde_Fremd_Geloescht	Flag für das logische Löschen	\N	2	105104	\N	\N	\N
105118	Patient_Befunde_Fremd_MessageIDString	\N	\N	3	105104	\N	\N	\N
105119	Patient_Befunde_Fremd_Subsystem	Name des Subsystems, ggf. bereits geändert durch den Trigger	\N	3	105104	\N	\N	\N
105120	HarnwegeDarm_FuellstandAuffang	Dokumentation des Füllstandes des Urinauffang.	\N	3	100172	\N	\N	\N
105121	Patient_Befunde_Fremd_Untersuchung_Fragestellung	\N	\N	3	105104	\N	\N	\N
105123	Dekanuelierungsplan_Abschlussdatum	Dokunentiertes Datum, wenn eine Dekanülierungsplan abgeschlossen wurde.	\N	5	105122	\N	\N	\N
105124	Dekanuelierungsplan_Anlagedatum	Datum des Anlagezeitpunkts des Dekanülierungsplans.	\N	5	105122	\N	\N	\N
105126	Dekanuelierungsplan_Dekanuelierung_nein	\N	\N	2	105122	\N	\N	\N
105127	Dekanuelierungsplan_Abbruch_Tag10SD	\N	\N	3	105122	\N	\N	\N
105128	Dekanuelierungsplan_Entblockungszeit_Tag10	\N	\N	3	105122	\N	\N	\N
105129	Dekanuelierungsplan_Endoskopie_ja	\N	\N	2	105122	\N	\N	\N
105130	Dekanuelierungsplan_Endoskopie_nein	\N	\N	2	105122	\N	\N	\N
105131	Dekanuelierungsplan_Tag11_Datum	\N	\N	5	105122	\N	\N	\N
105132	Dekanuelierungsplan_Befunde_Freitext	\N	\N	3	105122	\N	\N	\N
105133	Dekanuelierungsplan_Abbruch_Tag8SD	\N	\N	3	105122	\N	\N	\N
105134	Dekanuelierungsplan_Abbruch_Tag9FD	\N	\N	3	105122	\N	\N	\N
105135	Dekanuelierungsplan_Abbruch_Tag9SD	\N	\N	3	105122	\N	\N	\N
105136	Dekanuelierungsplan_Abbruch_Tag10FD	\N	\N	3	105122	\N	\N	\N
105137	Dekanuelierungsplan_Abbruch_Tag10ND	\N	\N	3	105122	\N	\N	\N
105138	Dekanuelierungsplan_Abbruch_Tag5FD	\N	\N	3	105122	\N	\N	\N
105139	Dekanuelierungsplan_Abbruch_Tag5SD	\N	\N	3	105122	\N	\N	\N
105140	Dekanuelierungsplan_Abbruch_Tag6FD	\N	\N	3	105122	\N	\N	\N
105141	Dekanuelierungsplan_Abbruch_Tag6SD	\N	\N	3	105122	\N	\N	\N
105142	Dekanuelierungsplan_Abbruch_Tag7FD	\N	\N	3	105122	\N	\N	\N
105143	Dekanuelierungsplan_Abbruch_Tag7SD	\N	\N	3	105122	\N	\N	\N
105144	Dekanuelierungsplan_Abbruch_Tag8FD	\N	\N	3	105122	\N	\N	\N
105145	Dekanuelierungsplan_Abbruch_Tag3FD	\N	\N	3	105122	\N	\N	\N
105146	Dekanuelierungsplan_Abbruch_Tag3SD	\N	\N	3	105122	\N	\N	\N
105147	Dekanuelierungsplan_Abbruch_Tag4FD	\N	\N	3	105122	\N	\N	\N
105148	Dekanuelierungsplan_Abbruch_Tag4SD	\N	\N	3	105122	\N	\N	\N
105149	Dekanuelierungsplan_Abbruch_Tag2FD	\N	\N	3	105122	\N	\N	\N
105150	Dekanuelierungsplan_Abbruch_Tag2SD	\N	\N	3	105122	\N	\N	\N
105151	Dekanuelierungsplan_Abbruch_Tag1SD	\N	\N	3	105122	\N	\N	\N
105152	Dekanuelierungsplan_Abbruch_Tag1FD	\N	\N	3	105122	\N	\N	\N
105153	Dekanuelierungsplan_Tag10_Datum	\N	\N	5	105122	\N	\N	\N
105154	Dekanuelierungsplan_Tag9_Datum	\N	\N	5	105122	\N	\N	\N
105155	Dekanuelierungsplan_Tag8_Datum	\N	\N	5	105122	\N	\N	\N
105156	Dekanuelierungsplan_Tag7_Datum	\N	\N	5	105122	\N	\N	\N
105157	Dekanuelierungsplan_Tag6_Datum	\N	\N	5	105122	\N	\N	\N
105158	Dekanuelierungsplan_Tag5_Datum	\N	\N	5	105122	\N	\N	\N
105159	Dekanuelierungsplan_Tag4_Datum	\N	\N	5	105122	\N	\N	\N
105160	Dekanuelierungsplan_Tag3_Datum	\N	\N	5	105122	\N	\N	\N
105161	Dekanuelierungsplan_Tag2_Datum	\N	\N	5	105122	\N	\N	\N
105162	Dekanuelierungsplan_Tag1_Datum	\N	\N	5	105122	\N	\N	\N
105163	Dekanuelierungsplan_Entblockungszeit_Tag9	\N	\N	3	105122	\N	\N	\N
105164	Dekanuelierungsplan_Entblockungszeit_Tag8SD	\N	\N	3	105122	\N	\N	\N
105165	Dekanuelierungsplan_Entblockungszeit_Tag8FD	\N	\N	3	105122	\N	\N	\N
105166	Dekanuelierungsplan_Entblockungszeit_Tag7SD	\N	\N	3	105122	\N	\N	\N
105167	Dekanuelierungsplan_Entblockungszeit_Tag7FD	\N	\N	3	105122	\N	\N	\N
105168	Dekanuelierungsplan_Entblockungszeit_Tag6SD	\N	\N	3	105122	\N	\N	\N
105169	Dekanuelierungsplan_Entblockungszeit_Tag6FD	\N	\N	3	105122	\N	\N	\N
105170	Dekanuelierungsplan_Entblockungszeit_Tag5SD	\N	\N	3	105122	\N	\N	\N
105171	Dekanuelierungsplan_Entblockungszeit_Tag5FD	\N	\N	3	105122	\N	\N	\N
105172	Dekanuelierungsplan_Entblockungszeit_Tag4SD	\N	\N	3	105122	\N	\N	\N
105173	Dekanuelierungsplan_Entblockungszeit_Tag4FD	\N	\N	3	105122	\N	\N	\N
105174	Dekanuelierungsplan_Entblockungszeit_Tag3SD	\N	\N	3	105122	\N	\N	\N
105175	Dekanuelierungsplan_Entblockungszeit_Tag2SD	\N	\N	3	105122	\N	\N	\N
105176	Dekanuelierungsplan_Entblockungszeit_Tag3FD	\N	\N	3	105122	\N	\N	\N
105177	Dekanuelierungsplan_Entblockungszeit_Tag2FD	\N	\N	3	105122	\N	\N	\N
105178	Dekanuelierungsplan_Entblockungszeit_Tag1SD	\N	\N	3	105122	\N	\N	\N
105179	Dekanuelierungsplan_Entblockungszeit_Tag1FD	\N	\N	3	105122	\N	\N	\N
105180	Dekanuelierungsplan_Mitarbeiter_Tag11	\N	\N	3	105122	\N	\N	\N
105181	Dekanuelierungsplan_Mitarbeiter_Tag10ND	\N	\N	3	105122	\N	\N	\N
105182	Dekanuelierungsplan_Mitarbeiter_Tag9FD	\N	\N	3	105122	\N	\N	\N
105183	Dekanuelierungsplan_Mitarbeiter_Tag9SD	\N	\N	3	105122	\N	\N	\N
105184	Dekanuelierungsplan_Mitarbeiter_Tag10FD	\N	\N	3	105122	\N	\N	\N
105185	Dekanuelierungsplan_Mitarbeiter_Tag10SD	\N	\N	3	105122	\N	\N	\N
105186	Dekanuelierungsplan_Mitarbeiter_Tag8SD	\N	\N	3	105122	\N	\N	\N
105187	Dekanuelierungsplan_Mitarbeiter_Tag8FD	\N	\N	3	105122	\N	\N	\N
105188	Dekanuelierungsplan_Mitarbeiter_Tag7SD	\N	\N	3	105122	\N	\N	\N
105189	Dekanuelierungsplan_Mitarbeiter_Tag7FD	\N	\N	3	105122	\N	\N	\N
105190	Dekanuelierungsplan_Mitarbeiter_Tag6SD	\N	\N	3	105122	\N	\N	\N
105191	Dekanuelierungsplan_Mitarbeiter_Tag6FD	\N	\N	3	105122	\N	\N	\N
105192	Dekanuelierungsplan_Mitarbeiter_Tag5SD	\N	\N	3	105122	\N	\N	\N
105193	Dekanuelierungsplan_Mitarbeiter_Tag5FD	\N	\N	3	105122	\N	\N	\N
105194	Dekanuelierungsplan_Mitarbeiter_Tag4SD	\N	\N	3	105122	\N	\N	\N
105195	Dekanuelierungsplan_Mitarbeiter_Tag4FD	\N	\N	3	105122	\N	\N	\N
105196	Dekanuelierungsplan_Mitarbeiter_Tag3SD	\N	\N	3	105122	\N	\N	\N
105197	Dekanuelierungsplan_Mitarbeiter_Tag3FD	\N	\N	3	105122	\N	\N	\N
105198	Dekanuelierungsplan_Mitarbeiter_Tag2SD	\N	\N	3	105122	\N	\N	\N
105199	Dekanuelierungsplan_Mitarbeiter_Tag2FD	\N	\N	3	105122	\N	\N	\N
105200	Dekanuelierungsplan_Mitarbeiter_Tag1SD	\N	\N	3	105122	\N	\N	\N
105201	Dekanuelierungsplan_Mitarbeiter_Tag1FD	\N	\N	3	105122	\N	\N	\N
105202	Diagnose_Storno	0/1-Repräsentation des Storno-Flags aus SAP	\N	2	1278	\N	\N	\N
105205	F_Untersuchung_Datum	\N	\N	5	105203	\N	\N	\N
105211	F_Untersuchung_Thorax	\N	\N	3	105203	\N	\N	\N
105212	F_Untersuchung_PreviousDataSet	Transientes Objekt für die temporäre Aufnahme der Vorwerte für die medizinische Dokumentation Untersuchung körperlicher Status	\N	37	20	\N	\N	\N
105213	F_Untersuchung_PreviousDataSet_Abdomen	\N	\N	3	105212	\N	\N	\N
105214	F_Untersuchung_PreviousDataSet_Datum	\N	\N	5	105212	\N	\N	\N
105215	F_Untersuchung_PreviousDataSet_Extremitaeten	\N	\N	3	105212	\N	\N	\N
105216	F_Untersuchung_PreviousDataSet_Herz	\N	\N	3	105212	\N	\N	\N
105217	F_Untersuchung_PreviousDataSet_Lunge	\N	\N	3	105212	\N	\N	\N
105218	F_Untersuchung_PreviousDataSet_Neurologie	\N	\N	3	105212	\N	\N	\N
105219	F_Untersuchung_PreviousDataSet_Sonstiges	\N	\N	3	105212	\N	\N	\N
105220	F_Untersuchung_PreviousDataSet_Thorax	\N	\N	3	105212	\N	\N	\N
105224	Score_NRS_Verlauf_Wert	\N	\N	2	105222	\N	\N	\N
105225	Score_NRS_Verlauf_Datum	\N	\N	5	105222	\N	\N	\N
105226	Score_BPS_Verlauf_Wert	\N	\N	2	105223	\N	\N	\N
105227	Score_BPS_Verlauf_Datum	Erhebungszeitpunkt des BPS Scores.	\N	5	105223	\N	\N	\N
105228	F_MedDoku_OperationRevisionEingriff	\N	\N	1	20	\N	\N	\N
105230	B_Versorgungsvollmacht	Dokumentation ob eine Versorgungsvollmacht vorliegt.	\N	3	30	\N	\N	\N
105231	B_Aufnahmebefund_Abdomen	Dokumentation des ärztlichen Aufnahmebfundes zur Rubrik Abdomen.	\N	3	30	\N	\N	\N
105232	B_Aufnahmebefund_EKGBefund	Befundsdokumentation des Aufnahme EKGs	\N	3	30	\N	\N	\N
105233	B_Aufnahmebefund_Datum	\N	\N	5	30	\N	\N	\N
105235	B_Aufnahmebefund_Procedere	\N	\N	3	30	\N	\N	\N
105236	B_Aufnahmebefund_Sonstiges	\N	\N	3	30	\N	\N	\N
105237	B_Aufnahmebefund_Neurologie	\N	\N	3	30	\N	\N	\N
105238	B_Aufnahmebefund_Atmung	\N	\N	3	30	\N	\N	\N
105239	B_Aufnahmebefund_Kreislauf	\N	\N	3	30	\N	\N	\N
105241	F_MedDoku_Vormedikation	\N	\N	1	20	\N	\N	\N
105245	F_MedDoku_OperationRevisionEingriff_Eintrag	\N	\N	3	105228	\N	\N	\N
105246	F_MedDoku_OperationRevisionEingriff_Bereich	\N	\N	3	105228	\N	\N	\N
105247	F_MedDoku_OperationRevisionEingriff_Datum_Alt	\N	\N	3	105228	\N	\N	\N
105256	F_MedDoku_OperationRevisionEingriff_dokuMA	Dokumentierender Mitarbeiter.	\N	3	105228	\N	\N	\N
105257	CO6_Filter_ToDo_MaBiDiKo	\N	\N	3	650	\N	\N	\N
105258	TabelleAerzteMassnahBildKonsil_LinkZuBericht	Link zu einem Befundobjekt	\N	15	102438	\N	\N	\N
105259	Behandlungsort_HL7Name	Beinhaltet den Namen der Bettplätze, wie er aus SAP bekannt ist. 	\N	3	40	\N	\N	\N
105260	Score_BPS_Verlauf_ObereExtremitaeten	\N	\N	27	105223	\N	\N	\N
105261	Score_BPS_Verlauf_Gesichtsausdruck	\N	\N	27	105223	\N	\N	\N
105262	Score_BPS_Verlauf_AdaptationanBeatmungsgeraet	\N	\N	27	105223	\N	\N	\N
105263	Score_NRS_Verlauf_NRS	\N	\N	27	105222	\N	\N	\N
105265	F_MedDoku_OperationRevisionEingriff_Datum	\N	\N	5	105228	\N	\N	\N
105266	Diagnose_LfdNr	Laufende Nummer aus SAP, zur eindeutigen Identifikation eines Datensatzes	\N	2	1278	\N	\N	\N
105267	Mikrobio_Typ	\N	\N	3	101696	\N	\N	\N
105268	Mikrobio_Befund	\N	\N	3	101696	\N	\N	\N
105269	Mikrobio_Keim	Keim-Objekt für die Zuordnung von Antibiogrammen und das Speichern der Erregerinformationen	\N	1	101696	\N	\N	\N
105270	Mikrobio_Keim_Erregername	\N	\N	3	105269	\N	\N	\N
105271	MikrobiologieAntibiogramm	Objektstruktur für die Aufnahme von strukturierten Antibiogrammen	\N	1	20	\N	\N	\N
105272	MikrobiologieAntibiogramm_AnzeigeGruppe	\N	\N	3	105271	\N	\N	\N
105273	MikrobiologieAntibiogramm_fuer_Keim	\N	\N	15	105271	\N	\N	\N
105274	MikrobiologieAntibiogramm_Wirkstoff	\N	\N	3	105271	\N	\N	\N
105275	MikrobiologieAntibiogramm_Wirkstoffsensibilitaet	\N	\N	3	105271	\N	\N	\N
106426	Verordnung_Messintervall_BZ_kont	\N	\N	39	30	\N	\N	\N
105277	Bewegen_Bewegungen_LagerungGrad	Winkel der Extremitätenlagerung/Bett/Kopf	°C	3	100360	\N	\N	\N
105278	Darm_Spuelung	Spüllösung die intermittierend appliziert wird, Wert wirdals Bilanzwert verrechnet	ml/h	6	102451	\N	\N	\N
106280	Beatmung_ES_C2_Pkontrol_Backup	\N	mbar	6	1	\N	\N	\N
106281	Beatmung_ES_C2_Apnoezeit_Backup	\N	s	6	1	\N	\N	\N
106282	Beatmung_ES_C2_Frequenz_Backup	\N	AZ/min	6	1	\N	\N	\N
106283	Beatmung_ES_C2_IEVerhaeltnis_Backup	\N	s	3	1	\N	\N	\N
106284	Lungenersatzverfahren_Doku_ILAactivve_Membranvent	Dokumentation Oxygenator - Liste	\N	3	1	\N	\N	\N
106285	Lungenersatzverfahren_MS_ILAactivve_Temp1	\N	°C	6	1	\N	\N	\N
106286	Lungenersatzverfahren_MS_ILAactivve_Temp2	\N	°C	6	1	\N	\N	\N
106287	Lungenersatzverfahren_ES_ILAactivve_Fluss	\N	l/min	6	1	\N	\N	\N
106288	Lungenersatzverfahren_MS_ILAactivve_Drehzahl	\N	1/min	6	1	\N	\N	\N
106289	Lungenersatzverfahren_MS_ILAactivve_P1	\N	mmHg	6	1	\N	\N	\N
106290	Lungenersatzverfahren_MS_ILAactivve_P2	\N	\N	6	1	\N	\N	\N
106291	Lungenersatzverfahren_MS_ILAactivve_P3	\N	mmHg	6	1	\N	\N	\N
106293	Lungenersatzverfahren_MS_ILAactivve_P4	\N	mmHg	6	1	\N	\N	\N
106294	Lungenersatzverfahren_ES_ILAactivve_Frequenz	\N	Zahl	6	1	\N	\N	\N
106295	Lungenersatzverfahren_ES_ILAactivve_Systole	%Systole Verhältnis Systolendauer zur Diastolendauer	%	6	1	\N	\N	\N
106296	Lungenersatzverfahren_VO_ILAactivve_Membranvent	\N	Liste	3	1	\N	\N	\N
106297	Lungenersatzverfahren_VO_ILAactivve_Fluss	\N	l/min	6	1	\N	\N	\N
106298	Lungenersatzverfahren_VO_ILAactivve_Frequenz	\N	Zahl	6	1	\N	\N	\N
106299	Lungenersatzverfahren_VO_ILAactivve_Systole	Verhältnis Systole zur Diastolendauer	%	6	1	\N	\N	\N
106300	Lungenersatzverfahren_ES_ILAactivve_Blutfluss	\N	ll/min	6	1	\N	\N	\N
106301	Lungenersatzverfahren_Doku_ILAactivve_Flushen	Liste - Doku Durchführung	\N	3	1	\N	\N	\N
106302	Lungenersatzverfahren_Doku_ILAactivve_Flussreg	Liste ein aus	\N	3	1	\N	\N	\N
106303	Lungenersatzverfahren_Doku_ILAactivve_Nullabgleich	Liste durchgeführt	\N	3	1	\N	\N	\N
106307	Lungenersatzverfahren_Doku_ILAactivve_KontrSchlsys	Liste 	\N	3	1	\N	\N	\N
106308	Lungenersatzverfahren_Doku_KontrAlarmg	Liste 	\N	3	1	\N	\N	\N
106309	Lungenersatzverfahren_Doku_ILAactivve_Nullfluss	bei luftblasen, Liste ein aus	\N	3	1	\N	\N	\N
106310	Lungenersatzverfahren_Doku_ILAactivve_Flussregel	Liste ein aus	\N	19	1	\N	\N	\N
106311	Lungenersatzverfahren_Doku_ILAactivve_Null_Fluss	Liste durchgeführt	\N	19	1	\N	\N	\N
106312	Lungenersatzverfahren_MS_ILAactivve_DeltaP	Delta P2/P3	mmHg	6	1	\N	\N	\N
106313	Lungenersatzverfahren_Doku_KontrSchlsys	Liste	\N	3	1	\N	\N	\N
106314	Patient_Befunde_Herkunftsmarker	interne (durch Presenter erhoben) oder externer (durch Schnittstelle) Befund	\N	3	105104	\N	\N	\N
106315	Patient_Befunde_Typ	Welcher Befundtyp (Beispiel: Konsil, Bildgebung etc.)	\N	3	105104	\N	\N	\N
106316	Patient_Befunde_MiBi_Keim	Objekt für die Keime von mikrobiologischen Befunden	\N	1	105104	\N	\N	\N
106317	Patient_Befunde_MiBi_Keim_Erregername	Erregername zur eindeutigen Identifikation des Objekts	\N	3	106316	\N	\N	\N
106318	Patient_MikrobiologieAntibiogramm	Antibiogrammobjekt für die MiBi-Befunde	\N	1	1	\N	\N	\N
106319	Patient_MikrobiologieAntibiogramm_fuer_Keim	Link zum Keim eines Antibiogramm-Objekts	\N	15	106318	\N	\N	\N
106320	Patient_MikrobiologieAntibiogramm_Wirkstoff	Wirkstoffbezeichnung	\N	3	106318	\N	\N	\N
106321	Patient_MikrobiologieAntibiogramm_Wirkstoffsensib	Wirkstoffsensibilität	\N	3	106318	\N	\N	\N
106322	CO6_Filter_ToDo_MaBiDiKo_Source	Für die Filterung auf der Seite Massnahmen, Bildgebung, Diagnostik und Konsile nach Herkunft (extern, d.h. über Schnittstelle, oder intern, d.h. über Presenter dokumentiert)	\N	3	650	\N	\N	\N
106323	Extrakorporaleverfahren_DOKU_Heizung	\N	\N	3	1	\N	\N	\N
106324	CardioHelpMaquet_DOKU_InitialisierenVenoeseProbe	\N	\N	3	1	\N	\N	\N
106325	CardioHelpMaquet_DOKU_Antikoagulation	\N	\N	3	1	\N	\N	\N
106326	CardioHelpMaquet_DOKU_Flushen	\N	\N	3	1	\N	\N	\N
106327	CardioHelpMaquet_MS_TemperaturIst	\N	°C	6	1	\N	\N	\N
106328	CardioHelpMaquet_MS_SvO2	\N	%	6	1	\N	\N	\N
106329	CardioHelpMaquet_MS_DeltaP	\N	mmHg	6	1	\N	\N	\N
106330	CardioHelpMaquet_MS_DruckVenoes	\N	mmHg	6	1	\N	\N	\N
106331	CardioHelpMaquet_MS_DruckArteriell	\N	mmHg	6	1	\N	\N	\N
106332	CardioHelpMaquet_MS_Blutfluss	\N	L/Min	6	1	\N	\N	\N
106333	CardioHelpMaquet_ES_TemperaturSoll	\N	°C	6	1	\N	\N	\N
106334	CardioHelpMaquet_ES_Pumpendrehzahl	\N	RPM	6	1	\N	\N	\N
106335	CardioHelpMaquet_ES_Gasfluss	\N	L/Min	6	1	\N	\N	\N
106336	CardioHelpMaquet_ES_FiO2	\N	%	6	1	\N	\N	\N
106337	CardioHelpMaquet_VO_TemperaturSoll	\N	°C	6	1	\N	\N	\N
106338	CardioHelpMaquet_VO_Pumpendrehzahl	\N	RPM	6	1	\N	\N	\N
106339	CardioHelpMaquet_VO_Blutfluss	\N	L/Min	6	1	\N	\N	\N
106340	CardioHelpMaquet_VO_Gasfluss	\N	L/Min	6	1	\N	\N	\N
106341	CardioHelpMaquet_VO_FiO2	\N	%	6	1	\N	\N	\N
106342	NEV_CRRT_MS_DCMFETTotal	\N	ml	6	1	\N	\N	\N
106343	NEV_Apherese_MS_Multi_FiltratDruck	\N	mmHg	6	1	\N	\N	\N
106344	NEV_CRRT_MS_DCMFBTgesamt	\N	ml	6	1	\N	\N	\N
106345	CardioHelpMaquet_DOKU_KalibrierenVenoesenMesskopf	\N	\N	3	1	\N	\N	\N
106346	CardioHelpMaquet_DOKU_HFAnsaetzeAspirierenSpuelen	\N	\N	3	1	\N	\N	\N
106347	CardioHelpMaquet_VO_Antikoagulation	\N	\N	3	1	\N	\N	\N
106348	CardioHelpMaquet_VO_Oxygenator	\N	\N	3	1	\N	\N	\N
106349	CardioHelpMaquet_DOKU_Oxygenator	\N	\N	3	1	\N	\N	\N
106351	CardioHelpMaquet_DOKU_HCT	\N	\N	6	1	\N	\N	\N
106352	CardioHelpMaquet_DOKU_HB	\N	\N	6	1	\N	\N	\N
106353	CardioHelpMaquet_DOKU_OxygenatorTest	\N	\N	3	1	\N	\N	\N
106354	Beatmung_MS_G5_ProzentMinVol	Messung nur unter ASV Intellivent	%	6	1	\N	\N	\N
106355	Beatmung_ES_G5_Peep_Grenzwert	Negativ Wert/positiv Wert	mbar	3	1	\N	\N	\N
106356	Beatmung_ES_G5_HLI	Liste ein aus	\N	3	1	\N	\N	\N
106357	Beatmung_ES_G5_Kein_Recruitment	Liste ein aus	\N	3	1	\N	\N	\N
106358	Beatmung_ES_G5_passiver_Patient	Liste ein aus	\N	3	1	\N	\N	\N
106359	Beatmung_ES_G5_Quick_Wean	Liste ein aus	\N	3	1	\N	\N	\N
106360	Beatmung_ES_G5_SHT	Liste ein aus	\N	3	1	\N	\N	\N
106361	Beatmung_ES_G5_ARDS	Liste ein aus	\N	3	1	\N	\N	\N
106362	Beatmung_ES_G5_Chron_Hyperkapnie	Liste ein aus	\N	3	1	\N	\N	\N
106363	Beatmung_ES_G5_Oxygen_Target_Shift	Bereich Decimal - bis +	\N	3	1	\N	\N	\N
106364	Beatmung_ES_G5_CO2Elim_Target_Shift	Bereich Decimal - bis +	\N	3	1	\N	\N	\N
106365	Beatmung_ES_G5_SBT_Zeitraum_bevor	\N	\N	3	1	\N	\N	\N
106366	Beatmung_ES_G5_SBT_Zeitraum_nach	Uhrzeit	\N	3	1	\N	\N	\N
106367	Beatmung_ES_G5_SBT_Support_min	\N	mbar	6	1	\N	\N	\N
106368	Beatmung_ES_G5_SBT_Frrequenz	\N	1/min	6	1	\N	\N	\N
106369	Beatmung_ES_G5_SBT_Psupp_max	\N	\N	6	1	\N	\N	\N
106370	Beatmung_ES_G5_Zeit_zw2_SBT	Zeit zwishen 2 SBT	min	6	1	\N	\N	\N
106371	Beatmung_ES_G5_ZeitStartSBT	Zeit bis zum Start STB	min	6	1	\N	\N	\N
106372	Patient_Befunde_Viro_Test	Tabellen-Object-Variable für den Befundtest aus der Virologie	\N	1	105104	\N	\N	\N
106373	Patient_Befunde_Viro_Test_Bewertung	\N	\N	3	106372	\N	\N	\N
106374	Patient_Befunde_Viro_Test_Ergebnis	\N	\N	3	106372	\N	\N	\N
106375	Patient_Befunde_Viro_Test_Material	\N	\N	3	106372	\N	\N	\N
106376	Patient_Befunde_Viro_Test_Normbereich	\N	\N	3	106372	\N	\N	\N
106377	Patient_Befunde_Viro_Test_Test	Auf was getestet wurde	\N	3	106372	\N	\N	\N
106378	Hemolung_MS_Blutfluss	\N	L/Min	6	1	\N	\N	\N
106379	Hemolung_ES_Pumpendrehzahl	\N	RPM	6	1	\N	\N	\N
106380	Hemolung_ES_Gasfluss	\N	L/Min	6	1	\N	\N	\N
106381	Hemolung_VO_Blutfluss	\N	L/Min	6	1	\N	\N	\N
106382	Hemolung_VO_Pumpendrehzahl	\N	RPM	6	1	\N	\N	\N
106383	Hemolung_VO_Gasfluss	\N	L/Min	6	1	\N	\N	\N
106384	NEV_Apherese_MS_Multi_Behandlungs_Zeit_min	Anpassung für automatische Gerätedataenübernahme mit IBUS	minuten	6	1	\N	\N	\N
106385	NEV_HD_MS_4008onl_Rest_Zeit_min	Anpassung für IBUS Anbindung	min	6	1	\N	\N	\N
106386	NEV_HD_MS_4008onl_SubBolusVolKum_ml	Anpassung IBUS Anbindung	ml	6	1	\N	\N	\N
106387	NEV_HD_MS_4008onl_SubVolKum_ml	Anpassung für IBUS Anbindung	ml	6	1	\N	\N	\N
106388	NEV_HD_MS_4008onl_IsoUFVolKum_ml	Anpassung für IBUS Anbindung	ml	6	1	\N	\N	\N
106389	NEV_HD_MS_4008onl_BlutvolKum_ml	Anpassung für IBUS	ml	6	1	\N	\N	\N
106390	NEV_HD_MS_4008HS_Rest_Zeit_min	Anpassung für IBUS Anbindung	Minuten	6	1	\N	\N	\N
106391	NEV_HD_MS_4008HS_IsoUFVolKum_ml	Anpassung für IBUS Anbindung	ml	6	1	\N	\N	\N
106392	NEV_HD_MS_4008HS_BlutvolKum_ml	Anpassung aufgrund IBUS Anbindung	ml	6	1	\N	\N	\N
106393	NEV_CRRT_MS_Multi_Behandlungszeit_Aktuell__min	Anpassung für die automatische Datenübermnahme IBUS	min	6	1	\N	\N	\N
106394	NEV_CRRT_MS_Multi_SubBolusVolKum_ml	Anpassung für die automatische Datenübernahme IBUS	ml	6	1	\N	\N	\N
106395	NEV_CRRT_MS_Multi_SubVolKum_ml	Änderung für die automatische Datenübernahme IBUS	ml	6	1	\N	\N	\N
106396	NEV_CRRT_MS_Multi_DialysatvolKum_ml	Anpassung für automatische Datenübernahme IBUS	ml	6	1	\N	\N	\N
106397	NEV_CRRT_MS_Multi_UltrafiltrationlKum_ml	Neuanlage im Zuge der IBUS Anbindung	ml	6	1	\N	\N	\N
106398	NEV_Apherese_MS_OctoNova_PlasmaVolKum_ml	Anpassung im Zuge der automatischen Geräteanbindung über IBUS. Änderung in ml	ml	6	1	\N	\N	\N
106399	NEV_Apherese_MS_Cobe_PlasmaVolKum_ml	Anpassung analog zu Geräten mit automatischer Datenübernahme Änderung in ml 	\N	6	1	\N	\N	\N
106400	NEV_Apherese_MS_Multi_PlasmaVolKum_ml	automatische Datenübernahme IBUS	ml	6	1	\N	\N	\N
106401	NEV_HD_MS_4008_HS_onl_Ultrafiltratmengekum_ml	Anpassung im Zuge der automatischen Datenübernahme IBUS	ml	6	1	\N	\N	\N
106402	NEV_CRRT_MS_Multi_Bilanz_ml	neue Variable für automatische Datenübernahme IBUS	ml	6	1	\N	\N	\N
106403	Hypothermie_ArticSun_MS_Wasserstand	Texteintrag	\N	3	1	\N	\N	\N
106404	Hypothermie_ArticSun_MS_Hoechstwassertemp	Anlage für IBUS Datenübermittlung	°C	6	1	\N	\N	\N
106405	Hypothermie_ArticSun_MS_Mindestwassertemp	Anlage für IBUS Datenübermittlung	°C	6	1	\N	\N	\N
106406	Hypothermie_ArticSun_MS_Flussrate	\N	l/min	3	1	\N	\N	\N
106407	Hypothermie_ArticSun_MS_Zieltemperatur	Messwert im Verlaufbis zum erreichen der eingestellten Zieltemperatur	°C	6	1	\N	\N	\N
106408	Hypothermie_ArticSun_ES_Wasserziel	manueller Modus	°C	3	1	\N	\N	\N
106409	Hypothermie_ArticSun_ES_Hoechsttwassertemp	\N	°C	3	1	\N	\N	\N
106410	Hypothermie_ArticSun_ES_Mindestwassertemp	\N	°C	3	1	\N	\N	\N
106411	CO6_Filter_ToDo_MaBiDiKo_System	Filtermöglichkeit für Systeme (Eingeführt für den Filter auf MLAB/Viro und MiBi-Befunde)	\N	3	650	\N	\N	\N
106412	Beatmung_MS_G5_petCO2	\N	mmHg	6	1	\N	\N	\N
106413	Beatmung_MS_G5_SpO2	Wert gemessen am Ventilator	mmHg	6	1	\N	\N	\N
106414	Beatmung_MS_G5_VCO2	\N	\N	6	1	\N	\N	\N
106415	Beatmung_MS_G5_VT_IBW	VT/IBW	\N	6	1	\N	\N	\N
106416	TabelleVerordnungAerzte	\N	\N	1	30	\N	\N	\N
106417	Verordnung_Messintervall_Bewusst_kont	\N	\N	39	30	\N	\N	\N
106418	Verordnung_Messintervall_Pupillen_kont	\N	\N	39	30	\N	\N	\N
106419	Verordnung_Messintervall_BGA_kont	\N	\N	39	30	\N	\N	\N
106420	Verordnung_Messintervall_ZVD_kont	\N	\N	39	30	\N	\N	\N
106421	Verordnung_Messintervall_ICP_kont	\N	\N	39	30	\N	\N	\N
106422	Verordnung_Messintervall_Gewicht_kont	\N	\N	39	30	\N	\N	\N
106423	Verordnung_Messintervall_SpezGew_kont	\N	\N	39	30	\N	\N	\N
106424	Verordnung_Messintervall_Urinausfuhr_kont	\N	\N	39	30	\N	\N	\N
106425	Verordnung_Messintervall_Bilanz_kont	\N	\N	39	30	\N	\N	\N
106427	Verordnung_Kostform_kont	\N	\N	39	30	\N	\N	\N
106428	Verordnung_Allgemein_kont	\N	\N	39	30	\N	\N	\N
106429	Zielwert_Bilanz_kont	\N	ml	39	30	\N	\N	\N
106430	Zielwert_BZ_kont	\N	mg/dl	39	30	\N	\N	\N
106431	Zielwert_SpO2_kont	\N	%	39	30	\N	\N	\N
106432	Zielwert_ICP_kont	\N	mmHg	39	30	\N	\N	\N
106433	Zielwert_Temp_kont	\N	°C	39	30	\N	\N	\N
106434	Zielwert_ZVD_kont	\N	cmH2O	39	30	\N	\N	\N
106435	Zielwert_RR_kont	\N	mmHg	39	30	\N	\N	\N
106436	Zielwert_HF_kont	\N	1/min	39	30	\N	\N	\N
106437	TabelleVerordnungAerzte_AusarbeitVerantwMitarbeite	\N	\N	3	106416	\N	\N	\N
106438	TabelleVerordnungAerzte_Verordnung	\N	\N	3	106416	\N	\N	\N
106439	TabelleVerordnungAerzte_VerantwMitarbeier	\N	\N	3	106416	\N	\N	\N
106440	TabelleVerordnungAerzte_Datum	\N	\N	5	106416	\N	\N	\N
106441	Dekubitus_FotodokumentationVorhanden	Flag für eine Fotodokumentation. Gibtkeine Information über Aufnahmezeitpunkt und Anzahl der Fotos	\N	2	100182	\N	\N	\N
79	Location_CoPI	Enthällt den ConnectionString für die Remote-Verbindung zum COPRA-Pumpeninterface. Dieser folgt dem Schema tcp:--COMPUTERNAME:PORT/ENDPUNKTNAME.	\N	3	40	\N	\N	\N
501	Geraet_Identifikation	Eindeutige Identifikation innerhalb des Geratetyp-Namensraums (z.B. Seriennummer)	\N	3	500	\N	\N	\N
502	Geraet_Typ	Name des Gerätetyps	\N	3	500	\N	\N	\N
503	Geraet_Anzeigename	Name des Geräts, der innerhalb des Gerätetyps eindeutig ist, damit Mitarbeiter ihn aus der Liste zuordnen können	\N	3	500	\N	\N	\N
505	Patient_Geraet_Zuordnung	Verknüpfung zwischen Patient und einem Gerät	\N	38	500	\N	\N	\N
101322	Patient_AufnGewicht	Aufnahmegewicht (fallbezogen)	kg	6	20	\N	\N	\N
104356	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.	mm[Hg]	12	1	\N	\N	\N
102020	HZV	Herzzeitvolumen	L/min	3	100134	2007-12-12 16:30:27.673	\N	\N
102051	HZV	Herzzeitvolumen	L/min	6	1	\N	\N	\N
102978	Nierenverfahren_ES_Multi_Substituat	Umsatz, Austausch Substituat ml/h	mL/h	6	1	\N	\N	\N
110777	P_NEV_HD_MS_5008onl_effBlutfluss	\N	mL/min	6	1	\N	\N	\N
106468	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP	mm[Hg]	12	1	\N	\N	\N
\.


--
-- Data for Name: conf_var_no_for_analysis; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.conf_var_no_for_analysis (conf_var_id, conf_var_name, conf_var_description, conf_var_types_name, conf_var_parent_name, quantities) FROM stdin;
13	COPRA_Patient_Bezugsgewicht	Bezugsgewicht des Patienten in kg	Decimal_6_3	Patient	\N
14	COPRA_Patient_Geburtsgewicht	Geburtsgewicht des Patienten in Kilogramm	Decimal_6_3	Patient	236
1273	SaO2	arterielle Sauerstoffsättigung	Decimal_6_3	Patient	\N
1275	NBP	nichtinvasiver Blutdruck	Medic_Pressure	Patient	8
1276	ABP	arterielle Blutdruck	Medic_Pressure	Patient	\N
100047	TISS28_TS_ICPMessung	\N	SubScore	TISS28	\N
100099	Beatmung_Messung_Frequenz	Frequenz tot.	Decimal_6_3	Patient	\N
100104	Beatmung_Einstellung_Flow	Inspiratorische Flowrate	Decimal_6_3	Patient	77
100107	Beatmung_Einstellung_AMV	Atemminutenvolumen (AMV)	Decimal_6_3	Patient	\N
100113	Beatmung_Anordnung_Flow	Anordnung Inspiratorische Flowrate	Decimal_6_3	Patient	\N
100264	Beatmung_Einstellung_Pmax	Pmax, Maximaldruck	Decimal_6_3	Patient	254
100271	Beatmung_Messung_AMV	Respiratory Minute Volume	Decimal_6_3	Patient	419
100292	Beatmung_Messung_intermPEEP	\N	Decimal_6_3	Patient	\N
100305	Beatmung_Messung_ZeitHoch	\N	Decimal_6_3	Patient	\N
100306	Beatmung_Messung_ZeitNiedrig	\N	Decimal_6_3	Patient	\N
100776	IstPflege_Koerperkerntemp	\N	String	Behandlung	\N
101030	KlinikTemperaturstatus_Kerntemperatur_Wert	\N	GroupedParameterPropertyObject	KlinikTemperaturstatus	\N
101274	KlinikTemperaturstatus_Kerntemperatur_Kerntemp	\N	String	KlinikTemperaturstatus_Kerntemperatur_Wert	\N
101323	Patient_AufnGroesse	Größe Patient (fallbezogen)	Decimal_6_3	Fall	\N
101619	Beatmung_VO_FiO2	\N	Decimal_6_3Order	Patient	\N
101625	Beatmung_VO_Pmax	\N	Decimal_6_3Order	Patient	\N
101629	Beatmung_Proc_FiO2	\N	Decimal_6_3Procedure	Patient	\N
101635	Beatmung_Proc_Pmax	\N	Decimal_6_3Procedure	Patient	\N
101763	Patient_Kopfumfang	Kopfumfang des Patienten (Kinder)	String	Patient	\N
101912	KlinikHerzKreislaufFunktion_KMakrozirkulation_Hf	Herzfrequenz	String	KlinikHerzKreislaufFunktion_KMakrozirkulation_Wert	\N
101934	KlinikNervensys_Kerntemperatur_Wert	\N	GroupedParameterPropertyObject	KlinikNervensys	\N
101935	KlinikNervensys_Kerntemperatur_Temp	Kerntemperatur	String	KlinikNervensys_Kerntemperatur_Wert	\N
101956	Score_TISS28_ICPMessung	\N	SubScore	Score_TISS28	\N
102015	RVP	Rechtsventrikulärer Mitteldruck	Decimal_6_3	Patient	\N
102016	RAP	Rechtsatrial Mitteldruck	Decimal_6_3	Patient	835
102019	PAM	Mittlerer pulmonale arterieller Druck	Decimal_6_3	Patient	\N
102024	LVSAI	Linksventrikulärer Schlagarbeitsindex 	Decimal_6_3	Patient	28
102031	SVI	Index des Schlagvolumens 	String	HarnwegeDarm	\N
102055	LVP	Linksventrikulärer Mitteldruck	Medic_Pressure	Patient	6
102056	RVP	Rechtsventrikulärer Mitteldruck	Medic_Pressure	Patient	1
102058	Beatmung_Einstellung_Inspirationsflow	\N	Decimal_6_3	Patient	\N
102162	PICCO_ABP	Arterieller Druck	Medic_Pressure	Patient	63
102163	PICCO_ZVD	Zentraler Venendruck	Decimal_6_3	Patient	89
102165	PICCO_SVRI	Systemic vascular resistance index	Decimal_6_3	Patient	23
102173	PICCO_HZV	Herzzeitvolumen	Decimal_6_3	Patient	114
102181	Vigileo_SVRI	Systemic vascular resistance index	Decimal_6_3	Patient	175
102186	VigilanceC_SV	Schlagvolumen	Decimal_6_3	Patient	462
102187	VigilanceC_SVI	Schlagvolumenindex	Decimal_6_3	Patient	85
102190	VigilanceC_SVRI	Systemischer Gefäßwiderstandsindex	Decimal_6_3	Patient	163
102192	VigilanceC_PVRI	Pulmonaler vasculärer Widerstandsindex	Decimal_6_3	Patient	77
102651	Nierenersatzverfahren_Einstell_DialyseZeit	\N	Decimal_6_3	Patient	793
102666	Nierenersatzverfahren_Mess_DialyseZeit	\N	Decimal_6_3	Patient	\N
102675	Nierenersatzverfahren_VO_DialyseZeit	\N	Decimal_6_3	Patient	418
102775	Score_TISS10_ICPMessung	\N	SubScore	Score_TISS10	\N
102861	Beatmung_MS_BiPAPV_Pimax	Pimax (Maximaler inspiratorischer Atemwegsdruck)  	Decimal_6_3	Patient	150
102940	Nierenverfahren_VO_Multi_Substituat	Substituat in ml/h	Decimal_6_3	Patient	220
102941	Nierenverfahren_VO_Multi_SubstituatBolus	Substituatbolus in ml	Decimal_6_3	Patient	16
102967	Nierenverfahren_VO_ADM_Austauschrate	Umsatz, Austausch; Substituat ml/h	Decimal_6_3	Patient	\N
102979	Nierenverfahren_ES_Multi_SubstituatBolus	Substituatbolus ml	Decimal_6_3	Patient	76
103006	Nierenverfahren_ES_ADM_Austauschrate	Umsatz, Substituat	Decimal_6_3	Patient	88
103054	Nierenverfahren_VO_Multi_Calcium	Ca-rate	Decimal_6_3	Patient	165
103084	Beatmung_MS_VisionA_Tidalvolumen	gemessenes Tidalvolumen	Decimal_6_3	Patient	19
103126	Beatmung_ES_BiPAPV_O2Konzentration	Einstellparameter: O2 Konzentration des Gasgemisches	Decimal_6_3	Patient	275
103127	Beatmung_MS_BiPAPV_AF	Messparameter: gemessene Atemfrequenz	Decimal_6_3	Patient	226
103130	Beatmung_MS_BiPAPV_O2Konzentration	Messwert: gemessene O2 Konzentration des Gasgemisches	Decimal_6_3	Patient	145
103132	Beatmung_MS_BiPAPV_Vt	Messwert: gemessenes Tidalvolumen	Decimal_6_3	Patient	209
103133	Beatmung_ES_BiPAPV_Inspirationszeit	Einstellwert: Zeiteinstellung für die Inspirationszeit	Decimal_6_3	Patient	82
103142	Beatmung_MS_VisionA_PEEP	Messwert: gemessener positiver endexspiratorischer Druck	Decimal_6_3	Patient	20
103153	Nierenverfahren_ES_4008HS_BlutflussSNPumpe	\N	Decimal_6_3	Patient	36
103174	Nierenvwerfahren_ES_4008onl_Dialysezeit	\N	Decimal_6_3	Patient	\N
103180	Nierenverfahren_ES_4008onl_Blutfluss	\N	Decimal_6_3	Patient	516
103181	Nierenverfahren_ES_4008onl_BlutflussSNPumpe	\N	Decimal_6_3	Patient	3
103205	Nierenverfahren_ES_4008onl_Dialysezeit	\N	Decimal_6_3	Patient	439
103218	Nierenverfahren_VO_4008onl_Dialysezeit	\N	Decimal_6_3	Patient	78
103220	Nierenverfahren_VO_4008onl_Blutfluss	\N	Decimal_6_3	Patient	53
103235	Nierenverfahren_VO_4008onl_BlutflussSNPumpe	\N	Decimal_6_3	Patient	\N
103246	Nierenverfahren_VO_4008HS_BlutflussSNPumpe	\N	Decimal_6_3	Patient	1
103260	Beatmung_ES_VisionA_Ti	Einstellwert: Inspirationszeit in Sekunden	Decimal_6_3	Patient	10
103265	Beatmung_MS_VisionA_BreathRate	Messwert: gemessene Atemfrequenz	Decimal_6_3	Patient	15
103266	Beatmung_MS_VisionA_IEVerhaeltnis	Messwert: gemessenes I:E Verhältnis	String	Patient	5
103267	Beatmung_ES_Evita2_O2Konzentration	eingestellte O2 Konzentration des Gases	Decimal_6_3	Patient	6
103268	Beatmung_ES_Evita2_InspFlow	eingestellter Inspirationfluss	Decimal_6_3	Patient	\N
103280	Beatmung_MS_Evita2_AMV	gemessenes Atemminutenvolumen	Decimal_6_3	Patient	\N
103281	Beatmung_MS_Evita2_O2Konzentration	gemessene O2 Konzentration im Inspirationsgas	Decimal_6_3	Patient	\N
103282	Beatmung_MS_Evita2_Pmax	gemessener Beatmungsspitzendruck	Decimal_6_3	Patient	\N
103284	Beatmung_MS_Evita2_Ppeep	gemessener positer endexspiratorischer Druck	Decimal_6_3	Patient	\N
103287	Beatmung_MS_Evita2_frequenz	gemessene Atemfrequenz	Decimal_6_3	Patient	\N
103291	Beatmung_MS_Evita2_frequenzspon	gemessene spontane Atemfrequenz	Decimal_6_3	Patient	\N
103325	Beatmung_MS_Evita4_fmand	gemessene mandatorische Atemfrequenz	Decimal_6_3	Patient	33
103413	Beatmung_ES_Avea_FiO2	eingestellte Sauerstoffkonzentration des inspiratorischen Atemgases	Decimal_6_3	Patient	74
103415	Beatmung_ES_Avea_InspZeit	eingestellte Inspirationszeit eines Atemzuges	Decimal_6_3	Patient	1
103425	Beatmung_MS_Avea_PEEP	gemessenes PEEP Niveau	Decimal_6_3	Patient	53
103426	Beatmung_MS_Avea_IE	gemessenes I zu E Verhältnis	String	Patient	4
103429	Beatmung_MS_Avea_Mitteldruck	gemessener Atemwegsmitteldruck	Decimal_6_3	Patient	10
103430	Beatmung_MS_Avea_Frequenz	gemessene Atemfrequenz	Decimal_6_3	Patient	64
103432	Beatmung_MS_Avea_SpontVte	gemessenes spontanes Tidalvolumen	Decimal_6_3	Patient	65
103435	Beatmung_MS_Avea_SpontAF	gemessene spontane Atemfrequenz	Decimal_6_3	Patient	84
103436	Beatmung_MS_Avea_MandAF	gemessene mandatorische Atemfrequenz	Decimal_6_3	Patient	2
103439	Beatmung_MS_Avea_FiO2	gemessene Sauerstoffkonzentration im Atemgas	Decimal_6_3	Patient	66
103443	Beatmung_MS_Avea_AutoPEEP	gemessener AutoPEEP	Decimal_6_3	Patient	1
104032	Beatmung_MS_HorowitzINPULS	Messung des Horowitz-Indexes	Decimal_6_3	Patient	291
104052	TISS28_ICPMessung_Aufnahme	\N	SubScore	Score_TISS28_Aufnahme	\N
104150	Beatmung_ES_Airvo_O2Flow	Dokumentation des eingestellten O2 Flusses, welcher am Gerät Airvo angeschlossen ist.	Decimal_6_3	Patient	862
104161	Beatmung_ES_Zephyros_FIO2	\N	Decimal_6_3	Patient	56
104168	Beatmung_ES_Zephyros_Peep	\N	Decimal_6_3	Patient	45
104173	Beatmung_ES_Zephyros_Pmax	\N	Decimal_6_3	Patient	36
104189	Beatmung_MS_Zephyros_Ppeep	\N	Decimal_6_3	Patient	2
104190	Beatmung_MS_Zephyros_Ppeepi	\N	Decimal_6_3	Patient	\N
104203	TISS10_ICPMessung_Aufnahme	\N	SubScore	Score_TISS10_Aufnahme	\N
104236	Beatmung_MS_Servoi_Cdyn	Dynamische Charakteristika 	Decimal_6_3	Patient	22
104243	Beatmung_MS_Servoi_MVi	Insp. Minutenvolumen 	Decimal_6_3	Patient	54
104245	Beatmung_MS_Servoi_AF	Atemfrequenz 	Decimal_6_3	Patient	709
104248	Beatmung_MS_Servoi_PEEP	Positiver Endexsp. Druck 	Decimal_6_3	Patient	912
104262	Beatmung_ES_Servoi_Tpeep	zeit unteres Druckniveau (tniedrig) 	Decimal_6_3	Patient	\N
104263	Beatmung_ES_Servoi_Thoch	zeit oberes Druckniveau (thoch) 	Decimal_6_3	Patient	\N
104283	Beatmung_ES_Servoi_Frequenz	Atemfrequenz 	Decimal_6_3	Patient	253
104284	Beatmung_ES_Servoi_Vt	Tidalvolumen 	Decimal_6_3	Patient	\N
104418	Praemedikation_Präanästh_Anordnung_Einheiten_EB	Präanästhetische Anordnung: Anzahl der anzufordernden Einheiten an Eigenblut.	String	Praemedikation	\N
104555	Praemedikation_Blutdruck	Dokumentation des Blutdruckes.	String	Praemedikation	\N
104770	Beatmung_ES_Pallas_FrischgasFlow	Gesamt Frischgasfluss (Summe aus O2 + AIR)	Decimal_6_3	Patient	\N
104792	Beatmung_MS_C2_ExspFlow	\N	Decimal_6_3	Patient	30
104863	NEV_HD_MS_4008onl_effBlutfluss	\N	Decimal_6_3	Patient	619
104887	NEV_HD_ES_4008HS_BlutflussSNPumpe	\N	Decimal_6_3	Patient	86
104906	NEV_HD_ES_4008onl_BlutflussSNPumpe	\N	Decimal_6_3	Patient	1
104907	NEV_HD_ES_4008onll_Blutfluss	\N	Decimal_6_3	Patient	476
104929	NEV_HD_VO_4008onl_BlutflussSNPumpe	\N	Decimal_6_3	Patient	\N
104942	NEV_HD_VO_4008HS_Blutfluss_SN_Pumpe	\N	Decimal_6_3	Patient	14
104985	NEV_CRRT_Doku_CalciumLoesung	\N	BarValue	Patient	\N
104995	NEV_CRRT_VO_Multi_CalciumFiltrat	\N	Decimal_6_3	Patient	869
105041	AT_O2Flow	\N	ApparatusBar	Patient	\N
105243	B_Aufnahmegroesse	Dokumentation der Patientengröße bei Aufnahme.	String	Behandlung	\N
106339	CardioHelpMaquet_VO_Blutfluss	\N	Decimal_6_3	Patient	13
106467	B_Aufnahmegroesse_Wert	\N	Decimal_6_3	Behandlung	\N
106640	Beatmung_ES_T1_Ti	Einstelungswert für die Inspirationszeit	Decimal_6_3	Patient	16
107815	Beatmung_ES_Leoni_PEEP	\N	Decimal_6_3	Patient	\N
107816	Beatmung_ES_Leoni_FlowInsp	\N	Decimal_6_3	Patient	\N
107841	Beatmung_MS_Leoni_Freq_Spontan	\N	Decimal_6_3	Patient	\N
107873	Beatmung_MS_T1_ExspFlow	Exspiratorischer Peakflow	Decimal_6_3	Patient	1
107874	Beatmung_MS_T1_fSpontan	Spontane Atemfrequenz	Decimal_6_3	Patient	12
107875	Beatmung_MS_T1_fTotal	Gesamtfrequenz	Decimal_6_3	Patient	13
107876	Beatmung_MS_T1_IEVerhaeltnis	gemessenes I:E Verhältnis	String	Patient	1
107878	Beatmung_MS_T1_InspFlow	Inspiratorischer Peakflow	Decimal_6_3	Patient	\N
108018	P_Beatmung_MS_C3_fSpontan	Spontane Atemfrequenz	Decimal_6_3	Patient	194
108019	P_Beatmung_MS_C3_fTotal	Gesamtatemfrequenz	Decimal_6_3	Patient	370
108021	P_Beatmung_MS_C3_petCO2	Endtidaler CO2-Partialdruck	Decimal_6_3	Patient	\N
108032	P_Beatmung_MS_C3_ExspFlow	Exspiratorischer Peakflow	Decimal_6_3	Patient	\N
108033	P_Beatmung_MS_C3_InspFlow	Inspiratorischer Peakflow	Decimal_6_3	Patient	\N
108250	B_Aufnahme_Perzentile_Groesse	\N	Decimal_6_3	Behandlung	\N
108390	Score_ComfortSkala_MAD	Mittlerer Arterieller Blutdruck	SubScore	Score_ComfortSkala	\N
108502	Patient_Kopfumfang_bit	Kopfumfang bit cm	Decimal_6_3	Patient	781
108503	P_NBP_liBein	Nichtinvaiver Blutdruck linkes Bein	Medic_Pressure	Patient	514
108504	P_NBP_reBein	Nichtinvasiver Blutdruck rechtes Bein	Medic_Pressure	Patient	488
108505	P_NBP_liArm	Nichtinvasiver Blutdruck linker Arm	Medic_Pressure	Patient	396
108506	P_NBP_reArm	Nichtinvasiver Blutdruck rechter Arm	Medic_Pressure	Patient	537
110795	P_NEV_HD_ES_5008onl_BlutflussSNPumpe	\N	Decimal_6_3	Patient	17
110813	P_NEV_HD_VO_5008onl_BlutflussSNPumpe	\N	Decimal_6_3	Patient	4
110838	P_Beatmung_ES_3100A_O2Konzentration	O2 Konzentration des Gasgemisches	Decimal_6_3	Patient	\N
110879	Beatmung_ES_T1_Pmax	\N	Decimal_6_3	Patient	\N
110915	Beatmung_MS_Servoi_I_E	I:E Verhältnis (Messung)	String	Patient	\N
110921	RAP1	rechtsartrialer Druck	Medic_Pressure	Patient	1
110923	ICP1	intracranieller Druck	Medic_Pressure	Patient	\N
113046	Beatmung_ES_T1_Flow	Einstellung Sauerstoff Flow	Decimal_6_3	Patient	\N
117163	P_NEV_HD_ES_Genius_Blutfluss	\N	Decimal_6_3	Patient	163
\.


--
-- Data for Name: config_var; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.config_var (quantity, id, name, description) FROM stdin;
16410672	100093	ABP_1	arterieller Blutdruck 1
4799052	100094	NBP_1	nichtinvasiver Blutdruck 1
4408700	110935	ART	2. artereille Messung, ab 201712 im Rahmen Umstellung Philips Monitoring
206155	103817	PtiO2Druck	Gemessener Sauerstoffpartialdruck im Parenchym
171411	102050	PAP	Pulmunalarterieller Druck
156731	100089	ABP_2	zweiter arterieller Blutdruck
9561	104356	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.
9026	106468	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP
5552	108727	P_Impella_Impella_MS_LVDruck	\N
1774	103724	IABP_DatascopeCS100_MS_SystoleMittelDiastole	\N
24578727	1266	HF	Herzfrequenz
11370555	102010	SpO2	Sauerstoffsättigung Pulsoxymetrie
6890007	1267	AF	Atemfrequenz
6857880	102011	PLS	Pulsrate errechnet aus der SpO2 Messung
5204618	102004	Temp1a	Temperatur 1a
3264032	102902	Beatmung_MS_G5_VTE	Messwert; exspiratorisches Tidalvolumen Einheit: ml
3259020	103034	Beatmung_MS_G5_ExpMinVol	Exspiratorisches Minutenvolumen, Monitoring-Parameter 
3245683	102900	Beatmung_MS_G5_Pmittel	Messwert: Beatmungsmitteldruck
3197094	102901	Beatmung_MS_G5_PeepCPAP	Messwert: Beatmungsdruck Peep / CPAP
3186625	103037	Beatmung_MS_G5_O2VolProzent	Sauerstoffkonzentration des abgegebenen Gasgemisches
3035078	102907	Beatmung_MS_G5_Cstat	Statische Compliance, ein Monitoringwert
3004562	103036	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz
3003172	102905	Beatmung_MS_G5_Rinsp	Inspiratorische Flow-Resistance, ein Monitoring-Parameter
2934534	103035	Beatmung_MS_G5_ftotal	Gesamtatemfrequenz, ein Monitoring Parameter
2755955	102899	Beatmung_MS_G5_Ppeak	Messwert: Beatmungsspitzendruck
1902747	102057	ARR	Arrhythmie Drägermonitoring, VES/min
1867954	110934	P_Temperatur_generic	Anlage für Philips Monitoring
1395054	102942	Beatmung_ES_G5_Sauerstoff	Sauerstoffeinstellung
1279446	1269	ZVD	Zentralvenöser Druck
1159163	102935	Beatmung_ES_G5_Druckrampe	Eine Parametereinstellung. Anstiegszeit des Drucks bei druckkontrollierten und druckunterstützten Atemzyklus.
1138574	102892	Beatmung_ES_G5_Psupport	Einstellwert: Druckunterstützung beim G 5  bei Spontanatemzügen
1106362	105085	Beatmung_ES_G5_PEEP_CPAP_Ptief	Eingestelltes unteres Druckniveau bei den Respirator G5 in verschiedenen Beatmungsmodis.
948526	102012	etCO2	End-tidales CO2
928729	102931	Beatmung_ES_G5_ETS	Exspiratorische Triggersensitivität, eine Parametereinstellung
857825	104009	Beatmung_Messung_Horrowitz	\N
827665	103040	Beatmung_MS_G5_Pinsp	Inspiratorischer Druck; mit Pinsp wird der Zieldruck (zusätzlich zu PEEP/CPAP) bezeichnet, der im Modus ASV während der Inspirationsphase abgegeben wird
827463	104040	Beatmung_MS_G5_VTi	\N
773877	100088	ICP	Intrakranialer Druck
753893	103032	Beatmung_MS_G5_Pplateau	Plateau-Atemwegsdruck, ein Monitoring-Parameter
742578	110933	P_Temperatur_Kern	Anlage für Philips Monitoring
741598	100086	CPP	Zerebraler Perfusionsdruck
740392	102906	Beatmung_MS_G5_Rexsp	Exspiratorische Flow-Resistance, ein Monitoring-Parameter
675846	102903	Beatmung_MS_G5_InspFlow	Inspiratorischer Peakflow, ein Monitoring-Parameter
563157	102916	Beatmung_MS_G5_TE	Exspirationzeit, ein Monitoring-Parameter
507846	104971	NEV_CRRT_MS_Multi_venDruck	\N
507648	104972	NEV_CRRT_MS_Multi_artDruck	\N
480872	104970	NEV_CRRT_MS_Multi_TMP	\N
441662	102912	Beatmung_MS_G5_AutoPeep	Unerwarteter positiver endexspiratorischer Druck, ein Monitoring-Parameter
438173	103715	TempPBT	Temperatur bei der PICCO Messung
416868	103404	Beatmung_ES_G5_Flowtrigger	Die inspiratorische Bemühung des Patienten ( Flow),  die das Beatmungsgerät veranlässt, einen Atemhub abzugeben
384116	103334	Beatmung_ES_G5_Pmax	Hochdruckalarmgrenze im 'ASV Modus
351586	102039	dPmax	Index der linken Ventrikelkontraktilität  
350114	106402	NEV_CRRT_MS_Multi_Bilanz_ml	neue Variable für automatische Datenübernahme IBUS
342306	102904	Beatmung_MS_G5_TI	Inspirationszeit in Sekunden, Monitoring-Parameter
332747	102034	PCCO	Pulskontur-Herzzeitvolumen 
332155	102035	PCCI	Herzindex (kontinuirlich) 
331370	102532	PPV	Pulsdruckabweichung
324633	102036	p-SVI	Schlagvolumenindex  (PICCO Modul Dräger Monitoring)
313183	102408	p-SV	Schlagvolumen
296427	102037	p-SVR	Systemischer Gefäßwiderstand (PICCO Modul Dräger Monitoring) 
295716	100070	SVV	Schlagvolumenabweichung 
294129	105086	Beatmung_ES_G5_Pkontrol_Phoch	Eingestelltes oberes Druckniveau bei dem Respirator  G5 in verschiedenen Beatmungsmodi.
293188	102038	p-SVRI	Index des systemischen Gefäßwiderstandes (PICCO Modul Dräger Monitoring)  
289539	106412	Beatmung_MS_G5_petCO2	\N
273885	104037	Beatmung_MS_G5_Mvspont	\N
262289	104753	Beatmung_ES_G5_Frequenz_Backup	Frequenzeinstellung inder Backupeinstellung.
262224	104754	Beatmung_ES_G5_Apnoezeit_Backup	Apnoezeiteinstellung in der Backupeinstellung.
240537	102914	Beatmung_MS_G5_VLeckage	Leckagevolumen, ein Monitoring-Parameter
230624	103033	Beatmung_MS_G5_Pmin	Minimaler Atemwegsdruck, ein Monitoring Parameter
229381	104756	Beatmung_ES_G5_Pkontrol_Backup	\N
217541	102533	CFI	Herzfunktionsindex
203830	104963	NEV_CRRT_MS_Multi_CitratvolKum	\N
203454	104962	NEV_CRRT_MS_Multi_CalciumVolKum	\N
194583	110930	P_Temperatur_Rektal	Anlage im Rahmen Philips Monitoring
190026	104979	NEV_CRRT_ES_Multi_Ultrafiltration	\N
188552	102491	Oxidationswasser	Oxidationswasser in ml (einfuhrrelevant)
187816	102493	PerspiratioInsensibilis	Perspiratio Insensibilis in ml (Ausfuhrrelevant in der Bilanz)
177501	102915	Beatmung_MS_G5_ExspFlow	Exspiratorischer Peakflow, ein Monitoring-Parameter
6998	102006	Temp2a	Temperatur 2a
177417	102893	Beatmung_ES_G5_PeepCPAP	Einstellwert: Peep bzw. CPAP Niveau in verschiedenen Modi beim G 5
171496	106396	NEV_CRRT_MS_Multi_DialysatvolKum_ml	Anpassung für automatische Datenübernahme IBUS
163205	104980	NEV_CRRT_ES_Multi_Blutfluss	\N
158382	102938	Beatmung_ES_G5_Frequenz	Anzahl der Atemzyklen pro Minute, Parametereinstellung
155427	104978	NEV_CRRT_ES_Multi_Dialysat	\N
154165	104974	NEV_CRRT_ES_Multi_CalciumFiltrat	\N
142391	104967	NEV_CRRT_MS_Multi_Bilanz	\N
136296	104975	NEV_CRRT_ES_Multi_CitratBlut	\N
131661	102944	Beatmung_ES_G5_ProzentMinVol	Przentsatz des Minutenvolumens, eine Parametereinstellung im ASV Modus
130983	102888	Beatmung_ES_G5_Thoch	Einstellwert: Zeiteinstellung des oberes Druckniveau beim G 5 im Modus DuoPAP
111518	100096	Beatmung_Messung_VTeMl	VTe / ex. Atemzugvolumen (Tidal Volumen expir.)
111043	100300	Beatmung_Messung_Pmax	Peak Airway Pressure
110131	104968	NEV_CRRT_MS_Multi_Calciumfluss	\N
108942	100275	Beatmung_Messung_PEEP	\N
108930	101442	Beatmung_Messung_AF	Breathing Frequency
108818	101441	Beatmung_Messung_Pmean	Mean Airway Pressure
108636	100098	Beatmung_Messung_MV	Mindest Volumen tot.
107611	104969	NEV_CRRT_MS_Multi_Citratfluss	\N
102782	101433	Beatmung_Messung_Compliance	Compliance
102667	101435	Beatmung_Messung_Resistance	Resistance
102346	102909	Beatmung_MS_G5_RCexsp	Exspiratorische Zeitkonstante, ein Monitoring-Parameter
97971	102071	Beatmung_Messung_O2KonzentrationG5	\N
97841	103011	Nierenverfahren_MS_Multi_venDruck	venöser Druck
97677	103010	Nierenverfahren_MS_Multi_artDruck	arterieller Druck
97578	103012	Nierenverfahren_MS_Multi_TMPDruck	Transmembrandruck
96925	103116	Nierenverfahren_MS_Bilanz	Variable wird verwendet für Multifiltrate und ADM 08
95179	6	Patient_Gewicht	Gewicht des Patienten
87138	104758	Schlagvolumen	gemessenes Schlagvolumen
86700	100072	CI	Herzindex
83156	104760	Schlagvolumenindex	Wert des gemessenen Schlagvolumenindex.
79120	7	Patient_Groesse	Größe des Patienten
76517	104966	NEV_CRRT_MS_Multi_DialysatvolKum	\N
74252	106393	NEV_CRRT_MS_Multi_Behandlungszeit_Aktuell__min	Anpassung für die automatische Datenübermnahme IBUS
73292	110758	P_Beatmung_ES_Anfeuchtung_Temperatur	\N
60553	103049	Nierenverfahren_MS_Multi_DialysatvolumenKumulativ	kumulatives Dialysatvol
60046	102890	Beatmung_ES_G5_Phoch	Einstellwert oberes Druckniveau im beim G 5 im Modus DuoPAP
59723	100270	Beatmung_Messung_AFSpontan	Respiratory Rate (spontan)
59320	101414	Lungenersatzverfahren_Doku_ECMOBlutfluss	\N
59195	110929	P_Temperatur_Tympanal	Anlage im Rahmen PhilipsMonitoring
58936	101415	Lungenersatzverfahren_Doku_ECMOPumpendrehzahl	\N
53657	101413	Lungenersatzverfahren_Doku_ECMOAirFlow	\N
52807	101412	Lungenersatzverfahren_Doku_ECMOInspiratorischSaO2	\N
52545	103403	Beatmung_ES_G5_Drucktrigger	Inspiratorische Bemühung des Patienten, die das Beatmungsgerät veranlasst, einen Atemhub abzugeben
50953	102887	Beatmung_ES_G5_Ti	Einstelungswert für die Inspirationszeit
43338	108525	Beatmung_ES_G5_Flow	Parameter im Modus Highflow - ab 08.06.2017
39233	103059	Nierenverfahren_MS_Multi_CitratvolumenKumulativ	kumulativ Citrat
39078	103060	Nierenverfahren_MS_Multi_CalciumvolumenKumulativ	kumulativ
37979	102946	Beatmung_ES_G5_Groeße	Eine Parametereinstellung im ASV Modus. Sie wird zur Berechnnug des idealen Körpergewichts (IBW) des Patienten verwendet
34114	100074	SVR	Systemischer Gefäßwiderstand
33068	102185	VigilanceC_CI	Herzindex
33020	103296	Beatmung_ES_Evita4_O2Konzentration	eingestellte O2 Konzentration des Frischgases
29967	100105	Beatmung_Einstellung_FiO2	O²- Konzentration im Inspirationsgemisch (FiO2)
29275	100073	SVRI	Index des systemischen Gefäßwiderstandes 
29081	103338	Nierenverfahren_MS_BM25_AbnahmeKumulativ	\N
28887	100102	Beatmung_Einstellung_PEEP	Positiver endexspiratorischer Druck (PEEP)
28732	103716	TempBT	Bluttemperatur bei der HZV Messung
28190	103019	Nierenverfahren_MS_BM25_artDruck	\N
28112	103020	Nierenverfahren_MS_BM25_venDruck	\N
27734	102977	Nierenverfahren_ES_Multi_Ultrafiltration	Ultrafiltrationsrate ml/h
27055	102025	PVR	Pulmunaler Gefäßwiderstand 
27019	114052	NEV_CRRT_MS_Multi_praeF	\N
26821	103022	Nierenverfahren_MS_BM25_DruckvorFilter	\N
25803	103021	Nierenverfahren_MS_BM25_TMPDruck	\N
25700	103809	tcpCO2	transcutan gemessener pCO2 Wert.
25493	103301	Beatmung_ES_Evita4_PEEP	eingestelltes PEEP Niveau
24916	102184	VigilanceC_HZV	Herzzeitvolumen
24004	104036	Beatmung_ES_G5_Pasvlimit	\N
23560	102040	p-CO	Herzzeitvolumen (PICCO Modul Dräger Monitoring) 
23211	102045	GEF	Globale Auswurffraktion 
23023	102041	GEDV	Globales enddiastolisches Volumen 
22205	102976	Nierenverfahren_ES_Multi_Blutfluss	Blutpumpengeschwindigkeit ml/min
21963	104039	Beatmung_ES_G5_Pinsp	\N
21891	102042	GEDVI	Index des enddiastolisches Volumen 
21305	103013	Nierenverfahren_MS_Multi_DruckvorFilterDruck	\N
21083	103302	Beatmung_ES_Evita4_ASB	eingestellte Druckunterstützung
21002	100106	Beatmung_Einstellung_ASB	Inspiratorische Druckunterstützung [inspiratory pressure support] (IPS) bzw. assisted spontaneuous breathig (ASB)
20646	106395	NEV_CRRT_MS_Multi_SubVolKum_ml	Änderung für die automatische Datenübernahme IBUS
19523	103123	Nierenverfahren_ES_Multi_Dialysat	\N
19345	104977	NEV_CRRT_ES_Multi_Substituat	\N
19289	101401	Nierenersatzverfahren_Mess_ArteriellDruck	\N
19281	103058	Nierenverfahren_ES_Multi_CalciumFiltrat	Calciumrate
19206	102980	Nierenverfahren_ES_Multi_Temperatur	Tempertatu Celsius
19113	102891	Beatmung_ES_G5_Pkontrol	Einstellwert oberes Druckniveau beim G 5 im Modus P SIMV
19057	104965	NEV_CRRT_MS_Multi_SubVolKum	\N
18937	101422	Patient_KO	Körperoberfläche des Patienten ohne Fallbezug
17911	110926	P_Temperatur_Haut	Anlage im Rahmen PhilipsMonitoring
17611	101447	Beatmung_Messung_Pplateau	Plateau Druck
17553	103299	Beatmung_ES_Evita4_Rampe	eingestellte Anstiegszeit vom unteren zum oberen Druckniveau
17225	104876	NEV_HD_MS_4008HS_venDruck	\N
17186	104877	NEV_HD_MS_4008HS_artDruck	\N
16976	104875	NEV_HD_MS_4008HS_TMP	\N
16681	108630	P_Therapiebetten_Doku_Lifetherm_ES_Temperatur	\N
16602	108623	P_Therapiebetten_Doku_Lifetherm_ES_Strahler	\N
16525	104961	NEV_CRRT_MS_Multi_UFR_BFRVerhaeltnis	\N
16439	103300	Beatmung_ES_Evita4_Pinsp	eingestelltes oberes Druckniveau
15958	102886	Beatmung_ES_G5_Timax	eingestellte maximale Inspirationszeit beim G5 im Modus NIV
15837	103050	Nierenverfahren_MS_BM25_DialysatvolumenKumulativ	\N
15728	103057	Nierenverfahren_ES_Multi_CitratBlut	Citratrate
15526	102073	Beatmung_Einstellung_O2Konzentration	\N
15079	102535	p-CI	Herzindex
14312	102043	EVLW	Extravaskuläres Lungenwasser 
14075	108509	SpO2_2	\N
13606	102494	PerspiratioSensibilis	Perspiratio Sensibilis in ml (ausfuhrrelevant in der Bilanz)
13579	102044	EVLWI	Extravaskuläres Lungenwasserindex 
13516	100069	ITBV	Intrathorakales Blutvolumen
13382	103298	Beatmung_ES_Evita4_frequenz	eingestellte Atemfrequenz
13373	103297	Beatmung_ES_Evita4_Tinsp	eingestellte absolute Inspirationszeit
13367	103303	Beatmung_ES_Evita4_Flowtrigger	Einstellgröße des Flowtriggers
12800	102536	ITBVI	Index des intrathorakalen Blutvolumens
12621	102047	PVPI	Pulmonalvaskuläer Permeabilitätsindex 
12533	104872	NEV_HD_MS_4008HS_effBlutfluss	\N
12427	104873	NEV_HD_MS_4008HS_Leitfähigkeit	\N
12372	101397	Nierenersatzverfahren_Mess_AbnahmeKumulat	\N
12360	100100	Beatmung_Messung_FiO2	FiO2
11960	102756	Nierenersatzverfahren_Mess_VenoeserDruck	\N
11682	102490	Vigileo_CI	\N
11632	103306	Beatmung_ES_Evita4_fApnoe	eingestellte Atemfrequenz in der Apnoeventilation
11553	101395	Nierenersatzverfahren_Mess_UmsatzKumulati	\N
11454	103015	Nierenverfahren_MS_Multi_SubvolumenKumulativ	\N
11344	103305	Beatmung_ES_Evita4_VtApnoe	Einstellgröße für das Tidalvolumen in der Apnoeeinstellung
11300	101399	Nierenersatzverfahren_Mess_DruckVorFilter	\N
11062	103062	Nierenverfahren_MS_Multi_Calciumfluss	Calciumrate
10962	101400	Nierenersatzverfahren_Dokumentation_Filtratdruck	\N
10853	100097	Beatmung_Messung_MVSpontan	Mindest Volumen sp
10704	101443	Beatmung_Messung_Pmin	Minimum Airway Pressure
10303	103061	Nierenverfahren_MS_Multi_Citratfluss	Citratrate
9989	101444	Beatmung_Messung_IntrinsicPEEP	Intrinsic PEEP
9873	103088	Beatmung_ES_F120_O2Konzentration	Einstellparameter: Sauerstoffgehalt des Gasgemisches
9674	101398	Nierenersatzverfahren_Dokumentation_Blutfluss	\N
9626	103018	Nierenverfahren_MS_Multi_Behandlungszeit	\N
9614	103087	Beatmung_ES_F120_Flow	Einstellwert: Größe des Gasflusses beim F 120
9453	112007	P_INVOS_Doku_rSO2_rechts	cerbebrale Sauerstoffsättigung rechts
9167	112006	P_INVOS_Doku_rSO2_links	cerebrale Sauerstoffsättigung links
8912	105014	Schrittmacher_Osypka101H_ES_Rate	Grundfrequenz
8725	104878	NEV_HD_MS_4008_HS_onl_Ultrafiltratmengekum	\N
8702	103086	Beatmung_ES_F120_CPAP	Eingestelltes CPAP Niveau
8509	102176	Vigileo_SV	ml/b
8502	106332	CardioHelpMaquet_MS_Blutfluss	\N
8292	103333	Beatmung_ES_G5_Vt	Einstellwert: Tidalvolumen
8096	102119	Nierenersatzverfahren_Mess_TMP	TransmembranDruck
7997	104888	NEV_HD_ES_4008HS_Blutfluss	\N
7992	102991	Nierenverfahren_ES_BM25_Abnahme	Ultrafiltrationsrate
7791	105043	Hypothermie_ArticSun_MS_Wassertemperatur	kontrollierte Wassertemperatur, gemessener Wert
7645	106331	CardioHelpMaquet_MS_DruckArteriell	\N
7640	106330	CardioHelpMaquet_MS_DruckVenoes	\N
7638	103206	Nierenverfahren_MS_UltrafiltratmengeKum	Kumulativer Entzug, bilanzrelevant
7634	106329	CardioHelpMaquet_MS_DeltaP	\N
7616	104893	NEV_HD_ES_4008HS_UFZiel	\N
7591	103702	Hypothermie_ArticSun_Doku_Patiententemperatur	\N
7401	103164	Nierenverfahren_MS_4008HS_venDruck	\N
7341	102489	Vigileo_CO	\N
7327	103163	Nierenverfahren_MS_4008HS_artDruck	\N
7263	101402	Nierenersatzverfahren_Mess_VenDruck	\N
7251	104880	NEV_HD_ES_4008HS_Temperatur	\N
7195	104151	Beatmung_ES_Airvo_O2Konzentration	Dokumentation der O2 Konzentration in Abhängigkeit der Einstellgrößen FlowSetting und O2 Flow.
7188	106328	CardioHelpMaquet_MS_SvO2	\N
7188	104944	NEV_HD_VO_4008HS_UF_Ziel	\N
7185	103165	Nierenverfahren_MS_4008HS_TMP	\N
7161	104808	Beatmung_ES_C2_Sauerstoff	\N
7146	110937	P_Beatmung_MS_AnaConDa_MAC	Umstellung PhilipsMonitoring
7100	105045	BIS	Der Bispectral Index (BIS) ist ein verarbeiteter EEG Parameter und zeigt die Auswirkungen der Sedierung auf das Gehirn an.
7091	105019	Schrittmacher_Osypka203H_ES_Rate	Grundfrequenz
7084	105015	Schrittmacher_Osypka101H_ES_Sense	Empfindlichkeit
7072	105016	Schrittmacher_Osypka101H_ES_STIM	Stimulation
7061	106352	CardioHelpMaquet_DOKU_HB	\N
7055	106351	CardioHelpMaquet_DOKU_HCT	\N
7040	103078	Beatmung_MS_VisionA_Amplitude	gemessene Druckdifferenz im HFOV Modus
6945	102878	Beatmung_MS_VisionA_MAP	gemessener Mittlerer Atemwegsdruck unter HFO bei Alpha Vision
6853	104943	NEV_HD_VO_4008HS_Blutfluss_Max	\N
6803	104892	NEV_HD_ES_4008HS_UFRate	\N
6787	104936	NEV_HD_VO_4008HS_Temperatur	\N
6772	102990	Nierenverfahren_ES_BM25_Blutfluss	Blutpumpengeschwindigkeit
6632	104935	NEV_HD_VO_4008HS_Fluss	\N
6475	104879	NEV_HD_ES_4008HS_Fluss	\N
6446	104881	NEV_HD_ES_4008HS_Bicarbonat	\N
6443	102628	Nierenersatzverfahren_Mess_Bilanz	\N
6326	104938	NEV_HD_VO_4008HS_Soll_Na	\N
6271	110782	P_NEV_HD_MS_5008onl_artDruck	\N
6254	110781	P_NEV_HD_MS_5008onl_venDruck	\N
6205	104871	NEV_HD_MS_4008HS_BlutvolKum	\N
6184	102881	Beatmung_MS_VisionA_HFOBaseFlow	gemessener Basis Continousflow
6142	104149	Beatmung_ES_Airvo_FlowSetting	Einstellunggröße  des Flows am Gerät
6106	110928	P_Temperatur_Oesophagial	Anlage im Rahmen PhilipsMonitoring
6105	104937	NEV_HD_VO_4008HS_Bicarbonat	\N
5952	102088	Lungenersatzverfahren_Doku_ECMOATZ	\N
5819	103943	Beatmung_ES_Heimbeatmung_Peep	\N
5765	104882	NEV_HD_ES_4008HS_SollNa	\N
5573	102074	Beatmung_Einstellung_SauerstoffFlow	\N
5543	105078	Beatmung_ES_C2_PEEP_CPAP_Ptief	Eingestellter PEEP, CPAP oder Ptief am C2.
5523	103169	Nierenverfahren_MS_4008HS_effBlutfluss	\N
5443	107907	Beatmung_ES_Heimbeatmung_Frequenz	\N
5419	110780	P_NEV_HD_MS_5008onl_TMP	\N
5417	101393	Nierenersatzverfahren_Einstell_Umsatz	\N
5376	104810	Beatmung_ES_C2_Druckrampe	\N
5305	102503	Nierenersatzverfahren_Dokumentation_BlutflussEinst	\N
5270	104809	Beatmung_ES_C2_ETS	\N
5250	100108	Beatmung_Einstellung_AF	Beatmungsfrequenz (f/AF)
5206	103168	Nierenverfahren_MS_4008HS_Leitfähigkeit	\N
5191	102062	Beatmung_Einstellung_PAW/Pinspiration	\N
5184	106401	NEV_HD_MS_4008_HS_onl_Ultrafiltratmengekum_ml	Anpassung im Zuge der automatischen Datenübernahme IBUS
5150	103340	IABP_Doku_Ballonvolumen	\N
5086	102880	Beatmung_MS_VisionA_SISetting	Dauer des manuell durchgeführten Atemhubs
5075	105023	Schrittmacher_Osypka203H_ES_V_STIM	Stimulation Ventrikel
5039	106334	CardioHelpMaquet_ES_Pumpendrehzahl	\N
4966	110783	P_NEV_HD_MS_5008_onl_Ultrafiltratmengekum_ml	\N
4952	107909	Beatmung_MS_Heimbeatmung_Ppeak	\N
4934	107908	Beatmung_MS_Heimbeatmung_MV	\N
4839	102631	Nierenersatzverfahren_Mess_Dialysatvolumen	\N
4802	103041	Beatmung_MS_G5_P01	Atemweg-Okklusionsdruck, ein Monitoring-Parameter
4773	106335	CardioHelpMaquet_ES_Gasfluss	\N
4724	106668	HeartWare_RPM_Doku	\N
4718	110866	Beatmung_ES_Heimbeatmung_Sauerstoff	\N
4705	102026	PVRI	Pulmunaler Gefäßwiderstandsindex 
4686	106667	HeartWare_Watt_Doku	\N
4675	106336	CardioHelpMaquet_ES_FiO2	\N
4618	103170	Nierenverfahren_MS_4008HS_BlutvolumenKum	\N
4596	103079	Beatmung_MS_VisionA_O2Konzentration	gemessene Sauerstoffgehalt des Gasgemisches
4587	104349	IABP_DatascopeCS300_ES_Unterstützungsdruck	Dokumentation des Unterstützungsdruckes.
4573	104874	NEV_HD_MS_4008HS_SollNa	\N
4554	104973	NEV_CRRT_ES_Multi_Temperatur	\N
4451	103166	Nierenverfahren_MS_4008HS_Restzeit	\N
4421	108722	P_Beatmung_MS_AnaConDa_etGaskonz	\N
4388	104819	Beatmung_ES_C2_Psupport	\N
4375	103124	Nierenverfahren_ES_BM25_Dialysat	\N
4361	102978	Nierenverfahren_ES_Multi_Substituat	Umsatz, Austausch Substituat ml/h
4305	103017	Nierenverfahren_MS_Multi_UFRBFRVerhaeltnis	\N
4282	110867	Beatmung_ES_Heimbeatmung_Psupport	\N
4278	103381	Schrittmacher_Eins_ES_Frequenz	Medtronic 5348
4251	108721	P_Beatmung_MS_AnaConDa_inspGaskonz	\N
4235	103563	PCWP	\N
4169	110778	P_NEV_HD_MS_5008onl_Leitfaehigkeit	\N
4161	102179	Vigileo_SVI	SchlagvolumenindexSchlagvolumenindex
4120	104805	Beatmung_ES_C2_Flowtrigger	\N
4107	103215	Beatmung_MS_3100B_Amplitude	Messwert: gemessene Druckamplitude
4022	106471	IABP_CARDIOSAVE_ES_Unterstuetzungsdruck	Dokumentation des Unterstützungdruckes
3985	103077	Beatmung_ES_VisionA_O2Konzentration	Eingestellte Sauerstoffzufuhr
3942	108742	P_Temperatur_DeltaT	Delta Temperatur zentral/Temperatur peripher
3922	106669	HeartWare_Blutfluss_Doku	\N
3908	108729	P_Impella_Impella_MS_Flow	\N
3884	108730	P_Impella_Impella_MS_PurgeFlow	\N
3863	102873	Beatmung_ES_VisionA_MAP	Mittlerer Atemwegsdruck (MAP)
3794	103152	Nierenverfahren_ES_4008HS_Blutfluss	\N
3772	102072	Beatmung_Einstellung_DruckFlow	\N
3733	103254	Nierenverfahren_VO_4008HS_Dialysezeit	\N
3733	103237	Nierenverfahren_VO_4008HS_UFZiel	\N
3721	103024	Nierenverfahren_MS_BM25_UmsatzvolumenKumulativ	\N
3718	103216	Beatmung_MS_3100B_O2Konzentration	Messwert: gemessene O2 Konzentration des Gasgemisches
3707	104752	Beatmung_ES_G5_Vt_Backup	Vt in der Backupeinstellung
3686	102894	Beatmung_ES_G5_Ttief	Einstellwert: Zeiteinstellung für das untere Druckniveau beim G5 im Modus APRV
3678	103698	Hypothermie_ArticSun_Doku_Zieltemperatur	\N
3659	103382	Schrittmacher_Eins_ES_Ausgang	Medtronic 5348
3590	103147	Nierenverfahren_ES_4008HS_UFZiel	Ultrafiltrationsziel
3562	106327	CardioHelpMaquet_MS_TemperaturIst	\N
3542	103213	Beatmung_ES_3100B_Mitteldruck	Einstellwert: eingestellter mittlerer Atemwegsdruck
3499	102102	Nierenersatzverfahren_Einstell_Blutfluss	\N
3464	106392	NEV_HD_MS_4008HS_BlutvolKum_ml	Anpassung aufgrund IBUS Anbindung
1302358	106480	EinweisenderArzt_PLZ	\N
3441	103383	Schrittmacher_Eins_ES_Empfindlichkeit	Medtronic 5348
3395	103146	Nierenverfahren_ES_4008HS_DialyseZeit	\N
3395	102874	Beatmung_ES_VisionA_Schlagvolumen	Schlagvolumen (SV) in engl. (cycle volume)
3352	110796	P_NEV_HD_ES_5008onl_Blutfluss	\N
3338	108508	tcpO2	transcutan gemessener pO2 Wert.
3329	102872	Beatmung_ES_VisionA_Oszillationsfrequenz	Oszillationsfrequenz Gerät: Alpha Vision Modus: HFO
3303	103242	Nierenverfahren_VO_4008HS_SollNatrium	\N
3284	107912	Beatmung_MS_Heimbeatmung_VTi	\N
3283	104352	IABP_DatascopeCS300_ES_Doku_Ballonvolumen	Dokumentation des Ballonvolumens.
3277	103148	Nierenverfahren_ES_4008HS_UFRate	Ultrafiltrationsrate
3244	102051	HZV	Herzzeitvolumen
3213	103161	Nierenverfahren_ES_4008HS_Temperatur	\N
3211	100254	Beatmung_Einstellung_Inspirationszeit	Inspirationszeit in %
3148	105000	NEV_CRRT_VO_Multi_Ultrafiltration	\N
3145	105022	Schrittmacher_Osypka203H_ES_A_STIM	Stimulation Vorhof
3086	107980	P_Beatmung_ES_C3_Sauerstoff	\N
3080	105001	NEV_CRRT_VO_Multi_BlutflussMax	\N
3076	106390	NEV_HD_MS_4008HS_Rest_Zeit_min	Anpassung für IBUS Anbindung
2969	103307	Beatmung_ES_Evita4_Tubuskompensation	Einstellgröße für die Tubuskompensation
2955	102198	VigilanceC_O2	\N
2935	102587	Nierenersatzverfahren_Einstell_UFR	\N
2899	110801	P_NEV_HD_ES_5008onl_UFZiel	\N
2884	106469	IABP_CARDIOSAVE_ES_IABPAufblasen	Dokumentation des prozentualen Anteils des Aufblasens des Ballons
2863	106474	IABP_CARDIOSAVE_ES_IABPLeersaugen	Dokumentation des prozentualen Anteils des Leersaugens des Ballons
2849	103244	Nierenverfahren_VO_4008HS_Temperatur	\N
2801	103565	Schrittmacher_Doku_Wahrnehmung	\N
2795	104261	Beatmung_ES_Servoi_O2	Sauerstoffkonzentration 
2764	103160	Nierenverfahren_ES_4008HS_Bicarbonat	\N
2761	102876	Beatmung_ES_VisionA_HFOBaseFlow	Basis Continousflow
2758	110785	P_NEV_HD_ES_5008onl_Temperatur	\N
2737	103162	Nierenverfahren_ES_4008HS_Fluss	\N
2728	103243	Nierenverfahren_VO_4008HS_Bicarbonat	\N
2728	103564	Schrittmacher_Doku_Reizschwelle	\N
2690	107911	Beatmung_MS_Heimbeatmung_VTe	\N
2640	110817	P_NEV_HD_VO_5008onl_UFZiel	\N
2640	103818	NIRSlinks_MS	Über eine Messsonde transcutan gemessener Prozentwert
2620	107910	Beatmung_MS_Heimbeatmung_Pmittel	\N
2590	110868	Beatmung_ES_Heimbeatmung_Pcontrol	\N
2584	100272	Beatmung_Messung_ASB	\N
2583	110814	P_NEV_HD_VO_5008onl_BlutflussMax	\N
2578	104999	NEV_CRRT_VO_Multi_Dialysat	\N
2576	103819	NIRSrechts_MS	\N
2563	110777	P_NEV_HD_MS_5008onl_effBlutfluss	\N
2562	106394	NEV_CRRT_MS_Multi_SubBolusVolKum_ml	Anpassung für die automatische Datenübernahme IBUS
2515	104264	Beatmung_ES_Servoi_PEEP	PEEP 
2500	102877	Beatmung_ES_VisionA_SISetting	Druckeinstellung für manuell ausgelösten Atemhub
2499	103832	Lungenersatzverfahren_Doku_ILA_Blutfluss	\N
2488	103158	Nierenverfahren_ES_4008HS_SollNa	\N
2459	102610	Nierenersatzverfahren_Einstell_Temperatur	\N
2456	110786	P_NEV_HD_ES_5008onl_Bicarbonat	\N
2451	106333	CardioHelpMaquet_ES_TemperaturSoll	\N
2448	110820	P_Beatmung_ES_C3_PEEP_CPAP	\N
2406	103210	Beatmung_ES_3100B_Frequenz	Einstellwert: eingestellte Oszillationsfrequenz 
2402	110804	P_NEV_HD_VO_5008onl_Fluss	\N
2391	110784	P_NEV_HD_ES_5008onl_Fluss	\N
2337	110800	P_NEV_HD_ES_5008onl_UFRate	\N
2332	106407	Hypothermie_ArticSun_MS_Zieltemperatur	Messwert im Verlaufbis zum erreichen der eingestellten Zieltemperatur
2324	110805	P_NEV_HD_VO_5008onl_Temperatur	\N
2271	104883	NEV_HD_ES_4008HS_BasisNa	\N
2249	102106	Nierenersatzverfahren_Einstell_Dialysatfluß	\N
2237	102889	Beatmung_ES_G5_Plateau	prozentualer Anteil der Inspiration, der Plateauphase bestimmt wird
2225	103214	Beatmung_ES_3100B_O2Konzentration	Einstellwert: O2 Konzentration des Gasgemisches
2211	110787	P_NEV_HD_ES_5008onl_SollNa	\N
2188	102993	Nierenverfahren_ES_BM25_Temperatur	Temperatur Celcius
2174	110806	P_NEV_HD_VO_5008onl_Bicarbonat	\N
2145	103386	Schrittmacher_zwei_ES_Frequenz	Medtronic 5375
2132	103211	Beatmung_ES_3100B_Inspirationszeit	Einstellwert: prozentualer Anteil der Inspirationszeit bezogen auf den gesamtem Atemzyklus
2105	110807	P_NEV_HD_VO_5008onl_SollNa	\N
2104	103209	Beatmung_ES_3100B_BiasFlow	Einstellwert: eingestellter Basisfluss im Beatmungssystem
2096	110904	P_Patient_Gewicht_Differenz	Differenz zwischen dem aktuellen Gewicht und dem Gewicht des letzten Eintrags
2028	103831	Lungenersatzverfahren_Doku_ILA_Gasfluss	\N
2017	102183	Vigileo_ScvO2	\N
2009	103167	Nierenverfahren_MS_4008HS_SollNatrium	\N
2008	102068	Beatmung_Einstellung_DruckTrigger	\N
1906	110939	P_Beatmung_ES_NO	\N
1902	104803	Beatmung_MS_C2_Ppeak	\N
1881	110938	P_Beatmung_MS_NO2	\N
1875	104798	Beatmung_MS_C2_VTE	\N
1866	103387	Schrittmacher_zwei_ES_Ausgang	Medtronic 5375
1860	104797	Beatmung_MS_C2_ExpMinVol	\N
1808	110779	P_NEV_HD_MS_5008onl_SollNa	\N
1745	103238	Nierenverfahren_VO_4008HS_BlutflussMax	\N
1745	103388	Schrittmacher_zwei_ES_Empfindlichkeit	Medtronic 5375
1724	110881	Beatmung_ES_Heimbeatmung_Ti	\N
1720	104790	Beatmung_MS_C2_fSpontan	\N
1713	103720	IABP_DatascopeCS100_ES_Unterstützungsdruck	\N
1657	104791	Beatmung_MS_C2_fTotal	\N
1653	105024	Schrittmacher_Osypka203H_ES_AV_DLY	AV Überleitungszeit
1234971	102926	Beatmung_MS_G5_IEVerhaeltnis	gemessenes I:E Verhältnis
1645	103212	Beatmung_ES_3100B_Leistung	Einstellwert: prozentuale Kolbenauslenkung
1642	104251	Beatmung_MS_Servoi_Ppeak	Atemdruck Spitze 
1592	110772	P_NEV_HD_MS_5008onl_Rest_Zeit_min	\N
1542	104800	Beatmung_MS_C2_PeepCPAP	\N
1512	110754	P_Therapiebetten_Doku_DraegerBabytherm_ES_Temp	\N
1501	104801	Beatmung_MS_C2_Pmittel	\N
1498	102059	Beatmung_Einstellung_ASBAnstieg	\N
1494	110755	P_Therapiebetten_Doku_DraegerBabytherm_ES_Strahler	\N
1485	106783	Beatmung_ES_Optiflow_O2Konzentration	\N
1484	104239	Beatmung_MS_Servoi_Vte	Exsp. Tidalvolumen 
1484	104804	Beatmung_MS_C2_Sauerstoff	\N
1483	104345	IABP_DatascopeCS300_ES_IABPAufblasen	Dokumentation des prozentualen Anteil des Aufblasens des Ballons.
1465	102753	Nierenersatzverfahren_Mess_CalciumFluss	\N
1452	102721	Nierenersatzverfahren_Einstell_Calcium	\N
1448	105077	Beatmung_ES_C2_Pmax	Eingestellte Alarmhochdruckgrenze. Einstellung erfolgtdirekt über die Alarmeinstellung aber auch indirekt über die Einstellung Pasvlimit. Die Alarmhochdruckgrenze liegt automatisch 10 mbar über der Pasvlimit Einstellung.
1448	102752	Nierenersatzverfahren_Mess_CitratFluss	\N
1437	106784	Beatmung_ES_Optiflow_O2Flow	\N
1432	107996	P_Beatmung_ES_C3_Flowtrigger	\N
1432	100091	LAP	Linksatrial  Mitteldruck
1412	103092	Beatmung_ES_CF800_DruckluftFlow	Einstellgröße: Gasfluss Druckluft
1409	106281	Beatmung_ES_C2_Apnoezeit_Backup	\N
1399	104884	NEV_HD_ES_4008HS_StartNa	\N
1398	104347	IABP_DatascopeCS300_ES_IABPLeersaugen	Dokumentation des prozentualen Anteils des Leersaugens des Ballons.
1396	103091	Beatmung_ES_CF800_SauerstoffFlow	Einstellgröße Gasfluss Sauerstoff
1392	108665	P_Waermesysteme_FisherPaykel_Doku_Prozent	\N
1389	103093	Beatmung_ES_CF800_O2Konzentration	Sauerstoffgehalt des eingestellten Gasgemisches CF 800
1366	104793	Beatmung_MS_C2_InsFlow	\N
1362	104788	Beatmung_MS_C2_TE	\N
1357	102627	Nierenersatzverfahren_Mess_SubstituatVolumen	\N
1356	102992	Nierenverfahren_ES_BM25_Umsatz	Austausch, Substituat, ml/h
1340	103195	Nierenverfahren_MS_4008onl_venDruck	\N
1321	103194	Nierenverfahren_MS_4008onl_artDruck	\N
1315	103196	Nierenverfahren_MS_4008onl_TMP	\N
1306	102007	Temp2b	Temperatur 2b
1297	104833	NEV_Apherese_ES_Multi_Plasma	\N
1275	103157	Nierenverfahren_ES_4008HS_BasisNa	\N
1268	110776	P_NEV_HD_MS_5008onl_BlutvolKum	\N
1267	103245	Nierenverfahren_VO_4008HS_Fluss	\N
1265	104784	Beatmung_MS_C2_Cstat	\N
1254	104786	Beatmung_MS_C2_Rinsp	\N
1251	104807	Beatmung_ES_C2_ProzentVol	\N
1241	103269	Beatmung_ES_Evita2_Frequenz	eingestellt mandatorische Atemfrquenz
1203	102729	Nierenersatzverfahren_Einstell_Citrat	\N
1194	108639	P_Temperaturregulation_Blankettrol_Doku_Temp	\N
1191	11	COPRA_Patient_Kopfumfang	Kopfumfang des Patienten in Zentimetern
1189	104117	Lungenersatzverfahren_MS_ILA_SpO2	\N
1187	102097	Lungenersatzverfahren_Doku_ILAQ1Flow	\N
1183	103320	Beatmung_MS_Evita4_MV	gemessenes Atemminutenvolumen
1182	102578	Beatmung_Einstellung_ProzentMinVol	\N
1169	107991	P_Beatmung_ES_C3_Ti	\N
1161	104820	Beatmung_ES_C2_Pinsp	\N
1151	107986	P_Beatmung_ES_C3_Pinsp	Inspiratorischer Druck
1148	103200	Nierenverfahren_MS_4008onl_effBlutfluss	\N
1145	107977	P_Beatmung_ES_C3_Druckrampe	\N
1142	103315	Beatmung_MS_Evita4_Ppeak	gemessener Atemwegsspitzendruck
1128	104282	Beatmung_ES_Servoi_SIMV_Frequenz	SIMV Frequenz 
1115	107997	P_Beatmung_ES_C3_ETS	\N
1110	104782	Beatmung_ES_C2_Ti	\N
1109	103314	Beatmung_MS_Evita4_FiO2	gemessene O2 Konzentration des inspiratorischen Atemgasgemisches
1108	100249	Beatmung_Einstellung_FlowTrigger	\N
1099	107998	P_Beatmung_ES_C3_Flow	\N
1097	104268	Beatmung_ES_Servoi_DU_ueber_PEEP	DU über PEEP 
1064	103323	Beatmung_MS_Evita4_frequenz	gemessene Gesamtatemfrequenz
1059	103094	Beatmung_ES_CF800_CPAP	eingestelltes CPAP Niveau
1055	103199	Nierenverfahren_MS_4008onl_Leitfähigkeit	\N
1052	110882	Beatmung_ES_Heimbeatmung_Timax	eingestellte maximale Inspirationszeit 
1052	104939	NEV_HD_VO_4008HS_Start_Na	\N
1051	103201	Nierenverfahren_MS_4008onl_BlutvolumenKumulativ	\N
1044	103318	Beatmung_MS_Evita4_PEEP	gemessener positiver endexspiratorischer Druck
1043	104244	Beatmung_MS_Servoi_Mve_spont	Spontanes exsp. Minutenvolumen 
1043	103317	Beatmung_MS_Evita4_Pmean	gemessener Atemwegsmitteldruck
1029	107993	P_Beatmung_ES_C3_Timax	Inspirationszeit max
1025	108634	P_Waermesysteme_BarkeyWaermepaddels_Doku_Temp	\N
1022	104830	NEV_Apherese_MS_Multi_artDruck	\N
1021	104829	NEV_Apherese_MS_Multil_venDruck	\N
1020	104249	Beatmung_MS_Servoi_Pmean	Mittlerer Atemwegsdruck 
1019	101322	Patient_AufnGewicht	Aufnahmegewicht (fallbezogen)
1016	103197	Nierenverfahren_MS_4008onl_Restzeit	\N
1006	104828	NEV_Apherese_MS_Multi_TMP	\N
4962086	100095	Herzrhythmus	Herzrhythmus
2506099	23	Fall_Nummer	Identifikationsnummer des Falles
2499758	101329	Fall_Art	\N
2225895	102013	PACED	\N
1536842	2	Patient_Name	Name des Patiente
1536836	3	Patient_Vorname	Vorname des Patiente
1536775	8	Patient_ID	Identifikation des Patiente
1536761	5	Patient_Geschlecht	Geschlecht des Patienten
1302682	106483	EinweisenderArzt_Name	\N
1302682	106478	EinweisenderArzt_Land	\N
1302459	106479	EinweisenderArzt_Ort	\N
1197501	106481	EinweisenderArzt_Strasse	\N
1107460	106477	EinweisenderArzt_Telefon	\N
1018430	105082	Beatmung_ES_G5_Body_Wt	Eingestelltes Körpergewicht.
1009318	106484	EinweisenderArzt_Titel	\N
1000261	100092	Ereignisse Vitlaparameter Graphisch	Ereignisse Vitlaparameter Graphisch als Listenauswahl
723927	106482	EinweisenderArzt_Vorname	\N
714951	100024	Patient_Nationalitaet	Nationalität des Patienten
713394	101327	Patient_Land	Patientenadresse: Land
712917	101325	Patient_PLZ	Patientenadresse: PLZ
712910	101326	Patient_Ort	Patientenadresse: Ort
700705	100023	Patient_Strasse	Adresse des Patienten: Strasse + Hausnummer
669378	105083	Beatmung_ES_G5_F_CMV	Eingestellte CMV Frequenz bei dem Respirator G5 in den Beatmungsmodi DUOPAP, APVcmv, Pcmv, 
584232	100036	Patient_Telefon	Telefonnummer des Patienten
419297	100035	Angehoerige1_Name	Nachname des Angehörigen
406430	101781	Angehoerige1_Land	\N
395020	101780	Angehoerige1_Ort	\N
394750	101779	Angehoerige1_PLZ	\N
394503	100034	Angehoerige1_Telefon	Angehoerigen-Telefon
392403	101778	Angehoerige1_Strasse	\N
355988	101777	Angehoerige1_Vorname	\N
295760	105049	NEV_CRRT_ES_Multi_Temp	neu angelegt am 18.05.2012
288555	101786	Hausarzt_Name	\N
288118	101789	Hausarzt_Ort	\N
288051	101788	Hausarzt_PLZ	\N
287855	101787	Hausarzt_Strasse	\N
287777	101790	Hausarzt_Land	\N
279682	101793	Hausarzt_Telefon	\N
268387	103752	Diagnostik	Dokumentation durchgeführter diagnostischer Maßnahmen.
261023	106486	Hausarzt_Titel	\N
242836	104757	Beatmung_ES_G5_IEVerhältnis_Backup	\N
174104	103748	Beatmung_ES_G5_Tubuskompensation	Dokumentation der eingestellten Tubuskompensation
153881	106485	Hausarzt_Vorname	\N
56283	102135	Untersuchung_Thorax_Pulmo	\N
55075	102138	Untersuchung_Abdomen_Bauchwand	\N
52278	102129	Untersuchung_Kopf_Augen	\N
51962	102144	Untersuchung_ExtremitaetenLeiste_UntereExtremitaet	\N
51546	102136	Untersuchung_Thorax_Cor	\N
50692	102145	Untersuchung_ZNS_Bewusstsein	\N
47541	102143	Untersuchung_ExtremitaetenLeiste_ObereExtremitaet	\N
46805	105084	Beatmung_ES_G5_F_SIMV	Eingestellt SIMV Frequenz bei dem Respirator G5 in den Beatmungsmodi APVsimv, Psimv.
26045	103734	Lungenersatzverfahren_Doku_ECMOTemperatur	Eingestellter Temperaturwert an der ECMO (Gerät)
24182	102151	Untersuchung_Status_Reizbildung	\N
22354	102152	Untersuchung_Status_Makrozirkulation	\N
20365	103376	Schrittmacher_Doku_Drähte	\N
20260	103374	Schrittmacher_Doku_Modus	\N
20086	102131	Untersuchung_Kopf_Nas_Mund	\N
19715	104959	NEV_CRRT_MS_Multi_BehandlungszeitAktuell	\N
18675	102156	Untersuchung_Status_Atemform	\N
17997	102154	Untersuchung_Status_Oxygenierung	\N
17229	102153	Untersuchung_Status_Mikrozirkulation	\N
16649	103805	Hypothermie_ArticSun_Doku_Behandlungsmodi	Liste
16193	102132	Untersuchung_Kopf_Hals	\N
15662	102139	Untersuchung_Abdomen_Nieren	\N
15069	102155	Untersuchung_Status_Ventilation	\N
14300	102128	Untersuchung_Kopf_Haut	\N
13774	102148	Untersuchung_ZNS_Motorik	\N
13270	104751	Untersuchung_Kontrolle_Laufraten	Arztdoku S. 10
12167	102142	Untersuchung_ExtremitaetenLeiste_Haut	\N
11862	102134	Untersuchung_Thorax_Wand	\N
11438	102158	Untersuchung_Status_Koerpertemperatur	\N
11191	105090	Fall_Wertsachen_Wertgegenstaende	\N
11088	103735	Lungenersatzverfahren_Doku_ECMOFlushen	Dokumentation der Tätigkeit "Flushen" bei Einsatz eines ECMO Verfahrens
10716	102137	Untersuchung_Abdomen_Haut	\N
10669	102133	Untersuchung_Thorax_Haut	\N
10573	102159	Untersuchung_Status_Urin	\N
10497	108501	Fontanelle_Beurteilung	\N
10340	104952	NEV_HD_VO_Konzentrat	\N
10261	101792	Angehoerige1_Verwandschaftsgrad	\N
10205	104954	NEV_HD_VO_Filter	\N
10187	104949	NEV_HD_VO_SpüllösungAntikoag	\N
10163	104955	NEV_HD_VO_Zugang	\N
10120	104948	NEV_HD_VO_FuellenMit	\N
10084	101462	Angehoerige1_TelefonMobil	Handy Nummer der Angehörigen des Patienten
9767	102146	Untersuchung_ZNS_Reflexe	\N
8781	104958	NEV_CRRT_Doku_AbschlussBegruendung	\N
8715	104914	NEV_HD_Doku_SpüllösungAntikoag	\N
8468	105096	Fall_Wertsachen_Kleidungsstuecke	\N
8259	104951	NEV_HD_VO_Antikoagulation	\N
8220	105017	Schrittmacher_Osypka101H_ES_Betriebsart	Listenauswahl
7867	104912	NEV_HD_Doku_FuellenMit	\N
7774	104981	NEV_CRRT_Doku_Fuellen_Mit	\N
7674	104957	NEV_CRRT_Doku_AbschlussUrteil	\N
7350	104857	NEV_HD_Doku_Abschlussbeurteilung	\N
7248	105100	Fall_Wertsachen_Wertgegenstaende_Ort	\N
7160	104947	NEV_HD_VO_4008HS_Dialysezeit	\N
6883	104894	NEV_HD_ES_4008HS_Dialysezeit	\N
6621	101416	Lungenersatzverfahren_Doku_ECMOAntikoagulation	\N
6599	105031	Schrittmacher_Osypka203H_ES_Betriebsart	Liste
6436	104856	NEV_HD_Doku_Abschlussbegründung	\N
6364	102157	Untersuchung_Status_Wasserhaushalt	\N
6298	102140	Untersuchung_Abdomen_Leber	\N
6261	102149	Untersuchung_ZNS_Sensibilitaet	\N
6238	104950	NEV_HD_VO_Bolus	\N
6160	105092	Fall_Wertsachen_Prothese	\N
6137	103117	Nierenverfahren_Doku_AbschlussBeurteilung	\N
5904	103118	Nierenverfahren_Doku_Abschlussbegruendung	\N
5901	105094	Fall_Wertsachen_Pflegeuntensilien	\N
5744	103115	Nierenverfahren_Doku_FüllenMit	Füllen des Systems
5675	104869	NEV_HD_MS_4008HS_Rest_Zeit	\N
5540	102130	Untersuchung_Kopf_Ohren	\N
5295	104982	NEV_CRRT_Doku_SpülloesungAntikoag	\N
5281	105098	Fall_Wertsachen_Papiere	\N
5207	103097	Nierenverfahren_Doku_SpuellösungAntikoagulanz	Spülung zur Vorbereitung
5130	105034	Schrittmacher_Osypka203H_ES_V-Sense	\N
5072	102928	Nierenverfahren_VO_Filter	Filter  für extrakorporale Verfahren
5007	102927	Nierenverfahren_VO_Zugang	VO Gefäßzugang extracorporale Verfahren
4906	102147	Untersuchung_ZNS_Hirnnerven	\N
4826	105097	Fall_Wertsachen_Kleidungsstuecke_Ort	\N
4715	102933	Nierenverfahren_VO_SpülloesungAntikoagulanz	Spüllösung zum Vorbereiten des extrakorporalen Verfahrens
4619	101328	Patient_Pseudonym	\N
4581	104911	NEV_HD_Doku_Bolusgabe	\N
4462	102934	Nierenverfahren_VO_FüllenMit	Liste hinterlegt mit Lösungen zum Befüllen des Systems vor Anschluss
4201	104354	IABP_DatascopeCS300_ES_IABP_Frequenz	Dokumentation der IABP Frequenz.
3904	102160	Untersuchung_Status_Stuhl	\N
3901	103250	Nierenverfahren_VO_Dialysekonzentrat	Dialyskonzentratbehälter
3863	106506	Angehoerige2_Verwandtschaftsgrad	\N
3839	104355	IABP_DatascopeCS300_ES_Triggerauswahl_EKG_RR_Pacer	Dokumentation des ausgewählten Triggers der IABP.
3784	102932	Nierenverfahren_VO_Antikoagulanz	Antikoagulation Medikament
3733	104353	IABP_DatascopeCS300_ES_EKG_Ableitung	Dokumentation der gewählten EG Ableitung für den IABP Einsatz.
3724	102141	Untersuchung_Abdomen_Gallenblase	\N
3719	102150	Untersuchung_ZNS_Vegetativum	\N
3714	108728	P_Impella_Impella_ES_Leistungsstufe	\N
3520	105012	NEV_CRRT_VO_Zugang	\N
3461	105011	NEV_CRRT_VO_Filter	\N
3456	103375	Schrittmacher_Doku_Art	\N
3428	103339	IABP_Doku_Ballonkatheter	Kathetertyp
3247	106505	Angehoerige2_Name	\N
3115	105002	NEV_CRRT_VO_Fuellen_Mit	\N
3076	106472	IABP_CARDIOSAVE_ES_IABP_Frequenz	Dokumentation der IABP Frequenz
3068	106498	Angehoerige2_TelefonMobil	\N
3067	105095	Fall_Wertsachen_Prothese_Ort	\N
3064	105009	NEV_CRRT_VO_Dialysatloesung	\N
3014	105033	Schrittmacher_Osypka203H_ES_A-Sense	\N
2980	100031	Betreuer_Name	Betreuer des Patienten
2943	103622	Lungenersatzverfahren_Doku_Zugang	Gefäßzugang
2938	106470	IABP_CARDIOSAVE_ES_EKG_Ableitung	Dokumentation der gewählten EKG Ableitung für den IABP Einsatz
2896	105003	NEV_CRRT_VO_SpülloesungAntikoag	\N
2867	106473	IABP_CARDIOSAVE_ES_Triggerauswahl_EKG_RR_Pacer	Dokumentation des ausgewählten Triggers der IABP
2759	105093	Fall_Wertsachen_Pflegeuntensilien_Ort	\N
2638	110802	P_NEV_HD_ES_5008onl_Dialyse_Zeit	\N
2633	110818	P_NEV_HD_VO_5008onl_Dialyse_Zeit	\N
2581	103744	Hypothermie_Doku_Kuehlverfahren	Listenauswahl
2578	103623	Lungenersatzverfahren_Doku_Schlauchsystem	Schlauchsystembeschichtung relevant
2573	106504	Angehoerige2_Vorname	\N
2526	103829	Waermesysteme_Warmtouch_Doku_Temperatur	Liste
2497	103135	Nierenverfahren_VO_Bolus	Medikament
2475	101791	Betreuer_Status	\N
2462	103745	Nierenverfahren_ES_BM25_Temperaturstufe	Liste
2458	105007	NEV_CRRT_VO_CitratLoesung	\N
2442	105006	NEV_CRRT_VO_CalciumLoesung	\N
2433	100029	Betreuer_Telefon	Telefonummer des Patientenbetreuers
2420	106325	CardioHelpMaquet_DOKU_Antikoagulation	\N
2404	103630	Lungenerstazverfahren_Doku_ECMO_Oxygenator	Gerätetyp
2342	105099	Fall_Wertsachen_Papiere_Ort	\N
2331	104351	IABP_DatascopeCS300_ES_Doku_Ballonkatheter	Dokumentation des verwendeten Ballonkatheters.
2304	105005	NEV_CRRT_VO_Antikoagulation	\N
2128	101482	Beatmung_Einstellung_Anfeuchtung	\N
2122	101766	Betreuer_Vorname	\N
2071	103136	Nierenverfahren_Doku_Bolus	Medikament
2058	103336	Nierenverfahren_ES_GeräteDesinfektion	Desinfektionsprogramme Gerät 
2037	103828	Waermesysteme_Warmtouch_Doku_Geblaese	Liste
1972	103718	IABP_DatascopeCS100_ES_IABPFrequenz	\N
1972	106499	Angehoerige2_Telefon	\N
1963	105050	NEV_CRRT_VO_Multi_Temp	Neuanlage 18.05.2012 String
1805	106517	Waermesysteme_BairHugger_Doku_Temperatur	Liste
1750	103717	IABP_DatascopeCS100_ES_Triggerauswahl	\N
1698	106406	Hypothermie_ArticSun_MS_Flussrate	\N
1691	101771	Betreuer_TelefonMobil	\N
1519	105081	Beatmung_ES_C2_F_SIMV	Eingestellt SIMV Frequenz bei dne Respiratoren C2 5 in den Beatmungsmodi APVsimv, Psimv.
1499	103721	IABP_DatascopeCS100_ES_EKGAbleitung	\N
1476	101463	Angehoerige1_TelefonArbeit	Berufliche Telefonnummer der Angehörigen des Patienten
1451	110886	P_Patient_Gewicht_WaageBezeichnung	Die Nummer der Waage, mit der das Gewicht ermittelt wurde.
1429	105052	NEV_Apherese_ES_Multi_Temp	Anlage 18.05.2012
1393	106496	Angehoerige3_Verwandtschaftsgrad	\N
1342	106518	Waermesysteme_BairHugger_Doku_Geblaese	Liste
1331	107989	P_Beatmung_ES_C3_F_SIMV	Eingestellte SIMV Frequenz
1231	101404	Nierenersatzverfahren_Dokumentation_Antikoagulatio	\N
1209	106326	CardioHelpMaquet_DOKU_Flushen	\N
1203	101406	Nierenersatzverfahren_Dokumentation_HFLoesung	\N
1128	101773	Patient_Verfügung	\N
1125	102504	Nierenersatzverfahren_Dokumentation_Abschluss	\N
1116	106495	Angehoerige3_Name	\N
1075	106489	Angehoerige3_TelefonMobil	\N
1062	103572	IABP_Datascope_ES_IABPFrequenz	LIste
1039	103624	Lungenersatzverfahren_Doku_Kathetertyp	Kathetertyp
1004	102201	HZV_VigilanceCGeraet	\N
\.


--
-- Data for Name: mapping_mii_co6; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.mapping_mii_co6 (profile_id, profile_name, category_coding_system, category_coding_code, code_coding_system_snomed, code_coding_code_snomed, code_coding_system_loinc, code_coding_code_loinc, code_coding_system_ieee, code_coding_code_ieee, valuequantity_system, valuequantity_code, conf_var_unit, device_reference, meta_profile, conf_var_id, conf_var_parent_id, conf_var_parent_name, conf_var_name, conf_var_description, conf_var_types_id, conf_var_types_name, code_systolic_coding_system_snomed, code_systolic_coding_code_snomed, code_systolic_coding_system_loinc, code_systolic_coding_code_loinc, code_systolic_coding_system_ieee, code_systolic_coding_code_ieee, code_mean_coding_system_snomed, code_mean_coding_code_snomed, code_mean_coding_system_loinc, code_mean_coding_code_loinc, code_mean_coding_system_ieee, code_mean_coding_code_ieee, code_diastolic_coding_system_snomed, code_diastolic_coding_code_snomed, code_diastolic_coding_system_loinc, code_diastolic_coding_code_loinc, code_diastolic_coding_system_ieee, code_diastolic_coding_code_ieee, matching_valide) FROM stdin;
1	Arterieller Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	386534000	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Arterieller-Druck	100093	1	Patient	ABP_1	arterieller Blutdruck 1	12	Medic_Pressure	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
1	Arterieller Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	386534000	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Arterieller-Druck	100089	1	Patient	ABP_2	zweiter arterieller Blutdruck	12	Medic_Pressure	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
2	Atemfrequenz	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	86290005	https://loinc.org/9279-1/	9279-1	\N	\N	http://unitsofmeasure.org	/min	1/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Atemfrequenz	1267	1	Patient	AF	Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
3	Atemzugvolumen-Waehrend-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	250874002	http://loinc.org	76222-9	urn:iso:std:iso:11073:10101	151980	http://unitsofmeasure.org	mL	ml	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Atemzugvolumen-Waehrend-Beatmung	104726	1	Patient	Beatmung_MS_Pallas_Vt	Gemessenes Tidalvolumen.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
4	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	426102006	http://loinc.org	76009-0	urn:iso:std:iso:11073:10101	152004	http://unitsofmeasure.org	L/min	L/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/SBeatmungsvolumen-Pro-Minute-Machineller-Beatmung	100098	1	Patient	Beatmung_Messung_MV	Mindest Volumen tot.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
4	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	426102006	http://loinc.org	76009-0	urn:iso:std:iso:11073:10101	152004	http://unitsofmeasure.org	L/min	L/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/SBeatmungsvolumen-Pro-Minute-Machineller-Beatmung	104725	1	Patient	Beatmung_MS_Pallas_MV	Gemessenes Atemminutenvolumen.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
4	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	426102006	http://loinc.org	76009-0	urn:iso:std:iso:11073:10101	152004	http://unitsofmeasure.org	L/min	L/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/SBeatmungsvolumen-Pro-Minute-Machineller-Beatmung	103320	1	Patient	Beatmung_MS_Evita4_MV	gemessenes Atemminutenvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
5	Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck	106468	1	Patient	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t
5	Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck	100094	1	Patient	NBP_1	nichtinvasiver Blutdruck 1	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t
5	Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck	104356	1	Patient	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t
6	Blutdruck Generisch	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck-Generisch	104356	1	Patient	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t
6	Blutdruck Generisch	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck-Generisch	106468	1	Patient	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t
6	Blutdruck Generisch	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck-Generisch	100094	1	Patient	NBP_1	nichtinvasiver Blutdruck 1	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t
7	Blutfluss durch cardiovasculäres Gerät	http://snomed.info/sct	182744004	http://snomed.info/sct	444479000	\N	\N	\N	\N	http://unitsofmeasure.org	L/min	L/Min	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutfluss-Cardiovasculaeres-Geraet	106332	1	Patient	CardioHelpMaquet_MS_Blutfluss	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
8	Druckdifferenz Beatmung	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76154-4	urn:iso:std:iso:11073:10101	152720	http://unitsofmeasure.org	cm[H2O]	cm H2O	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Druckdifferenz-Beatmung	103078	1	Patient	Beatmung_MS_VisionA_Amplitude	gemessene Druckdifferenz im HFOV Modus	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
9	Einstellung-Einatmungszeit-Beatmung	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76334-2	urn:iso:std:iso:11073:10101	16929632	http://unitsofmeasure.org	s	s	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Einstellung-Einatmungszeit-Beatmung	103297	1	Patient	Beatmung_ES_Evita4_Tinsp	eingestellte absolute Inspirationszeit	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
9	Einstellung-Einatmungszeit-Beatmung	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76334-2	urn:iso:std:iso:11073:10101	16929632	http://unitsofmeasure.org	s	s	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Einstellung-Einatmungszeit-Beatmung	102887	1	Patient	Beatmung_ES_G5_Ti	Einstelungswert für die Inspirationszeit	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
10	Exspiratorischer Gasfluss	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	60792-9	urn:iso:std:iso:11073:10101	151944	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Exspiratorischer-Gasfluss	102915	1	Patient	Beatmung_MS_G5_ExspFlow	Exspiratorischer Peakflow, ein Monitoring-Parameter	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
11	Exspiratorischer Sauerstoffpartialdruck	http://snomed.info/sct	40617009	http://snomed.info/sct	250775008	http://loinc.org	3147-6	urn:iso:std:iso:11073:10101	153132	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Exspiratorischer-Sauerstoffpartialdruck	103817	1	Patient	PtiO2Druck	Gemessener Sauerstoffpartialdruck im Parenchym	12	Medic_Pressure	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
12	Herzfrequenz	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	364075005	http://loinc.org	8867-4	\N	\N	http://unitsofmeasure.org	/min	1/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzfrequenz	1266	1	Patient	HF	Herzfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
13	Herzzeitvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	82799009	http://loinc.org	8741-1	urn:iso:std:iso:11073:10101	150276	http://unitsofmeasure.org	L/min	L/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzzeitvolumen	102051	1	Patient	HZV	Herzzeitvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
13	Herzzeitvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	82799009	http://loinc.org	8741-1	urn:iso:std:iso:11073:10101	150276	http://unitsofmeasure.org	L/min	L/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzzeitvolumen	102184	1	Patient	VigilanceC_HZV	Herzzeitvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
14	Inspiratorischer Gasfluss	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76275-7	urn:iso:std:iso:11073:10101	151948	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Eingestellter-Inspiratorischer-Gasfluss	102903	1	Patient	Beatmung_MS_G5_InspFlow	Inspiratorischer Peakflow, ein Monitoring-Parameter	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
15	Intrakranieller Druck (ICP)	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	250844005	http://loinc.org	60956-0	urn:iso:std:iso:11073:10101	153608	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Intrakranieller-Druck-ICP	100088	1	Patient	ICP	Intrakranialer Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
16	Ionisiertes Kalzium aus Nierenersatzverfahren	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	83064-6	\N	\N	http://unitsofmeasure.org	mmol/L	mmol/l	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Ionisiertes-Kalzium-Nierenersatzverfahren	103058	1	Patient	Nierenverfahren_ES_Multi_CalciumFiltrat	Calciumrate	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
16	Ionisiertes Kalzium aus Nierenersatzverfahren	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	83064-6	\N	\N	http://unitsofmeasure.org	mmol/L	\N	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Ionisiertes-Kalzium-Nierenersatzverfahren	105006	1	Patient	NEV_CRRT_VO_CalciumLoesung	\N	3	String	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
16	Ionisiertes Kalzium aus Nierenersatzverfahren	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	83064-6	\N	\N	http://unitsofmeasure.org	mmol/L	mmol/L	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Ionisiertes-Kalzium-Nierenersatzverfahren	104974	1	Patient	NEV_CRRT_ES_Multi_CalciumFiltrat	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
17	Koerpergewicht	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	27113001	http://loinc.org	29463-7	\N	\N	http://unitsofmeasure.org	kg	kg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpergewicht	6	1	Patient	Patient_Gewicht	Gewicht des Patienten	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
17	Koerpergewicht	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	27113001	http://loinc.org	29463-7	\N	\N	http://unitsofmeasure.org	kg	kg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpergewicht	101322	20	Fall	Patient_AufnGewicht	Aufnahmegewicht (fallbezogen)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
18	Koerpergroesse	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	1153637007	http://loinc.org	8302-2	\N	\N	http://unitsofmeasure.org	cm	cm	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpergroesse	7	1	Patient	Patient_Groesse	Größe des Patienten	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
19	Koerpertemperatur Kern	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	276885007	http://loinc.org	8329-5	urn:iso:std:iso:11073:10101	150368	http://unitsofmeasure.org	Cel	°C	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpertemperatur-Kern	110933	1	Patient	P_Temperatur_Kern	Anlage für Philips Monitoring	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
20	Kopfumfang	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	\N	\N	http://loinc.org	9843-4	\N	\N	http://unitsofmeasure.org	cm	cm	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Kopfumfang	11	1	Patient	COPRA_Patient_Kopfumfang	Kopfumfang des Patienten in Zentimetern	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
21	Linksatrialer Druck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksatrialer-Druck	100091	1	Patient	LAP	Linksatrial  Mitteldruck	6	Decimal_6_3	\N	\N	http://loinc.org	60989-1	urn:iso:std:iso:11073:10101	150065	\N	\N	http://loinc.org	8399-8	urn:iso:std:iso:11073:10101	150067	\N	\N	http://loinc.org	75933-2	urn:iso:std:iso:11073:10101	150066	t
22	Linksventrikulaerer Schlagvolumenindex	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	277381004	http://loinc.org	76297-1	urn:iso:std:iso:11073:10101	149764	http://unitsofmeasure.org	mL/m2	ml/m2	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaerer-Schlagvolumenindex	102036	1	Patient	p-SVI	Schlagvolumenindex  (PICCO Modul Dräger Monitoring)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
22	Linksventrikulaerer Schlagvolumenindex	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	277381004	http://loinc.org	76297-1	urn:iso:std:iso:11073:10101	149764	http://unitsofmeasure.org	mL/m2	ml/b/m²ml/b/m²	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaerer-Schlagvolumenindex	102179	1	Patient	Vigileo_SVI	SchlagvolumenindexSchlagvolumenindex	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	1/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	101442	1	Patient	Beatmung_Messung_AF	Breathing Frequency	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	1/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	104727	1	Patient	Beatmung_MS_Pallas_Frequenz	Gemessene Atemfrequenz.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	1/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	100108	1	Patient	Beatmung_Einstellung_AF	Beatmungsfrequenz (f/AF)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	AZ/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	103035	1	Patient	Beatmung_MS_G5_ftotal	Gesamtatemfrequenz, ein Monitoring Parameter	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	bpm	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	103323	1	Patient	Beatmung_MS_Evita4_frequenz	gemessene Gesamtatemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
24	Mittlerer Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76530-5	urn:iso:std:iso:11073:10101	151975	http://unitsofmeasure.org	cm[H2O]	cm H2O	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mittlerer-Beatmungsdruck	102873	1	Patient	Beatmung_ES_VisionA_MAP	Mittlerer Atemwegsdruck (MAP)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
24	Mittlerer Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76530-5	urn:iso:std:iso:11073:10101	151975	http://unitsofmeasure.org	cm[H2O]	cm H2O	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mittlerer-Beatmungsdruck	102878	1	Patient	Beatmung_MS_VisionA_MAP	gemessener Mittlerer Atemwegsdruck unter HFO bei Alpha Vision	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
24	Mittlerer Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76530-5	urn:iso:std:iso:11073:10101	151975	http://unitsofmeasure.org	cm[H2O]	[cmH2O]	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mittlerer-Beatmungsdruck	104249	1	Patient	Beatmung_MS_Servoi_Pmean	Mittlerer Atemwegsdruck 	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	[cmH2O]	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	104264	1	Patient	Beatmung_ES_Servoi_PEEP	PEEP 	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	100102	1	Patient	Beatmung_Einstellung_PEEP	Positiver endexspiratorischer Druck (PEEP)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	103943	1	Patient	Beatmung_ES_Heimbeatmung_Peep	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	100275	1	Patient	Beatmung_Messung_PEEP	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	104722	1	Patient	Beatmung_MS_Pallas_PEEP	Dokumentation des gemessenen PEEPs.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	101444	1	Patient	Beatmung_Messung_IntrinsicPEEP	Intrinsic PEEP	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	103318	1	Patient	Beatmung_MS_Evita4_PEEP	gemessener positiver endexspiratorischer Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
26	Pulmonalarterieller Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Pulmonalarterieller-Blutdruck	102050	1	Patient	PAP	Pulmunalarterieller Druck	12	Medic_Pressure	\N	\N	http://loinc.org	8440-0	urn:iso:std:iso:11073:10101	150045	\N	\N	http://loinc.org	8414-5	urn:iso:std:iso:11073:10101	150047	\N	\N	http://loinc.org	8385-7	urn:iso:std:iso:11073:10101	150046	t
27	Pulmonalarterieller wedge Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	118433006	http://loinc.org	75994-4	urn:iso:std:iso:11073:10101	150052	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Pulmonalarterieller-Wedge-Druck	102018	1	Patient	PWP	Pulmunaler Wedgedruck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	104730	1	Patient	Beatmung_MS_Pallas_O2_insp	Gemessene inspiratorische O2 Konzentration.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	Vol%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103314	1	Patient	Beatmung_MS_Evita4_FiO2	gemessene O2 Konzentration des inspiratorischen Atemgasgemisches	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103216	1	Patient	Beatmung_MS_3100B_O2Konzentration	Messwert: gemessene O2 Konzentration des Gasgemisches	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	100100	1	Patient	Beatmung_Messung_FiO2	FiO2	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
29	Sauerstofffraktion eingestellt	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	%	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	100105	1	Patient	Beatmung_Einstellung_FiO2	O²- Konzentration im Inspirationsgemisch (FiO2)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
29	Sauerstofffraktion eingestellt	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	%	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103296	1	Patient	Beatmung_ES_Evita4_O2Konzentration	eingestellte O2 Konzentration des Frischgases	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
29	Sauerstofffraktion eingestellt	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	%	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103214	1	Patient	Beatmung_ES_3100B_O2Konzentration	Einstellwert: O2 Konzentration des Gasgemisches	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
30	Sauerstoffgasfluss	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	19941-4	\N	\N	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffgasfluss	103091	1	Patient	Beatmung_ES_CF800_SauerstoffFlow	Einstellgröße Gasfluss Sauerstoff	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
30	Sauerstoffgasfluss	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	19941-4	\N	\N	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffgasfluss	106784	1	Patient	Beatmung_ES_Optiflow_O2Flow	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
31	Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	\N	\N	http://loinc.org	59408-5	urn:iso:std:iso:11073:10101	150456	http://unitsofmeasure.org	%	%	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffsaettigung-Im-Arteriellen-Blut-Per-Pulsoxymetrie	102010	1	Patient	SpO2	Sauerstoffsättigung Pulsoxymetrie	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
32	Spontane-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19839-0	urn:iso:std:iso:11073:10101	152498	http://unitsofmeasure.org	/min	bpm	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Atemfrequenz-Beatmet	103324	1	Patient	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
32	Spontane-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19839-0	urn:iso:std:iso:11073:10101	152498	http://unitsofmeasure.org	/min	AZ/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Atemfrequenz-Beatmet	103036	1	Patient	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
32	Spontane-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19839-0	urn:iso:std:iso:11073:10101	152498	http://unitsofmeasure.org	/min	1/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Atemfrequenz-Beatmet	100270	1	Patient	Beatmung_Messung_AFSpontan	Respiratory Rate (spontan)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
33	Spontane-Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19840-8	urn:iso:std:iso:11073:10101	152490	http://unitsofmeasure.org	/min	bpm	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Mechanische-Atemfrequenz-Beatmet	103324	1	Patient	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
33	Spontane-Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19840-8	urn:iso:std:iso:11073:10101	152490	http://unitsofmeasure.org	/min	AZ/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Mechanische-Atemfrequenz-Beatmet	103036	1	Patient	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
34	Substituatfluss	http://snomed.info/sct	182744004	http://snomed.info/sct	708513005	\N	\N	\N	\N	http://unitsofmeasure.org	mL/h	mL/h	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Substituatfluss	102978	1	Patient	Nierenverfahren_ES_Multi_Substituat	Umsatz, Austausch Substituat ml/h	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
34	Substituatfluss	http://snomed.info/sct	182744004	http://snomed.info/sct	708513005	\N	\N	\N	\N	http://unitsofmeasure.org	mL/h	mL/h	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Substituatfluss	102992	1	Patient	Nierenverfahren_ES_BM25_Umsatz	Austausch, Substituat, ml/h	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
35	Venöser Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	252076005	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Venoeser-Druck	103011	1	Patient	Nierenverfahren_MS_Multi_venDruck	venöser Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
36	Zeitverhaeltnis-Ein-Ausatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	250822000	http://loinc.org	75931-6	urn:iso:std:iso:11073:10101	151832	http://unitsofmeasure.org	{ratio}	\N	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Zeitverhaeltnis-Ein-Ausatmung	102926	1	Patient	Beatmung_MS_G5_IEVerhaeltnis	gemessenes I:E Verhältnis	3	String	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
37	Zentralvenoeser Druck (ZVD)	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	71420008	http://loinc.org	60985-9	urn:iso:std:iso:11073:10101	150084	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Zentralvenoeser-Blutdruck	1269	1	Patient	ZVD	Zentralvenöser Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	104758	1	Patient	Schlagvolumen	gemessenes Schlagvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	102030	1	Patient	SV	Schlagvolumen 	3	String	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	102408	1	Patient	p-SV	Schlagvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	102874	1	Patient	Beatmung_ES_VisionA_Schlagvolumen	Schlagvolumen (SV) in engl. (cycle volume)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
40	Linksventrikulaerer Herzindex	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	54993008	http://loinc.org	75919-1	urn:iso:std:iso:11073:10101	149772	http://unitsofmeasure.org	L/(min.m2)	mmHg/s	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaerer-Herzindex	102039	1	Patient	dPmax	Index der linken Ventrikelkontraktilität  	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
41	Maximaler Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76531-3	urn:iso:std:iso:11073:10101	151973	http://unitsofmeasure.org	cm[H2O]	mmHg	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Maximaler-Beatmungsdruck	100300	1	Patient	Beatmung_Messung_Pmax	Peak Airway Pressure	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
1	Arterieller Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	386534000	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Arterieller-Druck	103010	1	Patient	Nierenverfahren_MS_Multi_artDruck	arterieller Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
38	Dauer Haemodialysesitzung	http://snomed.info/sct	182744004	http://snomed.info/sct	445940005	\N	\N	\N	\N	http://unitsofmeasure.org	h	min	DeviceMetric/Example_Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Dauer-Haemodialysesitzung	110772	1	Patient	P_NEV_HD_MS_5008onl_Rest_Zeit_min	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t
\.


--
-- Data for Name: mapping_mii_co6_2; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.mapping_mii_co6_2 (profile_id, profile_name, category_coding_system, category_coding_code, code_coding_system_snomed, code_coding_code_snomed, code_coding_system_loinc, code_coding_code_loinc, code_coding_system_ieee, code_coding_code_ieee, valuequantity_system, valuequantity_code, conf_var_unit, device_reference, meta_profile, conf_var_id, conf_var_parent_id, conf_var_parent_name, conf_var_name, conf_var_description, conf_var_types_id, conf_var_types_name, code_systolic_coding_system_snomed, code_systolic_coding_code_snomed, code_systolic_coding_system_loinc, code_systolic_coding_code_loinc, code_systolic_coding_system_ieee, code_systolic_coding_code_ieee, code_mean_coding_system_snomed, code_mean_coding_code_snomed, code_mean_coding_system_loinc, code_mean_coding_code_loinc, code_mean_coding_system_ieee, code_mean_coding_code_ieee, code_diastolic_coding_system_snomed, code_diastolic_coding_code_snomed, code_diastolic_coding_system_loinc, code_diastolic_coding_code_loinc, code_diastolic_coding_system_ieee, code_diastolic_coding_code_ieee, matching_valide, unit_transform) FROM stdin;
1	Arterieller Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	386534000	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Arterieller-Druck	100089	1	Patient	ABP_2	zweiter arterieller Blutdruck	12	Medic_Pressure	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
1	Arterieller Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	386534000	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Arterieller-Druck	103010	1	Patient	Nierenverfahren_MS_Multi_artDruck	arterieller Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
1	Arterieller Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	386534000	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Arterieller-Druck	100093	1	Patient	ABP_1	arterieller Blutdruck 1	12	Medic_Pressure	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
2	Atemfrequenz	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	86290005	https://loinc.org/9279-1/	9279-1	\N	\N	http://unitsofmeasure.org	/min	1/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Atemfrequenz	1267	1	Patient	AF	Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
3	Atemzugvolumen-Waehrend-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	250874002	http://loinc.org	76222-9	urn:iso:std:iso:11073:10101	151980	http://unitsofmeasure.org	mL	ml	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Atemzugvolumen-Waehrend-Beatmung	104726	1	Patient	Beatmung_MS_Pallas_Vt	Gemessenes Tidalvolumen.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
4	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	426102006	http://loinc.org	76009-0	urn:iso:std:iso:11073:10101	152004	http://unitsofmeasure.org	L/min	L/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/SBeatmungsvolumen-Pro-Minute-Machineller-Beatmung	103320	1	Patient	Beatmung_MS_Evita4_MV	gemessenes Atemminutenvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
4	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	426102006	http://loinc.org	76009-0	urn:iso:std:iso:11073:10101	152004	http://unitsofmeasure.org	L/min	L/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/SBeatmungsvolumen-Pro-Minute-Machineller-Beatmung	100098	1	Patient	Beatmung_Messung_MV	Mindest Volumen tot.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
4	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	426102006	http://loinc.org	76009-0	urn:iso:std:iso:11073:10101	152004	http://unitsofmeasure.org	L/min	L/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/SBeatmungsvolumen-Pro-Minute-Machineller-Beatmung	104725	1	Patient	Beatmung_MS_Pallas_MV	Gemessenes Atemminutenvolumen.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
5	Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck	100094	1	Patient	NBP_1	nichtinvasiver Blutdruck 1	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1
5	Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck	104356	1	Patient	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1
5	Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck	106468	1	Patient	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1
6	Blutdruck Generisch	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck-Generisch	106468	1	Patient	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1
6	Blutdruck Generisch	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck-Generisch	100094	1	Patient	NBP_1	nichtinvasiver Blutdruck 1	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1
6	Blutdruck Generisch	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck-Generisch	104356	1	Patient	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1
7	Blutfluss durch cardiovasculäres Gerät	http://snomed.info/sct	182744004	http://snomed.info/sct	444479000	\N	\N	\N	\N	http://unitsofmeasure.org	L/min	L/Min	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutfluss-Cardiovasculaeres-Geraet	106332	1	Patient	CardioHelpMaquet_MS_Blutfluss	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
8	Druckdifferenz Beatmung	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76154-4	urn:iso:std:iso:11073:10101	152720	http://unitsofmeasure.org	cm[H2O]	cm H2O	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Druckdifferenz-Beatmung	103078	1	Patient	Beatmung_MS_VisionA_Amplitude	gemessene Druckdifferenz im HFOV Modus	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
9	Einstellung-Einatmungszeit-Beatmung	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76334-2	urn:iso:std:iso:11073:10101	16929632	http://unitsofmeasure.org	s	s	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Einstellung-Einatmungszeit-Beatmung	103297	1	Patient	Beatmung_ES_Evita4_Tinsp	eingestellte absolute Inspirationszeit	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
9	Einstellung-Einatmungszeit-Beatmung	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76334-2	urn:iso:std:iso:11073:10101	16929632	http://unitsofmeasure.org	s	s	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Einstellung-Einatmungszeit-Beatmung	102887	1	Patient	Beatmung_ES_G5_Ti	Einstelungswert für die Inspirationszeit	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
10	Exspiratorischer Gasfluss	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	60792-9	urn:iso:std:iso:11073:10101	151944	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Exspiratorischer-Gasfluss	102915	1	Patient	Beatmung_MS_G5_ExspFlow	Exspiratorischer Peakflow, ein Monitoring-Parameter	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
11	Exspiratorischer Sauerstoffpartialdruck	http://snomed.info/sct	40617009	http://snomed.info/sct	250775008	http://loinc.org	3147-6	urn:iso:std:iso:11073:10101	153132	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Exspiratorischer-Sauerstoffpartialdruck	103817	1	Patient	PtiO2Druck	Gemessener Sauerstoffpartialdruck im Parenchym	12	Medic_Pressure	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
12	Herzfrequenz	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	364075005	http://loinc.org	8867-4	\N	\N	http://unitsofmeasure.org	/min	1/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzfrequenz	1266	1	Patient	HF	Herzfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
13	Herzzeitvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	82799009	http://loinc.org	8741-1	urn:iso:std:iso:11073:10101	150276	http://unitsofmeasure.org	L/min	L/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzzeitvolumen	102184	1	Patient	VigilanceC_HZV	Herzzeitvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
13	Herzzeitvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	82799009	http://loinc.org	8741-1	urn:iso:std:iso:11073:10101	150276	http://unitsofmeasure.org	L/min	L/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzzeitvolumen	102051	1	Patient	HZV	Herzzeitvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
14	Inspiratorischer Gasfluss	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76275-7	urn:iso:std:iso:11073:10101	151948	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Eingestellter-Inspiratorischer-Gasfluss	102903	1	Patient	Beatmung_MS_G5_InspFlow	Inspiratorischer Peakflow, ein Monitoring-Parameter	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
15	Intrakranieller Druck (ICP)	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	250844005	http://loinc.org	60956-0	urn:iso:std:iso:11073:10101	153608	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Intrakranieller-Druck-ICP	100088	1	Patient	ICP	Intrakranialer Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
16	Ionisiertes Kalzium aus Nierenersatzverfahren	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	83064-6	\N	\N	http://unitsofmeasure.org	mmol/L	mmol/l	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Ionisiertes-Kalzium-Nierenersatzverfahren	103058	1	Patient	Nierenverfahren_ES_Multi_CalciumFiltrat	Calciumrate	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
16	Ionisiertes Kalzium aus Nierenersatzverfahren	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	83064-6	\N	\N	http://unitsofmeasure.org	mmol/L	mmol/L	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Ionisiertes-Kalzium-Nierenersatzverfahren	104974	1	Patient	NEV_CRRT_ES_Multi_CalciumFiltrat	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
17	Koerpergewicht	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	27113001	http://loinc.org	29463-7	\N	\N	http://unitsofmeasure.org	kg	kg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpergewicht	6	1	Patient	Patient_Gewicht	Gewicht des Patienten	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
17	Koerpergewicht	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	27113001	http://loinc.org	29463-7	\N	\N	http://unitsofmeasure.org	kg	kg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpergewicht	101322	20	Fall	Patient_AufnGewicht	Aufnahmegewicht (fallbezogen)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
18	Koerpergroesse	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	1153637007	http://loinc.org	8302-2	\N	\N	http://unitsofmeasure.org	cm	cm	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpergroesse	7	1	Patient	Patient_Groesse	Größe des Patienten	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
19	Koerpertemperatur Kern	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	276885007	http://loinc.org	8329-5	urn:iso:std:iso:11073:10101	150368	http://unitsofmeasure.org	Cel	°C	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpertemperatur-Kern	110933	1	Patient	P_Temperatur_Kern	Anlage für Philips Monitoring	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
20	Kopfumfang	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	\N	\N	http://loinc.org	9843-4	\N	\N	http://unitsofmeasure.org	cm	cm	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Kopfumfang	11	1	Patient	COPRA_Patient_Kopfumfang	Kopfumfang des Patienten in Zentimetern	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
21	Linksatrialer Druck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksatrialer-Druck	100091	1	Patient	LAP	Linksatrial  Mitteldruck	6	Decimal_6_3	\N	\N	http://loinc.org	60989-1	urn:iso:std:iso:11073:10101	150065	\N	\N	http://loinc.org	8399-8	urn:iso:std:iso:11073:10101	150067	\N	\N	http://loinc.org	75933-2	urn:iso:std:iso:11073:10101	150066	t	1
22	Linksventrikulaerer Schlagvolumenindex	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	277381004	http://loinc.org	76297-1	urn:iso:std:iso:11073:10101	149764	http://unitsofmeasure.org	mL/m2	ml/m2	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaerer-Schlagvolumenindex	102036	1	Patient	p-SVI	Schlagvolumenindex  (PICCO Modul Dräger Monitoring)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	1/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	101442	1	Patient	Beatmung_Messung_AF	Breathing Frequency	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	1/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	104727	1	Patient	Beatmung_MS_Pallas_Frequenz	Gemessene Atemfrequenz.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	1/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	100108	1	Patient	Beatmung_Einstellung_AF	Beatmungsfrequenz (f/AF)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	AZ/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	103035	1	Patient	Beatmung_MS_G5_ftotal	Gesamtatemfrequenz, ein Monitoring Parameter	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	bpm	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	103323	1	Patient	Beatmung_MS_Evita4_frequenz	gemessene Gesamtatemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
24	Mittlerer Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76530-5	urn:iso:std:iso:11073:10101	151975	http://unitsofmeasure.org	cm[H2O]	cm H2O	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mittlerer-Beatmungsdruck	102873	1	Patient	Beatmung_ES_VisionA_MAP	Mittlerer Atemwegsdruck (MAP)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
24	Mittlerer Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76530-5	urn:iso:std:iso:11073:10101	151975	http://unitsofmeasure.org	cm[H2O]	cm H2O	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mittlerer-Beatmungsdruck	102878	1	Patient	Beatmung_MS_VisionA_MAP	gemessener Mittlerer Atemwegsdruck unter HFO bei Alpha Vision	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
24	Mittlerer Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76530-5	urn:iso:std:iso:11073:10101	151975	http://unitsofmeasure.org	cm[H2O]	[cmH2O]	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mittlerer-Beatmungsdruck	104249	1	Patient	Beatmung_MS_Servoi_Pmean	Mittlerer Atemwegsdruck 	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	[cmH2O]	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	104264	1	Patient	Beatmung_ES_Servoi_PEEP	PEEP 	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
26	Pulmonalarterieller Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Pulmonalarterieller-Blutdruck	102050	1	Patient	PAP	Pulmunalarterieller Druck	12	Medic_Pressure	\N	\N	http://loinc.org	8440-0	urn:iso:std:iso:11073:10101	150045	\N	\N	http://loinc.org	8414-5	urn:iso:std:iso:11073:10101	150047	\N	\N	http://loinc.org	8385-7	urn:iso:std:iso:11073:10101	150046	t	1
27	Pulmonalarterieller wedge Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	118433006	http://loinc.org	75994-4	urn:iso:std:iso:11073:10101	150052	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Pulmonalarterieller-Wedge-Druck	102018	1	Patient	PWP	Pulmunaler Wedgedruck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
29	Sauerstofffraktion eingestellt	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	%	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103296	1	Patient	Beatmung_ES_Evita4_O2Konzentration	eingestellte O2 Konzentration des Frischgases	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
29	Sauerstofffraktion eingestellt	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	%	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103214	1	Patient	Beatmung_ES_3100B_O2Konzentration	Einstellwert: O2 Konzentration des Gasgemisches	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
29	Sauerstofffraktion eingestellt	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	%	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	100105	1	Patient	Beatmung_Einstellung_FiO2	O²- Konzentration im Inspirationsgemisch (FiO2)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
30	Sauerstoffgasfluss	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	19941-4	\N	\N	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffgasfluss	106784	1	Patient	Beatmung_ES_Optiflow_O2Flow	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
30	Sauerstoffgasfluss	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	19941-4	\N	\N	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffgasfluss	103091	1	Patient	Beatmung_ES_CF800_SauerstoffFlow	Einstellgröße Gasfluss Sauerstoff	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
31	Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	\N	\N	http://loinc.org	59408-5	urn:iso:std:iso:11073:10101	150456	http://unitsofmeasure.org	%	%	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffsaettigung-Im-Arteriellen-Blut-Per-Pulsoxymetrie	102010	1	Patient	SpO2	Sauerstoffsättigung Pulsoxymetrie	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
32	Spontane-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19839-0	urn:iso:std:iso:11073:10101	152498	http://unitsofmeasure.org	/min	AZ/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Atemfrequenz-Beatmet	103036	1	Patient	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
32	Spontane-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19839-0	urn:iso:std:iso:11073:10101	152498	http://unitsofmeasure.org	/min	1/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Atemfrequenz-Beatmet	100270	1	Patient	Beatmung_Messung_AFSpontan	Respiratory Rate (spontan)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
32	Spontane-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19839-0	urn:iso:std:iso:11073:10101	152498	http://unitsofmeasure.org	/min	bpm	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Atemfrequenz-Beatmet	103324	1	Patient	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
33	Spontane-Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19840-8	urn:iso:std:iso:11073:10101	152490	http://unitsofmeasure.org	/min	AZ/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Mechanische-Atemfrequenz-Beatmet	103036	1	Patient	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	Vol%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103314	1	Patient	Beatmung_MS_Evita4_FiO2	gemessene O2 Konzentration des inspiratorischen Atemgasgemisches	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0.01
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103216	1	Patient	Beatmung_MS_3100B_O2Konzentration	Messwert: gemessene O2 Konzentration des Gasgemisches	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0.01
33	Spontane-Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19840-8	urn:iso:std:iso:11073:10101	152490	http://unitsofmeasure.org	/min	bpm	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Mechanische-Atemfrequenz-Beatmet	103324	1	Patient	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
34	Substituatfluss	http://snomed.info/sct	182744004	http://snomed.info/sct	708513005	\N	\N	\N	\N	http://unitsofmeasure.org	mL/h	mL/h	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Substituatfluss	102992	1	Patient	Nierenverfahren_ES_BM25_Umsatz	Austausch, Substituat, ml/h	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
34	Substituatfluss	http://snomed.info/sct	182744004	http://snomed.info/sct	708513005	\N	\N	\N	\N	http://unitsofmeasure.org	mL/h	mL/h	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Substituatfluss	102978	1	Patient	Nierenverfahren_ES_Multi_Substituat	Umsatz, Austausch Substituat ml/h	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
35	Venöser Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	252076005	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Venoeser-Druck	103011	1	Patient	Nierenverfahren_MS_Multi_venDruck	venöser Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
37	Zentralvenoeser Druck (ZVD)	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	71420008	http://loinc.org	60985-9	urn:iso:std:iso:11073:10101	150084	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Zentralvenoeser-Blutdruck	1269	1	Patient	ZVD	Zentralvenöser Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	102030	1	Patient	SV	Schlagvolumen 	3	String	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	102874	1	Patient	Beatmung_ES_VisionA_Schlagvolumen	Schlagvolumen (SV) in engl. (cycle volume)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	102408	1	Patient	p-SV	Schlagvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	104758	1	Patient	Schlagvolumen	gemessenes Schlagvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	100102	1	Patient	Beatmung_Einstellung_PEEP	Positiver endexspiratorischer Druck (PEEP)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	103943	1	Patient	Beatmung_ES_Heimbeatmung_Peep	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	100275	1	Patient	Beatmung_Messung_PEEP	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	104722	1	Patient	Beatmung_MS_Pallas_PEEP	Dokumentation des gemessenen PEEPs.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	101444	1	Patient	Beatmung_Messung_IntrinsicPEEP	Intrinsic PEEP	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972
38	Dauer Haemodialysesitzung	http://snomed.info/sct	182744004	http://snomed.info/sct	445940005	\N	\N	\N	\N	http://unitsofmeasure.org	h	min	DeviceMetric/Example_Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Dauer-Haemodialysesitzung	110772	1	Patient	P_NEV_HD_MS_5008onl_Rest_Zeit_min	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0.016666667
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	103318	1	Patient	Beatmung_MS_Evita4_PEEP	gemessener positiver endexspiratorischer Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972
41	Maximaler Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76531-3	urn:iso:std:iso:11073:10101	151973	http://unitsofmeasure.org	cm[H2O]	mmHg	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Maximaler-Beatmungsdruck	100300	1	Patient	Beatmung_Messung_Pmax	Peak Airway Pressure	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.35951
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	100100	1	Patient	Beatmung_Messung_FiO2	FiO2	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0.01
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	104730	1	Patient	Beatmung_MS_Pallas_O2_insp	Gemessene inspiratorische O2 Konzentration.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0.01
\.


--
-- Data for Name: mapping_mii_co6_2_result; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.mapping_mii_co6_2_result (profile_id, profile_name, category_coding_system, category_coding_code, code_coding_system_snomed, code_coding_code_snomed, code_coding_system_loinc, code_coding_code_loinc, code_coding_system_ieee, code_coding_code_ieee, valuequantity_system, valuequantity_code, conf_var_unit, device_reference, meta_profile, conf_var_id, conf_var_parent_id, conf_var_parent_name, conf_var_name, conf_var_description, conf_var_types_id, conf_var_types_name, code_systolic_coding_system_snomed, code_systolic_coding_code_snomed, code_systolic_coding_system_loinc, code_systolic_coding_code_loinc, code_systolic_coding_system_ieee, code_systolic_coding_code_ieee, code_mean_coding_system_snomed, code_mean_coding_code_snomed, code_mean_coding_system_loinc, code_mean_coding_code_loinc, code_mean_coding_system_ieee, code_mean_coding_code_ieee, code_diastolic_coding_system_snomed, code_diastolic_coding_code_snomed, code_diastolic_coding_system_loinc, code_diastolic_coding_code_loinc, code_diastolic_coding_system_ieee, code_diastolic_coding_code_ieee, matching_valide, unit_transform, profil_generic, profil_generic_id) FROM stdin;
3	Atemzugvolumen-Waehrend-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	250874002	http://loinc.org	76222-9	urn:iso:std:iso:11073:10101	151980	http://unitsofmeasure.org	mL	ml	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Atemzugvolumen-Waehrend-Beatmung	104726	1	Patient	Beatmung_MS_Pallas_Vt	Gemessenes Tidalvolumen.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
4	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	426102006	http://loinc.org	76009-0	urn:iso:std:iso:11073:10101	152004	http://unitsofmeasure.org	L/min	L/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/SBeatmungsvolumen-Pro-Minute-Machineller-Beatmung	103320	1	Patient	Beatmung_MS_Evita4_MV	gemessenes Atemminutenvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
4	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	426102006	http://loinc.org	76009-0	urn:iso:std:iso:11073:10101	152004	http://unitsofmeasure.org	L/min	L/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/SBeatmungsvolumen-Pro-Minute-Machineller-Beatmung	100098	1	Patient	Beatmung_Messung_MV	Mindest Volumen tot.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
4	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	426102006	http://loinc.org	76009-0	urn:iso:std:iso:11073:10101	152004	http://unitsofmeasure.org	L/min	L/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/SBeatmungsvolumen-Pro-Minute-Machineller-Beatmung	104725	1	Patient	Beatmung_MS_Pallas_MV	Gemessenes Atemminutenvolumen.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
2	Atemfrequenz	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	86290005	https://loinc.org/9279-1/	9279-1	\N	\N	http://unitsofmeasure.org	/min	1/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Atemfrequenz	1267	1	Patient	AF	Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
1	Arterieller Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	386534000	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Arterieller-Druck	103010	1	Patient	Nierenverfahren_MS_Multi_artDruck	arterieller Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von extrakorporalen Verfahren	1
17	Koerpergewicht	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	27113001	http://loinc.org	29463-7	\N	\N	http://unitsofmeasure.org	kg	kg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpergewicht	6	1	Patient	Patient_Gewicht	Gewicht des Patienten	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
18	Koerpergroesse	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	1153637007	http://loinc.org	8302-2	\N	\N	http://unitsofmeasure.org	cm	cm	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpergroesse	7	1	Patient	Patient_Groesse	Größe des Patienten	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
8	Druckdifferenz Beatmung	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76154-4	urn:iso:std:iso:11073:10101	152720	http://unitsofmeasure.org	cm[H2O]	cm H2O	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Druckdifferenz-Beatmung	103078	1	Patient	Beatmung_MS_VisionA_Amplitude	gemessene Druckdifferenz im HFOV Modus	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
9	Einstellung-Einatmungszeit-Beatmung	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76334-2	urn:iso:std:iso:11073:10101	16929632	http://unitsofmeasure.org	s	s	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Einstellung-Einatmungszeit-Beatmung	103297	1	Patient	Beatmung_ES_Evita4_Tinsp	eingestellte absolute Inspirationszeit	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
9	Einstellung-Einatmungszeit-Beatmung	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76334-2	urn:iso:std:iso:11073:10101	16929632	http://unitsofmeasure.org	s	s	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Einstellung-Einatmungszeit-Beatmung	102887	1	Patient	Beatmung_ES_G5_Ti	Einstelungswert für die Inspirationszeit	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
12	Herzfrequenz	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	364075005	http://loinc.org	8867-4	\N	\N	http://unitsofmeasure.org	/min	1/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzfrequenz	1266	1	Patient	HF	Herzfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
13	Herzzeitvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	82799009	http://loinc.org	8741-1	urn:iso:std:iso:11073:10101	150276	http://unitsofmeasure.org	L/min	L/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzzeitvolumen	102184	1	Patient	VigilanceC_HZV	Herzzeitvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
13	Herzzeitvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	82799009	http://loinc.org	8741-1	urn:iso:std:iso:11073:10101	150276	http://unitsofmeasure.org	L/min	L/min	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzzeitvolumen	102051	1	Patient	HZV	Herzzeitvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
15	Intrakranieller Druck (ICP)	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	250844005	http://loinc.org	60956-0	urn:iso:std:iso:11073:10101	153608	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Intrakranieller-Druck-ICP	100088	1	Patient	ICP	Intrakranialer Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
16	Ionisiertes Kalzium aus Nierenersatzverfahren	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	83064-6	\N	\N	http://unitsofmeasure.org	mmol/L	mmol/l	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Ionisiertes-Kalzium-Nierenersatzverfahren	103058	1	Patient	Nierenverfahren_ES_Multi_CalciumFiltrat	Calciumrate	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von extrakorporalen Verfahren	1
16	Ionisiertes Kalzium aus Nierenersatzverfahren	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	83064-6	\N	\N	http://unitsofmeasure.org	mmol/L	mmol/L	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Ionisiertes-Kalzium-Nierenersatzverfahren	104974	1	Patient	NEV_CRRT_ES_Multi_CalciumFiltrat	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von extrakorporalen Verfahren	1
7	Blutfluss durch cardiovasculäres Gerät	http://snomed.info/sct	182744004	http://snomed.info/sct	444479000	\N	\N	\N	\N	http://unitsofmeasure.org	L/min	L/Min	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutfluss-Cardiovasculaeres-Geraet	106332	1	Patient	CardioHelpMaquet_MS_Blutfluss	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von extrakorporalen Verfahren	1
10	Exspiratorischer Gasfluss	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	60792-9	urn:iso:std:iso:11073:10101	151944	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Exspiratorischer-Gasfluss	102915	1	Patient	Beatmung_MS_G5_ExspFlow	Exspiratorischer Peakflow, ein Monitoring-Parameter	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
21	Linksatrialer Druck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksatrialer-Druck	100091	1	Patient	LAP	Linksatrial  Mitteldruck	6	Decimal_6_3	\N	\N	http://loinc.org	60989-1	urn:iso:std:iso:11073:10101	150065	\N	\N	http://loinc.org	8399-8	urn:iso:std:iso:11073:10101	150067	\N	\N	http://loinc.org	75933-2	urn:iso:std:iso:11073:10101	150066	t	1	Monitoring und Vitaldaten	3
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	1/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	101442	1	Patient	Beatmung_Messung_AF	Breathing Frequency	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	1/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	104727	1	Patient	Beatmung_MS_Pallas_Frequenz	Gemessene Atemfrequenz.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
27	Pulmonalarterieller wedge Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	118433006	http://loinc.org	75994-4	urn:iso:std:iso:11073:10101	150052	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Pulmonalarterieller-Wedge-Druck	102018	1	Patient	PWP	Pulmunaler Wedgedruck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
30	Sauerstoffgasfluss	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	19941-4	\N	\N	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffgasfluss	106784	1	Patient	Beatmung_ES_Optiflow_O2Flow	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von extrakorporalen Verfahren	1
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	[cmH2O]	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	104264	1	Patient	Beatmung_ES_Servoi_PEEP	PEEP 	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
32	Spontane-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19839-0	urn:iso:std:iso:11073:10101	152498	http://unitsofmeasure.org	/min	AZ/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Atemfrequenz-Beatmet	103036	1	Patient	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
32	Spontane-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19839-0	urn:iso:std:iso:11073:10101	152498	http://unitsofmeasure.org	/min	1/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Atemfrequenz-Beatmet	100270	1	Patient	Beatmung_Messung_AFSpontan	Respiratory Rate (spontan)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
32	Spontane-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19839-0	urn:iso:std:iso:11073:10101	152498	http://unitsofmeasure.org	/min	bpm	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Atemfrequenz-Beatmet	103324	1	Patient	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
33	Spontane-Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19840-8	urn:iso:std:iso:11073:10101	152490	http://unitsofmeasure.org	/min	AZ/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Mechanische-Atemfrequenz-Beatmet	103036	1	Patient	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
37	Zentralvenoeser Druck (ZVD)	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	71420008	http://loinc.org	60985-9	urn:iso:std:iso:11073:10101	150084	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Zentralvenoeser-Blutdruck	1269	1	Patient	ZVD	Zentralvenöser Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
34	Substituatfluss	http://snomed.info/sct	182744004	http://snomed.info/sct	708513005	\N	\N	\N	\N	http://unitsofmeasure.org	mL/h	mL/h	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Substituatfluss	102992	1	Patient	Nierenverfahren_ES_BM25_Umsatz	Austausch, Substituat, ml/h	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von extrakorporalen Verfahren	1
34	Substituatfluss	http://snomed.info/sct	182744004	http://snomed.info/sct	708513005	\N	\N	\N	\N	http://unitsofmeasure.org	mL/h	mL/h	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Substituatfluss	102978	1	Patient	Nierenverfahren_ES_Multi_Substituat	Umsatz, Austausch Substituat ml/h	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von extrakorporalen Verfahren	1
35	Venöser Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	252076005	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Venoeser-Druck	103011	1	Patient	Nierenverfahren_MS_Multi_venDruck	venöser Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von extrakorporalen Verfahren	1
31	Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	\N	\N	http://loinc.org	59408-5	urn:iso:std:iso:11073:10101	150456	http://unitsofmeasure.org	%	%	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffsaettigung-Im-Arteriellen-Blut-Per-Pulsoxymetrie	102010	1	Patient	SpO2	Sauerstoffsättigung Pulsoxymetrie	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
30	Sauerstoffgasfluss	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	19941-4	\N	\N	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffgasfluss	103091	1	Patient	Beatmung_ES_CF800_SauerstoffFlow	Einstellgröße Gasfluss Sauerstoff	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von extrakorporalen Verfahren	1
5	Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck	100094	1	Patient	NBP_1	nichtinvasiver Blutdruck 1	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1	Monitoring und Vitaldaten	3
5	Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck	104356	1	Patient	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1	Monitoring und Vitaldaten	3
5	Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck	106468	1	Patient	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1	Monitoring und Vitaldaten	3
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	100100	1	Patient	Beatmung_Messung_FiO2	FiO2	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0.01	Parameter von Beatmung	2
38	Dauer Haemodialysesitzung	http://snomed.info/sct	182744004	http://snomed.info/sct	445940005	\N	\N	\N	\N	http://unitsofmeasure.org	h	min	DeviceMetric/Example_Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Dauer-Haemodialysesitzung	110772	1	Patient	P_NEV_HD_MS_5008onl_Rest_Zeit_min	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0.016666667	Parameter von extrakorporalen Verfahren	1
1	Arterieller Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	386534000	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Arterieller-Druck	100089	1	Patient	ABP_2	zweiter arterieller Blutdruck	12	Medic_Pressure	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von extrakorporalen Verfahren	1
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	100102	1	Patient	Beatmung_Einstellung_PEEP	Positiver endexspiratorischer Druck (PEEP)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972	Parameter von Beatmung	2
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	103943	1	Patient	Beatmung_ES_Heimbeatmung_Peep	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972	Parameter von Beatmung	2
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	100275	1	Patient	Beatmung_Messung_PEEP	\N	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972	Parameter von Beatmung	2
6	Blutdruck Generisch	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck-Generisch	106468	1	Patient	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1	Monitoring und Vitaldaten	3
6	Blutdruck Generisch	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck-Generisch	100094	1	Patient	NBP_1	nichtinvasiver Blutdruck 1	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1	Monitoring und Vitaldaten	3
6	Blutdruck Generisch	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mm[Hg]	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck-Generisch	104356	1	Patient	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.	12	Medic_Pressure	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	t	1	Monitoring und Vitaldaten	3
11	Exspiratorischer Sauerstoffpartialdruck	http://snomed.info/sct	40617009	http://snomed.info/sct	250775008	http://loinc.org	3147-6	urn:iso:std:iso:11073:10101	153132	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Exspiratorischer-Sauerstoffpartialdruck	103817	1	Patient	PtiO2Druck	Gemessener Sauerstoffpartialdruck im Parenchym	12	Medic_Pressure	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
19	Koerpertemperatur Kern	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	276885007	http://loinc.org	8329-5	urn:iso:std:iso:11073:10101	150368	http://unitsofmeasure.org	Cel	°C	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpertemperatur-Kern	110933	1	Patient	P_Temperatur_Kern	Anlage für Philips Monitoring	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
20	Kopfumfang	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	\N	\N	http://loinc.org	9843-4	\N	\N	http://unitsofmeasure.org	cm	cm	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Kopfumfang	11	1	Patient	COPRA_Patient_Kopfumfang	Kopfumfang des Patienten in Zentimetern	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
22	Linksventrikulaerer Schlagvolumenindex	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	277381004	http://loinc.org	76297-1	urn:iso:std:iso:11073:10101	149764	http://unitsofmeasure.org	mL/m2	ml/m2	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaerer-Schlagvolumenindex	102036	1	Patient	p-SVI	Schlagvolumenindex  (PICCO Modul Dräger Monitoring)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	102030	1	Patient	SV	Schlagvolumen 	3	String	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	102874	1	Patient	Beatmung_ES_VisionA_Schlagvolumen	Schlagvolumen (SV) in engl. (cycle volume)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	102408	1	Patient	p-SV	Schlagvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	ml	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen	104758	1	Patient	Schlagvolumen	gemessenes Schlagvolumen	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Monitoring und Vitaldaten	3
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	1/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	100108	1	Patient	Beatmung_Einstellung_AF	Beatmungsfrequenz (f/AF)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	AZ/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	103035	1	Patient	Beatmung_MS_G5_ftotal	Gesamtatemfrequenz, ein Monitoring Parameter	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	bpm	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet	103323	1	Patient	Beatmung_MS_Evita4_frequenz	gemessene Gesamtatemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
24	Mittlerer Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76530-5	urn:iso:std:iso:11073:10101	151975	http://unitsofmeasure.org	cm[H2O]	cm H2O	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mittlerer-Beatmungsdruck	102873	1	Patient	Beatmung_ES_VisionA_MAP	Mittlerer Atemwegsdruck (MAP)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
24	Mittlerer Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76530-5	urn:iso:std:iso:11073:10101	151975	http://unitsofmeasure.org	cm[H2O]	cm H2O	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mittlerer-Beatmungsdruck	102878	1	Patient	Beatmung_MS_VisionA_MAP	gemessener Mittlerer Atemwegsdruck unter HFO bei Alpha Vision	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
24	Mittlerer Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76530-5	urn:iso:std:iso:11073:10101	151975	http://unitsofmeasure.org	cm[H2O]	[cmH2O]	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mittlerer-Beatmungsdruck	104249	1	Patient	Beatmung_MS_Servoi_Pmean	Mittlerer Atemwegsdruck 	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
29	Sauerstofffraktion eingestellt	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	%	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103296	1	Patient	Beatmung_ES_Evita4_O2Konzentration	eingestellte O2 Konzentration des Frischgases	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
29	Sauerstofffraktion eingestellt	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	%	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103214	1	Patient	Beatmung_ES_3100B_O2Konzentration	Einstellwert: O2 Konzentration des Gasgemisches	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
29	Sauerstofffraktion eingestellt	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	%	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	100105	1	Patient	Beatmung_Einstellung_FiO2	O²- Konzentration im Inspirationsgemisch (FiO2)	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	Vol%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103314	1	Patient	Beatmung_MS_Evita4_FiO2	gemessene O2 Konzentration des inspiratorischen Atemgasgemisches	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0.01	Parameter von Beatmung	2
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	103216	1	Patient	Beatmung_MS_3100B_O2Konzentration	Messwert: gemessene O2 Konzentration des Gasgemisches	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0.01	Parameter von Beatmung	2
33	Spontane-Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19840-8	urn:iso:std:iso:11073:10101	152490	http://unitsofmeasure.org	/min	bpm	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Mechanische-Atemfrequenz-Beatmet	103324	1	Patient	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
41	Maximaler Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76531-3	urn:iso:std:iso:11073:10101	151973	http://unitsofmeasure.org	cm[H2O]	mmHg	DeviceMetric/..._Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Maximaler-Beatmungsdruck	100300	1	Patient	Beatmung_Messung_Pmax	Peak Airway Pressure	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.35951	Parameter von Beatmung	2
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion	104730	1	Patient	Beatmung_MS_Pallas_O2_insp	Gemessene inspiratorische O2 Konzentration.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	0.01	Parameter von Beatmung	2
1	Arterieller Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	386534000	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Arterieller-Druck	100093	1	Patient	ABP_1	arterieller Blutdruck 1	12	Medic_Pressure	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von extrakorporalen Verfahren	1
26	Pulmonalarterieller Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	mmHg	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Pulmonalarterieller-Blutdruck	102050	1	Patient	PAP	Pulmunalarterieller Druck	12	Medic_Pressure	\N	\N	http://loinc.org	8440-0	urn:iso:std:iso:11073:10101	150045	\N	\N	http://loinc.org	8414-5	urn:iso:std:iso:11073:10101	150047	\N	\N	http://loinc.org	8385-7	urn:iso:std:iso:11073:10101	150046	t	1	Monitoring und Vitaldaten	3
14	Inspiratorischer Gasfluss	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76275-7	urn:iso:std:iso:11073:10101	151948	http://unitsofmeasure.org	L/min	l/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Eingestellter-Inspiratorischer-Gasfluss	102903	1	Patient	Beatmung_MS_G5_InspFlow	Inspiratorischer Peakflow, ein Monitoring-Parameter	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1	Parameter von Beatmung	2
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	104722	1	Patient	Beatmung_MS_Pallas_PEEP	Dokumentation des gemessenen PEEPs.	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972	Parameter von Beatmung	2
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	101444	1	Patient	Beatmung_Messung_IntrinsicPEEP	Intrinsic PEEP	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972	Parameter von Beatmung	2
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	mbar	DeviceMetric/Eingestellte_Parameter_Beatmung_id	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck	103318	1	Patient	Beatmung_MS_Evita4_PEEP	gemessener positiver endexspiratorischer Druck	6	Decimal_6_3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	1.01972	Parameter von Beatmung	2
\.


--
-- Data for Name: mapping_mii_co6_raw; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.mapping_mii_co6_raw (conf_var_id, conf_var_parent_id, conf_var_parent_name, profile_name, conf_var_name, conf_var_description, conf_var_unit, profile_unit, conf_var_types_id, conf_var_types_name, loinc, url_loinc, snomed, url_snomed, matching, quantities) FROM stdin;
102011	1	Patient	Puls	PLS	Pulsrate errechnet aus der SpO2 Messung	1/min	\N	6	Decimal_6_3	\N	\N	8499008	https://bioportal.bioontology.org/ontologies/SNOMEDCT?p=classes&conceptid=8499008	0	30000030
1276	1	Patient	Arterieller Druck	ABP	arterielle Blutdruck	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	386534000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=386534000	0	\N
108390	102794	Score_ComfortSkala	Arterieller Druck	Score_ComfortSkala_MAD	Mittlerer Arterieller Blutdruck	\N	mm[Hg]	27	SubScore	\N	\N	386534000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=386534000	0	\N
104284	1	Patient	Atemzugvolumen Waehrend Beatmung	Beatmung_ES_Servoi_Vt	Tidalvolumen 	[ml]	mL	6	Decimal_6_3	76222-9	https://loinc.org/76222-9/	250874002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250874002	0	\N
100107	1	Patient	Beatmungsvolumen Pro Minute Maschineller Beatmung	Beatmung_Einstellung_AMV	Atemminutenvolumen (AMV)	l/min.	L/min	6	Decimal_6_3	76009-0	https://loinc.org/76009-0/	426102006	https://browser.ihtsdotools.org/?perspective=full&conceptId1=426102006	0	\N
103280	1	Patient	Beatmungsvolumen Pro Minute Maschineller Beatmung	Beatmung_MS_Evita2_AMV	gemessenes Atemminutenvolumen	L/min	L/min	6	Decimal_6_3	76009-0	https://loinc.org/76009-0/	426102006	https://browser.ihtsdotools.org/?perspective=full&conceptId1=426102006	0	\N
104418	104403	Praemedikation	Blutdruck	Praemedikation_Präanästh_Anordnung_Einheiten_EB	Präanästhetische Anordnung: Anzahl der anzufordernden Einheiten an Eigenblut.	\N	mm[Hg]	3	String	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	\N
104555	104403	Praemedikation	Blutdruck	Praemedikation_Blutdruck	Dokumentation des Blutdruckes.	\N	mm[Hg]	3	String	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	\N
108390	102794	Score_ComfortSkala	Blutdruck	Score_ComfortSkala_MAD	Mittlerer Arterieller Blutdruck	\N	mm[Hg]	27	SubScore	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	\N
102010	1	Patient	Sauerstoffsaettigung Im Arteriellen Blut Per Pulsoxymetrie	SpO2	Sauerstoffsättigung Pulsoxymetrie	%	%	6	Decimal_6_3	59408-5	https://loinc.org/59408-5/	\N	\N	0	22647295
103036	1	Patient	Spontane Atemfrequenz Beatmet	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz	AZ/min	/min	6	Decimal_6_3	\N	\N	\N	\N	0	20846232
100305	1	Patient	Beatmungszeit Hohem Druck	Beatmung_Messung_ZeitHoch	\N	sec	s	6	Decimal_6_3	76190-8	https://loinc.org/76190-8/	\N	\N	0	\N
104263	1	Patient	Beatmungszeit Hohem Druck	Beatmung_ES_Servoi_Thoch	zeit oberes Druckniveau (thoch) 	[s]	s	6	Decimal_6_3	76190-8	https://loinc.org/76190-8/	\N	\N	0	\N
100306	1	Patient	Beatmungszeit Niedrigem Druck	Beatmung_Messung_ZeitNiedrig	\N	sec	s	6	Decimal_6_3	76229-4	https://loinc.org/76229-4/	\N	\N	0	\N
104262	1	Patient	Beatmungszeit Niedrigem Druck	Beatmung_ES_Servoi_Tpeep	zeit unteres Druckniveau (tniedrig) 	[s]	s	6	Decimal_6_3	76229-4	https://loinc.org/76229-4/	\N	\N	0	\N
1268	1	Patient	Puls	Puls	Puls	1/min	\N	6	Decimal_6_3	\N	\N	8499008	https://bioportal.bioontology.org/ontologies/SNOMEDCT?p=classes&conceptid=8499008	0	68448
102031	100134	HarnwegeDarm	Linksventrikulaeres Schlagvolumenindex	SVI	Index des Schlagvolumens 	ml/m2	mL/m2	3	String	76297-1	https://loinc.org/76297-1/	277381004	https://browser.ihtsdotools.org/?perspective=full&conceptId1=277381004	0	\N
102187	1	Patient	Linksventrikulaeres Schlagvolumenindex	VigilanceC_SVI	Schlagvolumenindex	\N	mL/m2	6	Decimal_6_3	76297-1	https://loinc.org/76297-1/	277381004	https://browser.ihtsdotools.org/?perspective=full&conceptId1=277381004	0	85
110934	1	Patient	Koerpertemperatur Generisch	P_Temperatur_generic	Anlage für Philips Monitoring	°C	Cel	6	Decimal_6_3	8310-5	https://loinc.org/8310-5/	\N	\N	0	1952044
103035	1	Patient	Mechanische Atemfrequenz Beatmet	Beatmung_MS_G5_ftotal	Gesamtatemfrequenz, ein Monitoring Parameter	AZ/min	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	9577905
102903	1	Patient	Inspiratorischer Gasfluss	Beatmung_MS_G5_InspFlow	Inspiratorischer Peakflow, ein Monitoring-Parameter	l/min	L/min	6	Decimal_6_3	60794-5	https://loinc.org/60794-5/	\N	\N	0	2686525
110930	1	Patient	Koerpertemperatur rektal	P_Temperatur_Rektal	Anlage im Rahmen Philips Monitoring	°C	Cel	6	Decimal_6_3	8332-9	https://loinc.org/8332-9/	307047009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=307047009	0	198068
110927	1	Patient	Koerpertemperatur nasal	P_Temperatur_Naso	Anlage im Rahmen PhilipsMonitoring	°C	Cel	6	Decimal_6_3	76010-8	https://loinc.org/76010-8/	\N	\N	0	2183
110929	1	Patient	Koerpertemperatur Trommelfell	P_Temperatur_Tympanal	Anlage im Rahmen PhilipsMonitoring	°C	Cel	6	Decimal_6_3	8333-7	https://loinc.org/8333-7/	415974002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=415974002	0	59195
110928	1	Patient	Koerpertemperatur Speiseroehre	P_Temperatur_Oesophagial	Anlage im Rahmen PhilipsMonitoring	°C	Cel	6	Decimal_6_3	60836-4	https://loinc.org/60836-4/	431598003	https://browser.ihtsdotools.org/?perspective=full&conceptId1=431598003	0	20648
110925	1	Patient	Koerpertemperatur Blut	P_Temperatur_Arteriell	Anlage im Rahmen PhilipsMonitoring	°C	Cel	6	Decimal_6_3	60834-9	https://loinc.org/60834-9/	860958002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=860958002	0	2237
103716	1	Patient	Koerpertemperatur Blut	TempBT	Bluttemperatur bei der HZV Messung	°C	Cel	6	Decimal_6_3	60834-9	https://loinc.org/60834-9/	860958002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=860958002	0	52583
102666	1	Patient	Dauer Haemodialysesitzung	Nierenersatzverfahren_Mess_DialyseZeit	\N	\N	h	6	Decimal_6_3	\N	\N	445940005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=445940005	0	\N
100088	1	Patient	Intrakranieller Druck	ICP	Intrakranialer Druck	mmHg	mm[Hg]	6	Decimal_6_3	60956-0	https://loinc.org/60956-0/	250844005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250844005	0	1680225
103174	1	Patient	Dauer Haemodialysesitzung	Nierenvwerfahren_ES_4008onl_Dialysezeit	\N	h:min	h	6	Decimal_6_3	\N	\N	445940005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=445940005	0	\N
102039	1	Patient	Linksventrikulaerer Herzindex	dPmax	Index der linken Ventrikelkontraktilität  	mmHg/s	L/(min.m2)	6	Decimal_6_3	75919-1	https://loinc.org/75919-1/	54993008	https://browser.ihtsdotools.org/?perspective=full&conceptId1=54993008	0	986335
102408	1	Patient	Linksventrikulaeres Schlagvolumen	p-SV	Schlagvolumen	ml	/mL	6	Decimal_6_3	20562-5	https://loinc.org/20562-5/	\N	\N	0	864963
110933	1	Patient	Koerpertemperatur Kern	P_Temperatur_Kern	Anlage für Philips Monitoring	°C	Cel	6	Decimal_6_3	8329-5	https://loinc.org/8329-5/	\N	\N	0	758879
102915	1	Patient	Exspiratorischer Gasfluss	Beatmung_MS_G5_ExspFlow	Exspiratorischer Peakflow, ein Monitoring-Parameter	l/min	L/min	6	Decimal_6_3	60792-9	https://loinc.org/60792-9/	\N	\N	0	734325
104974	1	Patient	Ionisiertes Kalzium Nierenersatzverfahren	NEV_CRRT_ES_Multi_CalciumFiltrat	\N	\N	mmol/L	6	Decimal_6_3	83064-6	https://loinc.org/83064-6/	\N	\N	0	303169
100113	1	Patient	Eingestellter Inspiratorischer Gasfluss	Beatmung_Anordnung_Flow	Anordnung Inspiratorische Flowrate	l/min	L/min	6	Decimal_6_3	76275-7	https://loinc.org/76275-7/	\N	\N	0	\N
102058	1	Patient	Eingestellter Inspiratorischer Gasfluss	Beatmung_Einstellung_Inspirationsflow	\N	l/min	L/min	6	Decimal_6_3	76275-7	https://loinc.org/76275-7/	\N	\N	0	\N
104758	1	Patient	Linksventrikulaeres Schlagvolumen	Schlagvolumen	gemessenes Schlagvolumen	ml	/mL	6	Decimal_6_3	20562-5	https://loinc.org/20562-5/	\N	\N	0	274423
100300	1	Patient	Maximaler Beatmungsdruck	Beatmung_Messung_Pmax	Peak Airway Pressure	mmHg	cm[H2O]	6	Decimal_6_3	76531-3	https://loinc.org/76531-3/	\N	\N	0	111043
101442	1	Patient	Mechanische Atemfrequenz Beatmet	Beatmung_Messung_AF	Breathing Frequency	1/min	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	108930
6	1	Patient	Koerpergewicht	Patient_Gewicht	Gewicht des Patienten	\N	kg	6	Decimal_6_3	29463-7	https://loinc.org/29463-7/	\N	\N	0	96050
102887	1	Patient	Einstellung Einatmungszeit Beatmung	Beatmung_ES_G5_Ti	Einstelungswert für die Inspirationszeit	s	s	6	Decimal_6_3	76334-2	https://loinc.org/76334-2/	\N	\N	0	70600
100270	1	Patient	Spontane Atemfrequenz Beatmet	Beatmung_Messung_AFSpontan	Respiratory Rate (spontan)	1/min	/min	6	Decimal_6_3	\N	\N	\N	\N	0	59723
108032	1	Patient	Exspiratorischer Gasfluss	P_Beatmung_MS_C3_ExspFlow	Exspiratorischer Peakflow	l/min	L/min	6	Decimal_6_3	60792-9	https://loinc.org/60792-9/	\N	\N	0	\N
103296	1	Patient	Sauerstofffraktion Eingestellt	Beatmung_ES_Evita4_O2Konzentration	eingestellte O2 Konzentration des Frischgases	%	\N	6	Decimal_6_3	19994-3	https://loinc.org/19994-3/	\N	\N	0	34154
100105	1	Patient	Sauerstofffraktion Eingestellt	Beatmung_Einstellung_FiO2	O²- Konzentration im Inspirationsgemisch (FiO2)	%	\N	6	Decimal_6_3	19994-3	https://loinc.org/19994-3/	\N	\N	0	29967
7	1	Patient	Koerpergroesse	Patient_Groesse	Größe des Patienten	\N	cm	6	Decimal_6_3	\N	\N	50373000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=50373000	0	79120
1266	1	Patient	Herzfrequenz	HF	Herzfrequenz	1/min	/min	6	Decimal_6_3	8867-4	https://loinc.org/8867-4/	\N	\N	0	25851846
103058	1	Patient	Ionisiertes Kalzium Nierenersatzverfahren	Nierenverfahren_ES_Multi_CalciumFiltrat	Calciumrate	mmol/l	mmol/L	6	Decimal_6_3	83064-6	https://loinc.org/83064-6/	\N	\N	0	19281
103297	1	Patient	Einstellung Einatmungszeit Beatmung	Beatmung_ES_Evita4_Tinsp	eingestellte absolute Inspirationszeit	s	s	6	Decimal_6_3	76334-2	https://loinc.org/76334-2/	\N	\N	0	13393
104730	1	Patient	Sauerstofffraktion	Beatmung_MS_Pallas_O2_insp	Gemessene inspiratorische O2 Konzentration.	%	\N	6	Decimal_6_3	71835-3	https://loinc.org/71835-3/	\N	\N	0	10295
103324	1	Patient	Spontane Atemfrequenz Beatmet	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz	bpm	/min	6	Decimal_6_3	\N	\N	\N	\N	0	7092
103078	1	Patient	Druckdifferenz Beatmung	Beatmung_MS_VisionA_Amplitude	gemessene Druckdifferenz im HFOV Modus	cm H2O	cm[H2O]	6	Decimal_6_3	76154-4	https://loinc.org/76154-4/	\N	\N	0	7040
102878	1	Patient	Mittlerer Beatmungsdruck	Beatmung_MS_VisionA_MAP	gemessener Mittlerer Atemwegsdruck unter HFO bei Alpha Vision	cm H2O	cm[H2O]	6	Decimal_6_3	76530-5	https://loinc.org/76530-5/	\N	\N	0	6945
100108	1	Patient	Mechanische Atemfrequenz Beatmet	Beatmung_Einstellung_AF	Beatmungsfrequenz (f/AF)	1/min	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	5250
101912	101906	KlinikHerzKreislaufFunktion_KMakrozirkulation_Wert	Herzfrequenz	KlinikHerzKreislaufFunktion_KMakrozirkulation_Hf	Herzfrequenz	\N	/min	3	String	8867-4	https://loinc.org/8867-4/	\N	\N	0	\N
102873	1	Patient	Mittlerer Beatmungsdruck	Beatmung_ES_VisionA_MAP	Mittlerer Atemwegsdruck (MAP)	cm H2O	cm[H2O]	6	Decimal_6_3	76530-5	https://loinc.org/76530-5/	\N	\N	0	3863
103216	1	Patient	Sauerstofffraktion	Beatmung_MS_3100B_O2Konzentration	Messwert: gemessene O2 Konzentration des Gasgemisches	%	\N	6	Decimal_6_3	71835-3	https://loinc.org/71835-3/	\N	\N	0	3718
103314	1	Patient	Sauerstofffraktion	Beatmung_MS_Evita4_FiO2	gemessene O2 Konzentration des inspiratorischen Atemgasgemisches	Vol%	\N	6	Decimal_6_3	71835-3	https://loinc.org/71835-3/	\N	\N	0	3673
103268	1	Patient	Inspiratorischer Gasfluss	Beatmung_ES_Evita2_InspFlow	eingestellter Inspirationfluss	L/min	L/min	6	Decimal_6_3	60794-5	https://loinc.org/60794-5/	\N	\N	0	\N
107816	1	Patient	Inspiratorischer Gasfluss	Beatmung_ES_Leoni_FlowInsp	\N	l/min	L/min	6	Decimal_6_3	60794-5	https://loinc.org/60794-5/	\N	\N	0	\N
107878	1	Patient	Inspiratorischer Gasfluss	Beatmung_MS_T1_InspFlow	Inspiratorischer Peakflow	l/min	L/min	6	Decimal_6_3	60794-5	https://loinc.org/60794-5/	\N	\N	0	\N
108033	1	Patient	Inspiratorischer Gasfluss	P_Beatmung_MS_C3_InspFlow	Inspiratorischer Peakflow	l/min	L/min	6	Decimal_6_3	60794-5	https://loinc.org/60794-5/	\N	\N	0	\N
100102	1	Patient	Positv Endexpiratorischer Druck	Beatmung_Einstellung_PEEP	Positiver endexspiratorischer Druck (PEEP)	mbar	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	28887
102184	1	Patient	Herzzeitvolumen	VigilanceC_HZV	Herzzeitvolumen	\N	L/min	6	Decimal_6_3	8741-1	https://loinc.org/8741-1/	82799009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=82799009	0	24916
102026	1	Patient	Pulmonalvaskulaerer Widerstandsindex	PVRI	Pulmunaler Gefäßwiderstandsindex 	dynes x sek/cm-5/m2	dyn.s/(cm5.m2)	6	Decimal_6_3	8834-4	https://loinc.org/8834-4/	276902009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=276902009	0	14127
101444	1	Patient	Positv Endexpiratorischer Druck	Beatmung_Messung_IntrinsicPEEP	Intrinsic PEEP	mbar	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	9989
106332	1	Patient	Blutfluss Cardiovasculaeres Geraet	CardioHelpMaquet_MS_Blutfluss	\N	L/Min	L/min	6	Decimal_6_3	\N	\N	444479000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=444479000	0	8502
103254	1	Patient	Dauer Haemodialysesitzung	Nierenverfahren_VO_4008HS_Dialysezeit	\N	h:min	h	6	Decimal_6_3	\N	\N	445940005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=445940005	0	3733
103323	1	Patient	Mechanische Atemfrequenz Beatmet	Beatmung_MS_Evita4_frequenz	gemessene Gesamtatemfrequenz	bpm	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	3620
104985	1	Patient	Ionisiertes Kalzium Nierenersatzverfahren	NEV_CRRT_Doku_CalciumLoesung	\N	\N	mmol/L	19	BarValue	83064-6	https://loinc.org/83064-6/	\N	\N	0	\N
104727	1	Patient	Mechanische Atemfrequenz Beatmet	Beatmung_MS_Pallas_Frequenz	Gemessene Atemfrequenz.	1/min	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	3493
13	1	Patient	Koerpergewicht	COPRA_Patient_Bezugsgewicht	Bezugsgewicht des Patienten in kg	kg	kg	6	Decimal_6_3	29463-7	https://loinc.org/29463-7/	\N	\N	0	\N
102874	1	Patient	Linksventrikulaeres Schlagvolumen	Beatmung_ES_VisionA_Schlagvolumen	Schlagvolumen (SV) in engl. (cycle volume)	ml	/mL	6	Decimal_6_3	20562-5	https://loinc.org/20562-5/	\N	\N	0	3395
100776	30	Behandlung	Koerpertemperatur Kern	IstPflege_Koerperkerntemp	\N	\N	Cel	3	String	8329-5	https://loinc.org/8329-5/	\N	\N	0	\N
101030	101007	KlinikTemperaturstatus	Koerpertemperatur Kern	KlinikTemperaturstatus_Kerntemperatur_Wert	\N	\N	Cel	25	GroupedParameterPropertyObject	8329-5	https://loinc.org/8329-5/	\N	\N	0	\N
101274	101030	KlinikTemperaturstatus_Kerntemperatur_Wert	Koerpertemperatur Kern	KlinikTemperaturstatus_Kerntemperatur_Kerntemp	\N	\N	Cel	3	String	8329-5	https://loinc.org/8329-5/	\N	\N	0	\N
101934	101009	KlinikNervensys	Koerpertemperatur Kern	KlinikNervensys_Kerntemperatur_Wert	\N	\N	Cel	25	GroupedParameterPropertyObject	8329-5	https://loinc.org/8329-5/	\N	\N	0	\N
101935	101934	KlinikNervensys_Kerntemperatur_Wert	Koerpertemperatur Kern	KlinikNervensys_Kerntemperatur_Temp	Kerntemperatur	\N	Cel	3	String	8329-5	https://loinc.org/8329-5/	\N	\N	0	\N
105006	1	Patient	Ionisiertes Kalzium Nierenersatzverfahren	NEV_CRRT_VO_CalciumLoesung	\N	\N	mmol/L	3	String	83064-6	https://loinc.org/83064-6/	\N	\N	0	2442
102775	102771	Score_TISS10	Intrakranieller Druck	Score_TISS10_ICPMessung	\N	\N	mm[Hg]	27	SubScore	60956-0	https://loinc.org/60956-0/	250844005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250844005	0	\N
104052	104041	Score_TISS28_Aufnahme	Intrakranieller Druck	TISS28_ICPMessung_Aufnahme	\N	\N	mm[Hg]	27	SubScore	60956-0	https://loinc.org/60956-0/	250844005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250844005	0	\N
104264	1	Patient	Positv Endexpiratorischer Druck	Beatmung_ES_Servoi_PEEP	PEEP 	[cmH2O]	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	2515
103214	1	Patient	Sauerstofffraktion Eingestellt	Beatmung_ES_3100B_O2Konzentration	Einstellwert: O2 Konzentration des Gasgemisches	%	\N	6	Decimal_6_3	19994-3	https://loinc.org/19994-3/	\N	\N	0	2225
106784	1	Patient	Sauerstoffgasfluss	Beatmung_ES_Optiflow_O2Flow	\N	l/min	L/min	6	Decimal_6_3	19941-4	https://loinc.org/19941-4/	\N	\N	0	1437
103091	1	Patient	Sauerstoffgasfluss	Beatmung_ES_CF800_SauerstoffFlow	Einstellgröße Gasfluss Sauerstoff	l/min	L/min	6	Decimal_6_3	19941-4	https://loinc.org/19941-4/	\N	\N	0	1396
101625	1	Patient	Maximaler Beatmungsdruck	Beatmung_VO_Pmax	\N	\N	cm[H2O]	30	Decimal_6_3Order	76531-3	https://loinc.org/76531-3/	\N	\N	0	\N
101635	1	Patient	Maximaler Beatmungsdruck	Beatmung_Proc_Pmax	\N	\N	cm[H2O]	32	Decimal_6_3Procedure	76531-3	https://loinc.org/76531-3/	\N	\N	0	\N
104249	1	Patient	Mittlerer Beatmungsdruck	Beatmung_MS_Servoi_Pmean	Mittlerer Atemwegsdruck 	[cmH2O]	cm[H2O]	6	Decimal_6_3	76530-5	https://loinc.org/76530-5/	\N	\N	0	1020
103282	1	Patient	Maximaler Beatmungsdruck	Beatmung_MS_Evita2_Pmax	gemessener Beatmungsspitzendruck	mbar	cm[H2O]	6	Decimal_6_3	76531-3	https://loinc.org/76531-3/	\N	\N	0	\N
101322	20	Fall	Koerpergewicht	Patient_AufnGewicht	Aufnahmegewicht (fallbezogen)	\N	kg	6	Decimal_6_3	29463-7	https://loinc.org/29463-7/	\N	\N	0	1019
110879	1	Patient	Maximaler Beatmungsdruck	Beatmung_ES_T1_Pmax	\N	mbar	cm[H2O]	6	Decimal_6_3	76531-3	https://loinc.org/76531-3/	\N	\N	0	\N
100099	1	Patient	Mechanische Atemfrequenz Beatmet	Beatmung_Messung_Frequenz	Frequenz tot.	1/min	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	\N
104995	1	Patient	Ionisiertes Kalzium Nierenersatzverfahren	NEV_CRRT_VO_Multi_CalciumFiltrat	\N	\N	mmol/L	6	Decimal_6_3	83064-6	https://loinc.org/83064-6/	\N	\N	0	869
104150	1	Patient	Sauerstoffgasfluss	Beatmung_ES_Airvo_O2Flow	Dokumentation des eingestellten O2 Flusses, welcher am Gerät Airvo angeschlossen ist.	L/min	L/min	6	Decimal_6_3	19941-4	https://loinc.org/19941-4/	\N	\N	0	862
103287	1	Patient	Mechanische Atemfrequenz Beatmet	Beatmung_MS_Evita2_frequenz	gemessene Atemfrequenz	bpm	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	\N
104245	1	Patient	Mechanische Atemfrequenz Beatmet	Beatmung_MS_Servoi_AF	Atemfrequenz 	[AZ/min]	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	709
102186	1	Patient	Linksventrikulaeres Schlagvolumen	VigilanceC_SV	Schlagvolumen	\N	/mL	6	Decimal_6_3	20562-5	https://loinc.org/20562-5/	\N	\N	0	462
108019	1	Patient	Mechanische Atemfrequenz Beatmet	P_Beatmung_MS_C3_fTotal	Gesamtatemfrequenz	bpm	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	370
104032	1	Patient	Horowitz In Arteriellem Blut	Beatmung_MS_HorowitzINPULS	Messung des Horowitz-Indexes	\N	mm[Hg]	6	Decimal_6_3	50984-4	https://loinc.org/50984-4/	\N	\N	0	291
103126	1	Patient	Sauerstofffraktion Eingestellt	Beatmung_ES_BiPAPV_O2Konzentration	Einstellparameter: O2 Konzentration des Gasgemisches	%	\N	6	Decimal_6_3	19994-3	https://loinc.org/19994-3/	\N	\N	0	275
100264	1	Patient	Maximaler Beatmungsdruck	Beatmung_Einstellung_Pmax	Pmax, Maximaldruck	mbar	cm[H2O]	6	Decimal_6_3	76531-3	https://loinc.org/76531-3/	\N	\N	0	254
102030	1	Patient	Linksventrikulaeres Schlagvolumen	SV	Schlagvolumen 	ml	/mL	3	String	20562-5	https://loinc.org/20562-5/	\N	\N	0	11899
1273	1	Patient	Periphere Artierielle Sauerstoffsaettigung ICU	SaO2	arterielle Sauerstoffsättigung	%	%	6	Decimal_6_3	2708-6	https://loinc.org/2708-6/	\N	\N	0	\N
102018	1	Patient	Pulmonalarterieller Wedge Druck	PWP	Pulmunaler Wedgedruck	mmHg	mm[Hg]	6	Decimal_6_3	75994-4	https://loinc.org/75994-4/	118433006	https://browser.ihtsdotools.org/?perspective=full&conceptId1=118433006	0	1848
11	1	Patient	Kopfumfang	COPRA_Patient_Kopfumfang	Kopfumfang des Patienten in Zentimetern	cm	cm	6	Decimal_6_3	9843-4	https://loinc.org/9843-4/	363811000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=363811000	0	1191
104248	1	Patient	Positv Endexpiratorischer Druck	Beatmung_MS_Servoi_PEEP	Positiver Endexsp. Druck 	[cmH2O]	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	912
100100	1	Patient	Sauerstofffraktion	Beatmung_Messung_FiO2	FiO2	%	\N	6	Decimal_6_3	71835-3	https://loinc.org/71835-3/	\N	\N	0	12360
104283	1	Patient	Mechanische Atemfrequenz Beatmet	Beatmung_ES_Servoi_Frequenz	Atemfrequenz 	[n/min]	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	253
14	1	Patient	Koerpergewicht	COPRA_Patient_Geburtsgewicht	Geburtsgewicht des Patienten in Kilogramm	kg	kg	6	Decimal_6_3	29463-7	https://loinc.org/29463-7/	\N	\N	0	236
103127	1	Patient	Mechanische Atemfrequenz Beatmet	Beatmung_MS_BiPAPV_AF	Messparameter: gemessene Atemfrequenz	AZ/min	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	226
108018	1	Patient	Spontane Mechanische Atemfrequenz Beatmet	P_Beatmung_MS_C3_fSpontan	Spontane Atemfrequenz	bpm	/min	6	Decimal_6_3	19840-8	https://loinc.org/19840-8/	\N	\N	0	194
108018	1	Patient	Spontane Atemfrequenz Beatmet	P_Beatmung_MS_C3_fSpontan	Spontane Atemfrequenz	bpm	/min	6	Decimal_6_3	\N	\N	\N	\N	0	194
103054	1	Patient	Ionisiertes Kalzium Nierenersatzverfahren	Nierenverfahren_VO_Multi_Calcium	Ca-rate	mmol/l	mmol/L	6	Decimal_6_3	83064-6	https://loinc.org/83064-6/	\N	\N	0	165
102861	1	Patient	Maximaler Beatmungsdruck	Beatmung_MS_BiPAPV_Pimax	Pimax (Maximaler inspiratorischer Atemwegsdruck)  	cm H2O	cm[H2O]	6	Decimal_6_3	76531-3	https://loinc.org/76531-3/	\N	\N	0	150
101619	1	Patient	Sauerstofffraktion	Beatmung_VO_FiO2	\N	\N	\N	30	Decimal_6_3Order	71835-3	https://loinc.org/71835-3/	\N	\N	0	\N
101629	1	Patient	Sauerstofffraktion	Beatmung_Proc_FiO2	\N	\N	\N	32	Decimal_6_3Procedure	71835-3	https://loinc.org/71835-3/	\N	\N	0	\N
103435	1	Patient	Spontane Mechanische Atemfrequenz Beatmet	Beatmung_MS_Avea_SpontAF	gemessene spontane Atemfrequenz	bpm	/min	6	Decimal_6_3	19840-8	https://loinc.org/19840-8/	\N	\N	0	84
103435	1	Patient	Spontane Atemfrequenz Beatmet	Beatmung_MS_Avea_SpontAF	gemessene spontane Atemfrequenz	bpm	/min	6	Decimal_6_3	\N	\N	\N	\N	0	84
102181	1	Patient	Systemischer Vaskulaerer Widerstandsindex	Vigileo_SVRI	Systemic vascular resistance index	dyne-s-m²/cm5	dyn.s/(cm5.m2)	6	Decimal_6_3	8837-7	https://loinc.org/8837-7/	276900001	https://browser.ihtsdotools.org/?perspective=full&conceptId1=276900001	0	175
100292	1	Patient	Positv Endexpiratorischer Druck	Beatmung_Messung_intermPEEP	\N	mbar	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	\N
103130	1	Patient	Sauerstofffraktion	Beatmung_MS_BiPAPV_O2Konzentration	Messwert: gemessene O2 Konzentration des Gasgemisches	%	\N	6	Decimal_6_3	71835-3	https://loinc.org/71835-3/	\N	\N	0	145
103281	1	Patient	Sauerstofffraktion	Beatmung_MS_Evita2_O2Konzentration	gemessene O2 Konzentration im Inspirationsgas	Vol %	\N	6	Decimal_6_3	71835-3	https://loinc.org/71835-3/	\N	\N	0	\N
103133	1	Patient	Einstellung Einatmungszeit Beatmung	Beatmung_ES_BiPAPV_Inspirationszeit	Einstellwert: Zeiteinstellung für die Inspirationszeit	s	s	6	Decimal_6_3	76334-2	https://loinc.org/76334-2/	\N	\N	0	82
100104	1	Patient	Eingestellter Inspiratorischer Gasfluss	Beatmung_Einstellung_Flow	Inspiratorische Flowrate	l/min	L/min	6	Decimal_6_3	76275-7	https://loinc.org/76275-7/	\N	\N	0	77
110838	1	Patient	Sauerstofffraktion	P_Beatmung_ES_3100A_O2Konzentration	O2 Konzentration des Gasgemisches	\N	\N	6	Decimal_6_3	71835-3	https://loinc.org/71835-3/	\N	\N	0	\N
103413	1	Patient	Sauerstofffraktion Eingestellt	Beatmung_ES_Avea_FiO2	eingestellte Sauerstoffkonzentration des inspiratorischen Atemgases	%	\N	6	Decimal_6_3	19994-3	https://loinc.org/19994-3/	\N	\N	0	74
103439	1	Patient	Sauerstofffraktion	Beatmung_MS_Avea_FiO2	gemessene Sauerstoffkonzentration im Atemgas	%	\N	6	Decimal_6_3	71835-3	https://loinc.org/71835-3/	\N	\N	0	66
103430	1	Patient	Mechanische Atemfrequenz Beatmet	Beatmung_MS_Avea_Frequenz	gemessene Atemfrequenz	bpm	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	64
104161	1	Patient	Sauerstofffraktion	Beatmung_ES_Zephyros_FIO2	\N	%	\N	6	Decimal_6_3	71835-3	https://loinc.org/71835-3/	\N	\N	0	56
104770	1	Patient	Sauerstoffgasfluss	Beatmung_ES_Pallas_FrischgasFlow	Gesamt Frischgasfluss (Summe aus O2 + AIR)	L/min	L/min	6	Decimal_6_3	19941-4	https://loinc.org/19941-4/	\N	\N	0	\N
105041	1	Patient	Sauerstoffgasfluss	AT_O2Flow	\N	l/min	L/min	26	ApparatusBar	19941-4	https://loinc.org/19941-4/	\N	\N	0	\N
113046	1	Patient	Sauerstoffgasfluss	Beatmung_ES_T1_Flow	Einstellung Sauerstoff Flow	L/min	L/min	6	Decimal_6_3	19941-4	https://loinc.org/19941-4/	\N	\N	0	\N
104173	1	Patient	Maximaler Beatmungsdruck	Beatmung_ES_Zephyros_Pmax	\N	cm H20	cm[H2O]	6	Decimal_6_3	76531-3	https://loinc.org/76531-3/	\N	\N	0	36
103291	1	Patient	Spontane Atemfrequenz Beatmet	Beatmung_MS_Evita2_frequenzspon	gemessene spontane Atemfrequenz	bpm	/min	6	Decimal_6_3	\N	\N	\N	\N	0	\N
103325	1	Patient	Mechanische Atemfrequenz Beatmet	Beatmung_MS_Evita4_fmand	gemessene mandatorische Atemfrequenz	bpm	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	33
104792	1	Patient	Exspiratorischer Gasfluss	Beatmung_MS_C2_ExspFlow	\N	\N	L/min	6	Decimal_6_3	60792-9	https://loinc.org/60792-9/	\N	\N	0	30
107841	1	Patient	Spontane Atemfrequenz Beatmet	Beatmung_MS_Leoni_Freq_Spontan	\N	1/min	/min	6	Decimal_6_3	\N	\N	\N	\N	0	\N
103291	1	Patient	Spontane Mechanische Atemfrequenz Beatmet	Beatmung_MS_Evita2_frequenzspon	gemessene spontane Atemfrequenz	bpm	/min	6	Decimal_6_3	19840-8	https://loinc.org/19840-8/	\N	\N	0	\N
103218	1	Patient	Dauer Haemodialysesitzung	Nierenverfahren_VO_4008onl_Dialysezeit	\N	h:min	h	6	Decimal_6_3	\N	\N	445940005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=445940005	0	78
102192	1	Patient	Pulmonalvaskulaerer Widerstandsindex	VigilanceC_PVRI	Pulmonaler vasculärer Widerstandsindex	\N	dyn.s/(cm5.m2)	6	Decimal_6_3	8834-4	https://loinc.org/8834-4/	276902009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=276902009	0	77
1267	1	Patient	Atemfrequenz	AF	Atemfrequenz	1/min	/min	6	Decimal_6_3	9279-1	https://loinc.org/9279-1/	86290005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=86290005	0	11360118
100098	1	Patient	Beatmungsvolumen Pro Minute Maschineller Beatmung	Beatmung_Messung_MV	Mindest Volumen tot.	L/min	L/min	6	Decimal_6_3	76009-0	https://loinc.org/76009-0/	426102006	https://browser.ihtsdotools.org/?perspective=full&conceptId1=426102006	0	108636
103010	1	Patient	Arterieller Druck	Nierenverfahren_MS_Multi_artDruck	arterieller Druck	mmHg	mm[Hg]	6	Decimal_6_3	\N	\N	386534000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=386534000	0	97677
103320	1	Patient	Beatmungsvolumen Pro Minute Maschineller Beatmung	Beatmung_MS_Evita4_MV	gemessenes Atemminutenvolumen	L/min	L/min	6	Decimal_6_3	76009-0	https://loinc.org/76009-0/	426102006	https://browser.ihtsdotools.org/?perspective=full&conceptId1=426102006	0	3739
104726	1	Patient	Atemzugvolumen Waehrend Beatmung	Beatmung_MS_Pallas_Vt	Gemessenes Tidalvolumen.	ml	mL	6	Decimal_6_3	76222-9	https://loinc.org/76222-9/	250874002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250874002	0	3394
102036	1	Patient	Linksventrikulaeres Schlagvolumenindex	p-SVI	Schlagvolumenindex  (PICCO Modul Dräger Monitoring)	ml/m2	mL/m2	6	Decimal_6_3	76297-1	https://loinc.org/76297-1/	277381004	https://browser.ihtsdotools.org/?perspective=full&conceptId1=277381004	0	869963
102179	1	Patient	Linksventrikulaeres Schlagvolumenindex	Vigileo_SVI	SchlagvolumenindexSchlagvolumenindex	ml/b/m²ml/b/m²	mL/m2	6	Decimal_6_3	76297-1	https://loinc.org/76297-1/	277381004	https://browser.ihtsdotools.org/?perspective=full&conceptId1=277381004	0	4161
100093	1	Patient	Arterieller Druck	ABP_1	arterieller Blutdruck 1	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	386534000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=386534000	0	16463153
100094	1	Patient	Blutdruck	NBP_1	nichtinvasiver Blutdruck 1	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	4332392
100089	1	Patient	Arterieller Druck	ABP_2	zweiter arterieller Blutdruck	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	386534000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=386534000	0	446834
104356	1	Patient	Blutdruck	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.	\N	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	9561
106468	1	Patient	Blutdruck	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP	\N	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	8752
108503	1	Patient	Blutdruck	P_NBP_liBein	Nichtinvaiver Blutdruck linkes Bein	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	514
102162	1	Patient	Arterieller Druck	PICCO_ABP	Arterieller Druck	\N	mm[Hg]	12	Medic_Pressure	\N	\N	386534000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=386534000	0	63
100275	1	Patient	Positv Endexpiratorischer Druck	Beatmung_Messung_PEEP	\N	mbar	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	108942
108021	1	Patient	Endexpiratorischer Kohlendioxidpartialdruck	P_Beatmung_MS_C3_petCO2	Endtidaler CO2-Partialdruck	mmHg	mm[Hg]	6	Decimal_6_3	19891-1	https://loinc.org/19891-1/	250784008	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250784008	0	\N
102047	1	Patient	Pulmonalvaskulaerer Widerstandsindex	PVPI	Pulmonalvaskuläer Permeabilitätsindex 	\N	dyn.s/(cm5.m2)	6	Decimal_6_3	8834-4	https://loinc.org/8834-4/	276902009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=276902009	0	37642
103817	1	Patient	Exspiratorischer Sauerstoffpartialdruck	PtiO2Druck	Gemessener Sauerstoffpartialdruck im Parenchym	mmHg	mm[Hg]	12	Medic_Pressure	3147-6	https://loinc.org/3147-6/	250775008	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250775008	0	295225
108506	1	Patient	Blutdruck	P_NBP_reArm	Nichtinvasiver Blutdruck rechter Arm	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	537
108504	1	Patient	Blutdruck	P_NBP_reBein	Nichtinvasiver Blutdruck rechtes Bein	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	488
108505	1	Patient	Blutdruck	P_NBP_liArm	Nichtinvasiver Blutdruck linker Arm	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	396
103943	1	Patient	Positv Endexpiratorischer Druck	Beatmung_ES_Heimbeatmung_Peep	\N	mbar	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	5819
100047	100000	TISS28	Intrakranieller Druck	TISS28_TS_ICPMessung	\N	\N	mm[Hg]	27	SubScore	60956-0	https://loinc.org/60956-0/	250844005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250844005	0	\N
101956	101947	Score_TISS28	Intrakranieller Druck	Score_TISS28_ICPMessung	\N	\N	mm[Hg]	27	SubScore	60956-0	https://loinc.org/60956-0/	250844005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250844005	0	\N
104203	104197	Score_TISS10_Aufnahme	Intrakranieller Druck	TISS10_ICPMessung_Aufnahme	\N	\N	mm[Hg]	27	SubScore	60956-0	https://loinc.org/60956-0/	250844005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250844005	0	\N
110923	1	Patient	Intrakranieller Druck	ICP1	intracranieller Druck	mmHg	mm[Hg]	12	Medic_Pressure	60956-0	https://loinc.org/60956-0/	250844005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250844005	0	\N
1275	1	Patient	Blutdruck	NBP	nichtinvasiver Blutdruck	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	8
110796	1	Patient	Haemodialyse Blutfluss	P_NEV_HD_ES_5008onl_Blutfluss	\N	\N	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	3352
104725	1	Patient	Beatmungsvolumen Pro Minute Maschineller Beatmung	Beatmung_MS_Pallas_MV	Gemessenes Atemminutenvolumen.	L/min	L/min	6	Decimal_6_3	76009-0	https://loinc.org/76009-0/	426102006	https://browser.ihtsdotools.org/?perspective=full&conceptId1=426102006	0	3451
103146	1	Patient	Dauer Haemodialysesitzung	Nierenverfahren_ES_4008HS_DialyseZeit	\N	h:min	h	6	Decimal_6_3	\N	\N	445940005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=445940005	0	3395
103318	1	Patient	Positv Endexpiratorischer Druck	Beatmung_MS_Evita4_PEEP	gemessener positiver endexspiratorischer Druck	mbar	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	3388
101323	20	Fall	Koerpergroesse	Patient_AufnGroesse	Größe Patient (fallbezogen)	\N	cm	6	Decimal_6_3	\N	\N	50373000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=50373000	0	\N
105243	30	Behandlung	Koerpergroesse	B_Aufnahmegroesse	Dokumentation der Patientengröße bei Aufnahme.	\N	cm	3	String	\N	\N	50373000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=50373000	0	\N
106467	30	Behandlung	Koerpergroesse	B_Aufnahmegroesse_Wert	\N	\N	cm	6	Decimal_6_3	\N	\N	50373000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=50373000	0	\N
108250	30	Behandlung	Koerpergroesse Percentil	B_Aufnahme_Perzentile_Groesse	\N	\N	%	6	Decimal_6_3	8303-0	https://loinc.org/8303-0/	1153605006	https://browser.ihtsdotools.org/?perspective=full&conceptId1=1153605006	0	\N
102051	1	Patient	Herzzeitvolumen	HZV	Herzzeitvolumen	\N	L/min	6	Decimal_6_3	8741-1	https://loinc.org/8741-1/	82799009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=82799009	0	3339
101763	1	Patient	Kopfumfang	Patient_Kopfumfang	Kopfumfang des Patienten (Kinder)	\N	cm	3	String	9843-4	https://loinc.org/9843-4/	363811000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=363811000	0	\N
100091	1	Patient	Linksatrialer Druck	LAP	Linksatrial  Mitteldruck	mmHg	mm[Hg]	6	Decimal_6_3	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	3189
104722	1	Patient	Positv Endexpiratorischer Druck	Beatmung_MS_Pallas_PEEP	Dokumentation des gemessenen PEEPs.	mbar	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	3127
102055	1	Patient	Linksventrikulaerer Druck	LVP	Linksventrikulärer Mitteldruck	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	6
102016	1	Patient	Rechtsatrialer Druck	RAP	Rechtsatrial Mitteldruck	mmHg	mm[Hg]	6	Decimal_6_3	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	835
102651	1	Patient	Dauer Haemodialysesitzung	Nierenersatzverfahren_Einstell_DialyseZeit	\N	\N	h	6	Decimal_6_3	\N	\N	445940005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=445940005	0	793
108502	1	Patient	Kopfumfang	Patient_Kopfumfang_bit	Kopfumfang bit cm	cm	cm	6	Decimal_6_3	9843-4	https://loinc.org/9843-4/	363811000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=363811000	0	781
103205	1	Patient	Dauer Haemodialysesitzung	Nierenverfahren_ES_4008onl_Dialysezeit	\N	h:min	h	6	Decimal_6_3	\N	\N	445940005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=445940005	0	439
102675	1	Patient	Dauer Haemodialysesitzung	Nierenersatzverfahren_VO_DialyseZeit	\N	\N	h	6	Decimal_6_3	\N	\N	445940005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=445940005	0	418
102190	1	Patient	Systemischer Vaskulaerer Widerstandsindex	VigilanceC_SVRI	Systemischer Gefäßwiderstandsindex	\N	dyn.s/(cm5.m2)	6	Decimal_6_3	8837-7	https://loinc.org/8837-7/	276900001	https://browser.ihtsdotools.org/?perspective=full&conceptId1=276900001	0	163
103006	1	Patient	Substituatfluss	Nierenverfahren_ES_ADM_Austauschrate	Umsatz, Substituat	ml/h	mL/h	6	Decimal_6_3	\N	\N	708513005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=708513005	0	88
103284	1	Patient	Positv Endexpiratorischer Druck	Beatmung_MS_Evita2_Ppeep	gemessener positer endexspiratorischer Druck	mbar	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	\N
104190	1	Patient	Positv Endexpiratorischer Druck	Beatmung_MS_Zephyros_Ppeepi	\N	cm H2O	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	\N
107815	1	Patient	Positv Endexpiratorischer Druck	Beatmung_ES_Leoni_PEEP	\N	cmH2O	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	\N
102019	1	Patient	Pulmonalarterieller Blutdruck	PAM	Mittlerer pulmonale arterieller Druck	mmHg	mm[Hg]	6	Decimal_6_3	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	\N
102173	1	Patient	Herzzeitvolumen	PICCO_HZV	Herzzeitvolumen	\N	L/min	6	Decimal_6_3	8741-1	https://loinc.org/8741-1/	82799009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=82799009	0	114
102163	1	Patient	Zentralvenoeser Blutdruck	PICCO_ZVD	Zentraler Venendruck	\N	mm[Hg]	6	Decimal_6_3	60985-9	https://loinc.org/60985-9/	71420008	https://browser.ihtsdotools.org/?perspective=full&conceptId1=71420008	0	89
102015	1	Patient	Rechtsventrikulaerer Druck	RVP	Rechtsventrikulärer Mitteldruck	mmHg	mm[Hg]	6	Decimal_6_3	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	\N
102050	1	Patient	Pulmonalarterieller Blutdruck	PAP	Pulmunalarterieller Druck	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	441466
110921	1	Patient	Rechtsatrialer Druck	RAP1	rechtsartrialer Druck	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	1
102056	1	Patient	Rechtsventrikulaerer Druck	RVP	Rechtsventrikulärer Mitteldruck	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	1
103235	1	Patient	Haemodialyse Blutfluss	Nierenverfahren_VO_4008onl_BlutflussSNPumpe	\N	ml/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	\N
104872	1	Patient	Haemodialyse Blutfluss	NEV_HD_MS_4008HS_effBlutfluss	\N	\N	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	12533
117163	1	Patient	Haemodialyse Blutfluss	P_NEV_HD_ES_Genius_Blutfluss	\N	\N	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	163
103432	1	Patient	Spontanes Atemzugvolumen	Beatmung_MS_Avea_SpontVte	gemessenes spontanes Tidalvolumen	L	mL	6	Decimal_6_3	20116-0	https://loinc.org/20116-0/	250816009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250816009	0	65
104243	1	Patient	Beatmungsvolumen Pro Minute Maschineller Beatmung	Beatmung_MS_Servoi_MVi	Insp. Minutenvolumen 	[l/min]	L/min	6	Decimal_6_3	76009-0	https://loinc.org/76009-0/	426102006	https://browser.ihtsdotools.org/?perspective=full&conceptId1=426102006	0	54
103425	1	Patient	Positv Endexpiratorischer Druck	Beatmung_MS_Avea_PEEP	gemessenes PEEP Niveau	cmH2O	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	53
104168	1	Patient	Positv Endexpiratorischer Druck	Beatmung_ES_Zephyros_Peep	\N	mbar	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	45
102024	1	Patient	Linksventrikulaerer Herzindex	LVSAI	Linksventrikulärer Schlagarbeitsindex 	g x m/m2	L/(min.m2)	6	Decimal_6_3	75919-1	https://loinc.org/75919-1/	54993008	https://browser.ihtsdotools.org/?perspective=full&conceptId1=54993008	0	28
104236	1	Patient	Dynamische Kompliance	Beatmung_MS_Servoi_Cdyn	Dynamische Charakteristika 	[ml/cmH2O]	mL/cm[H2O]	6	Decimal_6_3	60827-3	https://loinc.org/60827-3/	250823005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250823005	0	22
103142	1	Patient	Positv Endexpiratorischer Druck	Beatmung_MS_VisionA_PEEP	Messwert: gemessener positiver endexspiratorischer Druck	cmH2O	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	20
102165	1	Patient	Systemischer Vaskulaerer Widerstandsindex	PICCO_SVRI	Systemic vascular resistance index	\N	dyn.s/(cm5.m2)	6	Decimal_6_3	8837-7	https://loinc.org/8837-7/	276900001	https://browser.ihtsdotools.org/?perspective=full&conceptId1=276900001	0	23
104888	1	Patient	Haemodialyse Blutfluss	NEV_HD_ES_4008HS_Blutfluss	\N	\N	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	7997
102979	1	Patient	Substituatvolumen	Nierenverfahren_ES_Multi_SubstituatBolus	Substituatbolus ml	\N	L	6	Decimal_6_3	\N	\N	708514004	https://browser.ihtsdotools.org/?perspective=full&conceptId1=708514004	0	76
100271	1	Patient	Beatmungsvolumen Pro Minute Maschineller Beatmung	Beatmung_Messung_AMV	Respiratory Minute Volume	L/min	L/min	6	Decimal_6_3	76009-0	https://loinc.org/76009-0/	426102006	https://browser.ihtsdotools.org/?perspective=full&conceptId1=426102006	0	419
103132	1	Patient	Atemzugvolumen Waehrend Beatmung	Beatmung_MS_BiPAPV_Vt	Messwert: gemessenes Tidalvolumen	ml	mL	6	Decimal_6_3	76222-9	https://loinc.org/76222-9/	250874002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250874002	0	209
110915	1	Patient	Zeitverhaeltnis Ein Ausatmung	Beatmung_MS_Servoi_I_E	I:E Verhältnis (Messung)	\N	{ratio}	3	String	75931-6	https://loinc.org/75931-6/	250822000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250822000	0	\N
103084	1	Patient	Atemzugvolumen Waehrend Beatmung	Beatmung_MS_VisionA_Tidalvolumen	gemessenes Tidalvolumen	ml	mL	6	Decimal_6_3	76222-9	https://loinc.org/76222-9/	250874002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250874002	0	19
102926	1	Patient	Zeitverhaeltnis Ein Ausatmung	Beatmung_MS_G5_IEVerhaeltnis	gemessenes I:E Verhältnis	\N	{ratio}	3	String	75931-6	https://loinc.org/75931-6/	250822000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250822000	0	1342180
103266	1	Patient	Zeitverhaeltnis Ein Ausatmung	Beatmung_MS_VisionA_IEVerhaeltnis	Messwert: gemessenes I:E Verhältnis	\N	{ratio}	3	String	75931-6	https://loinc.org/75931-6/	250822000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250822000	0	5
103426	1	Patient	Zeitverhaeltnis Ein Ausatmung	Beatmung_MS_Avea_IE	gemessenes I zu E Verhältnis	Verhältnis	{ratio}	3	String	75931-6	https://loinc.org/75931-6/	250822000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250822000	0	4
107876	1	Patient	Zeitverhaeltnis Ein Ausatmung	Beatmung_MS_T1_IEVerhaeltnis	gemessenes I:E Verhältnis	\N	{ratio}	3	String	75931-6	https://loinc.org/75931-6/	250822000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250822000	0	1
102967	1	Patient	Substituatfluss	Nierenverfahren_VO_ADM_Austauschrate	Umsatz, Austausch; Substituat ml/h	\N	mL/h	6	Decimal_6_3	\N	\N	708513005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=708513005	0	\N
104929	1	Patient	Haemodialyse Blutfluss	NEV_HD_VO_4008onl_BlutflussSNPumpe	\N	\N	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	\N
103169	1	Patient	Haemodialyse Blutfluss	Nierenverfahren_MS_4008HS_effBlutfluss	\N	ml/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	5523
103152	1	Patient	Haemodialyse Blutfluss	Nierenverfahren_ES_4008HS_Blutfluss	\N	ml/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	3794
110777	1	Patient	Haemodialyse Blutfluss	P_NEV_HD_MS_5008onl_effBlutfluss	\N	\N	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	2563
103200	1	Patient	Haemodialyse Blutfluss	Nierenverfahren_MS_4008onl_effBlutfluss	\N	ml/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	1148
104863	1	Patient	Haemodialyse Blutfluss	NEV_HD_MS_4008onl_effBlutfluss	\N	\N	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	619
103180	1	Patient	Haemodialyse Blutfluss	Nierenverfahren_ES_4008onl_Blutfluss	\N	ml/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	516
104907	1	Patient	Haemodialyse Blutfluss	NEV_HD_ES_4008onll_Blutfluss	\N	\N	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	476
104887	1	Patient	Haemodialyse Blutfluss	NEV_HD_ES_4008HS_BlutflussSNPumpe	\N	\N	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	86
103220	1	Patient	Haemodialyse Blutfluss	Nierenverfahren_VO_4008onl_Blutfluss	\N	ml/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	53
103153	1	Patient	Haemodialyse Blutfluss	Nierenverfahren_ES_4008HS_BlutflussSNPumpe	\N	ml/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	36
103181	1	Patient	Haemodialyse Blutfluss	Nierenverfahren_ES_4008onl_BlutflussSNPumpe	\N	ml/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	3
104906	1	Patient	Haemodialyse Blutfluss	NEV_HD_ES_4008onl_BlutflussSNPumpe	\N	\N	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	1
103443	1	Patient	Positv Endexpiratorischer Druck	Beatmung_MS_Avea_AutoPEEP	gemessener AutoPEEP	cmH2O	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	1
103246	1	Patient	Haemodialyse Blutfluss	Nierenverfahren_VO_4008HS_BlutflussSNPumpe	\N	ml/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	1
102941	1	Patient	Substituatvolumen	Nierenverfahren_VO_Multi_SubstituatBolus	Substituatbolus in ml	\N	L	6	Decimal_6_3	\N	\N	708514004	https://browser.ihtsdotools.org/?perspective=full&conceptId1=708514004	0	16
104418	104403	Praemedikation	Blutdruck Generisch	Praemedikation_Präanästh_Anordnung_Einheiten_EB	Präanästhetische Anordnung: Anzahl der anzufordernden Einheiten an Eigenblut.	\N	mm[Hg]	3	String	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	\N
104555	104403	Praemedikation	Blutdruck Generisch	Praemedikation_Blutdruck	Dokumentation des Blutdruckes.	\N	mm[Hg]	3	String	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	\N
108390	102794	Score_ComfortSkala	Blutdruck Generisch	Score_ComfortSkala_MAD	Mittlerer Arterieller Blutdruck	\N	mm[Hg]	27	SubScore	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	\N
100094	1	Patient	Blutdruck Generisch	NBP_1	nichtinvasiver Blutdruck 1	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	4332392
104356	1	Patient	Blutdruck Generisch	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.	\N	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	9561
106468	1	Patient	Blutdruck Generisch	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP	\N	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	8752
108503	1	Patient	Blutdruck Generisch	P_NBP_liBein	Nichtinvaiver Blutdruck linkes Bein	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	514
108506	1	Patient	Blutdruck Generisch	P_NBP_reArm	Nichtinvasiver Blutdruck rechter Arm	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	537
108504	1	Patient	Blutdruck Generisch	P_NBP_reBein	Nichtinvasiver Blutdruck rechtes Bein	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	488
108505	1	Patient	Blutdruck Generisch	P_NBP_liArm	Nichtinvasiver Blutdruck linker Arm	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	396
1275	1	Patient	Blutdruck Generisch	NBP	nichtinvasiver Blutdruck	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	8
102038	1	Patient	Systemischer Vaskulaerer Widerstandsindex	p-SVRI	Index des systemischen Gefäßwiderstandes (PICCO Modul Dräger Monitoring)  	dynes x sek/cm-5/m2	dyn.s/(cm5.m2)	6	Decimal_6_3	8837-7	https://loinc.org/8837-7/	276900001	https://browser.ihtsdotools.org/?perspective=full&conceptId1=276900001	0	778804
100073	1	Patient	Systemischer Vaskulaerer Widerstandsindex	SVRI	Index des systemischen Gefäßwiderstandes 	dynes x sek/cm-5/m2	dyn.s/(cm5.m2)	6	Decimal_6_3	8837-7	https://loinc.org/8837-7/	276900001	https://browser.ihtsdotools.org/?perspective=full&conceptId1=276900001	0	125230
102978	1	Patient	Substituatfluss	Nierenverfahren_ES_Multi_Substituat	Umsatz, Austausch Substituat ml/h	\N	mL/h	6	Decimal_6_3	\N	\N	708513005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=708513005	0	4361
102992	1	Patient	Substituatfluss	Nierenverfahren_ES_BM25_Umsatz	Austausch, Substituat, ml/h	\N	mL/h	6	Decimal_6_3	\N	\N	708513005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=708513005	0	1356
102940	1	Patient	Substituatfluss	Nierenverfahren_VO_Multi_Substituat	Substituat in ml/h	\N	mL/h	6	Decimal_6_3	\N	\N	708513005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=708513005	0	220
1269	1	Patient	Zentralvenoeser Blutdruck	ZVD	Zentralvenöser Druck	mmHg	mm[Hg]	6	Decimal_6_3	60985-9	https://loinc.org/60985-9/	71420008	https://browser.ihtsdotools.org/?perspective=full&conceptId1=71420008	0	3579740
103036	1	Patient	Spontane Mechanische Atemfrequenz Beatmet	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz	AZ/min	/min	6	Decimal_6_3	19840-8	https://loinc.org/19840-8/	\N	\N	0	20846232
103324	1	Patient	Spontane Mechanische Atemfrequenz Beatmet	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz	bpm	/min	6	Decimal_6_3	19840-8	https://loinc.org/19840-8/	\N	\N	0	7092
103011	1	Patient	Venoeser Druck	Nierenverfahren_MS_Multi_venDruck	venöser Druck	mmHg	mm[Hg]	6	Decimal_6_3	\N	\N	252076005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=252076005	0	97841
106640	1	Patient	Einstellung Einatmungszeit Beatmung	Beatmung_ES_T1_Ti	Einstelungswert für die Inspirationszeit	s	s	6	Decimal_6_3	76334-2	https://loinc.org/76334-2/	\N	\N	0	16
103265	1	Patient	Mechanische Atemfrequenz Beatmet	Beatmung_MS_VisionA_BreathRate	Messwert: gemessene Atemfrequenz	AZ/min	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	15
107875	1	Patient	Mechanische Atemfrequenz Beatmet	Beatmung_MS_T1_fTotal	Gesamtfrequenz	AZ/min	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	13
107874	1	Patient	Spontane Mechanische Atemfrequenz Beatmet	Beatmung_MS_T1_fSpontan	Spontane Atemfrequenz	AZ/min	/min	6	Decimal_6_3	19840-8	https://loinc.org/19840-8/	\N	\N	0	12
107874	1	Patient	Spontane Atemfrequenz Beatmet	Beatmung_MS_T1_fSpontan	Spontane Atemfrequenz	AZ/min	/min	6	Decimal_6_3	\N	\N	\N	\N	0	12
103260	1	Patient	Einstellung Einatmungszeit Beatmung	Beatmung_ES_VisionA_Ti	Einstellwert: Inspirationszeit in Sekunden	sec.	s	6	Decimal_6_3	76334-2	https://loinc.org/76334-2/	\N	\N	0	10
103429	1	Patient	Mittlerer Beatmungsdruck	Beatmung_MS_Avea_Mitteldruck	gemessener Atemwegsmitteldruck	cm H2O	cm[H2O]	6	Decimal_6_3	76530-5	https://loinc.org/76530-5/	\N	\N	0	10
103267	1	Patient	Sauerstofffraktion Eingestellt	Beatmung_ES_Evita2_O2Konzentration	eingestellte O2 Konzentration des Gases	Vol %	\N	6	Decimal_6_3	19994-3	https://loinc.org/19994-3/	\N	\N	0	6
103436	1	Patient	Mechanische Atemfrequenz Beatmet	Beatmung_MS_Avea_MandAF	gemessene mandatorische Atemfrequenz	bpm	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	2
103415	1	Patient	Einstellung Einatmungszeit Beatmung	Beatmung_ES_Avea_InspZeit	eingestellte Inspirationszeit eines Atemzuges	sek.	s	6	Decimal_6_3	76334-2	https://loinc.org/76334-2/	\N	\N	0	1
107873	1	Patient	Exspiratorischer Gasfluss	Beatmung_MS_T1_ExspFlow	Exspiratorischer Peakflow	l/min	L/min	6	Decimal_6_3	60792-9	https://loinc.org/60792-9/	\N	\N	0	1
106339	1	Patient	Blutfluss Cardiovasculaeres Geraet	CardioHelpMaquet_VO_Blutfluss	\N	L/Min	L/min	6	Decimal_6_3	\N	\N	444479000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=444479000	0	13
104189	1	Patient	Positv Endexpiratorischer Druck	Beatmung_MS_Zephyros_Ppeep	\N	cm H2O	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	2
110795	1	Patient	Haemodialyse Blutfluss	P_NEV_HD_ES_5008onl_BlutflussSNPumpe	\N	\N	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	17
104942	1	Patient	Haemodialyse Blutfluss	NEV_HD_VO_4008HS_Blutfluss_SN_Pumpe	\N	\N	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	14
110813	1	Patient	Haemodialyse Blutfluss	P_NEV_HD_VO_5008onl_BlutflussSNPumpe	\N	\N	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	4
\.


--
-- Data for Name: mapping_mii_co6_tmp; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.mapping_mii_co6_tmp (conf_var_id, conf_var_parent_id, conf_var_parent_name, profile_name, conf_var_name, conf_var_description, conf_var_unit, profile_unit, conf_var_types_id, conf_var_types_name, loinc, snomed, ieee, matching_valide, quantities, profile_type) FROM stdin;
102011	1	Patient	Puls	PLS	Pulsrate errechnet aus der SpO2 Messung	1/min	\N	6	Decimal_6_3	\N	8499008	\N	t	30000030	Observation
100100	1	Patient	Sauerstofffraktion	Beatmung_Messung_FiO2	FiO2	%	\N	6	Decimal_6_3	71835-3	\N	\N	t	12360	Observation
1268	1	Patient	Puls	Puls	Puls	1/min	\N	6	Decimal_6_3	\N	8499008	\N	t	68448	Observation
110934	1	Patient	Koerpertemperatur Generisch	P_Temperatur_generic	Anlage für Philips Monitoring	°C	Cel	6	Decimal_6_3	8310-5	\N	\N	t	1952044	Observation
110930	1	Patient	Koerpertemperatur rektal	P_Temperatur_Rektal	Anlage im Rahmen Philips Monitoring	°C	Cel	6	Decimal_6_3	8332-9	307047009	\N	t	198068	Observation
110927	1	Patient	Koerpertemperatur nasal	P_Temperatur_Naso	Anlage im Rahmen PhilipsMonitoring	°C	Cel	6	Decimal_6_3	76010-8	\N	\N	t	2183	Observation
110929	1	Patient	Koerpertemperatur Trommelfell	P_Temperatur_Tympanal	Anlage im Rahmen PhilipsMonitoring	°C	Cel	6	Decimal_6_3	8333-7	415974002	\N	t	59195	Observation
110928	1	Patient	Koerpertemperatur Speiseroehre	P_Temperatur_Oesophagial	Anlage im Rahmen PhilipsMonitoring	°C	Cel	6	Decimal_6_3	60836-4	431598003	\N	t	20648	Observation
110925	1	Patient	Koerpertemperatur Blut	P_Temperatur_Arteriell	Anlage im Rahmen PhilipsMonitoring	°C	Cel	6	Decimal_6_3	60834-9	860958002	\N	t	2237	Observation
103716	1	Patient	Koerpertemperatur Blut	TempBT	Bluttemperatur bei der HZV Messung	°C	Cel	6	Decimal_6_3	60834-9	860958002	\N	t	52583	Observation
103078	1	Patient	Druckdifferenz Beatmung	Beatmung_MS_VisionA_Amplitude	gemessene Druckdifferenz im HFOV Modus	cm H2O	cm[H2O]	6	Decimal_6_3	76154-4	\N	152720	t	7040	Observation
102915	1	Patient	Exspiratorischer Gasfluss	Beatmung_MS_G5_ExspFlow	Exspiratorischer Peakflow, ein Monitoring-Parameter	l/min	L/min	6	Decimal_6_3	60792-9	\N	151944	t	734325	Observation
1266	1	Patient	Herzfrequenz	HF	Herzfrequenz	1/min	/min	6	Decimal_6_3	8867-4	\N	147842	t	25851846	Observation
102903	1	Patient	Inspiratorischer Gasfluss	Beatmung_MS_G5_InspFlow	Inspiratorischer Peakflow, ein Monitoring-Parameter	l/min	L/min	6	Decimal_6_3	60794-5	\N	151948	t	2686525	Observation
103010	1	Patient	Arterieller Druck	Nierenverfahren_MS_Multi_artDruck	arterieller Druck	mmHg	mm[Hg]	6	Decimal_6_3	\N	386534000	\N	t	97677	Observation
100089	1	Patient	Arterieller Druck	ABP_2	zweiter arterieller Blutdruck	mmHg	mm[Hg]	12	Medic_Pressure	\N	386534000	\N	t	446834	Observation
100093	1	Patient	Arterieller Druck	ABP_1	arterieller Blutdruck 1	mmHg	mm[Hg]	12	Medic_Pressure	\N	386534000	\N	t	16463153	Observation
1267	1	Patient	Atemfrequenz	AF	Atemfrequenz	1/min	/min	6	Decimal_6_3	9279-1	86290005	\N	t	11360118	Observation
104726	1	Patient	Atemzugvolumen-Waehrend-Beatmung	Beatmung_MS_Pallas_Vt	Gemessenes Tidalvolumen.	ml	mL	6	Decimal_6_3	76222-9	250874002	151980	t	3394	Observation
100098	1	Patient	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	Beatmung_Messung_MV	Mindest Volumen tot.	L/min	L/min	6	Decimal_6_3	76009-0	426102006	152004	t	108636	Observation
103320	1	Patient	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	Beatmung_MS_Evita4_MV	gemessenes Atemminutenvolumen	L/min	L/min	6	Decimal_6_3	76009-0	426102006	152004	t	3739	Observation
103297	1	Patient	Einstellung-Einatmungszeit-Beatmung	Beatmung_ES_Evita4_Tinsp	eingestellte absolute Inspirationszeit	s	s	6	Decimal_6_3	76334-2	\N	152720	t	13393	Observation
102887	1	Patient	Einstellung-Einatmungszeit-Beatmung	Beatmung_ES_G5_Ti	Einstelungswert für die Inspirationszeit	s	s	6	Decimal_6_3	76334-2	\N	152720	t	70600	Observation
110933	1	Patient	Koerpertemperatur Kern	P_Temperatur_Kern	Anlage für Philips Monitoring	°C	Cel	6	Decimal_6_3	8329-5	\N	150368	t	758879	Observation
104758	1	Patient	Linksventrikulaeres Schlagvolumen	Schlagvolumen	gemessenes Schlagvolumen	ml	/mL	6	Decimal_6_3	20562-5	\N	150428	t	274423	Observation
102030	1	Patient	Linksventrikulaeres Schlagvolumen	SV	Schlagvolumen 	ml	/mL	3	String	20562-5	\N	150428	t	11899	Observation
102874	1	Patient	Linksventrikulaeres Schlagvolumen	Beatmung_ES_VisionA_Schlagvolumen	Schlagvolumen (SV) in engl. (cycle volume)	ml	/mL	6	Decimal_6_3	20562-5	\N	150428	t	3395	Observation
102408	1	Patient	Linksventrikulaeres Schlagvolumen	p-SV	Schlagvolumen	ml	/mL	6	Decimal_6_3	20562-5	\N	150428	t	864963	Observation
100300	1	Patient	Maximaler Beatmungsdruck	Beatmung_Messung_Pmax	Peak Airway Pressure	mmHg	cm[H2O]	6	Decimal_6_3	76531-3	\N	151973	t	111043	Observation
102878	1	Patient	Mittlerer Beatmungsdruck	Beatmung_MS_VisionA_MAP	gemessener Mittlerer Atemwegsdruck unter HFO bei Alpha Vision	cm H2O	cm[H2O]	6	Decimal_6_3	76530-5	\N	151975	t	6945	Observation
102873	1	Patient	Mittlerer Beatmungsdruck	Beatmung_ES_VisionA_MAP	Mittlerer Atemwegsdruck (MAP)	cm H2O	cm[H2O]	6	Decimal_6_3	76530-5	\N	151975	t	3863	Observation
104249	1	Patient	Mittlerer Beatmungsdruck	Beatmung_MS_Servoi_Pmean	Mittlerer Atemwegsdruck 	[cmH2O]	cm[H2O]	6	Decimal_6_3	76530-5	\N	151975	t	1020	Observation
6	1	Patient	Koerpergewicht	Patient_Gewicht	Gewicht des Patienten	kg	kg	6	Decimal_6_3	29463-7	\N	\N	t	96050	Observation
101322	20	Fall	Koerpergewicht	Patient_AufnGewicht	Aufnahmegewicht (fallbezogen)	kg	kg	6	Decimal_6_3	29463-7	\N	\N	t	1019	Observation
103058	1	Patient	Ionisiertes Kalzium aus Nierenersatzverfahren	Nierenverfahren_ES_Multi_CalciumFiltrat	Calciumrate	mmol/l	mmol/L	6	Decimal_6_3	83064-6	\N	\N	t	19281	Observation
105006	1	Patient	Ionisiertes Kalzium aus Nierenersatzverfahren	NEV_CRRT_VO_CalciumLoesung	\N	\N	mmol/L	3	String	83064-6	\N	\N	t	2442	Observation
104974	1	Patient	Ionisiertes Kalzium aus Nierenersatzverfahren	NEV_CRRT_ES_Multi_CalciumFiltrat	\N	mmol/L	mmol/L	6	Decimal_6_3	83064-6	\N	\N	t	303169	Observation
100108	1	Patient	Mechanische-Atemfrequenz-Beatmet	Beatmung_Einstellung_AF	Beatmungsfrequenz (f/AF)	1/min	{Breaths}/min	6	Decimal_6_3	33438-3	\N	151586	t	5250	Observation
103035	1	Patient	Mechanische-Atemfrequenz-Beatmet	Beatmung_MS_G5_ftotal	Gesamtatemfrequenz, ein Monitoring Parameter	AZ/min	{Breaths}/min	6	Decimal_6_3	33438-3	\N	151586	t	9577905	Observation
101442	1	Patient	Mechanische-Atemfrequenz-Beatmet	Beatmung_Messung_AF	Breathing Frequency	1/min	{Breaths}/min	6	Decimal_6_3	33438-3	\N	151586	t	108930	Observation
103323	1	Patient	Mechanische-Atemfrequenz-Beatmet	Beatmung_MS_Evita4_frequenz	gemessene Gesamtatemfrequenz	bpm	{Breaths}/min	6	Decimal_6_3	33438-3	\N	151586	t	3620	Observation
104727	1	Patient	Mechanische-Atemfrequenz-Beatmet	Beatmung_MS_Pallas_Frequenz	Gemessene Atemfrequenz.	1/min	{Breaths}/min	6	Decimal_6_3	33438-3	\N	151586	t	3493	Observation
103314	1	Patient	Sauerstofffraktion	Beatmung_MS_Evita4_FiO2	gemessene O2 Konzentration des inspiratorischen Atemgasgemisches	Vol%	\N	6	Decimal_6_3	71835-3	\N	\N	t	3673	Observation
104730	1	Patient	Sauerstofffraktion	Beatmung_MS_Pallas_O2_insp	Gemessene inspiratorische O2 Konzentration.	%	\N	6	Decimal_6_3	71835-3	\N	\N	t	10295	Observation
103216	1	Patient	Sauerstofffraktion	Beatmung_MS_3100B_O2Konzentration	Messwert: gemessene O2 Konzentration des Gasgemisches	%	\N	6	Decimal_6_3	71835-3	\N	\N	t	3718	Observation
103091	1	Patient	Sauerstoffgasfluss	Beatmung_ES_CF800_SauerstoffFlow	Einstellgröße Gasfluss Sauerstoff	l/min	L/min	6	Decimal_6_3	19941-4	\N	\N	t	1396	Observation
106784	1	Patient	Sauerstoffgasfluss	Beatmung_ES_Optiflow_O2Flow	\N	l/min	L/min	6	Decimal_6_3	19941-4	\N	\N	t	1437	Observation
103214	1	Patient	Sauerstofffraktion eingestellt	Beatmung_ES_3100B_O2Konzentration	Einstellwert: O2 Konzentration des Gasgemisches	%	\N	6	Decimal_6_3	19994-3	\N	\N	t	2225	Observation
103296	1	Patient	Sauerstofffraktion eingestellt	Beatmung_ES_Evita4_O2Konzentration	eingestellte O2 Konzentration des Frischgases	%	\N	6	Decimal_6_3	19994-3	\N	\N	t	34154	Observation
100105	1	Patient	Sauerstofffraktion eingestellt	Beatmung_Einstellung_FiO2	O²- Konzentration im Inspirationsgemisch (FiO2)	%	\N	6	Decimal_6_3	19994-3	\N	\N	t	29967	Observation
100270	1	Patient	Spontane-Atemfrequenz-Beatmet	Beatmung_Messung_AFSpontan	Respiratory Rate (spontan)	1/min	/min	6	Decimal_6_3	\N	\N	152498	t	59723	Observation
103324	1	Patient	Spontane-Atemfrequenz-Beatmet	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz	bpm	/min	6	Decimal_6_3	\N	\N	152498	t	7092	Observation
103036	1	Patient	Spontane-Atemfrequenz-Beatmet	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz	AZ/min	/min	6	Decimal_6_3	\N	\N	152498	t	20846232	Observation
103324	1	Patient	Spontane-Mechanische-Atemfrequenz-Beatmet	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz	bpm	/min	6	Decimal_6_3	19840-8	\N	152490	t	7092	Observation
103036	1	Patient	Spontane-Mechanische-Atemfrequenz-Beatmet	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz	AZ/min	/min	6	Decimal_6_3	19840-8	\N	152490	t	20846232	Observation
102010	1	Patient	Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie	SpO2	Sauerstoffsättigung Pulsoxymetrie	%	%	6	Decimal_6_3	59408-5	\N	150456	t	22647295	Observation
100094	1	Patient	Blutdruck	NBP_1	nichtinvasiver Blutdruck 1	mmHg	mm[Hg]	12	Medic_Pressure	\N	75367002	\N	t	4332392	Observation
103254	1	Patient	Dauer Haemodialysesitzung	Nierenverfahren_VO_4008HS_Dialysezeit	\N	h:min	h	6	Decimal_6_3	\N	445940005	\N	t	3733	Observation
103146	1	Patient	Dauer Haemodialysesitzung	Nierenverfahren_ES_4008HS_DialyseZeit	\N	h:min	h	6	Decimal_6_3	\N	445940005	\N	t	3395	Observation
103817	1	Patient	Exspiratorischer Sauerstoffpartialdruck	PtiO2Druck	Gemessener Sauerstoffpartialdruck im Parenchym	mmHg	mm[Hg]	12	Medic_Pressure	3147-6	250775008	153132	t	295225	Observation
11	1	Patient	Kopfumfang	COPRA_Patient_Kopfumfang	Kopfumfang des Patienten in Zentimetern	cm	cm	6	Decimal_6_3	9843-4	363811000	\N	t	1191	Observation
100091	1	Patient	Linksatrialer Druck	LAP	Linksatrial  Mitteldruck	mmHg	mm[Hg]	6	Decimal_6_3	\N	75367002	\N	t	3189	Observation
102039	1	Patient	Linksventrikulaerer Herzindex	dPmax	Index der linken Ventrikelkontraktilität  	mmHg/s	L/(min.m2)	6	Decimal_6_3	75919-1	54993008	149772	t	986335	Observation
102050	1	Patient	Pulmonalarterieller Blutdruck	PAP	Pulmunalarterieller Druck	mmHg	mm[Hg]	12	Medic_Pressure	\N	75367002	\N	t	441466	Observation
102026	1	Patient	Pulmonalvaskulaerer Widerstandsindex	PVRI	Pulmunaler Gefäßwiderstandsindex 	dynes x sek/cm-5/m2	dyn.s/(cm5.m2)	6	Decimal_6_3	8834-4	276902009	152852	t	14127	Observation
101444	1	Patient	Positiv-endexpiratorischer Druck	Beatmung_Messung_IntrinsicPEEP	Intrinsic PEEP	mbar	cm[H2O]	6	Decimal_6_3	76248-4	250854009	151976	t	9989	Observation
103318	1	Patient	Positiv-endexpiratorischer Druck	Beatmung_MS_Evita4_PEEP	gemessener positiver endexspiratorischer Druck	mbar	cm[H2O]	6	Decimal_6_3	76248-4	250854009	151976	t	3388	Observation
104356	1	Patient	Blutdruck	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.	mm[Hg]	mm[Hg]	12	Medic_Pressure	\N	75367002	\N	t	9561	Observation
102051	1	Patient	Herzzeitvolumen	HZV	Herzzeitvolumen	L/min	L/min	6	Decimal_6_3	8741-1	82799009	150276	t	3339	Observation
102184	1	Patient	Herzzeitvolumen	VigilanceC_HZV	Herzzeitvolumen	L/min	L/min	6	Decimal_6_3	8741-1	82799009	150276	t	24916	Observation
7	1	Patient	Koerpergroesse	Patient_Groesse	Größe des Patienten	cm	cm	6	Decimal_6_3	\N	50373000	\N	t	79120	Observation
106468	1	Patient	Blutdruck	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP	mm[Hg]	mm[Hg]	12	Medic_Pressure	\N	75367002	\N	t	8752	Observation
104725	1	Patient	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	Beatmung_MS_Pallas_MV	Gemessenes Atemminutenvolumen.	L/min	L/min	6	Decimal_6_3	76009-0	426102006	152004	t	3451	Observation
100088	1	Patient	Intrakranieller Druck (ICP)	ICP	Intrakranialer Druck	mmHg	mm[Hg]	6	Decimal_6_3	60956-0	250844005	153608	t	1680225	Observation
102036	1	Patient	Linksventrikulaerer Schlagvolumenindex	p-SVI	Schlagvolumenindex  (PICCO Modul Dräger Monitoring)	ml/m2	mL/m2	6	Decimal_6_3	76297-1	277381004	\N	t	869963	Observation
104264	1	Patient	Positiv-endexpiratorischer Druck	Beatmung_ES_Servoi_PEEP	PEEP 	[cmH2O]	cm[H2O]	6	Decimal_6_3	76248-4	250854009	151976	t	2515	Observation
102018	1	Patient	Pulmonalarterieller wedge Blutdruck	PWP	Pulmunaler Wedgedruck	mmHg	mm[Hg]	6	Decimal_6_3	75994-4	118433006	150052	t	1848	Observation
106332	1	Patient	Blutfluss durch cardiovasculäres Gerät	CardioHelpMaquet_MS_Blutfluss	\N	L/Min	L/min	6	Decimal_6_3	\N	444479000	\N	t	8502	Observation
102047	1	Patient	Pulmonalvaskulaerer Widerstandsindex	PVPI	Pulmonalvaskuläer Permeabilitätsindex 	\N	dyn.s/(cm5.m2)	6	Decimal_6_3	8834-4	276902009	152852	t	37642	Observation
103169	1	Patient	Haemodialyse Blutfluss	Nierenverfahren_MS_4008HS_effBlutfluss	\N	ml/min	mL/h	6	Decimal_6_3	\N	401000124105	\N	t	5523	Observation
103200	1	Patient	Haemodialyse Blutfluss	Nierenverfahren_MS_4008onl_effBlutfluss	\N	ml/min	mL/h	6	Decimal_6_3	\N	401000124105	\N	t	1148	Observation
103152	1	Patient	Haemodialyse Blutfluss	Nierenverfahren_ES_4008HS_Blutfluss	\N	ml/min	mL/h	6	Decimal_6_3	\N	401000124105	\N	t	3794	Observation
100094	1	Patient	Blutdruck Generisch	NBP_1	nichtinvasiver Blutdruck 1	mmHg	mm[Hg]	12	Medic_Pressure	\N	75367002	\N	t	4332392	Observation
104356	1	Patient	Blutdruck Generisch	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.	mm[Hg]	mm[Hg]	12	Medic_Pressure	\N	75367002	\N	t	9561	Observation
102978	1	Patient	Substituatfluss	Nierenverfahren_ES_Multi_Substituat	Umsatz, Austausch Substituat ml/h	mL/h	mL/h	6	Decimal_6_3	\N	708513005	\N	t	4361	Observation
102992	1	Patient	Substituatfluss	Nierenverfahren_ES_BM25_Umsatz	Austausch, Substituat, ml/h	mL/h	mL/h	6	Decimal_6_3	\N	708513005	\N	t	1356	Observation
110777	1	Patient	Haemodialyse Blutfluss	P_NEV_HD_MS_5008onl_effBlutfluss	\N	mL/min	mL/h	6	Decimal_6_3	\N	401000124105	\N	t	2563	Observation
110796	1	Patient	Haemodialyse Blutfluss	P_NEV_HD_ES_5008onl_Blutfluss	\N	mL/min	mL/h	6	Decimal_6_3	\N	401000124105	\N	t	3352	Observation
104872	1	Patient	Haemodialyse Blutfluss	NEV_HD_MS_4008HS_effBlutfluss	\N	mL/min	mL/h	6	Decimal_6_3	\N	401000124105	\N	t	12533	Observation
104888	1	Patient	Haemodialyse Blutfluss	NEV_HD_ES_4008HS_Blutfluss	\N	mL/min	mL/h	6	Decimal_6_3	\N	401000124105	\N	t	7997	Observation
106468	1	Patient	Blutdruck Generisch	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP	mm[Hg]	mm[Hg]	12	Medic_Pressure	\N	75367002	\N	t	8752	Observation
102926	1	Patient	Zeitverhaeltnis-Ein-Ausatmung	Beatmung_MS_G5_IEVerhaeltnis	gemessenes I:E Verhältnis	\N	{ratio}	3	String	75931-6	250822000	151832	t	1342180	Observation
100073	1	Patient	Systemischer vaskulaerer Widerstandsindex	SVRI	Index des systemischen Gefäßwiderstandes 	dynes x sek/cm-5/m2	dyn.s/(cm5.m2)	6	Decimal_6_3	8837-7	276900001	149760	t	125230	Observation
102038	1	Patient	Systemischer vaskulaerer Widerstandsindex	p-SVRI	Index des systemischen Gefäßwiderstandes (PICCO Modul Dräger Monitoring)  	dynes x sek/cm-5/m2	dyn.s/(cm5.m2)	6	Decimal_6_3	8837-7	276900001	149760	t	778804	Observation
1269	1	Patient	Zentralvenoeser Druck (ZVD)	ZVD	Zentralvenöser Druck	mmHg	mm[Hg]	6	Decimal_6_3	60985-9	71420008	150084	t	3579740	Observation
102179	1	Patient	Linksventrikulaerer Schlagvolumenindex	Vigileo_SVI	SchlagvolumenindexSchlagvolumenindex	ml/b/m²ml/b/m²	mL/m2	6	Decimal_6_3	76297-1	277381004	\N	t	4161	Observation
100102	1	Patient	Positiv-endexpiratorischer Druck	Beatmung_Einstellung_PEEP	Positiver endexspiratorischer Druck (PEEP)	mbar	cm[H2O]	6	Decimal_6_3	76248-4	250854009	151976	t	28887	Observation
104722	1	Patient	Positiv-endexpiratorischer Druck	Beatmung_MS_Pallas_PEEP	Dokumentation des gemessenen PEEPs.	mbar	cm[H2O]	6	Decimal_6_3	76248-4	250854009	151976	t	3127	Observation
100275	1	Patient	Positiv-endexpiratorischer Druck	Beatmung_Messung_PEEP	\N	mbar	cm[H2O]	6	Decimal_6_3	76248-4	250854009	151976	t	108942	Observation
103943	1	Patient	Positiv-endexpiratorischer Druck	Beatmung_ES_Heimbeatmung_Peep	\N	mbar	cm[H2O]	6	Decimal_6_3	76248-4	250854009	151976	t	5819	Observation
103011	1	Patient	Venöser Druck	Nierenverfahren_MS_Multi_venDruck	venöser Druck	mmHg	mm[Hg]	6	Decimal_6_3	\N	252076005	\N	t	97841	Observation
\.


--
-- Data for Name: mapping_mii_copra_old; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.mapping_mii_copra_old (conf_var_id, conf_var_parent_id, conf_var_parent_name, profile_name, conf_var_name, conf_var_description, conf_var_unit, profile_unit, conf_var_types_id, conf_var_types_name, loinc, url_loinc, snomed, url_snomed, matching, quantities, profile_type, ieee) FROM stdin;
102011	1	Patient	Puls	PLS	Pulsrate errechnet aus der SpO2 Messung	1/min	\N	6	Decimal_6_3	\N	\N	8499008	https://bioportal.bioontology.org/ontologies/SNOMEDCT?p=classes&conceptid=8499008	0	30000030	Observation	\N
1268	1	Patient	Puls	Puls	Puls	1/min	\N	6	Decimal_6_3	\N	\N	8499008	https://bioportal.bioontology.org/ontologies/SNOMEDCT?p=classes&conceptid=8499008	0	68448	Observation	\N
110934	1	Patient	Koerpertemperatur Generisch	P_Temperatur_generic	Anlage für Philips Monitoring	°C	Cel	6	Decimal_6_3	8310-5	https://loinc.org/8310-5/	\N	\N	0	1952044	Observation	\N
110930	1	Patient	Koerpertemperatur rektal	P_Temperatur_Rektal	Anlage im Rahmen Philips Monitoring	°C	Cel	6	Decimal_6_3	8332-9	https://loinc.org/8332-9/	307047009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=307047009	0	198068	Observation	\N
110927	1	Patient	Koerpertemperatur nasal	P_Temperatur_Naso	Anlage im Rahmen PhilipsMonitoring	°C	Cel	6	Decimal_6_3	76010-8	https://loinc.org/76010-8/	\N	\N	0	2183	Observation	\N
110929	1	Patient	Koerpertemperatur Trommelfell	P_Temperatur_Tympanal	Anlage im Rahmen PhilipsMonitoring	°C	Cel	6	Decimal_6_3	8333-7	https://loinc.org/8333-7/	415974002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=415974002	0	59195	Observation	\N
110928	1	Patient	Koerpertemperatur Speiseroehre	P_Temperatur_Oesophagial	Anlage im Rahmen PhilipsMonitoring	°C	Cel	6	Decimal_6_3	60836-4	https://loinc.org/60836-4/	431598003	https://browser.ihtsdotools.org/?perspective=full&conceptId1=431598003	0	20648	Observation	\N
110925	1	Patient	Koerpertemperatur Blut	P_Temperatur_Arteriell	Anlage im Rahmen PhilipsMonitoring	°C	Cel	6	Decimal_6_3	60834-9	https://loinc.org/60834-9/	860958002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=860958002	0	2237	Observation	\N
103716	1	Patient	Koerpertemperatur Blut	TempBT	Bluttemperatur bei der HZV Messung	°C	Cel	6	Decimal_6_3	60834-9	https://loinc.org/60834-9/	860958002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=860958002	0	52583	Observation	\N
103078	1	Patient	Druckdifferenz Beatmung	Beatmung_MS_VisionA_Amplitude	gemessene Druckdifferenz im HFOV Modus	cm H2O	cm[H2O]	6	Decimal_6_3	76154-4	https://loinc.org/76154-4/	\N	\N	0	7040	Observation	152720
102915	1	Patient	Exspiratorischer Gasfluss	Beatmung_MS_G5_ExspFlow	Exspiratorischer Peakflow, ein Monitoring-Parameter	l/min	L/min	6	Decimal_6_3	60792-9	https://loinc.org/60792-9/	\N	\N	0	734325	Observation	151944
1266	1	Patient	Herzfrequenz	HF	Herzfrequenz	1/min	/min	6	Decimal_6_3	8867-4	https://loinc.org/8867-4/	\N	\N	0	25851846	Observation	147842
102903	1	Patient	Inspiratorischer Gasfluss	Beatmung_MS_G5_InspFlow	Inspiratorischer Peakflow, ein Monitoring-Parameter	l/min	L/min	6	Decimal_6_3	60794-5	https://loinc.org/60794-5/	\N	\N	0	2686525	Observation	151948
103010	1	Patient	Arterieller Druck	Nierenverfahren_MS_Multi_artDruck	arterieller Druck	mmHg	mm[Hg]	6	Decimal_6_3	\N	\N	386534000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=386534000	0	97677	Observation	\N
100089	1	Patient	Arterieller Druck	ABP_2	zweiter arterieller Blutdruck	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	386534000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=386534000	0	446834	Observation	\N
100093	1	Patient	Arterieller Druck	ABP_1	arterieller Blutdruck 1	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	386534000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=386534000	0	16463153	Observation	\N
1267	1	Patient	Atemfrequenz	AF	Atemfrequenz	1/min	/min	6	Decimal_6_3	9279-1	https://loinc.org/9279-1/	86290005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=86290005	0	11360118	Observation	\N
104726	1	Patient	Atemzugvolumen-Waehrend-Beatmung	Beatmung_MS_Pallas_Vt	Gemessenes Tidalvolumen.	ml	mL	6	Decimal_6_3	76222-9	https://loinc.org/76222-9/	250874002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250874002	0	3394	Observation	151980
100098	1	Patient	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	Beatmung_Messung_MV	Mindest Volumen tot.	L/min	L/min	6	Decimal_6_3	76009-0	https://loinc.org/76009-0/	426102006	https://browser.ihtsdotools.org/?perspective=full&conceptId1=426102006	0	108636	Observation	152004
103320	1	Patient	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	Beatmung_MS_Evita4_MV	gemessenes Atemminutenvolumen	L/min	L/min	6	Decimal_6_3	76009-0	https://loinc.org/76009-0/	426102006	https://browser.ihtsdotools.org/?perspective=full&conceptId1=426102006	0	3739	Observation	152004
103297	1	Patient	Einstellung-Einatmungszeit-Beatmung	Beatmung_ES_Evita4_Tinsp	eingestellte absolute Inspirationszeit	s	s	6	Decimal_6_3	76334-2	https://loinc.org/76334-2/	\N	\N	0	13393	Observation	152720
102887	1	Patient	Einstellung-Einatmungszeit-Beatmung	Beatmung_ES_G5_Ti	Einstelungswert für die Inspirationszeit	s	s	6	Decimal_6_3	76334-2	https://loinc.org/76334-2/	\N	\N	0	70600	Observation	152720
110933	1	Patient	Koerpertemperatur Kern	P_Temperatur_Kern	Anlage für Philips Monitoring	°C	Cel	6	Decimal_6_3	8329-5	https://loinc.org/8329-5/	\N	\N	0	758879	Observation	150368
104758	1	Patient	Linksventrikulaeres Schlagvolumen	Schlagvolumen	gemessenes Schlagvolumen	ml	/mL	6	Decimal_6_3	20562-5	https://loinc.org/20562-5/	\N	\N	0	274423	Observation	150428
102030	1	Patient	Linksventrikulaeres Schlagvolumen	SV	Schlagvolumen 	ml	/mL	3	String	20562-5	https://loinc.org/20562-5/	\N	\N	0	11899	Observation	150428
102874	1	Patient	Linksventrikulaeres Schlagvolumen	Beatmung_ES_VisionA_Schlagvolumen	Schlagvolumen (SV) in engl. (cycle volume)	ml	/mL	6	Decimal_6_3	20562-5	https://loinc.org/20562-5/	\N	\N	0	3395	Observation	150428
102408	1	Patient	Linksventrikulaeres Schlagvolumen	p-SV	Schlagvolumen	ml	/mL	6	Decimal_6_3	20562-5	https://loinc.org/20562-5/	\N	\N	0	864963	Observation	150428
100300	1	Patient	Maximaler Beatmungsdruck	Beatmung_Messung_Pmax	Peak Airway Pressure	mmHg	cm[H2O]	6	Decimal_6_3	76531-3	https://loinc.org/76531-3/	\N	\N	0	111043	Observation	151973
102878	1	Patient	Mittlerer Beatmungsdruck	Beatmung_MS_VisionA_MAP	gemessener Mittlerer Atemwegsdruck unter HFO bei Alpha Vision	cm H2O	cm[H2O]	6	Decimal_6_3	76530-5	https://loinc.org/76530-5/	\N	\N	0	6945	Observation	151975
102873	1	Patient	Mittlerer Beatmungsdruck	Beatmung_ES_VisionA_MAP	Mittlerer Atemwegsdruck (MAP)	cm H2O	cm[H2O]	6	Decimal_6_3	76530-5	https://loinc.org/76530-5/	\N	\N	0	3863	Observation	151975
104249	1	Patient	Mittlerer Beatmungsdruck	Beatmung_MS_Servoi_Pmean	Mittlerer Atemwegsdruck 	[cmH2O]	cm[H2O]	6	Decimal_6_3	76530-5	https://loinc.org/76530-5/	\N	\N	0	1020	Observation	151975
6	1	Patient	Koerpergewicht	Patient_Gewicht	Gewicht des Patienten	kg	kg	6	Decimal_6_3	29463-7	https://loinc.org/29463-7/	\N	\N	0	96050	Observation	\N
101322	20	Fall	Koerpergewicht	Patient_AufnGewicht	Aufnahmegewicht (fallbezogen)	kg	kg	6	Decimal_6_3	29463-7	https://loinc.org/29463-7/	\N	\N	0	1019	Observation	\N
103058	1	Patient	Ionisiertes Kalzium aus Nierenersatzverfahren	Nierenverfahren_ES_Multi_CalciumFiltrat	Calciumrate	mmol/l	mmol/L	6	Decimal_6_3	83064-6	https://loinc.org/83064-6/	\N	\N	0	19281	Observation	\N
105006	1	Patient	Ionisiertes Kalzium aus Nierenersatzverfahren	NEV_CRRT_VO_CalciumLoesung	\N	\N	mmol/L	3	String	83064-6	https://loinc.org/83064-6/	\N	\N	0	2442	Observation	\N
104974	1	Patient	Ionisiertes Kalzium aus Nierenersatzverfahren	NEV_CRRT_ES_Multi_CalciumFiltrat	\N	mmol/L	mmol/L	6	Decimal_6_3	83064-6	https://loinc.org/83064-6/	\N	\N	0	303169	Observation	\N
100108	1	Patient	Mechanische-Atemfrequenz-Beatmet	Beatmung_Einstellung_AF	Beatmungsfrequenz (f/AF)	1/min	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	5250	Observation	151586
103035	1	Patient	Mechanische-Atemfrequenz-Beatmet	Beatmung_MS_G5_ftotal	Gesamtatemfrequenz, ein Monitoring Parameter	AZ/min	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	9577905	Observation	151586
101442	1	Patient	Mechanische-Atemfrequenz-Beatmet	Beatmung_Messung_AF	Breathing Frequency	1/min	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	108930	Observation	151586
103323	1	Patient	Mechanische-Atemfrequenz-Beatmet	Beatmung_MS_Evita4_frequenz	gemessene Gesamtatemfrequenz	bpm	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	3620	Observation	151586
104727	1	Patient	Mechanische-Atemfrequenz-Beatmet	Beatmung_MS_Pallas_Frequenz	Gemessene Atemfrequenz.	1/min	{Breaths}/min	6	Decimal_6_3	33438-3	https://loinc.org/33438-3/	\N	\N	0	3493	Observation	151586
100100	1	Patient	Sauerstofffraktion	Beatmung_Messung_FiO2	FiO2	%	\N	6	Decimal_6_3	71835-3	https://loinc.org/71835-3/	\N	\N	0	12360	Observation	\N
103314	1	Patient	Sauerstofffraktion	Beatmung_MS_Evita4_FiO2	gemessene O2 Konzentration des inspiratorischen Atemgasgemisches	Vol%	\N	6	Decimal_6_3	71835-3	https://loinc.org/71835-3/	\N	\N	0	3673	Observation	\N
104730	1	Patient	Sauerstofffraktion	Beatmung_MS_Pallas_O2_insp	Gemessene inspiratorische O2 Konzentration.	%	\N	6	Decimal_6_3	71835-3	https://loinc.org/71835-3/	\N	\N	0	10295	Observation	\N
103216	1	Patient	Sauerstofffraktion	Beatmung_MS_3100B_O2Konzentration	Messwert: gemessene O2 Konzentration des Gasgemisches	%	\N	6	Decimal_6_3	71835-3	https://loinc.org/71835-3/	\N	\N	0	3718	Observation	\N
103091	1	Patient	Sauerstoffgasfluss	Beatmung_ES_CF800_SauerstoffFlow	Einstellgröße Gasfluss Sauerstoff	l/min	L/min	6	Decimal_6_3	19941-4	https://loinc.org/19941-4/	\N	\N	0	1396	Observation	\N
106784	1	Patient	Sauerstoffgasfluss	Beatmung_ES_Optiflow_O2Flow	\N	l/min	L/min	6	Decimal_6_3	19941-4	https://loinc.org/19941-4/	\N	\N	0	1437	Observation	\N
103214	1	Patient	Sauerstofffraktion eingestellt	Beatmung_ES_3100B_O2Konzentration	Einstellwert: O2 Konzentration des Gasgemisches	%	\N	6	Decimal_6_3	19994-3	https://loinc.org/19994-3/	\N	\N	0	2225	Observation	\N
103296	1	Patient	Sauerstofffraktion eingestellt	Beatmung_ES_Evita4_O2Konzentration	eingestellte O2 Konzentration des Frischgases	%	\N	6	Decimal_6_3	19994-3	https://loinc.org/19994-3/	\N	\N	0	34154	Observation	\N
100105	1	Patient	Sauerstofffraktion eingestellt	Beatmung_Einstellung_FiO2	O²- Konzentration im Inspirationsgemisch (FiO2)	%	\N	6	Decimal_6_3	19994-3	https://loinc.org/19994-3/	\N	\N	0	29967	Observation	\N
100270	1	Patient	Spontane-Atemfrequenz-Beatmet	Beatmung_Messung_AFSpontan	Respiratory Rate (spontan)	1/min	/min	6	Decimal_6_3	\N	\N	\N	\N	0	59723	Observation	152498
103324	1	Patient	Spontane-Atemfrequenz-Beatmet	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz	bpm	/min	6	Decimal_6_3	\N	\N	\N	\N	0	7092	Observation	152498
103036	1	Patient	Spontane-Atemfrequenz-Beatmet	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz	AZ/min	/min	6	Decimal_6_3	\N	\N	\N	\N	0	20846232	Observation	152498
103324	1	Patient	Spontane-Mechanische-Atemfrequenz-Beatmet	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz	bpm	/min	6	Decimal_6_3	19840-8	https://loinc.org/19840-8/	\N	\N	0	7092	Observation	152490
103036	1	Patient	Spontane-Mechanische-Atemfrequenz-Beatmet	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz	AZ/min	/min	6	Decimal_6_3	19840-8	https://loinc.org/19840-8/	\N	\N	0	20846232	Observation	152490
102010	1	Patient	Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie	SpO2	Sauerstoffsättigung Pulsoxymetrie	%	%	6	Decimal_6_3	59408-5	https://loinc.org/59408-5/	\N	\N	0	22647295	Observation	150456
100094	1	Patient	Blutdruck	NBP_1	nichtinvasiver Blutdruck 1	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	4332392	Observation	\N
103254	1	Patient	Dauer Haemodialysesitzung	Nierenverfahren_VO_4008HS_Dialysezeit	\N	h:min	h	6	Decimal_6_3	\N	\N	445940005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=445940005	0	3733	Observation	\N
103146	1	Patient	Dauer Haemodialysesitzung	Nierenverfahren_ES_4008HS_DialyseZeit	\N	h:min	h	6	Decimal_6_3	\N	\N	445940005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=445940005	0	3395	Observation	\N
103817	1	Patient	Exspiratorischer Sauerstoffpartialdruck	PtiO2Druck	Gemessener Sauerstoffpartialdruck im Parenchym	mmHg	mm[Hg]	12	Medic_Pressure	3147-6	https://loinc.org/3147-6/	250775008	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250775008	0	295225	Observation	153132
11	1	Patient	Kopfumfang	COPRA_Patient_Kopfumfang	Kopfumfang des Patienten in Zentimetern	cm	cm	6	Decimal_6_3	9843-4	https://loinc.org/9843-4/	363811000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=363811000	0	1191	Observation	\N
100091	1	Patient	Linksatrialer Druck	LAP	Linksatrial  Mitteldruck	mmHg	mm[Hg]	6	Decimal_6_3	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	3189	Observation	\N
102039	1	Patient	Linksventrikulaerer Herzindex	dPmax	Index der linken Ventrikelkontraktilität  	mmHg/s	L/(min.m2)	6	Decimal_6_3	75919-1	https://loinc.org/75919-1/	54993008	https://browser.ihtsdotools.org/?perspective=full&conceptId1=54993008	0	986335	Observation	149772
102050	1	Patient	Pulmonalarterieller Blutdruck	PAP	Pulmunalarterieller Druck	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	441466	Observation	\N
102026	1	Patient	Pulmonalvaskulaerer Widerstandsindex	PVRI	Pulmunaler Gefäßwiderstandsindex 	dynes x sek/cm-5/m2	dyn.s/(cm5.m2)	6	Decimal_6_3	8834-4	https://loinc.org/8834-4/	276902009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=276902009	0	14127	Observation	152852
101444	1	Patient	Positiv-endexpiratorischer Druck	Beatmung_Messung_IntrinsicPEEP	Intrinsic PEEP	mbar	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	9989	Observation	151976
103318	1	Patient	Positiv-endexpiratorischer Druck	Beatmung_MS_Evita4_PEEP	gemessener positiver endexspiratorischer Druck	mbar	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	3388	Observation	151976
104356	1	Patient	Blutdruck	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.	mm[Hg]	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	9561	Observation	\N
102051	1	Patient	Herzzeitvolumen	HZV	Herzzeitvolumen	L/min	L/min	6	Decimal_6_3	8741-1	https://loinc.org/8741-1/	82799009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=82799009	0	3339	Observation	150276
102184	1	Patient	Herzzeitvolumen	VigilanceC_HZV	Herzzeitvolumen	L/min	L/min	6	Decimal_6_3	8741-1	https://loinc.org/8741-1/	82799009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=82799009	0	24916	Observation	150276
7	1	Patient	Koerpergroesse	Patient_Groesse	Größe des Patienten	cm	cm	6	Decimal_6_3	\N	\N	50373000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=50373000	0	79120	Observation	\N
106468	1	Patient	Blutdruck	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP	mm[Hg]	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	8752	Observation	\N
104725	1	Patient	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	Beatmung_MS_Pallas_MV	Gemessenes Atemminutenvolumen.	L/min	L/min	6	Decimal_6_3	76009-0	https://loinc.org/76009-0/	426102006	https://browser.ihtsdotools.org/?perspective=full&conceptId1=426102006	0	3451	Observation	152004
100088	1	Patient	Intrakranieller Druck (ICP)	ICP	Intrakranialer Druck	mmHg	mm[Hg]	6	Decimal_6_3	60956-0	https://loinc.org/60956-0/	250844005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250844005	0	1680225	Observation	153608
106332	1	Patient	Blutfluss durch cardiovasculaeres Geraet	CardioHelpMaquet_MS_Blutfluss	\N	L/Min	L/min	6	Decimal_6_3	\N	\N	444479000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=444479000	0	8502	Observation	\N
102036	1	Patient	Linksventrikulaerer Schlagvolumenindex	p-SVI	Schlagvolumenindex  (PICCO Modul Dräger Monitoring)	ml/m2	mL/m2	6	Decimal_6_3	76297-1	https://loinc.org/76297-1/	277381004	https://browser.ihtsdotools.org/?perspective=full&conceptId1=277381004	0	869963	Observation	\N
104264	1	Patient	Positiv-endexpiratorischer Druck	Beatmung_ES_Servoi_PEEP	PEEP 	[cmH2O]	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	2515	Observation	151976
102018	1	Patient	Pulmonalarterieller wedge Blutdruck	PWP	Pulmunaler Wedgedruck	mmHg	mm[Hg]	6	Decimal_6_3	75994-4	https://loinc.org/75994-4/	118433006	https://browser.ihtsdotools.org/?perspective=full&conceptId1=118433006	0	1848	Observation	150052
102047	1	Patient	Pulmonalvaskulaerer Widerstandsindex	PVPI	Pulmonalvaskuläer Permeabilitätsindex 	\N	dyn.s/(cm5.m2)	6	Decimal_6_3	8834-4	https://loinc.org/8834-4/	276902009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=276902009	0	37642	Observation	152852
103011	1	Patient	Venoeser Druck	Nierenverfahren_MS_Multi_venDruck	venöser Druck	mmHg	mm[Hg]	6	Decimal_6_3	\N	\N	252076005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=252076005	0	97841	Observation	\N
103169	1	Patient	Haemodialyse Blutfluss	Nierenverfahren_MS_4008HS_effBlutfluss	\N	ml/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	5523	Observation	\N
103200	1	Patient	Haemodialyse Blutfluss	Nierenverfahren_MS_4008onl_effBlutfluss	\N	ml/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	1148	Observation	\N
103152	1	Patient	Haemodialyse Blutfluss	Nierenverfahren_ES_4008HS_Blutfluss	\N	ml/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	3794	Observation	\N
100094	1	Patient	Blutdruck Generisch	NBP_1	nichtinvasiver Blutdruck 1	mmHg	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	4332392	Observation	\N
104356	1	Patient	Blutdruck Generisch	IABP_DatascopeCS300_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP.	mm[Hg]	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	9561	Observation	\N
102978	1	Patient	Substituatfluss	Nierenverfahren_ES_Multi_Substituat	Umsatz, Austausch Substituat ml/h	mL/h	mL/h	6	Decimal_6_3	\N	\N	708513005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=708513005	0	4361	Observation	\N
102992	1	Patient	Substituatfluss	Nierenverfahren_ES_BM25_Umsatz	Austausch, Substituat, ml/h	mL/h	mL/h	6	Decimal_6_3	\N	\N	708513005	https://browser.ihtsdotools.org/?perspective=full&conceptId1=708513005	0	1356	Observation	\N
110777	1	Patient	Haemodialyse Blutfluss	P_NEV_HD_MS_5008onl_effBlutfluss	\N	mL/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	2563	Observation	\N
110796	1	Patient	Haemodialyse Blutfluss	P_NEV_HD_ES_5008onl_Blutfluss	\N	mL/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	3352	Observation	\N
104872	1	Patient	Haemodialyse Blutfluss	NEV_HD_MS_4008HS_effBlutfluss	\N	mL/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	12533	Observation	\N
104888	1	Patient	Haemodialyse Blutfluss	NEV_HD_ES_4008HS_Blutfluss	\N	mL/min	mL/h	6	Decimal_6_3	\N	\N	401000124105	https://browser.ihtsdotools.org/?perspective=full&conceptId1=401000124105	0	7997	Observation	\N
106468	1	Patient	Blutdruck Generisch	IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole	Dokumentation des gemessenen Blutdruckes unter IABP	mm[Hg]	mm[Hg]	12	Medic_Pressure	\N	\N	75367002	https://browser.ihtsdotools.org/?perspective=full&conceptId1=75367002	0	8752	Observation	\N
102926	1	Patient	Zeitverhaeltnis-Ein-Ausatmung	Beatmung_MS_G5_IEVerhaeltnis	gemessenes I:E Verhältnis	\N	{ratio}	3	String	75931-6	https://loinc.org/75931-6/	250822000	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250822000	0	1342180	Observation	151832
100073	1	Patient	Systemischer vaskulaerer Widerstandsindex	SVRI	Index des systemischen Gefäßwiderstandes 	dynes x sek/cm-5/m2	dyn.s/(cm5.m2)	6	Decimal_6_3	8837-7	https://loinc.org/8837-7/	276900001	https://browser.ihtsdotools.org/?perspective=full&conceptId1=276900001	0	125230	Observation	149760
102038	1	Patient	Systemischer vaskulaerer Widerstandsindex	p-SVRI	Index des systemischen Gefäßwiderstandes (PICCO Modul Dräger Monitoring)  	dynes x sek/cm-5/m2	dyn.s/(cm5.m2)	6	Decimal_6_3	8837-7	https://loinc.org/8837-7/	276900001	https://browser.ihtsdotools.org/?perspective=full&conceptId1=276900001	0	778804	Observation	149760
1269	1	Patient	Zentralvenoeser Druck (ZVD)	ZVD	Zentralvenöser Druck	mmHg	mm[Hg]	6	Decimal_6_3	60985-9	https://loinc.org/60985-9/	71420008	https://browser.ihtsdotools.org/?perspective=full&conceptId1=71420008	0	3579740	Observation	150084
102179	1	Patient	Linksventrikulaerer Schlagvolumenindex	Vigileo_SVI	SchlagvolumenindexSchlagvolumenindex	ml/b/m²ml/b/m²	mL/m2	6	Decimal_6_3	76297-1	https://loinc.org/76297-1/	277381004	https://browser.ihtsdotools.org/?perspective=full&conceptId1=277381004	0	4161	Observation	\N
100102	1	Patient	Positiv-endexpiratorischer Druck	Beatmung_Einstellung_PEEP	Positiver endexspiratorischer Druck (PEEP)	mbar	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	28887	Observation	151976
104722	1	Patient	Positiv-endexpiratorischer Druck	Beatmung_MS_Pallas_PEEP	Dokumentation des gemessenen PEEPs.	mbar	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	3127	Observation	151976
100275	1	Patient	Positiv-endexpiratorischer Druck	Beatmung_Messung_PEEP	\N	mbar	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	108942	Observation	151976
103943	1	Patient	Positiv-endexpiratorischer Druck	Beatmung_ES_Heimbeatmung_Peep	\N	mbar	cm[H2O]	6	Decimal_6_3	76248-4	https://loinc.org/76248-4/	250854009	https://browser.ihtsdotools.org/?perspective=full&conceptId1=250854009	0	5819	Observation	151976
\.


--
-- Data for Name: mii_icu; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.mii_icu (profile_id, profile_name, category_coding_system, category_coding_code, code_coding_system_snomed, code_coding_code_snomed, code_coding_system_loinc, code_coding_code_loinc, code_coding_system_ieee, code_coding_code_ieee, valuequantity_system, valuequantity_code, device_reference, code_systolic_coding_system_snomed, code_systolic_coding_code_snomed, code_systolic_coding_system_loinc, code_systolic_coding_code_loinc, code_systolic_coding_system_ieee, code_systolic_coding_code_ieee, code_mean_coding_system_snomed, code_mean_coding_code_snomed, code_mean_coding_system_loinc, code_mean_coding_code_loinc, code_mean_coding_system_ieee, code_mean_coding_code_ieee, code_diastolic_coding_system_snomed, code_diastolic_coding_code_snomed, code_diastolic_coding_system_loinc, code_diastolic_coding_code_loinc, code_diastolic_coding_system_ieee, code_diastolic_coding_code_ieee, meta_profile) FROM stdin;
8	Druckdifferenz Beatmung	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76154-4	urn:iso:std:iso:11073:10101	152720	http://unitsofmeasure.org	cm[H2O]	DeviceMetric/Gemessene_Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Druckdifferenz-Beatmung
9	Einstellung-Einatmungszeit-Beatmung	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76334-2	urn:iso:std:iso:11073:10101	16929632	http://unitsofmeasure.org	s	DeviceMetric/Eingestellte_Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Einstellung-Einatmungszeit-Beatmung
10	Exspiratorischer Gasfluss	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	60792-9	urn:iso:std:iso:11073:10101	151944	http://unitsofmeasure.org	L/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Exspiratorischer-Gasfluss
5	Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	\N	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck
12	Herzfrequenz	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	364075005	http://loinc.org	8867-4	\N	\N	http://unitsofmeasure.org	/min	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzfrequenz
16	Ionisiertes Kalzium aus Nierenersatzverfahren	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	83064-6	\N	\N	http://unitsofmeasure.org	mmol/L	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Ionisiertes-Kalzium-Nierenersatzverfahren
20	Kopfumfang	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	\N	\N	http://loinc.org	9843-4	\N	\N	http://unitsofmeasure.org	cm	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Kopfumfang
26	Pulmonalarterieller Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	\N	\N	\N	http://loinc.org	8440-0	urn:iso:std:iso:11073:10101	150045	\N	\N	http://loinc.org	8414-5	urn:iso:std:iso:11073:10101	150047	\N	\N	http://loinc.org	8385-7	urn:iso:std:iso:11073:10101	150046	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Pulmonalarterieller-Blutdruck
27	Pulmonalarterieller wedge Blutdruck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	118433006	http://loinc.org	75994-4	urn:iso:std:iso:11073:10101	150052	http://unitsofmeasure.org	mm[Hg]	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Pulmonalarterieller-Wedge-Druck
28	Sauerstofffraktion	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	1	DeviceMetric/Gemessene_Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion
29	Sauerstofffraktion eingestellt	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	71835-3	\N	\N	http://unitsofmeasure.org	%	DeviceMetric/Gemessene_Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion
30	Sauerstoffgasfluss	http://snomed.info/sct	182744004	\N	\N	http://loinc.org	19941-4	\N	\N	http://unitsofmeasure.org	L/min	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffgasfluss
6	Blutdruck Generisch	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	\N	http://snomed.info/sct	271649006	http://loinc.org	8480-6	urn:iso:std:iso:11073:10101	150017	http://snomed.info/sct	6797001	http://loinc.org	8478-0	urn:iso:std:iso:11073:10101	150019	http://snomed.info/sct	271650006	http://loinc.org	8462-4	urn:iso:std:iso:11073:10101	150018	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck-Generisch
31	Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	\N	\N	http://loinc.org	59408-5	urn:iso:std:iso:11073:10101	150456	http://unitsofmeasure.org	%	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffsaettigung-Im-Arteriellen-Blut-Per-Pulsoxymetrie
24	Mittlerer Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76530-5	urn:iso:std:iso:11073:10101	151975	http://unitsofmeasure.org	cm[H2O]	DeviceMetric/..._Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mittlerer-Beatmungsdruck
32	Spontane-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19839-0	urn:iso:std:iso:11073:10101	152498	http://unitsofmeasure.org	/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Atemfrequenz-Beatmet
14	Inspiratorischer Gasfluss	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76275-7	urn:iso:std:iso:11073:10101	151948	http://unitsofmeasure.org	L/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Eingestellter-Inspiratorischer-Gasfluss
33	Spontane-Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	19840-8	urn:iso:std:iso:11073:10101	152490	http://unitsofmeasure.org	/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Mechanische-Atemfrequenz-Beatmet
23	Mechanische-Atemfrequenz-Beatmet	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	33438-3	urn:iso:std:iso:11073:10101	151586	http://unitsofmeasure.org	{Breaths}/min	DeviceMetric/Eingestellte_Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet
7	Blutfluss durch cardiovasculäres Gerät	http://snomed.info/sct	182744004	http://snomed.info/sct	444479000	\N	\N	\N	\N	http://unitsofmeasure.org	L/min	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutfluss-Cardiovasculaeres-Geraet
36	Zeitverhaeltnis-Ein-Ausatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	250822000	http://loinc.org	75931-6	urn:iso:std:iso:11073:10101	151832	http://unitsofmeasure.org	{ratio}	DeviceMetric/Eingestellte_Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Zeitverhaeltnis-Ein-Ausatmung
37	Zentralvenoeser Druck (ZVD)	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	71420008	http://loinc.org	60985-9	urn:iso:std:iso:11073:10101	150084	http://unitsofmeasure.org	mm[Hg]	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Zentralvenoeser-Blutdruck
4	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	426102006	http://loinc.org	76009-0	urn:iso:std:iso:11073:10101	152004	http://unitsofmeasure.org	L/min	DeviceMetric/Gemessene_Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/SBeatmungsvolumen-Pro-Minute-Machineller-Beatmung
3	Atemzugvolumen-Waehrend-Beatmung	http://snomed.info/sct	40617009	http://snomed.info/sct	250874002	http://loinc.org	76222-9	urn:iso:std:iso:11073:10101	151980	http://unitsofmeasure.org	mL	DeviceMetric/Gemessene_Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Atemzugvolumen-Waehrend-Beatmung
2	Atemfrequenz	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	86290005	https://loinc.org/9279-1/	9279-1	\N	\N	http://unitsofmeasure.org	/min	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Atemfrequenz
1	Arterieller Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	386534000	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Arterieller-Druck
21	Linksatrialer Druck	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	75367002	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	\N	\N	\N	http://loinc.org	60989-1	urn:iso:std:iso:11073:10101	150065	\N	\N	http://loinc.org	8399-8	urn:iso:std:iso:11073:10101	150067	\N	\N	http://loinc.org	75933-2	urn:iso:std:iso:11073:10101	150066	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksatrialer-Druck
17	Koerpergewicht	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	27113001	http://loinc.org	29463-7	\N	\N	http://unitsofmeasure.org	kg	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpergewicht
18	Koerpergroesse	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	1153637007	http://loinc.org	8302-2	\N	\N	http://unitsofmeasure.org	cm	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpergroesse
19	Koerpertemperatur Kern	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	276885007	http://loinc.org	8329-5	urn:iso:std:iso:11073:10101	150368	http://unitsofmeasure.org	Cel	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpertemperatur-Kern
22	Linksventrikulaerer Schlagvolumenindex	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	277381004	http://loinc.org	76297-1	urn:iso:std:iso:11073:10101	149764	http://unitsofmeasure.org	mL/m2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaerer-Schlagvolumenindex
11	Exspiratorischer Sauerstoffpartialdruck	http://snomed.info/sct	40617009	http://snomed.info/sct	250775008	http://loinc.org	3147-6	urn:iso:std:iso:11073:10101	153132	http://unitsofmeasure.org	mm[Hg]	DeviceMetric/Gemessene_Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Exspiratorischer-Sauerstoffpartialdruck
15	Intrakranieller Druck (ICP)	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	250844005	http://loinc.org	60956-0	urn:iso:std:iso:11073:10101	153608	http://unitsofmeasure.org	mm[Hg]	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Intrakranieller-Druck-ICP
25	Positiv-endexpiratorischer Druck	http://snomed.info/sct	40617009	http://snomed.info/sct	250854009	http://loinc.org	76248-4	urn:iso:std:iso:11073:10101	151976	http://unitsofmeasure.org	cm[H2O]	DeviceMetric/Eingestellte_Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck
34	Substituatfluss	http://snomed.info/sct	182744004	http://snomed.info/sct	708513005	\N	\N	\N	\N	http://unitsofmeasure.org	mL/h	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Substituatfluss
35	Venöser Druck	http://snomed.info/sct	182744004	http://snomed.info/sct	252076005	\N	\N	\N	\N	http://unitsofmeasure.org	mm[Hg]	DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Venoeser-Druck
38	Dauer Haemodialysesitzung	http://snomed.info/sct	182744004	http://snomed.info/sct	445940005	\N	\N	\N	\N	http://unitsofmeasure.org	h	DeviceMetric/Example_Gemessene_Parameter_extrakorporale_Verfahren_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Dauer-Haemodialysesitzung
39	Linksventrikulaeres Schlagvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	90096001	http://loinc.org	20562-5	urn:iso:std:iso:11073:10101	150428	http://unitsofmeasure.org	mL	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen
40	Linksventrikulaerer Herzindex	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	54993008	http://loinc.org	75919-1	urn:iso:std:iso:11073:10101	149772	http://unitsofmeasure.org	L/(min.m2)	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaerer-Herzindex
41	Maximaler Beatmungsdruck	http://snomed.info/sct	40617009	\N	\N	http://loinc.org	76531-3	urn:iso:std:iso:11073:10101	151973	http://unitsofmeasure.org	cm[H2O]	DeviceMetric/..._Parameter_Beatmung_id	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Maximaler-Beatmungsdruck
13	Herzzeitvolumen	http://terminology.hl7.org/CodeSystem/observation-category	vital-signs	http://snomed.info/sct	82799009	http://loinc.org	8741-1	urn:iso:std:iso:11073:10101	150276	http://unitsofmeasure.org	L/min	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzzeitvolumen
\.


--
-- Data for Name: mii_icu_changed_provi; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.mii_icu_changed_provi (profile_name, profile_type, profile_unit, profile_status, mapped, ops, loinc, ieee, snomed) FROM stdin;
Blutflussindex Extrakorporaler Gasaustausch	Observation	L/(min.m2)	Active	f	\N	\N	\N	251289007
Koerpergewicht Percentil Altersabhaengig	Observation	%	Active	f	\N	8336-0	\N	1153592008
Linksventrikulaerer Herzindex Durch Indikatorverduennung	Observation	L/min/m2	Active	f	\N	8751-0	149772	\N
Blutfluss Extrakorporaler Gasaustausch	Observation	L/min	Active	f	\N	\N	\N	251288004
Linksventrikulaerer Schlagvolumenindex Durch Indikatorverduennung	Observation	/mL	Active	f	\N	8791-6	\N	\N
Linksventrikulaeres Herzzeitvolumen Durch Indikatorverduennung	Observation	L/min	Active	f	\N	8737-9	150276	\N
Linksventrikulaeres Schlagvolumen Durch Indikatorverduennung	Observation	/mL	Active	f	\N	8771-8	\N	\N
Parameter von Extrakorporalen Verfahren	Observation	\N	Active	f	\N	\N	\N	\N
Parameter von Beatmung	Observation	\N	Active	f	\N	\N	\N	\N
Atemwegsdruck Mittlerem Expiratorischem Gasfluss	Observation	cm[H2O]	Active	f	\N	20056-8	\N	\N
Atemwegsdruck Null Expiratorischem Gasfluss	Observation	cm[H2O]	Active	f	\N	20060-0	\N	\N
Einstellung Ausatmungszeit Beatmung	Observation	s	Active	f	\N	76187-4	\N	\N
Ideales Koerpergewicht	Observation	kg	Active	f	\N	50064-5	\N	170804003
Monitoring und Vitaldaten	Observation	\N	Active	f	\N	\N	\N	\N
Sauerstoffsaettigung Im Blut Postduktal Durch Pulsoxymetrie	Observation	%	Active	f	\N	59418-4	160300	\N
Unterstuzungsdruck Beatmung	Observation	cm[H2O]	Active	f	\N	20079-0	\N	\N
ICU Device	Device	\N	Active	f	\N	\N	\N	\N
Beatmung	Procedure	\N	Active	f	\N	\N	\N	\N
DeviceMetric Eingestellte Gemessene Parameter Extrakorporale Verfahren	DeviceMetric	\N	Active	f	\N	\N	\N	\N
Extrakorporales Verfahren	Procedure	\N	Active	f	\N	\N	\N	\N
Spontanes Mechanisches Atemzugvolumen Waehrend Beatmung	Observation	mL	Active	f	\N	20118-6	\N	\N
DeviceMetric Eingestellte Gemessene Parameter Beatmung	DeviceMetric	\N	Active	f	\N	\N	\N	\N
Puls	Observation	\N	Active	t	\N	\N	149514	8499008
Dauer Extrakorporaler Gasaustausch	Observation	h	Active	f	\N	\N	\N	251286000
Sauerstoffsaettigung Im Blut Preduktal Durch Pulsoxymetrie	Observation	%	Active	f	\N	59407-7	160296	\N
Koerpertemperatur Generisch	Observation	Cel	Active	t	\N	8310-5	\N	\N
Koerpertemperatur nasal	Observation	Cel	Active	t	\N	76010-8	188504	\N
Koerpertemperatur rektal	Observation	Cel	Active	t	\N	8332-9	188420	307047009
Koerpertemperatur Trommelfell	Observation	Cel	Active	t	\N	8333-7	\N	415974002
Koerpertemperatur Speiseroehre	Observation	Cel	Active	t	\N	60836-4	\N	431598003
Koerpertemperatur Blut	Observation	Cel	Active	t	\N	60834-9	188436	860958002
Atemzugvolumen Einstellung	Observation	mL	Active	f	\N	20112-9	16929196	416811008
Atemzugvolumen Waehrend Beatmung	Observation	mL	Active	t	\N	76222-9	151980	250874002
Linksventrikulaeres Schlagvolumenindex	Observation	mL/m2	Active	t	\N	76297-1	149764	277381004
Rechtsventrikulaerer Druck	Observation	mm[Hg]	Active	t	\N	\N	\N	75367002
Horowitz In Arteriellem Blut	Observation	mm[Hg]	Active	t	\N	50984-4	150656	\N
Beatmungsvolumen Pro Minute Maschineller Beatmung	Observation	L/min	Active	t	\N	76009-0	152004	426102006
Spontanes Atemzugvolumen	Observation	mL	Active	t	\N	20116-0	\N	250816009
Ionisiertes Kalzium Nierenersatzverfahren	Observation	mmol/L	Active	t	\N	83064-6	\N	\N
Koerpergewicht	Observation	kg	Active	t	\N	29463-7	\N	\N
Koerpertemperatur Kern	Observation	Cel	Active	t	\N	8329-5	150368	\N
Einstellung Einatmungszeit Beatmung	Observation	s	Active	t	\N	76334-2	16929632	\N
Beatmungszeit Hohem Druck	Observation	s	Active	t	\N	76190-8	16929860	\N
Blutdruck	Observation	mm[Hg]	Active	t	\N	\N	\N	75367002
Blutfluss Cardiovasculaeres Geraet	Observation	L/min	Active	t	\N	\N	\N	444479000
Dauer Haemodialysesitzung	Observation	h	Active	t	\N	\N	\N	445940005
Druckdifferenz Beatmung	Observation	cm[H2O]	Active	t	\N	76154-4	152720	\N
Eingestellter Inspiratorischer Gasfluss	Observation	L/min	Active	t	\N	76275-7	\N	\N
Endexpiratorischer Kohlendioxidpartialdruck	Observation	mm[Hg]	Active	t	\N	19891-1	151708	250784008
Exspiratorischer Gasfluss	Observation	L/min	Active	t	\N	60792-9	151944	\N
Arterieller Druck	Observation	mm[Hg]	Active	t	\N	\N	\N	386534000
Atemfrequenz	Observation	/min	Active	t	\N	9279-1	\N	86290005
Inspiratorischer Gasfluss	Observation	L/min	Active	t	\N	60794-5	151948	\N
Koerpergroesse	Observation	cm	Active	t	\N	\N	\N	50373000
Kopfumfang	Observation	cm	Active	t	\N	9843-4	\N	363811000
Linksventrikulaerer Druck	Observation	mm[Hg]	Active	t	\N	\N	\N	75367002
Linksventrikulaerer Herzindex	Observation	L/(min.m2)	Active	t	\N	75919-1	149772	54993008
Linksventrikulaeres Schlagvolumen	Observation	/mL	Active	t	\N	20562-5	150428	\N
Beatmungszeit Niedrigem Druck	Observation	s	Active	t	\N	76229-4	16929864	\N
Herzfrequenz	Observation	/min	Active	t	\N	8867-4	\N	\N
Herzzeitvolumen	Observation	L/min	Active	t	\N	8741-1	150276	82799009
Dynamische Kompliance	Observation	mL/cm[H2O]	Active	t	\N	60827-3	151692	250823005
Exspiratorischer Sauerstoffpartialdruck	Observation	mm[Hg]	Active	t	\N	3147-6	153132	250775008
Blutdruck Generisch	Observation	mm[Hg]	Active	t	\N	\N	\N	75367002
Intrakranieller Druck	Observation	mm[Hg]	Active	t	\N	60956-0	153608	250844005
Koerpergroesse Percentil	Observation	%	Active	t	\N	8303-0	\N	1153605006
Mechanische Atemfrequenz Beatmet	Observation	{Breaths}/min	Active	t	\N	33438-3	151586	\N
Mittlerer Beatmungsdruck	Observation	cm[H2O]	Active	t	\N	76530-5	151975	\N
Positv Endexpiratorischer Druck	Observation	cm[H2O]	Active	t	\N	76248-4	151976	250854009
Pulmonalarterieller Blutdruck	Observation	mm[Hg]	Active	t	\N	\N	\N	75367002
Pulmonalarterieller Wedge Druck	Observation	mm[Hg]	Active	t	\N	75994-4	150052	118433006
Sauerstofffraktion	Observation	\N	Active	t	\N	71835-3	\N	\N
Sauerstofffraktion Eingestellt	Observation	\N	Active	t	\N	19994-3	\N	\N
Sauerstoffgasfluss	Observation	L/min	Active	t	\N	19941-4	\N	\N
Sauerstoffsaettigung Im Arteriellen Blut Per Pulsoxymetrie	Observation	%	Active	t	\N	59408-5	150456	\N
Spontane Atemfrequenz Beatmet	Observation	/min	Active	t	\N	\N	152498	\N
Venoeser Druck	Observation	mm[Hg]	Active	t	\N	\N	\N	252076005
Zeitverhaeltnis Ein Ausatmung	Observation	{ratio}	Active	t	\N	75931-6	151832	250822000
Zentralvenoeser Blutdruck	Observation	mm[Hg]	Active	t	\N	60985-9	150084	71420008
Haemodialyse Blutfluss	Observation	mL/h	Active	t	\N	\N	_83064-6	401000124105
Rechtsatrialer Druck	Observation	mm[Hg]	Active	t	\N	\N	\N	75367002
Linksatrialer Druck	Observation	mm[Hg]	Active	t	\N	\N	\N	75367002
Maximaler Beatmungsdruck	Observation	cm[H2O]	Active	t	\N	76531-3	151973	\N
Pulmonalvaskulaerer Widerstandsindex	Observation	dyn.s/(cm5.m2)	Active	t	\N	8834-4	152852	276902009
Spontane Mechanische Atemfrequenz Beatmet	Observation	/min	Active	t	\N	19840-8	152490	\N
Substituatvolumen	Observation	l	Active	t	\N	\N	\N	708514004
Periphere Artierielle Sauerstoffsaettigung ICU	Observation	%	Active	t	\N	2708-6	\N	\N
Systemischer Vaskulaerer Widerstandsindex	Observation	dyn.s/(cm5.m2)	Active	t	\N	8837-7	149760	276900001
Substituatfluss	Observation	mL/h	Active	t	\N	\N	\N	708513005
\.


--
-- Data for Name: mii_icu_new; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.mii_icu_new (profile_name, profile_type, profile_status, profile_datum) FROM stdin;
Arterieller Druck	Observation	Active	18/3/2022
Atemfrequenz	Observation	Active	29/4/2022
Atemwegsdruck Mittlerem Expiratorischem Gasfluss	Observation	Active	16/3/2022
Atemwegsdruck Null Expiratorischem Gasfluss	Observation	Active	16/3/2022
Atemzugvolumen Einstellung	Observation	Active	16/3/2022
Atemzugvolumen Waehrend Beatmung	Observation	Active	16/3/2022
Beatmung	Procedure	Active	18/5/2022
Beatmungsvolumen Pro Minute Maschineller Beatmung	Observation	Active	7/4/2022
Beatmungszeit Hohem Druck	Observation	Active	16/3/2022
Beatmungszeit Niedrigem Druck	Observation	Active	21/3/2022
Blutdruck	Observation	Active	8/4/2022
Blutdruck Generisch	Observation	Active	29/4/2022
Blutfluss Cardiovasculaeres Geraet	Observation	Active	6/4/2022
Blutfluss Extrakorporaler Gasaustausch	Observation	Active	22/3/2022
Blutflussindex Extrakorporaler Gasaustausch	Observation	Active	22/3/2022
Dauer Extrakorporaler Gasaustausch	Observation	Active	22/3/2022
Dauer Haemodialysesitzung	Observation	Active	21/3/2022
DeviceMetric Eingestellte Gemessene Parameter Beatmung	DeviceeMetric	Active	21/3/2022
DeviceMetric Eingestellte Gemessene Parameter Extrakorporale Verfahren	DeviceeMetric	Active	25/4/2022
Druckdifferenz Beatmung	Observation	Active	16/3/2022
Dynamische Kompliance	Observation	Active	16/3/2022
Eingestellter Inspiratorischer Gasfluss	Observation	Active	16/3/2022
Einstellung Ausatmungszeit Beatmung	Observation	Active	7/4/2022
Einstellung Einatmungszeit Beatmung	Observation	Active	7/4/2022
Endexpiratorischer Kohlendioxidpartialdruck	Observation	Active	6/4/2022
Exspiratorischer Gasfluss	Observation	Active	16/3/2022
Exspiratorischer Sauerstoffpartialdruck	Observation	Active	6/4/2022
Extrakorporales Verfahren	Procedure	Active	22/4/2022
Haemodialyse Blutfluss	Observation	Active	8/4/2022
Herzfrequenz	Observation	Active	29/4/2022
Herzzeitvolumen	Observation	Active	8/4/2022
Horowitz In Arteriellem Blut	Observation	Active	16/3/2022
ICU Device	Devicee	Active	16/3/2022
Ideales Koerpergewicht	Observation	Active	16/3/2022
Inspiratorisch Sauerstofffraktion Eingestellt	Observation	Active	25/4/2022
Inspiratorische Sauerstofffraktion	Observation	Active	19/4/2022
Inspiratorischer Gasfluss	Observation	Active	16/3/2022
Intrakranieller Druck	Observation	Active	16/3/2022
Ionisiertes Kalzium Nierenersatzverfahren	Observation	Active	21/3/2022
Koerpergewicht	Observation	Active	29/4/2022
Koerpergewicht Percentil Altersabhaengig	Observation	Active	19/4/2022
Koerpergroesse	Observation	Active	29/4/2022
Koerpergroesse Percentil	Observation	Active	22/4/2022
Koerpertemperatur Achsel	Observation	Active	20/5/2022
Koerpertemperatur Atemwege	Observation	Active	20/5/2022
Koerpertemperatur Blut	Observation	Active	20/5/2022
Koerpertemperatur Brust	Observation	Active	20/5/2022
Koerpertemperatur Brustwirbelsaeule	Observation	Active	20/5/2022
Koerpertemperatur Gelenk	Observation	Active	20/5/2022
Koerpertemperatur Halswirbelsaeule	Observation	Active	20/5/2022
Koerpertemperatur Harnblase	Observation	Active	20/5/2022
Koerpertemperatur Kern	Observation	Active	29/4/2022
Koerpertemperatur Leiste	Observation	Active	20/5/2022
Koerpertemperatur Lendenwirbelsaeule	Observation	Active	20/5/2022
Koerpertemperatur Myokard	Observation	Active	20/5/2022
Koerpertemperatur nasal	Observation	Active	20/5/2022
Koerpertemperatur Nasen Rachen Raum	Observation	Active	20/5/2022
Koerpertemperatur rektal	Observation	Active	20/5/2022
Koerpertemperatur Speiseroehre	Observation	Active	20/5/2022
Koerpertemperatur Stirn	Observation	Active	20/5/2022
Koerpertemperatur Trommelfell	Observation	Active	20/5/2022
Koerpertemperatur unter der Zunge	Observation	Active	20/5/2022
Koerpertemperatur vaginal	Observation	Active	20/5/2022
Kopfumfang	Observation	Active	29/4/2022
Linksatrialer Druck	Observation	Active	8/4/2022
Linksventrikulaerer Druck	Observation	Active	16/3/2022
Linksventrikulaerer Herzindex	Observation	Active	6/4/2022
Linksventrikulaerer Herzindex Durch Indikatorverduennung	Observation	Active	8/4/2022
Linksventrikulaerer Schlagvolumenindex Durch Indikatorverduennung	Observation	Active	8/4/2022
Linksventrikulaeres Herzzeitvolumen Durch Indikatorverduennung	Observation	Active	8/4/2022
Linksventrikulaeres Schlagvolumen	Observation	Active	7/4/2022
Linksventrikulaeres Schlagvolumen Durch Indikatorverduennung	Observation	Active	23/3/2022
Linksventrikulaeres Schlagvolumenindex	Observation	Active	8/4/2022
Maximaler Beatmungsdruck	Observation	Active	21/4/2022
Mechanische Atemfrequenz Beatmet	Observation	Active	8/4/2022
Mittlerer Beatmungsdruck	Observation	Active	21/4/2022
Monitoring und Vitaldaten	Observation	Active	29/4/2022
Parameter von Beatmung	Observation	Active	23/5/2022
Parameter von Extrakorporalen Verfahren	Observation	Active	23/5/2022
Periphere Artierielle Sauerstoffsaettigung ICU	Observation	Active	16/3/2022
Positv Endexpiratorischer Druck	Observation	Active	16/3/2022
Pulmonalarterieller Blutdruck	Observation	Active	16/3/2022
Pulmonalarterieller Wedge Druck	Observation	Active	21/3/2022
Pulmonalvaskulaerer Widerstandsindex	Observation	Active	8/4/2022
Puls	Observation	Active	25/4/2022
Rechtsatrialer Druck	Observation	Active	8/4/2022
Rechtsventrikulaerer Druck	Observation	Active	16/3/2022
Sauerstofffraktion	Observation	Active	7/4/2022
Sauerstofffraktion Eingestellt	Observation	Active	7/4/2022
Sauerstoffgasfluss	Observation	Active	8/4/2022
Sauerstoffsaettigung Im Arteriellen Blut Per Pulsoxymetrie	Observation	Active	29/4/2022
Sauerstoffsaettigung Im Blut Postduktal Durch Pulsoxymetrie	Observation	Active	29/4/2022
Sauerstoffsaettigung Im Blut Preduktal Durch Pulsoxymetrie	Observation	Active	29/4/2022
Spontane Atemfrequenz Beatmet	Observation	Active	8/4/2022
Spontane Mechanische Atemfrequenz Beatmet	Observation	Active	8/4/2022
Spontanes Atemzugvolumen	Observation	Active	16/3/2022
Spontanes Plus Mechanisches Atemzugvolumen	Observation	Active	8/4/2022
Substituatfluss	Observation	Active	23/3/2022
Substituatvolumen	Observation	Active	23/3/2022
Systemischer Vaskulaerer Widerstandsindex	Observation	Active	8/4/2022
Unterstuzungsdruck Beatmung	Observation	Active	16/3/2022
Venoeser Druck	Observation	Active	31/3/2022
Zeitverhaeltnis Ein Ausatmung	Observation	Active	16/3/2022
Zentralvenoeser Blutdruck	Observation	Active	16/3/2022
Observation - VitalSignDE - Kopfumfang	Observation	Active	19/4/2022
SD MII Prozedur Procedure	Procedure	Active	2/5/2022
VitalSignDE	Observation	Active	19/4/2022
VitalSignDE Atemfrequenz	Observation	Active	22/4/2022
VitalSignDE Koerpergewicht	Observation	Active	19/4/2022
VitalSignDE Koerpergroesse	Observation	Active	19/4/2022
Koerpertemperatur Generisch	Observation	Active	27/5/2022
\.


--
-- Data for Name: mii_icu_used; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.mii_icu_used (id_profile, profile, typ) FROM stdin;
1	Extrakorporale Verfahren	Procedure
2	Eingestellte und gemessene Parameter (Extrakorporale Verfahren)	DeviceMetric
3	Parameter von extrakorporalen Verfahren	Observation
4	Blutfluss durch cardiovasculaeres Geraet	Observation
5	Ionisiertes Kalzium aus Nierenersatzverfahren	Observation
6	Sauerstoffgasfluss	Observation
7	Dauer Haemodialysesitzung	Observation
8	Haemodialyse Blutfluss	Observation
9	Substituatfluss	Observation
10	Substituatvolumen	Observation
11	Dauer extrakoporaler Gasaustausch	Observation
12	Blutfluss extrakoporaler Gasaustausch	Observation
13	Blutflussindex extrakoporaler Gasaustausch	Observation
14	Venoeser Druck	Observation
15	Arterieller Druck	Observation
16	Beatmung	Procedure
17	Eingestellte und gemessene Parameter (Beatmung)	DeviceMetric
18	Parameter von Beatmung	Observation
19	Unterstuetzungsdruck Beatmung	Observation
20	Endexpiratorischer Kohlendioxidpartialdruck	Observation
21	Atemwegsdruck bei null expiratorischem Gasfluss	Observation
22	Atemwegsdruck bei mittlerem expiratorischem Gasfluss	Observation
23	Druckdifferenz Beatmung	Observation
24	Positiv-endexpiratorischer Druck	Observation
25	Dynamische Kompliance	Observation
26	Maximaler Beatmungsdruck	Observation
27	Mittlerer Beatmungsdruck	Observation
28	Exspiratorischer Sauerstoffpartialdruck	Observation
29	Sauerstofffraktion	Observation
30	Sauerstofffraktion eingestellt	Observation
31	Exspiratorischer Gasfluss	Observation
32	Inspiratorischer Gasfluss	Observation
33	Eingestellter inspiratorischer Gasfluss	Observation
34	Beatmungszeit auf niedriegem Druck	Observation
35	Beatmungszeit auf hohem Druck	Observation
36	Spontanes-Mechanisches-Atemzugvolumen-Waehrend-Beatmung	Observation
37	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	Observation
38	Spontanes-Atemzugvolumen	Observation
39	Atemzugvolumen-Waehrend-Beatmung	Observation
40	Atemzugvolumen-Einstellung	Observation
41	Zeitverhaeltnis-Ein-Ausatmung	Observation
42	Einstellung-Ausatmungszeit-Beatmung	Observation
43	Einstellung-Einatmungszeit-Beatmung	Observation
44	Spontane-Mechanische-Atemfrequenz-Beatmet	Observation
45	Spontane-Atemfrequenz-Beatmet	Observation
46	Mechanische-Atemfrequenz-Beatmet	Observation
47	Horowitz-In-Arteriellem-Blut	Observation
48	Monitoring und Vitaldaten	Observation
49	Pulmonalarterieller wedge Blutdruck	Observation
50	Intrakranieller Druck (ICP)	Observation
51	Atemfrequenz	Observation
52	Kopfumfang	Observation
53	Koerpergroesse	Observation
54	Koerpergewicht	Observation
55	Koerpergewicht Percentil altersabhaengig	Observation
56	Koerpergroesse (Percentile)	Observation
57	Ideales Koerpergewicht	Observation
58	Koerpertemperatur Kern	Observation
59	Sauerstoffsaettigung im Blut preductal durch Pulsoxymetrie	Observation
60	Sauerstoffsaettigung im Blut postduktal durch Pulsoxymetrie	Observation
61	Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie	Observation
64	Linksv. Schlagvolumenindex durch Indikatorverd.	Observation
65	Linksv. Schlagvolumen durch Indikatorverduennung	Observation
66	Pulmonalvaskulaerer Widerstandsindex	Observation
67	Systemischer vaskulaerer Widerstandsindex	Observation
68	Linksventrikulaerer Herzindex	Observation
69	Herzzeitvolumen	Observation
70	Linksv. Herzindex durch Indikatorverduennung	Observation
71	Linksv. Herzzeitvolumen durch Indikatorverduennung	Observation
72	Herzfrequenz	Observation
73	Zentralvenoeser Druck (ZVD)	Observation
74	Blutdruck Generisch	Observation
75	Linksatrialer Druck	Observation
76	Rechtsatrialer Druck	Observation
77	Rechtsventrikulaerer Druck	Observation
78	Linksventrikulaerer Druck	Observation
79	Pulmonalarterieller Blutdruck	Observation
80	Blutdruck	Observation
63	Linksventrikulaerer Schlagvolumenindex	Observation
62	Linksventrikulaeres Schlagvolumen	Observation
\.


--
-- Data for Name: mii_icu_used_all_info; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.mii_icu_used_all_info (id_profile, standard, matched, typ_standard, profile_unit, loinc, snomed, ieee, matching_to_control, mathching) FROM stdin;
1	Extrakorporale Verfahren	\N	Procedure	\N	\N	\N	\N	\N	0
9	Substituatfluss	Substituatfluss	Observation	mL/h	\N	708513005	\N	0	1
3	Parameter von extrakorporalen Verfahren	\N	Observation	\N	\N	\N	\N	\N	0
15	Arterieller Druck	Arterieller Druck	Observation	mm[Hg]	\N	386534000	\N	0	1
48	Monitoring und Vitaldaten	\N	Observation	\N	\N	\N	\N	\N	0
18	Parameter von Beatmung	\N	Observation	\N	\N	\N	\N	\N	0
2	Eingestellte und gemessene Parameter (Extrakorporale Verfahren)	\N	DeviceMetric	\N	\N	\N	\N	\N	0
16	Beatmung	\N	Procedure	\N	\N	\N	\N	\N	0
14	Venoeser Druck	Venoeser Druck	Observation	mm[Hg]	\N	252076005	\N	0	1
52	Kopfumfang	Kopfumfang	Observation	cm	9843-4	363811000	\N	0	1
5	Ionisiertes Kalzium aus Nierenersatzverfahren	Ionisiertes Kalzium aus Nierenersatzverfahren	Observation	mmol/L	83064-6	\N	\N	0	1
51	Atemfrequenz	Atemfrequenz	Observation	/min	9279-1	86290005	\N	0	1
7	Dauer Haemodialysesitzung	Dauer Haemodialysesitzung	Observation	h	\N	445940005	\N	0	1
17	Eingestellte und gemessene Parameter (Beatmung)	\N	DeviceMetric	\N	\N	\N	\N	\N	0
42	Einstellung-Ausatmungszeit-Beatmung	\N	Observation	s	76187-4	250820008	264338	\N	0
38	Spontanes-Atemzugvolumen	\N	Observation	mL	20116-0	250816009	\N	\N	0
64	Linksv. Schlagvolumenindex durch Indikatorverd.	\N	Observation	/mL	8791-6	\N	\N	\N	0
57	Ideales Koerpergewicht	\N	Observation	kg	50064-5	170804003	\N	\N	0
60	Sauerstoffsaettigung im Blut postduktal durch Pulsoxymetrie	\N	Observation	%	59418-4	\N	160300	\N	0
47	Horowitz-In-Arteriellem-Blut	\N	Observation	mm[Hg]	50984-4	\N	150656	\N	0
56	Koerpergroesse (Percentile)	\N	Observation	%	8303-0	1153605006	\N	\N	0
19	Unterstuetzungsdruck Beatmung	\N	Observation	cm[H2O]	20079-0	\N	\N	\N	0
22	Atemwegsdruck bei mittlerem expiratorischem Gasfluss	\N	Observation	cm[H2O]	20056-8	\N	\N	\N	0
12	Blutfluss extrakoporaler Gasaustausch	\N	Observation	L/min	\N	251288004	\N	\N	0
13	Blutflussindex extrakoporaler Gasaustausch	\N	Observation	L/(min.m2)	\N	251289007	\N	\N	0
40	Atemzugvolumen-Einstellung	\N	Observation	mL	20112-9	416811008	16929196	\N	0
36	Spontanes-Mechanisches-Atemzugvolumen-Waehrend-Beatmung	\N	Observation	mL	20118-6	\N	\N	\N	0
63	Linksventrikulaerer Schlagvolumenindex	Linksventrikulaerer Schlagvolumenindex	Observation	mL/m2	76297-1	277381004	\N	0	1
70	Linksv. Herzindex durch Indikatorverduennung	\N	Observation	L/min/m2	8751-0	\N	149772	\N	0
4	Blutfluss durch cardiovasculaeres Geraet	Blutfluss durch cardiovasculaeres Geraet	Observation	L/min	\N	444479000	\N	0	1
37	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	Observation	L/min	76009-0	250875001	152004	0	1
80	Blutdruck	Blutdruck	Observation	mm[Hg]	85354-9	75367002	\N	0	1
74	Blutdruck Generisch	Blutdruck Generisch	Observation	mm[Hg]	85354-9	75367002	\N	0	1
23	Druckdifferenz Beatmung	Druckdifferenz Beatmung	Observation	cm[H2O]	76154-4	\N	152720	0	1
43	Einstellung-Einatmungszeit-Beatmung	Einstellung-Einatmungszeit-Beatmung	Observation	s	76334-2	16929632	152720	0	1
31	Exspiratorischer Gasfluss	Exspiratorischer Gasfluss	Observation	L/min	60792-9	\N	151944	0	1
28	Exspiratorischer Sauerstoffpartialdruck	Exspiratorischer Sauerstoffpartialdruck	Observation	mm[Hg]	3147-6	442720002	153132	0	1
8	Haemodialyse Blutfluss	Haemodialyse Blutfluss	Observation	mL/min	\N	401000124105	\N	0	1
72	Herzfrequenz	Herzfrequenz	Observation	/min	8867-4	364075005	147842	0	1
69	Herzzeitvolumen	Herzzeitvolumen	Observation	L/min	8741-1	82799009	150276	0	1
32	Inspiratorischer Gasfluss	Inspiratorischer Gasfluss	Observation	L/min	60794-5	\N	151948	0	1
50	Intrakranieller Druck (ICP)	Intrakranieller Druck (ICP)	Observation	mm[Hg]	60956-0	250844005	153608	0	1
54	Koerpergewicht	Koerpergewicht	Observation	kg	29463-7	27113001	\N	0	1
53	Koerpergroesse	Koerpergroesse	Observation	cm	8302-2	1153637007	\N	0	1
58	Koerpertemperatur Kern	Koerpertemperatur Kern	Observation	Cel	8329-5	276885007	150368	0	1
75	Linksatrialer Druck	Linksatrialer Druck	Observation	mm[Hg]	85354-9	276762004	\N	0	1
26	Maximaler Beatmungsdruck	Maximaler Beatmungsdruck	Observation	cm[H2O]	76531-3	27913002	151973	0	1
46	Mechanische-Atemfrequenz-Beatmet	Mechanische-Atemfrequenz-Beatmet	Observation	{Breaths}/min	33438-3	250876000	151586	0	1
27	Mittlerer Beatmungsdruck	Mittlerer Beatmungsdruck	Observation	cm[H2O]	76530-5	698821009	151975	0	1
24	Positiv-endexpiratorischer Druck	Positiv-endexpiratorischer Druck	Observation	cm[H2O]	76248-4	250854009	151976	0	1
79	Pulmonalarterieller Blutdruck	Pulmonalarterieller Blutdruck	Observation	mm[Hg]	85354-9	75367002	\N	0	1
49	Pulmonalarterieller wedge Blutdruck	Pulmonalarterieller wedge Blutdruck	Observation	mm[Hg]	75994-4	118433006	150052	0	1
66	Pulmonalvaskulaerer Widerstandsindex	Pulmonalvaskulaerer Widerstandsindex	Observation	dyn.s/(cm5.m2)	8834-4	276902009	152852	0	1
77	Rechtsventrikulaerer Druck	\N	Observation	mm[Hg]	85354-9	75367002	\N	\N	0
29	Sauerstofffraktion	Sauerstofffraktion	Observation	1	71835-3	250774007	\N	0	1
6	Sauerstoffgasfluss	Sauerstoffgasfluss	Observation	L/min	19941-4	79063001	\N	0	1
45	Spontane-Atemfrequenz-Beatmet	Spontane-Atemfrequenz-Beatmet	Observation	/min	\N	271625008	152498	0	1
44	Spontane-Mechanische-Atemfrequenz-Beatmet	Spontane-Mechanische-Atemfrequenz-Beatmet	Observation	/min	19840-8	250810003	152490	0	1
10	Substituatvolumen	\N	Observation	L	\N	708514004	\N	\N	0
41	Zeitverhaeltnis-Ein-Ausatmung	Zeitverhaeltnis-Ein-Ausatmung	Observation	{ratio}	75931-6	250822000	151832	0	1
30	Sauerstofffraktion eingestellt	Sauerstofffraktion eingestellt	Observation	%	19994-3	250774007	\N	0	1
34	Beatmungszeit auf niedriegem Druck	\N	Observation	s	76229-4	\N	16929864	\N	0
21	Atemwegsdruck bei null expiratorischem Gasfluss	\N	Observation	cm[H2O]	20060-0	\N	\N	\N	0
11	Dauer extrakoporaler Gasaustausch	\N	Observation	h	\N	251286000	\N	\N	0
25	Dynamische Kompliance	\N	Observation	mL/cm[H2O]	60827-3	250823005	151692	\N	0
35	Beatmungszeit auf hohem Druck	\N	Observation	s	76190-8	\N	16929860	\N	0
33	Eingestellter inspiratorischer Gasfluss	\N	Observation	L/min	76275-7	\N	\N	\N	0
55	Koerpergewicht Percentil altersabhaengig	\N	Observation	%	8336-0	1153592008	\N	\N	0
65	Linksv. Schlagvolumen durch Indikatorverduennung	\N	Observation	/mL	8771-8	\N	\N	\N	0
71	Linksv. Herzzeitvolumen durch Indikatorverduennung	\N	Observation	L/min	8737-9	\N	150276	\N	0
20	Endexpiratorischer Kohlendioxidpartialdruck	\N	Observation	mm[Hg]	19891-1	250784008	151708	\N	0
59	Sauerstoffsaettigung im Blut preductal durch Pulsoxymetrie	\N	Observation	%	59407-7	\N	160296	\N	0
39	Atemzugvolumen-Waehrend-Beatmung	Atemzugvolumen-Waehrend-Beatmung	Observation	mL	76222-9	250874002	151980	0	1
78	Linksventrikulaerer Druck	\N	Observation	mm[Hg]	85354-9	75367002	\N	\N	0
68	Linksventrikulaerer Herzindex	Linksventrikulaerer Herzindex	Observation	L/(min.m2)	75919-1	54993008	149772	0	1
62	Linksventrikulaeres Schlagvolumen	Linksventrikulaeres Schlagvolumen	Observation	/mL	20562-5	\N	150428	0	1
76	Rechtsatrialer Druck	\N	Observation	mm[Hg]	85354-9	75367002	\N	\N	0
61	Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie	Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie	Observation	%	59408-5	442476006	150456	0	1
67	Systemischer vaskulaerer Widerstandsindex	Systemischer vaskulaerer Widerstandsindex	Observation	dyn.s/(cm5.m2)	8837-7	276900001	149760	0	1
73	Zentralvenoeser Druck (ZVD)	Zentralvenoeser Druck (ZVD)	Observation	mm[Hg]	60985-9	71420008	150084	0	1
\.


--
-- Data for Name: profile_config_vars_python; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.profile_config_vars_python (profil, config_var_name_description, score) FROM stdin;
Extrakorporale Verfahren	Nierenverfahren_VO_Filter Filter  für extrakorporale Verfahren	100
Extrakorporale Verfahren	Nierenverfahren_VO_Zugang VO Gefäßzugang extracorporale Verfahren	55
Extrakorporale Verfahren	Nierenverfahren_VO_Bolus Medikament	47
Extrakorporale Verfahren	Nierenverfahren_ES_Multi_CitratBlut Citratrate	46
Extrakorporale Verfahren	Nierenersatzverfahren_Mess_Bilanz	46
Substituatfluss	NEV_CRRT_MS_Multi_Citratfluss	55
Substituatfluss	NEV_CRRT_ES_Multi_Blutfluss	52
Substituatfluss	NEV_CRRT_ES_Multi_Substituat	47
Substituatfluss	Betreuer_Status	47
Substituatfluss	Hausarzt_Strasse	45
Parameter von extrakorporalen Verfahren	Nierenverfahren_VO_Filter Filter  für extrakorporale Verfahren	63
Parameter von extrakorporalen Verfahren	Nierenverfahren_VO_Zugang VO Gefäßzugang extracorporale Verfahren	63
Parameter von extrakorporalen Verfahren	Nierenverfahren_VO_SpülloesungAntikoagulanz Spüllösung zum Vorbereiten des extrakorporalen Verfahrens	56
Parameter von extrakorporalen Verfahren	Nierenverfahren_VO_Antikoagulanz Antikoagulation Medikament	51
Parameter von extrakorporalen Verfahren	Nierenverfahren_VO_Bolus Medikament	51
Arterieller Druck	Nierenverfahren_MS_Multi_artDruck arterieller Druck	100
Arterieller Druck	ABP_1 arterieller Blutdruck 1	79
Arterieller Druck	ABP_2 zweiter arterieller Blutdruck	79
Arterieller Druck	PAP Pulmunalarterieller Druck	74
Arterieller Druck	ICP Intrakranialer Druck	59
Monitoring und Vitaldaten	ART 2. artereille Messung, ab 201712 im Rahmen Umstellung Philips Monitoring	57
Monitoring und Vitaldaten	Beatmung_MS_G5_ExpMinVol Exspiratorisches Minutenvolumen, Monitoring-Parameter	57
Monitoring und Vitaldaten	Beatmung_MS_G5_Rinsp Inspiratorische Flow-Resistance, ein Monitoring-Parameter	57
Monitoring und Vitaldaten	Beatmung_MS_G5_ftotal Gesamtatemfrequenz, ein Monitoring Parameter	57
Monitoring und Vitaldaten	P_Temperatur_generic Anlage für Philips Monitoring	57
Parameter von Beatmung	Beatmung_ES_C2_ProzentVol	60
Parameter von Beatmung	Beatmung_MS_G5_ExpMinVol Exspiratorisches Minutenvolumen, Monitoring-Parameter	58
Parameter von Beatmung	Beatmung_MS_G5_Rinsp Inspiratorische Flow-Resistance, ein Monitoring-Parameter	58
Parameter von Beatmung	Beatmung_MS_G5_ftotal Gesamtatemfrequenz, ein Monitoring Parameter	58
Parameter von Beatmung	Beatmung_MS_G5_Pplateau Plateau-Atemwegsdruck, ein Monitoring-Parameter	58
Eingestellte und gemessene Parameter (Extrakorporale Verfahren)	Nierenverfahren_VO_Filter Filter  für extrakorporale Verfahren	66
Eingestellte und gemessene Parameter (Extrakorporale Verfahren)	Nierenverfahren_VO_Zugang VO Gefäßzugang extracorporale Verfahren	56
Eingestellte und gemessene Parameter (Extrakorporale Verfahren)	Beatmung_ES_Evita4_frequenz eingestellte Atemfrequenz	51
Eingestellte und gemessene Parameter (Extrakorporale Verfahren)	Beatmung_ES_Evita4_Tinsp eingestellte absolute Inspirationszeit	50
Eingestellte und gemessene Parameter (Extrakorporale Verfahren)	Beatmung_ES_Evita4_fApnoe eingestellte Atemfrequenz in der Apnoeventilation	50
Beatmung	P_Beatmung_ES_NO	67
Beatmung	P_Beatmung_MS_NO2	64
Beatmung	Beatmung_MS_C2_TE	64
Beatmung	Beatmung_ES_C2_Ti	64
Beatmung	Beatmung_MS_G5_VTi	62
Venoeser Druck	ZVD Zentralvenöser Druck	65
Venoeser Druck	PAP Pulmunalarterieller Druck	53
Venoeser Druck	Beatmung_MS_G5_Pinsp Inspiratorischer Druck; mit Pinsp wird der Zieldruck (zusätzlich zu PEEP/CPAP) bezeichnet, der im Modus ASV während der Inspirationsphase abgegeben wird	53
Venoeser Druck	ICP Intrakranialer Druck	53
Venoeser Druck	Beatmung_MS_G5_AutoPeep Unerwarteter positiver endexspiratorischer Druck, ein Monitoring-Parameter	53
Kopfumfang	COPRA_Patient_Kopfumfang Kopfumfang des Patienten in Zentimetern	100
Kopfumfang	NEV_HD_VO_Zugang	38
Kopfumfang	Patient_Verfügung	38
Kopfumfang	Untersuchung_Kopf_Augen	36
Kopfumfang	NEV_CRRT_VO_Zugang	36
Ionisiertes Kalzium aus Nierenersatzverfahren	Nierenersatzverfahren_Mess_Bilanz	54
Ionisiertes Kalzium aus Nierenersatzverfahren	Nierenersatzverfahren_Einstell_UFR	53
Ionisiertes Kalzium aus Nierenersatzverfahren	Lungenersatzverfahren_Doku_Kathetertyp Kathetertyp	53
Ionisiertes Kalzium aus Nierenersatzverfahren	Nierenersatzverfahren_Mess_VenDruck	52
Ionisiertes Kalzium aus Nierenersatzverfahren	Lungenersatzverfahren_Doku_Zugang Gefäßzugang	52
Atemfrequenz	AF Atemfrequenz	100
Atemfrequenz	Beatmung_MS_G5_fspontan Spontane Atemfrequenz	100
Atemfrequenz	Beatmung_ES_Evita4_frequenz eingestellte Atemfrequenz	100
Atemfrequenz	Beatmung_ES_Evita4_fApnoe eingestellte Atemfrequenz in der Apnoeventilation	100
Atemfrequenz	HF Herzfrequenz	67
Dauer Haemodialysesitzung	NEV_CRRT_VO_Dialysatloesung	54
Dauer Haemodialysesitzung	P_NEV_HD_ES_5008onl_Dialyse_Zeit	46
Dauer Haemodialysesitzung	Nierenersatzverfahren_Mess_Dialysatvolumen	45
Dauer Haemodialysesitzung	Nierenverfahren_VO_4008HS_Dialysezeit	45
Dauer Haemodialysesitzung	NEV_HD_VO_4008HS_Dialysezeit	45
Eingestellte und gemessene Parameter (Beatmung)	Beatmung_ES_Evita4_ASB eingestellte Druckunterstützung	63
Eingestellte und gemessene Parameter (Beatmung)	Beatmung_MS_G5_ftotal Gesamtatemfrequenz, ein Monitoring Parameter	62
Eingestellte und gemessene Parameter (Beatmung)	Beatmung_MS_Evita4_frequenz gemessene Gesamtatemfrequenz	61
Eingestellte und gemessene Parameter (Beatmung)	Beatmung_MS_G5_TE Exspirationzeit, ein Monitoring-Parameter	60
Eingestellte und gemessene Parameter (Beatmung)	Beatmung_ES_Evita4_PEEP eingestelltes PEEP Niveau	60
Einstellung-Ausatmungszeit-Beatmung	Beatmung_MS_Heimbeatmung_Pmittel	63
Einstellung-Ausatmungszeit-Beatmung	Beatmung_MS_Heimbeatmung_VTe	60
Einstellung-Ausatmungszeit-Beatmung	Beatmung_ES_Heimbeatmung_Peep	59
Einstellung-Ausatmungszeit-Beatmung	Beatmung_ES_Heimbeatmung_Frequenz	59
Einstellung-Ausatmungszeit-Beatmung	Beatmung_ES_Heimbeatmung_Pcontrol	59
Spontanes-Atemzugvolumen	Beatmung_Messung_VTeMl VTe / ex. Atemzugvolumen (Tidal Volumen expir.)	74
Spontanes-Atemzugvolumen	Beatmung_MS_C2_fSpontan	55
Spontanes-Atemzugvolumen	Beatmung_MS_Servoi_Mve_spont Spontanes exsp. Minutenvolumen	55
Spontanes-Atemzugvolumen	Beatmung_MS_G5_fspontan Spontane Atemfrequenz	52
Spontanes-Atemzugvolumen	p-SV Schlagvolumen	52
Linksv. Schlagvolumenindex durch Indikatorverd.	Schlagvolumenindex Wert des gemessenen Schlagvolumenindex.	64
Linksv. Schlagvolumenindex durch Indikatorverd.	p-SVI Schlagvolumenindex  (PICCO Modul Dräger Monitoring)	63
Linksv. Schlagvolumenindex durch Indikatorverd.	Vigileo_SVI SchlagvolumenindexSchlagvolumenindex	54
Linksv. Schlagvolumenindex durch Indikatorverd.	Schlagvolumen gemessenes Schlagvolumen	49
Linksv. Schlagvolumenindex durch Indikatorverd.	GEDVI Index des enddiastolisches Volumen	49
Ideales Koerpergewicht	Beatmung_ES_G5_Body_Wt Eingestelltes Körpergewicht.	51
Ideales Koerpergewicht	Patient_Gewicht Gewicht des Patienten	47
Ideales Koerpergewicht	Patient_AufnGewicht Aufnahmegewicht (fallbezogen)	43
Ideales Koerpergewicht	Beatmung_Messung_Horrowitz	42
Ideales Koerpergewicht	TempPBT Temperatur bei der PICCO Messung	42
Sauerstoffsaettigung im Blut postduktal durch Pulsoxymetrie	SpO2 Sauerstoffsättigung Pulsoxymetrie	67
Sauerstoffsaettigung im Blut postduktal durch Pulsoxymetrie	P_INVOS_Doku_rSO2_rechts cerbebrale Sauerstoffsättigung rechts	57
Sauerstoffsaettigung im Blut postduktal durch Pulsoxymetrie	P_INVOS_Doku_rSO2_links cerebrale Sauerstoffsättigung links	56
Sauerstoffsaettigung im Blut postduktal durch Pulsoxymetrie	PtiO2Druck Gemessener Sauerstoffpartialdruck im Parenchym	48
Sauerstoffsaettigung im Blut postduktal durch Pulsoxymetrie	Beatmung_ES_Servoi_O2 Sauerstoffkonzentration	46
Horowitz-In-Arteriellem-Blut	ABP_2 zweiter arterieller Blutdruck	60
Horowitz-In-Arteriellem-Blut	ABP_1 arterieller Blutdruck 1	56
Horowitz-In-Arteriellem-Blut	Beatmung_Messung_Horrowitz	44
Horowitz-In-Arteriellem-Blut	Fontanelle_Beurteilung	44
Horowitz-In-Arteriellem-Blut	Nierenverfahren_MS_Multi_artDruck arterieller Druck	43
Koerpergroesse (Percentile)	Patient_Groesse Größe des Patienten	59
Koerpergroesse (Percentile)	Nierenverfahren_ES_4008HS_Temperatur	43
Koerpergroesse (Percentile)	Betreuer_Name Betreuer des Patienten	43
Koerpergroesse (Percentile)	NEV_Apherese_ES_Multi_Plasma	42
Koerpergroesse (Percentile)	Angehoerige1_Telefon Angehoerigen-Telefon	42
Unterstuetzungsdruck Beatmung	Beatmung_Einstellung_DruckFlow	68
Unterstuetzungsdruck Beatmung	Beatmung_Einstellung_DruckTrigger	65
Unterstuetzungsdruck Beatmung	IABP_DatascopeCS100_ES_Unterstützungsdruck	60
Unterstuetzungsdruck Beatmung	Beatmung_Messung_ASB	57
Unterstuetzungsdruck Beatmung	Beatmung_ES_C2_Druckrampe	56
Atemwegsdruck bei mittlerem expiratorischem Gasfluss	Beatmung_ES_VisionA_MAP Mittlerer Atemwegsdruck (MAP)	62
Atemwegsdruck bei mittlerem expiratorischem Gasfluss	Beatmung_MS_Servoi_Pmean Mittlerer Atemwegsdruck	62
Atemwegsdruck bei mittlerem expiratorischem Gasfluss	Beatmung_MS_Evita4_PEEP gemessener positiver endexspiratorischer Druck	57
Atemwegsdruck bei mittlerem expiratorischem Gasfluss	Beatmung_MS_G5_Rexsp Exspiratorische Flow-Resistance, ein Monitoring-Parameter	54
Atemwegsdruck bei mittlerem expiratorischem Gasfluss	Beatmung_Einstellung_PEEP Positiver endexspiratorischer Druck (PEEP)	54
Blutfluss extrakoporaler Gasaustausch	ITBVI Index des intrathorakalen Blutvolumens	52
Blutfluss extrakoporaler Gasaustausch	ITBV Intrathorakales Blutvolumen	49
Blutfluss extrakoporaler Gasaustausch	EVLW Extravaskuläres Lungenwasser	43
Blutfluss extrakoporaler Gasaustausch	Betreuer_Status	42
Blutfluss extrakoporaler Gasaustausch	SpO2 Sauerstoffsättigung Pulsoxymetrie	41
Blutflussindex extrakoporaler Gasaustausch	ITBVI Index des intrathorakalen Blutvolumens	56
Blutflussindex extrakoporaler Gasaustausch	ITBV Intrathorakales Blutvolumen	49
Blutflussindex extrakoporaler Gasaustausch	Beatmung_MS_G5_Cstat Statische Compliance, ein Monitoringwert	43
Blutflussindex extrakoporaler Gasaustausch	Nierenverfahren_ES_BM25_Blutfluss Blutpumpengeschwindigkeit	42
Blutflussindex extrakoporaler Gasaustausch	SpO2 Sauerstoffsättigung Pulsoxymetrie	41
Atemzugvolumen-Einstellung	Beatmung_Messung_VTeMl VTe / ex. Atemzugvolumen (Tidal Volumen expir.)	70
Atemzugvolumen-Einstellung	Beatmung_ES_C2_Pmax Eingestellte Alarmhochdruckgrenze. Einstellung erfolgtdirekt über die Alarmeinstellung aber auch indirekt über die Einstellung Pasvlimit. Die Alarmhochdruckgrenze liegt automatisch 10 mbar über der Pasvlimit Einstellung.	59
Atemzugvolumen-Einstellung	Beatmung_Einstellung_DruckFlow	57
Atemzugvolumen-Einstellung	Beatmung_Einstellung_ASBAnstieg	56
Atemzugvolumen-Einstellung	Beatmung_Einstellung_FlowTrigger	55
Spontanes-Mechanisches-Atemzugvolumen-Waehrend-Beatmung	Beatmung_Messung_VTeMl VTe / ex. Atemzugvolumen (Tidal Volumen expir.)	59
Spontanes-Mechanisches-Atemzugvolumen-Waehrend-Beatmung	Beatmung_MS_Evita4_MV gemessenes Atemminutenvolumen	57
Spontanes-Mechanisches-Atemzugvolumen-Waehrend-Beatmung	Beatmung_MS_G5_fspontan Spontane Atemfrequenz	56
Spontanes-Mechanisches-Atemzugvolumen-Waehrend-Beatmung	Beatmung_MS_Servoi_Mve_spont Spontanes exsp. Minutenvolumen	50
Spontanes-Mechanisches-Atemzugvolumen-Waehrend-Beatmung	Beatmung_MS_G5_Ppeak Messwert: Beatmungsspitzendruck	49
Linksventrikulaerer Schlagvolumenindex	Schlagvolumenindex Wert des gemessenen Schlagvolumenindex.	66
Linksventrikulaerer Schlagvolumenindex	p-SVI Schlagvolumenindex  (PICCO Modul Dräger Monitoring)	64
Linksventrikulaerer Schlagvolumenindex	Schlagvolumen gemessenes Schlagvolumen	58
Linksventrikulaerer Schlagvolumenindex	Vigileo_SVI SchlagvolumenindexSchlagvolumenindex	56
Linksventrikulaerer Schlagvolumenindex	EVLWI Extravaskuläres Lungenwasserindex	53
Linksv. Herzindex durch Indikatorverduennung	CI Herzindex	86
Linksv. Herzindex durch Indikatorverduennung	p-CI Herzindex	78
Linksv. Herzindex durch Indikatorverduennung	VigilanceC_CI Herzindex	56
Linksv. Herzindex durch Indikatorverduennung	PCCI Herzindex (kontinuirlich)	49
Linksv. Herzindex durch Indikatorverduennung	ITBVI Index des intrathorakalen Blutvolumens	46
Blutfluss durch cardiovasculaeres Geraet	EVLW Extravaskuläres Lungenwasser	47
Blutfluss durch cardiovasculaeres Geraet	ITBVI Index des intrathorakalen Blutvolumens	45
Blutfluss durch cardiovasculaeres Geraet	Beatmung_MS_VisionA_SISetting Dauer des manuell durchgeführten Atemhubs	45
Blutfluss durch cardiovasculaeres Geraet	EVLWI Extravaskuläres Lungenwasserindex	44
Blutfluss durch cardiovasculaeres Geraet	CardioHelpMaquet_MS_DruckArteriell	43
Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	Beatmung_ES_G5_Frequenz Anzahl der Atemzyklen pro Minute, Parametereinstellung	56
Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	Beatmung_MS_Servoi_Pmean Mittlerer Atemwegsdruck	56
Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	Beatmung_MS_G5_Pmittel Messwert: Beatmungsmitteldruck	54
Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	Beatmung_Messung_MVSpontan Mindest Volumen sp	54
Beatmungsvolumen-Pro-Minute-Machineller-Beatmung	Beatmung_MS_G5_Ppeak Messwert: Beatmungsspitzendruck	53
Blutdruck	ABP_1 arterieller Blutdruck 1	100
Blutdruck	NBP_1 nichtinvasiver Blutdruck 1	100
Blutdruck	ABP_2 zweiter arterieller Blutdruck	100
Blutdruck	Beatmung_ES_C2_Druckrampe	41
Blutdruck	Beatmung_Einstellung_DruckFlow	41
Blutdruck Generisch	ABP_1 arterieller Blutdruck 1	64
Blutdruck Generisch	NBP_1 nichtinvasiver Blutdruck 1	64
Blutdruck Generisch	ABP_2 zweiter arterieller Blutdruck	64
Blutdruck Generisch	ZVD Zentralvenöser Druck	48
Blutdruck Generisch	PPV Pulsdruckabweichung	48
Druckdifferenz Beatmung	Beatmung_MS_VisionA_Amplitude gemessene Druckdifferenz im HFOV Modus	76
Druckdifferenz Beatmung	Beatmung_ES_C2_Druckrampe	62
Druckdifferenz Beatmung	P_Beatmung_ES_C3_Druckrampe	60
Druckdifferenz Beatmung	Beatmung_Einstellung_DruckTrigger	57
Druckdifferenz Beatmung	Beatmung_Einstellung_DruckFlow	53
Einstellung-Einatmungszeit-Beatmung	Beatmung_Einstellung_ASBAnstieg	64
Einstellung-Einatmungszeit-Beatmung	Beatmung_MS_Heimbeatmung_Pmittel	63
Einstellung-Einatmungszeit-Beatmung	Beatmung_ES_G5_Sauerstoff Sauerstoffeinstellung	61
Einstellung-Einatmungszeit-Beatmung	Beatmung_Einstellung_ProzentMinVol	61
Einstellung-Einatmungszeit-Beatmung	Beatmung_Einstellung_Anfeuchtung	60
Exspiratorischer Gasfluss	Beatmung_MS_G5_ExspFlow Exspiratorischer Peakflow, ein Monitoring-Parameter	78
Exspiratorischer Gasfluss	P_Beatmung_ES_C3_Pinsp Inspiratorischer Druck	54
Exspiratorischer Gasfluss	GEDV Globales enddiastolisches Volumen	51
Exspiratorischer Gasfluss	CardioHelpMaquet_ES_Gasfluss	49
Exspiratorischer Gasfluss	Beatmung_ES_CF800_DruckluftFlow Einstellgröße: Gasfluss Druckluft	48
Exspiratorischer Sauerstoffpartialdruck	PtiO2Druck Gemessener Sauerstoffpartialdruck im Parenchym	72
Exspiratorischer Sauerstoffpartialdruck	Beatmung_MS_G5_ExspFlow Exspiratorischer Peakflow, ein Monitoring-Parameter	58
Exspiratorischer Sauerstoffpartialdruck	SpO2 Sauerstoffsättigung Pulsoxymetrie	50
Exspiratorischer Sauerstoffpartialdruck	P_Beatmung_ES_C3_Pinsp Inspiratorischer Druck	50
Exspiratorischer Sauerstoffpartialdruck	NEV_Apherese_MS_Multi_artDruck	49
Haemodialyse Blutfluss	ITBV Intrathorakales Blutvolumen	44
Haemodialyse Blutfluss	HeartWare_Blutfluss_Doku	43
Haemodialyse Blutfluss	ITBVI Index des intrathorakalen Blutvolumens	42
Haemodialyse Blutfluss	NEV_HD_VO_4008HS_Blutfluss_Max	42
Haemodialyse Blutfluss	NEV_CRRT_VO_Multi_BlutflussMax	42
Herzfrequenz	HF Herzfrequenz	100
Herzfrequenz	AF Atemfrequenz	67
Herzfrequenz	HZV Herzzeitvolumen	58
Herzfrequenz	Herzrhythmus Herzrhythmus	50
Herzfrequenz	Beatmung_ES_Heimbeatmung_Frequenz	44
Herzzeitvolumen	PCCO Pulskontur-Herzzeitvolumen	100
Herzzeitvolumen	VigilanceC_HZV Herzzeitvolumen	100
Herzzeitvolumen	p-CO Herzzeitvolumen (PICCO Modul Dräger Monitoring)	100
Herzzeitvolumen	HZV Herzzeitvolumen	100
Herzzeitvolumen	HF Herzfrequenz	53
Inspiratorischer Gasfluss	Beatmung_MS_G5_Pinsp Inspiratorischer Druck; mit Pinsp wird der Zieldruck (zusätzlich zu PEEP/CPAP) bezeichnet, der im Modus ASV während der Inspirationsphase abgegeben wird	78
Inspiratorischer Gasfluss	Beatmung_MS_G5_InspFlow Inspiratorischer Peakflow, ein Monitoring-Parameter	78
Inspiratorischer Gasfluss	P_Beatmung_ES_C3_Pinsp Inspiratorischer Druck	78
Inspiratorischer Gasfluss	Lungenersatzverfahren_Doku_ECMOInspiratorischSaO2	49
Inspiratorischer Gasfluss	Beatmung_ES_CF800_DruckluftFlow Einstellgröße: Gasfluss Druckluft	48
Intrakranieller Druck (ICP)	ICP Intrakranialer Druck	94
Intrakranieller Druck (ICP)	PAP Pulmunalarterieller Druck	63
Intrakranieller Druck (ICP)	ZVD Zentralvenöser Druck	54
Intrakranieller Druck (ICP)	NBP_1 nichtinvasiver Blutdruck 1	49
Intrakranieller Druck (ICP)	Nierenverfahren_MS_Multi_venDruck venöser Druck	45
Koerpergewicht	NIRSrechts_MS	44
Koerpergewicht	Beatmung_ES_G5_Body_Wt Eingestelltes Körpergewicht.	41
Koerpergewicht	Angehoerige1_Ort	40
Koerpergewicht	Angehoerige1_Verwandschaftsgrad	40
Koerpergewicht	Patient_Gewicht Gewicht des Patienten	39
Koerpergroesse	Patient_Groesse Größe des Patienten	47
Koerpergroesse	Angehoerige1_Strasse	47
Koerpergroesse	Patient_Ort Patientenadresse: Ort	43
Koerpergroesse	Fall_Wertsachen_Prothese	42
Koerpergroesse	Betreuer_Status	41
Koerpertemperatur Kern	Untersuchung_Status_Koerpertemperatur	68
Koerpertemperatur Kern	Temp1a Temperatur 1a	62
Koerpertemperatur Kern	Temp2a Temperatur 2a	62
Koerpertemperatur Kern	Temp2b Temperatur 2b	62
Koerpertemperatur Kern	NEV_CRRT_ES_Multi_Temperatur	56
Linksatrialer Druck	ICP Intrakranialer Druck	70
Linksatrialer Druck	PAP Pulmunalarterieller Druck	62
Linksatrialer Druck	ZVD Zentralvenöser Druck	62
Linksatrialer Druck	LAP Linksatrial  Mitteldruck	61
Linksatrialer Druck	NBP_1 nichtinvasiver Blutdruck 1	47
Maximaler Beatmungsdruck	Beatmung_MS_G5_PeepCPAP Messwert: Beatmungsdruck Peep / CPAP	74
Maximaler Beatmungsdruck	Beatmung_ES_C2_Druckrampe	69
Maximaler Beatmungsdruck	P_Beatmung_ES_C3_Druckrampe	67
Maximaler Beatmungsdruck	Beatmung_Einstellung_DruckTrigger	60
Maximaler Beatmungsdruck	Beatmung_MS_C2_Pmittel	57
Mechanische-Atemfrequenz-Beatmet	AF Atemfrequenz	89
Mechanische-Atemfrequenz-Beatmet	Beatmung_MS_G5_fspontan Spontane Atemfrequenz	60
Mechanische-Atemfrequenz-Beatmet	Beatmung_ES_Evita4_frequenz eingestellte Atemfrequenz	59
Mechanische-Atemfrequenz-Beatmet	Beatmung_ES_Evita2_Frequenz eingestellt mandatorische Atemfrquenz	58
Mechanische-Atemfrequenz-Beatmet	Beatmung_ES_Evita4_fApnoe eingestellte Atemfrequenz in der Apnoeventilation	55
Mittlerer Beatmungsdruck	Beatmung_MS_G5_PeepCPAP Messwert: Beatmungsdruck Peep / CPAP	74
Mittlerer Beatmungsdruck	Beatmung_ES_C2_Druckrampe	65
Mittlerer Beatmungsdruck	Beatmung_MS_C2_Pmittel	65
Mittlerer Beatmungsdruck	Beatmung_Einstellung_DruckTrigger	63
Mittlerer Beatmungsdruck	P_Beatmung_ES_C3_Druckrampe	63
Positiv-endexpiratorischer Druck	Beatmung_Einstellung_PEEP Positiver endexspiratorischer Druck (PEEP)	65
Positiv-endexpiratorischer Druck	Beatmung_MS_Evita4_PEEP gemessener positiver endexspiratorischer Druck	63
Positiv-endexpiratorischer Druck	P_Beatmung_ES_C3_Pinsp Inspiratorischer Druck	62
Positiv-endexpiratorischer Druck	ZVD Zentralvenöser Druck	55
Positiv-endexpiratorischer Druck	ICP Intrakranialer Druck	50
Pulmonalarterieller Blutdruck	PAP Pulmunalarterieller Druck	83
Pulmonalarterieller Blutdruck	ABP_1 arterieller Blutdruck 1	76
Pulmonalarterieller Blutdruck	ABP_2 zweiter arterieller Blutdruck	69
Pulmonalarterieller Blutdruck	CardioHelpMaquet_MS_DruckArteriell	54
Pulmonalarterieller Blutdruck	ICP Intrakranialer Druck	53
Pulmonalarterieller wedge Blutdruck	PAP Pulmunalarterieller Druck	75
Pulmonalarterieller wedge Blutdruck	ABP_2 zweiter arterieller Blutdruck	74
Pulmonalarterieller wedge Blutdruck	ABP_1 arterieller Blutdruck 1	69
Pulmonalarterieller wedge Blutdruck	CardioHelpMaquet_MS_DruckArteriell	49
Pulmonalarterieller wedge Blutdruck	NBP_1 nichtinvasiver Blutdruck 1	48
Pulmonalvaskulaerer Widerstandsindex	EVLWI Extravaskuläres Lungenwasserindex	51
Pulmonalvaskulaerer Widerstandsindex	PVRI Pulmunaler Gefäßwiderstandsindex	48
Pulmonalvaskulaerer Widerstandsindex	PVPI Pulmonalvaskuläer Permeabilitätsindex	47
Pulmonalvaskulaerer Widerstandsindex	SVRI Index des systemischen Gefäßwiderstandes	46
Pulmonalvaskulaerer Widerstandsindex	EVLW Extravaskuläres Lungenwasser	44
Rechtsventrikulaerer Druck	ZVD Zentralvenöser Druck	57
Rechtsventrikulaerer Druck	ICP Intrakranialer Druck	56
Rechtsventrikulaerer Druck	PAP Pulmunalarterieller Druck	51
Rechtsventrikulaerer Druck	Nierenverfahren_MS_Multi_venDruck venöser Druck	50
Rechtsventrikulaerer Druck	Beatmung_MS_Servoi_Pmean Mittlerer Atemwegsdruck	49
Sauerstofffraktion	GEF Globale Auswurffraktion	53
Sauerstofffraktion	Beatmung_ES_Servoi_O2 Sauerstoffkonzentration	51
Sauerstofffraktion	SpO2 Sauerstoffsättigung Pulsoxymetrie	47
Sauerstofffraktion	Beatmung_ES_C2_Sauerstoff	47
Sauerstofffraktion	Beatmung_MS_C2_Sauerstoff	47
Sauerstoffgasfluss	CardioHelpMaquet_ES_Gasfluss	52
Sauerstoffgasfluss	Lungenersatzverfahren_Doku_ILA_Gasfluss	49
Sauerstoffgasfluss	Betreuer_Status	48
Sauerstoffgasfluss	SpO2 Sauerstoffsättigung Pulsoxymetrie	47
Sauerstoffgasfluss	Beatmung_ES_C2_Sauerstoff	47
Spontane-Atemfrequenz-Beatmet	AF Atemfrequenz	89
Spontane-Atemfrequenz-Beatmet	Beatmung_MS_G5_fspontan Spontane Atemfrequenz	84
Spontane-Atemfrequenz-Beatmet	Beatmung_ES_Evita4_frequenz eingestellte Atemfrequenz	59
Spontane-Atemfrequenz-Beatmet	Beatmung_ES_Evita4_fApnoe eingestellte Atemfrequenz in der Apnoeventilation	59
Spontane-Atemfrequenz-Beatmet	Beatmung_ES_Evita2_Frequenz eingestellt mandatorische Atemfrquenz	53
Spontane-Mechanische-Atemfrequenz-Beatmet	AF Atemfrequenz	89
Spontane-Mechanische-Atemfrequenz-Beatmet	Beatmung_MS_G5_fspontan Spontane Atemfrequenz	70
Spontane-Mechanische-Atemfrequenz-Beatmet	Beatmung_ES_Evita4_frequenz eingestellte Atemfrequenz	57
Spontane-Mechanische-Atemfrequenz-Beatmet	Beatmung_ES_Evita2_Frequenz eingestellt mandatorische Atemfrquenz	53
Spontane-Mechanische-Atemfrequenz-Beatmet	Beatmung_MS_Servoi_Ppeak Atemdruck Spitze	51
Substituatvolumen	Nierenersatzverfahren_Mess_SubstituatVolumen	56
Substituatvolumen	p-SV Schlagvolumen	51
Substituatvolumen	NEV_CRRT_MS_Multi_CitratvolKum	51
Substituatvolumen	IABP_Doku_Ballonvolumen	50
Substituatvolumen	HZV Herzzeitvolumen	50
Zeitverhaeltnis-Ein-Ausatmung	Beatmung_ES_G5_IEVerhältnis_Backup	58
Zeitverhaeltnis-Ein-Ausatmung	Beatmung_ES_Heimbeatmung_Ti	50
Zeitverhaeltnis-Ein-Ausatmung	Beatmung_Einstellung_O2Konzentration	49
Zeitverhaeltnis-Ein-Ausatmung	Beatmung_MS_G5_IEVerhaeltnis gemessenes I:E Verhältnis	49
Zeitverhaeltnis-Ein-Ausatmung	Beatmung_ES_Optiflow_O2Konzentration	49
Sauerstofffraktion eingestellt	Beatmung_Einstellung_SauerstoffFlow	65
Sauerstofffraktion eingestellt	Beatmung_ES_Servoi_O2 Sauerstoffkonzentration	61
Sauerstofffraktion eingestellt	Beatmung_Einstellung_O2Konzentration	55
Sauerstofffraktion eingestellt	Beatmung_ES_C2_Sauerstoff	55
Sauerstofffraktion eingestellt	Beatmung_ES_Evita2_Frequenz eingestellt mandatorische Atemfrquenz	54
Beatmungszeit auf niedriegem Druck	Beatmung_Einstellung_DruckTrigger	60
Beatmungszeit auf niedriegem Druck	Beatmung_ES_Evita4_ASB eingestellte Druckunterstützung	55
Beatmungszeit auf niedriegem Druck	PAP Pulmunalarterieller Druck	54
Beatmungszeit auf niedriegem Druck	Beatmung_ES_C2_Druckrampe	54
Beatmungszeit auf niedriegem Druck	Beatmung_ES_Evita4_Pinsp eingestelltes oberes Druckniveau	53
Atemwegsdruck bei null expiratorischem Gasfluss	Beatmung_MS_VisionA_MAP gemessener Mittlerer Atemwegsdruck unter HFO bei Alpha Vision	53
Atemwegsdruck bei null expiratorischem Gasfluss	Beatmung_MS_Evita4_PEEP gemessener positiver endexspiratorischer Druck	53
Atemwegsdruck bei null expiratorischem Gasfluss	P_Beatmung_ES_C3_Pinsp Inspiratorischer Druck	52
Atemwegsdruck bei null expiratorischem Gasfluss	Beatmung_ES_VisionA_MAP Mittlerer Atemwegsdruck (MAP)	51
Atemwegsdruck bei null expiratorischem Gasfluss	Beatmung_MS_Evita4_Pmean gemessener Atemwegsmitteldruck	51
Dauer extrakoporaler Gasaustausch	EVLW Extravaskuläres Lungenwasser	46
Dauer extrakoporaler Gasaustausch	Fall_Wertsachen_Kleidungsstuecke	43
Dauer extrakoporaler Gasaustausch	PLS Pulsrate errechnet aus der SpO2 Messung	42
Dauer extrakoporaler Gasaustausch	ICP Intrakranialer Druck	42
Dauer extrakoporaler Gasaustausch	EVLWI Extravaskuläres Lungenwasserindex	42
Dynamische Kompliance	Beatmung_Messung_Compliance Compliance	51
Dynamische Kompliance	Patient_Name Name des Patiente	43
Dynamische Kompliance	Fall_Wertsachen_Kleidungsstuecke	42
Dynamische Kompliance	Beatmung_Messung_Resistance Resistance	41
Dynamische Kompliance	Untersuchung_Kopf_Augen	41
Beatmungszeit auf hohem Druck	Beatmung_Einstellung_DruckFlow	58
Beatmungszeit auf hohem Druck	Beatmung_ES_C2_Druckrampe	56
Beatmungszeit auf hohem Druck	Beatmung_Einstellung_DruckTrigger	55
Beatmungszeit auf hohem Druck	P_Beatmung_ES_C3_Druckrampe	54
Beatmungszeit auf hohem Druck	Beatmung_Messung_Pplateau Plateau Druck	53
Eingestellter inspiratorischer Gasfluss	Beatmung_MS_G5_Pinsp Inspiratorischer Druck; mit Pinsp wird der Zieldruck (zusätzlich zu PEEP/CPAP) bezeichnet, der im Modus ASV während der Inspirationsphase abgegeben wird	58
Eingestellter inspiratorischer Gasfluss	Beatmung_MS_G5_InspFlow Inspiratorischer Peakflow, ein Monitoring-Parameter	58
Eingestellter inspiratorischer Gasfluss	P_Beatmung_ES_C3_Pinsp Inspiratorischer Druck	58
Eingestellter inspiratorischer Gasfluss	Beatmung_Einstellung_PAW/Pinspiration	55
Eingestellter inspiratorischer Gasfluss	Beatmung_Einstellung_PEEP Positiver endexspiratorischer Druck (PEEP)	53
Koerpergewicht Percentil altersabhaengig	Patient_Gewicht Gewicht des Patienten	49
Koerpergewicht Percentil altersabhaengig	Untersuchung_Status_Koerpertemperatur	49
Koerpergewicht Percentil altersabhaengig	Fall_Wertsachen_Pflegeuntensilien	49
Koerpergewicht Percentil altersabhaengig	Beatmung_ES_G5_Body_Wt Eingestelltes Körpergewicht.	47
Koerpergewicht Percentil altersabhaengig	Fall_Wertsachen_Wertgegenstaende	47
Linksv. Schlagvolumen durch Indikatorverduennung	p-SV Schlagvolumen	84
Linksv. Schlagvolumen durch Indikatorverduennung	Schlagvolumen gemessenes Schlagvolumen	70
Linksv. Schlagvolumen durch Indikatorverduennung	p-SVI Schlagvolumenindex  (PICCO Modul Dräger Monitoring)	52
Linksv. Schlagvolumen durch Indikatorverduennung	Beatmung_ES_VisionA_Schlagvolumen Schlagvolumen (SV) in engl. (cycle volume)	49
Linksv. Schlagvolumen durch Indikatorverduennung	GEDVI Index des enddiastolisches Volumen	48
Linksv. Herzzeitvolumen durch Indikatorverduennung	HZV Herzzeitvolumen	88
Linksv. Herzzeitvolumen durch Indikatorverduennung	VigilanceC_HZV Herzzeitvolumen	67
Linksv. Herzzeitvolumen durch Indikatorverduennung	PCCO Pulskontur-Herzzeitvolumen	65
Linksv. Herzzeitvolumen durch Indikatorverduennung	p-CO Herzzeitvolumen (PICCO Modul Dräger Monitoring)	59
Linksv. Herzzeitvolumen durch Indikatorverduennung	ITBV Intrathorakales Blutvolumen	49
Endexpiratorischer Kohlendioxidpartialdruck	Beatmung_MS_G5_ExspFlow Exspiratorischer Peakflow, ein Monitoring-Parameter	50
Endexpiratorischer Kohlendioxidpartialdruck	Nierenersatzverfahren_Mess_ArteriellDruck	50
Endexpiratorischer Kohlendioxidpartialdruck	PtiO2Druck Gemessener Sauerstoffpartialdruck im Parenchym	48
Endexpiratorischer Kohlendioxidpartialdruck	Beatmung_MS_G5_ExpMinVol Exspiratorisches Minutenvolumen, Monitoring-Parameter	48
Endexpiratorischer Kohlendioxidpartialdruck	Beatmung_MS_G5_Rexsp Exspiratorische Flow-Resistance, ein Monitoring-Parameter	48
Sauerstoffsaettigung im Blut preductal durch Pulsoxymetrie	SpO2 Sauerstoffsättigung Pulsoxymetrie	67
Sauerstoffsaettigung im Blut preductal durch Pulsoxymetrie	P_INVOS_Doku_rSO2_rechts cerbebrale Sauerstoffsättigung rechts	55
Sauerstoffsaettigung im Blut preductal durch Pulsoxymetrie	P_INVOS_Doku_rSO2_links cerebrale Sauerstoffsättigung links	52
Sauerstoffsaettigung im Blut preductal durch Pulsoxymetrie	PtiO2Druck Gemessener Sauerstoffpartialdruck im Parenchym	49
Sauerstoffsaettigung im Blut preductal durch Pulsoxymetrie	Beatmung_ES_Servoi_O2 Sauerstoffkonzentration	47
Atemzugvolumen-Waehrend-Beatmung	Beatmung_Messung_VTeMl VTe / ex. Atemzugvolumen (Tidal Volumen expir.)	61
Atemzugvolumen-Waehrend-Beatmung	Beatmung_MS_Evita4_MV gemessenes Atemminutenvolumen	60
Atemzugvolumen-Waehrend-Beatmung	Beatmung_Messung_AF Breathing Frequency	54
Atemzugvolumen-Waehrend-Beatmung	Beatmung_MS_Heimbeatmung_VTe	53
Atemzugvolumen-Waehrend-Beatmung	Beatmung_ES_Heimbeatmung_Peep	52
Linksventrikulaerer Druck	ZVD Zentralvenöser Druck	58
Linksventrikulaerer Druck	ICP Intrakranialer Druck	57
Linksventrikulaerer Druck	PAP Pulmunalarterieller Druck	52
Linksventrikulaerer Druck	Nierenverfahren_MS_Multi_venDruck venöser Druck	48
Linksventrikulaerer Druck	Beatmung_MS_Servoi_Pmean Mittlerer Atemwegsdruck	47
Linksventrikulaerer Herzindex	CI Herzindex	86
Linksventrikulaerer Herzindex	p-CI Herzindex	78
Linksventrikulaerer Herzindex	VigilanceC_CI Herzindex	58
Linksventrikulaerer Herzindex	dPmax Index der linken Ventrikelkontraktilität	57
Linksventrikulaerer Herzindex	PCCI Herzindex (kontinuirlich)	56
Linksventrikulaeres Schlagvolumen	p-SV Schlagvolumen	84
Linksventrikulaeres Schlagvolumen	Schlagvolumen gemessenes Schlagvolumen	70
Linksventrikulaeres Schlagvolumen	Beatmung_ES_VisionA_Schlagvolumen Schlagvolumen (SV) in engl. (cycle volume)	57
Linksventrikulaeres Schlagvolumen	Nierenersatzverfahren_Mess_Dialysatvolumen	53
Linksventrikulaeres Schlagvolumen	Schlagvolumenindex Wert des gemessenen Schlagvolumenindex.	51
Rechtsatrialer Druck	ICP Intrakranialer Druck	68
Rechtsatrialer Druck	ZVD Zentralvenöser Druck	60
Rechtsatrialer Druck	PAP Pulmunalarterieller Druck	53
Rechtsatrialer Druck	CPP Zerebraler Perfusionsdruck	52
Rechtsatrialer Druck	NBP_1 nichtinvasiver Blutdruck 1	50
Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie	SpO2 Sauerstoffsättigung Pulsoxymetrie	72
Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie	P_INVOS_Doku_rSO2_rechts cerbebrale Sauerstoffsättigung rechts	57
Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie	P_INVOS_Doku_rSO2_links cerebrale Sauerstoffsättigung links	55
Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie	PtiO2Druck Gemessener Sauerstoffpartialdruck im Parenchym	50
Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie	Beatmung_ES_Servoi_O2 Sauerstoffkonzentration	49
Systemischer vaskulaerer Widerstandsindex	SVR Systemischer Gefäßwiderstand	70
Systemischer vaskulaerer Widerstandsindex	p-SVR Systemischer Gefäßwiderstand (PICCO Modul Dräger Monitoring)	57
Systemischer vaskulaerer Widerstandsindex	EVLWI Extravaskuläres Lungenwasserindex	53
Systemischer vaskulaerer Widerstandsindex	SVRI Index des systemischen Gefäßwiderstandes	48
Systemischer vaskulaerer Widerstandsindex	PVRI Pulmunaler Gefäßwiderstandsindex	45
Zentralvenoeser Druck (ZVD)	ZVD Zentralvenöser Druck	96
Zentralvenoeser Druck (ZVD)	ICP Intrakranialer Druck	53
Zentralvenoeser Druck (ZVD)	Nierenverfahren_MS_Multi_venDruck venöser Druck	51
Zentralvenoeser Druck (ZVD)	PAP Pulmunalarterieller Druck	48
Zentralvenoeser Druck (ZVD)	CPP Zerebraler Perfusionsdruck	47
\.


--
-- Data for Name: quantities_conf_var; Type: TABLE DATA; Schema: mii_copra; Owner: -
--

COPY mii_copra.quantities_conf_var (quantities, id_conf_var, name_conf_var, description_conf_var) FROM stdin;
25851846	1266	HF	Herzfrequenz
22647295	102010	SpO2	Sauerstoffsättigung Pulsoxymetrie
21861094	102011	PLS	Pulsrate errechnet aus der SpO2 Messung
13886796	102004	Temp1a	Temperatur 1a
11360118	1267	AF	Atemfrequenz
10762178	102902	Beatmung_MS_G5_VTE	Messwert; exspiratorisches Tidalvolumen Einheit: ml
10755292	102900	Beatmung_MS_G5_Pmittel	Messwert: Beatmungsmitteldruck
10742134	103034	Beatmung_MS_G5_ExpMinVol	Exspiratorisches Minutenvolumen, Monitoring-Parameter 
10652919	103037	Beatmung_MS_G5_O2VolProzent	Sauerstoffkonzentration des abgegebenen Gasgemisches
10650024	102901	Beatmung_MS_G5_PeepCPAP	Messwert: Beatmungsdruck Peep / CPAP
10477142	102905	Beatmung_MS_G5_Rinsp	Inspiratorische Flow-Resistance, ein Monitoring-Parameter
10423116	103036	Beatmung_MS_G5_fspontan	Spontane Atemfrequenz
10402794	102907	Beatmung_MS_G5_Cstat	Statische Compliance, ein Monitoringwert
9577905	103035	Beatmung_MS_G5_ftotal	Gesamtatemfrequenz, ein Monitoring Parameter
8838343	102899	Beatmung_MS_G5_Ppeak	Messwert: Beatmungsspitzendruck
7304705	102057	ARR	Arrhythmie Drägermonitoring, VES/min
3693759	102942	Beatmung_ES_G5_Sauerstoff	Sauerstoffeinstellung
3579740	1269	ZVD	Zentralvenöser Druck
3515771	102935	Beatmung_ES_G5_Druckrampe	Eine Parametereinstellung. Anstiegszeit des Drucks bei druckkontrollierten und druckunterstützten Atemzyklus.
3475287	105085	Beatmung_ES_G5_PEEP_CPAP_Ptief	Eingestelltes unteres Druckniveau bei den Respirator G5 in verschiedenen Beatmungsmodis.
3298810	102892	Beatmung_ES_G5_Psupport	Einstellwert: Druckunterstützung beim G 5  bei Spontanatemzügen
3161225	103040	Beatmung_MS_G5_Pinsp	Inspiratorischer Druck; mit Pinsp wird der Zieldruck (zusätzlich zu PEEP/CPAP) bezeichnet, der im Modus ASV während der Inspirationsphase abgegeben wird
3152111	104040	Beatmung_MS_G5_VTi	\N
3104560	102906	Beatmung_MS_G5_Rexsp	Exspiratorische Flow-Resistance, ein Monitoring-Parameter
2686525	102903	Beatmung_MS_G5_InspFlow	Inspiratorischer Peakflow, ein Monitoring-Parameter
2558291	102931	Beatmung_ES_G5_ETS	Exspiratorische Triggersensitivität, eine Parametereinstellung
2268044	103032	Beatmung_MS_G5_Pplateau	Plateau-Atemwegsdruck, ein Monitoring-Parameter
2245344	102012	etCO2	End-tidales CO2
2141506	102916	Beatmung_MS_G5_TE	Exspirationzeit, ein Monitoring-Parameter
1952044	110934	P_Temperatur_generic	Anlage für Philips Monitoring
1680225	100088	ICP	Intrakranialer Druck
1616814	100086	CPP	Zerebraler Perfusionsdruck
1605554	102912	Beatmung_MS_G5_AutoPeep	Unerwarteter positiver endexspiratorischer Druck, ein Monitoring-Parameter
1428979	103334	Beatmung_ES_G5_Pmax	Hochdruckalarmgrenze im 'ASV Modus
1389042	103715	TempPBT	Temperatur bei der PICCO Messung
1321136	102904	Beatmung_MS_G5_TI	Inspirationszeit in Sekunden, Monitoring-Parameter
1081012	106412	Beatmung_MS_G5_petCO2	\N
1039813	102532	PPV	Pulsdruckabweichung
1032569	104037	Beatmung_MS_G5_Mvspont	\N
986335	102039	dPmax	Index der linken Ventrikelkontraktilität  
925137	102914	Beatmung_MS_G5_VLeckage	Leckagevolumen, ein Monitoring-Parameter
900458	103033	Beatmung_MS_G5_Pmin	Minimaler Atemwegsdruck, ein Monitoring Parameter
872097	102035	PCCI	Herzindex (kontinuirlich) 
871980	102034	PCCO	Pulskontur-Herzzeitvolumen 
869963	102036	p-SVI	Schlagvolumenindex  (PICCO Modul Dräger Monitoring)
864963	102408	p-SV	Schlagvolumen
862754	100070	SVV	Schlagvolumenabweichung 
857825	104009	Beatmung_Messung_Horrowitz	\N
780881	102037	p-SVR	Systemischer Gefäßwiderstand (PICCO Modul Dräger Monitoring) 
778804	102038	p-SVRI	Index des systemischen Gefäßwiderstandes (PICCO Modul Dräger Monitoring)  
762407	102533	CFI	Herzfunktionsindex
758879	110933	P_Temperatur_Kern	Anlage für Philips Monitoring
734325	102915	Beatmung_MS_G5_ExspFlow	Exspiratorischer Peakflow, ein Monitoring-Parameter
723452	105086	Beatmung_ES_G5_Pkontrol_Phoch	Eingestelltes oberes Druckniveau bei dem Respirator  G5 in verschiedenen Beatmungsmodi.
673563	104971	NEV_CRRT_MS_Multi_venDruck	\N
673346	104972	NEV_CRRT_MS_Multi_artDruck	\N
646599	104970	NEV_CRRT_MS_Multi_TMP	\N
588015	103404	Beatmung_ES_G5_Flowtrigger	Die inspiratorische Bemühung des Patienten ( Flow),  die das Beatmungsgerät veranlässt, einen Atemhub abzugeben
513477	106402	NEV_CRRT_MS_Multi_Bilanz_ml	neue Variable für automatische Datenübernahme IBUS
421411	102909	Beatmung_MS_G5_RCexsp	Exspiratorische Zeitkonstante, ein Monitoring-Parameter
400863	117170	Datenuebernahme_TestvariableDec	\N
357120	102944	Beatmung_ES_G5_ProzentMinVol	Przentsatz des Minutenvolumens, eine Parametereinstellung im ASV Modus
355552	104979	NEV_CRRT_ES_Multi_Ultrafiltration	\N
350664	104963	NEV_CRRT_MS_Multi_CitratvolKum	\N
350352	104962	NEV_CRRT_MS_Multi_CalciumVolKum	\N
328734	104980	NEV_CRRT_ES_Multi_Blutfluss	\N
326991	106396	NEV_CRRT_MS_Multi_DialysatvolKum_ml	Anpassung für automatische Datenübernahme IBUS
314598	102938	Beatmung_ES_G5_Frequenz	Anzahl der Atemzyklen pro Minute, Parametereinstellung
311125	104978	NEV_CRRT_ES_Multi_Dialysat	\N
303169	104974	NEV_CRRT_ES_Multi_CalciumFiltrat	\N
282817	104975	NEV_CRRT_ES_Multi_CitratBlut	\N
278946	104753	Beatmung_ES_G5_Frequenz_Backup	Frequenzeinstellung inder Backupeinstellung.
274423	104758	Schlagvolumen	gemessenes Schlagvolumen
270864	100072	CI	Herzindex
262224	104754	Beatmung_ES_G5_Apnoezeit_Backup	Apnoezeiteinstellung in der Backupeinstellung.
260942	104760	Schlagvolumenindex	Wert des gemessenen Schlagvolumenindex.
256944	104968	NEV_CRRT_MS_Multi_Calciumfluss	\N
254030	104969	NEV_CRRT_MS_Multi_Citratfluss	\N
239632	106393	NEV_CRRT_MS_Multi_Behandlungszeit_Aktuell__min	Anpassung für die automatische Datenübermnahme IBUS
229381	104756	Beatmung_ES_G5_Pkontrol_Backup	\N
198068	110930	P_Temperatur_Rektal	Anlage im Rahmen Philips Monitoring
188552	102491	Oxidationswasser	Oxidationswasser in ml (einfuhrrelevant)
187816	102493	PerspiratioInsensibilis	Perspiratio Insensibilis in ml (Ausfuhrrelevant in der Bilanz)
177517	102893	Beatmung_ES_G5_PeepCPAP	Einstellwert: Peep bzw. CPAP Niveau in verschiedenen Modi beim G 5
142391	104967	NEV_CRRT_MS_Multi_Bilanz	\N
131257	102888	Beatmung_ES_G5_Thoch	Einstellwert: Zeiteinstellung des oberes Druckniveau beim G 5 im Modus DuoPAP
125230	100073	SVRI	Index des systemischen Gefäßwiderstandes 
111518	100096	Beatmung_Messung_VTeMl	VTe / ex. Atemzugvolumen (Tidal Volumen expir.)
111043	100300	Beatmung_Messung_Pmax	Peak Airway Pressure
108942	100275	Beatmung_Messung_PEEP	\N
108930	101442	Beatmung_Messung_AF	Breathing Frequency
108818	101441	Beatmung_Messung_Pmean	Mean Airway Pressure
108636	100098	Beatmung_Messung_MV	Mindest Volumen tot.
102782	101433	Beatmung_Messung_Compliance	Compliance
102667	101435	Beatmung_Messung_Resistance	Resistance
101043	103403	Beatmung_ES_G5_Drucktrigger	Inspiratorische Bemühung des Patienten, die das Beatmungsgerät veranlasst, einen Atemhub abzugeben
97971	102071	Beatmung_Messung_O2KonzentrationG5	\N
97841	103011	Nierenverfahren_MS_Multi_venDruck	venöser Druck
97677	103010	Nierenverfahren_MS_Multi_artDruck	arterieller Druck
97578	103012	Nierenverfahren_MS_Multi_TMPDruck	Transmembrandruck
96925	103116	Nierenverfahren_MS_Bilanz	Variable wird verwendet für Multifiltrate und ADM 08
96050	6	Patient_Gewicht	Gewicht des Patienten
79120	7	Patient_Groesse	Größe des Patienten
76517	104966	NEV_CRRT_MS_Multi_DialysatvolKum	\N
74581	104039	Beatmung_ES_G5_Pinsp	\N
73292	110758	P_Beatmung_ES_Anfeuchtung_Temperatur	\N
70600	102887	Beatmung_ES_G5_Ti	Einstelungswert für die Inspirationszeit
64409	1268	Puls	Puls
60553	103049	Nierenverfahren_MS_Multi_DialysatvolumenKumulativ	kumulatives Dialysatvol
60046	102890	Beatmung_ES_G5_Phoch	Einstellwert oberes Druckniveau im beim G 5 im Modus DuoPAP
59723	100270	Beatmung_Messung_AFSpontan	Respiratory Rate (spontan)
59320	101414	Lungenersatzverfahren_Doku_ECMOBlutfluss	\N
59195	110929	P_Temperatur_Tympanal	Anlage im Rahmen PhilipsMonitoring
58936	101415	Lungenersatzverfahren_Doku_ECMOPumpendrehzahl	\N
57054	110926	P_Temperatur_Haut	Anlage im Rahmen PhilipsMonitoring
55469	100074	SVR	Systemischer Gefäßwiderstand
53657	101413	Lungenersatzverfahren_Doku_ECMOAirFlow	\N
52807	101412	Lungenersatzverfahren_Doku_ECMOInspiratorischSaO2	\N
52583	103716	TempBT	Bluttemperatur bei der HZV Messung
48565	102045	GEF	Globale Auswurffraktion 
44576	102043	EVLW	Extravaskuläres Lungenwasser 
44463	100069	ITBV	Intrathorakales Blutvolumen
43364	102536	ITBVI	Index des intrathorakalen Blutvolumens
43338	108525	Beatmung_ES_G5_Flow	Parameter im Modus Highflow - ab 08.06.2017
43282	102044	EVLWI	Extravaskuläres Lungenwasserindex 
43042	102535	p-CI	Herzindex
39748	102025	PVR	Pulmunaler Gefäßwiderstand 
39233	103059	Nierenverfahren_MS_Multi_CitratvolumenKumulativ	kumulativ Citrat
39078	103060	Nierenverfahren_MS_Multi_CalciumvolumenKumulativ	kumulativ
38439	102946	Beatmung_ES_G5_Groeße	Eine Parametereinstellung im ASV Modus. Sie wird zur Berechnnug des idealen Körpergewichts (IBW) des Patienten verwendet
37642	102047	PVPI	Pulmonalvaskuläer Permeabilitätsindex 
35273	106395	NEV_CRRT_MS_Multi_SubVolKum_ml	Änderung für die automatische Datenübernahme IBUS
35075	102027	RPP	Rate-/Druck-Produkt 
34205	104977	NEV_CRRT_ES_Multi_Substituat	\N
34154	103296	Beatmung_ES_Evita4_O2Konzentration	eingestellte O2 Konzentration des Frischgases
33068	102185	VigilanceC_CI	Herzindex
29987	102041	GEDV	Globales enddiastolisches Volumen 
29967	100105	Beatmung_Einstellung_FiO2	O²- Konzentration im Inspirationsgemisch (FiO2)
29306	102040	p-CO	Herzzeitvolumen (PICCO Modul Dräger Monitoring) 
29133	102042	GEDVI	Index des enddiastolisches Volumen 
29081	103338	Nierenverfahren_MS_BM25_AbnahmeKumulativ	\N
28887	100102	Beatmung_Einstellung_PEEP	Positiver endexspiratorischer Druck (PEEP)
28190	103019	Nierenverfahren_MS_BM25_artDruck	\N
28112	103020	Nierenverfahren_MS_BM25_venDruck	\N
27734	102977	Nierenverfahren_ES_Multi_Ultrafiltration	Ultrafiltrationsrate ml/h
27515	105043	Hypothermie_ArticSun_MS_Wassertemperatur	kontrollierte Wassertemperatur, gemessener Wert
27197	103702	Hypothermie_ArticSun_Doku_Patiententemperatur	\N
27072	110937	P_Beatmung_MS_AnaConDa_MAC	Umstellung PhilipsMonitoring
27019	114052	NEV_CRRT_MS_Multi_praeF	\N
26821	103022	Nierenverfahren_MS_BM25_DruckvorFilter	\N
26631	103301	Beatmung_ES_Evita4_PEEP	eingestelltes PEEP Niveau
25803	103021	Nierenverfahren_MS_BM25_TMPDruck	\N
25701	103809	tcpCO2	transcutan gemessener pCO2 Wert.
24916	102184	VigilanceC_HZV	Herzzeitvolumen
24004	104036	Beatmung_ES_G5_Pasvlimit	\N
23579	105045	BIS	Der Bispectral Index (BIS) ist ein verarbeiteter EEG Parameter und zeigt die Auswirkungen der Sedierung auf das Gehirn an.
22804	104728	Beatmung_MS_Pallas_MV_Leck	Gemessene Leckage.
22700	104709	Beatmung_ES_Pallas_Alter	Dokumentation des Alters des Patienten.
22249	103302	Beatmung_ES_Evita4_ASB	eingestellte Druckunterstützung
22205	102976	Nierenverfahren_ES_Multi_Blutfluss	Blutpumpengeschwindigkeit ml/min
21305	103013	Nierenverfahren_MS_Multi_DruckvorFilterDruck	\N
21002	100106	Beatmung_Einstellung_ASB	Inspiratorische Druckunterstützung [inspiratory pressure support] (IPS) bzw. assisted spontaneuous breathig (ASB)
20648	110928	P_Temperatur_Oesophagial	Anlage im Rahmen PhilipsMonitoring
19523	103123	Nierenverfahren_ES_Multi_Dialysat	\N
19516	104771	Beatmung_ES_Pallas_PatGewicht	Eingestelter Patientengewicht am Pallas
19289	101401	Nierenersatzverfahren_Mess_ArteriellDruck	\N
19281	103058	Nierenverfahren_ES_Multi_CalciumFiltrat	Calciumrate
19206	102980	Nierenverfahren_ES_Multi_Temperatur	Tempertatu Celsius
19113	102891	Beatmung_ES_G5_Pkontrol	Einstellwert oberes Druckniveau beim G 5 im Modus P SIMV
19057	104965	NEV_CRRT_MS_Multi_SubVolKum	\N
18949	101422	Patient_KO	Körperoberfläche des Patienten ohne Fallbezug
18677	103299	Beatmung_ES_Evita4_Rampe	eingestellte Anstiegszeit vom unteren zum oberen Druckniveau
17611	101447	Beatmung_Messung_Pplateau	Plateau Druck
17225	104876	NEV_HD_MS_4008HS_venDruck	\N
17186	104877	NEV_HD_MS_4008HS_artDruck	\N
16976	104875	NEV_HD_MS_4008HS_TMP	\N
16681	108630	P_Therapiebetten_Doku_Lifetherm_ES_Temperatur	\N
16602	108623	P_Therapiebetten_Doku_Lifetherm_ES_Strahler	\N
16525	104961	NEV_CRRT_MS_Multi_UFR_BFRVerhaeltnis	\N
16468	103300	Beatmung_ES_Evita4_Pinsp	eingestelltes oberes Druckniveau
15958	102886	Beatmung_ES_G5_Timax	eingestellte maximale Inspirationszeit beim G5 im Modus NIV
15837	103050	Nierenverfahren_MS_BM25_DialysatvolumenKumulativ	\N
15728	103057	Nierenverfahren_ES_Multi_CitratBlut	Citratrate
15526	102073	Beatmung_Einstellung_O2Konzentration	\N
14985	108722	P_Beatmung_MS_AnaConDa_etGaskonz	\N
14814	108721	P_Beatmung_MS_AnaConDa_inspGaskonz	\N
14493	103303	Beatmung_ES_Evita4_Flowtrigger	Einstellgröße des Flowtriggers
14400	104742	Beatmung_MS_Pallas_Sevofluran_exsp	Exspiratorisch gemessene Sevofluran Konzentration.
14329	104741	Beatmung_MS_Pallas_Sevofluran_insp	Inspiratorisch gemessene Sevofluran Konzentration.
14127	102026	PVRI	Pulmunaler Gefäßwiderstandsindex 
14075	108509	SpO2_2	\N
13967	103041	Beatmung_MS_G5_P01	Atemweg-Okklusionsdruck, ein Monitoring-Parameter
13606	102494	PerspiratioSensibilis	Perspiratio Sensibilis in ml (ausfuhrrelevant in der Bilanz)
13400	103298	Beatmung_ES_Evita4_frequenz	eingestellte Atemfrequenz
13393	103297	Beatmung_ES_Evita4_Tinsp	eingestellte absolute Inspirationszeit
13244	102033	TVR	Gesamtgefäßwiderstand 
12533	104872	NEV_HD_MS_4008HS_effBlutfluss	\N
12427	104873	NEV_HD_MS_4008HS_Leitfähigkeit	\N
12372	101397	Nierenersatzverfahren_Mess_AbnahmeKumulat	\N
12360	100100	Beatmung_Messung_FiO2	FiO2
11960	102756	Nierenersatzverfahren_Mess_VenoeserDruck	\N
11682	102490	Vigileo_CI	\N
11632	103306	Beatmung_ES_Evita4_fApnoe	eingestellte Atemfrequenz in der Apnoeventilation
11553	101395	Nierenersatzverfahren_Mess_UmsatzKumulati	\N
11454	103015	Nierenverfahren_MS_Multi_SubvolumenKumulativ	\N
11344	103305	Beatmung_ES_Evita4_VtApnoe	Einstellgröße für das Tidalvolumen in der Apnoeeinstellung
11300	101399	Nierenersatzverfahren_Mess_DruckVorFilter	\N
11062	103062	Nierenverfahren_MS_Multi_Calciumfluss	Calciumrate
10962	101400	Nierenersatzverfahren_Dokumentation_Filtratdruck	\N
10853	100097	Beatmung_Messung_MVSpontan	Mindest Volumen sp
10822	104732	Beatmung_MS_Pallas_MAC_exsp	Gemessener MAC Wert. (endexspiratorische mittlere alveoläre Konzentration)
10704	101443	Beatmung_Messung_Pmin	Minimum Airway Pressure
10303	103061	Nierenverfahren_MS_Multi_Citratfluss	Citratrate
10295	104723	Beatmung_MS_Pallas_etCO2	Dokumention des gemessenen endtidalen
10295	104724	Beatmung_MS_Pallas_inCO2	Inspiratorisch gemessenes CO2.
10295	104731	Beatmung_MS_Pallas_O2_exsp	Gemessene exspiratorische O2 Konzentration.
10295	104730	Beatmung_MS_Pallas_O2_insp	Gemessene inspiratorische O2 Konzentration.
10279	104808	Beatmung_ES_C2_Sauerstoff	\N
9989	101444	Beatmung_Messung_IntrinsicPEEP	Intrinsic PEEP
9873	103088	Beatmung_ES_F120_O2Konzentration	Einstellparameter: Sauerstoffgehalt des Gasgemisches
9794	103333	Beatmung_ES_G5_Vt	Einstellwert: Tidalvolumen
9674	101398	Nierenersatzverfahren_Dokumentation_Blutfluss	\N
9626	103018	Nierenverfahren_MS_Multi_Behandlungszeit	\N
9614	103087	Beatmung_ES_F120_Flow	Einstellwert: Größe des Gasflusses beim F 120
9453	112007	P_INVOS_Doku_rSO2_rechts	cerbebrale Sauerstoffsättigung rechts
9397	108742	P_Temperatur_DeltaT	Delta Temperatur zentral/Temperatur peripher
9179	112006	P_INVOS_Doku_rSO2_links	cerebrale Sauerstoffsättigung links
8912	105014	Schrittmacher_Osypka101H_ES_Rate	Grundfrequenz
8725	104878	NEV_HD_MS_4008_HS_onl_Ultrafiltratmengekum	\N
8702	103086	Beatmung_ES_F120_CPAP	Eingestelltes CPAP Niveau
8659	105078	Beatmung_ES_C2_PEEP_CPAP_Ptief	Eingestellter PEEP, CPAP oder Ptief am C2.
8509	102176	Vigileo_SV	ml/b
8502	106332	CardioHelpMaquet_MS_Blutfluss	\N
8487	104810	Beatmung_ES_C2_Druckrampe	\N
8380	104809	Beatmung_ES_C2_ETS	\N
8096	102119	Nierenersatzverfahren_Mess_TMP	TransmembranDruck
7997	104888	NEV_HD_ES_4008HS_Blutfluss	\N
7992	102991	Nierenverfahren_ES_BM25_Abnahme	Ultrafiltrationsrate
7776	106407	Hypothermie_ArticSun_MS_Zieltemperatur	Messwert im Verlaufbis zum erreichen der eingestellten Zieltemperatur
7645	106331	CardioHelpMaquet_MS_DruckArteriell	\N
7640	106330	CardioHelpMaquet_MS_DruckVenoes	\N
7638	103206	Nierenverfahren_MS_UltrafiltratmengeKum	Kumulativer Entzug, bilanzrelevant
7634	106329	CardioHelpMaquet_MS_DeltaP	\N
7616	104893	NEV_HD_ES_4008HS_UFZiel	\N
7525	106394	NEV_CRRT_MS_Multi_SubBolusVolKum_ml	Anpassung für die automatische Datenübernahme IBUS
7401	103164	Nierenverfahren_MS_4008HS_venDruck	\N
7348	102022	LHCPP	Linksseitiger Herzkranzperfusionsdruck 
7341	102489	Vigileo_CO	\N
7327	103163	Nierenverfahren_MS_4008HS_artDruck	\N
7263	101402	Nierenersatzverfahren_Mess_VenDruck	\N
7251	104880	NEV_HD_ES_4008HS_Temperatur	\N
7195	104151	Beatmung_ES_Airvo_O2Konzentration	Dokumentation der O2 Konzentration in Abhängigkeit der Einstellgrößen FlowSetting und O2 Flow.
7188	106328	CardioHelpMaquet_MS_SvO2	\N
7188	104944	NEV_HD_VO_4008HS_UF_Ziel	\N
7185	103165	Nierenverfahren_MS_4008HS_TMP	\N
7160	104819	Beatmung_ES_C2_Psupport	\N
7093	102006	Temp2a	Temperatur 2a
7091	105019	Schrittmacher_Osypka203H_ES_Rate	Grundfrequenz
7084	105015	Schrittmacher_Osypka101H_ES_Sense	Empfindlichkeit
7072	105016	Schrittmacher_Osypka101H_ES_STIM	Stimulation
7061	106352	CardioHelpMaquet_DOKU_HB	\N
7055	106351	CardioHelpMaquet_DOKU_HCT	\N
7040	103078	Beatmung_MS_VisionA_Amplitude	gemessene Druckdifferenz im HFOV Modus
6999	102032	TPR	Pulmonaler Gesamtgefäßwiderstand 
6945	102878	Beatmung_MS_VisionA_MAP	gemessener Mittlerer Atemwegsdruck unter HFO bei Alpha Vision
6853	104943	NEV_HD_VO_4008HS_Blutfluss_Max	\N
6803	104892	NEV_HD_ES_4008HS_UFRate	\N
6787	104936	NEV_HD_VO_4008HS_Temperatur	\N
6772	102990	Nierenverfahren_ES_BM25_Blutfluss	Blutpumpengeschwindigkeit
6632	104935	NEV_HD_VO_4008HS_Fluss	\N
6475	104879	NEV_HD_ES_4008HS_Fluss	\N
6446	104881	NEV_HD_ES_4008HS_Bicarbonat	\N
6443	102628	Nierenersatzverfahren_Mess_Bilanz	\N
6326	104938	NEV_HD_VO_4008HS_Soll_Na	\N
6271	110782	P_NEV_HD_MS_5008onl_artDruck	\N
6254	110781	P_NEV_HD_MS_5008onl_venDruck	\N
6205	104871	NEV_HD_MS_4008HS_BlutvolKum	\N
6184	102881	Beatmung_MS_VisionA_HFOBaseFlow	gemessener Basis Continousflow
6142	104149	Beatmung_ES_Airvo_FlowSetting	Einstellunggröße  des Flows am Gerät
6105	104937	NEV_HD_VO_4008HS_Bicarbonat	\N
5952	102088	Lungenersatzverfahren_Doku_ECMOATZ	\N
5819	103943	Beatmung_ES_Heimbeatmung_Peep	\N
5765	104882	NEV_HD_ES_4008HS_SollNa	\N
5573	102074	Beatmung_Einstellung_SauerstoffFlow	\N
5523	103169	Nierenverfahren_MS_4008HS_effBlutfluss	\N
5443	107907	Beatmung_ES_Heimbeatmung_Frequenz	\N
5419	110780	P_NEV_HD_MS_5008onl_TMP	\N
5417	101393	Nierenersatzverfahren_Einstell_Umsatz	\N
5305	102503	Nierenersatzverfahren_Dokumentation_BlutflussEinst	\N
5250	100108	Beatmung_Einstellung_AF	Beatmungsfrequenz (f/AF)
5206	103168	Nierenverfahren_MS_4008HS_Leitfähigkeit	\N
5191	102062	Beatmung_Einstellung_PAW/Pinspiration	\N
5184	106401	NEV_HD_MS_4008_HS_onl_Ultrafiltratmengekum_ml	Anpassung im Zuge der automatischen Datenübernahme IBUS
5150	103340	IABP_Doku_Ballonvolumen	\N
5086	102880	Beatmung_MS_VisionA_SISetting	Dauer des manuell durchgeführten Atemhubs
5075	105023	Schrittmacher_Osypka203H_ES_V_STIM	Stimulation Ventrikel
5039	106334	CardioHelpMaquet_ES_Pumpendrehzahl	\N
5007	104803	Beatmung_MS_C2_Ppeak	\N
5005	102007	Temp2b	Temperatur 2b
4976	104798	Beatmung_MS_C2_VTE	\N
4975	104797	Beatmung_MS_C2_ExpMinVol	\N
4966	110783	P_NEV_HD_MS_5008_onl_Ultrafiltratmengekum_ml	\N
4952	107909	Beatmung_MS_Heimbeatmung_Ppeak	\N
4934	107908	Beatmung_MS_Heimbeatmung_MV	\N
4868	104790	Beatmung_MS_C2_fSpontan	\N
4839	102631	Nierenersatzverfahren_Mess_Dialysatvolumen	\N
4799	104791	Beatmung_MS_C2_fTotal	\N
4773	106335	CardioHelpMaquet_ES_Gasfluss	\N
4724	106668	HeartWare_RPM_Doku	\N
4718	110866	Beatmung_ES_Heimbeatmung_Sauerstoff	\N
4698	104804	Beatmung_MS_C2_Sauerstoff	\N
4686	106667	HeartWare_Watt_Doku	\N
4678	104800	Beatmung_MS_C2_PeepCPAP	\N
4675	106336	CardioHelpMaquet_ES_FiO2	\N
4665	103563	PCWP	\N
4628	104801	Beatmung_MS_C2_Pmittel	\N
4618	103170	Nierenverfahren_MS_4008HS_BlutvolumenKum	\N
4596	103079	Beatmung_MS_VisionA_O2Konzentration	gemessene Sauerstoffgehalt des Gasgemisches
4587	104349	IABP_DatascopeCS300_ES_Unterstützungsdruck	Dokumentation des Unterstützungsdruckes.
4573	104874	NEV_HD_MS_4008HS_SollNa	\N
4570	104788	Beatmung_MS_C2_TE	\N
4562	104793	Beatmung_MS_C2_InsFlow	\N
4555	105077	Beatmung_ES_C2_Pmax	Eingestellte Alarmhochdruckgrenze. Einstellung erfolgtdirekt über die Alarmeinstellung aber auch indirekt über die Einstellung Pasvlimit. Die Alarmhochdruckgrenze liegt automatisch 10 mbar über der Pasvlimit Einstellung.
4554	104973	NEV_CRRT_ES_Multi_Temperatur	\N
4451	103166	Nierenverfahren_MS_4008HS_Restzeit	\N
4375	103124	Nierenverfahren_ES_BM25_Dialysat	\N
4361	102978	Nierenverfahren_ES_Multi_Substituat	Umsatz, Austausch Substituat ml/h
4359	104784	Beatmung_MS_C2_Cstat	\N
4305	103017	Nierenverfahren_MS_Multi_UFRBFRVerhaeltnis	\N
4282	110867	Beatmung_ES_Heimbeatmung_Psupport	\N
4278	103381	Schrittmacher_Eins_ES_Frequenz	Medtronic 5348
4169	110778	P_NEV_HD_MS_5008onl_Leitfaehigkeit	\N
4161	102179	Vigileo_SVI	SchlagvolumenindexSchlagvolumenindex
4149	104786	Beatmung_MS_C2_Rinsp	\N
4120	104805	Beatmung_ES_C2_Flowtrigger	\N
4107	103215	Beatmung_MS_3100B_Amplitude	Messwert: gemessene Druckamplitude
4105	103698	Hypothermie_ArticSun_Doku_Zieltemperatur	\N
4022	106471	IABP_CARDIOSAVE_ES_Unterstuetzungsdruck	Dokumentation des Unterstützungdruckes
3985	103077	Beatmung_ES_VisionA_O2Konzentration	Eingestellte Sauerstoffzufuhr
3922	106669	HeartWare_Blutfluss_Doku	\N
3908	108729	P_Impella_Impella_MS_Flow	\N
3884	108730	P_Impella_Impella_MS_PurgeFlow	\N
3863	102873	Beatmung_ES_VisionA_MAP	Mittlerer Atemwegsdruck (MAP)
3794	103152	Nierenverfahren_ES_4008HS_Blutfluss	\N
3772	102072	Beatmung_Einstellung_DruckFlow	\N
3739	103320	Beatmung_MS_Evita4_MV	gemessenes Atemminutenvolumen
3733	103254	Nierenverfahren_VO_4008HS_Dialysezeit	\N
3733	103237	Nierenverfahren_VO_4008HS_UFZiel	\N
3721	103024	Nierenverfahren_MS_BM25_UmsatzvolumenKumulativ	\N
3718	103216	Beatmung_MS_3100B_O2Konzentration	Messwert: gemessene O2 Konzentration des Gasgemisches
3707	104752	Beatmung_ES_G5_Vt_Backup	Vt in der Backupeinstellung
3698	103315	Beatmung_MS_Evita4_Ppeak	gemessener Atemwegsspitzendruck
3686	102894	Beatmung_ES_G5_Ttief	Einstellwert: Zeiteinstellung für das untere Druckniveau beim G5 im Modus APRV
3673	103314	Beatmung_MS_Evita4_FiO2	gemessene O2 Konzentration des inspiratorischen Atemgasgemisches
3659	103382	Schrittmacher_Eins_ES_Ausgang	Medtronic 5348
3620	103323	Beatmung_MS_Evita4_frequenz	gemessene Gesamtatemfrequenz
3599	103317	Beatmung_MS_Evita4_Pmean	gemessener Atemwegsmitteldruck
3590	103147	Nierenverfahren_ES_4008HS_UFZiel	Ultrafiltrationsziel
3578	104740	Beatmung_MS_Pallas_Desfluran_exsp	Exspiratorisch gemessene Desfluran Konzentration.
3562	106327	CardioHelpMaquet_MS_TemperaturIst	\N
3546	103324	Beatmung_MS_Evita4_fspn	gemessene spontane Atemfrequenz
3542	103213	Beatmung_ES_3100B_Mitteldruck	Einstellwert: eingestellter mittlerer Atemwegsdruck
3540	103327	Beatmung_MS_Evita4_Vt	gemessenes inspiratorisches Tidalvolumen
3523	103321	Beatmung_MS_Evita4_MVspn	gemessenes spontanes Atemminutenvolumen
3499	102102	Nierenersatzverfahren_Einstell_Blutfluss	\N
3494	104739	Beatmung_MS_Pallas_Desfluran_insp	Inspiratorisch gemessene Desfluran Konzentration.
3493	104727	Beatmung_MS_Pallas_Frequenz	Gemessene Atemfrequenz.
3472	103319	Beatmung_MS_Evita4_Pmin	gemessener minimaler Atemwegsdruck während des Atemzyklus
3464	106392	NEV_HD_MS_4008HS_BlutvolKum_ml	Anpassung aufgrund IBUS Anbindung
3451	104725	Beatmung_MS_Pallas_MV	Gemessenes Atemminutenvolumen.
3441	103383	Schrittmacher_Eins_ES_Empfindlichkeit	Medtronic 5348
3395	102874	Beatmung_ES_VisionA_Schlagvolumen	Schlagvolumen (SV) in engl. (cycle volume)
3395	103146	Nierenverfahren_ES_4008HS_DialyseZeit	\N
3394	104726	Beatmung_MS_Pallas_Vt	Gemessenes Tidalvolumen.
3388	103318	Beatmung_MS_Evita4_PEEP	gemessener positiver endexspiratorischer Druck
3352	110796	P_NEV_HD_ES_5008onl_Blutfluss	\N
3339	102051	HZV	Herzzeitvolumen
3339	108508	tcpO2	transcutan gemessener pO2 Wert.
3329	102872	Beatmung_ES_VisionA_Oszillationsfrequenz	Oszillationsfrequenz Gerät: Alpha Vision Modus: HFO
3303	103242	Nierenverfahren_VO_4008HS_SollNatrium	\N
3284	107912	Beatmung_MS_Heimbeatmung_VTi	\N
3283	104352	IABP_DatascopeCS300_ES_Doku_Ballonvolumen	Dokumentation des Ballonvolumens.
3277	103148	Nierenverfahren_ES_4008HS_UFRate	Ultrafiltrationsrate
3253	104720	Beatmung_MS_Pallas_Ppeak	Dokumentation des gemessenen Beatmungsspitzendruck.
3213	103161	Nierenverfahren_ES_4008HS_Temperatur	\N
3211	100254	Beatmung_Einstellung_Inspirationszeit	Inspirationszeit in %
3200	104708	Beatmung_ES_Pallas_PEEP	Dokumentation des eingestellten PEEP.
3200	104714	Beatmung_ES_Pallas_T_Rampe	Dokumentation der eingestellten Rampenzeit.
3192	103328	Beatmung_MS_Evita4_Resistance	gemessener Atemwegswiderstand
3189	100091	LAP	Linksatrial  Mitteldruck
3169	104729	Beatmung_MS_Pallas_Cpat	Die gemessene Gesamtcompliance abzüglich der im Selbsttest ermittelten System- und Schlauchcompliance ergibt die Lungencompliance.
3148	105000	NEV_CRRT_VO_Multi_Ultrafiltration	\N
3145	105022	Schrittmacher_Osypka203H_ES_A_STIM	Stimulation Vorhof
3127	104722	Beatmung_MS_Pallas_PEEP	Dokumentation des gemessenen PEEPs.
3100	104721	Beatmung_MS_Pallas_Pplat	Dokumentation des gemessenen Plateaudruckes.
3086	107980	P_Beatmung_ES_C3_Sauerstoff	\N
3080	105001	NEV_CRRT_VO_Multi_BlutflussMax	\N
3076	106390	NEV_HD_MS_4008HS_Rest_Zeit_min	Anpassung für IBUS Anbindung
2969	103307	Beatmung_ES_Evita4_Tubuskompensation	Einstellgröße für die Tubuskompensation
2955	102198	VigilanceC_O2	\N
2935	102587	Nierenersatzverfahren_Einstell_UFR	\N
2932	103329	Beatmung_MS_Evita4_Compliance	gemessene Lungencompliance
2899	110801	P_NEV_HD_ES_5008onl_UFZiel	\N
2884	106469	IABP_CARDIOSAVE_ES_IABPAufblasen	Dokumentation des prozentualen Anteils des Aufblasens des Ballons
2863	106474	IABP_CARDIOSAVE_ES_IABPLeersaugen	Dokumentation des prozentualen Anteils des Leersaugens des Ballons
2849	103244	Nierenverfahren_VO_4008HS_Temperatur	\N
2801	103565	Schrittmacher_Doku_Wahrnehmung	\N
2795	104261	Beatmung_ES_Servoi_O2	Sauerstoffkonzentration 
2764	103160	Nierenverfahren_ES_4008HS_Bicarbonat	\N
2761	102876	Beatmung_ES_VisionA_HFOBaseFlow	Basis Continousflow
2758	110785	P_NEV_HD_ES_5008onl_Temperatur	\N
2749	102889	Beatmung_ES_G5_Plateau	prozentualer Anteil der Inspiration, der Plateauphase bestimmt wird
2737	103162	Nierenverfahren_ES_4008HS_Fluss	\N
2730	104712	Beatmung_ES_Pallas_Trigger	Dokumentation des eingestellten Triggers.
2728	103243	Nierenverfahren_VO_4008HS_Bicarbonat	\N
2728	103564	Schrittmacher_Doku_Reizschwelle	\N
2696	104716	Beatmung_ES_Pallas_Tinsp	Dokumentation der Inspirationszeit.
2695	104718	Beatmung_ES_Pallas_Frequenz	Dokumentation der eingestellten Frequenz.
2690	107911	Beatmung_MS_Heimbeatmung_VTe	\N
2651	104747	Beatmung_ES_Pallas_Pinsp	Eingestellter Inspiration Druck.
2640	103818	NIRSlinks_MS	Über eine Messsonde transcutan gemessener Prozentwert
2640	110817	P_NEV_HD_VO_5008onl_UFZiel	\N
2620	107910	Beatmung_MS_Heimbeatmung_Pmittel	\N
2590	110868	Beatmung_ES_Heimbeatmung_Pcontrol	\N
2584	100272	Beatmung_Messung_ASB	\N
2583	110814	P_NEV_HD_VO_5008onl_BlutflussMax	\N
2578	104999	NEV_CRRT_VO_Multi_Dialysat	\N
2576	103819	NIRSrechts_MS	\N
2563	110777	P_NEV_HD_MS_5008onl_effBlutfluss	\N
2515	104264	Beatmung_ES_Servoi_PEEP	PEEP 
2500	102877	Beatmung_ES_VisionA_SISetting	Druckeinstellung für manuell ausgelösten Atemhub
2499	103832	Lungenersatzverfahren_Doku_ILA_Blutfluss	\N
2488	103158	Nierenverfahren_ES_4008HS_SollNa	\N
2459	102610	Nierenersatzverfahren_Einstell_Temperatur	\N
2456	110786	P_NEV_HD_ES_5008onl_Bicarbonat	\N
2451	106333	CardioHelpMaquet_ES_TemperaturSoll	\N
2448	110820	P_Beatmung_ES_C3_PEEP_CPAP	\N
2406	103210	Beatmung_ES_3100B_Frequenz	Einstellwert: eingestellte Oszillationsfrequenz 
2402	110804	P_NEV_HD_VO_5008onl_Fluss	\N
2391	110784	P_NEV_HD_ES_5008onl_Fluss	\N
2337	110800	P_NEV_HD_ES_5008onl_UFRate	\N
2324	110805	P_NEV_HD_VO_5008onl_Temperatur	\N
2311	104717	Beatmung_ES_Pallas_PS	Dokumentation des eingestellten Pressure Support.
2271	104883	NEV_HD_ES_4008HS_BasisNa	\N
2249	102106	Nierenersatzverfahren_Einstell_Dialysatfluß	\N
2237	110925	P_Temperatur_Arteriell	Anlage im Rahmen PhilipsMonitoring
2225	103214	Beatmung_ES_3100B_O2Konzentration	Einstellwert: O2 Konzentration des Gasgemisches
2211	110787	P_NEV_HD_ES_5008onl_SollNa	\N
2188	102993	Nierenverfahren_ES_BM25_Temperatur	Temperatur Celcius
2183	110927	P_Temperatur_Naso	Anlage im Rahmen PhilipsMonitoring
2174	110806	P_NEV_HD_VO_5008onl_Bicarbonat	\N
2145	103386	Schrittmacher_zwei_ES_Frequenz	Medtronic 5375
2132	103211	Beatmung_ES_3100B_Inspirationszeit	Einstellwert: prozentualer Anteil der Inspirationszeit bezogen auf den gesamtem Atemzyklus
2119	104833	NEV_Apherese_ES_Multi_Plasma	\N
2105	110807	P_NEV_HD_VO_5008onl_SollNa	\N
2104	103209	Beatmung_ES_3100B_BiasFlow	Einstellwert: eingestellter Basisfluss im Beatmungssystem
2096	110904	P_Patient_Gewicht_Differenz	Differenz zwischen dem aktuellen Gewicht und dem Gewicht des letzten Eintrags
2028	103831	Lungenersatzverfahren_Doku_ILA_Gasfluss	\N
2017	102183	Vigileo_ScvO2	\N
2009	103167	Nierenverfahren_MS_4008HS_SollNatrium	\N
2008	102068	Beatmung_Einstellung_DruckTrigger	\N
1906	110939	P_Beatmung_ES_NO	\N
1881	110938	P_Beatmung_MS_NO2	\N
1866	103387	Schrittmacher_zwei_ES_Ausgang	Medtronic 5375
1859	104829	NEV_Apherese_MS_Multil_venDruck	\N
1854	104830	NEV_Apherese_MS_Multi_artDruck	\N
1848	102018	PWP	Pulmunaler Wedgedruck
1844	104828	NEV_Apherese_MS_Multi_TMP	\N
1808	110779	P_NEV_HD_MS_5008onl_SollNa	\N
1763	104832	NEV_Apherese_ES_Multi_Blutfluss	\N
1745	103238	Nierenverfahren_VO_4008HS_BlutflussMax	\N
1745	103388	Schrittmacher_zwei_ES_Empfindlichkeit	Medtronic 5375
1724	110881	Beatmung_ES_Heimbeatmung_Ti	\N
1713	103720	IABP_DatascopeCS100_ES_Unterstützungsdruck	\N
1653	105024	Schrittmacher_Osypka203H_ES_AV_DLY	AV Überleitungszeit
1645	103212	Beatmung_ES_3100B_Leistung	Einstellwert: prozentuale Kolbenauslenkung
1642	104251	Beatmung_MS_Servoi_Ppeak	Atemdruck Spitze 
1592	110772	P_NEV_HD_MS_5008onl_Rest_Zeit_min	\N
1529	104834	NEV_Apherese_ES_Multi_PlasmaVolumen	\N
1512	110754	P_Therapiebetten_Doku_DraegerBabytherm_ES_Temp	\N
1498	102059	Beatmung_Einstellung_ASBAnstieg	\N
1494	110755	P_Therapiebetten_Doku_DraegerBabytherm_ES_Strahler	\N
1485	106783	Beatmung_ES_Optiflow_O2Konzentration	\N
1484	104239	Beatmung_MS_Servoi_Vte	Exsp. Tidalvolumen 
1483	104345	IABP_DatascopeCS300_ES_IABPAufblasen	Dokumentation des prozentualen Anteil des Aufblasens des Ballons.
1465	102753	Nierenersatzverfahren_Mess_CalciumFluss	\N
1452	102721	Nierenersatzverfahren_Einstell_Calcium	\N
1448	102752	Nierenersatzverfahren_Mess_CitratFluss	\N
1437	106784	Beatmung_ES_Optiflow_O2Flow	\N
1432	107996	P_Beatmung_ES_C3_Flowtrigger	\N
1412	103092	Beatmung_ES_CF800_DruckluftFlow	Einstellgröße: Gasfluss Druckluft
1409	106281	Beatmung_ES_C2_Apnoezeit_Backup	\N
1399	104884	NEV_HD_ES_4008HS_StartNa	\N
1398	104347	IABP_DatascopeCS300_ES_IABPLeersaugen	Dokumentation des prozentualen Anteils des Leersaugens des Ballons.
1396	103091	Beatmung_ES_CF800_SauerstoffFlow	Einstellgröße Gasfluss Sauerstoff
1392	108665	P_Waermesysteme_FisherPaykel_Doku_Prozent	\N
1389	103093	Beatmung_ES_CF800_O2Konzentration	Sauerstoffgehalt des eingestellten Gasgemisches CF 800
1361	104782	Beatmung_ES_C2_Ti	\N
1357	102627	Nierenersatzverfahren_Mess_SubstituatVolumen	\N
1356	102992	Nierenverfahren_ES_BM25_Umsatz	Austausch, Substituat, ml/h
1340	103195	Nierenverfahren_MS_4008onl_venDruck	\N
1321	103194	Nierenverfahren_MS_4008onl_artDruck	\N
1319	117241	P_PtiO2_Decimal	\N
1315	103196	Nierenverfahren_MS_4008onl_TMP	\N
1277	104807	Beatmung_ES_C2_ProzentVol	\N
1275	103157	Nierenverfahren_ES_4008HS_BasisNa	\N
1268	110776	P_NEV_HD_MS_5008onl_BlutvolKum	\N
1267	103245	Nierenverfahren_VO_4008HS_Fluss	\N
1241	103269	Beatmung_ES_Evita2_Frequenz	eingestellt mandatorische Atemfrquenz
1203	102729	Nierenersatzverfahren_Einstell_Citrat	\N
1195	106343	NEV_Apherese_MS_Multi_FiltratDruck	\N
1194	108639	P_Temperaturregulation_Blankettrol_Doku_Temp	\N
1191	11	COPRA_Patient_Kopfumfang	Kopfumfang des Patienten in Zentimetern
1189	104117	Lungenersatzverfahren_MS_ILA_SpO2	\N
1187	102097	Lungenersatzverfahren_Doku_ILAQ1Flow	\N
1182	102578	Beatmung_Einstellung_ProzentMinVol	\N
1169	107991	P_Beatmung_ES_C3_Ti	\N
1161	104820	Beatmung_ES_C2_Pinsp	\N
1151	107986	P_Beatmung_ES_C3_Pinsp	Inspiratorischer Druck
1148	103200	Nierenverfahren_MS_4008onl_effBlutfluss	\N
1145	107977	P_Beatmung_ES_C3_Druckrampe	\N
1128	104282	Beatmung_ES_Servoi_SIMV_Frequenz	SIMV Frequenz 
1115	107997	P_Beatmung_ES_C3_ETS	\N
1108	100249	Beatmung_Einstellung_FlowTrigger	\N
1099	107998	P_Beatmung_ES_C3_Flow	\N
1097	104268	Beatmung_ES_Servoi_DU_ueber_PEEP	DU über PEEP 
1059	103094	Beatmung_ES_CF800_CPAP	eingestelltes CPAP Niveau
1055	103199	Nierenverfahren_MS_4008onl_Leitfähigkeit	\N
1052	110882	Beatmung_ES_Heimbeatmung_Timax	eingestellte maximale Inspirationszeit 
1052	104939	NEV_HD_VO_4008HS_Start_Na	\N
1051	103201	Nierenverfahren_MS_4008onl_BlutvolumenKumulativ	\N
1043	104244	Beatmung_MS_Servoi_Mve_spont	Spontanes exsp. Minutenvolumen 
1029	107993	P_Beatmung_ES_C3_Timax	Inspirationszeit max
1025	108634	P_Waermesysteme_BarkeyWaermepaddels_Doku_Temp	\N
1020	104249	Beatmung_MS_Servoi_Pmean	Mittlerer Atemwegsdruck 
1019	101322	Patient_AufnGewicht	Aufnahmegewicht (fallbezogen)
1016	103197	Nierenverfahren_MS_4008onl_Restzeit	\N
\.


--
-- Name: fhir_profile_observations_profile_id_seq; Type: SEQUENCE SET; Schema: mii_copra; Owner: -
--

SELECT pg_catalog.setval('mii_copra.fhir_profile_observations_profile_id_seq', 41, true);


--
-- Name: mii_icu_used_id_profile_seq; Type: SEQUENCE SET; Schema: mii_copra; Owner: -
--

SELECT pg_catalog.setval('mii_copra.mii_icu_used_id_profile_seq', 1, false);


--
-- Name: co6_config_variable_types co6_config_variable_types_name_key; Type: CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_config_variable_types
    ADD CONSTRAINT co6_config_variable_types_name_key UNIQUE (name);


--
-- Name: co6_config_variable_types co6_config_variable_types_pkey; Type: CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_config_variable_types
    ADD CONSTRAINT co6_config_variable_types_pkey PRIMARY KEY (id);


--
-- Name: co6_config_variables co6_config_variables_pkey; Type: CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_config_variables
    ADD CONSTRAINT co6_config_variables_pkey PRIMARY KEY (id);


--
-- Name: co6_data_decimal_6_3 co6_data_decimal_6_3_pkey; Type: CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_data_decimal_6_3
    ADD CONSTRAINT co6_data_decimal_6_3_pkey PRIMARY KEY (id);


--
-- Name: co6_data_object co6_data_object_pkey; Type: CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_data_object
    ADD CONSTRAINT co6_data_object_pkey PRIMARY KEY (id);


--
-- Name: co6_data_string co6_data_string_pkey; Type: CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_data_string
    ADD CONSTRAINT co6_data_string_pkey PRIMARY KEY (id);


--
-- Name: co6_medic_data_patient co6_medic_data_patient_pkey; Type: CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_medic_data_patient
    ADD CONSTRAINT co6_medic_data_patient_pkey PRIMARY KEY (id);


--
-- Name: co6_medic_pressure co6_medic_pressure_pkey; Type: CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_medic_pressure
    ADD CONSTRAINT co6_medic_pressure_pkey PRIMARY KEY (id);


--
-- Name: mii_icu fhir_profile_observations_pkey; Type: CONSTRAINT; Schema: mii_copra; Owner: -
--

ALTER TABLE ONLY mii_copra.mii_icu
    ADD CONSTRAINT fhir_profile_observations_pkey PRIMARY KEY (profile_id);


--
-- Name: mii_icu fhir_profile_observations_profile_name_key; Type: CONSTRAINT; Schema: mii_copra; Owner: -
--

ALTER TABLE ONLY mii_copra.mii_icu
    ADD CONSTRAINT fhir_profile_observations_profile_name_key UNIQUE (profile_name);


--
-- Name: mii_icu_new mii_icu_new_pkey; Type: CONSTRAINT; Schema: mii_copra; Owner: -
--

ALTER TABLE ONLY mii_copra.mii_icu_new
    ADD CONSTRAINT mii_icu_new_pkey PRIMARY KEY (profile_name);


--
-- Name: mii_icu_used mii_icu_used_pkey; Type: CONSTRAINT; Schema: mii_copra; Owner: -
--

ALTER TABLE ONLY mii_copra.mii_icu_used
    ADD CONSTRAINT mii_icu_used_pkey PRIMARY KEY (id_profile);


--
-- Name: mii_icu_used mii_icu_used_profile_key; Type: CONSTRAINT; Schema: mii_copra; Owner: -
--

ALTER TABLE ONLY mii_copra.mii_icu_used
    ADD CONSTRAINT mii_icu_used_profile_key UNIQUE (profile);


--
-- Name: co6_config_variables co6_config_variables_co6_config_variabletypes_id_fkey; Type: FK CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_config_variables
    ADD CONSTRAINT co6_config_variables_co6_config_variabletypes_id_fkey FOREIGN KEY (co6_config_variabletypes_id) REFERENCES copra.co6_config_variable_types(id);


--
-- Name: co6_data_decimal_6_3 co6_data_decimal_6_3_parent_id_fkey; Type: FK CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_data_decimal_6_3
    ADD CONSTRAINT co6_data_decimal_6_3_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES copra.co6_medic_data_patient(id);


--
-- Name: co6_data_decimal_6_3 co6_data_decimal_6_3_parent_varid_fkey; Type: FK CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_data_decimal_6_3
    ADD CONSTRAINT co6_data_decimal_6_3_parent_varid_fkey FOREIGN KEY (parent_varid) REFERENCES copra.co6_config_variables(id);


--
-- Name: co6_data_decimal_6_3 co6_data_decimal_6_3_varid_fkey; Type: FK CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_data_decimal_6_3
    ADD CONSTRAINT co6_data_decimal_6_3_varid_fkey FOREIGN KEY (varid) REFERENCES copra.co6_config_variables(id);


--
-- Name: co6_data_object co6_data_object_parent_id_fkey; Type: FK CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_data_object
    ADD CONSTRAINT co6_data_object_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES copra.co6_medic_data_patient(id);


--
-- Name: co6_data_object co6_data_object_parent_varid_fkey; Type: FK CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_data_object
    ADD CONSTRAINT co6_data_object_parent_varid_fkey FOREIGN KEY (parent_varid) REFERENCES copra.co6_config_variables(id);


--
-- Name: co6_data_object co6_data_object_varid_fkey; Type: FK CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_data_object
    ADD CONSTRAINT co6_data_object_varid_fkey FOREIGN KEY (varid) REFERENCES copra.co6_config_variables(id);


--
-- Name: co6_data_string co6_data_string_parent_id_fkey; Type: FK CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_data_string
    ADD CONSTRAINT co6_data_string_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES copra.co6_medic_data_patient(id);


--
-- Name: co6_data_string co6_data_string_parent_varid_fkey; Type: FK CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_data_string
    ADD CONSTRAINT co6_data_string_parent_varid_fkey FOREIGN KEY (parent_varid) REFERENCES copra.co6_config_variables(id);


--
-- Name: co6_data_string co6_data_string_varid_fkey; Type: FK CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_data_string
    ADD CONSTRAINT co6_data_string_varid_fkey FOREIGN KEY (varid) REFERENCES copra.co6_config_variables(id);


--
-- Name: co6_medic_pressure co6_medic_pressure_parent_id_fkey; Type: FK CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_medic_pressure
    ADD CONSTRAINT co6_medic_pressure_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES copra.co6_medic_data_patient(id);


--
-- Name: co6_medic_pressure co6_medic_pressure_parent_varid_fkey; Type: FK CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_medic_pressure
    ADD CONSTRAINT co6_medic_pressure_parent_varid_fkey FOREIGN KEY (parent_varid) REFERENCES copra.co6_config_variables(id);


--
-- Name: co6_medic_pressure co6_medic_pressure_varid_fkey; Type: FK CONSTRAINT; Schema: copra; Owner: -
--

ALTER TABLE ONLY copra.co6_medic_pressure
    ADD CONSTRAINT co6_medic_pressure_varid_fkey FOREIGN KEY (varid) REFERENCES copra.co6_config_variables(id);


--
-- PostgreSQL database dump complete
--

