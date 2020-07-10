------------------------------------------------------
-- funkcje sluzace do sprawdzania unikalnosci danego parametru w tablicy
-- funkcje zwracaja wartosc boolean
-- false jesli sprawdzana wartosc znajduje sie juz w tablicy

CREATE OR REPLACE Function valid_phone_nr
(nr_to_check number)
    RETURN boolean
IS
    counter_person number(1);
    counter_dealership number(1);
BEGIN
    select count(*) into counter_person from Person where phone_nr = nr_to_check;
    select count(*) into counter_dealership from Car_dealership where phone_nr = nr_to_check;
    if(counter_person = 0 and counter_dealership = 0) then
    return true;
    else
    return false;
    end if;
END;
/

CREATE OR REPLACE Function valid_car
(car_to_check number)
    RETURN boolean
IS
output number(1,0);
BEGIN
    select valid into output from car where id_car = car_to_check;
    if(output = 1) then
    return true;
    else
    return false;
    end if;
END;
/

CREATE OR REPLACE Function valid_pesel
(pesel_to_check number)
    RETURN boolean
IS
    counter number(1);
BEGIN
    select count(*) into counter from Person where pesel = pesel_to_check;
    if(counter= 0) then
    return true;
    else
    return false;
    end if;
END;
/

CREATE OR REPLACE Function valid_address
(address_to_check varchar2)
    RETURN boolean
IS
    counter number(1);
BEGIN
    select count(*) into counter from car_dealership where address = address_to_check;
    if(counter= 0) then
    return true;
    else
    return false;
    end if;
END;
/

CREATE OR REPLACE Function valid_email
(email_to_check varchar2)
    RETURN boolean
IS
    counter number(1);
BEGIN
    select count(*) into counter from car_dealership where email = email_to_check;
    if(counter= 0) then
    return true;
    else
    return false;
    end if;
END;
/

CREATE OR REPLACE Function valid_vin
(vin_to_check varchar2)
    RETURN boolean
IS
    counter number(1);
BEGIN
    select count(*) into counter from car where vin = vin_to_check;
    if(counter= 0) then
    return true;
    else
    return false;
    end if;
END;
/
------------------------------------------------------
-- funkcje sluzace do uzyskiwania kolejnych wartosci id
-- funkcje zwracaja unikalna w danej tablicy wartosc integer

CREATE OR REPLACE Function next_dealership_id
   RETURN number
IS
   last_id integer;
BEGIN
    SELECT COALESCE(MAX(id_dealer), 0)into last_id FROM car_dealership;
RETURN last_id +1;
END;
/

CREATE OR REPLACE Function next_car_id
   RETURN number
IS
   last_id integer;
BEGIN
    SELECT COALESCE(MAX(id_car), 0)into last_id FROM car;
RETURN last_id +1;
END;
/

CREATE OR REPLACE Function next_mod_id
   RETURN number
IS
   last_id integer;
BEGIN
    SELECT COALESCE(MAX(id_mod), 0)into last_id FROM Modification;
RETURN last_id +1;
END;
/

CREATE OR REPLACE Function next_repair_id
   RETURN number
IS
   last_id integer;
BEGIN
    SELECT COALESCE(MAX(id_repair), 0)into last_id FROM Repair;
RETURN last_id +1;
END;
/

CREATE OR REPLACE Function next_reservation_id
   RETURN number
IS
   last_id integer;
BEGIN
    SELECT COALESCE(MAX(id_reservation), 0)into last_id FROM Reservation;
RETURN last_id +1;
END;
/

CREATE OR REPLACE Function next_transaction_id
   RETURN number
IS
   last_id integer;
BEGIN
    SELECT COALESCE(MAX(id_transaction), 0)into last_id FROM Transaction;
RETURN last_id +1;
END;
/

------------------------------------------------------
-- funkcje sluzace do wydobycia danych z z jakiejs tablicy
-- czesc funkcji zwraca losowa wartosc znajdujaca sie w tablicy
-- czesc funkcji zwraca wartosc szukanego pola znajdujacego sie w krotce ktore klucz glowny podano jako argument wywolania

CREATE OR REPLACE Function get_random_pesel
   RETURN number
IS
   pesel_nr integer;
BEGIN
    SELECT pesel INTO pesel_nr FROM (SELECT pesel FROM person ORDER BY dbms_random.value) where rownum=1;
RETURN pesel_nr;
END;
/

CREATE OR REPLACE Function get_random_car_id
   RETURN number
IS
   car_out integer;
BEGIN
    SELECT id_car INTO car_out FROM (SELECT id_car FROM car ORDER BY dbms_random.value) where rownum=1;
RETURN car_out;
END;
/

CREATE OR REPLACE Function get_random_dealership_id
   RETURN number
IS
   dealership_out integer;
BEGIN
    SELECT id_dealer INTO dealership_out FROM (SELECT id_dealer FROM car_dealership ORDER BY dbms_random.value) where rownum=1;
RETURN dealership_out;
END;
/

CREATE OR REPLACE Function get_random_date
   RETURN date
IS
    random_date date;
BEGIN
    SELECT TO_DATE(
              TRUNC(
                   DBMS_RANDOM.VALUE(TO_CHAR(DATE '2020-01-01','J')
                                    ,TO_CHAR(DATE '2020-12-31','J')
                                    )
                    ),'J'
               )into random_date FROM DUAL;
RETURN random_date;
END;
/

CREATE OR REPLACE Function get_car_price
(car_to_look integer)
   RETURN integer
IS
    price_out integer;
BEGIN
    SELECT price INTO price_out FROM car WHERE id_car = car_to_look;
RETURN price_out;
END;
/

CREATE OR REPLACE Function get_car_dealership
(car_to_look integer)
   RETURN integer
IS
    dealership_out integer;
BEGIN
    SELECT id_dealer INTO dealership_out FROM car WHERE id_car = car_to_look;
RETURN dealership_out;
END;
/