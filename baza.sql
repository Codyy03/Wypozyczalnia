PGDMP                  
    |            wypozyczalnia    17.0    17.0 &    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    16388    wypozyczalnia    DATABASE     �   CREATE DATABASE wypozyczalnia WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Polish_Poland.1250';
    DROP DATABASE wypozyczalnia;
                     postgres    false            �            1259    16427    egzemplarze    TABLE       CREATE TABLE public.egzemplarze (
    "Rejestracja" text NOT NULL,
    kolor text NOT NULL,
    "ID_modelu" integer NOT NULL,
    rok_produkcji date NOT NULL,
    cena integer NOT NULL,
    przebieg integer NOT NULL,
    CONSTRAINT egzemplarze_cena_check CHECK ((cena > 0))
);
    DROP TABLE public.egzemplarze;
       public         heap r       postgres    false            �            1259    16435    klienci    TABLE     �   CREATE TABLE public.klienci (
    pesel bigint NOT NULL,
    imie text NOT NULL,
    nazwisko text NOT NULL,
    email text,
    telefon bigint NOT NULL,
    CONSTRAINT klienci_telefon_check CHECK (((telefon > 0) AND (telefon < 1000000000)))
);
    DROP TABLE public.klienci;
       public         heap r       postgres    false            �            1259    16447    modele    TABLE     d  CREATE TABLE public.modele (
    "ID_modelu" integer NOT NULL,
    marka text NOT NULL,
    model text NOT NULL,
    pojemnosc_silnika integer NOT NULL,
    moc_silnika integer NOT NULL,
    opiekun integer,
    CONSTRAINT modele_moc_silnika_check CHECK ((moc_silnika > 0)),
    CONSTRAINT modele_pojemnosc_silnika_check CHECK ((pojemnosc_silnika > 0))
);
    DROP TABLE public.modele;
       public         heap r       postgres    false            �            1259    16460 
   pracownicy    TABLE     &  CREATE TABLE public.pracownicy (
    "ID_pracownika" integer NOT NULL,
    imie text NOT NULL,
    nazwisko text NOT NULL,
    wynagrodzenie_bazowe integer NOT NULL,
    data_zatrudnienia date NOT NULL,
    CONSTRAINT pracownicy_wynagrodzenie_bazowe_check CHECK ((wynagrodzenie_bazowe > 0))
);
    DROP TABLE public.pracownicy;
       public         heap r       postgres    false            �            1259    16468 
   rezerwacje    TABLE     �   CREATE TABLE public.rezerwacje (
    "ID_rezerwacji" integer NOT NULL,
    pesel bigint NOT NULL,
    data_rozpoczecia date NOT NULL,
    data_zakonczenia date NOT NULL
);
    DROP TABLE public.rezerwacje;
       public         heap r       postgres    false            �            1259    16483    rezerwacje_egzemplarze    TABLE     �   CREATE TABLE public.rezerwacje_egzemplarze (
    "rezerwacje_ID_rezerwacji" integer NOT NULL,
    "egzemplarze_Rejestracja" text NOT NULL
);
 *   DROP TABLE public.rezerwacje_egzemplarze;
       public         heap r       postgres    false            �            1259    16473    wypozyczone    TABLE     �   CREATE TABLE public.wypozyczone (
    "ID_wypozyczenia" integer NOT NULL,
    data_wypozyczenia date NOT NULL,
    pesel bigint,
    data_zwrotu date NOT NULL
);
    DROP TABLE public.wypozyczone;
       public         heap r       postgres    false            �            1259    16478    wypozyczone_egzemplarze    TABLE     �   CREATE TABLE public.wypozyczone_egzemplarze (
    "wypozyczone_ID_wypozyczenia" integer NOT NULL,
    "egzemplarze_Rejestracja" text NOT NULL
);
 +   DROP TABLE public.wypozyczone_egzemplarze;
       public         heap r       postgres    false            �          0    16427    egzemplarze 
   TABLE DATA           g   COPY public.egzemplarze ("Rejestracja", kolor, "ID_modelu", rok_produkcji, cena, przebieg) FROM stdin;
    public               postgres    false    217   5       �          0    16435    klienci 
   TABLE DATA           H   COPY public.klienci (pesel, imie, nazwisko, email, telefon) FROM stdin;
    public               postgres    false    218   6       �          0    16447    modele 
   TABLE DATA           d   COPY public.modele ("ID_modelu", marka, model, pojemnosc_silnika, moc_silnika, opiekun) FROM stdin;
    public               postgres    false    219   ;7       �          0    16460 
   pracownicy 
   TABLE DATA           n   COPY public.pracownicy ("ID_pracownika", imie, nazwisko, wynagrodzenie_bazowe, data_zatrudnienia) FROM stdin;
    public               postgres    false    220   8       �          0    16468 
   rezerwacje 
   TABLE DATA           `   COPY public.rezerwacje ("ID_rezerwacji", pesel, data_rozpoczecia, data_zakonczenia) FROM stdin;
    public               postgres    false    221   9       �          0    16483    rezerwacje_egzemplarze 
   TABLE DATA           g   COPY public.rezerwacje_egzemplarze ("rezerwacje_ID_rezerwacji", "egzemplarze_Rejestracja") FROM stdin;
    public               postgres    false    224   �9       �          0    16473    wypozyczone 
   TABLE DATA           _   COPY public.wypozyczone ("ID_wypozyczenia", data_wypozyczenia, pesel, data_zwrotu) FROM stdin;
    public               postgres    false    222   :       �          0    16478    wypozyczone_egzemplarze 
   TABLE DATA           k   COPY public.wypozyczone_egzemplarze ("wypozyczone_ID_wypozyczenia", "egzemplarze_Rejestracja") FROM stdin;
    public               postgres    false    223   �:       B           2606    16434    egzemplarze Egzemplarze_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.egzemplarze
    ADD CONSTRAINT "Egzemplarze_pkey" PRIMARY KEY ("Rejestracja");
 H   ALTER TABLE ONLY public.egzemplarze DROP CONSTRAINT "Egzemplarze_pkey";
       public                 postgres    false    217            D           2606    16444    klienci klienci_email_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_email_key UNIQUE (email);
 C   ALTER TABLE ONLY public.klienci DROP CONSTRAINT klienci_email_key;
       public                 postgres    false    218            F           2606    16579    klienci klienci_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_pkey PRIMARY KEY (pesel);
 >   ALTER TABLE ONLY public.klienci DROP CONSTRAINT klienci_pkey;
       public                 postgres    false    218            H           2606    16530    klienci klienci_telefon_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_telefon_key UNIQUE (telefon);
 E   ALTER TABLE ONLY public.klienci DROP CONSTRAINT klienci_telefon_key;
       public                 postgres    false    218            J           2606    16457    modele modele_marka_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_marka_key UNIQUE (marka);
 A   ALTER TABLE ONLY public.modele DROP CONSTRAINT modele_marka_key;
       public                 postgres    false    219            L           2606    16459    modele modele_model_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_model_key UNIQUE (model);
 A   ALTER TABLE ONLY public.modele DROP CONSTRAINT modele_model_key;
       public                 postgres    false    219            N           2606    16455    modele modele_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_pkey PRIMARY KEY ("ID_modelu");
 <   ALTER TABLE ONLY public.modele DROP CONSTRAINT modele_pkey;
       public                 postgres    false    219            P           2606    16467    pracownicy pracownicy_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.pracownicy
    ADD CONSTRAINT pracownicy_pkey PRIMARY KEY ("ID_pracownika");
 D   ALTER TABLE ONLY public.pracownicy DROP CONSTRAINT pracownicy_pkey;
       public                 postgres    false    220            R           2606    16472    rezerwacje rezerwacje_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.rezerwacje
    ADD CONSTRAINT rezerwacje_pkey PRIMARY KEY ("ID_rezerwacji");
 D   ALTER TABLE ONLY public.rezerwacje DROP CONSTRAINT rezerwacje_pkey;
       public                 postgres    false    221            T           2606    16477    wypozyczone wypozyczone_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.wypozyczone
    ADD CONSTRAINT wypozyczone_pkey PRIMARY KEY ("ID_wypozyczenia");
 F   ALTER TABLE ONLY public.wypozyczone DROP CONSTRAINT wypozyczone_pkey;
       public                 postgres    false    222            U           2606    16488 &   egzemplarze egzemplarze_ID_modelu_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.egzemplarze
    ADD CONSTRAINT "egzemplarze_ID_modelu_fkey" FOREIGN KEY ("ID_modelu") REFERENCES public.modele("ID_modelu") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 R   ALTER TABLE ONLY public.egzemplarze DROP CONSTRAINT "egzemplarze_ID_modelu_fkey";
       public               postgres    false    219    4686    217            V           2606    16493    modele modele_opiekun_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.modele
    ADD CONSTRAINT modele_opiekun_fkey FOREIGN KEY (opiekun) REFERENCES public.pracownicy("ID_pracownika") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 D   ALTER TABLE ONLY public.modele DROP CONSTRAINT modele_opiekun_fkey;
       public               postgres    false    220    4688    219            W           2606    16598 %   rezerwacje rezerwacje_ID_klienta_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.rezerwacje
    ADD CONSTRAINT "rezerwacje_ID_klienta_fkey" FOREIGN KEY (pesel) REFERENCES public.klienci(pesel) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 Q   ALTER TABLE ONLY public.rezerwacje DROP CONSTRAINT "rezerwacje_ID_klienta_fkey";
       public               postgres    false    218    221    4678            [           2606    16523 J   rezerwacje_egzemplarze rezerwacje_egzemplarze_egzemplarze_Rejestracja_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.rezerwacje_egzemplarze
    ADD CONSTRAINT "rezerwacje_egzemplarze_egzemplarze_Rejestracja_fkey" FOREIGN KEY ("egzemplarze_Rejestracja") REFERENCES public.egzemplarze("Rejestracja") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 v   ALTER TABLE ONLY public.rezerwacje_egzemplarze DROP CONSTRAINT "rezerwacje_egzemplarze_egzemplarze_Rejestracja_fkey";
       public               postgres    false    224    217    4674            \           2606    16518 K   rezerwacje_egzemplarze rezerwacje_egzemplarze_rezerwacje_ID_rezerwacji_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.rezerwacje_egzemplarze
    ADD CONSTRAINT "rezerwacje_egzemplarze_rezerwacje_ID_rezerwacji_fkey" FOREIGN KEY ("rezerwacje_ID_rezerwacji") REFERENCES public.rezerwacje("ID_rezerwacji") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 w   ALTER TABLE ONLY public.rezerwacje_egzemplarze DROP CONSTRAINT "rezerwacje_egzemplarze_rezerwacje_ID_rezerwacji_fkey";
       public               postgres    false    221    224    4690            X           2606    16603 '   wypozyczone wypozyczone_ID_klienta_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.wypozyczone
    ADD CONSTRAINT "wypozyczone_ID_klienta_fkey" FOREIGN KEY (pesel) REFERENCES public.klienci(pesel) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;
 S   ALTER TABLE ONLY public.wypozyczone DROP CONSTRAINT "wypozyczone_ID_klienta_fkey";
       public               postgres    false    218    4678    222            Y           2606    16513 L   wypozyczone_egzemplarze wypozyczone_egzemplarze_egzemplarze_Rejestracja_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.wypozyczone_egzemplarze
    ADD CONSTRAINT "wypozyczone_egzemplarze_egzemplarze_Rejestracja_fkey" FOREIGN KEY ("egzemplarze_Rejestracja") REFERENCES public.egzemplarze("Rejestracja") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 x   ALTER TABLE ONLY public.wypozyczone_egzemplarze DROP CONSTRAINT "wypozyczone_egzemplarze_egzemplarze_Rejestracja_fkey";
       public               postgres    false    223    217    4674            Z           2606    16508 P   wypozyczone_egzemplarze wypozyczone_egzemplarze_wypozyczone_ID_wypozyczenia_fkey    FK CONSTRAINT     
  ALTER TABLE ONLY public.wypozyczone_egzemplarze
    ADD CONSTRAINT "wypozyczone_egzemplarze_wypozyczone_ID_wypozyczenia_fkey" FOREIGN KEY ("wypozyczone_ID_wypozyczenia") REFERENCES public.wypozyczone("ID_wypozyczenia") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 |   ALTER TABLE ONLY public.wypozyczone_egzemplarze DROP CONSTRAINT "wypozyczone_egzemplarze_wypozyczone_ID_wypozyczenia_fkey";
       public               postgres    false    4692    222    223            �   �   x�E��j�0E��Lм�h�}���f.DB�"x��[�+3��5�Hpt��+�(������sN�0�/����YW˥�S�����ށ���ɷ5H�d#�|��/(�q��G`:0"fx���4�
