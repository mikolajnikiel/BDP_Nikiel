CREATE DATABASE firma;
USE firma;
CREATE SCHEMA ksiegowosc;


--tabela zawierająca dane pracowników
CREATE TABLE ksiegowosc.pracownicy
(
	id_pracownika INT PRIMARY KEY,
	imie VARCHAR(35),
	nazwisko VARCHAR(35),
	adres VARCHAR(70),
	telefon VARCHAR(9)
);
--tabela zawierająca z godzinami, pierwszy FK łączący id_pracownika
CREATE TABLE ksiegowosc.godziny
(
	id_godziny INT PRIMARY KEY,
	data DATE,
	liczba_godzin INT,
	id_pracownika INT,
	CONSTRAINT FK_godziny_pracownicy FOREIGN KEY (id_pracownika)
		REFERENCES ksiegowosc.pracownicy(id_pracownika)

);
--tabela z danymi o pensjach
CREATE TABLE ksiegowosc.pensja
(
	id_pensji INT PRIMARY KEY,
	stanowisko VARCHAR(35),
	kwota DECIMAL(8,2)
);

--tabela zawierające dane o przyznanych premiach lub ich braku
CREATE TABLE ksiegowosc.premia
(
	id_premii INT PRIMARY KEY,
	rodzaj VARCHAR(30),
	kwota DECIMAL(8,2)
);

--tabela wynagrodzenie, powiązania z każdą z poprzednio stworzonych tabel
CREATE TABLE ksiegowosc.wynagrodzenie
(
	id_wynagrodzenia INT PRIMARY KEY, 
	data DATE,
	id_pracownika INT,
	id_godziny INT,
	id_pensji INT,
	id_premii INT,
	CONSTRAINT FK_wynagrodzenie_pracownicy FOREIGN KEY (id_pracownika)
		REFERENCES ksiegowosc.pracownicy(id_pracownika),
	CONSTRAINT FK_wynagrodzenie_godziny FOREIGN KEY (id_godziny)
		REFERENCES ksiegowosc.godziny(id_godziny),
	CONSTRAINT FK_wynagrodzenie_pensja FOREIGN KEY (id_pensji)
		REFERENCES ksiegowosc.pensja(id_pensji),
	CONSTRAINT FK_wynagrodzenie_premia FOREIGN KEY (id_premii)
		REFERENCES ksiegowosc.premia(id_premii)

);



-- Dla wygody poprosiłem model językowy o wygenerowanie danych do tabeli

INSERT INTO ksiegowosc.pracownicy (id_pracownika, imie, nazwisko, adres, telefon) VALUES
(1, 'Jan', 'Kowalski', 'ul. Kwiatowa 5, Warszawa', '123456789'),
(2, 'Anna', 'Nowak', 'ul. Słoneczna 12, Kraków', '234567890'),
(3, 'Piotr', 'Wiśniewski', 'ul. Leśna 8, Gdańsk', '345678901'),
(4, 'Jolanta', 'Wójcik', 'ul. Morska 3, Sopot', '456789012'),
(5, 'Krzysztof', 'Kowalczyk', 'ul. Górna 15, Wrocław', '567890123'),
(6, 'Magdalena', 'Kamińska', 'ul. Polna 7, Poznań', '678901234'),
(7, 'Tomasz', 'Lewandowski', 'ul. Miła 9, Łódź', '789012345'),
(8, 'Joanna', 'Zielińska', 'ul. Krótka 2, Katowice', '890123456'),
(9, 'Andrzej', 'Szymański', 'ul. Długa 11, Lublin', '901234567'),
(10, 'Maria', 'Woźniak', 'ul. Nowa 6, Szczecin', '012345678');


-- Wypełnienie tabeli pensja
INSERT INTO ksiegowosc.pensja (id_pensji, stanowisko, kwota) VALUES
(1, 'Kierownik', 5000.00),
(2, 'Starszy specjalista', 3500.00),
(3, 'Specjalista', 2800.00),
(4, 'Młodszy specjalista', 2200.00),
(5, 'Pracownik', 1800.00),
(6, 'Stażysta', 1200.00),
(7, 'Dyrektor', 8000.00),
(8, 'Asystent', 2000.00),
(9, 'Konsultant', 3200.00),
(10, 'Koordynator', 3000.00);


-- Wypełnienie tabeli premia
INSERT INTO ksiegowosc.premia (id_premii, rodzaj, kwota) VALUES
(1, 'Uznaniowa', 500.00),
(2, 'Świąteczna', 800.00),
(3, 'Roczna', 1200.00),
(4, 'Kwartalna', 400.00),
(5, 'Projektowa', 1000.00),
(6, 'Efektywnościowa', 600.00),
(7, 'Frekwencyjna', 300.00),
(8, 'Sprzedażowa', 700.00),
(9, 'Jubileuszowa', 1500.00),
(10, 'Motywacyjna', 450.00);


