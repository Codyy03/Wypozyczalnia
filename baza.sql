--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-01-19 09:41:49

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 33880)
-- Name: dodawanie; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA dodawanie;


ALTER SCHEMA dodawanie OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 33881)
-- Name: modyfikowanie; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA modyfikowanie;


ALTER SCHEMA modyfikowanie OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 33882)
-- Name: pgagent; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgagent;


ALTER SCHEMA pgagent OWNER TO postgres;

--
-- TOC entry 9 (class 2615 OID 33883)
-- Name: usuwanie; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA usuwanie;


ALTER SCHEMA usuwanie OWNER TO postgres;

--
-- TOC entry 10 (class 2615 OID 33884)
-- Name: wyswietlanie; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA wyswietlanie;


ALTER SCHEMA wyswietlanie OWNER TO postgres;

--
-- TOC entry 918 (class 1247 OID 33887)
-- Name: historia; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.historia AS (
	data_wypozyczenia date,
	data_zwrotu date,
	kolor text,
	rok_produkcji date,
	marka text,
	model text,
	czy_wypozyczony boolean
);


ALTER TYPE public.historia OWNER TO postgres;

--
-- TOC entry 921 (class 1247 OID 33890)
-- Name: info_auto; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.info_auto AS (
	rejestracja text,
	kolor text,
	rok_produkcji date,
	cena integer,
	przebieg integer,
	marka text,
	model text,
	pojemnosc_silnika integer,
	moc_silnika integer,
	imie text,
	nazwisko text
);


ALTER TYPE public.info_auto OWNER TO postgres;

--
-- TOC entry 924 (class 1247 OID 33893)
-- Name: pensja_pracownika; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.pensja_pracownika AS (
	imie text,
	nazwisko text,
	pensja bigint,
	data_zatrudnienia date
);


ALTER TYPE public.pensja_pracownika OWNER TO postgres;

--
-- TOC entry 927 (class 1247 OID 33896)
-- Name: przychod_z_egzemplarzy; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.przychod_z_egzemplarzy AS (
	rejestracja text,
	marka text,
	model text,
	ilosc_wypozyczen bigint,
	przychod bigint
);


ALTER TYPE public.przychod_z_egzemplarzy OWNER TO postgres;

--
-- TOC entry 930 (class 1247 OID 33899)
-- Name: przychody; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.przychody AS (
	pesel bigint,
	imie text,
	nazwisko text,
	koszt bigint
);


ALTER TYPE public.przychody OWNER TO postgres;

--
-- TOC entry 933 (class 1247 OID 33902)
-- Name: rekordklienci; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.rekordklienci AS (
	pesel_ bigint,
	imie_ text,
	nazwisko_ text,
	email_ text,
	telefon_ bigint
);


ALTER TYPE public.rekordklienci OWNER TO postgres;

--
-- TOC entry 252 (class 1255 OID 33903)
-- Name: dodajegzemplarz(text, text, integer, date, integer, integer); Type: PROCEDURE; Schema: dodawanie; Owner: postgres
--

CREATE PROCEDURE dodawanie.dodajegzemplarz(IN rejestracja text, IN kolor text, IN id_modelu integer, IN rok_produkcji date, IN cena integer, IN przebieg integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO egzemplarze("Rejestracja", kolor, "ID_modelu", rok_produkcji, cena, przebieg)
    VALUES (rejestracja, kolor, id_modelu, rok_produkcji, cena,przebieg);
EXCEPTION
    WHEN unique_violation THEN
           RAISE EXCEPTION 'Samochod o podanej rejestracji juz instnieje';
END;
$$;


ALTER PROCEDURE dodawanie.dodajegzemplarz(IN rejestracja text, IN kolor text, IN id_modelu integer, IN rok_produkcji date, IN cena integer, IN przebieg integer) OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 33904)
-- Name: dodajklienta(bigint, text, text, text, bigint); Type: PROCEDURE; Schema: dodawanie; Owner: postgres
--

CREATE PROCEDURE dodawanie.dodajklienta(IN pesel bigint, IN imie text, IN nazwisko text, IN email text, IN telefon bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
    INSERT INTO klienci(pesel, imie, nazwisko, email, telefon)
    VALUES (pesel, imie, nazwisko, email, telefon);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Klient o podanym PESEL lub numerze telefonu już istnieje.';
END;
$$;


ALTER PROCEDURE dodawanie.dodajklienta(IN pesel bigint, IN imie text, IN nazwisko text, IN email text, IN telefon bigint) OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 33905)
-- Name: dodajmodel(text, text, integer, integer, integer); Type: PROCEDURE; Schema: dodawanie; Owner: postgres
--

