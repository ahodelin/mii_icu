-- fine mapping

-- *Atemfrequenz*
select distinct profile_name  from mii_copra.mapping_mii_co6_tmp mmct where profile_name ~* 'atemfrequenz';
/*
- Spontane Atemfrequenz Beatmet            
- Spontane Mechanische Atemfrequenz Beatmet
- Mechanische Atemfrequenz Beatmet         
- Atemfrequenz                              
 */
select * from mii_copra.mapping_mii_co6_tmp mmct where conf_var_description  ~* 'spont.+enz' ;

--insert into mii_copra.mapping_mii_co6
select distinct 
  'Spontane Mechanische Atemfrequenz Beatmet' profile_name, 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  null profile_unit, 
  0 matching
from mii_copra.co6_config_variables
where description  ~* 'spont.+enz'
and deleted = 'NULL'
and co6_config_variabletypes_id <> 3
  union 
select distinct 
  'Spontane Atemfrequenz Beatmet' profile_name, 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  null profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where description  ~* 'spont.+enz'
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by profile_name
;

--insert into mii_copra.mapping_mii_co6
select distinct 
  'Mechanische Atemfrequenz Beatmet' profile_name, 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  null profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where description  ~* 'Atemfrequenz'
and name ~* 'beatm'
and description !~* '^an|^[esv]|sp'
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by profile_name
;

-- *Arteriell*
select distinct profile_name  from mii_copra.mapping_mii_co6_tmp mmct where profile_name ~* 'arteri';
/*
- Arterieller Druck                                         
x Horowitz In Arteriellem Blut                              
- Pulmonalarterieller Blutdruck                             
- Pulmonalarterieller Wedge Druck

update mii_copra.mii_icu 
  set mapped = false where profile_name = 'Horowitz In Arteriellem Blut';
 */
--insert into mii_copra.mapping_mii_co6
select 
  'Arterieller Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  null profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'arter' 
  or name ~* 'arter'
  )
and description !~* 'pul|li|anl|^2|sau'
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
;


--insert into mii_copra.mapping_mii_co6
select 
  'Pulmonalarterieller Blutdruck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  null profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'pulm' 
  or name ~* 'pulm'
  )
and description !~* 'wed|i[dn]|kap'
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
;
--insert into mii_copra.mapping_mii_co6
select 
  'Pulmonalarterieller Wedge Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  null profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'pulm' 
  or name ~* 'pulm'
  )
and description !~* 'wed|i[dn]|kap'
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
;


/*
-Sauerstoffsaettigung im arteriellen Blut Per Pulsoxymetrie       |%            
-Sauerstoffsaettigung im Blut postduktal durch Pulsoxymetrie      |%            
-Sauerstoffsaettigung im Blut preductal durch Pulsoxymetrie       |%m 
 */  

--insert into mii_copra.mapping_mii_co6
select 
  'Sauerstoffsaettigung im arteriellen Blut Per Pulsoxymetrie' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  null profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'o2|sauer' 
  or name ~* 'o2|sauer'
  )
--and description !~* 'co2|^[cflvwpt]'
and description ~* 'pulso'
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
;


/*
-Blutdruck
x Blutdruck Generisch 


update mii_copra.mii_icu 
  set mapped = false where profile_name in ('Blutdruck Generisch');
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Blutdruck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  null profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'blut' 
  or name ~* 'blut'
  )
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and description !~* '^[abzcÜ]|vol|verl|pump';
and conf_var_id not in (select conf_var_id from mii_copra.mapping_mii_co6)
/*  union 
select 
  'Blutdruck Generisch' profile_name ,
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  null profile_unit, 
  0 matching
from mii_copra.co6_config_variables
where (description  ~* 'blut' 
  or name ~* 'blut'
  )
and deleted = 'NULL'
and co6_config_variabletypes_id <> 3
--and conf_var_id not in (select conf_var_id from mii_copra.mapping_mii_co6)
;
*/


