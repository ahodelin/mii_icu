-- string
select 
  count(cvt.id) quantity_in_string, 
  ccv.id,
  ccv."name",
  ccv.description 
from copra.co6_config_variables ccv  
join copra.co6_data_string cvt
  on cdd.varid = ccv.id 
where not cvt.deleted
and ccv.parent in (1, 20)
and not ccv.deleted
and cvt.flagcurrent
and cvt.validated 
group by ccv.id, ccv."name"
having count(cvt.id) >= 1000
order by quantity desc;

-- decimal
select
  count(cvt.id) quantity_in_decimal,
  ccv.id,
  ccv."name",
  ccv.description
from copra.co6_config_variables ccv
join copra.co6_data_decimal_3_6 cvt
  on cdd.varid = ccv.id
where not cvt.deleted
and ccv.parent in (1, 20)
and not ccv.deleted
and cvt.flagcurrent
and cvt.validated
group by ccv.id, ccv."name"
having count(cvt.id) >= 1000
order by quantity desc;

-- string
select
  count(cvt.id) quantity_in_prossure,
  ccv.id,
  ccv."name",
  ccv.description
from copra.co6_config_variables ccv
join copra.co6_medic_pressure cvt
  on cdd.varid = ccv.id
where not cvt.deleted
and ccv.parent in (1, 20)
and not ccv.deleted
and cvt.flagcurrent
and cvt.validated
group by ccv.id, ccv."name"
having count(cvt.id) >= 1000
order by quantity desc;
