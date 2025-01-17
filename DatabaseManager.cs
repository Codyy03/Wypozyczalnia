using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Threading;
using System.Xml.Linq;
using Npgsql;
using OxyPlot.Series;
using OxyPlot;
using static Npgsql.Replication.PgOutput.Messages.RelationMessage;
using OxyPlot.Wpf;
using System.Globalization;

namespace GUI
{
    public class DatabaseManager
    {
        private DataGrid dataGrid;
        private string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        private DispatcherTimer timer;

        public void SetDataGrid(DataGrid dataGrid)
        {
            this.dataGrid = dataGrid;

        }
        public void ShowTable(string query, bool changeWidth)
        {
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    using (NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(query, connection))
                    {
                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable);

                        // Dodaj kolumnę 'Końcowa pensja' do istniejącej tabeli
                        if (query.Contains("pracownicy"))
                        {
                            LoadEmployeeSalaryData(dataTable);
                        }
                        dataGrid.Columns.Clear();

                        // Wyłącz możliwość dodawania nowych wierszy przez użytkowników
                        dataGrid.CanUserAddRows = false;

                        // Ustawienie nowego źródła danych
                        dataGrid.ItemsSource = dataTable.DefaultView;
                        dataGrid.ColumnWidth = new DataGridLength(1, DataGridLengthUnitType.Star);

                        // Dodanie kolumn na podstawie danych
                        foreach (DataColumn column in dataTable.Columns)
                        {
                            if (column.ColumnName == dataTable.Columns[0].ColumnName)
                                break;


                            dataGrid.Columns.Add(new DataGridTextColumn
                            {
                                // Użyj dokładnej nazwy kolumny z bazy danych
                                Header = column.ColumnName,

                                Binding = new Binding($"[{column.ColumnName}]")
                            });
                        }


                        timer = new DispatcherTimer();
                        timer.Interval = TimeSpan.FromSeconds(0.1f);

                        timer.Tick += (s, e) =>
                        {
                            timer.Stop();

                            if (dataGrid.Columns[0].Header.ToString() == "ID_pracownika")
                            {
                                AddEmployeeSalaryColumn(false);
                            }

                            AddDeleteButtons();
                        };

                        timer.Start();
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Wystąpił błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        public void AddDeleteButtons()
        {
            // Usuwa istniejącą kolumnę "Actions", jeśli istnieje
            var existingColumn = dataGrid.Columns.FirstOrDefault(c => c.Header.ToString() == "Usuń rekord");
            if (existingColumn != null)
            {
                dataGrid.Columns.Remove(existingColumn);

            }

            DataGridTemplateColumn actionsColumn = new DataGridTemplateColumn
            {
                Header = "Usuń rekord", // Ustawia nagłówek kolumny
                CellTemplate = CreateButtonTemplate() // Ustawia szablon komórki z przyciskiem
            };
            // Dodaje kolumnę z przyciskami do DataGrid
            dataGrid.Columns.Add(actionsColumn);
            dataGrid.Columns[0].IsReadOnly = true;

         
        }
        public void AddEmployeeSalaryColumn(bool delete)
        {
            // Usuwa istniejącą kolumnę "Końcowa pensja", jeśli istnieje
            var existingColumn = dataGrid.Columns.FirstOrDefault(c => c.Header.ToString() == "Końcowa pensja");
            if (existingColumn != null)
            {
                dataGrid.Columns.Remove(existingColumn);
                if (delete)
                    return;
            }

            // Tworzenie nowej kolumny "Końcowa pensja"
            DataGridTemplateColumn salaryColumn = new DataGridTemplateColumn
            {
                Header = "Końcowa pensja",
                CellTemplate = CreateSalaryTemplate()
            };

            salaryColumn.IsReadOnly = true;
            // Dodanie kolumny do DataGrid
            dataGrid.Columns.Add(salaryColumn);
            // SetDataGridWidth();
        }


        public void LoadEmployeeSalaryData(DataTable existingTable)
        {
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();
                string query = "SELECT pensja FROM liczenie_pensji()";

                using (NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(query, connection))
                {
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);

                    // Dodaj kolumnę 'Końcowa pensja' do istniejącej tabeli, jeśli nie istnieje
                    if (!existingTable.Columns.Contains("Końcowa pensja"))
                    {
                        existingTable.Columns.Add("Końcowa pensja", typeof(long));
                    }

                    // Upewnij się, że istniejąca tabela ma wystarczającą liczbę wierszy
                    int rowsToAdd = dataTable.Rows.Count - existingTable.Rows.Count;
                    for (int i = 0; i < rowsToAdd; i++)
                    {
                        existingTable.Rows.Add(existingTable.NewRow());
                    }

                    // Przypisanie wartości 'pensja' do odpowiednich wierszy istniejącej tabeli
                    for (int i = 0; i < existingTable.Rows.Count && i < dataTable.Rows.Count; i++)
                    {
                        existingTable.Rows[i]["Końcowa pensja"] = dataTable.Rows[i]["pensja"];
                    }
                }
            }
        }





