-- foreign keys
ALTER TABLE Car
    DROP CONSTRAINT Car_Car_dealership;

ALTER TABLE Modification
    DROP CONSTRAINT Car_Modification;

ALTER TABLE Car
    DROP CONSTRAINT Car_Person;

ALTER TABLE Repair
    DROP CONSTRAINT Car_Repair;

ALTER TABLE Car_model
    DROP CONSTRAINT Car_brand_Car_model;

ALTER TABLE Car_dealership
    DROP CONSTRAINT Car_dealership_Person;

ALTER TABLE Car
    DROP CONSTRAINT Car_model_Car;

ALTER TABLE Reservation
    DROP CONSTRAINT Reservation_Car;

ALTER TABLE Reservation
    DROP CONSTRAINT Reservation_Person;

ALTER TABLE Transaction
    DROP CONSTRAINT Transaction_Buyer;

ALTER TABLE Transaction
    DROP CONSTRAINT Transaction_Car;

ALTER TABLE Transaction
    DROP CONSTRAINT Transaction_Car_dealership;

ALTER TABLE Transaction
    DROP CONSTRAINT Transaction_Seller;

-- tables
DROP TABLE Car CASCADE CONSTRAINTS;

DROP TABLE Car_brand CASCADE CONSTRAINTS;

DROP TABLE Car_dealership CASCADE CONSTRAINTS;

DROP TABLE Car_model CASCADE CONSTRAINTS;

DROP TABLE Modification CASCADE CONSTRAINTS;

DROP TABLE Person CASCADE CONSTRAINTS;

DROP TABLE Repair CASCADE CONSTRAINTS;

DROP TABLE Reservation CASCADE CONSTRAINTS;

DROP TABLE Transaction CASCADE CONSTRAINTS;

-- End of file.