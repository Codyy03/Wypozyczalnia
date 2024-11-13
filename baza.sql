--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

-- Started on 2024-11-13 21:34:56

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 24581)
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
-- TOC entry 218 (class 1259 OID 24587)
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
-- TOC entry 219 (class 1259 OID 24593)
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
-- TOC entry 220 (class 1259 OID 24600)
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
-- TOC entry 221 (class 1259 OID 24606)
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
-- TOC entry 222 (class 1259 OID 24609)
-- Name: rezerwacje_egzemplarze; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rezerwacje_egzemplarze (
    "rezerwacje_ID_rezerwacji" integer NOT NULL,
    "egzemplarze_Rejestracja" text NOT NULL
);


ALTER TABLE public.rezerwacje_egzemplarze OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24614)
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
-- TOC entry 224 (class 1259 OID 24617)
-- Name: wypozyczone_egzemplarze; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wypozyczone_egzemplarze (
    "wypozyczone_ID_wypozyczenia" integer NOT NULL,
    "egzemplarze_Rejestracja" text NOT NULL
);


ALTER TABLE public.wypozyczone_egzemplarze OWNER TO postgres;

--
-- TOC entry 4846 (class 0 OID 24581)
-- Dependencies: 217
-- Data for Name: egzemplarze; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.egzemplarze ("Rejestracja", kolor, "ID_modelu", rok_produkcji, cena, przebieg) FROM stdin;
WW1234	Czerwony	1	2019-01-01	30000	45000
WW5678	Niebieski	2	2018-03-12	28000	55000
WW9101	Czarny	3	2020-06-25	32000	40000
WW1122	Biały	4	2017-04-15	27000	60000
WW3344	Szary	5	2016-11-10	25000	75000
WW5566	Zielony	6	2019-07-05	31000	47000
WW7788	Czerwony	7	2018-09-21	29500	52000
WW9900	Niebieski	8	2020-02-18	30500	44000
WW2233	Czarny	9	2017-05-30	26500	61000
WW4455	Szary	10	2019-08-10	28500	49000
\.


--
-- TOC entry 4847 (class 0 OID 24587)
-- Dependencies: 218
-- Data for Name: klienci; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.klienci (pesel, imie, nazwisko, email, telefon) FROM stdin;
12345678901	Adam	Nowak	adam.nowak@example.com	123456789
12345678902	Ewa	Kowalska	ewa.kowalska@example.com	234567890
12345678903	Marcin	Wiśniewski	marcin.w@example.com	345678901
12345678904	Natalia	Zielińska	n.zielinska@example.com	456789012
12345678905	Grzegorz	Mazur	grzegorz.mazur@example.com	567890123
12345678906	Iwona	Sikorska	iwona.s@example.com	678901234
12345678907	Dariusz	Król	dariusz.k@example.com	789012345
12345678908	Justyna	Dąbrowska	justyna.d@example.com	890123456
12345678909	Agnieszka	Wójcik	agnieszka.w@example.com	901234567
12345678910	Patryk	Zając	patryk.z@example.com	123098456
\.


--
-- TOC entry 4848 (class 0 OID 24593)
-- Dependencies: 219
-- Data for Name: modele; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.modele ("ID_modelu", marka, model, pojemnosc_silnika, moc_silnika, opiekun) FROM stdin;
1	Toyota	Corolla	1600	132	1
2	Ford	Focus	2000	150	2
3	BMW	3 Series	2500	190	3
4	Audi	A4	2000	170	4
5	Honda	Civic	1800	140	5
6	Mercedes	C-Class	2200	160	6
7	Volkswagen	Golf	1400	130	7
8	Mazda	3	1600	120	8
9	Skoda	Octavia	1800	150	9
10	Hyundai	Elantra	2000	147	10
\.


