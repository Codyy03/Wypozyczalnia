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
    /// Logika interakcji dla klasy AccessSelection.xaml
    /// </summary>
    public partial class AccessSelection : Window
    {
        public AccessSelection()
        {
            InitializeComponent();
        }

        private void checkPassword_Click(object sender, RoutedEventArgs e)
        {
            SelectTableWindows selectTableWindows = new SelectTableWindows();

            if(loginPasswordInput.Password=="123")
            {
                selectTableWindows.Show();
                this.Close();
            }
        }

        private void changeToCustomerLogin_Click(object sender, RoutedEventArgs e)
        {
            CustomerLogin customerLogin = new CustomerLogin();

            customerLogin.Show();
            this.Close();
        }
    }
}