        private DataTemplate CreateSalaryTemplate()
        {
            DataTemplate template = new DataTemplate();

            FrameworkElementFactory textBlockFactory = new FrameworkElementFactory(typeof(TextBlock));

            // Ustawia Binding dla TextBlock, aby wyświetlał wartość pensji
            textBlockFactory.SetBinding(TextBlock.TextProperty, new Binding("Końcowa pensja"));

            template.VisualTree = textBlockFactory;
            return template;
        }



        // Metoda tworząca szablon komórki z przyciskiem "Usuń"
        private DataTemplate CreateButtonTemplate()
        {

            DataTemplate template = new DataTemplate();

            FrameworkElementFactory buttonFactory = new FrameworkElementFactory(typeof(Button));

            // Ustawia zawartość przycisku
            buttonFactory.SetValue(Button.ContentProperty, "Usuń");

            // Dodaje obsługę zdarzenia kliknięcia
            buttonFactory.AddHandler(Button.ClickEvent, new RoutedEventHandler(DeleteButton_Click));

            template.VisualTree = buttonFactory;
            return template;
        }

        // Metoda obsługująca zdarzenie kliknięcia przycisku "Delete"
        private void DeleteButton_Click(object sender, RoutedEventArgs e)
        {
            // Sprawdzanie, czy zdarzenie jest wywołane przez przycisk i czy jego DataContext to DataRowView
            if (sender is Button button && button.DataContext is DataRowView rowView)
            {
                // Pobiera ID rekordu z pierwszej kolumny DataGrid (zakładamy, że jest to klucz główny)
                var id = rowView.Row.ItemArray[0];

                // Wyświetla okno dialogowe z potwierdzeniem usunięcia
                MessageBoxResult result = MessageBox.Show($"Czy na pewno chcesz usunąć rekord o kluczu głównym: {id}", "Potwierdź usunięcie", MessageBoxButton.YesNo, MessageBoxImage.Warning);

                if (result == MessageBoxResult.Yes)
                {
                    // Słownik mapujący nagłówki kolumn na zapytania SQL, nazwy tabel i zapytania odświeżające
                var tableMappings = new Dictionary<string, (string query, string tableName, string refreshQuery)>
                {
                { "ID_modelu", ("CALL usuwanie.UsunModel(@IDmodelu)", "Modele", "SELECT * FROM wyswietlanie.modeleall()") },
                { "pesel", ("CALL usuwanie.UsunKlienta(@pesel)", "Klienci", "SELECT * FROM wyswietlanie.klienciall()") },
                { "ID_pracownika", ("CALL usuwanie.UsunPracownika(@IDpracownika)", "Pracownicy", "SELECT * FROM wyswietlanie.pracownicyall()") },
                { "Rejestracja", ("CALL usuwanie.UsunEgzemplarz(@Rejestracja)", "Egzemplarze", "SELECT * FROM wyswietlanie.egzemplarzeall()") },
                { "ID_wypozyczenia", ("CALL usuwanie.UsunWypozyczone(@IDwypozyczenia)", "Wypozyczone", "SELECT * FROM wyswietlanie.wypozyczoneall()") },
                { "ID_rezerwacji", ("CALL usuwanie.UsunRezerwacje(@IDrezerwacji)", "Rezerwacje", "SELECT * FROM wyswietlanie.rezerwacjeall()") }
                };

                    // Pobranie nagłówka pierwszej kolumny (zakładamy, że jest to identyfikator tabeli)
                    var header = dataGrid.Columns[0].Header.ToString();
                    if (tableMappings.ContainsKey(header))
                    {
                        // Pobranie wartości z słownika na podstawie nagłówka kolumny
                        var mapping = tableMappings[header];

                        // Usuwa rekord z bazy danych, przekazując ID, zapytanie SQL i nazwę tabeli
                        DeleteRecordFromDatabase(id, mapping.query, mapping.tableName);

                        // Odświeża DataGrid, wykonując zapytanie odświeżające
                        ShowTable(mapping.refreshQuery, true);
                    }
                    else
                    {
                        // Wyświetla komunikat, jeśli tabela nie została zmapowana
                        MessageBox.Show("Nieznana tabela.");
                    }
                }
            }
        }