-- Wypełnienie tabeli godziny
INSERT INTO ksiegowosc.godziny (id_godziny, data, liczba_godzin, id_pracownika) VALUES
(1, '2024-01-31', 160, 1),
(2, '2024-01-31', 170, 2),
(3, '2024-01-31', 155, 3),
(4, '2024-01-31', 180, 4),
(5, '2024-01-31', 160, 5),
(6, '2024-01-31', 175, 6),
(7, '2024-01-31', 165, 7),
(8, '2024-01-31', 190, 8),
(9, '2024-01-31', 160, 9),
(10, '2024-01-31', 168, 10);


-- Wypełnienie tabeli wynagrodzenie
INSERT INTO ksiegowosc.wynagrodzenie (id_wynagrodzenia, data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES
(1, '2024-01-31', 1, 1, 1, 1),
(2, '2024-01-31', 2, 2, 2, 2),
(3, '2024-01-31', 3, 3, 3, NULL),
(4, '2024-01-31', 4, 4, 4, 3),
(5, '2024-01-31', 5, 5, 5, NULL),
(6, '2024-01-31', 6, 6, 6, NULL),
(7, '2024-01-31', 7, 7, 7, 4),
(8, '2024-01-31', 8, 8, 8, 5),
(9, '2024-01-31', 9, 9, 9, NULL),
(10, '2024-01-31', 10, 10, 10, 6);


--a
select id_pracownika, nazwisko 
from ksiegowosc.pracownicy;

--b
select w.id_pracownika
from ksiegowosc.wynagrodzenie w
join ksiegowosc.pensja p on w.id_pensji = p.id_pensji
where p.kwota > 1000;

--c
select w.id_pracownika
from ksiegowosc.wynagrodzenie w
join ksiegowosc.pensja p on w.id_pensji = p.id_pensji
where w.id_premii is NULL
	and p.kwota > 2000;

--d
select *
from ksiegowosc.pracownicy
where imie like 'J%';

--e
select *
from ksiegowosc.pracownicy
where nazwisko like '%n%'
AND imie like '%a';

--f
select p.id_pracownika, p.imie, p.nazwisko, g.liczba_godzin - 160 as nadgodz
from ksiegowosc.pracownicy p
join ksiegowosc.godziny g on p.id_pracownika = g.id_pracownika
where g.liczba_godzin > 160;

--g
select p.imie, p.nazwisko
from ksiegowosc.pracownicy p
join ksiegowosc.wynagrodzenie w on p.id_pracownika = w.id_pracownika
join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
where pe.kwota > 1500 and pe.kwota < 3000;

--h
select p.imie, p.nazwisko
from ksiegowosc.pracownicy p
join ksiegowosc.wynagrodzenie w on p.id_pracownika = w.id_pracownika
join ksiegowosc.godziny g on w.id_godziny = g.id_godziny
where g.liczba_godzin > 160 and w.id_premii is NULL;

--i
select p.imie, p.nazwisko, pe.kwota
from ksiegowosc.pracownicy p
join ksiegowosc.wynagrodzenie w on p.id_pracownika = w.id_pracownika
join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
order by pe.kwota ;

--j
select p.imie, p.nazwisko, pe.kwota as podstawa, pr.kwota as bonusy, 
case when pr.kwota is null then pe.kwota else pe.kwota + pr.kwota end as suma --aby nie pojawiał się błąd przy sumowaniu z Nullem dodałem taki warunek 
from ksiegowosc.pracownicy p
join ksiegowosc.wynagrodzenie w on p.id_pracownika = w.id_pracownika
join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
left join ksiegowosc.premia pr on w.id_premii = pr.id_premii
order by suma desc;

--k 
select p.stanowisko, count(*) as ilosc
from ksiegowosc.wynagrodzenie w
join ksiegowosc.pensja p on w.id_pensji = p.id_pensji
group by p.stanowisko;

--l
select stanowisko, avg(kwota) as sr_pensja,
min(kwota) as min_pensja,
max(kwota) as max_pensja
from ksiegowosc.pensja
where stanowisko = 'Kierownik'
group by stanowisko;

--m
select sum(case when pr.kwota is null then pe.kwota else pe.kwota + pr.kwota end) as suma_wynagrodzen
from ksiegowosc.wynagrodzenie w
join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
left join ksiegowosc.premia pr on w.id_premii = pr.id_premii;

--f
select pe.stanowisko, sum(case when pr.kwota is null then pe.kwota else pe.kwota + pr.kwota end) as suma_wynagrodzen
from ksiegowosc.wynagrodzenie w
join ksiegowosc.pensja pe on w.id_pensji = pe.id_pensji
left join ksiegowosc.premia pr on w.id_premii = pr.id_premii
group by pe.stanowisko;

--g
select p.stanowisko, count(w.id_premii) as liczba_premii
from ksiegowosc.wynagrodzenie w
join ksiegowosc.pensja p on w.id_pensji = p.id_pensji
where w.id_premii is not NULL
group by p.stanowisko;

--h
delete from ksiegowosc.pracownicy
where id_pracownika in (
    select w.id_pracownika
    from ksiegowosc.wynagrodzenie w
    join ksiegowosc.pensja p on w.id_pensji = p.id_pensji
    where p.kwota < 1200);