--
-- TOC entry 4849 (class 0 OID 24600)
-- Dependencies: 220
-- Data for Name: pracownicy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pracownicy ("ID_pracownika", imie, nazwisko, wynagrodzenie_bazowe, data_zatrudnienia) FROM stdin;
1	Jan	Kowalski	4000	2020-01-15
2	Anna	Nowak	4500	2019-03-20
3	Piotr	Wiśniewski	3800	2021-05-10
4	Katarzyna	Wójcik	5000	2018-07-25
5	Marek	Zieliński	4200	2022-02-01
6	Joanna	Mazur	4600	2020-11-30
7	Tomasz	Sikora	4800	2019-12-15
8	Michał	Dąbrowski	3900	2021-06-05
9	Paweł	Zając	5100	2017-08-17
10	Maria	Król	4300	2018-03-28
\.


--
-- TOC entry 4850 (class 0 OID 24606)
-- Dependencies: 221
-- Data for Name: rezerwacje; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rezerwacje ("ID_rezerwacji", pesel, data_rozpoczecia, data_zakonczenia) FROM stdin;
1	12345678901	2024-01-05	2024-01-15
2	12345678902	2024-02-10	2024-02-20
3	12345678903	2024-03-15	2024-03-25
4	12345678904	2024-04-20	2024-04-30
5	12345678905	2024-05-25	2024-06-04
6	12345678906	2024-06-30	2024-07-10
7	12345678907	2024-07-15	2024-07-25
8	12345678908	2024-08-20	2024-08-30
9	12345678909	2024-09-05	2024-09-15
10	12345678910	2024-10-10	2024-10-20
\.


--
-- TOC entry 4851 (class 0 OID 24609)
-- Dependencies: 222
-- Data for Name: rezerwacje_egzemplarze; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rezerwacje_egzemplarze ("rezerwacje_ID_rezerwacji", "egzemplarze_Rejestracja") FROM stdin;
1	WW1234
2	WW5678
3	WW9101
4	WW1122
5	WW3344
6	WW5566
7	WW7788
8	WW9900
9	WW2233
10	WW4455
\.


--
-- TOC entry 4852 (class 0 OID 24614)
-- Dependencies: 223
-- Data for Name: wypozyczone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wypozyczone ("ID_wypozyczenia", data_wypozyczenia, pesel, data_zwrotu) FROM stdin;
1	2023-01-05	12345678901	2023-01-15
2	2023-02-10	12345678902	2023-02-20
3	2023-03-15	12345678903	2023-03-25
4	2023-04-20	12345678904	2023-04-30
5	2023-05-25	12345678905	2023-06-04
6	2023-06-30	12345678906	2023-07-10
7	2023-07-15	12345678907	2023-07-25
8	2023-08-20	12345678908	2023-08-30
9	2023-09-05	12345678909	2023-09-15
10	2023-10-10	12345678910	2023-10-20
\.


--
-- TOC entry 4853 (class 0 OID 24617)
-- Dependencies: 224
-- Data for Name: wypozyczone_egzemplarze; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wypozyczone_egzemplarze ("wypozyczone_ID_wypozyczenia", "egzemplarze_Rejestracja") FROM stdin;
1	WW1234
2	WW5678
3	WW9101
4	WW1122
5	WW3344
6	WW5566
7	WW7788
8	WW9900
9	WW2233
10	WW4455
\.


--
-- TOC entry 4674 (class 2606 OID 24623)
-- Name: egzemplarze Egzemplarze_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egzemplarze
    ADD CONSTRAINT "Egzemplarze_pkey" PRIMARY KEY ("Rejestracja");


--
-- TOC entry 4676 (class 2606 OID 24625)
-- Name: klienci klienci_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_email_key UNIQUE (email);


--
-- TOC entry 4678 (class 2606 OID 24627)
-- Name: klienci klienci_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_pkey PRIMARY KEY (pesel);


--
-- TOC entry 4680 (class 2606 OID 24629)
-- Name: klienci klienci_telefon_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_telefon_key UNIQUE (telefon);


--
-- TOC entry 4682 (class 2606 OID 24631)
-- Name: modele modele_marka_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_marka_key UNIQUE (marka);