        // Metoda usuwająca rekord z bazy danych
        private void DeleteRecordFromDatabase(object id, string query, string tableName)
        {
        var parameterMappings = new Dictionary<string, string>
        {
        { "Modele", "@IDmodelu" },
        { "Klienci", "@pesel" },
        { "Pracownicy", "@IDpracownika" },
        { "Egzemplarze", "@Rejestracja" },
        { "Wypozyczone", "@IDwypozyczenia" },
        { "Rezerwacje", "@IDrezerwacji" }
        };

            if (!parameterMappings.ContainsKey(tableName))
            {
                throw new ArgumentException("Nieprawidłowa nazwa tabeli");
            }

            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        string parameterName = parameterMappings[tableName];

                        // Dodawanie parametru na podstawie nazwy tabeli
                        switch (tableName)
                        {
                            case "Modele":
                            case "Pracownicy":
                            case "Wypozyczone":
                            case "Rezerwacje":
                                command.Parameters.AddWithValue(parameterName, Convert.ToInt32(id));
                                break;
                            case "Klienci":
                                command.Parameters.AddWithValue(parameterName, Convert.ToInt64(id));
                                break;
                            case "Egzemplarze":
                                command.Parameters.AddWithValue(parameterName, Convert.ToString(id));
                                break;
                        }

                        // Wykonaj polecenie wywołania procedury
                        command.ExecuteNonQuery();
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Błąd połączenia: " + ex.Message);
                }
            }
        }


        public void UpdateModele(DataRowView dataRowView)
        {
            try
            {
                // Przygotuj zmienne do przechowywania zaktualizowanych wartości
                int idModelu = Convert.ToInt32(dataRowView["ID_modelu"]);
                string marka = dataRowView["marka"]?.ToString();
                string model = dataRowView["model"]?.ToString();
                int? pojemnoscSilnika = dataRowView["pojemnosc_silnika"] != DBNull.Value ? (int?)Convert.ToInt32(dataRowView["pojemnosc_silnika"]) : null;
                int? mocSilnika = dataRowView["moc_silnika"] != DBNull.Value ? (int?)Convert.ToInt32(dataRowView["moc_silnika"]) : null;
                int? opiekun = dataRowView["opiekun"] != DBNull.Value ? (int?)Convert.ToInt32(dataRowView["opiekun"]) : null;

                string query = "CALL modyfikowanie.modyfikujmodel(@idModelu, @marka, @model, @pojemnoscSilnika, @mocSilnika, @opiekun)";

                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@idModelu", idModelu);
                        command.Parameters.AddWithValue("@marka", marka ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@model", model ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@pojemnoscSilnika", pojemnoscSilnika ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@mocSilnika", mocSilnika ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@opiekun", opiekun ?? (object)DBNull.Value);

                        command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Wystąpił błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        public void UpdateKlienci(DataRowView dataRowView)
        {
            try
            {
                // Przygotuj zmienne do przechowywania zaktualizowanych wartości
                Int64 pesel = Convert.ToInt64(dataRowView["pesel"]);
                string imie = dataRowView["imie"]?.ToString();
                string nazwisko = dataRowView["nazwisko"]?.ToString();
                string email = dataRowView["email"]?.ToString();
                Int64? telefon = dataRowView["telefon"] != DBNull.Value ? Convert.ToInt64(dataRowView["telefon"]) : null;

                string query = "CALL modyfikowanie.modyfikujklienta(@pesel, @imie, @nazwisko, @email, @telefon)";


                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@pesel", pesel);
                        command.Parameters.AddWithValue("@imie", imie ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@nazwisko", nazwisko ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@email", email ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@telefon", telefon ?? (object)DBNull.Value);

                        command.ExecuteNonQuery();
                    }
                }


            }
            catch (Exception ex)
            {
                MessageBox.Show($"Wystąpił błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        public void UpdatePracownicy(DataRowView dataRowView)
        {
            int? wynagrodzenieBazowe = 0;
            try
            {
                //  zmienne do przechowywania zaktualizowanych wartości
                int idPracownika = Convert.ToInt32(dataRowView["ID_pracownika"]);
                string imie = dataRowView["imie"]?.ToString();
                string nazwisko = dataRowView["nazwisko"]?.ToString();
                wynagrodzenieBazowe = dataRowView["wynagrodzenie_bazowe"] != DBNull.Value ? (int?)Convert.ToInt32(dataRowView["wynagrodzenie_bazowe"]) : null;
                string dataZatrudnienia = Convert.ToDateTime(dataRowView["data_zatrudnienia"]).ToString("yyyy-MM-dd");


                string query = "CALL modyfikowanie.modyfikujpracownika(@idPracownika, @imie, @nazwisko, @wynagrodzenieBazowe, to_date(@dataZatrudnienia, 'YYYY-MM-DD'))";

                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@idPracownika", idPracownika);
                        command.Parameters.AddWithValue("@imie", imie ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@nazwisko", nazwisko ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@wynagrodzenieBazowe", wynagrodzenieBazowe ?? (object)DBNull.Value);

                        // Dodaj parametr jako ciąg tekstowy
                        command.Parameters.AddWithValue("@dataZatrudnienia", dataZatrudnienia);

                        command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Wystąpił błąd: {ex.Message}");
            }
            if (MainWindow.salary == wynagrodzenieBazowe)
                return;

            timer = new DispatcherTimer();
            timer.Interval = TimeSpan.FromSeconds(0.1f);

            timer.Tick += (s, e) =>
            {
                timer.Stop();


                ShowTable("SELECT * FROM wyswietlanie_tabel.pracownicyall()", false);
            };

            timer.Start();
        }
        public void UpdateEgzemplarze(DataRowView dataRowView)
        {
            try
            {
                // Przygotuj zmienne do przechowywania zaktualizowanych wartości
                string rejestracja = dataRowView["rejestracja"].ToString();
                string kolor = dataRowView["kolor"]?.ToString();
                int? idModelu = dataRowView["ID_modelu"] != DBNull.Value ? (int?)Convert.ToInt32(dataRowView["ID_modelu"]) : null;
                string rokProdukcji = Convert.ToDateTime(dataRowView["rok_produkcji"]).ToString("yyyy-MM-dd");
                int? cena = dataRowView["cena"] != DBNull.Value ? (int?)Convert.ToInt32(dataRowView["cena"]) : null;
                int? przebieg = dataRowView["przebieg"] != DBNull.Value ? (int?)Convert.ToInt32(dataRowView["przebieg"]) : null;

                string query = "CALL modyfikowanie.modyfikujegzemplarz(@rejestracja, @kolor, @idModelu, to_date(@rokProdukcji, 'YYYY-MM-DD'), @cena, @przebieg )";

                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@rejestracja", rejestracja);
                        command.Parameters.AddWithValue("@kolor", kolor ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@idModelu", idModelu ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@rokProdukcji", rokProdukcji);
                        command.Parameters.AddWithValue("@cena", cena ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@przebieg", przebieg ?? (object)DBNull.Value);
                        command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Wystąpił błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        public void UpdateWypozyczone(DataRowView dataRowView)
        {
            try
            {
                // Przygotuj zmienne do przechowywania zaktualizowanych wartości
                int idWypozyczenia = Convert.ToInt32(dataRowView["ID_wypozyczenia"]);
                string dataWypozyczenia = Convert.ToDateTime(dataRowView["data_wypozyczenia"]).ToString("yyyy-MM-dd");
                Int64? pesel = dataRowView["pesel"] != DBNull.Value ? Convert.ToInt64(dataRowView["pesel"]) : null;
                string dataZwrotu = Convert.ToDateTime(dataRowView["data_zwrotu"]).ToString("yyyy-MM-dd");

                string query = "CALL modyfikowanie.modyfikujwypozyczone(@idWypozyczenia,  to_date(@dataWypozyczenia, 'YYYY-MM-DD'), @pesel,  to_date(@dataZwrotu, 'YYYY-MM-DD'))";

                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@idWypozyczenia", idWypozyczenia);
                        command.Parameters.AddWithValue("@dataWypozyczenia", dataWypozyczenia ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@pesel", pesel ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@dataZwrotu", dataZwrotu ?? (object)DBNull.Value);


                        command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Wystąpił błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        public void UpdateRezerwacje(DataRowView dataRowView)
        {
            try
            {
                // Przygotuj zmienne do przechowywania zaktualizowanych wartości
                int idRezerwacji = Convert.ToInt32(dataRowView["ID_rezerwacji"]);
                Int64? pesel = dataRowView["pesel"] != DBNull.Value ? Convert.ToInt64(dataRowView["pesel"]) : null;
                string dataRozpoczecia = Convert.ToDateTime(dataRowView["data_rozpoczecia"]).ToString("yyyy-MM-dd");
                string dataZakonczenia = Convert.ToDateTime(dataRowView["data_zakonczenia"]).ToString("yyyy-MM-dd");


                string query = "CALL modyfikowanie.modyfikujrezerwacje(@idRezerwacji, @pesel, to_date(@dataRozpoczecia, 'YYYY-MM-DD'), to_date(@dataZakonczenia, 'YYYY-MM-DD'))";

                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@idRezerwacji", idRezerwacji);
                        command.Parameters.AddWithValue("@pesel", pesel ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@dataRozpoczecia", dataRozpoczecia);
                        command.Parameters.AddWithValue("@dataZakonczenia", dataZakonczenia);

                        command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Wystąpił błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        public void AddModel(DataRow row)
        {
            try
            {
                string query = "CALL dodawanie.dodajmodel(@marka, @model, @pojemnoscSilnika, @mocSilnika, @opiekun)";

                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@marka", row["marka"]);
                        command.Parameters.AddWithValue("@model", row["model"]);
                        command.Parameters.AddWithValue("@pojemnoscSilnika", row["pojemnosc_silnika"]);
                        command.Parameters.AddWithValue("@mocSilnika", row["moc_silnika"]);
                        command.Parameters.AddWithValue("@opiekun", row["opiekun"]);
                        command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Wystąpił błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
            }

        }
        public void AddKlienta(DataRow row)
        {
            try
            {

                string query = "CALL dodawanie.dodajklienta(@pesel, @imie, @nazwisko, @email, @telefon)";


                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@pesel", row["pesel"]);
                        command.Parameters.AddWithValue("@imie", row["imie"]);
                        command.Parameters.AddWithValue("@nazwisko", row["nazwisko"]);
                        command.Parameters.AddWithValue("@email", row["email"]);
                        command.Parameters.AddWithValue("@telefon", row["telefon"]);


                        command.ExecuteNonQuery();
                    }
                }

                dataGrid.Columns[0].IsReadOnly = true;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Wystąpił błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        public void AddKlienta(string pesel, string imie, string nazwisko, string email, string telefon)
        {
            var userNull = email;

            try
            {

                string query = "CALL dodawanie.dodajklienta(@pesel, @imie, @nazwisko, @email, @telefon)";


                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@pesel", Convert.ToInt64(pesel));
                        command.Parameters.AddWithValue("@imie", imie);
                        command.Parameters.AddWithValue("@nazwisko", nazwisko);
                        if (string.IsNullOrEmpty(email))
                            command.Parameters.AddWithValue("@email", DBNull.Value);
                        else
                            command.Parameters.AddWithValue("@email", email);

                        command.Parameters.AddWithValue("@telefon", Convert.ToInt64(telefon));


                        command.ExecuteNonQuery();
                       
                    }
                }


            }
            catch (Exception ex)
            {
                MessageBox.Show($"Wystąpił błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }


        public void AddPracownika(DataRow row)
        {
            try
            {

                string query = "CALL dodawanie.dodajpracownika(@imie, @nazwisko,@wynagrodzenieBazowe ,to_date(@dataZatrudniena, 'YYYY-MM-DD'))";


                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {

                        command.Parameters.AddWithValue("@imie", row["imie"]);
                        command.Parameters.AddWithValue("@nazwisko", row["nazwisko"]);
                        command.Parameters.AddWithValue("@wynagrodzenieBazowe", row["wynagrodzenie_bazowe"]);
                        string dataZatrudniena = Convert.ToDateTime(row["data_zatrudnienia"]).ToString("yyyy-MM-dd");
                        command.Parameters.AddWithValue("@dataZatrudniena", dataZatrudniena);


                        command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Wystąpił błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }


        public void AddEgzemplarz(DataRow row)
        {
            try
            {

                string query = "CALL dodawanie.dodajegzemplarz(@rejestracja, @kolor, @idModelu,  to_date(@rokProdukcji, 'YYYY-MM-DD'), @cena, @przebieg)";


                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@rejestracja", row["Rejestracja"]);
                        command.Parameters.AddWithValue("@kolor", row["kolor"]);
                        command.Parameters.AddWithValue("@idModelu", row["ID_modelu"]);
                        string rokProdukcji = Convert.ToDateTime(row["rok_produkcji"]).ToString("yyyy-MM-dd");
                        command.Parameters.AddWithValue("@rokProdukcji", rokProdukcji);
                        command.Parameters.AddWithValue("@cena", row["cena"]);
                        command.Parameters.AddWithValue("@przebieg", row["przebieg"]);


                        command.ExecuteNonQuery();
                    }
                }

                dataGrid.Columns[0].IsReadOnly = true;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Wystąpił błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        public void AddWypozyczone(DataRow row)
        {
            try
            {

                string query = "CALL dodawanie.dodajwypozyczone(to_date(@dataWypozyczenia, 'YYYY-MM-DD'), @pesel, to_date(@dataZwrotu, 'YYYY-MM-DD'))";


                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {

                        string dataWypozyczenia = Convert.ToDateTime(row["data_wypozyczenia"]).ToString("yyyy-MM-dd");
                        command.Parameters.AddWithValue("@dataWypozyczenia", dataWypozyczenia);

                        Int64 pesel = Convert.ToInt64(row["pesel"]);
                        command.Parameters.AddWithValue("@pesel", pesel);

                        string dataZwrotu = Convert.ToDateTime(row["data_zwrotu"]).ToString("yyyy-MM-dd");
                        command.Parameters.AddWithValue("@dataZwrotu", dataZwrotu);


                        command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Wystąpił błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        public void AddRezerwacje(DataRow row)
        {
            try
            {

                string query = "CALL dodawanie.dodajrezerwacje(@pesel, to_date(@dataRozpoczecia, 'YYYY-MM-DD'),  to_date(@dataZakonczenia, 'YYYY-MM-DD'))";


                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {

                        Int64 pesel = Convert.ToInt64(row["pesel"]);
                        command.Parameters.AddWithValue("@pesel", pesel);

                        string dataRozpoczecia = Convert.ToDateTime(row["data_rozpoczecia"]).ToString("yyyy-MM-dd");
                        command.Parameters.AddWithValue("@dataRozpoczecia", dataRozpoczecia);

                        string dataZakonczenia = Convert.ToDateTime(row["data_zakonczenia"]).ToString("yyyy-MM-dd");
                        command.Parameters.AddWithValue("@dataZakonczenia", dataZakonczenia);


                        command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {

                MessageBox.Show($"Wystąpił błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }



        public bool CustomerLoginExist(string pesel)
        {
            if (string.IsNullOrEmpty(pesel))
                return false;

            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();

                // Tworzymy komendę SQL, która wywołuje funkcję PL/pgSQL
                string sql = "SELECT czy_klient_istnieje(@pesel)";

                using (NpgsqlCommand command = new NpgsqlCommand(sql, connection))
                {
                    command.Parameters.AddWithValue("@pesel", Convert.ToInt64(pesel));

                    // Wykonujemy komendę i pobieramy wynik
                    bool result = (bool)command.ExecuteScalar();
                    return result;
                }
            }
        }
        public bool CustomerPhonNumberExist(string phonNumber)
        {
            if (string.IsNullOrEmpty(phonNumber))
                return false;

            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();

                // Tworzymy komendę SQL, która wywołuje funkcję PL/pgSQL
                string sql = "SELECT sprawdz_telefon(@pesel)";

                using (NpgsqlCommand command = new NpgsqlCommand(sql, connection))
                {
                    command.Parameters.AddWithValue("@pesel", Convert.ToInt64(phonNumber));

                    // Wykonujemy komendę i pobieramy wynik
                    bool result = (bool)command.ExecuteScalar();
                    return result;
                }
            }
        }
        public bool RegistractionExist(string registracion)
        {
            if (string.IsNullOrEmpty(registracion))
                return false;

            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();

                // Tworzymy komendę SQL, która wywołuje funkcję PL/pgSQL
                string sql = "SELECT sprawdz_rejestracje(@registracion)";

                using (NpgsqlCommand command = new NpgsqlCommand(sql, connection))
                {
                    command.Parameters.AddWithValue("@registracion",registracion);

                    // Wykonujemy komendę i pobieramy wynik
                    bool result = (bool)command.ExecuteScalar();
                    return result;
                }
            }
        }

        public List<Tuple<string, int>> AllRCarsRegistrations(bool getAll)
        {
            List<Tuple<string, int>> registrations= new();
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();
                DateTime tomorrow = DateTime.Today.AddDays(1);

                // Tworzymy komendę SQL, która wywołuje funkcję PL/pgSQL
                string sql = "SELECT \"Rejestracja\", \"ID_modelu\" FROM wyswietlanie.egzemplarzeall()";
                using (NpgsqlCommand command = new NpgsqlCommand(sql, connection))
                {
                    using (NpgsqlDataReader reader = command.ExecuteReader())
                    {

                        while (reader.Read())
                        {
                            if(getAll)
                                registrations.Add(new Tuple<string, int>(reader.GetString(0), reader.GetInt32(1)));
                            else
                            {
                                if (CheckIfCarIsFree(reader.GetString(0), DateTime.Today, DateTime.Today) && CheckIfCarIsFree(reader.GetString(0), tomorrow, tomorrow))
                                    registrations.Add(new Tuple<string, int>(reader.GetString(0), reader.GetInt32(1)));
                            }
                           

                        }
                    }

                }

            }
            return registrations;
        }
       

        public string[] BrandModel(string registration)
        {
            string[] modelsData = new string[7];

            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();

                // Poprawione zapytanie SQL bez cudzysłowów wokół @registration
                string sql2 = "SELECT pojemnosc_silnika, moc_silnika, kolor, rok_produkcji, przebieg, cena, imie || ' ' || nazwisko AS employee FROM info_auto(@registration)";

                using (NpgsqlCommand command2 = new NpgsqlCommand(sql2, connection))
                {
                    command2.Parameters.AddWithValue("@registration", registration);
                    using (NpgsqlDataReader reader2 = command2.ExecuteReader())
                    {
                        int i = 0;
                        while (reader2.Read())
                        {
                            for (int j = 0; j < reader2.FieldCount; j++)
                            {
                                if (!reader2.IsDBNull(j))
                                {
                                    if (reader2.GetFieldType(j) == typeof(int))
                                    {
                                        modelsData[i] = reader2.GetInt32(j).ToString();
                                    }
                                    else if (reader2.GetFieldType(j) == typeof(string))
                                    {
                                        modelsData[i] = reader2.GetString(j);
                                    }
                                    else if (reader2.GetFieldType(j) == typeof(DateTime))
                                    {
                                        modelsData[i] = reader2.GetDateTime(j).ToString("yyyy-MM-dd");
                                    }
                                    i++;
                                }
                            }
                        }
                    }
                }
            }

            return modelsData;
        }


        public string ReturnTwoRedcordsAsOneString(int id, string sql,Int64 pesel)
        {
            string name = "";
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();

                using (NpgsqlCommand command = new NpgsqlCommand(sql, connection))
                {
                    if(id!=0)
                        command.Parameters.AddWithValue("@id", id);

                    if (pesel != 0)
                        command.Parameters.AddWithValue("@pesel", pesel);

                    using (NpgsqlDataReader reader = command.ExecuteReader())
                    {

                        if (reader.Read())
                        {
                            name = $"{reader.GetString(0)} {reader.GetString(1)}";

                        }
                    }
                }
            }
            return name;
        }

        public int PriceForCarRent(string registration, DateTime start, DateTime end)
        {
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();

                // Tworzymy komendę SQL, która wywołuje funkcję PL/pgSQL
                string sql = "SELECT * FROM koszt(to_date(@startdate, 'YYYY-MM-DD'), to_date(@enddate, 'YYYY-MM-DD'), @registration)";

                using (NpgsqlCommand command = new NpgsqlCommand(sql, connection))
                {
                    string startdate = start.ToString("yyyy-MM-dd");
                    command.Parameters.AddWithValue("@startdate", startdate);
                    string enddate = end.ToString("yyyy-MM-dd");
                    command.Parameters.AddWithValue("@enddate", enddate);

                    command.Parameters.AddWithValue("@registration", registration);

                    // Wykonujemy komendę i pobieramy wynik
                    int price = (int)command.ExecuteScalar();

                    return price;
                }
            }
        }
        public void RentCars(Int64 pesel, DateTime dataZwrotu, string[] rejestracje)
        {
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();

                // Tworzymy komendę SQL do wywołania procedury
                string sql = "CALL wypozycz(@pesel,to_date(@date,'YYYY-MM-DD'), @rejestracje)";

                using (NpgsqlCommand command = new NpgsqlCommand(sql, connection))
                {
                    // Dodanie parametrów
                    command.Parameters.AddWithValue("@pesel", pesel);
                    string date = dataZwrotu.ToString("yyyy-MM-dd");
                    command.Parameters.AddWithValue("@date", date);
                    command.Parameters.Add(new NpgsqlParameter("@rejestracje", NpgsqlTypes.NpgsqlDbType.Array | NpgsqlTypes.NpgsqlDbType.Text)
                    {
                        Value = rejestracje
                    });

                    // Wykonanie komendy
                    command.ExecuteNonQuery();
                }
            }
        }

        public void BookCar(Int64 pesel, DateTime datarozpoczecia, DateTime dataZakonczenia, string[] rejestracje)
        {
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();

                    // Tworzymy komendę SQL do wywołania procedury
                    string sql = "CALL zarezerwuj(@pesel, to_date(@startDate,'YYYY-MM-DD'), to_date(@endDate,'YYYY-MM-DD'), @rejestracje)";

                    using (NpgsqlCommand command = new NpgsqlCommand(sql, connection))
                    {
                        // Dodanie parametrów
                        command.Parameters.AddWithValue("@pesel", pesel);
                        string startDate = datarozpoczecia.ToString("yyyy-MM-dd");
                        command.Parameters.AddWithValue("@startDate", startDate);
                        string endDate = dataZakonczenia.ToString("yyyy-MM-dd");
                        command.Parameters.AddWithValue("@endDate", endDate);
                        command.Parameters.Add(new NpgsqlParameter("@rejestracje", NpgsqlTypes.NpgsqlDbType.Array | NpgsqlTypes.NpgsqlDbType.Text)
                        {
                            Value = rejestracje
                        });

                        // Wykonanie komendy
                        command.ExecuteNonQuery();

                    }
                }
                MessageBox.Show("Pomyślnie zarezerwowano");
            }
            catch (Exception ex)
            {
                // Wyświetlenie błędu w MessageBox
                MessageBox.Show($"Wystąpił błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
            }

        }


        public int HowManyDaysCarCanBeRent(string[] rejestracje)
        {
            int date = 30;
           
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();

                // Tworzymy komendę SQL, która wywołuje funkcję PL/pgSQL
                string sql = "SELECT do_kiedy_wolne(@rejestracje)-CURRENT_DATE ";

                using (NpgsqlCommand command = new NpgsqlCommand(sql, connection))
                {

                    command.Parameters.Add(new NpgsqlParameter("@rejestracje", NpgsqlTypes.NpgsqlDbType.Array | NpgsqlTypes.NpgsqlDbType.Text)
                    {
                        Value = rejestracje
                    });

                    // Wykonujemy komendę i pobieramy wynik
                    if(command.ExecuteScalar()!=DBNull.Value)
                    date  = (int)command.ExecuteScalar();

                    return date;
                }
            }
        }
       

        public bool CheckIfCarIsFree(string registration, DateTime datarozpoczecia, DateTime dataZakonczenia)
        {
            bool isFree = false;
            int result = 0;
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();

                // Tworzymy komendę SQL, która wywołuje funkcję PL/pgSQL
                string sql = "SELECT czy_wolny(to_date(@startDate,'YYYY-MM-DD'),to_date(@endDate,'YYYY-MM-DD'),@registration)";

                using (NpgsqlCommand command = new NpgsqlCommand(sql, connection))
                {
                    string startDate = datarozpoczecia.ToString("yyyy-MM-dd");
                    command.Parameters.AddWithValue("@startDate", startDate);
                    string endDate = dataZakonczenia.ToString("yyyy-MM-dd");
                    command.Parameters.AddWithValue("@endDate", endDate);
                    command.Parameters.AddWithValue("@registration", registration);

                    // Wykonujemy komendę i pobieramy wynik
                    result = (int)command.ExecuteScalar();

                  
                    return (result == 0);

 
                }
            }
        }
        public void ShowUserHistoryTable(string query,DataGrid historyGrid,Int64 pesel,string registracion)
        {
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    
                    using (NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(query, connection))
                    
                        using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                        {
                        if(pesel!=0)
                        command.Parameters.AddWithValue("@pesel", pesel);

                        if(!string.IsNullOrEmpty(registracion))
                            command.Parameters.AddWithValue("@registracion", registracion);

                        adapter.SelectCommand = command;
                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable);

                        // Czyścimy istniejące kolumny w DataGrid
                        historyGrid.Columns.Clear();

                        // Wyłączamy możliwość dodawania nowych wierszy przez użytkowników
                        historyGrid.CanUserAddRows = false;

                        // Ustawiamy nowe źródło danych
                        historyGrid.ItemsSource = dataTable.DefaultView;
                        historyGrid.ColumnWidth = new DataGridLength(1, DataGridLengthUnitType.Star);

                        // Dodajemy kolumny na podstawie danych
                        foreach (DataColumn column in dataTable.Columns)
                        {
                            if (column.ColumnName == dataTable.Columns[0].ColumnName)
                                break;
                            historyGrid.Columns.Add(new DataGridTextColumn
                            {
                                // Używamy dokładnej nazwy kolumny z bazy danych
                                Header = column.ColumnName,
                                Binding = new Binding($"[{column.ColumnName}]")
                            });
                        }                 
                    }
                
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Błąd połączenia: " + ex.Message);
                }
            }
        }

        public string[] ClientInfo(Int64 pesel)
        {
            string[] info = new string[2];
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();
                string sql = "SELECT email, telefon FROM wyswietlanie.wyswietlklienci(@pesel)";
                using (NpgsqlCommand command = new NpgsqlCommand(sql, connection))
                {
                    
                    command.Parameters.AddWithValue("@pesel", pesel);

                    using (NpgsqlDataReader reader = command.ExecuteReader())
                    {

                        if (reader.Read())
                        {
                            if (!reader.IsDBNull(0))
                                info[0] = reader.GetString(0);
                            else info[0] = "";

                            info[1] = reader.GetInt64(1).ToString();

                        }
                    }
                }
            }
            return info;

        }

        public void ShowDiagramRevenues(PlotModel plotModel, PlotView plotView)
        {
            plotModel = new PlotModel { Title = "Przychody z egzemplarzy" };
            BarSeries barSeries = new BarSeries
            {
                Title = "Przychód",
                LabelPlacement = LabelPlacement.Inside,
                LabelFormatString = "{0}"
            };

            // Pobieranie danych z bazy danych
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();
                string query = "SELECT * FROM przychody_z_egzemplarzy()";
                using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                {
                    using (NpgsqlDataReader reader = command.ExecuteReader())
                    {
                        var categories = new List<string>();

                        while (reader.Read())
                        {
                            string marka = reader.GetString(1);
                            string model = reader.GetString(2);
                            Int64 przychod = reader.GetInt64(4);

                            // Tworzenie stringa zawierającego markę i model
                            string markaModel = $"{marka} {model}";

                            // Dodawanie danych do serii słupkowej
                            barSeries.Items.Add(new BarItem { Value = (double)przychod });
                            categories.Add(markaModel);
                        }

                        // Dodawanie osi kategorii (marka i model) na osi Y
                        plotModel.Axes.Add(new OxyPlot.Axes.CategoryAxis
                        {
                            Position = OxyPlot.Axes.AxisPosition.Left,
                            ItemsSource = categories,
                            Key = "CategoryAxis"
                        });

                        // Dodawanie osi wartości z tytułem "Przychód" na osi X
                        plotModel.Axes.Add(new OxyPlot.Axes.LinearAxis
                        {
                            Position = OxyPlot.Axes.AxisPosition.Bottom,
                            Title = "Przychód",
                            Key = "ValueAxis"
                        });
                    }
                }
            }

            plotModel.Series.Add(barSeries);

            plotView.Model = plotModel;
        }

        public void ShowDiagramCustomersRevenues(PlotModel plotModel, PlotView plotView)
        {
            plotModel = new PlotModel { Title = "Przychody z klientów" };
            BarSeries barSeries = new BarSeries
            {
                Title = "Przychód",
                LabelPlacement = LabelPlacement.Inside,
                LabelFormatString = "{0}"
            };

            // Pobieranie danych z bazy danych
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();
                string query = "SELECT * FROM przychody_z_klientow()";
                using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                {
                    using (NpgsqlDataReader reader = command.ExecuteReader())
                    {
                        var categories = new List<string>();

                        while (reader.Read())
                        {
                            string imie = reader.GetString(1);
                            string nazwisko = reader.GetString(2);
                            Int64 koszt = reader.GetInt64(3);

                            // Tworzenie stringa zawierającego imię i nazwisko
                            string imieNazwisko = $"{imie} {nazwisko}";

                            // Dodawanie danych do serii słupkowej
                            barSeries.Items.Add(new BarItem { Value = (double)koszt });
                            categories.Add(imieNazwisko);
                        }

                        // Dodawanie osi kategorii (imię i nazwisko) na osi Y
                        plotModel.Axes.Add(new OxyPlot.Axes.CategoryAxis
                        {
                            Position = OxyPlot.Axes.AxisPosition.Left,
                            ItemsSource = categories,
                            Key = "CategoryAxis"
                        });

                        // Dodawanie osi wartości z tytułem "Przychód" na osi X
                        plotModel.Axes.Add(new OxyPlot.Axes.LinearAxis
                        {
                            Position = OxyPlot.Axes.AxisPosition.Bottom,
                            Title = "Przychód",
                            Key = "ValueAxis"
                        });
                    }
                }
            }

            plotModel.Series.Add(barSeries);

            plotView.Model = plotModel;
        }



    }
}





  
      

       
          
