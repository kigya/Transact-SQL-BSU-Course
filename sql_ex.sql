----------Задания на предложения WHERE, GROUP BY, HAVING, ORDER BY----------
-- Задание: 1 (Serge I: 2002-09-30)
-- Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd
SELECT DISTINCT Model, Speed, Hd
    FROM Pc
    WHERE Price < 500


-- Задание: 2 (Serge I: 2002-09-21)
-- Найдите производителей принтеров. Вывести: maker
SELECT DISTINCT Maker
    FROM Product
    WHERE Type = 'printer'


-- Задание: 3 (Serge I: 2002-09-30)
-- Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.
SELECT Model, Ram, Screen
    FROM Laptop
    WHERE Price > 1000


-- Задание: 4 (Serge I: 2002-09-21)
-- Найдите все записи таблицы Printer для цветных принтеров.
SELECT *
    FROM Printer
    WHERE Color = 'y'


-- Задание: 5 (Serge I: 2002-09-30)
-- Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.
SELECT Model, Speed, Hd
    FROM Pc
    WHERE Price < 600
      AND (Cd = '12x' OR Cd = '24x')


-- Задание: 31 (Serge I: 2002-10-22)
-- Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну.
SELECT Class, Country
    FROM Classes
    WHERE Bore >= 16


-- Задание: 33 (Serge I: 2002-11-02)
-- Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic). Вывод: ship.
SELECT Ship
    FROM Outcomes
    WHERE Battle = 'North Atlantic'
      AND Result = 'sunk'


-- Задание: 11 (Serge I: 2002-11-02)
-- Найдите среднюю скорость ПК.
SELECT avg(Speed)
    FROM Pc


-- Задание: 12 (Serge I: 2002-11-02)
-- Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.
SELECT avg(Speed)
    FROM Laptop
    WHERE Price > 1000


-- Задание: 22 (Serge I: 2003-02-13)
-- Для каждого значения скорости ПК,
-- превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. Вывести: speed, средняя цена.
SELECT Speed, [средняя цена] = avg(Price)
    FROM Pc
    WHERE Speed > 600
    GROUP BY Speed


-- Задание: 15 (Serge I: 2003-02-03)
-- Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD
SELECT Hd = Hd
    FROM Pc
    GROUP BY Hd
    HAVING count(*) >= 2


-- Задание: 20 (Serge I: 2003-02-13)
-- Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.
SELECT Maker, [число моделей ПК] = count(*)
    FROM Product
    WHERE Type = 'PC'
    GROUP BY Maker
    HAVING count(Model) >= 3


-- Задание: 40 (Serge I: 2012-04-20)
-- Найти производителей, которые выпускают более одной модели, при этом все выпускаемые
-- производителем модели являются продуктами одного типа.
-- Вывести: maker, type

SELECT Maker = max(Maker), Type
    FROM Product
    GROUP BY Maker, Type
    HAVING count(DISTINCT Type) = 1
       AND count(Model) > 1


-- Задание: 90 (Serge I: 2012-05-04)
-- Вывести все строки из таблицы Product, кроме трех строк с наименьшими номерами моделей и трех строк с наибольшими номерами моделей.
SELECT *
    FROM Product
    WHERE Model NOT IN (SELECT TOP (3) Model
                            FROM Product
                            ORDER BY Model)

      AND Model NOT IN (SELECT TOP (3) Model
                            FROM Product
                            ORDER BY Model DESC);


-- Задание: 42 (Serge I: 2002-11-05)
-- Найдите названия кораблей, потопленных в сражениях, и название сражения, в котором они были потоплены.
SELECT Ship, Battle
    FROM Outcomes
    WHERE Result = 'sunk'


-- Задание: 38 (Serge I: 2003-02-19)
-- Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb') и имевшие когда-либо классы крейсеров ('bc').
SELECT Country
    FROM Classes
    GROUP BY Country
    HAVING count(DISTINCT Type) = 2


-- Задание: 53 (Serge I: 2002-11-05)
-- Определите среднее число орудий для классов линейных кораблей.
-- Получить результат с точностью до 2-х десятичных знаков.

SELECT cast(avg(cast(Numguns AS NUMERIC(5, 2))) AS NUMERIC(5, 2)) AS 'Avg-numGuns'
    FROM Classes
    WHERE Type = 'bb'


-- Задание: 86 (Serge I: 2012-04-20)
-- Для каждого производителя перечислить в алфавитном порядке с разделителем "/" все типы выпускаемой им продукции.
-- Вывод: maker, список типов продукции
SELECT Maker,
       CASE
           WHEN count(DISTINCT Type) = 3
               THEN 'Laptop/PC/Printer'
           WHEN count(DISTINCT Type) = 1
               THEN max(Type)
           ELSE min(Type) + '/' + max(Type)
           END
    FROM Product
    GROUP BY Maker


-- Задание: 85 (Serge I: 2012-03-16)
-- Найти производителей, которые выпускают только принтеры или только PC.
-- При этом искомые производители PC должны выпускать не менее 3 моделей.
SELECT DISTINCT Maker
    FROM Product
    GROUP BY Maker
    HAVING count(DISTINCT Type) = 1
       AND ((min(Type) = 'PC' AND count(Model) >= 3) OR min(Type) = 'Printer')


-- Задание: 24 (Serge I: 2003-02-03)
-- Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.

;
WITH Sql_Data(Price, Model) AS (
    SELECT Price, Model

        FROM Pc
    UNION ALL
    SELECT Price, Model
        FROM Laptop
    UNION ALL
    SELECT Price, Model
        FROM Printer
)

SELECT DISTINCT Model
    FROM Sql_Data
    WHERE Price = (SELECT TOP (1) Price
                       FROM Sql_Data
                       ORDER BY Price DESC)


-- Задание: 18 (Serge I: 2003-02-03)
-- Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price
SELECT DISTINCT Product.Maker, Printer.Price

    FROM Product,
         Printer

    WHERE Product.Model = Printer.Model

      AND Printer.Price = (
        SELECT min(Price)
            FROM Printer

            WHERE Printer.Color = 'y'
    )
      AND Printer.Color = 'y'


-- Задание: 77 (Serge I: 2003-04-09)
-- Определить дни, когда было выполнено максимальное число рейсов из
-- Ростова ('Rostov'). Вывод: число рейсов, дата.
SELECT TOP (1) WITH TIES Number = count(DISTINCT T.Trip_No), Date
    FROM Trip AS T
             JOIN Pass_In_Trip AS P ON P.Trip_No = T.Trip_No
    WHERE T.Town_From = 'Rostov'
    GROUP BY Date
    ORDER BY Number DESC


-- Задание: 97 (qwrqwr: 2013-02-15)
-- Отобрать из таблицы Laptop те строки, для которых выполняется следующее условие:
-- значения из столбцов speed, ram, price, screen возможно расположить таким образом, что каждое последующее значение будет превосходить предыдущее в 2 раза или более.
-- Замечание: все известные характеристики ноутбуков больше нуля.
-- Вывод: code, speed, ram, price, screen.
SELECT Code, Speed, Ram, Price, Screen
    FROM Laptop
    WHERE (Speed >= 2 * Ram OR Speed <= Ram / 2.0)
      AND (Speed >= 2 * Price OR Speed <= Price / 2)
      AND (Speed >= 2 * Screen OR Speed <= Screen / 2.0)
      AND (Ram >= 2 * Price OR Ram <= Price / 2.0)
      AND (Ram >= 2 * Screen OR Ram <= Screen / 2.0)
      AND (Price >= 2 * Screen OR Price <= Screen / 2.0)


----------Контроль на предложения WHERE, GROUP BY, HAVING, ORDER BY----------
--Контрольный вопрос 1.
-- Выполнить задание для базы данных AdventureWorks2019.
-- Для каждого товара в таблице Production.Product вывести  его название и количество пробелов в этом названии товара.
-- Например, для товара "Mountain-100 Black, 44" ожидается два пробела
USE Adventureworks2019
SELECT Name, Spaces = len(Name) - len(replace(Name, ' ', ''))
    FROM Production.Product


--Контрольный вопрос 2.
--Выполнить задание для базы данных AdventureWorks2019.
--Для каждого товара в таблице Production.Product вывести  его название и название, в котором удалены все цифры.
--Например, для товара "Mountain-100 Black, 44" ожидается "Mountain- Black, "
USE Adventureworks2019
SELECT Name,
       [Non-numeric Name] = (replace(
               replace(
                       replace(
                               replace(
                                       replace(
                                               replace(
                                                       replace(
                                                               replace(
                                                                       replace(
                                                                               replace(Name, '1', ''), '2', ''), '3',
                                                                       ''), '4', ''), '5', ''), '6', ''), '7', ''), '8',
                               ''), '9', ''), '0', ''))
    FROM Production.Product


