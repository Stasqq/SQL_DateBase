-- stworzenie dwoch lancuchow do generowania danych
create TYPE TABSTR IS TABLE OF VARCHAR2(250);
------------------------------------------------------

-- generowanie danych do tablicy car_brand
create or replace procedure generate_car_brand
is
car_brands TABSTR := TABSTR('Audi','Volkswagen','Renault','Mercedes','Skoda','Fiat','Ford','Honda','Nissan','Suzuki','Toyota');
begin
FOR i IN 1..car_brands.count LOOP
        INSERT INTO Car_brand (Brand_name) VALUES (car_brands(i));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('Tabela Car_brand zostala uzupelniona, wygenerowanych wierszy ' || car_brands.count);
end;
------------------------------------------------------

-- generowanie danych do tablicy car_model
create or replace procedure generate_car_model
is
car_models TABSTR := TABSTR('A3','A4','A6','A8','Passat','Golf','Polo','Clio','Megane','Talisman',
                    'Kangoo','A Class','C Class','E Class','S Class','G Class','Octavia','Fabia','Superb','Rapid',
                    'Punto','Panda','Tipo','Croma','Fiesta','Mondeo','Mustang','C-Max','Civic','Accord',
                    'C-RV','City','X-trail','GT-R','Navara','Jimny','Swift','GT 86','Corolla','Avensis');
car_brands TABSTR := TABSTR('Audi','Audi','Audi','Audi','Volkswagen','Volkswagen','Volkswagen','Renault','Renault','Renault',
                    'Renault','Mercedes','Mercedes','Mercedes','Mercedes','Mercedes','Skoda','Skoda','Skoda','Skoda',
                    'Fiat','Fiat','Fiat','Fiat','Ford','Ford','Ford','Ford','Honda','Honda',
                    'Honda','Honda','Nissan','Nissan','Nissan','Suzuki','Suzuki','Toyota','Toyota','Toyota');
begin
FOR i IN 1..car_models.count LOOP
        INSERT INTO Car_model (Model_name,Brand) VALUES (car_models(i),car_brands(i));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('Tabela Car_model zostala uzupelniona, wygenerowanych wierszy ' || car_models.count);
end;
------------------------------------------------------

-- generowanie danych do tablicy person
create or replace procedure generate_person
(persons_number IN integer)
is
first_names TABSTR := TABSTR('Lolita','Jenniffer','Ilona','Graig','Clorinda','Donna','Willene','Vinnie','Vivienne','Daphine',
                        'Kai','Ashley','Kelle','Curtis','Fritz','Cammie','Lita','Lilli','Buford','Dana',
                        'Merilyn','Shane','Mohamed','Beula','Savannah','Jimmy','Zola','Malisa','Winfred','Duane');
second_names TABSTR := TABSTR('Mcbride','Cuevas','West','Hopkins','Zamora','Klein','Ho','Montes','Parsons','Jensen',
                        'Fernandez','Howell','Owens','Stevenson','Adkins','Mueller','Alexander','Dalton','Trevino','Hanna',
                        'Kent','Riggs','Nolan','Ryan','Townsend','Palmer','Ellison','Hamilton','Bond','Shah');