-- *Beatmung* 
select profile_name, profile_unit from mii_copra.mii_icu mi where profile_name ~* 'beat';
/*
x Beatmung                                               |             
x DeviceMetric eingestellte gemessene Parameter Beatmung |             
x Parameter von Beatmung                                 |             
x Spontanes Mechanisches Atemzugvolumen Waehrend Beatmung|             
x Atemzugvolumen Waehrend Beatmung                       |mL           
- Beatmungsvolumen Pro Minute Machineller Beatmung       |L/min        
- Beatmungszeit Hohem Druck                              |s            
- Beatmungszeit niedriegem Druck                         |s            
- Druckdifferenz Beatmung                                |cm[H2O]      
x Einstellung Ausatmungszeit Beatmung                    |s            
- Einstellung Einatmungszeit Beatmung                    |s            
x Maximaler Beatmungsdruck                               |cm[H2O]      
- Mechanische Atemfrequenz Beatmet                       |{breaths}/min
- Mittlerer Beatmungsdruck                               |cm[H2O]      
- Spontane Atemfrequenz Beatmet                          |/min         
- Spontane Mechanische Atemfrequenz Beatmet              |/min         
x Unterstuzungsdruck Beatmung                            |cm[H2O]      
 
update mii_copra.mii_icu 
  set mapped = false where profile_name in ('Beatmung',
 'DeviceMetric eingestellte gemessene Parameter Beatmung',
 'Parameter von Beatmung',
 'Spontanes Mechanisches Atemzugvolumen Waehrend Beatmung',
 'Atemzugvolumen Waehrend Beatmung',
 'Einstellung Ausatmungszeit Beatmung',
 'Maximaler Beatmungsdruck'
 'Unterstuzungsdruck Beatmung');
 */
--insert into mii_copra.mapping_mii_co6
select 
  'Beatmungsvolumen Pro Minute Machineller Beatmung' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'L/min' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'beatm' 
  or name ~* 'beatm'
  )
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and (name !~* 'spon|sp' or description !~* 'spon')
and unit ~* 'l/min'
and unit !~* 'b|h|%|s|p|w'
and description notnull
and description ~* 'vo'
and description !~* 'ano|ex|ins|leck|sp$|nind|^Dok'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by conf_var_unit 
;

select 
  'Spontane Atemfrequenz Beatmet' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  '/min' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'beatm' 
  or name ~* 'beatm'
  )
and (description ~* 'spon' or name ~* 'spon|sp')
and deleted = 'NULL'
and co6_config_variabletypes_id <> 3
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by conf_var_unit 
;

--Beatmungszeit Hohem Druck
--insert into mii_copra.mapping_mii_co6
select 
  'Beatmungszeit Hohem Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  's' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'beatm' 
  or name ~* 'beatm'
  )
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and description notnull
and description ~* '(zeit.+dru)|(dru.+zeit)'
and description ~* 'ob'
and description !~* '^[d]|unter'
and unit !~* 'bar'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

--Beatmungszeit Hohem Druck
--insert into mii_copra.mapping_mii_co6
select 
  'Beatmungszeit Hohem Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  's' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'beatm' 
  or name ~* 'beatm'
  )
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and name ~* '(zeit.*ho)'
and name !~* 'eins'
and unit !~* 'bar'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


delete from ;
select * from mii_copra.mapping_mii_co6 where conf_var_description ~* 'anor';
--Beatmungszeit niedriegem Druck
--insert into mii_copra.mapping_mii_co6
select 
  'Beatmungszeit niedriegem Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  's' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'beatm' 
  or name ~* 'beatm'
  )
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and name ~* 'zeitnie'
and name !~* 'eins|ave'
and unit ~* 's'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

--Beatmungszeit niedriegem Druck
--insert into mii_copra.mapping_mii_co6
select 
  'Beatmungszeit niedriegem Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  's' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'beatm' 
  or name ~* 'beatm'
  )
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and description  ~* '(zeit.+druc)'
and description  ~* 'unte'
and description !~* 'para|obe'
and unit ~* 's'
and unit !~* 'bar'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

