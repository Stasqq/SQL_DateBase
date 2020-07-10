-- wyswietla model vin i cene aut nalezacych do zadaniej osoby w kojnosci od najnizszej ceny
select car_model,vin,price
from car
where owner_pesel = :pesel
order by price;

-- wyswietla ilosc aut danego modelu samochodu w bazie
select count(car_model) from car where car_model = 'A8';

-- wyswietla model samohcodu i ilosc aktualnych ofert, samochodow z moca powyzej 300km i rokiem produkcji powyzej 2010
select car_model, count(car_model)
from car
where hp > 300 and production_year > 2010 and valid = 1
group by car_model
order by count(car_model) desc;

-- wyswietla srednia cene samochodow z moca powyzej 300km dla kazdego z modeli
select round(avg(price)) as avg_price, car_model
from car
where hp > 300
group by car_model;

-- wyswietla imiona i nazwiska osoby ktora jest wlascicielem jakiegos komisu
select first_name || ' ' || second_name as person_name, phone_nr
from person
where pesel in (select owner_pesel from car_dealership);

-- wyswietla id tranzakcji typu 'Buy' oraz adres sprzedajacego dla osob ktorych pesel zaczyna sie od 99
select id_transaction,sum(seller_pesel) as pesel
from transaction
where transaction_type='Buy'
group by id_transaction
having sum(seller_pesel) >= 99000000000
order by id_transaction;