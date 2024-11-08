# Wypożyczalnia
Rozpatrzmy bazę danych stworzoną dla wypożyczalni samochodów, która przechowuje: markę, model, pojemność silnika, moc silnika, rejestracja, kolor, rok produkcji, cenę za dzień wypożyczenia. O klientach: imię, nazwisko, numer PESEL, telefon, email. O pracownikach: imię, nazwisko, wynagrodzenie miesięczne, data zatrudnienia. Każdy pracownik ma przydzielony pojazd, którym się opiekuje, pilnując daty zwrotu. Baza powinna przechowywać aktualnie wypożyczone pojazdy i całą historię wypożyczeń. W momencie wypożyczenia znana jest data zwrotu. Baza powinna uwzględniać możliwość wypożyczenia wielu samochodów przez jednego klienta. Firma również może rezerwować wybrane pojazdy przez klientów. 

1.	Modele – spis wszystkich modeli posiadanych przez wypożyczalnię.
Atrybuty: ID_modelu, marka, model, pojemność silnika, moc_silnika, opiekun (relacja do pracownika)

2.	Egzemplarze – spis wszystkich aut.
Atrybuty: Rejestracja, kolor, ID_modelu, rok_produkcji, cena, przebieg

3. Klienci – informacje o klientach banku.
Atrybuty: imię, nazwisko, numer_PESEL, telefon, email

4. Pracownicy – informacje o pracownikach.
Atrybuty: ID_pracownika, imię, nazwisko, wynagrodzenie_bazowe, data_zatrudnienia

5. Wypożyczone (auta) – stan magazynu.
Atrybuty: ID_wypożyczenia, data wypożyczenia, ID_klienta, data zwrotu

6. Rezerwacje – Przyszłościowe zamówienia.
Atrybuty: ID_rezerwacji, ID_klienta, Data_rozpoczęcia, Data_zakończenia
![image](https://github.com/user-attachments/assets/077b50e0-6b52-44a8-8a92-bdda170805a1)

