create schema "KeepCodingFleet" authorization kihrwwcm;

create table company_group( 
id_company_group integer not null,                   --PK
company_name varchar(255)not null,
constraint company_group_PK primary key(id_company_group)
);

create table car_brand( 
id_car_brand integer not null ,                     --PK
id_company_group integer not null,                  --FK
brand_name varchar(255)not null,
constraint car_brand_PK primary key(id_car_brand),
constraint car_brand_FK foreign key(id_company_group) references company_group(id_company_group)
);

create table car_model( 
id_car integer not null,                                 --PK
active_date date not null ,                              --PK (YYYY-MM-DD)
id_model integer not null ,                        --PK
id_car_brand integer not null,                     --FK
car_model_name varchar(255)not null,
constraint car_model_PK primary key(id_car, active_date, id_model),
constraint car_model_FK foreign key(id_car_brand) references car_brand(id_car_brand)
);

create table insurance_company( 
id_insurance_company integer not null,              --PK
policy_number integer not null,                          --PK
insurance_company_name varchar(255)not null,
constraint insurance_company_PK primary key(id_insurance_company)
);

create table color( 
id_color integer not null ,                          --PK
color_name varchar(255)not null,
constraint color_PK primary key(id_color)
);

create table currency( 
id_currency integer not null ,                       --PK
currency_name varchar(255)not null,
constraint currency_PK primary key(id_currency)
);

create table car_reviews( 
id_car integer not null,                                  --PK
active_date date not null ,                               --PK (YYYY-MM-DD)
id_review integer not null,                               --PK
review_date date not null,                                --(YYYY-MM-DD)
review_price integer not null,
id_currency integer not null,                         --FK
description varchar(255) null,
constraint car_reviews_PK primary key(id_car,active_date,id_review),
constraint car_reviews_FK foreign key(id_currency) references currency(id_currency)
);

create table active_cars( 
id_car integer not null,                                     --PK
active_date date not null ,                                  --PK (YYYY-MM-DD)
active_name varchar (255) not null,
id_model integer not null,                                   --FK
id_color integer not null,                                   --FK
plate varchar (10) not null,
id_insurance_company integer not null,                       --FK
policy_number integer not null,                             
total_kms integer not null,
purchase_date date not null,                                --(YYYY-MM-DD)
description varchar(255) null,
constraint active_cars_PK primary key(id_car, active_date),
constraint active_cars_FK1 foreign key (id_color) references color(id_color),
constraint active_cars_FK2 foreign key (id_car, active_date,id_model) references car_model(id_car, active_date,id_model),
constraint active_cars_FK3 foreign key (id_insurance_company) references insurance_company(id_insurance_company)
);

insert into company_group(id_company_group , company_name) values (01 ,"PSA");
insert into company_group(id_company_group , company_name) values (02 ,"Alianza Renault-Nissan-Mitsubishi");
insert into company_group(id_company_group , company_name) values (03 ,"Grupo Volkswagen");
insert into company_group(id_company_group , company_name) values (04 ,"Toyota Motor Corporation");
insert into company_group(id_company_group , company_name) values (05 ,"FCA");
insert into company_group(id_company_group , company_name) values (06 ,"General Motors");
insert into company_group(id_company_group , company_name) values (07 ,"Grupo BMW");


