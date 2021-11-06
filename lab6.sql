create table dealer (
    id integer primary key ,
    name varchar(255),
    location varchar(255),
    charge float
);

INSERT INTO dealer (id, name, location, charge) VALUES (101, 'Ерлан', 'Алматы', 0.15);
INSERT INTO dealer (id, name, location, charge) VALUES (102, 'Жасмин', 'Караганда', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (105, 'Азамат', 'Нур-Султан', 0.11);
INSERT INTO dealer (id, name, location, charge) VALUES (106, 'Канат', 'Караганда', 0.14);
INSERT INTO dealer (id, name, location, charge) VALUES (107, 'Евгений', 'Атырау', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (103, 'Жулдыз', 'Актобе', 0.12);

create table client (
    id integer primary key ,
    name varchar(255),
    city varchar(255),
    priority integer,
    dealer_id integer references dealer(id)
);

INSERT INTO client (id, name, city, priority, dealer_id) VALUES (802, 'Айша', 'Алматы', 100, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (807, 'Даулет', 'Алматы', 200, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (805, 'Али', 'Кокшетау', 200, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (808, 'Ильяс', 'Нур-Султан', 300, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (804, 'Алия', 'Караганда', 300, 106);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (809, 'Саша', 'Шымкент', 100, 103);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (803, 'Маша', 'Семей', 200, 107);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (801, 'Максат', 'Нур-Султан', null, 105);

create table sell (
    id integer primary key,
    amount float,
    date timestamp,
    client_id integer references client(id),
    dealer_id integer references dealer(id)
);

INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (201, 150.5, '2012-10-05 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (209, 270.65, '2012-09-10 00:00:00.000000', 801, 105);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (202, 65.26, '2012-10-05 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (204, 110.5, '2012-08-17 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (207, 948.5, '2012-09-10 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (205, 2400.6, '2012-07-27 00:00:00.000000', 807, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (208, 5760, '2012-09-10 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (210, 1983.43, '2012-10-10 00:00:00.000000', 804, 106);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (203, 2480.4, '2012-10-10 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (212, 250.45, '2012-06-27 00:00:00.000000', 808, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (211, 75.29, '2012-08-17 00:00:00.000000', 803, 107);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (213, 3045.6, '2012-04-25 00:00:00.000000', 802, 101);

-- drop table client;
-- drop table dealer;
-- drop table sell;

--task1 a
SELECT * FROM dealer JOIN client c on dealer.id = c.dealer_id;

--task1 b
SELECT c.id, c.name, s.id, city, priority, date, amount, d.id, d.name
FROM dealer d
FULL JOIN client c on d.id = c.dealer_id
FULL JOIN sell s on d.id = s.dealer_id and c.id = s.client_id;

--task1 c
SELECT * FROM dealer INNER JOIN client  on dealer.location = client.city;

--task1 d
SELECT sell.id, sell.amount, client.name, client.city
FROM sell inner join client on sell.client_id = client.id
WHERE sell.amount >= 100 and sell.amount <= 500;

--task1 e
SELECT d.name, count(d.id)
FROM dealer d
FULL JOIN client c on d.id = c.dealer_id
GROUP BY d.name;

--task1 f
SELECT d.name, c.id, c.name, charge, city
FROM dealer d
FULL JOIN client c on d.id = c.dealer_id;

--task1 g
SELECT c.id, c.city, c.name, d.name, charge
FROM client c
FULL JOIN dealer d on d.id = c.dealer_id
WHERE charge > 0.12;

--task1 h
SELECT c.name, s.id, s.amount, d.name, city, charge
FROM client c
FULL JOIN sell s on c.id = s.client_id
FULL JOIN dealer d on d.id = c.dealer_id;

--task1 i
SELECT c.name, c.priority, d.name, s.id, s.amount
FROM dealer d
LEFT JOIN client c on c.dealer_id = d.id
LEFT JOIN sell s on c.id = s.client_id
WHERE priority IS NOT NULL and s.amount > 2000;

--task2 a
create view each_date AS
    SELECT date, count(c.id), avg(amount), sum(amount)
FROM sell
LEFT JOIN client c on c.id = sell.client_id
GROUP BY date;

--task2 b
create view top_five_days as
    SELECT date, amount
    FROM sell
ORDER BY amount DESC limit 5;

--task2 c
create view each_dealer as
    SELECT d.name, count(s.id), avg(amount), sum(amount)
FROM dealer d
LEFT JOIN sell s on d.id = s.dealer_id
GROUP BY d.name;

--task2 d
create view dealers_earns as
    SELECT d.location, sum(amount), sum(amount) * (charge)
FROM dealer d
LEFT JOIN sell s on d.id = s.dealer_id
GROUP BY d.location, charge;

--task2 e
create view each_dealer_location as
    SELECT d.location, count(s.id), sum(amount),avg(amount)
FROM dealer d
LEFT JOIN sell s on d.id = s.dealer_id
GROUP BY d.location;

--task2 f
create view each_city as
    SELECT c.city, count(s.id), sum(amount), avg(amount)
FROM client c
LEFT JOIN sell s on c.id = s.client_id
GROUP BY c.city;

--task2 g
create view city_expenses as
    SELECT c.city, count(s.id), sum(amount)
FROM client c
JOIN sell s on c.id = s.client_id
JOIN dealer d on s.dealer_id = d.id and c.city = d.location
GROUP BY city;

