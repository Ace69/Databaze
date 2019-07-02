--------------------------------Zruseni tabulek
DROP SEQUENCE platba_gen;
DROP MATERIALIZED VIEW mv;
DROP TABLE Objednani_sluzby;
DROP TABLE Sluzba;
DROP TABLE Platba;
DROP TABLE Rezervace_pokoje;
DROP TABLE Zakaznik;
DROP TABLE Pokoj;

--------------------------------Inicializace tabulek
CREATE TABLE Pokoj(
cislo_pokoje INT PRIMARY KEY,
patro INT CHECK (patro > 0),
kapacita INT CHECK (kapacita > 0),
typ VARCHAR(10) CHECK(typ IN ('VIP', 'Standard'))
);


CREATE TABLE Zakaznik(
rodne_cislo VARCHAR(10) PRIMARY KEY,                                     
jmeno VARCHAR(20),
prijmeni VARCHAR(20),
datum_narozeni DATE,
ulice VARCHAR(40),
mesto VARCHAR(40),
psc INT,
email VARCHAR(40),
pohlavi VARCHAR(5) CHECK (pohlavi IN ('Muž', 'Žena'))
);


CREATE TABLE Rezervace_pokoje(
id_rezervace NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
cislo_pokoje NUMBER NOT NULL,
rodne_cislo VARCHAR(10) NOT NULL,
od_kdy DATE,
do_kdy DATE,
typ_penze VARCHAR(20) CHECK(typ_penze IN ('Plná penze', 'Polopenze', 'All-inclusive')),
FOREIGN KEY(cislo_pokoje) REFERENCES Pokoj(cislo_pokoje),
FOREIGN KEY(rodne_cislo) REFERENCES Zakaznik(rodne_cislo)
);
  
  
CREATE TABLE Platba(
id_platba NUMBER PRIMARY KEY,
id_rezervace NUMBER NOT NULL,
typ VARCHAR(10) CHECK(typ IN ('Hotovì', 'Kartou')),
datum_uhrazeni DATE,
castka NUMBER CHECK (castka > 0),
FOREIGN KEY(id_rezervace) REFERENCES Rezervace_pokoje(id_rezervace)
);                      

CREATE TABLE Sluzba(
id_sluzba NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
typ VARCHAR(20),
cena NUMBER CHECK (cena > 0)
);

CREATE TABLE Objednani_sluzby(
id_sluzba NUMBER NOT NULL,
id_rezervace NUMBER NOT NULL,
FOREIGN KEY(id_sluzba) REFERENCES Sluzba(id_sluzba),
FOREIGN KEY(id_rezervace) REFERENCES Rezervace_pokoje(id_rezervace)
);




--------------------------------------------------- Trigger na automaticke doplneni hodnoty ze sekvence v pripade vlozeni NULL
CREATE SEQUENCE platba_gen
START WITH 1
INCREMENT BY 1
NOCYCLE;


CREATE OR REPLACE TRIGGER autoincrement
  BEFORE INSERT ON Platba
  FOR EACH ROW
  WHEN (NEW.id_platba IS NULL)
BEGIN
  :new.id_platba := platba_gen.nextval;
END;
/





--------------------------------Naplneni tabulek hodnotami
 --Tabulka Pokoj
INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('100', '1','3', 'Standard');
INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('110', '1','2', 'VIP');
INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('120', '1','1', 'Standard');
INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('125', '1','3', 'VIP');
INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('135', '1','2', 'Standard');

INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('225', '2','3', 'VIP');
INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('215', '2','2', 'VIP');
INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('220', '2','1', 'Standard');
INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('210', '2','3', 'Standard');
INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('240', '2','2', 'Standard');

INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('300', '3','3', 'VIP');
INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('310', '3','2', 'VIP');
INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('315', '3','1', 'Standard');
INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('320', '3','3', 'VIP');
INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('330', '3','2', 'Standard');

INSERT INTO Pokoj(cislo_pokoje, patro, kapacita, typ) VALUES ('420', '4','1', 'Standard');

