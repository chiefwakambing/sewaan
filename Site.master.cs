using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class StyleSheets_Site : System.Web.UI.MasterPage
{
    //protected void Page_Load(object sender, EventArgs e)
    protected void Page_Init(object sender, EventArgs e)
    {
        var UsrName = HttpContext.Current.User.Identity.Name;
        var ModName = Page.Page.Request.Path.Split('/')[1];

        Session["ConnectionString"] = ConfigurationManager.ConnectionStrings["AliijarConnectionString"].ConnectionString + "; Application Name=" + UsrName;

        if (ModName.ToUpper()=="DEFAULT.ASPX") return;
        
        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = Session["ConnectionString"].ToString();
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                Cm.CommandText = string.Format("SELECT TOP 1 ISCONTRIBUTE, ISADMIN, MODULE FROM SECURITY WHERE USERNAME='{0}' AND MODULE='{1}'", UsrName, ModName);
		

                var Cursor = Cm.ExecuteReader();

                if (Cursor.Read())
                {

                    if (ModName.ToUpper() == Cursor.GetValue(2).ToString().ToUpper() || (Cursor.GetValue(1).ToString() != "" && Cursor.GetBoolean(1) != false))
                    {
                        Session["IsAdmin"]      = Cursor.GetValue(1).ToString() == "" ? false : Cursor.GetBoolean(1);
                        Session["IsContribute"] = Cursor.GetValue(0).ToString() == "" ? false : Cursor.GetBoolean(0);
                    }
                    else
                    {
                        Response.Write("Access Denied for <strong>" + UsrName + "</strong>");
                        Response.End();
                    }

                    Cursor.Close();
                }
                else
                {
                    Response.Write("Access Denied for <strong>" + UsrName + "</strong>");
                    Response.End();
                }
            }
        }
    }
}