--Контрольный вопрос 3.
--Выполнить задание для базы данных AdventureWorks2019.
--Для каждого товара в таблице Production.Product вывести  его название и количество гласных букв в названии.
USE Adventureworks2019
SELECT Name,
       [Vowel Count] = len(Name) - len(
               replace(
                       replace(
                               replace(
                                       replace(
                                               replace(
                                                       lower(Name), 'a', ''), 'e', ''), 'i', ''), 'o', ''), 'u', ''))
    FROM Production.Product


--Контрольный вопрос 6.
--Выполнить задание для базы данных AdventureWorks2019.
--На основании данных из столбца SellStartDate таблицы  Production.Product определить является ли год високосным.
--Предложите не менее трёх алгоритмов решения задачи.
SELECT Sellstartdate,
       Year = year(Sellstartdate),
       CASE
           WHEN year(Sellstartdate) % 4 = 0 AND year(Sellstartdate) % 100 != 0
               THEN 'Leap'
           WHEN year(Sellstartdate) % 400 = 0
               THEN 'Leap'
           ELSE 'Not leap'
           END
    FROM Production.Product

SELECT Sellstartdate,
       Year = year(Sellstartdate),
       iif(datepart(DAYOFYEAR, datefromparts(year(Sellstartdate), 12, 31)) = 366, 'Leap', 'Not leap')
    FROM Production.Product

SELECT Sellstartdate,
       Year = year(Sellstartdate),
       iif(day(eomonth(dateadd(DAY, 31, dateadd(YEAR, year(Sellstartdate) - 1900, 0)))) = 29, 'Leap', 'Not leap')
    FROM Production.Product


----------Задания на операторы над наборами данных, соединения таблиц (JOIN) и на подзапросы----------
USE [sql-ex]
--Задание: 8 (Serge I: 2003-02-03)
--Найдите производителя, выпускающего ПК, но не ПК-блокноты.

SELECT Maker
    FROM Product
    WHERE Type = 'pc'
EXCEPT
SELECT Maker
    FROM Product
    WHERE Type = 'laptop'

--Задание: 24 (Serge I: 2003-02-03)
--Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.

SELECT TOP (1) WITH TIES Model
    FROM (SELECT Model, Price
              FROM Laptop
          UNION
          SELECT Model, Price
              FROM Pc
          UNION
          SELECT Model, Price
              FROM Printer) AS A
    ORDER BY Price DESC

--Задание: 30 (Serge I: 2003-02-14)
--В предположении, что приход и расход денег на каждом пункте приема фиксируется произвольное число раз (первичным ключом в таблицах является столбец code), требуется получить таблицу, в которой каждому пункту за каждую дату выполнения операций будет соответствовать одна строка.
--Вывод: point, date, суммарный расход пункта за день (out), суммарный приход пункта за день (inc). Отсутствующие значения считать неопределенными (NULL).

;
WITH T1 AS (
    SELECT Point, Date, Out = NULL, Inc
        FROM Income
    UNION ALL
    SELECT Point, Date, Out, Inc = NULL
        FROM Outcome
)
SELECT Point, Date, Out = sum(Out), Inc = sum(Inc)
    FROM T1
    GROUP BY Point, Date

--Задание: 6 (Serge I: 2002-10-28)
--Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.

SELECT DISTINCT P.Maker, Lap.Speed
    FROM Product AS P
             INNER JOIN Laptop AS Lap ON P.Model = Lap.Model
    WHERE Hd >= 10

--Задание: 9 (Serge I: 2002-11-02)
--Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker

SELECT DISTINCT P.Maker
    FROM Product AS P
             INNER JOIN Pc ON P.Model = Pc.Model
    WHERE Speed >= 450

--Задание: 13 (Serge I: 2002-11-02)
--Найдите среднюю скорость ПК, выпущенных производителем A.

SELECT Avg = avg(Pc.Speed)
    FROM Product AS P
             INNER JOIN Pc ON P.Model = Pc.Model
    WHERE P.Maker = 'A'

--Задание: 16 (Serge I: 2003-02-03)
--Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i), Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.

SELECT DISTINCT T1.Model, T2.Model, T1.Speed, T1.Ram
    FROM Pc AS T1
             INNER JOIN Pc AS T2 ON T1.Speed = T2.Speed AND T1.Ram = T2.Ram AND T1.Model > T2.Model

--Задание: 19 (Serge I: 2003-02-13)
--Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
--Вывести: maker, средний размер экрана.

SELECT Maker, Avgscr = avg(Laptop.Screen)
    FROM Product
             JOIN Laptop ON Product.Model = Laptop.Model
    GROUP BY Maker

--Задание: 23 (Serge I: 2003-02-14)
--Найдите производителей, которые производили бы как ПК
--со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
--Вывести: Maker

SELECT Maker
    FROM (SELECT Model
              FROM Pc
              WHERE Speed >= 750) AS Pc750(Pc_Model)
             JOIN
         Product ON Product.Model = Pc750.Pc_Model
INTERSECT
SELECT Maker
    FROM (SELECT Model
              FROM Laptop
              WHERE Speed >= 750) AS Lt750(Lt_Model)
             JOIN
         Product ON Product.Model = Lt750.Lt_Model

--Задание: 29 (Serge I: 2003-02-14)
--В предположении, что приход и расход денег на каждом пункте приема фиксируется не чаще одного раза в день [т.е. первичный ключ (пункт, дата)], написать запрос с выходными данными (пункт, дата, приход, расход). Использовать таблицы Income_o и Outcome_o.

SELECT Point = coalesce(O.Point, I.Point), Date = coalesce(O.Date, I.Date), I.Inc, O.Out
    FROM Outcome_O AS O
             FULL JOIN Income_O AS I ON I.Point = O.Point AND O.Date = I.Date

--Задание: 10 (Serge I: 2002-09-23)
--Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price

SELECT Model, Price
    FROM Printer
    WHERE Price = (SELECT max(Price)
                       FROM Printer)
    ORDER BY Price DESC

--Задание: 17 (Serge I: 2003-02-03)
--Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
--Вывести: type, model, speed

SELECT DISTINCT P.Type, L.Model, L.Speed
    FROM Laptop AS L
             INNER JOIN Product AS P ON L.Model = P.Model
    WHERE Speed < ALL (SELECT Speed
                           FROM Pc)

--Задание: 25 (Serge I: 2003-02-14)
--Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

SELECT DISTINCT Maker
    FROM Product
    WHERE Model IN (
        SELECT Model
            FROM Pc
            WHERE Ram = (
                SELECT min(Ram)
                    FROM Pc
            )
              AND Speed = (
                SELECT max(Speed)
                    FROM Pc
                    WHERE Ram = (
                        SELECT min(Ram)
                            FROM Pc
                    )
            )
    )
      AND Maker IN (
        SELECT Maker
            FROM Product
            WHERE Type = 'printer'
    )

--Задание: 27 (Serge I: 2003-02-03)
--Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.

SELECT Product.Maker, avg(Pc.Hd)
    FROM Pc,
         Product
    WHERE Product.Model = Pc.Model
      AND Product.Maker IN (SELECT DISTINCT Maker
                                FROM Product
                                WHERE Product.Type = 'printer')
    GROUP BY Maker

--Задание: 34 (Serge I: 2002-11-04)
--По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн. Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду). Вывести названия кораблей.

SELECT Name
    FROM Classes,
         Ships
    WHERE Launched >= 1922
      AND Displacement > 35000
      AND Type = 'bb'
      AND Ships.Class = Classes.Class

--HomeWork

--Задание: 38 (Serge I: 2003-02-19)
--Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb') и имевшие когда-либо классы крейсеров ('bc').

SELECT Country
    FROM Classes
    WHERE Type = 'bb'
    GROUP BY Classes.Country
INTERSECT
SELECT Country
    FROM Classes
    WHERE Type = 'bc'
    GROUP BY Classes.Country

--Задание: 44 (Serge I: 2002-12-04)
--Найдите названия всех кораблей в базе данных, начинающихся с буквы R.

SELECT Name
    FROM Ships
    WHERE Name LIKE 'R%'
UNION
SELECT O.Ship
    FROM Outcomes AS O
    WHERE O.Ship LIKE 'R%'

--Задание: 45 (Serge I: 2002-12-04)
--Найдите названия всех кораблей в базе данных, состоящие из трех и более слов (например, King George V).
--Считать, что слова в названиях разделяются единичными пробелами, и нет концевых пробелов.

SELECT Name
    FROM Ships
    WHERE Name LIKE '% % %'
UNION
SELECT O.Ship
    FROM Outcomes AS O
    WHERE O.Ship LIKE '% % %'

--Задание: 73 (Serge I: 2009-04-17)
--Для каждой страны определить сражения, в которых не участвовали корабли данной страны.
--Вывод: страна, сражение

SELECT DISTINCT C.Country, B.Name
    FROM Battles B,
         Classes C
EXCEPT
SELECT C.Country, O.Battle
    FROM Outcomes O
             LEFT JOIN Ships S ON S.Name = O.Ship
             LEFT JOIN Classes C ON O.Ship = C.Class OR S.Class = C.Class
    WHERE C.Country IS NOT NULL
    GROUP BY C.Country, O.Battle

