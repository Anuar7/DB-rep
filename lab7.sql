create table customers (

    id integer primary key,

    name varchar(255),

    birth_date date

);




create table accounts(

    account_id varchar(40) primary key ,

    customer_id integer references customers(id),

    currency varchar(3),

    balance float,

    "limit" float

);




create table transactions (

    id serial primary key ,

    date timestamp,

    src_account varchar(40) references accounts(account_id),

    dst_account varchar(40) references accounts(account_id),

    amount float,

    status varchar(20)

);




INSERT INTO customers VALUES (201, 'John', '2021-11-05');

INSERT INTO customers VALUES (202, 'Anny', '2021-11-02');

INSERT INTO customers VALUES (203, 'Rick', '2021-11-24');




INSERT INTO accounts VALUES ('NT10204', 201, 'KZT', 1000, null);

INSERT INTO accounts VALUES ('AB10203', 202, 'USD', 100, 0);

INSERT INTO accounts VALUES ('DK12000', 203, 'EUR', 500, 200);

INSERT INTO accounts VALUES ('NK90123', 201, 'USD', 400, 0);

INSERT INTO accounts VALUES ('RS88012', 203, 'KZT', 5000, -100);




INSERT INTO transactions VALUES (1, '2021-11-05 18:00:34.000000', 'NT10204', 'RS88012', 1000, 'commited');

INSERT INTO transactions VALUES (2, '2021-11-05 18:01:19.000000', 'NK90123', 'AB10203', 500, 'rollback');

INSERT INTO transactions VALUES (3, '2021-06-05 18:02:45.000000', 'RS88012', 'NT10204', 400, 'init');




--1

--Blob and Clob data types




--2.1

CREATE ROLE accountant;

CREATE ROLE administrator;

CREATE ROLE support;

GRANT SELECT, INSERT ON accounts, transactions TO accountant;

GRANT ALL PRIVILEGES ON accounts, customers, transactions TO administrator;

GRANT INSERT, UPDATE, DELETE ON accounts, customers TO support;




--2.2

CREATE USER user_1;

CREATE USER user_2;

CREATE USER user_3;

GRANT administrator to user_1;

GRANT accountant to user_2;

GRANT support to user_3;




--2.3

CREATE USER God;

GRANT ALL PRIVILEGES on accounts, customers, transactions TO God WITH GRANT OPTION;




--2.4

REVOKE ALL PRIVILEGES ON accounts, customers, transactions FROM GOD;




--3.1




--3.2

ALTER TABLE customers

    ALTER COLUMN name SET NOT NULL;

ALTER TABLE customers

    ALTER COLUMN birth_date SET NOT NULL;




--5.1

CREATE INDEX acc_cur ON accounts (customer_id, currency);




--5.2

CREATE INDEX cur_bal ON accounts (currency, balance);




--6

DO

$$

    DECLARE

        bal INT;

        lim INT;

    BEGIN

--         SAVEPOINT s1;

        UPDATE accounts

        SET balance = balance - 400

        WHERE account_id = 'RS88012';

        UPDATE accounts

        SET balance = balance + 400

        WHERE account_id = 'NT10204';

        SELECT balance INTO bal FROM accounts WHERE account_id = 'RS88012';

        SELECT accounts.limit INTO lim FROM accounts WHERE account_id = 'RS88012';

        IF bal < lim THEN

--             ROLLBACK TO SAVEPOINT s1;

            UPDATE transactions SET status = 'rollback' WHERE id = 3;

        ELSE

            COMMIT;

            UPDATE transactions SET status = 'commited' WHERE id = 3;

        END IF;

    END;

$$