--Druckdifferenz Beatmung                                |cm[H2O]
--insert into mii_copra.mapping_mii_co6
select 
  'Druckdifferenz Beatmung' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'cm[H2O]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'beatm' 
  or name ~* 'beatm'
  )
and (name ~* 'dif' or description ~* 'dif')
and description !~* 'einst'
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

--insert into mii_copra.mapping_mii_co6
select 
  'Einstellung Einatmungszeit Beatmung' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  's' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'beatm' 
  or name ~* 'beatm'
  )
and description ~* 'einst|eing'
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and unit ~* 's'
and description ~* 'insp|eina'
and description !~* 'maxi'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

--Mittlerer Beatmungsdruck                               |cm[H2O] 
--insert into mii_copra.mapping_mii_co6
select 
  'Mittlerer Beatmungsdruck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'cm[H2O]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'beatm' 
  or name ~* 'beatm'
  )
and description !~* 'einst|einge'
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and unit !~* 's|ba|p'
and description ~* 'mitt.+druck'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

--Mechanische Atemfrequenz Beatmet
--insert into mii_copra.mapping_mii_co6
select 
  'Mechanische Atemfrequenz Beatmet' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  '{breaths}/min' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'beatm' 
  or name ~* 'beatm'
  )
and description ~* 'fre'
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and unit ~* 'min'
and description !~* '^[acdesv]|ba'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

/*
- Venoeser Druck                                                   |mmHg   
- Zeitverhaeltnis Ein Ausatmung                                    |{ratio}
- Zentralvenoeser Blutdruck                                        |mm[Hg]

update mii_copra.mii_icu 
  set mapped = true where profile_name in ('Zeitverhaeltnis Ein Ausatmung');
 */
--insert into mii_copra.mapping_mii_co6
select 
  'Venoeser Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mmHg' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'ven' 
  --or name ~* 'ven'
  )
and description ~* 'druck'
and description !~* 'zen|tri'
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


--insert into mii_copra.mapping_mii_co6
select 
  'Zeitverhaeltnis Ein Ausatmung' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  '{ratio}' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'verh' or description  ~* 'verh' 
  )
and description ~* 'mess'
and deleted = 'NULL'
--and co6_config_variabletypes_id <> 3
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
- Kopfumfang cm
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Kopfumfang' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'cm' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'kopfumfang' 
  )
and description !~* 'interv|grenz|ziel'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
- Dynamische Kompliance mL/cm[H2O]
*/

--insert into mii_copra.mapping_mii_co6
select 
'Dynamische Kompliance' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mL/cm[H2O]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'dyna.+char' 
  )
--and description !~* 'interv|grenz|ziel'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
- Dauer Haemodialysesitzung
*/
--insert into mii_copra.mapping_mii_co6
select 
  'Dauer Haemodialysesitzung' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'h' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'dial' or description  ~* 'dial' 
  )
and name ~* 'nie.+zei'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;



/*
- Intrakranieller Druck
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Intrakranieller Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mm[Hg]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'intra[ck]' or description  ~* 'intra[ck]' 
  )
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

/*
- Ionisiertes Kalzium Nierenersatzverfahren mmol/L
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Ionisiertes Kalzium Nierenersatzverfahren' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mmol/L' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* '(calc|kalz)' or description  ~* 'calc|kalz' 
  )
and unit ~* 'o'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
- Systemischer Vaskulaerer Widerstandsindex  dyn.s/(cm.m2) 
*/

--insert into mii_copra.mapping_mii_co6
select 
  'Systemischer Vaskulaerer Widerstandsindex' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'dyn.s/(cm.m2)' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'sys.+vas.+ind' or description  ~* 'sys.+vas.+ind' 
  )
--and unit ~* ''
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
- Pulmonalarterieller Wedge Druck
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Pulmonalarterieller Wedge Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mm[Hg]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'wedg' or description  ~* 'wedg' 
  )