--Tabulka Zakaznik
INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('2107691201','Josef','Novotný', DATE '1969-07-21', 'Horní 321', 'Jihlava', '58601', 'josef.nov@seznam.cz', 'Muž');
INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('0702881201', 'Martin','Èech', DATE '1988-02-07', 'Sokolská 18', 'Brno', '60200', 'cech_martin18@seznam.cz', 'Muž');
INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('1011951201', 'Lukáš','Èerný', DATE'1995-11-01', 'Božetìchova 70', 'Brno', '61400', 'lukas_cerny@gmail.com', 'Muž');
INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('3158011201', 'Anna','Novotná', DATE '2001-08-31', 'Dolní 101', 'Velké Meziøíèí', '59401', 'anna.nov@seznam.cz', 'Žena');
INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('2412921201', 'Karel','Starý', DATE '1992-12-24', 'Demlova 52', 'Jihlava', '58601', 'stary.karel@centrum.cz', 'Muž');

INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('0202781201', 'Jakub','Hoøejší', DATE '1978-02-02', 'Zachova 1504', 'Praha 4', '14000', 'hor_jakub1978@seznam.cz', 'Muž');
INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('1553751201', 'Ilona','Votavová', DATE '1975-03-15', 'Na Kopci 124', 'Jihlava', '58601', 'votav12345@gmail.com', 'Žena');
INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('0410591201', 'Petr','Nový', DATE '1959-04-10', 'Demlova 515', 'Jihlava', '58601', 'petr12@seznam.cz', 'Muž');
INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('2152721201', 'Karolína','Chvátalová', DATE '1972-02-21', 'Hradecká 780', 'Plzeò', '31200', 'chvatalova1972@gmail.com', 'Žena');
INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('1860001201', 'Jiøina','Pokorná', DATE '2000-10-18', 'Vlkova 120', 'Praha 4', '14000', 'jir_pok00@centrum.cz', 'Žena');

INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('2455901201', 'Kateøina','Svobodová', DATE '1990-05-24', 'Lužická 2', 'Praha 2', '12000', 'svob123@seznam.cz', 'Žena');
INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('2152621201', 'Pavlína','Hrušková', DATE '1962-02-21', 'Hradecká 70', 'Plzeò', '31200', 'hrusk14@gmail.com', 'Žena');
INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('0209981201', 'Zdenìk','Svoboda', DATE '1981-09-02', 'Lužická 2', 'Praha 2', '12000', 'zdenda_svob@seznam.cz', 'Muž');
INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('1210881201', 'Stanislav','Novotný', DATE '1988-10-12', 'Hruškové Sady 200', 'Jihlava', '58601', 'novotny988@gmail.com', 'Muž');
INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('2908891201', 'Tomáš','Soška', DATE '1989-08-29', 'Lužická 2', 'Praha 2', '12000', 'sostom@seznam.cz', 'Muž');

INSERT INTO Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('0151991201', 'Lada','Salátová', DATE '1999-01-01', 'Srázná 23', 'Jihlava', '58601', 'salat40@centrum.cz', 'Žena');

--Tabulka Sluzba
INSERT INTO Sluzba(Typ, Cena) VALUES ('Snídanì na pokoj', '100');
INSERT INTO Sluzba(Typ, Cena) VALUES ('Alkohol na pokoj', '800');
INSERT INTO Sluzba(Typ, Cena) VALUES ('Úklidové služby', '200');

--Vztahova tabulka mezi tabulkami Pokoj a Zakaznikem
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('100','2107691201',DATE'2018-5-3',DATE'2018-5-5', 'Plná penze');
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('110','0702881201',DATE'2018-2-20',DATE'2018-2-25', 'All-inclusive');
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('120','1011951201',DATE'2018-5-10',DATE'2018-5-13', 'Polopenze');        --Lukáš Èerný
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('125','3158011201',DATE'2018-5-25',DATE'2018-5-30', 'Plná penze');
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('135','2412921201',DATE'2018-3-1',DATE'2018-3-4', 'Plná penze');

INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('225','0202781201',DATE'2018-2-20',DATE'2018-2-23', 'Plná penze');
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('215','1553751201',DATE'2018-5-1',DATE'2018-5-4', 'Plná penze');
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('220','0410591201',DATE'2018-8-18',DATE'2018-8-21', 'Plná penze');
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('210','2152721201',DATE'2018-5-10',DATE'2018-5-13', 'Polopenze');
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('240','1860001201',DATE'2018-1-1',DATE'2018-1-4', 'All-inclusive');

INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('300','2455901201',DATE'2018-1-11',DATE'2018-1-14', 'All-inclusive');
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('310','2152621201',DATE'2018-8-3',DATE'2018-8-6', 'Plná penze');
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('315','0209981201',DATE'2018-4-1',DATE'2018-4-4', 'Plná penze');
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('320','1210881201',DATE'2018-3-5',DATE'2018-3-7', 'Polopenze');
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('330','2908891201',DATE'2018-8-9',DATE'2018-8-13', 'All-inclusive');   
 
--Rezervace v roce 2019                                                                                                                                                                    
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('420','0151991201',DATE'2019-1-1',DATE'2019-1-8', 'All-inclusive');    
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('110','1011951201',DATE'2019-3-20',DATE'2019-3-26', 'Polopenze');     --Lukáš Èerný  - Aby nekdo mel rezervaci vicekrat                                                                                                                                  
INSERT INTO Rezervace_pokoje (cislo_pokoje, rodne_cislo, od_kdy, do_kdy, typ_penze) VALUES ('300','1011951201',DATE'2019-4-14',DATE'2019-4-21', 'Plná penze');    --Testovani current_date



--Tabulka Platba
INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('1', 'Hotovì', '30.5.2018','1500');
INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('2','Hotovì', '20.2.2018','1500');
INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('3', 'Hotovì', '10.5.2018','2000');
INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('4', 'Hotovì', '25.1.2018','1300');
INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('5', 'Hotovì', '1.3.2018','2000');

INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('6', 'Kartou', '20.2.2018','1500');
INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('7', 'Kartou', '1.5.2018','1100');
INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('8', 'Kartou', '15.8.2018','1200');
INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('9', 'Kartou', '10.5.2018','3500');
INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('10', 'Kartou', '1.1.2018','2200');

INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('11', 'Kartou', '1.11.2018','1500');
INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('12', 'Kartou', '3.8.2018','3652');
INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('13', 'Hotovì', '1.4.2018','1930');
INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('14', 'Hotovì', '5.3.2018','1980');
INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('15', 'Kartou', '9.2.2018','1550');

INSERT INTO Platba (id_rezervace, typ, datum_uhrazeni, castka) VALUES ('16', 'Hotovì', '4.2.1420','420');

--Vztahova tabulka mezi tabulkami Sluzba a Rezervace
INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('2','1');          --Upraveno aby Josef Novotny mel 3x objednanou sluzbu
INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('2','1');          --A zaroven ji maji vsichni krome Martin Èech a Lukáš Èerný - id_rezervace 2 a 3
INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('2','1');
INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('1','4');
INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('2','5');

INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('3','6');
INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('1','7');
INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('2','8');
INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('3','9');
INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('1','10');

INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('2','11');
INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('3','12');
INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('2','13');
INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('1','14');
INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('2','15');

INSERT INTO Objednani_sluzby (id_sluzba, id_rezervace) VALUES ('3','16');



--------------------------------SQL DOTAZY

--POŽADAVKY ZADÁNÍ
--dva dotazy využívající spojení dvou tabulek,
--jeden využívající spojení tøí tabulek
--dva dotazy s klauzulí GROUP BY a agregaèní funkcí
--jeden dotaz obsahující predikát EXISTS
--jeden dotaz s predikátem IN s vnoøeným selectem (nikoliv IN s množinou konstantních dat)
--U každého z dotazù musí být (v komentáøi SQL kódu) popsáno srozumitelnì, jaká data hledá daný dotaz (jaká je jeho funkce v aplikaci).




----------------------------------------------------------------Dotazy spojujici 2 tabulky

--Vsichni zakaznici kteri nejake urcite datum nastupuji na hotel
SELECT Zakaznik.Rodne_cislo, Zakaznik.Jmeno, Zakaznik.Prijmeni FROM Zakaznik 
INNER JOIN  Rezervace_pokoje ON Zakaznik.rodne_cislo = Rezervace_pokoje.rodne_cislo 
WHERE Rezervace_pokoje.od_kdy = DATE '2019-4-14';