&E2�X���*<{�TF"�Ӡ��Y��ҷ�����}(����J���[�DCv�f!�S���[�#U� U�Y�ۦ��x�X�S5��~�C�����ò,��Wf      �   (  x�]�Kn�0���0V� �"QU-*���f�D��Dv"��)z� ܫ6`p��?����IF�4q=�e���X����|����9I�<sڹU��a��ּB���F�,;�wd)maEO-��(4�#}���Xb�5EXӼ��_=�%R��q����^�̋�Iu90(��4:����G�*��V�é����q�c�#���`�}�%��-9����[5t~�}�N��E�7:�x�B�K�V�}�R�֦�r���\���m+Xcyܥ�9'"�7���_�q��ݻ�      �   �   x�-��n�0E�˯���~���6��!E�tl�"X�l�H�����=��Q�H��:�)�T�e4i��<���K^14�_0O��R�1Y�)�h���a��9͓|�0B�XFE5�G?IG�[�KZ3jj��m�u?~�[��rU��ܟt��W3Z�p�%	���݃�_�rG�q~lbp�n^��m���LD�@�>�      �   �   x�=�Mj�@Fך��H��,]ŸZ�nTc�Į&)�^��=F���^�$��'��'���P�A�}��h҄��Vix�{�瘷`�5�)AM*��� 7���f@�/ F�Ȥ�r�0~G��|�ծ��)Cm��JB���5��~�z�h�8�RXy�M*����Ɍ	�^���Gxq�&����k�P��C�x�߃_T��jmUk������X���!�șb�=�@ΧLro������?W�      �   �   x�M��1�C.^q�8��?�a$�����5=Ģ6�o���u �B2��p<A�#H��@��h���s������
��Y���Xa��������?�9;�}���>�DIg��0�� ��A>      �   H   x�ʹ�@��,��/]%���:Le��s�����GE��I�G���*4�=�����f�P�"2� ~���      �   {   x�U���0�Q/tX>zI�u,�P"�9J (��Zci엨usm�O��h.���d���I�N=��dR�8J��1X��ꉚ4�����'5��}��`�?	�����~�A*      �   H   x�ʹ�@��,��/]%���:Le��s�����GE��I�G���*4�=�����f�P�"2� ~���     