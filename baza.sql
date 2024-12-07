--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

-- Started on 2024-12-07 21:16:17

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
-- TOC entry 885 (class 1247 OID 24688)
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
-- TOC entry 227 (class 1255 OID 24689)
-- Name: dodajegzemplarz(text, text, integer, date, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.dodajegzemplarz(IN rejestracja text, IN kolor text, IN id_modelu integer, IN rok_produkcji date, IN cena integer, IN przebieg integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO egzemplarze("Rejestracja", kolor, "ID_modelu", rok_produkcji, cena, przebieg)
    VALUES (rejestracja, kolor, id_modelu, rok_produkcji, cena,przebieg);
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Samochod o podanej rejestracji juz instnieje';
END;
$$;


ALTER PROCEDURE public.dodajegzemplarz(IN rejestracja text, IN kolor text, IN id_modelu integer, IN rok_produkcji date, IN cena integer, IN przebieg integer) OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 24690)
-- Name: dodajklienta(bigint, text, text, text, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.dodajklienta(IN pesel bigint, IN imie text, IN nazwisko text, IN email text, IN telefon bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO klienci(pesel, imie, nazwisko, email, telefon)
    VALUES (pesel, imie, nazwisko, email, telefon);
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Klient o podanym PESEL lub email już istnieje.';
END;
$$;


ALTER PROCEDURE public.dodajklienta(IN pesel bigint, IN imie text, IN nazwisko text, IN email text, IN telefon bigint) OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 24691)
-- Name: dodajmodel(integer, text, text, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.dodajmodel(IN id_modelu integer, IN marka text, IN model text, IN pojemnosc_silnika integer, IN moc_silnika integer, IN opiekun integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO modele("ID_modelu", marka, model, pojemnosc_silnika, moc_silnika, opiekun)
    VALUES (id_modelu, marka, model, pojemnosc_silnika, moc_silnika,opiekun);
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Model o podanym ID juz istnieje';
END;
$$;


ALTER PROCEDURE public.dodajmodel(IN id_modelu integer, IN marka text, IN model text, IN pojemnosc_silnika integer, IN moc_silnika integer, IN opiekun integer) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 24692)
-- Name: dodajpracownika(integer, text, text, integer, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.dodajpracownika(IN id_pracownika integer, IN imie text, IN nazwisko text, IN wynagrodzenie_bazowe integer, IN data_zatrudnienia date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO pracownicy("ID_pracownika", imie, nazwisko, wynagrodzenie_bazowe, data_zatrudnienia)
    VALUES (id_pracownika, imie, nazwisko, wynagrodzenie_bazowe, data_zatrudnienia);
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Pracownik o podanym ID juz istnieje';
END;
$$;


ALTER PROCEDURE public.dodajpracownika(IN id_pracownika integer, IN imie text, IN nazwisko text, IN wynagrodzenie_bazowe integer, IN data_zatrudnienia date) OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 24693)
-- Name: dodajrezerwacje(integer, bigint, date, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.dodajrezerwacje(IN id_rezerwacji integer, IN pesel bigint, IN data_rozpoczecia date, IN data_zakonczenia date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO rezerwacje("ID_rezerwacji", pesel, data_rozpoczecia, data_zakonczenia)
    VALUES (id_rezerwacji, pesel, data_rozpoczecia, data_zakonczenia);
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Rezerwacja o podanym ID juz istnieje';
END;
$$;


ALTER PROCEDURE public.dodajrezerwacje(IN id_rezerwacji integer, IN pesel bigint, IN data_rozpoczecia date, IN data_zakonczenia date) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 24694)
-- Name: dodajwypozyczone(integer, date, bigint, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.dodajwypozyczone(IN id_wypozyczenia integer, IN data_wypozyczenia date, IN pesel bigint, IN data_zwrotu date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO wypozyczone("ID_wypozyczenia", data_wypozyczenia, pesel, data_zwrotu)
    VALUES (id_wypozyczenia, data_wypozyczenia, pesel, data_zwrotu);
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Wypozyczenie o podanym ID juz istnieje';
END;
$$;


ALTER PROCEDURE public.dodajwypozyczone(IN id_wypozyczenia integer, IN data_wypozyczenia date, IN pesel bigint, IN data_zwrotu date) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 24709)
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
-- TOC entry 226 (class 1255 OID 24810)
-- Name: egzemplarzeall(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.egzemplarzeall() RETURNS SETOF public.egzemplarze
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM egzemplarze;
END $$;


ALTER FUNCTION public.egzemplarzeall() OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24715)
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
-- TOC entry 228 (class 1255 OID 24811)
-- Name: klienciall(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.klienciall() RETURNS SETOF public.klienci
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM klienci;
END $$;


ALTER FUNCTION public.klienciall() OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24721)
-- Name: modele; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.modele (
    "ID_modelu" integer NOT NULL,
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
-- TOC entry 233 (class 1255 OID 24812)
-- Name: modeleall(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modeleall() RETURNS SETOF public.modele
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM modele;
END $$;


ALTER FUNCTION public.modeleall() OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 24695)
-- Name: modyfikujegzemplarz(text, text, integer, date, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.modyfikujegzemplarz(IN rejestracja_ text, IN kolor_ text DEFAULT NULL::text, IN id_modelu_ integer DEFAULT NULL::integer, IN rok_produkcji_ date DEFAULT NULL::date, IN cena_ integer DEFAULT NULL::integer, IN przebieg_ integer DEFAULT NULL::integer)
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


ALTER PROCEDURE public.modyfikujegzemplarz(IN rejestracja_ text, IN kolor_ text, IN id_modelu_ integer, IN rok_produkcji_ date, IN cena_ integer, IN przebieg_ integer) OWNER TO postgres;

--
-- TOC entry 257 (class 1255 OID 24696)
-- Name: modyfikujklienta(bigint, text, text, text, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.modyfikujklienta(IN pesel_ bigint, IN imie_ text DEFAULT NULL::text, IN nazwisko_ text DEFAULT NULL::text, IN email_ text DEFAULT NULL::text, IN telefon_ bigint DEFAULT NULL::bigint)
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


ALTER PROCEDURE public.modyfikujklienta(IN pesel_ bigint, IN imie_ text, IN nazwisko_ text, IN email_ text, IN telefon_ bigint) OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 24697)
-- Name: modyfikujmodel(integer, text, text, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.modyfikujmodel(IN id_modelu_ integer, IN marka_ text DEFAULT NULL::text, IN model_ text DEFAULT NULL::text, IN pojemnosc_silnika_ integer DEFAULT NULL::integer, IN moc_silnika_ integer DEFAULT NULL::integer, IN opiekun_ integer DEFAULT NULL::integer)
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


ALTER PROCEDURE public.modyfikujmodel(IN id_modelu_ integer, IN marka_ text, IN model_ text, IN pojemnosc_silnika_ integer, IN moc_silnika_ integer, IN opiekun_ integer) OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 24698)
-- Name: modyfikujpracownika(integer, text, text, integer, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.modyfikujpracownika(IN id_pracownika_ integer, IN imie_ text DEFAULT NULL::text, IN nazwisko_ text DEFAULT NULL::text, IN wynagrodzenie_bazowe_ integer DEFAULT NULL::integer, IN data_zatrudnienia_ date DEFAULT NULL::date)
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


ALTER PROCEDURE public.modyfikujpracownika(IN id_pracownika_ integer, IN imie_ text, IN nazwisko_ text, IN wynagrodzenie_bazowe_ integer, IN data_zatrudnienia_ date) OWNER TO postgres;

--
-- TOC entry 244 (class 1255 OID 24824)
-- Name: modyfikujrezerwacje(integer, bigint, date, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.modyfikujrezerwacje(IN id_rezerwacji_ integer, IN pesel_ bigint, IN data_rozpoczecia_ date, IN data_zakonczenia_ date)
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


ALTER PROCEDURE public.modyfikujrezerwacje(IN id_rezerwacji_ integer, IN pesel_ bigint, IN data_rozpoczecia_ date, IN data_zakonczenia_ date) OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 24700)
-- Name: modyfikujwypozyczone(integer, date, bigint, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.modyfikujwypozyczone(IN id_wypozyczenia_ integer, IN data_wypozyczenia_ date DEFAULT NULL::date, IN pesel_ bigint DEFAULT NULL::bigint, IN data_zwrotu_ date DEFAULT NULL::date)
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


ALTER PROCEDURE public.modyfikujwypozyczone(IN id_wypozyczenia_ integer, IN data_wypozyczenia_ date, IN pesel_ bigint, IN data_zwrotu_ date) OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24728)
-- Name: pracownicy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pracownicy (
    "ID_pracownika" integer NOT NULL,
    imie text NOT NULL,
    nazwisko text NOT NULL,
    wynagrodzenie_bazowe integer NOT NULL,
    data_zatrudnienia date NOT NULL,
    CONSTRAINT pracownicy_wynagrodzenie_bazowe_check CHECK ((wynagrodzenie_bazowe > 0))
);


ALTER TABLE public.pracownicy OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 24813)
-- Name: pracownicyall(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pracownicyall() RETURNS SETOF public.pracownicy
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM pracownicy;
END $$;


ALTER FUNCTION public.pracownicyall() OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24734)
-- Name: rezerwacje; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rezerwacje (
    "ID_rezerwacji" integer NOT NULL,
    pesel bigint NOT NULL,
    data_rozpoczecia date NOT NULL,
    data_zakonczenia date NOT NULL
);


ALTER TABLE public.rezerwacje OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 24814)
-- Name: rezerwacjeall(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rezerwacjeall() RETURNS SETOF public.rezerwacje
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM rezerwacje;
END $$;


ALTER FUNCTION public.rezerwacjeall() OWNER TO postgres;

--
-- TOC entry 261 (class 1255 OID 24701)
-- Name: usunegzemplarz(text); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.usunegzemplarz(IN rejestracja_ text)
    LANGUAGE plpgsql
    AS $$
BEGIN
   DELETE FROM egzemplarze WHERE "Rejestracja" = rejestracja_; 
   IF NOT FOUND THEN RAISE NOTICE 'Egzemplarz o podanej rejestracji nie istnieje';
   END IF;
END;
$$;


ALTER PROCEDURE public.usunegzemplarz(IN rejestracja_ text) OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 24702)
-- Name: usunklienta(bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.usunklienta(IN pesel_ bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM klienci WHERE pesel_=klienci.pesel;
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Klient o podanym PESEL nie istnieje.';
END;
$$;


ALTER PROCEDURE public.usunklienta(IN pesel_ bigint) OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 24703)
-- Name: usunmodel(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.usunmodel(IN id_modelu_ integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
   DELETE FROM modele WHERE "ID_modelu" = id_modelu_; 
   IF NOT FOUND THEN RAISE NOTICE 'Model o podanym ID nie istnieje';
   END IF;
END;
$$;


ALTER PROCEDURE public.usunmodel(IN id_modelu_ integer) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 24704)
-- Name: usunpracownika(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.usunpracownika(IN id_pracownika_ integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
   DELETE FROM pracownicy WHERE "ID_pracownika" = id_pracownika_; 
   IF NOT FOUND THEN RAISE NOTICE 'Pracownik o podanym ID nie istnieje';
   END IF;
END;
$$;


ALTER PROCEDURE public.usunpracownika(IN id_pracownika_ integer) OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 24705)
-- Name: usunrezerwacje(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.usunrezerwacje(IN id_rezerwacji_ integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
   DELETE FROM rezerwacje WHERE "ID_rezerwacji" = id_rezerwacji_; 
   IF NOT FOUND THEN RAISE NOTICE 'Rezerwacja podanym ID nie istnieje';
   END IF;
END;
$$;


ALTER PROCEDURE public.usunrezerwacje(IN id_rezerwacji_ integer) OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 24706)
-- Name: usunwypozyczone(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.usunwypozyczone(IN id_wypozyczenia_ integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
   DELETE FROM wypozyczone WHERE "ID_wypozyczenia" = id_wypozyczenia_; 
   IF NOT FOUND THEN RAISE NOTICE 'Wypozyczenie podanym ID nie istnieje';
   END IF;
END;
$$;


ALTER PROCEDURE public.usunwypozyczone(IN id_wypozyczenia_ integer) OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24742)
-- Name: wypozyczone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wypozyczone (
    "ID_wypozyczenia" integer NOT NULL,
    data_wypozyczenia date NOT NULL,
    pesel bigint,
    data_zwrotu date NOT NULL
);


ALTER TABLE public.wypozyczone OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 24815)
-- Name: wypozyczoneall(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.wypozyczoneall() RETURNS SETOF public.wypozyczone
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM wypozyczone;
END $$;


ALTER FUNCTION public.wypozyczoneall() OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 24817)
-- Name: wyswietlegzemplarze(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.wyswietlegzemplarze(rejestracja_ text) RETURNS public.egzemplarze
    LANGUAGE plpgsql
    AS $$
DECLARE
rekord egzemplarze;
BEGIN
SELECT * INTO rekord FROM egzemplarze WHERE Rejestracja_ = "Rejestracja";
RETURN rekord;
END;
$$;


ALTER FUNCTION public.wyswietlegzemplarze(rejestracja_ text) OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 24818)
-- Name: wyswietlklienci(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.wyswietlklienci(pesel_ bigint) RETURNS public.klienci
    LANGUAGE plpgsql
    AS $$
DECLARE
rekord klienci;
BEGIN
SELECT * INTO rekord FROM klienci WHERE pesel_ = "pesel";
RETURN rekord;
END;
$$;


ALTER FUNCTION public.wyswietlklienci(pesel_ bigint) OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 24819)
-- Name: wyswietlmodele(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.wyswietlmodele(id_modelu_ integer) RETURNS public.modele
    LANGUAGE plpgsql
    AS $$
DECLARE
rekord modele;
BEGIN
SELECT * INTO rekord FROM modele WHERE ID_modelu_ = "ID_modelu";
RETURN rekord;
END;
$$;


ALTER FUNCTION public.wyswietlmodele(id_modelu_ integer) OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 24820)
-- Name: wyswietlpracownicy(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.wyswietlpracownicy(id_pracownika_ integer) RETURNS public.pracownicy
    LANGUAGE plpgsql
    AS $$
DECLARE
rekord pracownicy;
BEGIN
SELECT * INTO rekord FROM pracownicy WHERE ID_pracownika_ = "ID_pracownika";
RETURN rekord;
END;
$$;


ALTER FUNCTION public.wyswietlpracownicy(id_pracownika_ integer) OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 24821)
-- Name: wyswietlrezerwacje(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.wyswietlrezerwacje(id_rezerwacji_ integer) RETURNS public.rezerwacje
    LANGUAGE plpgsql
    AS $$
DECLARE
rekord rezerwacje;
BEGIN
SELECT * INTO rekord FROM rezerwacje WHERE ID_rezerwacji_ = "ID_rezerwacji";
RETURN rekord;
END;
$$;


ALTER FUNCTION public.wyswietlrezerwacje(id_rezerwacji_ integer) OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 24822)
-- Name: wyswietlwypozyczone(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.wyswietlwypozyczone(id_wypozyczenia_ integer) RETURNS public.wypozyczone
    LANGUAGE plpgsql
    AS $$
DECLARE
rekord wypozyczone;
BEGIN
SELECT * INTO rekord FROM wypozyczone WHERE ID_wypozyczenia_ = "ID_wypozyczenia";
RETURN rekord;
END;
$$;


ALTER FUNCTION public.wyswietlwypozyczone(id_wypozyczenia_ integer) OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 24708)
-- Name: znajdzcene(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.znajdzcene(rejestracja_ text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
cena_ integer;
BEGIN
SELECT cena INTO cena_ FROM egzemplarze WHERE "Rejestracja"=rejestracja_;
RETURN cena_;
END;
$$;


ALTER FUNCTION public.znajdzcene(rejestracja_ text) OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24737)
-- Name: rezerwacje_egzemplarze; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rezerwacje_egzemplarze (
    "rezerwacje_ID_rezerwacji" integer NOT NULL,
    "egzemplarze_Rejestracja" text NOT NULL
);


ALTER TABLE public.rezerwacje_egzemplarze OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24745)
-- Name: wypozyczone_egzemplarze; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wypozyczone_egzemplarze (
    "wypozyczone_ID_wypozyczenia" integer NOT NULL,
    "egzemplarze_Rejestracja" text NOT NULL
);


ALTER TABLE public.wypozyczone_egzemplarze OWNER TO postgres;

--
-- TOC entry 4881 (class 0 OID 24709)
-- Dependencies: 218
-- Data for Name: egzemplarze; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.egzemplarze ("Rejestracja", kolor, "ID_modelu", rok_produkcji, cena, przebieg) FROM stdin;
WW5678	Niebieski	2	2018-03-12	28000	55000
WW9101	Czarny	3	2020-06-25	32000	40000
WW3344	Szary	5	2016-11-10	25000	75000
WW5566	Zielony	6	2019-07-05	31000	47000
WW1122	Różowy	4	2017-04-15	271	60000
\.


--
-- TOC entry 4882 (class 0 OID 24715)
-- Dependencies: 219
-- Data for Name: klienci; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.klienci (pesel, imie, nazwisko, email, telefon) FROM stdin;
12345678902	Ewa	Kowalska	ewa.kowalska@example.com	234567890
12345678903	Marcin	Wiśniewski	marcin.w@example.com	345678901
12345678904	Natalia	Zielińska	n.zielinska@example.com	456789012
12345678905	Grzegorz	Mazur	grzegorz.mazur@example.com	567890123
12345678906	Anna	Sikorska	iwona.s@example.com	678901234
12345678901	Adam	Nowak	adam.nowak@example.comm	123456789
\.


--
-- TOC entry 4883 (class 0 OID 24721)
-- Dependencies: 220
-- Data for Name: modele; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.modele ("ID_modelu", marka, model, pojemnosc_silnika, moc_silnika, opiekun) FROM stdin;
4	Audi	A4	3000	222	4
3	BMW	3 Series	2500	22	3
5	Honda	Civic	1800	140	5
2	Ford	Focus	2000	150	2
6	Mercedes	C-Class	2200	160	6
\.


--
-- TOC entry 4884 (class 0 OID 24728)
-- Dependencies: 221
-- Data for Name: pracownicy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pracownicy ("ID_pracownika", imie, nazwisko, wynagrodzenie_bazowe, data_zatrudnienia) FROM stdin;
3	Piotr	Wiśniewski	3800	2021-05-10
4	Katarzyna	Wójcik	5000	2018-07-25
5	Marek	Zieliński	4200	2022-02-01
6	Joanna	Mazur	4600	2020-11-30
7	Tomasz	Sikora	4800	2019-12-15
8	Michał	Dąbrowski	3900	2021-06-05
9	Paweł	Zając	5100	2017-08-17
10	Maria	Król	4300	2018-03-28
1	Jan	Kowal	4001	2020-01-15
2	Anna	Nowak	23	2019-03-20
\.


--
-- TOC entry 4885 (class 0 OID 24734)
-- Dependencies: 222
-- Data for Name: rezerwacje; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rezerwacje ("ID_rezerwacji", pesel, data_rozpoczecia, data_zakonczenia) FROM stdin;
2	12345678902	2024-02-10	2024-02-20
3	12345678903	2024-03-15	2024-03-25
4	12345678904	2024-04-20	2024-04-30
5	12345678905	2024-05-25	2024-06-04
6	12345678906	2024-06-30	2024-07-10
1	12345678901	2024-01-05	2026-01-16
\.


--
-- TOC entry 4886 (class 0 OID 24737)
-- Dependencies: 223
-- Data for Name: rezerwacje_egzemplarze; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rezerwacje_egzemplarze ("rezerwacje_ID_rezerwacji", "egzemplarze_Rejestracja") FROM stdin;
2	WW5678
3	WW9101
4	WW1122
5	WW3344
6	WW5566
\.


--
-- TOC entry 4887 (class 0 OID 24742)
-- Dependencies: 224
-- Data for Name: wypozyczone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wypozyczone ("ID_wypozyczenia", data_wypozyczenia, pesel, data_zwrotu) FROM stdin;
2	2023-02-10	12345678902	2023-02-20
3	2023-03-15	12345678903	2023-03-25
4	2023-04-20	12345678904	2023-04-30
5	2023-05-25	12345678905	2023-06-04
6	2023-06-30	12345678906	2023-07-10
7	2023-07-15	\N	2023-07-25
1	2025-01-01	12345678901	2023-01-15
\.


--
-- TOC entry 4888 (class 0 OID 24745)
-- Dependencies: 225
-- Data for Name: wypozyczone_egzemplarze; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wypozyczone_egzemplarze ("wypozyczone_ID_wypozyczenia", "egzemplarze_Rejestracja") FROM stdin;
2	WW5678
3	WW9101
4	WW1122
5	WW3344
6	WW5566
\.


--
-- TOC entry 4709 (class 2606 OID 24751)
-- Name: egzemplarze Egzemplarze_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egzemplarze
    ADD CONSTRAINT "Egzemplarze_pkey" PRIMARY KEY ("Rejestracja");


--
-- TOC entry 4711 (class 2606 OID 24753)
-- Name: klienci klienci_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_email_key UNIQUE (email);


--
-- TOC entry 4713 (class 2606 OID 24755)
-- Name: klienci klienci_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_pkey PRIMARY KEY (pesel);


--
-- TOC entry 4715 (class 2606 OID 24757)
-- Name: klienci klienci_telefon_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_telefon_key UNIQUE (telefon);


--
-- TOC entry 4717 (class 2606 OID 24759)
-- Name: modele modele_marka_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_marka_key UNIQUE (marka);


--
-- TOC entry 4719 (class 2606 OID 24761)
-- Name: modele modele_model_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_model_key UNIQUE (model);


--
-- TOC entry 4721 (class 2606 OID 24763)
-- Name: modele modele_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_pkey PRIMARY KEY ("ID_modelu");


--
-- TOC entry 4723 (class 2606 OID 24765)
-- Name: pracownicy pracownicy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pracownicy
    ADD CONSTRAINT pracownicy_pkey PRIMARY KEY ("ID_pracownika");


--
-- TOC entry 4725 (class 2606 OID 24767)
-- Name: rezerwacje rezerwacje_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje
    ADD CONSTRAINT rezerwacje_pkey PRIMARY KEY ("ID_rezerwacji");


--
-- TOC entry 4727 (class 2606 OID 24769)
-- Name: wypozyczone wypozyczone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczone
    ADD CONSTRAINT wypozyczone_pkey PRIMARY KEY ("ID_wypozyczenia");


--
-- TOC entry 4728 (class 2606 OID 24770)
-- Name: egzemplarze egzemplarze_ID_modelu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egzemplarze
    ADD CONSTRAINT "egzemplarze_ID_modelu_fkey" FOREIGN KEY ("ID_modelu") REFERENCES public.modele("ID_modelu") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4729 (class 2606 OID 24775)
-- Name: modele modele_opiekun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_opiekun_fkey FOREIGN KEY (opiekun) REFERENCES public.pracownicy("ID_pracownika") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4730 (class 2606 OID 24780)
-- Name: rezerwacje rezerwacje_ID_klienta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje
    ADD CONSTRAINT "rezerwacje_ID_klienta_fkey" FOREIGN KEY (pesel) REFERENCES public.klienci(pesel) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4731 (class 2606 OID 24785)
-- Name: rezerwacje_egzemplarze rezerwacje_egzemplarze_egzemplarze_Rejestracja_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje_egzemplarze
    ADD CONSTRAINT "rezerwacje_egzemplarze_egzemplarze_Rejestracja_fkey" FOREIGN KEY ("egzemplarze_Rejestracja") REFERENCES public.egzemplarze("Rejestracja") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4732 (class 2606 OID 24790)
-- Name: rezerwacje_egzemplarze rezerwacje_egzemplarze_rezerwacje_ID_rezerwacji_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje_egzemplarze
    ADD CONSTRAINT "rezerwacje_egzemplarze_rezerwacje_ID_rezerwacji_fkey" FOREIGN KEY ("rezerwacje_ID_rezerwacji") REFERENCES public.rezerwacje("ID_rezerwacji") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4733 (class 2606 OID 24795)
-- Name: wypozyczone wypozyczone_ID_klienta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczone
    ADD CONSTRAINT "wypozyczone_ID_klienta_fkey" FOREIGN KEY (pesel) REFERENCES public.klienci(pesel) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- TOC entry 4734 (class 2606 OID 24800)
-- Name: wypozyczone_egzemplarze wypozyczone_egzemplarze_egzemplarze_Rejestracja_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczone_egzemplarze
    ADD CONSTRAINT "wypozyczone_egzemplarze_egzemplarze_Rejestracja_fkey" FOREIGN KEY ("egzemplarze_Rejestracja") REFERENCES public.egzemplarze("Rejestracja") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4735 (class 2606 OID 24805)
-- Name: wypozyczone_egzemplarze wypozyczone_egzemplarze_wypozyczone_ID_wypozyczenia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczone_egzemplarze
    ADD CONSTRAINT "wypozyczone_egzemplarze_wypozyczone_ID_wypozyczenia_fkey" FOREIGN KEY ("wypozyczone_ID_wypozyczenia") REFERENCES public.wypozyczone("ID_wypozyczenia") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


-- Completed on 2024-12-07 21:16:17

--
-- PostgreSQL database dump complete
--

