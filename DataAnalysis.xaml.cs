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
    /// Logika interakcji dla klasy DataAnalysis.xaml
    /// </summary>
    public partial class DataAnalysis : Window
    {
        DatabaseManager databaseManager = new();
        string sceneTitle;
        

        public DataAnalysis(string title,string sql,Int64 pesel,string sceneTitle)
        {
            InitializeComponent();
            this.sceneTitle = sceneTitle;
            this.title.Text = title;
            historyGrid.IsReadOnly = true;
            databaseManager.ShowUserHistoryTable(sql,historyGrid,pesel,null);

        }
        public DataAnalysis(string title, string sql, string registracion, string sceneTitle)
        {
            InitializeComponent();
            this.sceneTitle = sceneTitle;
            this.title.Text = title;
            historyGrid.IsReadOnly = true;
            databaseManager.ShowUserHistoryTable(sql, historyGrid, 0,registracion);

        }
        private void Button_Click(object sender, RoutedEventArgs e)
        {
            MainWindow mainWindow = new(sceneTitle);

            mainWindow.Show();
            this.Close();
        }

       

    }
}
