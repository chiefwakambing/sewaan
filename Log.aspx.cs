using System;
using System.Collections.Generic;
using System.DirectoryServices;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.DirectoryServices.AccountManagement;

public partial class _AuditLog : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack==false)
        {
            var FirstDayOfThisMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            TextBoxEndDate.Text = FirstDayOfThisMonth.AddMonths(1).AddDays(-1).ToString("yyyy-MM-dd");
            TextBoxStartDate.Text = FirstDayOfThisMonth.ToString("yyyy-MM-dd");
        }
    }



    protected void LinkButtonRefresh_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Js", "$('#ContentPlaceHolder1_GridView1').DataTable();", true);
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.TableSection = TableRowSection.TableHeader;
        }
    }
}