addresses TABSTR := TABSTR('677 Roehampton Dr. Mankato, MN 56001','8995 E. Tailwater Road Phillipsburg, NJ 08865','43 Arnold Rd. Romulus, MI 48174',
        '984 Plymouth Rd. Faribault, MN 55021','9 Spruce Drive District Heights, MD 20747','7271 Third St. Boynton Beach, FL 33435','9597 Andover Street New Kensington, PA 15068',
        '31 Branch Ave. Lindenhurst, NY 11757','8612 Lake Forest Avenue Powhatan, VA 23139','193 Holly Lane Hoboken, NJ 07030','990 Spring Ave. Greensboro, NC 27405',
        '393 Rock Maple Ave. Powell, TN 37849','8388 Albany Dr. Downingtown, PA 19335','15 Amerige LaneChesapeake, VA 23320','709 West Lane Victoria, TX 77904',
        '63 Edgemont Street Gibsonia, PA 15044','7 Henry St. San Jose, CA 95127','996 Willow Drive Westmont, IL 60559','49 Big Rock Cove St. Amsterdam, NY 12010',
        '500 Fairfield Street Wyandotte, MI 48192','223 Union Drive Henrico, VA 23228','98 Shirley Street Lincolnton, NC 28092','66 Pulaski Street Owensboro, KY 42301',
        '516 Smith Avenue Laurel, MD 20707','688 Brown Street Downers Grove, IL 60515','9805 West Whitemarsh Lane Washington, PA 15301','17 Sierra St. West Babylon, NY 11704',
        '508 Rock Maple Ave. De Pere, WI 54115','440 NW. Magnolia Street Owosso, MI 48867','502 E. Elm Road Pasadena, MD 21122');
phone_number number(9);
pesel_nr number(11);
first_name_index number(2);
second_name_index number(2);
address_index number(2);
begin
FOR i IN 1..persons_number LOOP
        first_name_index := dbms_random.value(1,first_names.count);
        second_name_index := dbms_random.value(1,second_names.count);
        address_index := dbms_random.value(1,addresses.count);
        phone_number := dbms_random.value(100000000,999999999);
        while(valid_phone_nr(phone_number)=false)
        loop
        phone_number := dbms_random.value(100000000,999999999);
        end loop;
        pesel_nr := dbms_random.value(10000000000,99999999999);
        while(valid_pesel(pesel_nr)=false)
        loop
        pesel_nr := dbms_random.value(10000000000,99999999999);
        end loop;
        INSERT INTO Person (first_name,second_name,address,pesel,phone_nr) VALUES (first_names(first_name_index)
        ,second_names(second_name_index),addresses(address_index),pesel_nr,phone_number);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('Tabela Person zostala uzupelniona, wygenerowanych wierszy ' || persons_number);
end;
------------------------------------------------------

-- generowanie danych do tablicy car_dealership
create or replace procedure generate_car_dealership
(dealership_number IN integer)
is
addresses TABSTR := TABSTR('677 Roehampton Dr. Mankato, MN 56001','8995 E. Tailwater Road Phillipsburg, NJ 08865','43 Arnold Rd. Romulus, MI 48174',
        '984 Plymouth Rd. Faribault, MN 55021','9 Spruce Drive District Heights, MD 20747','7271 Third St. Boynton Beach, FL 33435','9597 Andover Street New Kensington, PA 15068',
        '31 Branch Ave. Lindenhurst, NY 11757','8612 Lake Forest Avenue Powhatan, VA 23139','193 Holly Lane Hoboken, NJ 07030','990 Spring Ave. Greensboro, NC 27405',
        '393 Rock Maple Ave. Powell, TN 37849','8388 Albany Dr. Downingtown, PA 19335','15 Amerige LaneChesapeake, VA 23320','709 West Lane Victoria, TX 77904',
        '63 Edgemont Street Gibsonia, PA 15044','7 Henry St. San Jose, CA 95127','996 Willow Drive Westmont, IL 60559','49 Big Rock Cove St. Amsterdam, NY 12010',
        '500 Fairfield Street Wyandotte, MI 48192','223 Union Drive Henrico, VA 23228','98 Shirley Street Lincolnton, NC 28092','66 Pulaski Street Owensboro, KY 42301',
        '516 Smith Avenue Laurel, MD 20707','688 Brown Street Downers Grove, IL 60515','9805 West Whitemarsh Lane Washington, PA 15301','17 Sierra St. West Babylon, NY 11704',
        '508 Rock Maple Ave. De Pere, WI 54115','440 NW. Magnolia Street Owosso, MI 48867','502 E. Elm Road Pasadena, MD 21122');
