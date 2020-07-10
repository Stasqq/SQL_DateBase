CREATE INDEX ind_car_price ON car (price);
CREATE INDEX ind_car_vin ON car (vin);
CREATE INDEX ind_person_address ON person (address);
CREATE INDEX ind_transaction_date ON transaction (transaction_date);
CREATE INDEX ind_dealer_transaction ON transaction (id_dealer);
CREATE INDEX ind_car_owner_vin ON car (owner_pesel,vin);
CREATE INDEX ind_seller_dealer_transaction ON transaction (seller_pesel,id_dealer);
CREATE INDEX ind_car_price_hp_year ON car (price,hp,production_year);
CREATE INDEX ind_mod_price ON modification (price);
CREATE INDEX ind_reservation_pesel ON reservation (person_pesel);

drop index ind_car_price_hp;
drop index ind_car_price;
drop INDEX ind_car_vin;
drop index ind_person_address;
drop index ind_transaction_date;
drop INDEX ind_dealer_transaction;
drop INDEX ind_car_owner_vin;


-- przyklad index range scan dla pojedynczego indexu
explain plan for
select *
from car
where price > 199500;
select *
from table (dbms_xplan.display);
-----------------------------------------------------------------------------------------------------
--| Id  | Operation                           | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT                    |               |     4 |   452 |     6   (0)| 00:00:01 |
--|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| CAR           |     4 |   452 |     6   (0)| 00:00:01 |
--|*  2 |   INDEX RANGE SCAN                  | IND_CAR_PRICE |     4 |       |     2   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------------------

-- przyklad index range scan dla pojedynczego indexu
explain plan for
select *
from car
where vin = '7OZ5JZ5O07V4SUMKD';
select *
from table (dbms_xplan.display);
-----------------------------------------------------------------------------------------------------
--| Id  | Operation                           | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT                    |             |     1 |   113 |     2   (0)| 00:00:01 |
--|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| CAR         |     1 |   113 |     2   (0)| 00:00:01 |
--|*  2 |   INDEX RANGE SCAN                  | IND_CAR_VIN |     1 |       |     1   (0)| 00:00:01 |
-----------------------------------------------------------------------------------------------------

-- przyklad index unique scan, czyli wyszukanie po domyslnie utworzonym indeksie ktory jest przypisany do klucza glownego
explain plan for
select *
from person
where pesel = '57605188046';
select *
from table (dbms_xplan.display);
-------------------------------------------------------------------------------------------
--| Id  | Operation                   | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT            |           |     1 |    77 |     1   (0)| 00:00:01 |
--|   1 |  TABLE ACCESS BY INDEX ROWID| PERSON    |     1 |    77 |     1   (0)| 00:00:01 |
--|*  2 |   INDEX UNIQUE SCAN         | PERSON_PK |     1 |       |     1   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------

-- przyklad index full fast scan dla podwojnego indexu
explain plan for
select seller_pesel, id_dealer 
from transaction
where seller_pesel + id_dealer > 99500000000 ;
select *
from table (dbms_xplan.display);
--------------------------------------------------------------------------------------------------------
--| Id  | Operation            | Name                          | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT     |                               |     5 |   130 |     4   (0)| 00:00:01 |
--|*  1 |  INDEX FAST FULL SCAN| IND_SELLER_DEALER_TRANSACTION |     5 |   130 |     4   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

-- przyklad merge join cartesian uzyskany za pomoca indexow(bez hintow)
explain plan for
select transaction.id_car, car.owner_pesel
from transaction, car
where  transaction.id_transaction < 20 and transaction.price < 195000 and car.owner_pesel > 99000000000 ;
select *
from table (dbms_xplan.display);
------------------------------------------------------------------------------------------------------------
--| Id  | Operation                            | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT                     |                   |   285 | 14820 |    23   (0)| 00:00:01 |
--|   1 |  MERGE JOIN CARTESIAN                |                   |   285 | 14820 |    23   (0)| 00:00:01 |
--|*  2 |   TABLE ACCESS BY INDEX ROWID BATCHED| TRANSACTION       |    19 |   741 |     4   (0)| 00:00:01 |
--|*  3 |    INDEX RANGE SCAN                  | TRANSACTION_PK    |    19 |       |     2   (0)| 00:00:01 |
--|   4 |   BUFFER SORT                        |                   |    15 |   195 |    19   (0)| 00:00:01 |
--|*  5 |    INDEX RANGE SCAN                  | IND_CAR_OWNER_VIN |    15 |   195 |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------------