-- Vybere vsechny zakazniky, kteri maji typ penze 'All-inclusive'
SELECT Zakaznik.JMENO, Zakaznik.PRIJMENI
FROM Zakaznik
INNER JOIN Rezervace_pokoje ON Rezervace_pokoje.rodne_cislo = Zakaznik.rodne_cislo
WHERE Rezervace_pokoje.typ_penze = 'All-inclusive';


----------------------------------------------------------------Dotazy spojujici 3 a vice tabulek

--Vsichni zakaznici kartou a zaplatili 1500 a vice korun
SELECT Zakaznik.JMENO, Zakaznik.PRIJMENI
FROM Zakaznik
INNER JOIN Rezervace_pokoje ON Rezervace_pokoje.rodne_cislo = Zakaznik.rodne_cislo
INNER JOIN Platba ON Platba.id_rezervace = Rezervace_pokoje.id_rezervace
WHERE Platba.Typ IN(
SELECT PLATBA.Typ
FROM Platba
WHERE Platba.Typ = 'Kartou'
) 
AND Platba.Castka IN (
SELECT PLATBA.Castka
FROM Platba
WHERE Platba.Castka >= '1500'
); 

-- Vyber vsechny zakazniky, ktery si objednali sluzbu alespon za 200kc
SELECT DISTINCT Zakaznik.JMENO, Zakaznik.PRIJMENI
FROM Zakaznik
INNER JOIN Rezervace_pokoje ON Rezervace_pokoje.rodne_cislo = Zakaznik.rodne_cislo
INNER JOIN  Objednani_sluzby ON Objednani_sluzby.id_rezervace = Rezervace_pokoje.id_rezervace
INNER JOIN Sluzba ON Sluzba.id_sluzba = Objednani_sluzby.id_sluzba
WHERE Sluzba.cena >= '200';



----------------------------------------------------------------Dotazy obsahující GROUP BY a agregaèní funkci
-- Pocet pokoju co jsou VIP/Standard
SELECT SUM(COUNT(cislo_pokoje)) FROM Pokoj 
WHERE typ = 'VIP' 
GROUP BY cislo_pokoje;

SELECT SUM(COUNT(cislo_pokoje)) FROM Pokoj 
WHERE typ = 'Standard' 
GROUP BY cislo_pokoje;

--Pocet lidi co byli ubytovani v roce 2018
SELECT SUM(COUNT(Zakaznik.rodne_cislo)) FROM Zakaznik 
JOIN Rezervace_pokoje ON Zakaznik.rodne_cislo = Rezervace_pokoje.rodne_cislo
WHERE Rezervace_pokoje.od_kdy BETWEEN DATE '2018-1-1' AND DATE '2018-12-31' AND Rezervace_pokoje.do_kdy BETWEEN DATE '2018-1-1' AND DATE '2018-12-31'
GROUP BY Zakaznik.rodne_cislo;



----------------------------------------------------------------Dotazy obsahujici EXISTS
--Pocet lidi co si objednalo All-inclusive
SELECT COUNT(*) FROM Zakaznik 
WHERE EXISTS (SELECT * FROM Rezervace_pokoje
WHERE  Zakaznik.rodne_cislo = Rezervace_pokoje.rodne_cislo AND Rezervace_pokoje.typ_penze = 'All-inclusive');


--Zakaznici co nebyli ubytovani v roce 2018
SELECT Jmeno, Prijmeni FROM Zakaznik 
WHERE NOT EXISTS (SELECT * FROM Rezervace_pokoje
WHERE  Zakaznik.rodne_cislo = Rezervace_pokoje.rodne_cislo AND Rezervace_pokoje.od_kdy BETWEEN DATE '2018-1-1' AND DATE '2018-12-31' AND Rezervace_pokoje.do_kdy BETWEEN DATE '2018-1-1' AND DATE '2018-12-31');