emails TABSTR := TABSTR('sellthecar','bestdealership','yournewcar','ecocars','motorsinc','autoworld','ustruck','worldcars','prestigeauto','allstarcars',
        'carsandmore','americacars','mustangdealership','autoauction','europeanmotors','elitiron','banddsales','newbutold','cheapcar4you','fastandcheap'
        );
sites TABSTR := TABSTR('@gmail.com','@zoho.com','@outlook.com','@yahoo.com','@icloud.com','@mail.com','@epost.com');
address_index number(2);
email_index number(2);
site_index number(1);
pesel_nr number(11);
phone_number number(9);
dealership_id integer;
email_out varchar2(50);
begin
FOR i IN 1..dealership_number LOOP
        address_index := dbms_random.value(1,addresses.count);
        while(valid_address(addresses(address_index))=false)
        loop
        address_index := dbms_random.value(1,addresses.count);
        end loop;
        phone_number := dbms_random.value(100000000,999999999);
        while(valid_phone_nr(phone_number)=false)
        loop
        phone_number := dbms_random.value(100000000,999999999);
        end loop;
        pesel_nr := get_random_pesel();
        email_index := dbms_random.value(1,emails.count);
        site_index := dbms_random.value(1,sites.count);
        while(valid_email(emails(email_index) || sites(site_index)) = false)
        loop
        email_index := dbms_random.value(1,emails.count);
        site_index := dbms_random.value(1,sites.count);
        end loop;
        dealership_id := next_dealership_id();
        email_out := emails(email_index) || sites(site_index);
        INSERT INTO car_dealership (id_dealer,address,email,owner_pesel,phone_nr,car_number,budget) VALUES (dealership_id,
        addresses(address_index),email_out,pesel_nr,phone_number,0,dbms_random.value(100000,500000));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('Tabela Car_dealership zostala uzupelniona, wygenerowanych wierszy ' || dealership_number);
end;
------------------------------------------------------

-- generowanie danych do tablicy car
create or replace procedure generate_car
(cars_number IN integer)
is
car_models TABSTR := TABSTR('A3','A4','A6','A8','Passat','Golf','Polo','Clio','Megane','Talisman',
                    'Kangoo','A Class','C Class','E Class','S Class','G Class','Octavia','Fabia','Superb','Rapid',
                    'Punto','Panda','Tipo','Croma','Fiesta','Mondeo','Mustang','C-Max','Civic','Accord',
                    'C-RV','City','X-trail','GT-R','Navara','Jimny','Swift','GT 86','Corolla','Avensis');
model_index number(2);
car_id integer;
dealer_id integer;
nr_vin varchar2(17);
owner_p number(11);
begin
FOR i IN 1..cars_number LOOP
        model_index := dbms_random.value(1,car_models.count);
        car_id := next_car_id();
        dealer_id := get_random_dealership_id();
        owner_p := get_random_pesel();
        nr_vin := dbms_random.string('x',17);
        while(valid_vin(nr_vin)=false)
        loop
        nr_vin := dbms_random.string('x',17);
        end loop;
        INSERT INTO Car (id_car,owner_pesel,production_year,hp,vin,price,id_dealer,car_model,valid) VALUES (car_id,owner_p,
        dbms_random.value(1970,2020),dbms_random.value(60,400),nr_vin,dbms_random.value(10000,200000),dealer_id,
        car_models(model_index),1);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('Tabela Car zostala uzupelniona, wygenerowanych wierszy ' || cars_number);
end;
------------------------------------------------------

-- generowanie danych do tablicy modification
create or replace procedure generate_modification
(modifications_number IN integer)
is
mods TABSTR := TABSTR('Turbocharger','Suspension Upgrade','Sport Seats','Nitrous Oxide','Underbody Neon Lights','Suboofer',
                    'Steering Wheel Cover','Video Game Console','Spoiler','Custom Exhoust','Custom Rims','Racing Pedals',
                    'Door Lights','Body Kit','Chip Tuning','Hydraulic Handbrake');
