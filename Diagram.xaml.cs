using OxyPlot;
using OxyPlot.Series;
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
    /// Logika interakcji dla klasy Diagram.xaml
    /// </summary>
    public partial class Diagram : Window
    {
        public PlotModel PlotModel { get; set; }
        DatabaseManager databaseManager = new();
        string title;
        public Diagram(string title)
        {
            InitializeComponent();
            DataContext = this;
            this.title = title;
        }

        public void ShowCarsDiagram()
        {
            databaseManager.ShowDiagramRevenues(PlotModel, plotView);
        }

        public void ShowCustomersDiagram()
        {
            databaseManager.ShowDiagramCustomersRevenues(PlotModel, plotView);
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            MainWindow mainWindow = new MainWindow(title);

            mainWindow.Show();
            this.Close();
        }
    }
}