--Lide kteri si nikdy neobjednali jakoukoliv sluzbu
SELECT DISTINCT Jmeno, Prijmeni FROM Zakaznik
NATURAL JOIN Rezervace_pokoje
WHERE NOT EXISTS (SELECT * FROM Objednani_sluzby
WHERE Objednani_sluzby.id_rezervace = Rezervace_pokoje.id_rezervace);



----------------------------------------------------------------PROCEDURY

--vytvoøení alespoò DVOU netriviálních uložených procedur vè. jejich pøedvedení, ve kterých se musí (dohromady) vyskytovat alespoò 
--jednou kurzor, 
--ošetøení výjimek a 
--použití promìnné s datovým typem odkazujícím se na øádek èi typ sloupce tabulky (table_name.column_name%TYPE nebo table_name%ROWTYPE),
 

 ---------POVOLENI VYPISU
--SET SERVEROUTPUT ON;        

--Procedura zjisti kolik bylo zarezervovanych pokoju v danem obdobi                         
CREATE OR REPLACE PROCEDURE pocet_rezervaci_v_obdobi(od_kdy Rezervace_pokoje.od_kdy%TYPE, do_kdy Rezervace_pokoje.od_kdy%TYPE) AS
CURSOR kurzor_aktualni_rezervace IS SELECT * FROM Rezervace_pokoje WHERE Rezervace_pokoje.od_kdy BETWEEN pocet_rezervaci_v_obdobi.od_kdy AND pocet_rezervaci_v_obdobi.do_kdy;
celkovy_pocet NUMBER;
aktualni_rezervace kurzor_aktualni_rezervace%ROWTYPE;
BEGIN
    celkovy_pocet := 0;
    OPEN kurzor_aktualni_rezervace;
    LOOP
        FETCH kurzor_aktualni_rezervace INTO aktualni_rezervace;
        EXIT WHEN kurzor_aktualni_rezervace%NOTFOUND;
        celkovy_pocet := celkovy_pocet + 1; 
    END LOOP;
    IF celkovy_pocet = 0 THEN
        dbms_output.put_line('V zadanem obdobi nebyl rezervovan zadny pokoj.');
    ELSIF celkovy_pocet = 1 THEN
        dbms_output.put_line('V zadanem obdobi byl rezervovan ' || celkovy_pocet || ' pokoj.');
    ELSIF celkovy_pocet > 1 AND celkovy_pocet < 5 THEN
        dbms_output.put_line('V zadanem obdobi byly rezervovan ' || celkovy_pocet || ' pokoje.');
    ELSE
        dbms_output.put_line('V zadanem obdobi bylo rezervovano ' || celkovy_pocet || ' pokoju.');
    END IF;
    CLOSE kurzor_aktualni_rezervace;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('EXCEPTION: V zadanem obdobi nebyl rezervovan zadny pokoj.');
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'Neocekavana chyba procedury!');
END pocet_rezervaci_v_obdobi;
/



