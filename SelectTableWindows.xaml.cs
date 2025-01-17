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
    /// Logika interakcji dla klasy SelectTableWindows.xaml
    /// </summary>
    public partial class SelectTableWindows : Window
    {
        
        public SelectTableWindows()
        {
            InitializeComponent();
        }
        void ChangeWindow(string title)
        {
            MainWindow mainWindow = new MainWindow(title);
            this.Close();
            mainWindow.Show();
        }
        private void modelsTableButton_Click(object sender, RoutedEventArgs e)
        {
            ChangeWindow("Modele");
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            ChangeWindow("Klienci");
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            ChangeWindow("Egzemplarze");
        }

        private void Button_Click_2(object sender, RoutedEventArgs e)
        {
            ChangeWindow("Pracownicy");
        }

        private void Button_Click_3(object sender, RoutedEventArgs e)
        {
            ChangeWindow("Rezerwacje");
        }

        private void Button_Click_4(object sender, RoutedEventArgs e)
        {
            ChangeWindow("Wypozyczone");
        }

        private void ReturnToLoginButton_Click(object sender, RoutedEventArgs e)
        {
            AccessSelection accessSelection = new();

            accessSelection.Show();
            this.Close();
        }
    }
}