--and unit ~* ''
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
- Pulmonalvaskulaerer Widerstandsindex dyn.s/(cm5.m2)
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Pulmonalvaskulaerer Widerstandsindex' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'dyn.s/(cm5.m2)' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'pul.+vas.+ind' 
  )
--and unit ~* ''
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;
/*
-Linksventrikulaerer Schlagvolumenindex                           
-Linksatrialer Druck                                              
-Linksventrikulaerer Druck                                        
-Linksventrikulaerer Herzindex                                    
Linksventrikulaerer Herzindex durch Indikatorverduennung         
Linksventrikulaerer Schlagvolumenindex durch Indikatorverduennung
Linksventrikulaeres Herzzeitvolumen durch Indikatorverduennung   
-Linksventrikulaeres Schlagvolumen                                
Linksventrikulaeres Schlagvolumen durch Indikatorverduennung     
 */
/*
Linksatrialer Druck mm[Hg]
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Linksatrialer Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mm[Hg]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description  ~* 'lin.+atria' 
  )
--and unit ~* ''
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
- Linksventrikulaerer Druck
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Linksventrikulaerer Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mm[Hg]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name  ~* 'l.+ventr.+dr' or description ~* 'l.+ventr.+dr')
--and unit ~* ''
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;



/*
Koerpertemperatur Kern
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Koerpertemperatur Kern' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'Cel' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name  ~* 'temp' or description ~* 'temp')
and name ~* 'kern'
and name !~* 'ort|ver'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
- Linksventrikulaerer Herzindex L/(min.m2)
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Linksventrikulaerer Herzindex' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'L/(min.m2)' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name  ~* 'index' or description ~* 'index')
and description ~* 'link'
--and name !~* 'ort|ver'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
- Koerpergewicht kg
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Koerpergewicht' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'kg' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name  ~* 'gew' or description ~* 'gewi')
and description notnull
and name !~* '^[abefvz]|beat|vo_|waa|kon|dif|prae'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

/*
- Substituatfluss                                                  |ml/h 
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Substituatfluss' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'ml/h' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name  ~* 'tuat' or description ~* 'tuat')
and description notnull
and name !~* '^[i]|bolu'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

/*
- Positv Endexpiratorischer Druck  cm[H2O] 
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Positv Endexpiratorischer Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'cm[H2O]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name  ~* 'posi' or description ~* 'posi')
and description notnull
and description ~* '^pos.+end.+dr'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
- Maximaler Beatmungsdruck cm[H2O]
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Maximaler Beatmungsdruck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'cm[H2O]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name  ~* 'beat.+max' or description ~* 'max')
and description notnull
and unit ~* 'h2o'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
- Sauerstoffgasfluss L/min
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Sauerstoffgasfluss' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'L/min' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name  ~* 'o2|sauer' or description ~* 'o2|sauer')
--and description notnull
and name ~* 'flow'
and name !~* 'filt'
and unit ~* 'l/min'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

/*
x Ideales Koerpergewicht kg
 */

--insert into mii_copra.mapping_mii_co6
select 
--  'Ideales Koerpergewicht' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
--  '' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'gewi' or description ~* 'gewi')
and (unit isnull or unit ~* 'kg')
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
x Koerpergewicht Percentil Altersabhaengig  %
 */

--insert into mii_copra.mapping_mii_co6
select 
--  'Koerpergewicht Percentil Altersabhaengig' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
--  '%' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'per[cz]' or description ~* 'per[cz]')
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
- Endexpiratorischer Kohlendioxidpartialdruck  mm[Hg]
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Endexpiratorischer Kohlendioxidpartialdruck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mm[Hg]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description ~* 'co2|koh|diox|end')
and description notnull
and description ~* '^endt.+ck'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
- Exspiratorischer Sauerstoffpartialdruck  mm[Hg]
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Exspiratorischer Sauerstoffpartialdruck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mm[Hg]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (description ~* 'gem.+partial')
and description notnull
--and description ~* ''
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
x Dauer extrakoporaler Gasaustausch  h
 */