insert into car_brand(id_car_brand , id_company_group, brand_name) values (01 , 01 ,"Peugeot");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (02 , 01 ,"Opel");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (03 , 01 ,"Citroen");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (04 , 01 ,"DS");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (05 , 01 ,"Vauxhall");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (06 , 02 ,"Reanult");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (07 , 02 ,"Dacia");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (08 , 02 ,"Datsun");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (09 , 02 ,"Mitsubishi");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (10 , 02 ,"Nissan");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (11 , 02 ,"Infiniti");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (12 , 02 ,"Samsung");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (13 , 02 ,"Alpine");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (14 , 03 ,"Audi");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (15 , 03 ,"Bentley");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (16 , 03 ,"Bugatti");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (17 , 03 ,"Lamborgini");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (18 , 03 ,"Porsche");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (19 , 03 ,"Seat");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (20 , 04 ,"Toyota");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (21 , 04 ,"Lexus");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (22 , 04 ,"Mazda");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (23 , 05 ,"Alfa Romeo");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (24 , 05 ,"Jeep");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (25 , 05 ,"Maserati");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (26 , 05 ,"Ferrari");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (27 , 06 ,"Chevrolet");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (28 , 06 ,"Ferrari");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (29 , 06 ,"Buick");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (30 , 06 ,"Cadillac");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (31 , 07 ,"BMW");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (32 , 07 ,"MINI");
insert into car_brand(id_car_brand , id_company_group, brand_name) values (33 , 07 ,"Rolls-Royce");

insert into car_model(id_car, active_date , id_model, id_car_brand , car_model_name) values (01 , 2015-02-01 , 01 , 01 , "Peugeot 308");
insert into car_model(id_car, active_date , id_model, id_car_brand , car_model_name) values (02 , 2018-03-11 , 02 , 01 , "Peugeot E 208");
insert into car_model(id_car, active_date , id_model, id_car_brand , car_model_name) values (03 , 2017-02-10 , 03 , 02 , "Corsa");
insert into car_model(id_car, active_date , id_model, id_car_brand , car_model_name) values (04 , 2017-06-01 , 04 , 02 , "Neuer Astra");
insert into car_model(id_car, active_date , id_model, id_car_brand , car_model_name) values (05 , 2017-09-01 , 05 , 19 , "Ateca");
insert into car_model(id_car, active_date , id_model, id_car_brand , car_model_name) values (06 , 2018-11-01 , 06 , 31 , "X3");
insert into car_model(id_car, active_date , id_model, id_car_brand , car_model_name) values (07 , 2019-04-10 , 07 , 31 , "503");
insert into car_model(id_car, active_date , id_model, id_car_brand , car_model_name) values (08 , 2019-02-01 , 08 , 28 , "GTB");
insert into car_model(id_car, active_date , id_model, id_car_brand , car_model_name) values (09 , 2019-03-30 , 09 , 32 , "COOPER");
insert into car_model(id_car, active_date , id_model, id_car_brand , car_model_name) values (10 , 2019-12-20 , 10 , 31 , "SPYDER");
insert into car_model(id_car, active_date , id_model, id_car_brand , car_model_name) values (11 , 2020-11-11 , 11 , 06 , "Peugeot 3008");
insert into car_model(id_car, active_date , id_model, id_car_brand , car_model_name) values (12 , 2020-02-01 , 12 , 06 , "Captur");
insert into car_model(id_car, active_date , id_model, id_car_brand , car_model_name) values (13 , 2021-03-01 , 13 , 24 , "Cherokee");
insert into car_model(id_car, active_date , id_model, id_car_brand , car_model_name) values (14 , 2021-12-01 , 14 , 33 , "Down");
insert into car_model(id_car, active_date , id_model, id_car_brand , car_model_name) values (15 , 2022-02-01 , 15 , 33 , "GHOST");

