using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Applications_Customers_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
    }

    protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        
        e.Values["CreatedBy"]       = User.Identity.Name;
        e.Values["CreatedDateTime"] = DateTime.Now.ToString("dd/MMM/yy HH:mm");

        var _Description = string.Format("{0}", e.Values["OrganizationName"].ToString());
        AuditHelper.Log("Customer", "Create","", _Description );
    }

    protected void LinkButtonContactAdd_Click(object sender, EventArgs e)
    {
        System.Data.DataTable Contact;

        if (Session["Contact"] == null)
        {
            Contact = new System.Data.DataTable();
            Contact.Columns.Add("Person");
            Contact.Columns.Add("Email");
            Contact.Columns.Add("Phone01");
            Contact.Columns.Add("Phone02");
        }
        else
        {
            Contact = (System.Data.DataTable)Session["Contact"];            
        }

        var Grv = (GridView)FormView1.FindControl("GridViewContact");

        for (var i = 0; i < Grv.Rows.Count; i++)
        {
            foreach (var TextBox in new string[] { "Person", "Email", "Phone01", "Phone02" })
            {
                var Txt = (TextBox)Grv.Rows[i].FindControl("TextBox" + TextBox);
                Contact.Rows[i][TextBox] = Txt.Text;
            }
        }

        Contact.Rows.Add(new string[] { "", "", "", "" });

        Session["Contact"] = Contact;

        Grv.DataSource = Contact;
        Grv.DataBind();
    }

    protected void GridViewContact_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        var Contact = (System.Data.DataTable)Session["Contact"];
        var CId = Request.QueryString["Id"];

        Contact.Rows[e.RowIndex].Delete();
        Contact.AcceptChanges();

        Session["Contact"] = Contact;

        var Grv = (GridView)FormView1.FindControl("GridViewContact");
        Grv.DataSource = Contact;
        Grv.DataBind();
    }

 
    protected void SqlDataSource1_Inserted(object sender, SqlDataSourceStatusEventArgs e)
    {
        var CId = e.Command.Parameters["@NewID"].Value.ToString();

        var Grv = (GridView)FormView1.FindControl("GridViewContact");

        if (Grv.Rows.Count > 0)
        {

            for (var i = 0; i < Grv.Rows.Count; i++)
            {
                var Vals = new List<string>();

                foreach (var TextBox in new string[] { "Person", "Email", "Phone01", "Phone02" })
                {
                    var Txt = (TextBox)Grv.Rows[i].FindControl("TextBox" + TextBox);
                    Vals.Add(Txt.Text);
                }

                if (Vals[0] != "")
                {
                    var Sql = string.Format("insert into CONTACT values (" + CId + ",'{0}','{1}','{2}','{3}')", Vals.ToArray());
                    DBHelper.Execute(Sql);
                }

                if (i==0)
                {
                    var Sql = string.Format("update customer set PersonToContact='{0}', Email='{1}', Contact01='{2}', Contact02='{3}' where id=" + CId, Vals.ToArray());
                    DBHelper.Execute(Sql);

                }
            }

            
        }

        Session.Remove("Contact");
    }
}