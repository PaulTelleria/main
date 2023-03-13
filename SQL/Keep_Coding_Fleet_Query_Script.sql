
select concat (a.purchase_date,b.currency_name ) as fecha_inicio,
a.purchase_date as fecha_inicio,
a.plate as Matricula,
a.total_kms as total_kilometros,
b.car_model_name as modelo,
c.brand_name as marca,
d.company_name as grupo_automovilistico ,
e.color,
f.insurance_company_name as aseguradora,
h.currency_name as moneda,
from kihrwwcm.KeepCodingFleet a
inner join kihrwwcm.car_model b on b.id_car=a.id_car and a.id_model = b.id_model
inner join kihrwwcm.car_brand c on b.id_car_brand=c.id_car_brand
inner join kihrwwcm.company_group d on c.id_company_group=d.id_company_group 
inner join kihrwwcm.color e on a.id_color=e.id_color
inner join kihrwwcm.insurance_company f on a.id_insurance_company=f.id_insurance_company and a.policy_number=f.policy_number
inner join kihrwwcm.car_reviews g on a.id_car=g.id_car and a.active_date=g.active_date
inner join kihrwwcm.currency h on g.id_currency=h.id_currency
order by a.purchase_date ;   