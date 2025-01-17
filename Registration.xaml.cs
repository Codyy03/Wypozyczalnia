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
    /// Logika interakcji dla klasy registration.xaml
    /// </summary>
    public partial class Registration : Window
    {
        
        public Registration()
        {
            InitializeComponent();
        }
        
        private static bool IsTextAllowed(string text)
        {
            // Sprawdza, czy tekst zawiera tylko cyfry
            return text.All(char.IsDigit);
        }

        private void peselCustomerInput_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            // Sprawdza, czy wprowadzony tekst to cyfra
            e.Handled = !IsTextAllowed(e.Text);
        }

        private void userPhonNumber_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            // Sprawdza, czy wprowadzony tekst to cyfra
            e.Handled = !IsTextAllowed(e.Text);
        }

        private void peselCustomerInput_PreviewKeyDown(object sender, KeyEventArgs e)
        {
            // Pozwala na używanie klawiszy Backspace i Delete
            if (e.Key == Key.Back || e.Key == Key.Delete || e.Key == Key.Left || e.Key == Key.Right || e.Key == Key.Tab)
            {
                e.Handled = false;

            }
        }

        private void userPhonNumber_PreviewKeyDown(object sender, KeyEventArgs e)
        {
            // Pozwala na używanie klawiszy Backspace i Delete
            if (e.Key == Key.Back || e.Key == Key.Delete || e.Key == Key.Left || e.Key == Key.Right || e.Key == Key.Tab)
            {
                e.Handled = false;

            }
        }

        private void registrationButton_Click(object sender, RoutedEventArgs e)
        {

            if (string.IsNullOrEmpty(peselCustomerInput.Text) || peselCustomerInput.Text.Length<11 )
            {
                registratioNotification.Text = "Pesel jest pusty lub jest za krótki";
                return;
            }

            if (string.IsNullOrEmpty(userName.Text))
            {
                registratioNotification.Text = "Musisz podać imię";
                return;
            }
            if (string.IsNullOrEmpty(userLastName.Text))
            {
                registratioNotification.Text = "Musisz podać nazwisko";
                return;
            }

            if (string.IsNullOrEmpty(userPhonNumber.Text) || userPhonNumber.Text.Length<9)
            {
                registratioNotification.Text = "Musisz podać numer telefonu lub sprawdzić jego długość";
                return;
            }

            DatabaseManager databaseManager = new DatabaseManager();

            if(databaseManager.CustomerLoginExist(peselCustomerInput.Text))
            {
                registratioNotification.Text = "Użytkownik o podanym peselu już istnieje";
                return;
            }

            if (databaseManager.CustomerPhonNumberExist(userPhonNumber.Text))
            {
                registratioNotification.Text = "Numer telefonu jest już zajęty";
                return;
            }

            databaseManager.AddKlienta(peselCustomerInput.Text, userName.Text, userLastName.Text, userEmail.Text, userPhonNumber.Text);

            MessageBox.Show("Konto zostało pomyślnie utworzone");

            CustomerLogin customerLogin = new();

            customerLogin.Show();

            this.Close();
        }

        private void backToLogin_Click(object sender, RoutedEventArgs e)
        {
            CustomerLogin customerLogin = new();

            customerLogin.Show();
            this.Close();
        }
    }
}