--Procedura zjisti ktera sluzba byla nejvicekrat objednana
CREATE OR REPLACE PROCEDURE nejoblibenejsi_sluzba AS
CURSOR kurzor IS SELECT id_sluzba FROM Objednani_sluzby;
pocet_snidane NUMBER;
pocet_alkohol NUMBER;
pocet_uklid NUMBER;
maximum NUMBER;
aktualni_sluzba Objednani_sluzby.id_sluzba%TYPE;
BEGIN
    pocet_snidane := 0;
    pocet_alkohol := 0;
    pocet_uklid := 0;
    OPEN kurzor;
    LOOP
        FETCH kurzor INTO aktualni_sluzba;
        EXIT WHEN kurzor%NOTFOUND;
        
        IF aktualni_sluzba = 1 THEN         --SNIDANE NA POKOJ
           pocet_snidane := pocet_snidane + 1;
        ELSIF aktualni_sluzba = 2 THEN      --ALKOHOL NA POKOJ
            pocet_alkohol := pocet_alkohol + 1;
        ELSIF aktualni_sluzba = 3 THEN      --UKLID POKOJE
            pocet_uklid := pocet_uklid + 1;
        END IF;
    END LOOP;
    CLOSE kurzor;
    
    IF (pocet_snidane = pocet_alkohol) OR (pocet_snidane = pocet_uklid) OR (pocet_alkohol = pocet_uklid) THEN  --nektere hodnoty se rovnaji
        IF (pocet_snidane = pocet_alkohol) AND (pocet_snidane = pocet_uklid) THEN   --vsechny hodnoty se rovnaji
            dbms_output.put_line('Vsechny sluzby jsou stejne oblibene.');
        ELSIF (pocet_snidane = pocet_alkohol) THEN            --SNIDANE a ALKOHOL na pokoj se rovnaji
            IF (pocet_uklid > pocet_snidane) THEN   --uklid je nejoblibenejsi
                dbms_output.put_line('Nejoblibenejsi sluzba je uklid pokoje. Pocet objednani je: ' || pocet_uklid);    
            ELSE
                dbms_output.put_line('Sluzby snidane na pokoj a alkohol na pokoj maji stejny pocet objednani. Pocet objedani je: ' || pocet_snidane);
            END IF;
        ELSIF (pocet_snidane = pocet_uklid) THEN        --SNIDANE a UKLID se rovnaji
            IF pocet_alkohol > pocet_snidane  THEN   --alkohol je nejoblibenejsi
                dbms_output.put_line('Nejoblibenejsi sluzba je alkohol na pokoj. Pocet objednani je: ' || pocet_alkohol);
            ELSE
                dbms_output.put_line('Sluzby snidane na pokoj a uklid pokoje maji stejny pocet objednani. Pocet objedani je: ' || pocet_snidane);
            END IF;
        ELSE        --ALKOHOL a UKLID se rovnaji
            IF pocet_snidane > pocet_alkohol THEN   --snidane je nejoblibenejsi
                dbms_output.put_line('Nejoblibenejsi sluzba je snidane na pokoj. Pocet objednani je: ' || pocet_snidane);
            ELSE
                dbms_output.put_line('Sluzby alkohol na pokoj a uklid pokoje maji stejny pocet objednani. Pocet objedani je: ' || pocet_alkohol);
            END IF;
        END IF;
    ELSE           --zadna hodnota se nerovna    
        IF pocet_snidane > pocet_alkohol THEN       --alkohol nemuze byt nejoblibenejsi
            IF pocet_snidane > pocet_uklid THEN   --snidane je nejoblibenejsi
                dbms_output.put_line('Nejoblibenejsi sluzba je snidane na pokoj. Pocet objednani je: ' || pocet_snidane);
            ELSE    --uklid je nejoblibenejsi
                dbms_output.put_line('Nejoblibenejsi sluzba je uklid pokoje. Pocet objednani je: ' || pocet_uklid);
            END IF;
        ELSIF pocet_alkohol > pocet_uklid THEN   --alkohol je nejoblibenejsi
            dbms_output.put_line('Nejoblibenejsi sluzba je alkohol na pokoj. Pocet objednani je: ' || pocet_alkohol);
        ELSE --uklid je nejoblibenejsi
            dbms_output.put_line('Nejoblibenejsi sluzba je uklid pokoje. Pocet objednani je: ' || pocet_uklid);
        END IF;
    END IF; 
END nejoblibenejsi_sluzba;
/




------------------------------------------------------- TRIGGERY