-- przyklad uzycia nested loop na podstawie merge join
explain plan for
select /*+ USE_NL(transaction, car) */ transaction.id_car, car.owner_pesel
from transaction, car
where  transaction.id_transaction < 20 and transaction.price < 195000 and car.owner_pesel > 99000000000 ;
select *
from table (dbms_xplan.display);
------------------------------------------------------------------------------------------------------------
--| Id  | Operation                            | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT                     |                   |   268 |  5628 |    22   (0)| 00:00:01 |
--|   1 |  NESTED LOOPS                        |                   |   268 |  5628 |    22   (0)| 00:00:01 |
--|*  2 |   TABLE ACCESS BY INDEX ROWID BATCHED| TRANSACTION       |    19 |   247 |     3   (0)| 00:00:01 |
--|*  3 |    INDEX RANGE SCAN                  | TRANSACTION_PK    |    19 |       |     2   (0)| 00:00:01 |
--|*  4 |   INDEX RANGE SCAN                   | IND_CAR_OWNER_VIN |    14 |   112 |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------------

-- hasha sie nie da uzyskac z merg join
explain plan for
select /*+ USE_HASH(transaction, car) */ transaction.id_car, car.owner_pesel
from transaction, car
where  transaction.id_transaction < 20 and transaction.price < 195000 and car.owner_pesel > 99000000000 ;
select *
from table (dbms_xplan.display);

------------------------------------------------------------------------------------------------------------

-- przyklad nested loops przy uzyciu indexow(bez hintow)
explain plan for
select Car.vin, Person.pesel, Person.address
from Car
inner join person on car.owner_pesel = person.pesel
where car.price > 199900 and person.phone_nr > 990000000;
select *
from table (dbms_xplan.display);
---------------------------------------------------------------------------------------------------------
--| Id  | Operation                             | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT                      |               |     1 |    85 |     4   (0)| 00:00:01 |
--|   1 |  NESTED LOOPS                         |               |     1 |    85 |     4   (0)| 00:00:01 |
--|   2 |   NESTED LOOPS                        |               |     1 |    85 |     4   (0)| 00:00:01 |
--|   3 |    TABLE ACCESS BY INDEX ROWID BATCHED| CAR           |     1 |    31 |     3   (0)| 00:00:01 |
--|*  4 |     INDEX RANGE SCAN                  | IND_CAR_PRICE |     1 |       |     2   (0)| 00:00:01 |
--|*  5 |    INDEX UNIQUE SCAN                  | PERSON_PK     |     1 |       |     0   (0)| 00:00:01 |
--|*  6 |   TABLE ACCESS BY INDEX ROWID         | PERSON        |     1 |    54 |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------------------

-- przyklad uzyciahash join na podstawie nested loops
explain plan for
select /*+ use_hash(car,person)*/ Car.vin, Person.pesel, Person.address
from Car
inner join person on car.owner_pesel = person.pesel
where car.price > 199900 and person.phone_nr > 990000000;
select *
from table (dbms_xplan.display);
--------------------------------------------------------------------------------------------------------
--| Id  | Operation                            | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT                     |               |     1 |    85 |     6   (0)| 00:00:01 |
--|*  1 |  HASH JOIN                           |               |     1 |    85 |     6   (0)| 00:00:01 |
--|   2 |   TABLE ACCESS BY INDEX ROWID BATCHED| CAR           |     1 |    31 |     3   (0)| 00:00:01 |
--|*  3 |    INDEX RANGE SCAN                  | IND_CAR_PRICE |     1 |       |     2   (0)| 00:00:01 |
--|*  4 |   TABLE ACCESS FULL                  | PERSON        |     1 |    54 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------------------