--Задание: 90 (Serge I: 2012-05-04)
--Вывести все строки из таблицы Product, кроме трех строк с наименьшими номерами моделей и трех строк с наибольшими номерами моделей.

SELECT *
    FROM Product
    ORDER BY Model
    OFFSET 3 ROWS FETCH NEXT (SELECT count(*)
                                  FROM Product) - 3 - 3 ROWS ONLY

--второе

SELECT *
    FROM Product
    WHERE Model NOT IN (
        SELECT Model
            FROM (
                     SELECT TOP 3 Model
                         FROM Product
                     ORDER BY Model
                     UNION
                     SELECT TOP 3 Model
                         FROM Product
                     ORDER BY Model DESC) Asd)

--Задание: 49 (Serge I: 2003-02-17)
--Найдите названия кораблей с орудиями калибра 16 дюймов (учесть корабли из таблицы Outcomes).

SELECT Ship
    FROM (
             SELECT Ship, Ship AS Class
                 FROM Outcomes
             UNION
             SELECT Name, Class
                 FROM Ships
         ) AS S
             JOIN Classes C ON C.Class = S.Class
    WHERE Bore = 16

--Задание: 50 (Serge I: 2002-11-05)
--Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

SELECT DISTINCT B.Name
    FROM Battles B
             JOIN Outcomes O ON B.Name = O.Battle
    WHERE O.Ship IN
          (SELECT Name
               FROM Ships
               WHERE Class = 'Kongo')

--Задание: 52 (qwrqwr: 2010-04-23)
--Определить названия всех кораблей из таблицы Ships, которые могут быть линейным японским кораблем,
--имеющим число главных орудий не менее девяти, калибр орудий менее 19 дюймов и водоизмещение не более 65 тыс.тонн

SELECT S.Name
    FROM Ships AS S
             JOIN Classes C ON C.Class = S.Class
    WHERE (C.Type = 'bb' OR C.Type IS NULL)
      AND (C.Country = 'Japan' OR C.Country IS NULL)
      AND (C.Numguns >= 9 OR C.Numguns IS NULL)
      AND (C.Bore < 19.0 OR C.Bore IS NULL)
      AND (C.Displacement <= 65000 OR C.Displacement IS NULL)

--Задание: 55 (Serge I: 2003-02-16)
--Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

SELECT Cl.Class, min(Sh.Launched)
    FROM Classes Cl
             LEFT JOIN Ships Sh ON Sh.Class = Cl.Class
    GROUP BY Cl.Class

--Задание: 56 (Serge I: 2003-02-16)
--Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

SELECT C.Class, count(T.Ship)
    FROM Classes AS C
             LEFT JOIN (
        SELECT O.Ship, S.Class
            FROM Outcomes AS O
                     LEFT JOIN Ships AS S ON S.Name = O.Ship
            WHERE O.Result = 'sunk'
    ) AS T ON C.Class = T.Ship OR C.Class = T.Class
    GROUP BY C.Class

--Задание: 66 (Serge I: 2003-04-09)
--Для всех дней в интервале с 01/04/2003 по 07/04/2003 определить число рейсов из Rostov.
--Вывод: дата, количество рейсов

;
WITH T1 AS
         (SELECT Dataa = cast('2003-04-01' AS DATETIME)
          UNION ALL
          SELECT dateadd(DAY, 1, Dataa)
              FROM T1
              WHERE Dataa < '2003-04-07'
         )
SELECT T1.Dataa, count(DISTINCT T.Trip_No)
    FROM T1
             LEFT JOIN Pass_In_Trip AS P ON P.Date = T1.Dataa
             LEFT JOIN Trip AS T ON T.Trip_No = P.Trip_No AND T.Town_From = 'Rostov'
    GROUP BY T1.Dataa

--Задание: 71 (Serge I: 2008-02-23)
--Найти тех производителей ПК, все модели ПК которых имеются в таблице PC.

SELECT Maker
    FROM Product AS Z
    WHERE Type = 'pc'
EXCEPT
(SELECT Maker
     FROM Product AS A
              JOIN
          (SELECT Model
               FROM Product
               WHERE Type = 'pc'
           EXCEPT
           SELECT DISTINCT Model
               FROM Pc) B ON A.Model = B.Model)

--Задание: 95 (qwrqwr: 2013-02-08)
--На основании информации из таблицы Pass_in_Trip, для каждой авиакомпании определить:
--1) количество выполненных перелетов;
--2) число использованных типов самолетов;
--3) количество перевезенных различных пассажиров;
--4) общее число перевезенных компанией пассажиров.
--Вывод: Название компании, 1), 2), 3), 4).

SELECT C.Name                                                                           AS Company_Name,
       count(DISTINCT cast(Pit.Date AS VARCHAR(35)) + cast(Pit.Trip_No AS VARCHAR(35))) AS Flights,
       count(DISTINCT T.Plane)                                                          AS Planes,
       count(DISTINCT Pit.Id_Psg)                                                       AS Diff_Psngrs,
       count(Pit.Id_Psg)                                                                AS Total_Psngrs
    FROM Pass_In_Trip AS Pit
             INNER JOIN Trip AS T ON T.Trip_No = Pit.Trip_No
             INNER JOIN Company AS C ON T.Id_Comp = C.Id_Comp
    GROUP BY C.Name

--Задание: 43 (qwrqwr: 2011-10-28)
--Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

SELECT Name
    FROM Battles
    WHERE year(Date) NOT IN
          (SELECT Launched
               FROM Ships
               WHERE Launched IS NOT NULL)

--Задание: 63 (Serge I: 2003-04-08)
--Определить имена разных пассажиров, когда-либо летевших на одном и том же месте более одного раза.

SELECT Name
    FROM Passenger
    WHERE Id_Psg IN
          (SELECT Id_Psg
               FROM Pass_In_Trip
               GROUP BY Place, Id_Psg
               HAVING count(*) > 1)


----------Задания на табличные выражения-----------
--Задание: 59 (Serge I: 2003-02-15)
--Посчитать остаток денежных средств на каждом пункте приема для базы данных с отчетностью не чаще одного раза в день.
--Вывод: пункт, остаток.
SELECT Incs.Point,
       iif(sum(Out) IS NULL, sum(Inc), sum(Inc) - sum(Out)) Remain
    FROM (SELECT I.Point, Inc = sum(Inc)
              FROM Income_O I
              GROUP BY I.Point) AS Incs
             LEFT JOIN
         (SELECT O.Point, Out = sum(Out)
              FROM Outcome_O O
              GROUP BY O.Point) AS Ou
         ON Incs.Point = Ou.Point
    GROUP BY Incs.Point


--Задание: 60 (Serge I: 2003-02-15)
--Посчитать остаток денежных средств на начало дня 15/04/01 на каждом пункте приема для базы данных с отчетностью не
--чаще одного раза в день. Вывод: пункт, остаток.
--Замечание. Не учитывать пункты, информации о которых нет до указанной даты.
SELECT Income_O.Point,
       Remain = CASE
                    WHEN sum(Inc) - min(Outcome) > 0 THEN sum(Inc) - min(Outcome)
                    WHEN min(Outcome) IS NULL THEN sum(Inc)
                    ELSE 0
           END
    FROM Income_O
             FULL JOIN (SELECT Point, Outcome = sum(Out)
                            FROM Outcome_O
                            WHERE [date] < '20010415'
                            GROUP BY Point) AS O
                       ON O.Point = Income_O.Point
    WHERE [date] < '20010415'
    GROUP BY Income_O.Point


--Задание: 26 (Serge I: 2003-02-14)
--Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква).
--Вывести: одна общая средняя цена.
;
WITH T1 AS (
    SELECT T.Price
        FROM Product AS P
                 INNER JOIN Pc AS T ON P.Model = T.Model
        WHERE Maker = 'A'
    UNION ALL
    SELECT T.Price
        FROM Product AS P
                 INNER JOIN Laptop AS T ON P.Model = T.Model
        WHERE P.Maker = 'A'
)
SELECT avg(Price)
    FROM T1


--Задание: 28 (Serge I: 2012-05-04)
--Используя таблицу Product, определить количество производителей, выпускающих по одной модели.
;
WITH T1 AS (
    SELECT Maker
        FROM Product
        GROUP BY Maker
        HAVING count(Model) = 1
)
SELECT count(*)
    FROM T1;

WITH T1 AS (
    SELECT *, Num = count(Model) OVER (PARTITION BY Maker)
        FROM Product
)
SELECT count(*)
    FROM T1
    WHERE Num = 1


--Задание: 30 (Serge I: 2003-02-14)
--В предположении, что приход и расход денег на каждом пункте приема фиксируется произвольное число раз
--(первичным ключом в таблицах является столбец code), требуется получить таблицу, в которой каждому пункту за каждую
--дату выполнения операций будет соответствовать одна строка.
--Вывод: point, date, суммарный расход пункта за день (out), суммарный приход пункта за день (inc).
--Отсутствующие значения считать неопределенными (NULL).
;
WITH T1 AS (
    SELECT Point, Date, Out = NULL, Inc
        FROM Income
    UNION ALL
    SELECT Point, Date, Out, Inc = NULL
        FROM Outcome
)
SELECT Point, Date, Out = sum(Out), Inc = sum(Inc)
    FROM T1
    GROUP BY Point, Date