insert into insurance_company(id_insurance_company, policy_number , insurance_company_name) values (01 , 33157201 , "Allianz");
insert into insurance_company(id_insurance_company, policy_number , insurance_company_name) values (02 , 66674454 , "Linea Directa");
insert into insurance_company(id_insurance_company, policy_number , insurance_company_name) values (03 , 45325563 , "AXA");
insert into insurance_company(id_insurance_company, policy_number , insurance_company_name) values (04 , 08645563 , "Mapfre");
insert into insurance_company(id_insurance_company, policy_number , insurance_company_name) values (05 , 67356678 , "Qualitas");
insert into insurance_company(id_insurance_company, policy_number , insurance_company_name) values (06 , 00673676 , "Albadis");
insert into insurance_company(id_insurance_company, policy_number , insurance_company_name) values (07 , 01237433 , "Zurich");
insert into insurance_company(id_insurance_company, policy_number , insurance_company_name) values (08 , 00974454 , "Genesis");
insert into insurance_company(id_insurance_company, policy_number , insurance_company_name) values (09 , 01014454 , "Verti");
insert into insurance_company(id_insurance_company, policy_number , insurance_company_name) values (02 , 63454454 , "Linea Directa");
insert into insurance_company(id_insurance_company, policy_number , insurance_company_name) values (03 , 64355566 , "AXA");
insert into insurance_company(id_insurance_company, policy_number , insurance_company_name) values (04 , 87567840 , "Mapfre");
insert into insurance_company(id_insurance_company, policy_number , insurance_company_name) values (05 , 74336775 , "Qualitas");
insert into insurance_company(id_insurance_company, policy_number , insurance_company_name) values (06 , 96547887 , "Albadis");
insert into insurance_company(id_insurance_company, policy_number , insurance_company_name) values (07 , 64366776 , "Zurich");

insert into currency(id_currency , currency_name) values (01 , "Euro");
insert into currency(id_currency , currency_name) values (02 , "Dollar");
insert into currency(id_currency , currency_name) values (03 , "Yen");
insert into currency(id_currency , currency_name) values (04 , "Yuan");

insert into color(id_color , color_name) values (01 , "BlancoHueso");
insert into color(id_color , color_name) values (02 , "NegroMetalizado");
insert into color(id_color , color_name) values (03 , "NegroMate");
insert into color(id_color , color_name) values (04 , "GrisClaro");
insert into color(id_color , color_name) values (05 , "GrisOscuro");
insert into color(id_color , color_name) values (06 , "AzulOscuro");
insert into color(id_color , color_name) values (07 , "AzulEléctrico");
insert into color(id_color , color_name) values (08 , "AzulClaro");
insert into color(id_color , color_name) values (09 , "VerdeOscuro");
insert into color(id_color , color_name) values (10 , "VerdeEléctrico");
insert into color(id_color , color_name) values (11 , "VerdeClaro");
insert into color(id_color , color_name) values (12 , "AmarilloOscuro");
insert into color(id_color , color_name) values (13 , "NaranjaEléctrico");
insert into color(id_color , color_name) values (14 , "AmarilloClaro");
insert into color(id_color , color_name) values (15 , "RojoFuego");
insert into color(id_color , color_name) values (16 , "Rosa");
insert into color(id_color , color_name) values (17 , "RojoClaro");

insert into car_reviews(id_car , active_date, id_review , review_date , review_price , id_currency) values (01 , 2015-02-01 ,01 ,2016-03-01 , 250 , 01 );
insert into car_reviews(id_car , active_date, id_review , review_date , review_price , id_currency) values (01 , 2015-02-01 ,01 ,2017-02-01 , 550 , 01 );
insert into car_reviews(id_car , active_date, id_review , review_date , review_price , id_currency) values (02 , 2018-03-11 ,01 ,2019-06-01 , 350 , 02 );
insert into car_reviews(id_car , active_date, id_review , review_date , review_price , id_currency) values (02 , 2018-03-11 ,01 ,2020-05-01 , 150 , 02 );
insert into car_reviews(id_car , active_date, id_review , review_date , review_price , id_currency) values (03 , 2017-02-10 ,01 ,2016-03-11 , 250 , 01 );
insert into car_reviews(id_car , active_date, id_review , review_date , review_price , id_currency) values (03 , 2017-02-10 ,01 ,2017-04-01 , 150 , 01 );