CREATE PROCEDURE dodawanie.dodajmodel(IN marka text, IN model text, IN pojemnosc_silnika integer, IN moc_silnika integer, IN opiekun integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO modele(marka, model, pojemnosc_silnika, moc_silnika, opiekun)
    VALUES (marka, model, pojemnosc_silnika, moc_silnika, opiekun);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Model o podanej marce lub modelu już istnieje';
END;$$;


ALTER PROCEDURE dodawanie.dodajmodel(IN marka text, IN model text, IN pojemnosc_silnika integer, IN moc_silnika integer, IN opiekun integer) OWNER TO postgres;

--
-- TOC entry 244 (class 1255 OID 33906)
-- Name: dodajpracownika(text, text, integer, date); Type: PROCEDURE; Schema: dodawanie; Owner: postgres
--

CREATE PROCEDURE dodawanie.dodajpracownika(IN imie text, IN nazwisko text, IN wynagrodzenie_bazowe integer, IN data_zatrudnienia date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO pracownicy(imie, nazwisko, wynagrodzenie_bazowe, data_zatrudnienia)
    VALUES (imie, nazwisko, wynagrodzenie_bazowe, data_zatrudnienia);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Pracownik o podanym ID juz istnieje';
END;
$$;


ALTER PROCEDURE dodawanie.dodajpracownika(IN imie text, IN nazwisko text, IN wynagrodzenie_bazowe integer, IN data_zatrudnienia date) OWNER TO postgres;

--
-- TOC entry 253 (class 1255 OID 33907)
-- Name: dodajrezerwacje(bigint, date, date); Type: PROCEDURE; Schema: dodawanie; Owner: postgres
--

CREATE PROCEDURE dodawanie.dodajrezerwacje(IN pesel bigint, IN data_rozpoczecia date, IN data_zakonczenia date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO rezerwacje(pesel, data_rozpoczecia, data_zakonczenia)
    VALUES (pesel, data_rozpoczecia, data_zakonczenia);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Rezerwacja o podanym ID juz istnieje';
END;

$$;


ALTER PROCEDURE dodawanie.dodajrezerwacje(IN pesel bigint, IN data_rozpoczecia date, IN data_zakonczenia date) OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 33908)
-- Name: dodajwypozyczone(date, bigint, date); Type: PROCEDURE; Schema: dodawanie; Owner: postgres
--

CREATE PROCEDURE dodawanie.dodajwypozyczone(IN data_wypozyczenia date, IN pesel bigint, IN data_zwrotu date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO wypozyczone( data_wypozyczenia, pesel, data_zwrotu)
    VALUES ( data_wypozyczenia, pesel, data_zwrotu);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Wypozyczenie o podanym ID juz istnieje';
END;


$$;


ALTER PROCEDURE dodawanie.dodajwypozyczone(IN data_wypozyczenia date, IN pesel bigint, IN data_zwrotu date) OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 33909)
-- Name: modyfikujegzemplarz(text, text, integer, date, integer, integer); Type: PROCEDURE; Schema: modyfikowanie; Owner: postgres
--

CREATE PROCEDURE modyfikowanie.modyfikujegzemplarz(IN rejestracja_ text, IN kolor_ text DEFAULT NULL::text, IN id_modelu_ integer DEFAULT NULL::integer, IN rok_produkcji_ date DEFAULT NULL::date, IN cena_ integer DEFAULT NULL::integer, IN przebieg_ integer DEFAULT NULL::integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF rejestracja_ IS NULL THEN
        RAISE EXCEPTION 'Musisz podać Rejestracje';
    END IF;
    
    IF kolor_ IS NOT NULL THEN
        UPDATE egzemplarze SET kolor = kolor_ WHERE "Rejestracja" = rejestracja_;
    END IF;

    IF id_modelu_ IS NOT NULL THEN
        UPDATE egzemplarze SET "ID_modelu" = id_modelu_ WHERE "Rejestracja" = rejestracja_;
    END IF;

    IF rok_produkcji_ IS NOT NULL THEN
        UPDATE egzemplarze SET rok_produkcji = rok_produkcji_ WHERE "Rejestracja" = rejestracja_;
    END IF;

    IF cena_ IS NOT NULL THEN
        UPDATE egzemplarze SET cena = cena_ WHERE "Rejestracja" = rejestracja_;
    END IF;

    IF przebieg_ IS NOT NULL THEN
        UPDATE egzemplarze SET przebieg = przebieg_ WHERE "Rejestracja" = rejestracja_;
    END IF;
    
END;
$$;


ALTER PROCEDURE modyfikowanie.modyfikujegzemplarz(IN rejestracja_ text, IN kolor_ text, IN id_modelu_ integer, IN rok_produkcji_ date, IN cena_ integer, IN przebieg_ integer) OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 33910)
-- Name: modyfikujklienta(bigint, text, text, text, bigint); Type: PROCEDURE; Schema: modyfikowanie; Owner: postgres
--

CREATE PROCEDURE modyfikowanie.modyfikujklienta(IN pesel_ bigint, IN imie_ text DEFAULT NULL::text, IN nazwisko_ text DEFAULT NULL::text, IN email_ text DEFAULT NULL::text, IN telefon_ bigint DEFAULT NULL::bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF pesel_ IS NULL THEN
        RAISE EXCEPTION 'Musisz podać PESEL';
    END IF;
	
	IF imie_ IS NOT NULL THEN
    UPDATE klienci SET  imie=imie_ WHERE pesel=pesel_;
	END IF;

	IF nazwisko_ IS NOT NULL THEN
    UPDATE klienci SET  nazwisko=nazwisko_ WHERE pesel=pesel_;
	END IF;

	IF email_ IS NOT NULL THEN
    UPDATE klienci SET  email=email_ WHERE pesel=pesel_;
	END IF;

	IF telefon_ IS NOT NULL THEN
    UPDATE klienci SET  telefon=telefon_ WHERE pesel=pesel_;
	END IF;
	
END;
$$;


ALTER PROCEDURE modyfikowanie.modyfikujklienta(IN pesel_ bigint, IN imie_ text, IN nazwisko_ text, IN email_ text, IN telefon_ bigint) OWNER TO postgres;

--
-- TOC entry 270 (class 1255 OID 33911)
-- Name: modyfikujmodel(integer, text, text, integer, integer, integer); Type: PROCEDURE; Schema: modyfikowanie; Owner: postgres
--

CREATE PROCEDURE modyfikowanie.modyfikujmodel(IN id_modelu_ integer, IN marka_ text DEFAULT NULL::text, IN model_ text DEFAULT NULL::text, IN pojemnosc_silnika_ integer DEFAULT NULL::integer, IN moc_silnika_ integer DEFAULT NULL::integer, IN opiekun_ integer DEFAULT NULL::integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF id_modelu_ IS NULL THEN
        RAISE EXCEPTION 'Musisz podać ID modelu';
    END IF;
    
    IF marka_ IS NOT NULL THEN
        UPDATE modele SET marka = marka_ WHERE "ID_modelu" = id_modelu_;
    END IF;

    IF model_ IS NOT NULL THEN
        UPDATE modele SET model = model_ WHERE "ID_modelu" = id_modelu_;
    END IF;

    IF pojemnosc_silnika_ IS NOT NULL THEN
        UPDATE modele SET pojemnosc_silnika = pojemnosc_silnika_ WHERE "ID_modelu" = id_modelu_;
    END IF;

    IF moc_silnika_ IS NOT NULL THEN
        UPDATE modele SET moc_silnika = moc_silnika_ WHERE "ID_modelu" = id_modelu_;
    END IF;

    IF opiekun_ IS NOT NULL THEN
        UPDATE modele SET opiekun = opiekun_ WHERE "ID_modelu" = id_modelu_;
    END IF;
    
END;
$$;


ALTER PROCEDURE modyfikowanie.modyfikujmodel(IN id_modelu_ integer, IN marka_ text, IN model_ text, IN pojemnosc_silnika_ integer, IN moc_silnika_ integer, IN opiekun_ integer) OWNER TO postgres;

--
-- TOC entry 271 (class 1255 OID 33912)
-- Name: modyfikujpracownika(integer, text, text, integer, date); Type: PROCEDURE; Schema: modyfikowanie; Owner: postgres
--

CREATE PROCEDURE modyfikowanie.modyfikujpracownika(IN id_pracownika_ integer, IN imie_ text DEFAULT NULL::text, IN nazwisko_ text DEFAULT NULL::text, IN wynagrodzenie_bazowe_ integer DEFAULT NULL::integer, IN data_zatrudnienia_ date DEFAULT NULL::date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF id_pracownika_ IS NULL THEN
        RAISE EXCEPTION 'Musisz podać ID pracownika';
    END IF;
    
    IF imie_ IS NOT NULL THEN
        UPDATE pracownicy SET imie = imie_ WHERE "ID_pracownika" = id_pracownika_;
    END IF;

    IF nazwisko_ IS NOT NULL THEN
        UPDATE pracownicy SET nazwisko = nazwisko_ WHERE "ID_pracownika" = id_pracownika_;
    END IF;

    IF wynagrodzenie_bazowe_ IS NOT NULL THEN
        UPDATE pracownicy SET wynagrodzenie_bazowe = wynagrodzenie_bazowe_ WHERE "ID_pracownika" = id_pracownika_;
    END IF;

    IF data_zatrudnienia_ IS NOT NULL THEN
        UPDATE pracownicy SET data_zatrudnienia = data_zatrudnienia_ WHERE "ID_pracownika" = id_pracownika_;
    END IF;
    
END;
$$;


ALTER PROCEDURE modyfikowanie.modyfikujpracownika(IN id_pracownika_ integer, IN imie_ text, IN nazwisko_ text, IN wynagrodzenie_bazowe_ integer, IN data_zatrudnienia_ date) OWNER TO postgres;

--
-- TOC entry 272 (class 1255 OID 33913)
-- Name: modyfikujrezerwacje(integer, bigint, date, date); Type: PROCEDURE; Schema: modyfikowanie; Owner: postgres
--

CREATE PROCEDURE modyfikowanie.modyfikujrezerwacje(IN id_rezerwacji_ integer, IN pesel_ bigint, IN data_rozpoczecia_ date, IN data_zakonczenia_ date)
    LANGUAGE plpgsql
    AS $$
BEGIN
  
    IF id_rezerwacji_ IS NULL THEN
        RAISE EXCEPTION 'Musisz podać ID rezerwacji';
    END IF;

    IF pesel_ IS NOT NULL THEN
        UPDATE rezerwacje
        SET pesel = pesel_
        WHERE "ID_rezerwacji" = id_rezerwacji_;
    END IF;


    IF data_rozpoczecia_ IS NOT NULL THEN
        UPDATE rezerwacje
        SET data_rozpoczecia = data_rozpoczecia_
        WHERE "ID_rezerwacji" = id_rezerwacji_;
    END IF;


    IF data_zakonczenia_ IS NOT NULL THEN
        UPDATE rezerwacje
        SET data_zakonczenia = data_zakonczenia_
        WHERE "ID_rezerwacji" = id_rezerwacji_;
    END IF;
END;
$$;


ALTER PROCEDURE modyfikowanie.modyfikujrezerwacje(IN id_rezerwacji_ integer, IN pesel_ bigint, IN data_rozpoczecia_ date, IN data_zakonczenia_ date) OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 33914)
-- Name: modyfikujwypozyczone(integer, date, bigint, date); Type: PROCEDURE; Schema: modyfikowanie; Owner: postgres
--

CREATE PROCEDURE modyfikowanie.modyfikujwypozyczone(IN id_wypozyczenia_ integer, IN data_wypozyczenia_ date DEFAULT NULL::date, IN pesel_ bigint DEFAULT NULL::bigint, IN data_zwrotu_ date DEFAULT NULL::date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF id_wypozyczenia_ IS NULL THEN
        RAISE EXCEPTION 'Musisz podać ID wypozyczenia';
    END IF;
    
    IF data_wypozyczenia_ IS NOT NULL THEN
        UPDATE wypozyczone SET data_wypozyczenia = data_wypozyczenia_ WHERE "ID_wypozyczenia" = id_wypozyczenia_;
    END IF;

    IF pesel_ IS NOT NULL THEN
        UPDATE wypozyczone SET pesel = pesel_ WHERE "ID_wypozyczenia" = id_wypozyczenia_;
    END IF;

    IF data_zwrotu_ IS NOT NULL THEN
        UPDATE wypozyczone SET data_zwrotu = data_zwrotu_ WHERE "ID_wypozyczenia" = id_wypozyczenia_;
    END IF;
    
END;
$$;


ALTER PROCEDURE modyfikowanie.modyfikujwypozyczone(IN id_wypozyczenia_ integer, IN data_wypozyczenia_ date, IN pesel_ bigint, IN data_zwrotu_ date) OWNER TO postgres;

--
-- TOC entry 274 (class 1255 OID 33915)
-- Name: czy_klient_istnieje(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.czy_klient_istnieje(pesel_ bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS(SELECT pesel FROM klienci WHERE pesel=pesel_) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END $$;


ALTER FUNCTION public.czy_klient_istnieje(pesel_ bigint) OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 33916)
-- Name: czy_wolny(date, date, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.czy_wolny(data_rozpoczecia_ date, data_zakonczenia_ date, rejestracja_ text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
    --sprawdzanie czy podane auto istnieje
    IF NOT EXISTS(SELECT "Rejestracja" FROM egzemplarze WHERE egzemplarze."Rejestracja"=rejestracja_) THEN
        RETURN 1;
    --sprawdzanie w wypozyczonych
    ELSEIF EXISTS(
        SELECT "Rejestracja"
        FROM egzemplarze
        JOIN wypozyczone_egzemplarze ON egzemplarze."Rejestracja"=wypozyczone_egzemplarze."egzemplarze_Rejestracja"
        JOIN wypozyczone ON wypozyczone_egzemplarze."wypozyczone_ID_wypozyczenia"=wypozyczone."ID_wypozyczenia"
        WHERE egzemplarze."Rejestracja"=rejestracja_ AND wypozyczone.data_zwrotu >= data_rozpoczecia_
    )
    THEN
        RETURN 2;
    --    sprawdzanie w rezerwacjach
    ELSIF EXISTS(
        SELECT "Rejestracja"
        FROM egzemplarze
        JOIN rezerwacje_egzemplarze ON egzemplarze."Rejestracja"=rezerwacje_egzemplarze."egzemplarze_Rejestracja"
        JOIN rezerwacje ON rezerwacje_egzemplarze."rezerwacje_ID_rezerwacji"=rezerwacje."ID_rezerwacji"
        WHERE egzemplarze."Rejestracja"=rejestracja_ AND rezerwacje.data_zakonczenia>=data_rozpoczecia_ AND rezerwacje.data_rozpoczecia<=data_zakonczenia_
    )
    THEN
        RETURN 3;
    ELSE
        RETURN 0;
    END IF;
END $$;


ALTER FUNCTION public.czy_wolny(data_rozpoczecia_ date, data_zakonczenia_ date, rejestracja_ text) OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 33917)
-- Name: do_kiedy_wolne(text[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.do_kiedy_wolne(rejestracje_ text[]) RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE
do_kiedy DATE;
najwczesniej DATE;
BEGIN
    najwczesniej:=CURRENT_DATE+30;
    FOR i IN 1 .. array_length(rejestracje_, 1) LOOP
        IF EXISTS(SELECT data_rozpoczecia FROM rezerwacje
        JOIN rezerwacje_egzemplarze ON rezerwacje."ID_rezerwacji"=rezerwacje_egzemplarze."rezerwacje_ID_rezerwacji"
        JOIN egzemplarze ON rezerwacje_egzemplarze."egzemplarze_Rejestracja"=egzemplarze."Rejestracja"
        WHERE egzemplarze."Rejestracja"=rejestracje_[i] ORDER BY data_rozpoczecia ASC LIMIT 1) THEN
            SELECT data_rozpoczecia INTO do_kiedy FROM rezerwacje
            JOIN rezerwacje_egzemplarze ON rezerwacje."ID_rezerwacji"=rezerwacje_egzemplarze."rezerwacje_ID_rezerwacji"
            JOIN egzemplarze ON rezerwacje_egzemplarze."egzemplarze_Rejestracja"=egzemplarze."Rejestracja"
            WHERE egzemplarze."Rejestracja"=rejestracje_[i] ORDER BY data_rozpoczecia ASC LIMIT 1;
            IF do_kiedy<najwczesniej THEN
                najwczesniej:=do_kiedy;
            END IF;
        END IF;
    END LOOP;
    RETURN najwczesniej;
END $$;


ALTER FUNCTION public.do_kiedy_wolne(rejestracje_ text[]) OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 33918)
-- Name: historia_uzytkownika(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.historia_uzytkownika(pesel_ bigint) RETURNS SETOF public.historia
    LANGUAGE plpgsql
    AS $$
DECLARE
historia_tab HISTORIA[];
historia historia;
i INT;
BEGIN
    i:=0;
    FOR historia IN SELECT wypozyczone.data_wypozyczenia, wypozyczone.data_zwrotu, egzemplarze.kolor,  egzemplarze.rok_produkcji, modele.marka, modele.model 
    FROM klienci 
    JOIN wypozyczone ON klienci.pesel=wypozyczone.pesel
    JOIN wypozyczone_egzemplarze ON wypozyczone."ID_wypozyczenia"=wypozyczone_egzemplarze."wypozyczone_ID_wypozyczenia"
    JOIN egzemplarze ON wypozyczone_egzemplarze."egzemplarze_Rejestracja"=egzemplarze."Rejestracja"
    JOIN modele ON egzemplarze."ID_modelu"=modele."ID_modelu"
    WHERE klienci.pesel=pesel_
    ORDER BY data_wypozyczenia DESC LOOP
        historia_tab[i].data_wypozyczenia:=historia.data_wypozyczenia;
        historia_tab[i].data_zwrotu:=historia.data_zwrotu;
        historia_tab[i].kolor:=historia.kolor;
        historia_tab[i].rok_produkcji:=historia.rok_produkcji;
        historia_tab[i].marka:=historia.marka;
        historia_tab[i].model:=historia.model;
        historia_tab[i].czy_wypozyczony:=historia.data_zwrotu>CURRENT_DATE;
        i:=i+1;
    END LOOP;
    RETURN QUERY SELECT * FROM unnest(historia_tab);
END $$;


ALTER FUNCTION public.historia_uzytkownika(pesel_ bigint) OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 33919)
-- Name: info_auto(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.info_auto(rejestracja_ text) RETURNS public.info_auto
    LANGUAGE plpgsql
    AS $$
DECLARE
informacje info_auto;
BEGIN
    SELECT egzemplarze."Rejestracja", egzemplarze.kolor, egzemplarze.rok_produkcji, egzemplarze.cena, egzemplarze.przebieg, modele.marka, modele.model, modele.pojemnosc_silnika, modele.moc_silnika, pracownicy.imie as "imię opiekuna", pracownicy.nazwisko AS "nazwisko opiekuna" INTO informacje FROM egzemplarze JOIN modele ON egzemplarze."ID_modelu"=modele."ID_modelu" JOIN pracownicy ON modele.opiekun=pracownicy."ID_pracownika" WHERE egzemplarze."Rejestracja"=rejestracja_;
    IF informacje.rejestracja IS NULL THEN
        RAISE EXCEPTION 'Brak auta o podanej rejestracji!';
    END IF;
    RETURN informacje;
END $$;


ALTER FUNCTION public.info_auto(rejestracja_ text) OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 33920)
-- Name: koszt(date, date, text[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.koszt(poczatek date, koniec date, rejestracje_ text[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    suma INTEGER;
BEGIN
    suma:=0;
    FOR i IN 1 .. array_length(rejestracje_, 1) LOOP
        suma:=suma+(SELECT cena FROM egzemplarze WHERE "Rejestracja"=rejestracje_[i]);
    END LOOP;
    RETURN suma*(koniec-poczatek);
END $$;


ALTER FUNCTION public.koszt(poczatek date, koniec date, rejestracje_ text[]) OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 33921)
-- Name: koszt(date, date, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.koszt(poczatek date, koniec date, rejestracja text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    egzCena INTEGER;
    liczba_dni INTEGER;
BEGIN
    -- Obliczanie liczby dni przy użyciu funkcji AGE i EXTRACT
    liczba_dni := EXTRACT(DAY FROM AGE(koniec, poczatek));

    -- Pobranie ceny za wynajem dla podanej rejestracji
    SELECT e.cena INTO egzCena FROM egzemplarze e WHERE e."Rejestracja" = rejestracja;

    -- Obliczanie całkowitego kosztu
    RETURN egzCena * liczba_dni;
END $$;


ALTER FUNCTION public.koszt(poczatek date, koniec date, rejestracja text) OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 33922)
-- Name: liczenie_pensji(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.liczenie_pensji() RETURNS SETOF public.pensja_pracownika
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        p.imie, 
        p.nazwisko, 
        p."wynagrodzenie_bazowe" + COALESCE(COUNT(e."Rejestracja") * 300, 0) AS "pensja", 
        p.data_zatrudnienia
    FROM 
        pracownicy p 
        LEFT JOIN modele m ON p."ID_pracownika" = m.opiekun 
        LEFT JOIN egzemplarze e ON e."ID_modelu" = m."ID_modelu"
    GROUP BY 
        p."ID_pracownika"
    ORDER BY 
        p."ID_pracownika";
END 
/*COALESCE: Używany do zapewnienia, że wynik mnożenia COUNT(e."Rejestracja") * 300 nie jest NULL.*/
/* LEFT JOIN: Używany do uwzględnienia wszystkich pracowników, nawet tych bez powiązanych rekordów w tabelach modele i egzemplarze.*/$$;


ALTER FUNCTION public.liczenie_pensji() OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 33923)
-- Name: przychody_z_egzemplarza(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.przychody_z_egzemplarza(egzemplarz_ text) RETURNS public.przychod_z_egzemplarzy
    LANGUAGE plpgsql
    AS $$
DECLARE
przychod przychod_z_egzemplarzy;
BEGIN
    SELECT "Rejestracja", marka, model, count(*), sum(koszt)
    INTO przychod
    FROM(
        SELECT egzemplarze."Rejestracja", modele.marka, modele.model, koszt(wypozyczone.data_wypozyczenia, wypozyczone.data_zwrotu, ARRAY[egzemplarze."Rejestracja"]) FROM modele
        JOIN egzemplarze ON modele."ID_modelu"=egzemplarze."ID_modelu"
        JOIN wypozyczone_egzemplarze ON egzemplarze."Rejestracja"=wypozyczone_egzemplarze."egzemplarze_Rejestracja"
        JOIN wypozyczone ON wypozyczone_egzemplarze."wypozyczone_ID_wypozyczenia"=wypozyczone."ID_wypozyczenia"
        JOIN klienci ON wypozyczone.pesel=klienci.pesel
    )
    WHERE "Rejestracja"=egzemplarz_
    GROUP BY "Rejestracja", marka, model;
    RETURN przychod;
END $$;


ALTER FUNCTION public.przychody_z_egzemplarza(egzemplarz_ text) OWNER TO postgres;

--
-- TOC entry 285 (class 1255 OID 33924)
-- Name: przychody_z_egzemplarzy(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.przychody_z_egzemplarzy() RETURNS SETOF public.przychod_z_egzemplarzy
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT "Rejestracja", marka, model, count(*), sum(koszt)
    FROM(
        SELECT egzemplarze."Rejestracja", modele.marka, modele.model, koszt(wypozyczone.data_wypozyczenia, wypozyczone.data_zwrotu, ARRAY[egzemplarze."Rejestracja"]) FROM modele
        JOIN egzemplarze ON modele."ID_modelu"=egzemplarze."ID_modelu"
        JOIN wypozyczone_egzemplarze ON egzemplarze."Rejestracja"=wypozyczone_egzemplarze."egzemplarze_Rejestracja"
        JOIN wypozyczone ON wypozyczone_egzemplarze."wypozyczone_ID_wypozyczenia"=wypozyczone."ID_wypozyczenia"
        JOIN klienci ON wypozyczone.pesel=klienci.pesel
    )
    GROUP BY "Rejestracja", marka, model
    ORDER BY sum DESC;
END $$;


ALTER FUNCTION public.przychody_z_egzemplarzy() OWNER TO postgres;

--
-- TOC entry 286 (class 1255 OID 33925)
-- Name: przychody_z_klienta(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.przychody_z_klienta(pesel_ bigint) RETURNS public.przychody
    LANGUAGE plpgsql
    AS $$
DECLARE
klient przychody;
BEGIN
    SELECT pesel, imie, nazwisko, sum(koszt)
    INTO klient
    FROM (
        SELECT klienci.pesel, klienci.imie, klienci.nazwisko, koszt(wypozyczone.data_wypozyczenia, wypozyczone.data_zwrotu, ARRAY["egzemplarze_Rejestracja"])
        FROM klienci
        JOIN wypozyczone ON klienci.pesel=wypozyczone.pesel
        JOIN wypozyczone_egzemplarze ON wypozyczone."ID_wypozyczenia"=wypozyczone_egzemplarze."wypozyczone_ID_wypozyczenia"
    )
    WHERE pesel=pesel_
    GROUP BY pesel, imie, nazwisko;
    RETURN klient;
END $$;


ALTER FUNCTION public.przychody_z_klienta(pesel_ bigint) OWNER TO postgres;

--
-- TOC entry 287 (class 1255 OID 33926)
-- Name: przychody_z_klientow(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.przychody_z_klientow() RETURNS SETOF public.przychody
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT pesel, imie, nazwisko, sum(koszt) FROM (
        SELECT klienci.pesel, klienci.imie, klienci.nazwisko, koszt(wypozyczone.data_wypozyczenia, wypozyczone.data_zwrotu, ARRAY["egzemplarze_Rejestracja"])
        FROM klienci
        JOIN wypozyczone ON klienci.pesel=wypozyczone.pesel
        JOIN wypozyczone_egzemplarze ON wypozyczone."ID_wypozyczenia"=wypozyczone_egzemplarze."wypozyczone_ID_wypozyczenia"
    )
    GROUP BY pesel, imie, nazwisko ORDER BY sum DESC;
END $$;


ALTER FUNCTION public.przychody_z_klientow() OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 33927)
-- Name: sprawdz_rejestracje(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sprawdz_rejestracje(rejestracja_ text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS(SELECT "Rejestracja" FROM egzemplarze WHERE "Rejestracja" = rejestracja_) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;


ALTER FUNCTION public.sprawdz_rejestracje(rejestracja_ text) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 33928)
-- Name: sprawdz_telefon(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sprawdz_telefon(telefon_ bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS(SELECT telefon FROM klienci WHERE telefon=telefon_) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;


ALTER FUNCTION public.sprawdz_telefon(telefon_ bigint) OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 33929)
-- Name: wszystkierejestracje(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.wszystkierejestracje() RETURNS TABLE(rejestracja text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT "Rejestracja"
    FROM egzemplarze;
END;
$$;


ALTER FUNCTION public.wszystkierejestracje() OWNER TO postgres;

--
-- TOC entry 289 (class 1255 OID 33930)
-- Name: wypozycz(bigint, date, text[]); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.wypozycz(IN pesel_ bigint, IN data_zwrotu_ date, IN rejestracje_ text[])
    LANGUAGE plpgsql
    AS $$
DECLARE
wynik INTEGER;
BEGIN
    --sprawdzanie czy kazde auto moze byc wypozyczone
    FOR i IN 1 .. array_length(rejestracje_, 1) LOOP
        wynik:=czy_wolny(CURRENT_DATE, data_zwrotu_, rejestracje_[i]);
        IF wynik=1 THEN
            RAISE EXCEPTION 'Auto z rejestracją % nie istnieje!', rejestracje_[i];
        ELSIF wynik=2 THEN
            RAISE EXCEPTION 'Auto z rejestracją % jest teraz wypozyczane!', rejestracje_[i];
        ELSEIF wynik=3 THEN
            RAISE EXCEPTION 'Auto z rejestracją % jest już zarezerwowane w tym terminie!', rejestracje_[i];
        END IF;
    END LOOP;
    --sprawdzanie czy klient o podanym peselu istnieje
    IF NOT EXISTS(SELECT pesel FROM klienci WHERE pesel=pesel_) THEN
        RAISE EXCEPTION 'Ten klient nie istnieje';
    END IF;
    --sapisywanie wypozyczenia
    INSERT INTO wypozyczone (data_wypozyczenia, pesel, data_zwrotu) VALUES (CURRENT_DATE, pesel_, data_zwrotu_);
    FOR i IN 1 .. array_length(rejestracje_, 1) LOOP
        INSERT INTO wypozyczone_egzemplarze ("wypozyczone_ID_wypozyczenia","egzemplarze_Rejestracja") VALUES (currval('wypozyczone_seq'), rejestracje_[i]);
    END LOOP;
END $$;


ALTER PROCEDURE public.wypozycz(IN pesel_ bigint, IN data_zwrotu_ date, IN rejestracje_ text[]) OWNER TO postgres;

--
-- TOC entry 290 (class 1255 OID 33931)
-- Name: zarezerwuj(bigint, date, date, text[]); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.zarezerwuj(IN pesel_ bigint, IN data_rozpoczecia_ date, IN data_zakonczenia_ date, IN rejestracje_ text[])
    LANGUAGE plpgsql
    AS $$
DECLARE
wynik INTEGER;
BEGIN
    --sprawdzanie czy kazde auto moze byc zarezerwowane
    FOR i IN 1 .. array_length(rejestracje_, 1) LOOP
        wynik:=czy_wolny(data_rozpoczecia_, data_zakonczenia_, rejestracje_[i]);
        IF wynik=1 THEN
            RAISE EXCEPTION 'Auto z rejestracją % nie istnieje!', rejestracje_[i];
        ELSIF wynik=2 THEN
            RAISE EXCEPTION 'Auto z rejestracją % jest teraz wypozyczane!', rejestracje_[i];
        ELSEIF wynik=3 THEN
            RAISE EXCEPTION 'Auto z rejestracją % jest już zarezerwowane w tym terminie!', rejestracje_[i];
        END IF;
    END LOOP;
    --sprawdzanie czy klient o podanym peselu istnieje
    IF NOT EXISTS(SELECT pesel FROM klienci WHERE pesel=pesel_) THEN
        RAISE EXCEPTION 'Ten klient nie istnieje';
    END IF;
    -- sprawdzanie czy rezerwacja jest w przyszlosci
    IF data_rozpoczecia_<=CURRENT_DATE THEN
        RAISE EXCEPTION 'Rezerwować można tylko na przyszłość!';
    END IF;
    --sapisywanie rezerwacji
    INSERT INTO rezerwacje (data_rozpoczecia, pesel, data_zakonczenia) VALUES (data_rozpoczecia_, pesel_, data_zakonczenia_);
    FOR i IN 1 .. array_length(rejestracje_, 1) LOOP
        INSERT INTO rezerwacje_egzemplarze ("rezerwacje_ID_rezerwacji","egzemplarze_Rejestracja") VALUES (currval('rezerwacje_seq'), rejestracje_[i]);
    END LOOP;
END $$;


ALTER PROCEDURE public.zarezerwuj(IN pesel_ bigint, IN data_rozpoczecia_ date, IN data_zakonczenia_ date, IN rejestracje_ text[]) OWNER TO postgres;

--
-- TOC entry 291 (class 1255 OID 33932)
-- Name: zrealizuj_rezerwacje_dla_wszystkich(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.zrealizuj_rezerwacje_dla_wszystkich()
    LANGUAGE plpgsql
    AS $$
DECLARE
    rezerwacja RECORD; -- Zmienna do przechowywania przetwarzanej rezerwacji
    egzemplarz_ RECORD; -- Zmienna do przechowywania przetwarzanego egzemplarza
BEGIN
    -- Pętla przez wszystkie rezerwacje, które mogą być realizowane
    FOR rezerwacja IN 
        SELECT * FROM rezerwacje 
        WHERE CURRENT_DATE > data_rozpoczecia -- Warunek na datę rozpoczęcia
    LOOP
		
        -- Wstawienie rekordu do tabeli wypożyczone
        INSERT INTO wypozyczone (data_wypozyczenia, pesel, data_zwrotu)
        VALUES (rezerwacja.data_rozpoczecia, rezerwacja.pesel, rezerwacja.data_zakonczenia);

        -- Przetwarzanie egzemplarzy związanych z rezerwacją
        FOR egzemplarz_ IN 
            SELECT "egzemplarze_Rejestracja" 
            FROM rezerwacje_egzemplarze 
            WHERE "rezerwacje_ID_rezerwacji" = rezerwacja."ID_rezerwacji"
        LOOP
            INSERT INTO wypozyczone_egzemplarze 
            VALUES (currval('wypozyczone_seq'), egzemplarz_."egzemplarze_Rejestracja");
        END LOOP;

        -- Usunięcie danych z tabeli łączącej
        DELETE FROM rezerwacje_egzemplarze 
        WHERE "rezerwacje_ID_rezerwacji" = rezerwacja."ID_rezerwacji";

        -- Usunięcie rezerwacji
        DELETE FROM rezerwacje 
        WHERE "ID_rezerwacji" = rezerwacja."ID_rezerwacji";
    END LOOP;
END;
$$;


ALTER PROCEDURE public.zrealizuj_rezerwacje_dla_wszystkich() OWNER TO postgres;

--
-- TOC entry 255 (class 1255 OID 33933)
-- Name: usunegzemplarz(text); Type: PROCEDURE; Schema: usuwanie; Owner: postgres
--

CREATE PROCEDURE usuwanie.usunegzemplarz(IN rejestracja_ text)
    LANGUAGE plpgsql
    AS $$
BEGIN
   DELETE FROM egzemplarze WHERE "Rejestracja" = rejestracja_; 
   IF NOT FOUND THEN RAISE EXCEPTION 'Egzemplarz o podanej rejestracji nie istnieje';
   END IF;
END;
$$;


ALTER PROCEDURE usuwanie.usunegzemplarz(IN rejestracja_ text) OWNER TO postgres;

--
-- TOC entry 297 (class 1255 OID 33934)
-- Name: usunklienta(bigint); Type: PROCEDURE; Schema: usuwanie; Owner: postgres
--

CREATE PROCEDURE usuwanie.usunklienta(IN pesel_ bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM klienci WHERE pesel_=klienci.pesel;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Klient o podanym PESEL nie istnieje.';
END;
$$;


ALTER PROCEDURE usuwanie.usunklienta(IN pesel_ bigint) OWNER TO postgres;

--
-- TOC entry 298 (class 1255 OID 33935)
-- Name: usunmodel(integer); Type: PROCEDURE; Schema: usuwanie; Owner: postgres
--

CREATE PROCEDURE usuwanie.usunmodel(IN id_modelu_ integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
   DELETE FROM modele WHERE "ID_modelu" = id_modelu_; 
   IF NOT FOUND THEN RAISE EXCEPTION 'Model o podanym ID nie istnieje';
   END IF;
END;
$$;


ALTER PROCEDURE usuwanie.usunmodel(IN id_modelu_ integer) OWNER TO postgres;

--
-- TOC entry 299 (class 1255 OID 33936)
-- Name: usunpracownika(integer); Type: PROCEDURE; Schema: usuwanie; Owner: postgres
--

CREATE PROCEDURE usuwanie.usunpracownika(IN id_pracownika_ integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
   DELETE FROM pracownicy WHERE "ID_pracownika" = id_pracownika_; 
   IF NOT FOUND THEN RAISE EXCEPTION 'Pracownik o podanym ID nie istnieje';
   END IF;
END;
$$;


ALTER PROCEDURE usuwanie.usunpracownika(IN id_pracownika_ integer) OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 33937)
-- Name: usunrezerwacje(integer); Type: PROCEDURE; Schema: usuwanie; Owner: postgres
--

CREATE PROCEDURE usuwanie.usunrezerwacje(IN id_rezerwacji_ integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
   DELETE FROM rezerwacje WHERE "ID_rezerwacji" = id_rezerwacji_; 
   IF NOT FOUND THEN RAISE EXCEPTION 'Rezerwacja podanym ID nie istnieje';
   END IF;
END;
$$;


ALTER PROCEDURE usuwanie.usunrezerwacje(IN id_rezerwacji_ integer) OWNER TO postgres;

--
-- TOC entry 300 (class 1255 OID 33938)
-- Name: usunwypozyczone(integer); Type: PROCEDURE; Schema: usuwanie; Owner: postgres
--

CREATE PROCEDURE usuwanie.usunwypozyczone(IN id_wypozyczenia_ integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
   DELETE FROM wypozyczone WHERE "ID_wypozyczenia" = id_wypozyczenia_; 
   IF NOT FOUND THEN RAISE EXCEPTION 'Wypozyczenie podanym ID nie istnieje';
   END IF;
END;
$$;


ALTER PROCEDURE usuwanie.usunwypozyczone(IN id_wypozyczenia_ integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 228 (class 1259 OID 33939)
-- Name: egzemplarze; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.egzemplarze (
    "Rejestracja" text NOT NULL,
    kolor text NOT NULL,
    "ID_modelu" integer NOT NULL,
    rok_produkcji date NOT NULL,
    cena integer NOT NULL,
    przebieg integer NOT NULL,
    CONSTRAINT egzemplarze_cena_check CHECK ((cena > 0))
);


ALTER TABLE public.egzemplarze OWNER TO postgres;

--
-- TOC entry 292 (class 1255 OID 33945)
-- Name: egzemplarzeall(); Type: FUNCTION; Schema: wyswietlanie; Owner: postgres
--

CREATE FUNCTION wyswietlanie.egzemplarzeall() RETURNS SETOF public.egzemplarze
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM egzemplarze ORDER BY "ID_modelu";
END $$;


ALTER FUNCTION wyswietlanie.egzemplarzeall() OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 33946)
-- Name: klienci; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.klienci (
    pesel bigint NOT NULL,
    imie text NOT NULL,
    nazwisko text NOT NULL,
    email text,
    telefon bigint NOT NULL,
    CONSTRAINT klienci_telefon_check CHECK (((telefon > 0) AND (telefon < 1000000000)))
);


ALTER TABLE public.klienci OWNER TO postgres;

--
-- TOC entry 293 (class 1255 OID 33952)
-- Name: klienciall(); Type: FUNCTION; Schema: wyswietlanie; Owner: postgres
--

CREATE FUNCTION wyswietlanie.klienciall() RETURNS SETOF public.klienci
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM klienci;
END $$;


ALTER FUNCTION wyswietlanie.klienciall() OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 33953)
-- Name: modele_id_modelu_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.modele_id_modelu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.modele_id_modelu_seq OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 33954)
-- Name: modele; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.modele (
    "ID_modelu" integer DEFAULT nextval('public.modele_id_modelu_seq'::regclass) NOT NULL,
    marka text NOT NULL,
    model text NOT NULL,
    pojemnosc_silnika integer NOT NULL,
    moc_silnika integer NOT NULL,
    opiekun integer,
    CONSTRAINT modele_moc_silnika_check CHECK ((moc_silnika > 0)),
    CONSTRAINT modele_pojemnosc_silnika_check CHECK ((pojemnosc_silnika > 0))
);


ALTER TABLE public.modele OWNER TO postgres;

--
-- TOC entry 294 (class 1255 OID 33962)
-- Name: modeleall(); Type: FUNCTION; Schema: wyswietlanie; Owner: postgres
--

CREATE FUNCTION wyswietlanie.modeleall() RETURNS SETOF public.modele
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM modele ORDER BY "ID_modelu";
END $$;


ALTER FUNCTION wyswietlanie.modeleall() OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 33963)
-- Name: pracownicy_id_pracownika_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pracownicy_id_pracownika_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pracownicy_id_pracownika_seq OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 33964)
-- Name: pracownicy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pracownicy (
    "ID_pracownika" integer DEFAULT nextval('public.pracownicy_id_pracownika_seq'::regclass) NOT NULL,
    imie text NOT NULL,
    nazwisko text NOT NULL,
    wynagrodzenie_bazowe integer NOT NULL,
    data_zatrudnienia date NOT NULL,
    CONSTRAINT pracownicy_wynagrodzenie_bazowe_check CHECK ((wynagrodzenie_bazowe > 0))
);


ALTER TABLE public.pracownicy OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 33971)
-- Name: pracownicyall(); Type: FUNCTION; Schema: wyswietlanie; Owner: postgres
--

CREATE FUNCTION wyswietlanie.pracownicyall() RETURNS SETOF public.pracownicy
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM pracownicy ORDER BY "ID_pracownika";
END $$;


ALTER FUNCTION wyswietlanie.pracownicyall() OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 33972)
-- Name: rezerwacje_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rezerwacje_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rezerwacje_seq OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 33973)
-- Name: rezerwacje; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rezerwacje (
    "ID_rezerwacji" integer DEFAULT nextval('public.rezerwacje_seq'::regclass) NOT NULL,
    pesel bigint NOT NULL,
    data_rozpoczecia date NOT NULL,
    data_zakonczenia date NOT NULL
);


ALTER TABLE public.rezerwacje OWNER TO postgres;

--
-- TOC entry 296 (class 1255 OID 33977)
-- Name: rezerwacjeall(); Type: FUNCTION; Schema: wyswietlanie; Owner: postgres
--

CREATE FUNCTION wyswietlanie.rezerwacjeall() RETURNS SETOF public.rezerwacje
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM rezerwacje ORDER BY "ID_rezerwacji";
END $$;


ALTER FUNCTION wyswietlanie.rezerwacjeall() OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 33978)
-- Name: wypozyczone_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wypozyczone_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wypozyczone_seq OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 33979)
-- Name: wypozyczone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wypozyczone (
    "ID_wypozyczenia" integer DEFAULT nextval('public.wypozyczone_seq'::regclass) NOT NULL,
    data_wypozyczenia date NOT NULL,
    pesel bigint,
    data_zwrotu date NOT NULL
);


ALTER TABLE public.wypozyczone OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 33983)
-- Name: wypozyczoneall(); Type: FUNCTION; Schema: wyswietlanie; Owner: postgres
--

CREATE FUNCTION wyswietlanie.wypozyczoneall() RETURNS SETOF public.wypozyczone
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM wypozyczone ORDER BY "ID_wypozyczenia";
END $$;


ALTER FUNCTION wyswietlanie.wypozyczoneall() OWNER TO postgres;

--
-- TOC entry 245 (class 1255 OID 33984)
-- Name: wyswietlegzemplarze(text); Type: FUNCTION; Schema: wyswietlanie; Owner: postgres
--

CREATE FUNCTION wyswietlanie.wyswietlegzemplarze(rejestracja_ text) RETURNS public.egzemplarze
    LANGUAGE plpgsql
    AS $$
DECLARE
rekord egzemplarze;
BEGIN
SELECT * INTO rekord FROM egzemplarze WHERE Rejestracja_ = "Rejestracja" ORDER BY "ID_modelu";
RETURN rekord;
END;
$$;


ALTER FUNCTION wyswietlanie.wyswietlegzemplarze(rejestracja_ text) OWNER TO postgres;

--
-- TOC entry 246 (class 1255 OID 33985)
-- Name: wyswietlklienci(bigint); Type: FUNCTION; Schema: wyswietlanie; Owner: postgres
--

CREATE FUNCTION wyswietlanie.wyswietlklienci(pesel_ bigint) RETURNS public.klienci
    LANGUAGE plpgsql
    AS $$
DECLARE
rekord klienci;
BEGIN
SELECT * INTO rekord FROM klienci WHERE pesel_ = "pesel";
RETURN rekord;
END;
$$;


ALTER FUNCTION wyswietlanie.wyswietlklienci(pesel_ bigint) OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 33986)
-- Name: wyswietlmodele(integer); Type: FUNCTION; Schema: wyswietlanie; Owner: postgres
--

CREATE FUNCTION wyswietlanie.wyswietlmodele(id_modelu_ integer) RETURNS public.modele
    LANGUAGE plpgsql
    AS $$
DECLARE
rekord modele;
BEGIN
SELECT * INTO rekord FROM modele WHERE ID_modelu_ = "ID_modelu";
RETURN rekord;
END;
$$;


ALTER FUNCTION wyswietlanie.wyswietlmodele(id_modelu_ integer) OWNER TO postgres;

--
-- TOC entry 248 (class 1255 OID 33987)
-- Name: wyswietlpracownicy(integer); Type: FUNCTION; Schema: wyswietlanie; Owner: postgres
--

CREATE FUNCTION wyswietlanie.wyswietlpracownicy(id_pracownika_ integer) RETURNS public.pracownicy
    LANGUAGE plpgsql
    AS $$
DECLARE
rekord pracownicy;
BEGIN
SELECT * INTO rekord FROM pracownicy WHERE ID_pracownika_ = "ID_pracownika";
RETURN rekord;
END;
$$;


ALTER FUNCTION wyswietlanie.wyswietlpracownicy(id_pracownika_ integer) OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 33988)
-- Name: wyswietlrezerwacje(integer); Type: FUNCTION; Schema: wyswietlanie; Owner: postgres
--

CREATE FUNCTION wyswietlanie.wyswietlrezerwacje(id_rezerwacji_ integer) RETURNS public.rezerwacje
    LANGUAGE plpgsql
    AS $$
DECLARE
rekord rezerwacje;
BEGIN
SELECT * INTO rekord FROM rezerwacje WHERE ID_rezerwacji_ = "ID_rezerwacji";
RETURN rekord;
END;
$$;


ALTER FUNCTION wyswietlanie.wyswietlrezerwacje(id_rezerwacji_ integer) OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 33989)
-- Name: wyswietlwypozyczone(integer); Type: FUNCTION; Schema: wyswietlanie; Owner: postgres
--

CREATE FUNCTION wyswietlanie.wyswietlwypozyczone(id_wypozyczenia_ integer) RETURNS public.wypozyczone
    LANGUAGE plpgsql
    AS $$
DECLARE
rekord wypozyczone;
BEGIN
SELECT * INTO rekord FROM wypozyczone WHERE ID_wypozyczenia_ = "ID_wypozyczenia";
RETURN rekord;
END;
$$;


ALTER FUNCTION wyswietlanie.wyswietlwypozyczone(id_wypozyczenia_ integer) OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 33990)
-- Name: rezerwacje_egzemplarze; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rezerwacje_egzemplarze (
    "rezerwacje_ID_rezerwacji" integer NOT NULL,
    "egzemplarze_Rejestracja" text NOT NULL
);


ALTER TABLE public.rezerwacje_egzemplarze OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 33995)
-- Name: rezerwacje_id_rezerwacji_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rezerwacje_id_rezerwacji_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rezerwacje_id_rezerwacji_seq OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 33996)
-- Name: wypozyczone_egzemplarze; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wypozyczone_egzemplarze (
    "wypozyczone_ID_wypozyczenia" integer NOT NULL,
    "egzemplarze_Rejestracja" text NOT NULL
);


ALTER TABLE public.wypozyczone_egzemplarze OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 34001)
-- Name: wypozyczone_id_wypozyczenia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wypozyczone_id_wypozyczenia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wypozyczone_id_wypozyczenia_seq OWNER TO postgres;

--
-- TOC entry 4933 (class 0 OID 33939)
-- Dependencies: 228
-- Data for Name: egzemplarze; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.egzemplarze ("Rejestracja", kolor, "ID_modelu", rok_produkcji, cena, przebieg) FROM stdin;
ABC123	Czarny	2	2019-07-05	1000	47000
WW9101	Czarny	3	2020-06-25	3200	4000
WW1122	Różowy	4	2017-04-15	2710	6000
WW3344	Szary	5	2016-11-10	2500	7500
WW5566	Zielony	6	2019-07-05	3100	4700
WW5678	Niebieski	2	2018-03-12	2800	5500
\.


--
-- TOC entry 4934 (class 0 OID 33946)
-- Dependencies: 229
-- Data for Name: klienci; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.klienci (pesel, imie, nazwisko, email, telefon) FROM stdin;
12345678902	Ewa	Kowalska	ewa.kowalska@example.com	234567890
12345678903	Marcin	Wiśniewski	marcin.w@example.com	345678901
12345678905	Grzegorz	Mazur	grzegorz.mazur@example.com	567890123
12345678901	Adam	Nowak	adam.nowak@example.comm	123456789
12345678904	Natalia	Zielińska	n.zielinska@example.com	456789012
11111111111	Jan	Kowalski	janKowalski@example.com	324456651
12345678906	Anna	Sikorska	iwona.s@example.com	678901234
\.


--
-- TOC entry 4936 (class 0 OID 33954)
-- Dependencies: 231
-- Data for Name: modele; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.modele ("ID_modelu", marka, model, pojemnosc_silnika, moc_silnika, opiekun) FROM stdin;
3	BMW	3 Series	2500	22	3
5	Honda	Civic	1800	140	5
2	Ford	Focus	2000	150	2
6	Mercedes	C-Class	2200	160	6
4	Audi	A3	3000	222	4
\.


--
-- TOC entry 4938 (class 0 OID 33964)
-- Dependencies: 233
-- Data for Name: pracownicy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pracownicy ("ID_pracownika", imie, nazwisko, wynagrodzenie_bazowe, data_zatrudnienia) FROM stdin;
6	Joanna	Mazur	4600	2020-11-30
7	Tomasz	Sikora	4800	2019-12-15
8	Michał	Dąbrowski	3900	2021-06-05
10	Maria	Król	4300	2018-03-28
1	Jan	Kowal	4001	2020-01-15
150	Tomasz	Sikora	4800	2019-12-15
4	Katarzyna	Wójcik	4700	2018-07-25
5	Marek	Zielińskii	4200	2022-02-01
9	Paweł	Zając	5100	2017-08-17
3	Piotr	Wiśniewski	3700	2021-05-10
2	Anna	Nowak	2000	2019-03-20
152	Bogdan	Nowak	4000	2019-12-12
\.


--
-- TOC entry 4940 (class 0 OID 33973)
-- Dependencies: 235
-- Data for Name: rezerwacje; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rezerwacje ("ID_rezerwacji", pesel, data_rozpoczecia, data_zakonczenia) FROM stdin;
19	11111111111	2025-01-18	2025-01-30
\.


--
-- TOC entry 4943 (class 0 OID 33990)
-- Dependencies: 238
-- Data for Name: rezerwacje_egzemplarze; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rezerwacje_egzemplarze ("rezerwacje_ID_rezerwacji", "egzemplarze_Rejestracja") FROM stdin;
19	WW9101
\.


--
-- TOC entry 4942 (class 0 OID 33979)
-- Dependencies: 237
-- Data for Name: wypozyczone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wypozyczone ("ID_wypozyczenia", data_wypozyczenia, pesel, data_zwrotu) FROM stdin;
2	2023-02-10	12345678902	2023-02-20
3	2023-03-15	12345678903	2023-03-25
4	2023-04-20	12345678904	2023-04-30
5	2023-05-25	12345678905	2023-06-04
6	2023-06-30	12345678906	2023-07-10
1	2023-01-01	12345678901	2023-01-15
36	2025-01-13	11111111111	2025-01-28
\.


--
-- TOC entry 4945 (class 0 OID 33996)
-- Dependencies: 240
-- Data for Name: wypozyczone_egzemplarze; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wypozyczone_egzemplarze ("wypozyczone_ID_wypozyczenia", "egzemplarze_Rejestracja") FROM stdin;
2	WW5678
3	WW9101
4	WW1122
5	WW3344
6	WW5566
36	WW5678
\.


--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 230
-- Name: modele_id_modelu_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.modele_id_modelu_seq', 42, true);


--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 232
-- Name: pracownicy_id_pracownika_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pracownicy_id_pracownika_seq', 160, true);


--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 239
-- Name: rezerwacje_id_rezerwacji_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rezerwacje_id_rezerwacji_seq', 7, true);


--
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 234
-- Name: rezerwacje_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rezerwacje_seq', 24, true);


--
-- TOC entry 4956 (class 0 OID 0)
-- Dependencies: 241
-- Name: wypozyczone_id_wypozyczenia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wypozyczone_id_wypozyczenia_seq', 11, true);


--
-- TOC entry 4957 (class 0 OID 0)
-- Dependencies: 236
-- Name: wypozyczone_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wypozyczone_seq', 37, true);


--
-- TOC entry 4761 (class 2606 OID 34003)
-- Name: egzemplarze Egzemplarze_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egzemplarze
    ADD CONSTRAINT "Egzemplarze_pkey" PRIMARY KEY ("Rejestracja");


--
-- TOC entry 4763 (class 2606 OID 34005)
-- Name: klienci klienci_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_email_key UNIQUE (email);


--
-- TOC entry 4765 (class 2606 OID 34007)
-- Name: klienci klienci_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_pkey PRIMARY KEY (pesel);


--
-- TOC entry 4767 (class 2606 OID 34009)
-- Name: klienci klienci_telefon_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_telefon_key UNIQUE (telefon);


--
-- TOC entry 4769 (class 2606 OID 34011)
-- Name: modele modele_marka_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_marka_key UNIQUE (marka);


--
-- TOC entry 4771 (class 2606 OID 34013)
-- Name: modele modele_model_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_model_key UNIQUE (model);


--
-- TOC entry 4773 (class 2606 OID 34015)
-- Name: modele modele_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_pkey PRIMARY KEY ("ID_modelu");


--
-- TOC entry 4775 (class 2606 OID 34017)
-- Name: pracownicy pracownicy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pracownicy
    ADD CONSTRAINT pracownicy_pkey PRIMARY KEY ("ID_pracownika");


--
-- TOC entry 4777 (class 2606 OID 34019)
-- Name: rezerwacje rezerwacje_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje
    ADD CONSTRAINT rezerwacje_pkey PRIMARY KEY ("ID_rezerwacji");


--
-- TOC entry 4779 (class 2606 OID 34021)
-- Name: wypozyczone wypozyczone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczone
    ADD CONSTRAINT wypozyczone_pkey PRIMARY KEY ("ID_wypozyczenia");


--
-- TOC entry 4780 (class 2606 OID 34022)
-- Name: egzemplarze egzemplarze_ID_modelu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egzemplarze
    ADD CONSTRAINT "egzemplarze_ID_modelu_fkey" FOREIGN KEY ("ID_modelu") REFERENCES public.modele("ID_modelu") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4781 (class 2606 OID 34027)
-- Name: modele modele_opiekun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_opiekun_fkey FOREIGN KEY (opiekun) REFERENCES public.pracownicy("ID_pracownika") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4782 (class 2606 OID 34032)
-- Name: rezerwacje rezerwacje_ID_klienta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje
    ADD CONSTRAINT "rezerwacje_ID_klienta_fkey" FOREIGN KEY (pesel) REFERENCES public.klienci(pesel) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4784 (class 2606 OID 34037)
-- Name: rezerwacje_egzemplarze rezerwacje_egzemplarze_egzemplarze_Rejestracja_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje_egzemplarze
    ADD CONSTRAINT "rezerwacje_egzemplarze_egzemplarze_Rejestracja_fkey" FOREIGN KEY ("egzemplarze_Rejestracja") REFERENCES public.egzemplarze("Rejestracja") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4785 (class 2606 OID 34042)
-- Name: rezerwacje_egzemplarze rezerwacje_egzemplarze_rezerwacje_ID_rezerwacji_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje_egzemplarze
    ADD CONSTRAINT "rezerwacje_egzemplarze_rezerwacje_ID_rezerwacji_fkey" FOREIGN KEY ("rezerwacje_ID_rezerwacji") REFERENCES public.rezerwacje("ID_rezerwacji") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4783 (class 2606 OID 34047)
-- Name: wypozyczone wypozyczone_ID_klienta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczone
    ADD CONSTRAINT "wypozyczone_ID_klienta_fkey" FOREIGN KEY (pesel) REFERENCES public.klienci(pesel) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- TOC entry 4786 (class 2606 OID 34052)
-- Name: wypozyczone_egzemplarze wypozyczone_egzemplarze_egzemplarze_Rejestracja_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczone_egzemplarze
    ADD CONSTRAINT "wypozyczone_egzemplarze_egzemplarze_Rejestracja_fkey" FOREIGN KEY ("egzemplarze_Rejestracja") REFERENCES public.egzemplarze("Rejestracja") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4787 (class 2606 OID 34057)
-- Name: wypozyczone_egzemplarze wypozyczone_egzemplarze_wypozyczone_ID_wypozyczenia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczone_egzemplarze
    ADD CONSTRAINT "wypozyczone_egzemplarze_wypozyczone_ID_wypozyczenia_fkey" FOREIGN KEY ("wypozyczone_ID_wypozyczenia") REFERENCES public.wypozyczone("ID_wypozyczenia") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


-- Completed on 2025-01-19 09:41:50

--
-- PostgreSQL database dump complete
--

