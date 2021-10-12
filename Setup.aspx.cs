using System;
using System.Collections.Generic;
using System.DirectoryServices;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.DirectoryServices.AccountManagement;

public partial class Setup : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack==false)
        {
            
            
                //using (var context = new PrincipalContext(ContextType.Domain, "KHTP"))
                //{
                //    using (var searcher = new PrincipalSearcher(new UserPrincipal(context)))
                //    {
                //        foreach (var result in searcher.FindAll())
                //        {
                //            DirectoryEntry de = result.GetUnderlyingObject() as DirectoryEntry;

                //            //Console.WriteLine("SAM account name   : " + de.Properties["samAccountName"].Value);
                //            //Console.WriteLine("User principal name: " + de.Properties["userPrincipalName"].Value);

                //        }
                //    }
                //}
            
        }
    }

    protected void btnUser_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#SecurityDialog').modal('show');</script>", false);
    }

    protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        var DdlModule = (DropDownList)FormView1.FindControl("DdlModule");
        e.Values["Module"] = DdlModule.SelectedItem.Value;
     }

    protected void chkIsContribute_CheckedChanged(object sender, EventArgs e)
    {
        var Chk = (CheckBox)sender;

        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = Session["ConnectionString"].ToString();
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                Cm.CommandText = string.Format("UPDATE SECURITY SET ISCONTRIBUTE={0} WHERE ID={1}", Chk.Checked ? 1 : 0, Chk.ValidationGroup);
                Cm.ExecuteNonQuery();
            }
        }
    }

    protected void chkIsReadOnly_CheckedChanged(object sender, EventArgs e)
    {
        var Chk = (CheckBox)sender;

        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = Session["ConnectionString"].ToString();
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                Cm.CommandText = string.Format("UPDATE SECURITY SET ISREADONLY={0} WHERE ID={1}", Chk.Checked ? 1 : 0, Chk.ValidationGroup);
                Cm.ExecuteNonQuery();
            }
        }
    }

    protected void chkIsNotify_CheckedChanged(object sender, EventArgs e)
    {
        var Chk = (CheckBox)sender;

        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = Session["ConnectionString"].ToString();
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                Cm.CommandText = string.Format("UPDATE SECURITY SET ISNOTIFY={0} WHERE ID={1}", Chk.Checked ? 1 : 0, Chk.ValidationGroup);
                Cm.ExecuteNonQuery();
            }
        }
    }
}