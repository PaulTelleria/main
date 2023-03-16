
select B.car_model_name as MODELO, 
C.brand_name as MARCA, 
D.company_name as GRUPO, 
A.purchase_date as FECHA_COMPRA, 
A.plate as MATRICULA, 
E.COLOR, 
A.total_kms as KILOMETRAJE, 
F.insurance_company_name as ASEGURADORA, 
A.policy_number as NUMERO_POLIZA,
H.currency_name as MONEDA
from KFleet.active_cars A, KFleet.car_model B, KFleet.car_brand C, KFleet.company_group D, KFleet.color E, KFleet.insurance_company F, KFleet.car_reviews G, KFleet.currency H 
where A.id_car = B.id_car and A.id_model = B.id_model and B.id_car_brand = C.id_car_brand and C.id_company_group = D.id_company_group and A.id_color = E.id_color and A.id_insurance_company = F.id_insurance_company and A.policy_number = F.policy_number and A.id_car = G.id_car and G.id_currency = H.id_currency