car_id integer;
mod_id integer;
mod_index number(2);
begin
FOR i IN 1..modifications_number LOOP
        mod_id := next_mod_id();
        car_id := get_random_car_id();
        mod_index := dbms_random.value(1,mods.count);
        INSERT INTO Modification (id_mod,mod_type,price,id_car) VALUES (mod_id,mods(mod_index),dbms_random.value(100,4000),car_id);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('Tabela Modification zostala uzupelniona, wygenerowanych wierszy ' || modifications_number);
end;
------------------------------------------------------

-- generowanie danych do tablicy repair
create or replace procedure generate_repair
(repair_number IN integer)
is
repairs TABSTR := TABSTR('New Battery','New Brakes','A/C Renovation','Varnish Corrections','New Tires','New Air Filter',
                    'New Oil','New Oil Filter','New Fuel Filter','New Engine Coolant','Tire Rotation',
                    'New Windshield Wipers','Remove Minor Paint Scratches','Set a Spark Plug Gap','Silence a Squealing Belt');
car_id integer;
repair_id integer;
repair_index number(2);
begin
FOR i IN 1..repair_number LOOP
        repair_id := next_repair_id();
        car_id := get_random_car_id();
        repair_index := dbms_random.value(1,repairs.count);
        INSERT INTO Repair (id_repair,repair_type,price,id_car) VALUES (repair_id,repairs(repair_index),
            dbms_random.value(100,4000),car_id);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('Tabela Repair zostala uzupelniona, wygenerowanych wierszy ' || repair_number);
end;
------------------------------------------------------

-- generowanie danych do tablicy reservation
create or replace procedure generate_reservation
(reservation_number IN integer)
is
car_id integer;
reservation_id integer;
pesel_nr number(11);
begin
FOR i IN 1..reservation_number LOOP
        reservation_id := next_reservation_id();
        car_id := get_random_car_id();
        pesel_nr := get_random_pesel();
        INSERT INTO Reservation (id_reservation,id_car,person_pesel) VALUES (reservation_id,car_id,pesel_nr);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('Tabela Reservation zostala uzupelniona, wygenerowanych wierszy ' || reservation_number);
end;
------------------------------------------------------

-- generowanie danych do tablicy transaction
-- podana argument wywolania jest maksymalna iloscia wygenerowanych tranzakcji
-- w przypadku gdy bedziemy trafiac na samochody ktorych oferty nie sa aktualne to tranzakcja nie zostanie utworzona
create or replace procedure generate_transaction
(transaction_number IN integer)
is
b_pesel number(11);
car_id integer;
transaction_id integer;
trans_date date;
counter integer := 0;
begin
FOR i IN 1..transaction_number LOOP
        transaction_id := next_transaction_id();
        b_pesel := get_random_pesel();
        trans_date := get_random_date();
        car_id := get_random_car_id();
        if( valid_car(car_id) = false ) then
            NULL;
        else
        INSERT INTO Transaction (id_transaction,transaction_type,seller_pesel,buyer_pesel,id_dealer,id_car,transaction_date,price) 
        VALUES (transaction_id,'Sell',null,b_pesel,get_car_dealership(car_id),car_id,trans_date,
        get_car_price(car_id));
        counter := counter + 1;
        end if;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('Tabela Transaction zostala uzupelniona, wygenerowanych wierszy ' || counter);
end;
------------------------------------------------------

-- polecenia wykonujace powyzsze procedury generowania danych
exec generate_car_brand;
exec generate_car_model;
exec generate_person(200);
exec generate_car_dealership(20);
exec generate_car(1000);
exec generate_modification(300);
exec generate_repair(400);
exec generate_reservation(150);
exec generate_transaction(500);

-- wyswietlanie wygenerowanych danych
select * from car_brand;
select * from car_model;
select * from person;
select * from car_dealership;
select * from car;
select * from modification;
select * from repair;
select * from reservation;
select * from transaction;

-- czyszczenie tabel
delete from transaction;
delete from reservation;
delete from repair;
delete from modification;
delete from car;
delete from car_dealership;
delete from person;
delete from car_model;
delete from car_brand;