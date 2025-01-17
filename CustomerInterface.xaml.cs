using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace GUI
{
    /// <summary>
    /// Logika interakcji dla klasy CustomerInterface.xaml
    /// </summary>
    public partial class CustomerInterface : Window
    {
        // 1 string rejestracja
        // 2 string id
        List<Tuple<string, int>> registrationsIds = new List<Tuple<string, int>>();

        List<string> carsNames = new();
        DatabaseManager databaseManager = new();
        // 1 string rejestracja
        //2 string cena za dzień
        // 3 string nazwa pojazdu
        List<Tuple<string, string, string>> carsToRent = new();
        Int64 pesel;


        public CustomerInterface(Int64 pesel)
        {

            this.pesel = pesel;
            InitializeComponent();
            SetCars();



            slider.IsEnabled = false;
        }

        void SetCars()
        {
            registrationsIds.Clear();
            registrationsIds = databaseManager.AllRCarsRegistrations(false);
            carsNames.Clear();
            carsNames.Add("-- Wybierz opcję --");
            for (int i = 0; i < registrationsIds.Count; i++)
            {
                carsNames.Add(databaseManager.ReturnTwoRedcordsAsOneString(registrationsIds[i].Item2, "SELECT marka, model FROM wyswietlanie.wyswietlmodele(@id)",0));
            }
         

            carsOptions.ItemsSource = null;
            carsOptions.ItemsSource = carsNames;
            carsOptions.SelectedIndex = 0;


            slider.IsEnabled = false;

        }
        int selectedIndex = 0;
        string[] data = new string[7];
        private void carsOptions_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            selectedIndex = carsOptions.SelectedIndex;
            if (selectedIndex == 0)
            {
                firstCar.Visibility = Visibility.Hidden;
                return;
            }

            if (selectedIndex > 0)
            {
                firstCar.Visibility = Visibility.Visible;


                data = databaseManager.BrandModel(registrationsIds.ElementAt(selectedIndex - 1).Item1);

                carName.Text = carsNames[selectedIndex];
                engineCapacity.Text = $"Pojemność silnika: {data[0]}";
                enginePower.Text = $"Moc silnika: {data[1]}";
                carColor.Text = $"Kolor: {data[2]}";
                productionDate.Text = $"Data produkcji: {data[3]}";
                carMileage.Text = $"Przebieg: {data[4]}";
                employee.Text = $"Opiekun: {data[6]}";
                price.Text = $"Cena: {data[5].ToString()}";
                registraction.Text = $"Rejestracja: {registrationsIds.ElementAt(selectedIndex - 1).Item1}";

                if (carsToRent.Any(tuple => tuple.Item1 == registrationsIds.ElementAt(selectedIndex - 1).Item1))
                {
                    addToRent.IsChecked = true;
                }
                else
                {
                    addToRent.IsChecked = false;
                }
            }
        }

        private void addToRent_Checked(object sender, RoutedEventArgs e)
        {
            if (!carsToRent.Contains(new Tuple<string, string, string>(registrationsIds.ElementAt(selectedIndex - 1).Item1, data[5], carName.Text)))
                carsToRent.Add(new Tuple<string, string, string>(registrationsIds.ElementAt(selectedIndex - 1).Item1, data[5], carName.Text));


            CalculatePrice();
            slider.IsEnabled = true;
            UpdateCart();


        }

        private void addToRent_Unchecked(object sender, RoutedEventArgs e)
        {

            carsToRent.RemoveAll(tuple => tuple.Item1 == registrationsIds.ElementAt(selectedIndex - 1).Item1);
            if (carsToRentListBox.Items.Count == 0)
                slider.IsEnabled = false;

            CalculatePrice();
            UpdateCart();
        }


        private void Button_Click(object sender, RoutedEventArgs e)
        {
            SelectingCustomerOptions selectingCustomerOptions = new(pesel);

            selectingCustomerOptions.Show();

            this.Close();

        }

        void UpdateCart()
        {
            carsToRentListBox.ItemsSource = null;
            carsToRentListBox.ItemsSource = carsToRent;
            slider.Value = 1;

            List<string> cars = new();

            foreach (var car in carsToRent)
            {
                cars.Add(car.Item1);
            }
            if(cars.Count > 0) 
            slider.Maximum = databaseManager.HowManyDaysCarCanBeRent(cars.ToArray());

            CalculatePrice();
        }
        private void carsToRentListBox_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            // Sprawdzenie, czy element jest wybrany
            if (carsToRentListBox.SelectedItem != null)
            {
                // Pobranie wybranego elementu
                var selectedItem = carsToRentListBox.SelectedItem as Tuple<string, string, string>;
                if (registraction.Text.Contains(selectedItem.Item1))
                {
                    addToRent.IsChecked = false;
                    slider.IsEnabled = true;
                }
                // Usunięcie elementu z listy krotek
                carsToRent.Remove(selectedItem);
                // Odświeżenie ListBoxa
                carsToRentListBox.ItemsSource = null;
                carsToRentListBox.ItemsSource = carsToRent;

                if (carsToRentListBox.Items.Count == 0)
                    slider.IsEnabled = false;

                CalculatePrice();

            }
        }

        void CalculatePrice()
        {
            int fullPrice = 0;

            foreach (var item in carsToRent)
            {

                fullPrice += databaseManager.PriceForCarRent(item.Item1, DateTime.Today, DateTime.Today.AddDays(slider.Value));

            }

            if (endPrice != null)
                endPrice.Text = "Cena końcowa: " + fullPrice;
        }
        private void orderCarsButton_Click(object sender, RoutedEventArgs e)
        {
            if (carsToRentListBox.Items.Count == 0)
                return;

            string[] registractionsTab = new string[carsToRent.Count];
            for (int i = 0; i < carsToRent.Count; i++)
            {
                registractionsTab[i] = carsToRent[i].Item1;

            }

            databaseManager.RentCars(pesel, DateTime.Today.AddDays(slider.Value), registractionsTab);
            MessageBox.Show("Pomyślnie wypożyczono");
            CustomerInterface customerInterface = new CustomerInterface(pesel);

            customerInterface.Show();
            this.Close();

        }

        private void slider_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {


            CalculatePrice();
        }
    }
}