--insert into mii_copra.mapping_mii_co6
select 
  --'Dauer extrakoporaler Gasaustausch' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  --'h' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'extr' or description ~* 'gas')
and description notnull
and unit notnull
and unit !~* '%'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

update mii_copra.mii_icu
  set mapped = false where profile_name = 'Dauer extrakoporaler Gasaustausch';

  

/*
Blutflussindex Extrakoporaler Gasaustausch  L/(min.m2)
 */

--insert into mii_copra.mapping_mii_co6
select 
  --'Blutflussindex Extrakoporaler Gasaustausch' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  --'L/(min.m2)' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'extr' or description ~* 'extr')
and description notnull
--and unit notnull
--and unit !~* '%'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;


/*
x Blutflussindex Extrakoporaler Gasaustausch  L/(min.m2)
 */

--insert into mii_copra.mapping_mii_co6
select 
  --'Blutflussindex Extrakoporaler Gasaustausch' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  --'L/(min.m2)' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'extr' or description ~* 'extr')
and description notnull
--and unit notnull
--and unit !~* '%'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

/*
update mii_copra.mii_icu
  set mapped = false where profile_name ~* 'extrakorporale';
*/


/*
- Eingestellter Inspiratorischer Gasfluss  L/min
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Eingestellter Inspiratorischer Gasfluss' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'L/min' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'ins' or description ~* 'insp')
and name !~* 'max|bias|sauer|trig|peak'
and name ~* 'anord|einstel'
--and unit notnull
and unit ~* 'l/min'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

/*
update mii_copra.mii_icu
  set mapped = true where profile_name = 'Eingestellter Inspiratorischer Gasfluss';
*/

/*
- Exspiratorischer Gasfluss L/min
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Exspiratorischer Gasfluss' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'L/min' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'flow' or description ~* 'gas|flu')
--and name !~* '^[andfilmr]|b_|peak|trig|o2|dru|impel|saue|bias|prae|max|coug|_vo_'
and (description isnull or description ~* 'exsp.+flo')
and name ~* 'exsp'
--and unit !~* '%'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

/*
update mii_copra.mii_icu
  set mapped = true where profile_name = 'Exspiratorischer Gasfluss';
*/


/*
- Inspiratorischer Gasfluss
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Inspiratorischer Gasfluss' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'L/min' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'fl[uo]' or description ~* 'gas|fl[uo]')
and name !~* 'max'
and (description isnull or description ~* 'insp')
and name ~* 'insp'
and unit ~* 'l/min'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

/*
update mii_copra.mii_icu
  set mapped = true where profile_name = 'Inspiratorischer Gasfluss';
*/


/*
x Atemzugvolumen Einstellung   ml
 */

--insert into mii_copra.mapping_mii_co6
select 
  --'Atemzugvolumen Einstellung' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  --'ml' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'vol' or description ~* 'vol')
and description notnull
and unit ~* 'ml'
and unit !~* '/'
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

/*
update mii_copra.mii_icu
  set mapped = false where profile_name = 'Atemzugvolumen Einstellung';
*/


/*
- Substituatvolumen  l
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Substituatvolumen' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'l' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'substi.+bol' or description ~* 'subtit.+bol')
and description notnull
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

/*
update mii_copra.mii_icu
  set mapped = true where profile_name = 'Substituatvolumen';
*/



/*
x Atemwegsdruck Mittlerem Expiratorischem Gasfluss  cm[H2O]
 */

--insert into mii_copra.mapping_mii_co6
select 
  --'Atemwegsdruck Mittlerem Expiratorischem Gasfluss' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  --'cm[H2O]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'exs' or description ~* 'exs')
and unit notnull
and description notnull
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;



/*
- Sauerstofffraktion
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Sauerstofffraktion' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  null profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'fio2' or description ~* 'fio2|o2.+kon.')
and name !~* 'anor|eins|^p.+ms.+3100a'
and name ~* '^[bp]'
and (description isnull or description !~* 'exs|no2|stell')
and deleted = 'NULL'
--and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by name 
;

/*
update mii_copra.mii_icu
  set mapped = true where profile_name = 'Sauerstofffraktion';
*/