insert into active_cars(id_car , active_date, active_name , id_model , id_color , plate , id_insurance_company , policy_number , total_kms , purchase_date ) values (01 , 2015-02-01 ,"CEO01" ,01 , 10 , 3546FKJ , 01 ,33157201 , 1000000 , 2016-04-01 );
insert into active_cars(id_car , active_date, active_name , id_model , id_color , plate , id_insurance_company , policy_number , total_kms , purchase_date ) values (02 , 2018-03-11 ,"CEO02" ,02 , 10 , 2346GLJ , 02 ,66674454 , 200000 , 2017-04-01 );
insert into active_cars(id_car , active_date, active_name , id_model , id_color , plate , id_insurance_company , policy_number , total_kms , purchase_date ) values (03 , 2017-02-10 ,"CEO03" ,03 , 10 , 6446GMJ , 03 ,45325563 , 3400000 , 2016-04-01 );
insert into active_cars(id_car , active_date, active_name , id_model , id_color , plate , id_insurance_company , policy_number , total_kms , purchase_date ) values (04 , 2017-06-01 ,"Comercial1" ,04 , 10 , 4540GNJ , 04 ,08645563 , 7000 , 2016-04-01 );
insert into active_cars(id_car , active_date, active_name , id_model , id_color , plate , id_insurance_company , policy_number , total_kms , purchase_date ) values (05 , 2017-09-01 ,"Comercial2" ,05 , 10 , 0246GPJ , 05 ,67356678 , 1067000 , 2016-09-01 );
insert into active_cars(id_car , active_date, active_name , id_model , id_color , plate , id_insurance_company , policy_number , total_kms , purchase_date ) values (06 , 2018-11-01 ,"Comercial3" ,06 , 10 , 0516GQJ , 06 ,00673676 , 1000000 , 2017-02-01 );
insert into active_cars(id_car , active_date, active_name , id_model , id_color , plate , id_insurance_company , policy_number , total_kms , purchase_date ) values (07 , 2019-04-10 ,"Profesor1" ,07 , 10 , 3746GSJ , 07 , 01237433, 60000 , 2016-04-01 );
insert into active_cars(id_car , active_date, active_name , id_model , id_color , plate , id_insurance_company , policy_number , total_kms , purchase_date ) values (08 , 2019-02-01 ,"Profesor2" ,08 , 10 , 3546GSM , 08 ,00974454 , 1000500 , 2016-04-01 );
insert into active_cars(id_car , active_date, active_name , id_model , id_color , plate , id_insurance_company , policy_number , total_kms , purchase_date ) values (09 , 2019-03-30 ,"Profesor3" ,09 , 10 , 3346GTB , 09 ,01014454 , 50000 , 2016-04-01 );
insert into active_cars(id_car , active_date, active_name , id_model , id_color , plate , id_insurance_company , policy_number , total_kms , purchase_date ) values (10 , 2019-12-20 ,"Profesor4" ,10 , 10 , 3546HBJ , 02 ,63454454 , 300600 , 2016-04-01 );
insert into active_cars(id_car , active_date, active_name , id_model , id_color , plate , id_insurance_company , policy_number , total_kms , purchase_date ) values (11 , 2020-11-11 ,"Profesor5" ,11 , 10 , 3526HBJ , 03 , 64355566 , 1060000 , 2016-04-01 );
insert into active_cars(id_car , active_date, active_name , id_model , id_color , plate , id_insurance_company , policy_number , total_kms , purchase_date ) values (12 , 2020-02-01 ,"Profesor6" ,12 , 10 , 3546HKJ , 04 , 87567840, 130000 , 2016-04-01 );
insert into active_cars(id_car , active_date, active_name , id_model , id_color , plate , id_insurance_company , policy_number , total_kms , purchase_date ) values (13 , 2021-03-01 ,"Profesor7" ,13 , 10 , 3546HKJ , 05 ,74336775 , 4005600 , 2016-04-01 );
insert into active_cars(id_car , active_date, active_name , id_model , id_color , plate , id_insurance_company , policy_number , total_kms , purchase_date ) values (14 , 2021-12-01 ,"CEO04" ,01 , 14 , 2346KKJ , 06 , 96547887, 300430 , 2016-04-01 );
insert into active_cars(id_car , active_date, active_name , id_model , id_color , plate , id_insurance_company , policy_number , total_kms , purchase_date ) values (15 , 2021-12-01 ,"CEO05" ,01 , 15 , 3536LKJ , 07 , 64366776, 200400 , 2016-04-01 );


