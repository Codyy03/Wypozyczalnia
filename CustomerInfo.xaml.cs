using System;
using System.Collections.Generic;
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
using System.Windows.Shapes;

namespace GUI
{
    /// <summary>
    /// Logika interakcji dla klasy CustomerInfo.xaml
    /// </summary>
    public partial class CustomerInfo : Window
    {
        DatabaseManager databaseManager = new DatabaseManager();
        Int64 pesel;
        public CustomerInfo(Int64 pesel)
        {
            
            this.pesel = pesel;
            InitializeComponent();
            historyGrid.IsReadOnly = true;
            databaseManager.ShowUserHistoryTable("SELECT * FROM historia_uzytkownika(@pesel)",historyGrid,pesel,null);

            peselText.Text ="Pesel: "+ pesel.ToString();
            string[] customerData = new string[2];
            customerData = databaseManager.ClientInfo(pesel);

            if (customerData[0] != "")
                email.Text = "Email: " + customerData[0];
            else email.Visibility = Visibility.Hidden;

            phon.Text = "Telefon: " + customerData[1];
            userName.Text = databaseManager.ReturnTwoRedcordsAsOneString(0, "SELECT imie, nazwisko FROM wyswietlanie.wyswietlklienci(@pesel)", pesel);
        }

        private void historyGrid_LoadingRow(object sender, DataGridRowEventArgs e)
        {
            
              
        }

        private void logout_Click(object sender, RoutedEventArgs e)
        {
            SelectingCustomerOptions selectingCustomerOptions = new(pesel);

            selectingCustomerOptions.Show();

            this.Close();
        }
    }
}
