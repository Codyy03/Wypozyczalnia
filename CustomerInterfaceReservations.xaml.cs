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
    public partial class CustomerInterfaceReservations : Window
    {
        // 1 string rejestracja, id modelu
        List<Tuple<string, int>> registrationsIds = new List<Tuple<string, int>>();
        List<string> carsNames = new();
        DatabaseManager databaseManager = new();
        // 1 string rejestracja
        // 2 string nazwa pojazdu


        List<Tuple<string, string>> carsReservation = new();
        Int64 pesel;
        public CustomerInterfaceReservations()
        {
            InitializeComponent();
            SetCars();

            
        }

         void SetCars()
         {
                registrationsIds.Clear();
                registrationsIds = databaseManager.AllRCarsRegistrations(true);
                carsNames.Clear();
                carsNames.Add("-- Wybierz opcję --");
                for (int i = 0; i < registrationsIds.Count; i++)
                {
                    carsNames.Add(databaseManager.ReturnTwoRedcordsAsOneString(registrationsIds[i].Item2, "SELECT marka, model FROM wyswietlanie.wyswietlmodele(@id)",0));
                }
                carsToRentListBox.ItemsSource = null;

                carsOptions.ItemsSource = null;
                carsOptions.ItemsSource = carsNames;
                carsOptions.SelectedIndex = 0;
              

            }
        
        public void setPesel(Int64 pesel)
        {
            this.pesel = pesel;

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

                if (carsReservation.Any(tuple => tuple.Item1 == registrationsIds.ElementAt(selectedIndex - 1).Item1))
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
            if (!carsReservation.Any(tuple => tuple.Item1 == registrationsIds.ElementAt(selectedIndex - 1).Item1))
                carsReservation.Add(new Tuple<string, string>(registrationsIds.ElementAt(selectedIndex - 1).Item1, carName.Text));


            UpdateCart();
        }

        private void addToRent_Unchecked(object sender, RoutedEventArgs e)
        {

            carsReservation.RemoveAll(tuple => tuple.Item1 == registrationsIds.ElementAt(selectedIndex - 1).Item1);
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
            carsToRentListBox.ItemsSource = carsReservation;
        }
        private void carsToRentListBox_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            // Sprawdzenie, czy element jest wybrany
            if (carsToRentListBox.SelectedItem != null)
            {
                // Pobranie wybranego elementu
                var selectedItem = carsToRentListBox.SelectedItem as Tuple<string, string>;
                if (registraction.Text.Contains(selectedItem.Item1))
                {
                    addToRent.IsChecked = false;

                }
                // Usunięcie elementu z listy krotek
                carsReservation.Remove(selectedItem);
                // Odświeżenie ListBoxa
                carsToRentListBox.ItemsSource = null;
                carsToRentListBox.ItemsSource = carsReservation;
            }
        }


        private void orderCarsButton_Click(object sender, RoutedEventArgs e)
        {
            if (carsToRentListBox.Items.Count == 0)
                return;
            string[] registractionsTab = new string[carsReservation.Count];
            for (int i = 0; i < carsReservation.Count; i++)
            {
                registractionsTab[i] = carsReservation[i].Item1;
            }
            
            databaseManager.BookCar(pesel, startDatePicker.SelectedDate.Value, endDatePicker.SelectedDate.Value, registractionsTab);

           
            registrationsIds.Clear();
            
            SetCars();
           
        }


        private void startDatePicker_Loaded(object sender, RoutedEventArgs e)
        {
            DateTime tomorrow = DateTime.Today.AddDays(1);

            // Ustawienie domyślnej daty na jutro
            startDatePicker.SelectedDate = tomorrow;

            // Blokowanie wcześniejszych dat
            startDatePicker.BlackoutDates.Add(new CalendarDateRange(DateTime.MinValue, DateTime.Today));

        }

        private void startDatePicker_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        {
            if (startDatePicker.SelectedDate.HasValue)
            {
                DateTime selectedStartDate = startDatePicker.SelectedDate.Value;
                // Ustawienie maksymalnej daty dla endDatePicker na 30 dni od wybranej daty początkowej
                endDatePicker.DisplayDateStart = selectedStartDate;
                endDatePicker.DisplayDateEnd = selectedStartDate.AddDays(30);
                // Opcjonalnie ustawienie wybranej daty w endDatePicker na wybraną datę początkową
                endDatePicker.BlackoutDates.Clear();
                endDatePicker.SelectedDate = selectedStartDate.AddDays(1);
                // Blokowanie wcześniejszych dat w endDatePicker
                endDatePicker.BlackoutDates.Add(new CalendarDateRange(DateTime.MinValue, selectedStartDate.AddDays(-1)));
                endDatePicker.BlackoutDates.Add(new CalendarDateRange(selectedStartDate.AddDays(31), DateTime.MaxValue));
            }
        }
    }
}