/*
x Atemwegsdruck Null Expiratorischem Gasfluss  cm[H2O]
 */

--insert into mii_copra.mapping_mii_co6
select 
  --'Atemwegsdruck Null Expiratorischem Gasfluss' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  --'cm[H2O]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* '^[pbl].+fl[ou]' or description ~* 'fl[ou]')
and unit notnull
and description notnull
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by description 
;

/*
update mii_copra.mii_icu
  set mapped = false where profile_name = 'Atemwegsdruck Null Expiratorischem Gasfluss';
*/


/*
- Sauerstofffraktion Eingestellt
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Sauerstofffraktion Eingestellt' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  null profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'fio2' or description ~* 'fio2|o2.+kon.')
and name !~* '^p.+ms.+3100a|ano'
and name ~* '^[bp]|einst'
and (description isnull or description !~* 'exs|no2|^doku')
and deleted = 'NULL'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by name  
;

/*
update mii_copra.mii_icu
  set mapped = true where profile_name = 'Sauerstofffraktion Eingestellt';
*/


--------------------------------------------------------
/*
- Rechtsatrialer Druck  mm[Hg]
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Rechtsatrialer Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mm[Hg]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where 
name ~* '(rech|righ).+(ar*tri).+(dru|pres)' 
or description ~* '(rech|righ).+(ar*tri).+(dru|pres)' 
or displayname ~*'(rech|righ).+(ar*tri).+(dru|pres)'
and deleted isnull
order by name  
;

/*
update mii_copra.mii_icu
  set mapped = true where profile_name = 'Rechtsventrikulaerer Druck';
*/



/*
- Rechtsventrikulaerer Druck   mm[Hg]
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Rechtsventrikulaerer Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mm[Hg]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where 
name ~* '(rech|righ).+ven.+(dru|pres)' 
or description ~* '(rech|righ).+ven.+(dru|pres)' 
or displayname ~*'(rech|righ).+ven.+(dru|pres)'
and deleted isnull
--and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by name  
;



/*
- Linksventrikulaerer Schlagvolumenindex  mL/m2
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Linksventrikulaerer Schlagvolumenindex' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mL/m2' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where (name ~* 'svi' 
or description ~* '(lef|link).+vol.+inde' 
)
and deleted isnull
and description notnull
--and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by name  
;

/*
update mii_copra.mii_icu
  set mapped = true where profile_name = 'Linksventrikulaerer Schlagvolumenindex';
*/



--------------------------------------------------------
/*
- Periphere Artierielle Sauerstoffsaettigung ICU  %
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Periphere Artierielle Sauerstoffsaettigung ICU' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  '%' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where ( name ~* 'sao2'
or description ~* 'sao2'
or displayname ~* 'sao2'
)
and name !~* 'z'
and deleted isnull
and description notnull
--and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by name  
;

/*
update mii_copra.mii_icu
  set mapped = true where profile_name = 'Monitoring und Vitaldaten';
*/


-- falta
select 
  distinct profile_name, profile_unit 
from mii_copra.mii_icu mi  
where mapped isnull
--and profile_unit notnull 
order by profile_name;

--drop table mii_copra.loinc;
select distinct 'https://loinc.org/'||loinc||'/' url_loinc, loinc, profile_name, null::boolean mapped into mii_copra.loinc from mii_copra.mii_icu mi where loinc notnull;

--- nach loinc shortname

--------------------------------------------------------
/*
- Pulmonalvaskulaerer Widerstandsindex  dyn.s/(cm5.m2)
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Pulmonalvaskulaerer Widerstandsindex' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'dyn.s/(cm5.m2)' profile_unit, 
  0 matching
from mii_copra.co6_config_variables 
where name ~* 'pvri'
and deleted isnull
--and description notnull
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by name  
;

/*
update mii_copra.mii_icu
  set mapped = true where profile_name = 'Monitoring und Vitaldaten';
*/



