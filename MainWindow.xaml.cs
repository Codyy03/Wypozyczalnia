using GUI;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace GUI
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {

        public static int salary;
        bool isEditing;
        DatabaseManager databaseManager = new DatabaseManager();
        public MainWindow(string title)
        {
            InitializeComponent();
            this.Title = title;
            databaseManager.SetDataGrid(modelTableView);

            ShowRightTable(true);

            if(title=="Klienci")
                userHistory.Visibility = Visibility.Visible;


            if (title == "Egzemplarze")
                carsRenevue.Visibility = Visibility.Visible;
        }

        void ShowRightTable(bool changeWidth)
        {
            switch (this.Title)
            {
                case "Modele": databaseManager.ShowTable("SELECT * FROM wyswietlanie.modeleall()", changeWidth); break;
                case "Klienci": databaseManager.ShowTable("SELECT * FROM wyswietlanie.klienciall()", changeWidth); break;
                case "Pracownicy": databaseManager.ShowTable("SELECT * FROM wyswietlanie.pracownicyall()", changeWidth); break;
                case "Egzemplarze": databaseManager.ShowTable("SELECT * FROM wyswietlanie.egzemplarzeall()", changeWidth); showDiagram.Visibility = Visibility.Visible; break;
                case "Wypozyczone": databaseManager.ShowTable("SELECT * FROM wyswietlanie.wypozyczoneall()", changeWidth); break;
                case "Rezerwacje": databaseManager.ShowTable("SELECT * FROM wyswietlanie.rezerwacjeall()", changeWidth); break;
            }
        }
        private bool isMessageBoxShown = false;

        private void modelTableView_CellEditEnding(object sender, DataGridCellEditEndingEventArgs e)
        {
            if (isEditing)
                return;

            if (!isMessageBoxShown)
            {
                isMessageBoxShown = true;

                var dataRowView = e.Row.Item as DataRowView;
                if (dataRowView != null)
                {

                    MessageBoxResult result = MessageBox.Show($"Czy na pewno chcesz zmodyfikować rekord ", "Potwierdź modyfikację", MessageBoxButton.YesNo, MessageBoxImage.Warning);

                    if (result == MessageBoxResult.Yes)
                    {
                        modelTableView.CommitEdit(DataGridEditingUnit.Row, true);
                        switch (this.Title)
                        {
                            case "Modele": databaseManager.UpdateModele(dataRowView); break;
                            case "Klienci": databaseManager.UpdateKlienci(dataRowView); break;
                            case "Pracownicy": databaseManager.UpdatePracownicy(dataRowView);  break;
                            case "Egzemplarze": databaseManager.UpdateEgzemplarze(dataRowView); break;
                            case "Wypozyczone": databaseManager.UpdateWypozyczone(dataRowView); break;
                            case "Rezerwacje": databaseManager.UpdateRezerwacje(dataRowView); break;
                        }

                    }
                    else
                    {
                        modelTableView.CancelEdit(DataGridEditingUnit.Row);
                        modelTableView.Items.Refresh(); // Odświeżenie widoku po anulowaniu edycji
                    }
                }

                    
                isMessageBoxShown = false;
            }
        }

        private void ReturnToSelectTableButton_Click(object sender, RoutedEventArgs e)
        {
            SelectTableWindows selectTableWindows = new SelectTableWindows();

            selectTableWindows.Show();
            this.Close();
        }

        private void addNewRecordButton_Click(object sender, RoutedEventArgs e)
        {
            isEditing = true;
            DataTable dataTable = ((DataView)modelTableView.ItemsSource).ToTable();
            DataRow newRow = dataTable.NewRow();
            dataTable.Rows.Add(newRow);
            modelTableView.ItemsSource = dataTable.DefaultView;
          
            
            databaseManager.AddDeleteButtons();

            if (Title == "Klienci" || Title == "Egzemplarze")
                modelTableView.Columns[0].IsReadOnly = false;
            if(Title == "Pracownicy")
            {
                databaseManager.AddEmployeeSalaryColumn(true);
                modelTableView.Columns[5].IsReadOnly = true;
            }

            saveNewRecordButton.Visibility = Visibility.Visible;
            addNewRecordButton.Visibility = Visibility.Hidden;
            deleteNewRecordButton.Visibility = Visibility.Visible;
            notification.Visibility = Visibility.Visible;
            notification.Text = "Jesteś w trybie dodawania. Zmodyfikowane rekordy nie zostaną zapisane!";
            scroll.ScrollToEnd();
        }
        DataRow row;
        private void saveNewRecordButton_Click(object sender, RoutedEventArgs e)
        {
            DataTable dataTable = ((DataView)modelTableView.ItemsSource).ToTable();
            int size = dataTable.Rows.Count;
            row = dataTable.Rows[size - 1];

            if (!RecordCanBeAdd(row))
                return;

            switch (this.Title)
            {
                case "Modele": databaseManager.AddModel(row); break;
                case "Klienci": databaseManager.AddKlienta(row); break;
                case "Pracownicy": databaseManager.AddPracownika(row); break;
                case "Egzemplarze": databaseManager.AddEgzemplarz(row); break;
                case "Wypozyczone": databaseManager.AddWypozyczone(row); break;
                case "Rezerwacje": databaseManager.AddRezerwacje(row); break;
            }



            isEditing = false;

            ShowRightTable(false);
            saveNewRecordButton.Visibility = Visibility.Hidden;
            addNewRecordButton.Visibility = Visibility.Visible;
            deleteNewRecordButton.Visibility = Visibility.Hidden;
            notification.Visibility = Visibility.Hidden;

        }

        private void deleteNewRecordButton_Click(object sender, RoutedEventArgs e)
        {
            isEditing = false;
            ShowRightTable(false);
            saveNewRecordButton.Visibility = Visibility.Hidden;
            addNewRecordButton.Visibility = Visibility.Visible;
            deleteNewRecordButton.Visibility = Visibility.Hidden;
            notification.Visibility = Visibility.Hidden;
        }

        private bool RecordCanBeAdd(DataRow dataRow)
        {
            int startingIndex = 0;
            int endIndex = 0;
            DataTable dataTable = dataRow.Table;

            if (dataTable.Columns[0].DataType == typeof(int))
            {
               startingIndex = 1;
               endIndex = dataRow.ItemArray.Length;
            }

            if(Title=="Pracownicy")
                endIndex = dataRow.ItemArray.Length-1;

            for (int i=startingIndex; i< endIndex; i++)
            {
                if (dataRow[i] == DBNull.Value)
                {
                    

                    notification.Text = "Wszystkie wymagane pola nie zostały wypełnione";
                    notification.Visibility = Visibility.Visible;
                    return false;
                }
            }

            return true;

        }

        private void modelTableView_BeginningEdit(object sender, DataGridBeginningEditEventArgs e)
        {
            // zapisuje wartość pensji przed zmianą 
            if (Title != "Pracownicy")
                return;

            if (isEditing)
                return;

            var dataRowView = e.Row.Item as DataRowView;
            salary = Convert.ToInt32(dataRowView["wynagrodzenie_bazowe"]);
            
            

        }

        private void showDiagram_Click(object sender, RoutedEventArgs e)
        {
            Diagram diagram = new(this.Title);

            diagram.ShowCarsDiagram();
            diagram.Show();

            this.Close();
        }

        private void showUserHistory_Click(object sender, RoutedEventArgs e)
        {
            if (!databaseManager.CustomerLoginExist(peselInput.Text) || string.IsNullOrEmpty(peselInput.Text))
                return;

            DataAnalysis dataAnalysis = new("Historia wypożyczeń", "SELECT * FROM historia_uzytkownika(@pesel)",Convert.ToInt64(peselInput.Text),Title);

            dataAnalysis.Show();
            this.Close();
        }

        
        private void peselInput_PreviewKeyDown(object sender, KeyEventArgs e)
        {
            // Pozwala na używanie klawiszy Backspace i Delete
            if (e.Key == Key.Back || e.Key == Key.Delete || e.Key == Key.Left || e.Key == Key.Right || e.Key == Key.Tab)
            {
                e.Handled = false;

            }
        }

        private static bool IsTextAllowed(string text)
        {
            // Sprawdza, czy tekst zawiera tylko cyfry
            return text.All(char.IsDigit);
        }


        private void peselInput_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            // Sprawdza, czy wprowadzony tekst to cyfra
            e.Handled = !IsTextAllowed(e.Text);
        }

        private void showRevenueDiagram_Click(object sender, RoutedEventArgs e)
        {
            Diagram diagram = new(this.Title);
            diagram.ShowCustomersDiagram();
            diagram.Show();
            this.Close();
        }

        private void clientRevenue_Click(object sender, RoutedEventArgs e)
        {
            if (!databaseManager.CustomerLoginExist(peselInput.Text) || string.IsNullOrEmpty(peselInput.Text))
                return;

            DataAnalysis dataAnalysis = new("Dochód z klienta", "SELECT * FROM przychody_z_klienta(@pesel)", Convert.ToInt64(peselInput.Text), Title);

            dataAnalysis.Show();
            this.Close();
        }

        private void showCarsRenevueData_Click(object sender, RoutedEventArgs e)
        {
            if (!databaseManager.RegistractionExist(registractionInput.Text) || string.IsNullOrEmpty(registractionInput.Text))
                return;

            DataAnalysis dataAnalysis = new("Dochód z pojazdu", "SELECT * FROM przychody_z_egzemplarza(@registracion)", registractionInput.Text, Title);

            dataAnalysis.Show();
            this.Close();
        }

        private void allClientsRevenue_Click(object sender, RoutedEventArgs e)
        {
            DataAnalysis dataAnalysis = new("Przychód ze wszystkich klientów", "SELECT * FROM przychody_z_klientow()",null, Title);

            dataAnalysis.Show();
            this.Close();
        }

        private void showCAllarsRenevueData_Click(object sender, RoutedEventArgs e)
        {
            DataAnalysis dataAnalysis = new("Dochód z pojazdów", "SELECT * FROM przychody_z_egzemplarzy()", registractionInput.Text, Title);

            dataAnalysis.Show();
            this.Close();
        }
    }


}




