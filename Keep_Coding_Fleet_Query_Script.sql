select concat (a.car_model_name,b.car_brand_name,c.company_group_name ) as Tipo_Coche,
a.Tipo_Coche,
b.purchase_date as Fecha_Compra,
c.company_group_name as Grupo,
d.total_kms as Kilometraje
e.id_color as Color,             --Error no encontrado
f.insurance_company_name as Aseguradora,
g.policy_number as Numero_Poliza,
h.plate as Matricula ,
from KeepCodingFleet.active_cars a

order by c.plate ;