/*
- Beatmungsvolumen Pro Minute Maschineller Beatmung
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Beatmungsvolumen Pro Minute Maschineller Beatmung' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'L/min' profile_unit, 
  0 matching
from mii_copra.co6_config_variables
where (name ~* 'MV' or description ~* 'MV')
and deleted isnull
and (unit ~* 'l/min')
and description ~* 'ins.+men'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by name  
;

/*
update mii_copra.mii_icu
  set mapped = true where profile_name = 'Horowitz In Arteriellem Blut';
*/


/*
- Ionisiertes Kalzium Nierenersatzverfahren  mmol/l
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Ionisiertes Kalzium Nierenersatzverfahren' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mmol/L' profile_unit, 
  0 matching
from mii_copra.co6_config_variables
where name ~* 'CRRT.+cal'
and deleted isnull
--and (unit ~* 'l/min')
and name !~* 'vol|fluss'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by name  
;


/*
- Intrakranieller Druck
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Intrakranieller Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mm[Hg]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables
where name ~* 'ICP'
and deleted isnull
and (unit ~* 'mmhg' or unit isnull)
and name ~* 'messung'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by name  
;



/*
- Systemischer Vaskulaerer Widerstandsindex
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Systemischer Vaskulaerer Widerstandsindex' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'dyn.s/(cm.m2)' profile_unit, 
  0 matching
from mii_copra.co6_config_variables
where name ~* 'svri'
and deleted isnull
--and (unit ~* '' or unit isnull)
--and name ~* ''
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by name  
;


/*
- Spontanes Atemzugvolumen ml
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Spontanes Atemzugvolumen' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mL' profile_unit, 
  0 matching
from mii_copra.co6_config_variables
where (name ~* 'tidal' or description ~* 'tidal')
and deleted isnull
and (unit ~* 'l')
and description ~* 'spont'
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by name  
;


/*
- Positv Endexpiratorischer Druck  cm[H2O]
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Positv Endexpiratorischer Druck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'cm[H2O]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables
where (name ~* 'PEEP' or description ~* 'PEEP')
and deleted isnull
and unit notnull
and name !~* '^(p|b_)|pins|einst|cpap|grenz'
and (description isnull or description !~* 'ein[sg]|nega|uner|modu|anord|[üö]')
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by name  
;

--------------------------------------------------------
/*
- Horowitz In Arteriellem Blut  mm[Hg]
 */


--insert into mii_copra.mapping_mii_co6
select 
  'Horowitz In Arteriellem Blut' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mm[Hg]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables
where (name ~* 'horo' or description ~* 'horo')
and deleted isnull
--and unit notnull
--and name !~* '^(p|b_)|pins|einst|cpap|grenz'
and description notnull
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by name  
;


/*
- Atemzugvolumen Waehrend Beatmung  mL
 */


--insert into mii_copra.mapping_mii_co6
select 
  'Atemzugvolumen Waehrend Beatmung' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'mL' profile_unit, 
  0 matching
from mii_copra.co6_config_variables
where (name ~* 'tidal' or description ~* 'tidal')
and deleted isnull
and unit ~* 'l'
and name !~* 'einst|anor|vt[ie]' 
and description !~* 'ein[gs]|anor|insp'
--and description notnull
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by name  
;


/*
- Maximaler Beatmungsdruck  cm[H2O]
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Maximaler Beatmungsdruck' profile_name , 
  name conf_var_name, 
  description conf_var_description, 
  id conf_var_id, 
  unit conf_var_unit, 
  'cm[H2O]' profile_unit, 
  0 matching
from mii_copra.co6_config_variables
where (name ~* '^beat.+pmax' or description ~* 'max')
and deleted isnull
--and unit isnull
and name !~* '^n|tim|ano' 
and (description isnull or description !~* 'ein[gs]|ala')
--and description notnull
and id not in (select conf_var_id from mii_copra.mapping_mii_co6 mmc)
order by name  
;




