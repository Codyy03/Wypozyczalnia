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
    /// Logika interakcji dla klasy SelectingCustomerOptions.xaml
    /// </summary>
    public partial class SelectingCustomerOptions : Window
    {
        Int64 pesel;
        public SelectingCustomerOptions(Int64 pesel)
        {
            InitializeComponent();
            this.pesel = pesel;
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            CustomerInterface customerInterface = new CustomerInterface(pesel);

          
            customerInterface.Show();
            
            this.Close();
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            CustomerInterfaceReservations customerInterfaceReservations = new CustomerInterfaceReservations();
            customerInterfaceReservations.setPesel(Convert.ToInt64(pesel));
            customerInterfaceReservations.Show();
            this.Close();
        }

        private void Button_Click_2(object sender, RoutedEventArgs e)
        {
            CustomerLogin customerLogin = new CustomerLogin();

            customerLogin.Show();
            this.Close();
        }

        private void clientInfoButton_Click(object sender, RoutedEventArgs e)
        {
            CustomerInfo customerInfo = new(pesel);

            customerInfo.Show();
            this.Close();
        }
    }
}
