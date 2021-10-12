using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Applications_Tenancies_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = Session["ConnectionString"].ToString();
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                Cm.CommandText = "SELECT SUM(TotalDeposit) FROM vTenancy";
                var Result = Cm.ExecuteScalar();
                var Total = 0.0m;
                decimal.TryParse(Result.ToString(), out Total);
                LabelTotalDeposit.Text = Total.ToString("#,###,##0.00");
            }
        }
		
    }
	
	 public string Color(int input)
    {
        if (input < 0)
        {
            return "label label-danger";
        }
        else if ((input >= 0) && (input < 7))
        {
            return "label label-warning";
        }
        else
        {
            return "label label-success";
        }
    }
  
}