--Задание: 32 (Serge I: 2003-02-17)
--Одной из характеристик корабля является половина куба калибра его главных орудий (mw).
--С точностью до 2 десятичных знаков определите среднее значение mw для кораблей каждой страны,
--у которой есть корабли в базе данных.
;
WITH T1 AS (
    SELECT S.Name, C.Country, Mw = power(C.Bore, 3) / 2
        FROM Classes AS C
                 INNER JOIN Ships AS S ON C.Class = S.Class
    UNION
    SELECT C.Class, C.Country, Mw = power(C.Bore, 3) / 2
        FROM Classes AS C
                 INNER JOIN Outcomes AS O ON C.Class = O.Ship
)
SELECT Country, cast(avg(Mw) AS DECIMAL(7, 2))
    FROM T1
    GROUP BY Country


--Задание: 37 (Serge I: 2003-02-17)
--Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes).
;
WITH T AS (
    SELECT Class, Name
        FROM Ships
    UNION
    SELECT Ship, Ship
        FROM Outcomes)
SELECT C.Class
    FROM Classes C
             LEFT JOIN T ON C.Class = T.Class
    GROUP BY C.Class
    HAVING count(T.Name) = 1


--Задание: 41 (Serge I: 2019-05-31)
--Для каждого производителя, у которого присутствуют модели хотя бы в одной из таблиц PC, Laptop или Printer,
--определить максимальную цену на его продукцию.
--Вывод: имя производителя, если среди цен на продукцию данного производителя присутствует NULL, то выводить для этого производителя NULL,
--иначе максимальную цену.
;
WITH Cte_Maker_Model_Price AS (
    SELECT Maker, Product.Model, Price
        FROM Product
                 INNER JOIN Pc ON Product.Model = Pc.Model
    UNION
    SELECT Maker, Product.Model, Price
        FROM Product
                 INNER JOIN Laptop ON Product.Model = Laptop.Model
    UNION
    SELECT Maker, Product.Model, Price
        FROM Product
                 INNER JOIN Printer ON Product.Model = Printer.Model
)
SELECT Maker,
       CASE
           WHEN max(iif(Price IS NULL, 1, 0)) = 0
               THEN max(Price)
           END
    FROM Cte_Maker_Model_Price
    GROUP BY Maker

--Задание: 51 (Serge I: 2003-02-17)
--Найдите названия кораблей, имеющих наибольшее число орудий среди всех имеющихся кораблей такого же водоизмещения
--(учесть корабли из таблицы Outcomes).
;
WITH T1 AS (
    SELECT C.Class, S.Name, C.Numguns, C.Displacement
        FROM Classes AS C
                 INNER JOIN Ships AS S ON S.Class = C.Class
    UNION
    SELECT C.Class, Name = O.Ship, C.Numguns, C.Displacement
        FROM Classes AS C
                 INNER JOIN Outcomes AS O ON O.Ship = C.Class),
     T2 AS (
         SELECT Max_Numgums = max(Numguns), Displacement
             FROM T1
             GROUP BY Displacement)
SELECT T1.Name
    FROM T1
             INNER JOIN T2 ON T1.Displacement = T2.Displacement AND T1.Numguns = T2.Max_Numgums


--Задание: 89 (Serge I: 2012-05-04)
--Найти производителей, у которых больше всего моделей в таблице Product, а также тех, у которых меньше всего моделей.
--Вывод: maker, число моделей
;
WITH T1 AS (
    SELECT Maker, Count_Model = count(Model)
        FROM Product
        GROUP BY Maker)
SELECT*
    FROM T1
    WHERE Count_Model = (SELECT min(Count_Model)
                             FROM T1)
       OR Count_Model = (SELECT max(Count_Model)
                             FROM T1)


--Задание: 66 (Serge I: 2003-04-09)
--Для всех дней в интервале с 01/04/2003 по 07/04/2003 определить число рейсов из Rostov.
--Вывод: дата, количество рейсов
;
WITH T1 AS
         (SELECT Dataa = cast('2003-04-01' AS DATETIME)
          UNION ALL
          SELECT dateadd(DAY, 1, Dataa)
              FROM T1
              WHERE Dataa < '2003-04-07'
         )
SELECT T1.Dataa, count(DISTINCT T.Trip_No)
    FROM T1
             LEFT JOIN Pass_In_Trip AS P ON P.Date = T1.Dataa
             LEFT JOIN Trip AS T ON T.Trip_No = P.Trip_No AND T.Town_From = 'Rostov'
    GROUP BY T1.Dataa


--Задание: 133 (yuriy.rozhok: 2007-03-24)
--Пусть имеется некоторое подмножество S множества целых чисел. Назовем "горкой с вершиной N" последовательность чисел
--из S, в которой числа, меньшие N, выстроены (слева направо без разделителей) сначала возрастающей цепочкой, а потом –
--убывающей цепочкой, и значением N между ними.
--Например , для S = {1, 2, …, 10} горка с вершиной 5 представляется такой последовательностью: 123454321. При S,
--состоящем из идентификаторов всех компаний, для каждой компании построить "горку", рассматривая ее идентификатор в
--качестве вершины.
--Считать идентификаторы положительными числами и учесть, что в базе нет данных, при которых количество цифр в "горке"
--может превысить 70.
--Вывод: id_comp, "горка"
;
WITH T1 AS (
    SELECT Id = Id_Comp, Number = row_number() OVER (ORDER BY Id_Comp)
        FROM Company AS C
),
     T2 AS (
         SELECT Number, Id, Left_Hill = cast('' AS VARCHAR(8000)), Right_Hill = cast('' AS VARCHAR(8000))
             FROM T1
             WHERE Number = 1
         UNION ALL
         SELECT T1.Number, T1.Id, T2.Left_Hill + cast(T2.Id AS VARCHAR(8000)),
                cast(T2.Id AS VARCHAR(8000)) + T2.Right_Hill
             FROM T1
                      INNER JOIN T2 ON T1.Number = T2.Number + 1
     )
SELECT Id, Hill = Left_Hill + cast(Id AS VARCHAR(8000)) + Right_Hill
    FROM T2


--Задание: 61 (Serge I: 2003-02-14)
--Посчитать остаток денежных средств на всех пунктах приема для базы данных с отчетностью не чаще одного раза в день.
SELECT Remain = iif(sum(Inc) - min(Outcome) > 0, sum(Inc) - min(Outcome), 0)
    FROM Income_O,
         (SELECT Outcome = sum(Out)
              FROM Outcome_O) AS O


--Задание: 67 (Serge I: 2010-03-27)
--Найти количество маршрутов, которые обслуживаются наибольшим числом рейсов.
--Замечания.
--1) A - B и B - A считать РАЗНЫМИ маршрутами.
--2) Использовать только таблицу Trip
;
WITH T1 AS (
    SELECT Town_From, Town_To, Num = count(*)
        FROM Trip
        GROUP BY Town_From, Town_To)
SELECT count(*)
    FROM T1
    WHERE Num = (SELECT max(Num)
                     FROM T1)


--Задание: 68 (Serge I: 2010-03-27)
--Найти количество маршрутов, которые обслуживаются наибольшим числом рейсов.
--Замечания.
--1) A - B и B - A считать ОДНИМ И ТЕМ ЖЕ маршрутом.
--2) Использовать только таблицу Trip
;
WITH T1 AS (
    SELECT Town_From = iif(Town_From > Town_To, Town_From, Town_To),
           Town_To   = iif(Town_From > Town_To, Town_To, Town_From)
        FROM Trip),
     T2 AS (
         SELECT TOP 1 WITH TIES Max = count(*)
             FROM T1
             GROUP BY Town_To, Town_From
             ORDER BY count(*) DESC)
SELECT Num = count(*)
    FROM T2


--Задание: 83 (dorin_larsen: 2006-03-14)
--Определить названия всех кораблей из таблицы Ships, которые удовлетворяют, по крайней мере,
--комбинации любых четырёх критериев из следующего списка:
--numGuns = 8
--bore = 15
--displacement = 32000
--type = bb
--launched = 1915
--class=Kongo
--country=USA
SELECT Name
    FROM Ships AS S
             JOIN Classes AS Cl1 ON S.Class = Cl1.Class
    WHERE iif(Numguns = 8, 1, 0) +
          iif(Bore = 15, 1, 0) +
          iif(Displacement = 32000, 1, 0) +
          iif(Type = 'bb', 1, 0) +
          iif(Launched = 1915, 1, 0) +
          iif(S.Class = 'kongo', 1, 0) +
          iif(Country = 'usa', 1, 0) >= 4