--Trigger na kontrolu rodneho cisla
create or replace TRIGGER Rcislo
BEFORE INSERT OR UPDATE OF RODNE_CISLO ON ZAKAZNIK
FOR EACH ROW
BEGIN
    IF NOT regexp_like(:NEW.RODNE_CISLO, '^[^a-zA-Z]*$') THEN
        RAISE_APPLICATION_ERROR(-20000, 'V rodnem cisle se nesmi vyskytovat jine znaky nez cislice'); -- Osetreni, zda rodne cislo obsahuje pouze cislice
    END IF;
    IF (LENGTH(:NEW.RODNE_CISLO)=10 AND MOD(CAST(:NEW.RODNE_CISLO AS INT) , 11) != 0) THEN -- overime, zda modulo 11 vychazi cele cislo, plati pro osoby narozene po roce 1954
        RAISE_APPLICATION_ERROR(-20001, 'Modulo rodneho cisla se nerovna 11'); -- cislovani vyjimek startuje na 20,000
    END IF;
    IF ((CAST(SUBSTR(:NEW.RODNE_CISLO,1,2)AS INT) NOT BETWEEN 00 AND 19) AND (CAST(SUBSTR(:NEW.RODNE_CISLO,1,2)AS INT) NOT BETWEEN 30 AND 99) -- ROK: Bereme v uvahu osoby narozene po roce 1930 az do soucasnosti
            OR (CAST(SUBSTR(:NEW.RODNE_CISLO,3,2)AS INT) NOT BETWEEN 1 AND 12 AND CAST(SUBSTR(:NEW.RODNE_CISLO,3,2)AS INT) NOT BETWEEN 21 AND 32) AND (CAST(SUBSTR(:NEW.RODNE_CISLO,3,2)AS INT) NOT BETWEEN 51 AND 62 AND CAST(SUBSTR(:NEW.RODNE_CISLO,3,2)AS INT) NOT BETWEEN 71 AND 82) -- MESIC: prvni je muz, druhy zena(pricte se 50)
            OR (CAST(SUBSTR(:NEW.RODNE_CISLO,5,2)AS INT) NOT BETWEEN 1 AND 31)) -- DEN: 
            THEN 
        RAISE_APPLICATION_ERROR(-20002, 'Spatny format cisli rodneho cisla'); --
    END IF;

END;
/


  
----------------------------------------------------------------NASTAVENI OPRAVNENI DRUHEMU CLENOVI
GRANT ALL ON Zakaznik TO xdolej09;
GRANT ALL ON Objednani_sluzby TO xdolej09;
GRANT ALL ON Platba TO xdolej09;
GRANT ALL ON Pokoj TO xdolej09;
GRANT ALL ON Rezervace_pokoje TO xdolej09;
GRANT ALL ON Sluzba TO xdolej09;

GRANT EXECUTE ON pocet_rezervaci_v_obdobi TO xdolej09;
GRANT EXECUTE ON nejoblibenejsi_sluzba TO xdolej09;




------------------------------------------- Materializovany pohled
CREATE MATERIALIZED VIEW mv
BUILD IMMEDIATE
REFRESH ON COMMIT
AS
  SELECT XSVERA04.Zakaznik.jmeno FROM XSVERA04.zakaznik;
  
GRANT SELECT ON mv TO XSVERA04;            
             


------------------------------------ Explain plan
create index date_indx on Rezervace_pokoje(od_kdy);
EXPLAIN PLAN FOR
SELECT SUM(COUNT(Zakaznik.rodne_cislo)) FROM Zakaznik 
JOIN Rezervace_pokoje ON Zakaznik.rodne_cislo = Rezervace_pokoje.rodne_cislo
WHERE  Rezervace_pokoje.od_kdy BETWEEN DATE '2018-1-1' AND DATE '2018-12-31' AND Rezervace_pokoje.do_kdy BETWEEN DATE '2018-1-1' AND DATE '2018-12-31'
GROUP BY Zakaznik.rodne_cislo;
SELECT plan_table_output FROM TABLE(DBMS_XPLAN.display);


drop index date_indx;




------------------------------ predvedeni materializovaneho pohledu
  select jmeno from XSVERA04.zakaznik;
  select jmeno from mv;
  
  INSERT INTO XSVERA04.Zakaznik(rodne_cislo, jmeno, prijmeni, datum_narozeni, ulice, mesto, psc, email, pohlavi) VALUES('6405050014','Franta','Materializovany', DATE '1969-07-21', 'Horní 420', 'Jihlava', '58601', 'franta.mat@seznam.cz', 'Muž');
  
  select jmeno from XSVERA04.zakaznik;
  select jmeno from mv;
  
  commit;
  
  select jmeno from XSVERA04.zakaznik;
  select jmeno from mv;
  

----------------------------------------------------------------DEMONSTRACE PROCEDUR
                                                                                        
EXECUTE pocet_rezervaci_v_obdobi(TO_DATE('2018-1-1', 'YYYY-MM-DD'), TO_DATE('2018-3-1', 'YYYY-MM-DD'));
EXECUTE pocet_rezervaci_v_obdobi(TO_DATE('2018-2-20', 'YYYY-MM-DD'), TO_DATE('2018-7-28', 'YYYY-MM-DD'));
EXECUTE nejoblibenejsi_sluzba;




