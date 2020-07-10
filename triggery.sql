-- zadaniem triggera jest zmniejszenie bud¿etu komisu samochodowego po wprowadzenieu jakiejs modyfikacji
create or replace trigger dec_budget_after_modification
after insert on Modification
for each row
declare
id_dealer2 integer;
begin
    select id_dealer into id_dealer2 from car where id_car= :new.id_car;
    update car_dealership d set budget=budget - :new.price where d.id_dealer = id_dealer2;
end;

-- zadaniem triggera jest zmniejszenie bud¿etu komisu samochodowego po wprowadzenieu jakiejs naprawy
create or replace trigger dec_budget_after_repair
after insert on Repair
for each row
declare
id_dealer2 integer;
begin
    select id_dealer into id_dealer2 from car where id_car= :new.id_car;
    update car_dealership d set budget=budget - :new.price where d.id_dealer = id_dealer2;
end;

-- zadaniem triggera jest inkrementacja liczby samochodow komisu po tym jak utworzony jest jakis samochod
create or replace trigger inc_dealership_car_number
after insert on Car
for each row
declare
begin
    update car_dealership set car_number=car_number+1 where id_dealer = :new.id_dealer;
end;

-- zadaniem triggera jest aktualizacjia danych komisu po dokonaniu jakiejs tranzakcji
-- modyfikowane pola to w zaleznosci od rodzaju tranakji (budzet) lub (budzet, ilosc aut w komisie,aktualnosc auta)
create or replace trigger update_dealership_after_transaction
after insert on Transaction
for each row
declare
t_type varchar2(10);
begin
    t_type := :new.transaction_type;
    IF(t_type = 'Buy') THEN
        update car_dealership set budget = budget - :new.price where id_dealer = :new.id_dealer;
    ELSE
        update car_dealership set budget = budget + :new.price where id_dealer = :new.id_dealer;
        update car_dealership set car_number = car_number - 1 where id_dealer = :new.id_dealer;
        update car set valid = 0 where id_car = :new.id_car;
    END IF;
end;

-- zadaniem triggera jest wygenerowanie tranzakcji kupna po wstawieniu nowego samochodu
-- poniewaz przyjmuje ze kazdy samochod pojawiajacy sie w bazie danych zostal kiedys zakupiony przez jakis komis
create or replace trigger generate_buy_transaction
after insert on Car
for each row
declare
s_pesel number(11);
transaction_id integer;
trans_date date;
begin
    transaction_id := next_transaction_id();
    s_pesel := get_random_pesel();
    trans_date := get_random_date();

    INSERT INTO Transaction (id_transaction,transaction_type,seller_pesel,buyer_pesel,id_dealer,id_car,transaction_date,price) 
        VALUES (transaction_id,'Buy',s_pesel,null,:new.id_dealer,:new.id_car,trans_date,
        :new.price);
end;