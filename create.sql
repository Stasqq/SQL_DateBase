-- Table: Car
CREATE TABLE Car (
    Id_car integer GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Owner_PESEL integer  NOT NULL,
    Production_year smallint  NULL,
    Hp smallint  NULL,
    Vin varchar2(17)  NOT NULL,
    Price integer  NOT NULL,
    Id_dealer integer  NOT NULL,
    Car_model varchar2(20)  NOT NULL,
    Valid number(1,0) NOT NULL,
    CONSTRAINT Car_pk PRIMARY KEY (Id_car)
) ;

-- Table: Car_brand
CREATE TABLE Car_brand (
    Brand_name varchar2(20)  NOT NULL,
    CONSTRAINT Car_brand_pk PRIMARY KEY (Brand_name)
) ;

-- Table: Car_dealership
CREATE TABLE Car_dealership (
    Id_dealer integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Address varchar2(50)  NOT NULL,
    Email varchar2(50)  NOT NULL,
    Owner_PESEL integer  NOT NULL,
    Phone_nr integer  NOT NULL,
    Car_number integer  NOT NULL,
    Budget integer NOT NULL,
    CONSTRAINT Car_dealership_pk PRIMARY KEY (Id_dealer)
) ;

-- Table: Car_model
CREATE TABLE Car_model (
    Model_name varchar2(20)  NOT NULL,
    Brand varchar2(20)  NOT NULL,
    CONSTRAINT Car_model_pk PRIMARY KEY (Model_name)
) ;

-- Table: Modification
CREATE TABLE Modification (
    Id_mod integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Mod_type varchar2(50)  NULL,
    Price integer  NOT NULL,
    Id_car integer  NOT NULL,
    CONSTRAINT Modification_pk PRIMARY KEY (Id_mod)
) ;

-- Table: Person
CREATE TABLE Person (
    PESEL number(11)  NOT NULL,
    First_name varchar2(20)  NOT NULL,
    Address varchar2(50)  NOT NULL,
    Second_name varchar2(20)  NOT NULL,
    Phone_nr number(9)  NOT NULL,
    CONSTRAINT Person_pk PRIMARY KEY (PESEL)
) ;

-- Table: Repair
CREATE TABLE Repair (
    Id_repair integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Repair_type varchar2(50)  NULL,
    Price integer  NOT NULL,
    Id_car integer  NOT NULL,
    CONSTRAINT Repair_pk PRIMARY KEY (Id_repair)
) ;

-- Table: Reservation
CREATE TABLE Reservation (
    Id_reservation integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Id_car integer  NOT NULL,
    Person_PESEL integer  NOT NULL,
    CONSTRAINT Reservation_pk PRIMARY KEY (Id_reservation)
) ;

-- Table: Transaction
CREATE TABLE Transaction (
    Id_transaction integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Transaction_type varchar2(20)  NOT NULL,
    Seller_PESEL integer,
    Buyer_PESEL integer,
    Id_dealer integer  NOT NULL,
    Id_car integer  NOT NULL,
    Transaction_date date  NOT NULL,
    Price integer  NOT NULL,
    CONSTRAINT Transaction_pk PRIMARY KEY (Id_transaction)
) ;

-- foreign keys
-- Reference: Car_Car_dealership (table: Car)
ALTER TABLE Car ADD CONSTRAINT Car_Car_dealership
    FOREIGN KEY (Id_dealer)
    REFERENCES Car_dealership (Id_dealer);

-- Reference: Car_Modification (table: Modification)
ALTER TABLE Modification ADD CONSTRAINT Car_Modification
    FOREIGN KEY (Id_car)
    REFERENCES Car (Id_car);

-- Reference: Car_Person (table: Car)
ALTER TABLE Car ADD CONSTRAINT Car_Person
    FOREIGN KEY (Owner_PESEL)
    REFERENCES Person (PESEL);

-- Reference: Car_Repair (table: Repair)
ALTER TABLE Repair ADD CONSTRAINT Car_Repair
    FOREIGN KEY (Id_car)
    REFERENCES Car (Id_car);

-- Reference: Car_brand_Car_model (table: Car_model)
ALTER TABLE Car_model ADD CONSTRAINT Car_brand_Car_model
    FOREIGN KEY (Brand)
    REFERENCES Car_brand (Brand_name);

-- Reference: Car_dealership_Person (table: Car_dealership)
ALTER TABLE Car_dealership ADD CONSTRAINT Car_dealership_Person
    FOREIGN KEY (Owner_PESEL)
    REFERENCES Person (PESEL);

-- Reference: Car_model_Car (table: Car)
ALTER TABLE Car ADD CONSTRAINT Car_model_Car
    FOREIGN KEY (Car_model)
    REFERENCES Car_model (Model_name);

-- Reference: Reservation_Car (table: Reservation)
ALTER TABLE Reservation ADD CONSTRAINT Reservation_Car
    FOREIGN KEY (Id_car)
    REFERENCES Car (Id_car);

-- Reference: Reservation_Person (table: Reservation)
ALTER TABLE Reservation ADD CONSTRAINT Reservation_Person
    FOREIGN KEY (Person_PESEL)
    REFERENCES Person (PESEL);

-- Reference: Transaction_Buyer (table: Transaction)
ALTER TABLE Transaction ADD CONSTRAINT Transaction_Buyer
    FOREIGN KEY (Buyer_PESEL)
    REFERENCES Person (PESEL);

-- Reference: Transaction_Car (table: Transaction)
ALTER TABLE Transaction ADD CONSTRAINT Transaction_Car
    FOREIGN KEY (Id_car)
    REFERENCES Car (Id_car);

-- Reference: Transaction_Car_dealership (table: Transaction)
ALTER TABLE Transaction ADD CONSTRAINT Transaction_Car_dealership
    FOREIGN KEY (Id_dealer)
    REFERENCES Car_dealership (Id_dealer);

-- Reference: Transaction_Seller (table: Transaction)
ALTER TABLE Transaction ADD CONSTRAINT Transaction_Seller
    FOREIGN KEY (Seller_PESEL)
    REFERENCES Person (PESEL);

-- End of file.