--
-- TOC entry 4684 (class 2606 OID 24633)
-- Name: modele modele_model_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_model_key UNIQUE (model);


--
-- TOC entry 4686 (class 2606 OID 24635)
-- Name: modele modele_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_pkey PRIMARY KEY ("ID_modelu");


--
-- TOC entry 4688 (class 2606 OID 24637)
-- Name: pracownicy pracownicy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pracownicy
    ADD CONSTRAINT pracownicy_pkey PRIMARY KEY ("ID_pracownika");


--
-- TOC entry 4690 (class 2606 OID 24639)
-- Name: rezerwacje rezerwacje_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje
    ADD CONSTRAINT rezerwacje_pkey PRIMARY KEY ("ID_rezerwacji");


--
-- TOC entry 4692 (class 2606 OID 24641)
-- Name: wypozyczone wypozyczone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczone
    ADD CONSTRAINT wypozyczone_pkey PRIMARY KEY ("ID_wypozyczenia");


--
-- TOC entry 4693 (class 2606 OID 24642)
-- Name: egzemplarze egzemplarze_ID_modelu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egzemplarze
    ADD CONSTRAINT "egzemplarze_ID_modelu_fkey" FOREIGN KEY ("ID_modelu") REFERENCES public.modele("ID_modelu") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4694 (class 2606 OID 24647)
-- Name: modele modele_opiekun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_opiekun_fkey FOREIGN KEY (opiekun) REFERENCES public.pracownicy("ID_pracownika") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4695 (class 2606 OID 24652)
-- Name: rezerwacje rezerwacje_ID_klienta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje
    ADD CONSTRAINT "rezerwacje_ID_klienta_fkey" FOREIGN KEY (pesel) REFERENCES public.klienci(pesel) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4696 (class 2606 OID 24657)
-- Name: rezerwacje_egzemplarze rezerwacje_egzemplarze_egzemplarze_Rejestracja_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje_egzemplarze
    ADD CONSTRAINT "rezerwacje_egzemplarze_egzemplarze_Rejestracja_fkey" FOREIGN KEY ("egzemplarze_Rejestracja") REFERENCES public.egzemplarze("Rejestracja") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4697 (class 2606 OID 24662)
-- Name: rezerwacje_egzemplarze rezerwacje_egzemplarze_rezerwacje_ID_rezerwacji_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezerwacje_egzemplarze
    ADD CONSTRAINT "rezerwacje_egzemplarze_rezerwacje_ID_rezerwacji_fkey" FOREIGN KEY ("rezerwacje_ID_rezerwacji") REFERENCES public.rezerwacje("ID_rezerwacji") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4698 (class 2606 OID 24667)
-- Name: wypozyczone wypozyczone_ID_klienta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczone
    ADD CONSTRAINT "wypozyczone_ID_klienta_fkey" FOREIGN KEY (pesel) REFERENCES public.klienci(pesel) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- TOC entry 4699 (class 2606 OID 24672)
-- Name: wypozyczone_egzemplarze wypozyczone_egzemplarze_egzemplarze_Rejestracja_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczone_egzemplarze
    ADD CONSTRAINT "wypozyczone_egzemplarze_egzemplarze_Rejestracja_fkey" FOREIGN KEY ("egzemplarze_Rejestracja") REFERENCES public.egzemplarze("Rejestracja") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4700 (class 2606 OID 24677)
-- Name: wypozyczone_egzemplarze wypozyczone_egzemplarze_wypozyczone_ID_wypozyczenia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczone_egzemplarze
    ADD CONSTRAINT "wypozyczone_egzemplarze_wypozyczone_ID_wypozyczenia_fkey" FOREIGN KEY ("wypozyczone_ID_wypozyczenia") REFERENCES public.wypozyczone("ID_wypozyczenia") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


-- Completed on 2024-11-13 21:34:56

--
-- PostgreSQL database dump complete
--