--Задание: 88 (Serge I: 2003-04-29)
--Среди тех, кто пользуется услугами только одной компании, определить имена разных пассажиров, летавших чаще других.
--Вывести: имя пассажира, число полетов и название компании.
;
WITH T1 AS (
    SELECT Pit.Id_Psg, Count_Trip = count(T.Trip_No), Company = min(C.Name)
        FROM Trip AS T
                 INNER JOIN Pass_In_Trip AS Pit ON T.Trip_No = Pit.Trip_No
                 INNER JOIN Company AS C ON C.Id_Comp = T.Id_Comp
        GROUP BY Pit.Id_Psg
        HAVING count(DISTINCT C.Id_Comp) = 1)
SELECT P.Name, Count_Trip, T1.Company
    FROM T1
             INNER JOIN Passenger AS P ON P.Id_Psg = T1.Id_Psg
    WHERE Count_Trip = (SELECT max(Count_Trip)
                            FROM T1)

--Задание: 91 (Serge I: 2015-03-20)
--C точностью до двух десятичных знаков определить среднее количество краски на квадрате.
;
WITH T1 AS (
    SELECT Utq.Q_Id, S = sum(coalesce(Utb.B_Vol, 0))
        FROM Utq
                 LEFT JOIN Utb ON Utq.Q_Id = Utb.B_Q_Id
        GROUP BY Utq.Q_Id
)
SELECT cast(avg(cast(S AS NUMERIC(10, 2))) AS NUMERIC(10, 2))
    FROM T1

--Задание: 102 (Serge I: 2003-04-29)
--Определить имена разных пассажиров, которые летали
--только между двумя городами (туда и/или обратно).
;
WITH T1 AS (
    SELECT T.Trip_No, Town_From, Town_To, Id_Psg
        FROM Trip AS T
                 INNER JOIN Pass_In_Trip AS Pit ON Pit.Trip_No = T.Trip_No
    UNION ALL
    SELECT T.Trip_No, Town_To, Town_From, Id_Psg
        FROM Trip AS T
                 INNER JOIN Pass_In_Trip AS Pit ON Pit.Trip_No = T.Trip_No)
SELECT Name = min(Name)
    FROM T1
             INNER JOIN Passenger AS P ON P.Id_Psg = T1.Id_Psg
    GROUP BY P.Id_Psg
    HAVING count(DISTINCT Town_From) = 2
       AND count(DISTINCT Town_To) = 2


--Задание: 140 (no_more: 2017-07-07)
--Определить, сколько битв произошло в течение каждого десятилетия, начиная с даты первого сражения в базе данных и до даты последнего.
--Вывод: десятилетие в формате "1940s", количество битв.
;
WITH T1 AS (
    SELECT Years = (year(Date) / 10) * 10, Battles = count(*)
        FROM Battles
        GROUP BY (year(Date) / 10) * 10
),
     T2 AS (
         SELECT Years      = 0
                 , Buttles = 0
         UNION ALL
         SELECT Years + 10, 0
             FROM T2
             WHERE Years + 10 <= year(getdate())
     ),
     T3 AS (
         SELECT *
             FROM T1
         UNION ALL
         SELECT *
             FROM T2
     )
SELECT Years = cast(Years AS VARCHAR(4)) + 's', Buttles = sum(Battles)
    FROM T3
    WHERE Years <= (SELECT max(Years)
                        FROM T1)
      AND (Years >= (SELECT min(Years)
                         FROM T1))
    GROUP BY cast(Years AS VARCHAR(4)) + 's'
    OPTION (MAXRECURSION 0)

-- Найти число, состоящее из 10 цифр, которое можно получить если в последовательности подряд записанных натуральных чисел
-- 12345678910111213… взять число, состоящее из десяти цифр, начиная слева с цифры под номером 10000.
-- Т.е. необходимо в последовательности 12345678910111213… выбрать цифры начиная с позиции 10000 до 10009
DECLARE @A INT = 10000;
DECLARE @B INT = 10;
WITH T1 AS (
    SELECT Num  = 1,
           Strn = cast('1' AS VARCHAR(MAX))
    UNION ALL
    SELECT Num + 1,
           Strn + cast(Num + 1 AS VARCHAR(38))
        FROM T1
        WHERE len(Strn) <= @A + @B
)
SELECT substring(Strn, @A, @B)
    FROM T1
    WHERE Num = (
        SELECT max(Num)
            FROM T1
    )
    OPTION (MAXRECURSION 0)


-- Найти число, состоящее из 10 цифр, которое можно получить если в последовательности подряд записанных чисел Фибоначчи
-- 1123581321345589… взять число, состоящее из десяти цифр, начиная слева с цифры под номером 3000.
-- Т.е. необходимо в последовательности 1123581321345589… выбрать цифры начиная с позиции 3000 до 3009.
;
WITH T1 AS (
    SELECT Number = cast(1 AS DECIMAL(38, 0)),
           Pr_Fi  = cast(0 AS DECIMAL(38, 0)),
           Fi     = cast(1 AS DECIMAL(38, 0)),
           Str    = cast('' AS VARCHAR(MAX))
    UNION ALL
    SELECT Number + 1,
           Fi,
           Pr_Fi + Fi,
           [Str] + cast(Fi AS VARCHAR(MAX))
        FROM T1
        WHERE len([Str]) < 3000 + 9
)
SELECT substring([Str], 3000, 10)
    FROM T1
    WHERE Fi = (
        SELECT max(Fi)
            FROM T1
    )
    OPTION (MAXRECURSION 200)