-- przyklad uzycia merge join na podtsawie nested loops
explain plan for
select /*+ use_merge(car,person)*/ Car.vin, Person.pesel, Person.address
from Car
inner join person on car.owner_pesel = person.pesel
where car.price > 199900 and person.phone_nr > 990000000;
select *
from table (dbms_xplan.display);
---------------------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT                      |               |     1 |    85 |     8  (25)| 00:00:01 |
--|   1 |  MERGE JOIN                           |               |     1 |    85 |     8  (25)| 00:00:01 |
--|   2 |   SORT JOIN                           |               |     1 |    31 |     4  (25)| 00:00:01 |
--|   3 |    TABLE ACCESS BY INDEX ROWID BATCHED| CAR           |     1 |    31 |     3   (0)| 00:00:01 |
--|*  4 |     INDEX RANGE SCAN                  | IND_CAR_PRICE |     1 |       |     2   (0)| 00:00:01 |
--|*  5 |   SORT JOIN                           |               |     1 |    54 |     4  (25)| 00:00:01 |
--|*  6 |    TABLE ACCESS FULL                  | PERSON        |     1 |    54 |     3   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------------------

-- przyklad hash join przy uzyciu indexow(bez hintow)
explain plan for
select Car.vin, transaction.id_transaction
from Car,transaction
where transaction.id_transaction < 100 and car.owner_pesel = transaction.seller_pesel;
select *
from table (dbms_xplan.display);
------------------------------------------------------------------------------------------------------------
--| Id  | Operation                            | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT                     |                   |  1187 | 43919 |    10   (0)| 00:00:01 |
--|*  1 |  HASH JOIN                           |                   |  1187 | 43919 |    10   (0)| 00:00:01 |
--|*  2 |   TABLE ACCESS BY INDEX ROWID BATCHED| TRANSACTION       |    79 |   869 |     3   (0)| 00:00:01 |
--|*  3 |    INDEX RANGE SCAN                  | TRANSACTION_PK    |    99 |       |     2   (0)| 00:00:01 |
--|   4 |   INDEX FAST FULL SCAN               | IND_CAR_OWNER_VIN |  3000 | 78000 |     7   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------------

-- przyklad uzycia merge join na podstawie hash join
explain plan for
select /*+ use_merge(car,transaction) */ Car.vin, transaction.id_transaction
from Car,transaction
where transaction.id_transaction < 100 and car.owner_pesel = transaction.seller_pesel;
select *
from table (dbms_xplan.display);
-------------------------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT                      |                   |  1187 | 43919 |    12  (17)| 00:00:01 |
--|   1 |  MERGE JOIN                           |                   |  1187 | 43919 |    12  (17)| 00:00:01 |
--|   2 |   SORT JOIN                           |                   |    79 |   869 |     4  (25)| 00:00:01 |
--|*  3 |    TABLE ACCESS BY INDEX ROWID BATCHED| TRANSACTION       |    79 |   869 |     3   (0)| 00:00:01 |
--|*  4 |     INDEX RANGE SCAN                  | TRANSACTION_PK    |    99 |       |     2   (0)| 00:00:01 |
--|*  5 |   SORT JOIN                           |                   |  3000 | 78000 |     8  (13)| 00:00:01 |
--|   6 |    INDEX FAST FULL SCAN               | IND_CAR_OWNER_VIN |  3000 | 78000 |     7   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------------------------

-- przyklad uzycia nested loops na podstawie hash join
explain plan for
select /*+ use_nl(car,transaction) */ Car.vin, transaction.id_transaction
from Car,transaction
where transaction.id_transaction < 100 and car.owner_pesel = transaction.seller_pesel;
select *
from table (dbms_xplan.display);
------------------------------------------------------------------------------------------------------------
--| Id  | Operation                            | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT                     |                   |  1187 | 43919 |    82   (0)| 00:00:01 |
--|   1 |  NESTED LOOPS                        |                   |  1187 | 43919 |    82   (0)| 00:00:01 |
--|*  2 |   TABLE ACCESS BY INDEX ROWID BATCHED| TRANSACTION       |    79 |   869 |     3   (0)| 00:00:01 |
--|*  3 |    INDEX RANGE SCAN                  | TRANSACTION_PK    |    99 |       |     2   (0)| 00:00:01 |
--|*  4 |   INDEX RANGE SCAN                   | IND_CAR_OWNER_VIN |    15 |   390 |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------------