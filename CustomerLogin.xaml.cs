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
    /// Logika interakcji dla klasy CustomerLogin.xaml
    /// </summary>
    public partial class CustomerLogin : Window
    {
        public CustomerLogin()
        {
            InitializeComponent();

            
        }



        private void checkPassword_Click(object sender, RoutedEventArgs e)
        {
            DatabaseManager databaseManager = new DatabaseManager();

            if (databaseManager.CustomerLoginExist(peselCustomerInput.Text))
            {
                SelectingCustomerOptions customerOptions = new SelectingCustomerOptions(Convert.ToInt64(peselCustomerInput.Text));
                customerOptions.Show();
                this.Close();
            }
            else wrongPeselNotification.Visibility = Visibility.Visible;
        }
        private void peselCustomerInput_PreviewTextInput(object sender, TextCompositionEventArgs e)
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
        private static bool IsTextAllowed(string text)
        {
            // Sprawdza, czy tekst zawiera tylko cyfry
            return text.All(char.IsDigit);
        }

        private void ChangeToAdminLoginButton_Click(object sender, RoutedEventArgs e)
        {
            AccessSelection accessSelection = new AccessSelection();

            accessSelection.Show();
            this.Close();
        }

        private void toRegistrationButton_Click(object sender, RoutedEventArgs e)
        {
            Registration registration = new Registration();

            registration.Show();
            this.Close();
        }
    }
}
