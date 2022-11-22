CREATE OR REPLACE VIEW copra.v_profil_decimal
AS
SELECT 
  'd_'||md5((SELECT table_name FROM information_schema.tables 
   WHERE table_schema = 'copra'
   and table_name = 'co6_data_decimal_6_3') || cdd.id||mmc.profile_name) id,
   mmc.meta_profile,
   'final' status,
   mmc.category_coding_system,
   mmc.category_coding_code,
   mmc.code_coding_system_snomed,
   mmc.code_coding_code_snomed,
   mmc.code_coding_system_loinc,
   mmc.code_coding_code_loinc,
   mmc.code_coding_system_ieee,
   mmc.code_coding_code_ieee,
   'p_'||md5(cmdp.id::varchar) subject_reference,
   cdd.val * mmc.unit_transform "valueQuantity_value",
   mmc.valuequantity_system "valueQuantity_system",
   mmc.valuequantity_code "valueQuantity_code",
   cdd.datetimeto "effectiveDataTime"
  from copra.co6_data_decimal_6_3 cdd 
  join copra.co6_config_variables ccv 
    on cdd.varid = ccv.id 
  join copra.mapping_mii_co6_2 mmc 
    on mmc.conf_var_id = ccv.id 
  join copra.co6_medic_data_patient cmdp 
    on cmdp.id = cdd.parent_id 
  where cdd.validated 
  and not cdd.deleted 
  and cdd.flagcurrent
 ;

CREATE OR REPLACE VIEW copra.v_profil_string 
AS
SELECT 
  's_'||md5((SELECT table_name FROM information_schema.tables 
   WHERE table_schema = 'copra'
   and table_name = 'co6_data_string') || cdd.id|| mmc.profile_name) id,   
   mmc.meta_profile,
   'final' status,
   mmc.category_coding_system,
   mmc.category_coding_code,
   mmc.code_coding_system_snomed,
   mmc.code_coding_code_snomed,
   mmc.code_coding_system_loinc,
   mmc.code_coding_code_loinc,
   mmc.code_coding_system_ieee,
   mmc.code_coding_code_ieee,
   'p_'||md5(cmdp.id::varchar) subject_reference,
   cdd.val::decimal * mmc.unit_transform "valueQuantity_value",  
   mmc.valuequantity_system "valueQuantity_system",
   mmc.valuequantity_code "valueQuantity_code",
   cdd.datetimeto "effectiveDataTime"
  from copra.co6_data_string cdd 
  join copra.co6_config_variables ccv 
    on cdd.varid = ccv.id 
  join copra.mapping_mii_co6_2 mmc 
    on mmc.conf_var_id = ccv.id 
  join copra.co6_medic_data_patient cmdp 
    on cmdp.id = cdd.parent_id 
  where not cdd.deleted 
  and cdd.flagcurrent
  and cdd.val ~ '^\d+$|^\d+\.\d+$'
 ;

CREATE OR REPLACE VIEW copra.v_profil_pressure 
AS
SELECT 
  'pr_'||md5((SELECT table_name FROM information_schema.tables 
   WHERE table_schema = 'copra'
   and table_name = 'co6_medic_pressure') || cdd.id || mmc.profile_name) id,
   mmc.meta_profile,
   'final' status,
   mmc.category_coding_system,
   mmc.category_coding_code,  
   'p_'||md5(cmdp.id::varchar) subject_reference,
    cdd.datetimeto "effectiveDataTime",
    mmc.code_systolic_coding_system_snomed,
    mmc.code_systolic_coding_code_snomed,
    mmc.code_systolic_coding_system_loinc,
    mmc.code_systolic_coding_code_loinc,
    mmc.code_systolic_coding_system_ieee ,
    mmc.code_systolic_coding_code_ieee,
    cdd.systolic "valueQuantity_value_systolic",
    mmc.valuequantity_system "valueQuantity_system_systolic",
    mmc.valuequantity_code "valueQuantity_code_systolic",
    mmc.code_mean_coding_system_snomed,
    mmc.code_mean_coding_code_snomed,
    mmc.code_mean_coding_system_loinc,
    mmc.code_mean_coding_code_loinc,
    mmc.code_mean_coding_system_ieee ,
    mmc.code_mean_coding_code_ieee,
    cdd.mean "valueQuantity_value_mean",
    mmc.valuequantity_system "valueQuantity_system_mean",
    mmc.valuequantity_code "valueQuantity_code_mean",
    mmc.code_diastolic_coding_system_snomed,
    mmc.code_diastolic_coding_code_snomed,
    mmc.code_diastolic_coding_system_loinc,
    mmc.code_diastolic_coding_code_loinc,
    mmc.code_diastolic_coding_system_ieee,
    mmc.code_diastolic_coding_code_ieee,
    cdd.mean "valueQuantity_value_diastolic",
   mmc.valuequantity_system "valueQuantity_system_diastolic",
   mmc.valuequantity_code "valueQuantity_code_diastolic"
  from copra.co6_medic_pressure cdd 
  join copra.co6_config_variables ccv 
    on cdd.varid = ccv.id 
  join copra.mapping_mii_co6_2 mmc 
    on mmc.conf_var_id = ccv.id 
  join copra.co6_medic_data_patient cmdp 
    on cmdp.id = cdd.parent_id 
  where cdd.validated 
  and not cdd.deleted 
  and cdd.flagcurrent
 ;