-- Для индивидуальных покупателей (Поле PersonType из таблицы Person содержит 'IN'  –  Individual (retail) customer)
-- из штатов Texas, Alaska, Florida, Georgia, New York создать представление, содержащее имена, фамилии индивидуальных
-- покупателей и их почтовый адрес (AddressLine1, City, название штата, почтовый код
USE Adventureworks2019
DROP VIEW IF EXISTS In_Information;
GO
CREATE VIEW In_Information AS
SELECT Pers.Firstname,
       Pers.Lastname,
       Adress.Addressline1,
       Adress.City,
       State = State.Name, Adress.Postalcode
    FROM Person.Person AS Pers
             JOIN Person.Businessentityaddress AS Business
                  ON Pers.Businessentityid = Business.Businessentityid
             JOIN Person.Address AS Adress
                  ON Adress.Addressid = Business.Addressid
             JOIN Person.Stateprovince AS State
                  ON State.Stateprovinceid = Adress.Stateprovinceid
    WHERE Pers.Persontype = 'in'
      AND State.Name IN ('Alaska', 'Texas', 'Georgia', 'Florida', 'New York')


----------Контроль на рекурсивные обобщенные табличные выражения----------
USE Adventureworks2019
-- Контрольный вопрос 1.
-- Выполнить задание для базы данных AdventureWorks2019.
-- В таблице Production.Product найти самый дешевый товар с ненулевой ценой и вывести его название
-- по одному символу в строке в виде таблицы  из двух столбцов: номер символа в строке, символ.
DECLARE @Data VARCHAR(30)
SET @Data = (SELECT TOP (1) Product.Name
                 FROM Production.Product
                 WHERE Production.Product.Standardcost > 0
                 ORDER BY Production.Product.Standardcost);
WITH Resulttable AS
         (
             SELECT [UpdateText] = stuff(@Data, 1, 1, ''), Char = left(@Data, 1), Num = 1
             UNION ALL
             SELECT stuff([UpdateText], 1, 1, ''), left([UpdateText], 1), Resulttable.Num + 1
                 FROM Resulttable
                 WHERE len([UpdateText]) > 0
         )
SELECT Num, Char
    FROM Resulttable;


-- Контрольный вопрос 2.
-- Выполнить задание для базы данных AdventureWorks2019.
-- Для каждого поставщика в таблице Purchasing.Vendor вывести его номер аккаунта AccountNumber
-- и вывести столбец, в котором будут отсортированные по возрастанию символы строки AccountNumber
-- (т.е. отсортировать в пределах строки символы по алфавиту)
WITH Base AS (
    SELECT Item.[char], Pv.Accountnumber
        FROM Purchasing.Vendor AS Pv
                 CROSS APPLY (SELECT substring(Pv.Accountnumber, 1 + Number, 1) [char]
                                  FROM Master..Spt_Values --[1, 2047]
                                  WHERE Number < len(Pv.Accountnumber)
                                    AND Type = 'P'
        ) AS Item
)
SELECT DISTINCT B1.Accountnumber,
                [Sorted Account Numbers] = replace((SELECT '' + [char]
                                                        FROM Base B2
                                                        WHERE B1.Accountnumber = B2.Accountnumber
                                                        ORDER BY [char]
                                                        FOR XML PATH('')
                                                   ), '&#x20;', ' ')
    FROM Base AS B1;


----------Задания на операторы PIVOT и UNPIVOT и оконные функции----------
--Задание: 84 (Serge I: 2003-06-05)
--Для каждой компании подсчитать количество перевезенных пассажиров (если они были в этом месяце) по декадам апреля 2003.
--При этом учитывать только дату вылета.
--Вывод: название компании, количество пассажиров за каждую декаду
SELECT *
    FROM (
             SELECT Company.Name,
                    Pass_In_Trip.Id_Psg,
                    T = CASE
                            WHEN day(Date) BETWEEN 1 AND 10 THEN '1-10'
                            WHEN day(Date) BETWEEN 11 AND 20 THEN '11-20'
                            WHEN day(Date) BETWEEN 21 AND 30 THEN '21-30'
                        END
                 FROM Company
                          JOIN Trip ON Company.Id_Comp = Trip.Id_Comp
                          JOIN Pass_In_Trip ON Trip.Trip_No = Pass_In_Trip.Trip_No
                 WHERE year(Date) = 2003
                   AND month(Date) = 4
         ) AS Base
             PIVOT (
             count(Id_Psg)
             FOR T
             IN ([1-10], [11-20], [21-30])
             ) AS Ptable


--Задание: 109 (qwrqwr: 2011-01-13)
--Вывести:
--1. Названия всех квадратов черного или белого цвета.
--2. Общее количество белых квадратов.
--3. Общее количество черных квадратов.
;
WITH _Data AS
         (
             SELECT Q_Id, Q_Name, isnull([r], 0) R, isnull([g], 0) G, isnull([b], 0) B
                 FROM (
                          SELECT Q_Id, Q_Name, isnull(B_Vol, 0) B_Vol, isnull(V_Color, 'x') V_Color
                              FROM Dbo.Utv V
                                       JOIN Dbo.Utb B ON V.V_Id = B.B_V_Id
                                       RIGHT JOIN Dbo.Utq Q ON Q.Q_Id = B.B_Q_Id
                      ) T
                          PIVOT
                          (sum(B_Vol) FOR V_Color IN ([r],[g],[b])) P
         )

SELECT Q_Name,
       W_Q = (SELECT count(*)
                  FROM _Data
                  WHERE R + G + B = 255 * 3)
        ,
       B_Q = (SELECT count(*)
                  FROM _Data
                  WHERE R + G + B = 0)
    FROM _Data
    WHERE R + G + B = 255 * 3
       OR R + G + B = 0
--Второй вариант
;
WITH T1 AS (
    SELECT DISTINCT Q_Name, Paint = sum(B_Vol) OVER (PARTITION BY Q_Id)
        FROM Utb
                 RIGHT JOIN Utq
                            ON Utb.B_Q_Id = Utq.Q_Id
),

     T2 AS (
         SELECT *
             FROM T1
             WHERE Paint = 765
                OR Paint IS NULL
     )

SELECT Q_Name,
       White = (SELECT count(*)
                    FROM T2
                    WHERE Paint = 765),
       Black = (SELECT count(*)
                    FROM T2
                    WHERE Paint IS NULL)
    FROM T2


--Задание: 111 (Serge I: 2003-12-24)
--Найти НЕ белые и НЕ черные квадраты, которые окрашены разными цветами в пропорции 1:1:1. Вывод: имя квадрата,
--количество краски одного цвета
;
WITH T1 AS (
    SELECT B_Q_Id, Paint = sum(B_Vol), V_Color
        FROM Utb
                 JOIN Utv ON Utv.V_Id = Utb.B_V_Id
        GROUP BY B_Q_Id, V_Color
),

     T2 AS (
         SELECT B_Q_Id, [r], [g], [b]
             FROM T1
                      PIVOT (sum(Paint) FOR V_Color IN ([r], [g], [b])) AS Color
             WHERE R = G
               AND B = G
               AND (R + G + B <> 765)
     )

SELECT Utq.Q_Name, Qty = R
    FROM T2
             JOIN Utq ON Utq.Q_Id = T2.B_Q_Id


--Задание: 146 (Serge I: 2008-08-30)
--Для ПК с максимальным кодом из таблицы PC вывести все его характеристики (кроме кода) в два столбца:
--- название характеристики (имя соответствующего столбца в таблице PC);
--- значение характеристики
SELECT Character, Value
    FROM (
             SELECT Model = cast(Model AS VARCHAR(1000)),
                    Speed = cast(Speed AS VARCHAR(1000)),
                    Ram   = cast(Ram AS VARCHAR(1000)),
                    Hd    = cast(Hd AS VARCHAR(1000)),
                    Cd    = cast(Cd AS VARCHAR(1000)),
                    Price = cast(isnull(cast(Price AS VARCHAR(1000)), '') AS VARCHAR(1000))
                 FROM Pc
                 WHERE Code IN (SELECT max(Code)
                                    FROM Pc)
         ) T1
             UNPIVOT
             ( Value FOR Character IN (Model,Speed,Ram,Hd,Cd,Price)) AS Unpivottable


--Задание: 47 (Serge I: 2019-06-07)
--Определить страны, которые потеряли в сражениях все свои корабли.
;
WITH T1 AS (SELECT Co = count(Name), Country
                FROM (SELECT Name, Country
                          FROM Classes
                                   INNER JOIN Ships ON Ships.Class = Classes.Class
                      UNION
                      SELECT Ship, Country
                          FROM Classes
                                   INNER JOIN Outcomes ON Outcomes.Ship = Classes.Class) Fr1
                GROUP BY Country
),

     T2 AS (SELECT count(Name) AS Co, Country
                FROM (SELECT Name, Country
                          FROM Classes
                                   INNER JOIN Ships ON Ships.Class = Classes.Class
                          WHERE Name IN (SELECT DISTINCT Ship
                                             FROM Outcomes
                                             WHERE Result LIKE 'sunk')
                      UNION
                      SELECT Ship, Country
                          FROM Classes
                                   INNER JOIN Outcomes ON Outcomes.Ship = Classes.Class
                          WHERE Ship IN (SELECT DISTINCT Ship
                                             FROM Outcomes
                                             WHERE Result LIKE 'sunk')
                     ) Fr2
                GROUP BY Country)

SELECT T1.Country
    FROM T1
             INNER JOIN T2 ON T1.Co = T2.Co AND T1.Country = T2.Country


--Задание: 82 (Serge I: 2011-10-08)
--В наборе записей из таблицы PC, отсортированном по столбцу code (по возрастанию) найти среднее значение цены для
--каждой шестерки подряд идущих ПК.
--Вывод: значение code, которое является первым в наборе из шести строк, среднее значение цены в наборе.
SELECT TOP ((SELECT count(*)
                 FROM Pc) - 5) Code, Average = avg(Price) OVER (ORDER BY Code ROWS BETWEEN CURRENT ROW AND 5 FOLLOWING)
    FROM Pc
    ORDER BY Code


--Задание: 87 (Serge I: 2003-08-28)
--Считая, что пункт самого первого вылета пассажира является местом жительства, найти не москвичей, которые прилетали в
--Москву более одного раза.
--Вывод: имя пассажира, количество полетов в Москву
;
WITH T1 AS (
    SELECT DISTINCT Id_Psg,
                    Home = first_value(Town_From) OVER (PARTITION BY Id_Psg ORDER BY (Date + Time_Out -
                                                                                      cast(datefromparts(year(Time_Out), month(Time_Out), day(Time_Out))
                                                                                          AS DATETIME)))
        FROM Trip AS T
                 JOIN Pass_In_Trip AS Pt ON Pt.Trip_No = T.Trip_No
)

SELECT Name = min(Name), Trip_Count = count(*)
    FROM Pass_In_Trip AS Pt
             JOIN Trip AS T ON T.Trip_No = Pt.Trip_No
             JOIN T1
                  ON T1.Id_Psg = Pt.Id_Psg
             JOIN Passenger AS P
                  ON P.Id_Psg = T1.Id_Psg
    WHERE Town_To = 'moscow'
      AND Home <> 'moscow'
    GROUP BY T1.Id_Psg
    HAVING count(*) > 1


--Задание: 100 ($erges: 2009-06-05)
--Написать запрос, который выводит все операции прихода и расхода из таблиц Income и Outcome в следующем виде:
--дата, порядковый номер записи за эту дату, пункт прихода, сумма прихода, пункт расхода, сумма расхода.
--При этом все операции прихода по всем пунктам, совершённые в течение одного дня, упорядочены по полю code, и так же
--все операции расхода упорядочены по полю code.
--В случае, если операций прихода/расхода за один день было не равное количество, выводить NULL в соответствующих
--колонках на месте недостающих операций.
SELECT DISTINCT A.Date, A.R, B.Point, B.Inc, C.Point, C.Out
    FROM (SELECT DISTINCT Date, R = row_number() OVER (PARTITION BY Date ORDER BY Code)
              FROM Income
          UNION
          SELECT DISTINCT Date, row_number() OVER (PARTITION BY Date ORDER BY Code)
              FROM Outcome) A
             LEFT JOIN (SELECT Date, Point, Inc, Ri = row_number() OVER (PARTITION BY Date ORDER BY Code)
                            FROM Income) B ON B.Date = A.Date AND B.Ri = A.R
             LEFT JOIN (SELECT Date, Point, Out, Ro = row_number() OVER (PARTITION BY Date ORDER BY Code)
                            FROM Outcome) C ON C.Date = A.Date AND C.Ro = A.R


--Задание: 126 (Serge I: 2015-04-17)
--Для последовательности пассажиров, упорядоченных по id_psg, определить того,
--кто совершил наибольшее число полетов, а также тех, кто находится в последовательности непосредственно перед и после него.
--Для первого пассажира в последовательности предыдущим будет последний, а для последнего пассажира последующим будет первый.
--Для каждого пассажира, отвечающего условию, вывести: имя, имя предыдущего пассажира, имя следующего пассажира.
;
WITH T1 AS (
    SELECT Id_Psg, count(Trip_No) AS Qty
        FROM Pass_In_Trip AS Pt
        GROUP BY Id_Psg
),

     T2 AS (
         SELECT Id_Psg, Name,
                Previous = coalesce(lag(Id_Psg) OVER (ORDER BY Id_Psg), last_value(Id_Psg)
                                                                                   OVER (ORDER BY Id_Psg ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)),
                Next     = coalesce(lead(Id_Psg) OVER (ORDER BY Id_Psg), first_value(Id_Psg)
                                                                                     OVER (ORDER BY Id_Psg ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING))
             FROM Passenger AS P
     )

SELECT T2.Name,
       (SELECT Name
            FROM Passenger AS P
            WHERE P.Id_Psg = [previous]) AS Previous,
       (SELECT Name
            FROM Passenger AS P
            WHERE P.Id_Psg = [next])     AS Next
    FROM T1
             JOIN T2 ON T2.Id_Psg = T1.Id_Psg
    WHERE Qty = (SELECT max(Qty)
                     FROM T1)

--Задание: 147 (Serge I: 2011-02-11)
--Пронумеровать строки из таблицы Product в следующем порядке: имя производителя в порядке убывания числа производимых им моделей (при одинаковом числе моделей имя производителя в алфавитном порядке по возрастанию), номер модели (по возрастанию).
--Вывод: номер в соответствии с заданным порядком, имя производителя (maker), модель (model)

;
WITH T1 AS (
    SELECT Maker, T = count(Model)
        FROM Product
        GROUP BY Maker
)

SELECT Number = row_number() OVER (ORDER BY T DESC, T1.Maker , Model), T1.Maker, Model
    FROM Product AS P
             JOIN T1 ON T1.Maker = P.Maker


--Задание: 107 (VIG: 2003-09-01)
--Для пятого по счету пассажира из числа вылетевших из Ростова в апреле 2003 года определить компанию, номер рейса и дату вылета.
--Замечание. Считать, что два рейса одновременно вылететь из Ростова не могут.
;
WITH T1 AS (
    SELECT Number = row_number() OVER (ORDER BY (Date + Time_Out)), Id_Comp, Date, T.Trip_No
        FROM Pass_In_Trip AS Pt
                 JOIN Trip AS T ON T.Trip_No = Pt.Trip_No
        WHERE Date >= '20030401'
          AND Date <= '20030430'
          AND Town_From = 'rostov'
)
SELECT Name, Trip_No, Date
    FROM T1
             JOIN Company AS C ON C.Id_Comp = T1.Id_Comp
    WHERE Number = 5


--Задание: 137 (Serge I: 2005-01-19)
--Для каждой пятой модели (в порядке возрастания номеров
--моделей) из таблицы Product
--определить тип продукции и среднюю цену модели.
SELECT Mo.Type,
       Avg_Price = CASE
                       WHEN Mo.Type = 'pc' THEN avg(P.Price)
                       WHEN Mo.Type = 'laptop' THEN avg(Lap.Price)
                       WHEN Mo.Type = 'printer' THEN avg(Prin.Price)
           END
    FROM (SELECT Prod.Model, Prod.Type, Prod.Num
              FROM (SELECT row_number() OVER (ORDER BY Model) Num, Model, Type
                        FROM Product) AS Prod
              GROUP BY Prod.Model, Prod.Type, Prod.Num
              HAVING Num % 5 = 0) AS Mo

             LEFT JOIN Pc P ON Mo.Model = P.Model
             LEFT JOIN Laptop Lap ON Mo.Model = Lap.Model
             LEFT JOIN Printer Prin ON Mo.Model = Prin.Model

    GROUP BY Mo.Num, Mo.Type


----------Контроль на операторы CROSS APPLY, OUTER APPLY, PIVOT и UNPIVOT и оконные функции----------
--Контрольный вопрос 2
--Требуется провести синтаксический разбор IP-адреса и разместить его поля в отдельные столбцы

CREATE TABLE Custom
(
    Ip CHAR(15)
)
INSERT INTO Custom (Ip)

    VALUES ('111.22.33.44'),

           ('222.33.44.55'),

           ('333.44.55.66'),

           ('444.55.66.77');
WITH T1 AS (
    SELECT Ip, [Value], [Id] = row_number() OVER (ORDER BY Custom.[Ip])
        FROM Custom
                 CROSS APPLY string_split(Ip, '.')
)


SELECT [1], [2], [3], [4]
    FROM (
             SELECT [Ip], Value, [Newid] = row_number() OVER (PARTITION BY [Ip] ORDER BY [Id])

                 FROM [T1]) AS [A]
             PIVOT (
             max(Value)
             FOR [Newid]
             IN ([1],[2],[3],[4])) [Pvt]


--Контрольный вопрос 4.
--Выполнить задание для базы данных AdventureWorks2019. Вывести таблицу, названиями столбцов которой являют названия
--катеорий, а в строках содержаться названия подкатегорий, отсортированные по алфавиту в пределах каждой категории
;
WITH T1 AS (
    SELECT DISTINCT [Cat] = C.Name, [Subcat] = S.Name

        FROM Adventureworks2019.[Production].[ProductSubcategory] AS S

                 JOIN Adventureworks2019.Production.Productcategory AS C
                      ON [C].[ProductCategoryID] = S.[ProductCategoryID])


SELECT [Accessories], [Bikes], [Components], [Clothing]

    FROM (SELECT [Cat], [Subcat], [Tt] = row_number() OVER (PARTITION BY [Cat] ORDER BY [Subcat])

              FROM [T1]) AS [A]
             PIVOT (max([Subcat]) FOR [Cat] IN ([Accessories],[Bikes],[Components],[Clothing])) AS [Table]


----------Задания на операторы DML (INSERT, DELETE, UPDATE)----------
-- Задание: 1 (Serge I: 2004-09-08)
-- Добавить в таблицу PC следующую модель:
-- code: 20
-- model: 2111
-- speed: 950
-- ram: 512
-- hd: 60
-- cd: 52x
-- price: 1100
BEGIN TRANSACTION
INSERT INTO Product(Maker, Model, Type)
    VALUES ('A', '2111', 'PC')
INSERT INTO Pc(Code, Model, Speed, Ram, Hd, Cd, Price)
    VALUES (20, '2111', 950, 512, 60, '52x', 1100)

INSERT INTO Pc(Code, Model, Speed, Ram, Hd, Cd, Price)
SELECT 20, '2111', 950, 512, 60, '52x', 1100

SELECT *
    FROM Pc
SELECT *
    FROM Product

ROLLBACK TRANSACTION


-- Задание: 2 (Serge I: 2004-09-08)
-- Добавить в таблицу Product следующие продукты производителя Z:
-- принтер модели 4003, ПК модели 4001 и блокнот модели 4002
BEGIN TRANSACTION

INSERT INTO Product(Maker, Model, Type)
    VALUES ('Z', '4003', 'Printer')
         , ('Z', '4001', 'PC')
         , ('Z', '4002', 'Laptop')


INSERT INTO Product(Maker, Model, Type)
SELECT 'Z', '4003', 'Printer'
UNION ALL
SELECT 'Z', '4001', 'PC'
UNION ALL
SELECT 'Z', '4002', 'Laptop'

ROLLBACK TRANSACTION

-- Задание: 3 (Serge I: 2004-09-08)
-- Добавить в таблицу PC модель 4444 с кодом 22, имеющую скорость процессора 1200 и цену 1350.
-- Отсутствующие характеристики должны быть восполнены значениями по умолчанию, принятыми для соответствующих столбцов.
BEGIN TRANSACTION
INSERT INTO Pc (Model, Code, Speed, Price)
    VALUES ('4444', 22, 1200, 1350)

INSERT INTO Pc(Code, Model, Speed, Ram, Hd, Cd, Price)
    VALUES (22, '4444', 1200, default, default, default, 1350)

ROLLBACK TRANSACTION

-- Задание: 4 (Serge I: 2004-09-08)
-- Для каждой группы блокнотов с одинаковым номером модели добавить запись в таблицу PC со следующими характеристиками:
-- код: минимальный код блокнота в группе +20;
-- модель: номер модели блокнота +1000;
-- скорость: максимальная скорость блокнота в группе;
-- ram: максимальный объем ram блокнота в группе *2;
-- hd: максимальный объем hd блокнота в группе *2;
-- cd: значение по умолчанию;
-- цена: максимальная цена блокнота в группе, уменьшенная в 1,5 раза.
-- Замечание. Считать номер модели числом.
BEGIN TRANSACTION

INSERT INTO Pc (Code, Model, Speed, Ram, Hd, Price)
SELECT min(Code) + 20
        , Model + 1000
        , max(Speed)
        , max(Ram) * 2
        , max(Hd) * 2
        , max(Price) / 1.5
    FROM Laptop
    GROUP BY Model

ROLLBACK TRANSACTION


-- Задание: 5 (Serge I: 2004-09-08)
-- Удалить из таблицы PC компьютеры, имеющие минимальный объем диска или памяти.
DELETE
    FROM Pc
    WHERE Hd = (SELECT min(Hd)
                    FROM Pc
    )
       OR Ram = (SELECT min(Ram)
                     FROM Pc)


-- Задание: 6 (Serge I: 2004-09-08)
-- Удалить все блокноты, выпускаемые производителями, которые не выпускают принтеры.
BEGIN TRANSACTION

WITH T1 AS (
    SELECT Model
        FROM Product
        WHERE [type] = 'Laptop'
          AND Maker NOT IN (SELECT Maker
                                FROM Product
                                WHERE [type] = 'Printer')
)
DELETE
    FROM Laptop
    WHERE Model IN (SELECT *
                        FROM T1)
SELECT *
    FROM Laptop

ROLLBACK TRANSACTION

-- Задание: 7 (Serge I: 2004-09-08)
-- Производство принтеров производитель A передал производителю Z. Выполнить соответствующее изменение.
BEGIN TRANSACTION

UPDATE Product
SET Maker = 'Z'
    WHERE Maker = 'A'
      AND Type = 'printer'

SELECT *
    FROM Product

ROLLBACK TRANSACTION

-- Задание: 8 (Serge I: 2004-09-08)
-- Удалите из таблицы Ships все корабли, потопленные в сражениях.
BEGIN TRANSACTION

DELETE
    FROM Ships
    WHERE Name IN (SELECT Name
                       FROM Ships AS S,
                            Outcomes AS O
                       WHERE S.Name = O.Ship
                         AND Result = 'sunk')
SELECT *
    FROM Ships

ROLLBACK TRANSACTION

-- Задание: 9 (Serge I: 2004-09-08)
-- Измените данные в таблице Classes так, чтобы калибры орудий измерялись в
-- сантиметрах (1 дюйм=2,5см), а водоизмещение в метрических тоннах (1
-- метрическая тонна = 1,1 тонны). Водоизмещение вычислить с точностью до
-- целых.
BEGIN TRANSACTION
UPDATE Classes
SET Bore=Bore * 2.5, Displacement= round(Displacement / 1.1, 0)

SELECT *
    FROM Classes

ROLLBACK TRANSACTION


-- Задание: 10 (Serge I: 2004-09-09)
-- Добавить в таблицу PC те модели ПК из Product, которые отсутствуют в таблице PC.
-- При этом модели должны иметь следующие характеристики:
-- 1. Код равен номеру модели плюс максимальный код, который был до вставки.
-- 2. Скорость, объем памяти и диска, а также скорость CD должны иметь максимальные характеристики среди всех имеющихся
-- в таблице PC.
-- 3. Цена должна быть средней среди всех ПК, имевшихся в таблице PC до вставки.
BEGIN TRANSACTION

INSERT INTO Pc (Code, Model, Speed, Ram, Hd, Cd, Price)
SELECT (SELECT max(P.Code)
            FROM Pc AS P) + Model,
       Model,
       (SELECT max(P.Speed)
            FROM Pc AS P),
       (SELECT max(P.Ram)
            FROM Pc AS P),
       (SELECT max(P.Hd)
            FROM Pc AS P),
       cast((SELECT max(cast(left(Cd, len(Cd) - 1) AS INT))
                 FROM Pc) AS VARCHAR(30)) + 'x',
       (SELECT avg(P.Price)
            FROM Pc AS P)
    FROM Product
    WHERE Type = 'pc'
      AND Model NOT IN (SELECT Model
                            FROM Pc)

SELECT *
    FROM Pc

SELECT *
    FROM Product

ROLLBACK TRANSACTION

-- Задание: 11 (Serge I: 2004-09-09)
-- Для каждой группы блокнотов с одинаковым номером модели добавить запись в таблицу PC со следующими характеристиками:
-- код: минимальный код блокнота в группе +20;
-- модель: номер модели блокнота +1000;
-- скорость: максимальная скорость блокнота в группе;
-- ram: максимальный объем ram блокнота в группе *2;
-- hd: максимальный объем hd блокнота в группе *2;
-- cd: cd c максимальной скоростью среди всех ПК;
-- цена: максимальная цена блокнота в группе, уменьшенная в 1,5 раза
BEGIN TRANSACTION

INSERT INTO Pc (Code, Model, Speed, Ram, Hd, Cd, Price)
SELECT min(Code) + 20, cast(Model AS INTEGER) + 1000, max(Speed), max(Ram) * 2, max(Hd) * 2,
       cast((SELECT max(cast(left(Cd, len(Cd) - 1) AS INT))
                 FROM Pc) AS VARCHAR(30)) + 'x', max(Price) / 1.5
    FROM Laptop
    GROUP BY Model

SELECT *
    FROM Pc

ROLLBACK TRANSACTION

-- Задание: 12 (Serge I: 2004-09-09)
-- Добавьте один дюйм к размеру экрана каждого блокнота,
-- выпущенного производителями E и B, и уменьшите его цену на $100.
BEGIN TRANSACTION

UPDATE Laptop
SET Screen = Screen + 1, Price = Price - 100
    WHERE Model IN (SELECT Model
                        FROM Product
                        WHERE Maker = 'E'
                           OR Maker = 'B')

SELECT *
    FROM Laptop

SELECT *
    FROM Product

ROLLBACK TRANSACTION


-- Задание: 13 (Serge I: 2004-09-09)
-- Ввести в базу данных информацию о том, что корабль Rodney был потоплен в битве, произошедшей 25/10/1944,
-- а корабль Nelson поврежден - 28/01/1945.
-- Замечание: считать, что дата битвы уникальна в таблице Battles.

BEGIN TRANSACTION

INSERT INTO Outcomes(Ship, Battle, Result)
    VALUES ('Rodney',
            (SELECT Name
                 FROM Battles
                 WHERE Date = '1944-10-25 00:00:00'), 'sunk'),
           ('Nelson',
            (SELECT Name
                 FROM Battles
                 WHERE Date = '1945-01-28 00:00:00'), 'damaged')

SELECT *
    FROM Outcomes

SELECT *
    FROM Battles

ROLLBACK TRANSACTION


-- Задание: 14 (Serge I: 2004-09-09)
-- Удалите классы, имеющие в базе данных менее трех кораблей (учесть корабли из Outcomes).
BEGIN TRANSACTION

DELETE
    FROM Classes
    WHERE Class NOT IN (SELECT Class
                            FROM (SELECT Class
                                      FROM Ships

                                  UNION ALL

                                  SELECT DISTINCT Ship
                                      FROM Outcomes
                                      WHERE Ship NOT IN (SELECT Name
                                                             FROM Ships)) AS X
                            GROUP BY Class
                            HAVING count(*) >= 3)

SELECT *
    FROM Outcomes

SELECT *
    FROM Classes

SELECT *
    FROM Ships

ROLLBACK TRANSACTION

-- Задание: 15 (Serge I: 2009-06-05)
-- Из каждой группы ПК с одинаковым номером модели в таблице PC удалить все строки кроме строки с наибольшим для этой
-- группы кодом (столбец code).
BEGIN TRANSACTION

DELETE
    FROM Pc
    WHERE Code NOT IN (SELECT max(Code)
                           FROM Pc
                           GROUP BY Model)
SELECT *
    FROM Pc

ROLLBACK TRANSACTION

-- Задание: 16 (Serge I: 2004-09-09)
-- Удалить из таблицы Product те модели, которые отсутствуют в других таблицах.
BEGIN TRANSACTION

DELETE
    FROM Product
    WHERE Product.Model NOT IN (
        SELECT Model
            FROM Pc

        UNION

        SELECT Model
            FROM Laptop

        UNION

        SELECT Model
            FROM Printer
            GROUP BY Model
    )

SELECT *
    FROM Pc

SELECT *
    FROM Printer

SELECT *
    FROM Product

ROLLBACK TRANSACTION


-- Задание: 17 (Serge I: 2017-04-14)
-- Удалить из таблицы PC компьютеры, у которых величина hd попадает в тройку наименьших значений.
BEGIN TRANSACTION

DELETE
    FROM Pc
    WHERE Hd IN (
        SELECT TOP 3 Hd
            FROM (
                     SELECT DISTINCT Hd
                         FROM Pc
                 ) AS T1
            ORDER BY Hd
    )

SELECT *
    FROM Pc

ROLLBACK TRANSACTION
