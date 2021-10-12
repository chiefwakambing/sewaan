using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Applications_Customers_Detail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false)
        {
           
        }
    }
    protected void FormView2_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        ScriptManager.RegisterStartupScript(UpdatePanel2, UpdatePanel2.GetType(), "show", "$(function () { $('#EditDialog').modal('hide'); });", true);
        UpdatePanel2.Update();


    }

    protected void lnkDelete_Click(object sender, EventArgs e)
    {

        var OrganizationName = ((Label)FormView1.FindControl("LabelOrganizationName")).Text;
        var PersonToContact = ((GridView)FormView1.FindControl("GridView1")).Rows[0].Cells[0].Text;

        if (GridView3.Rows.Count == 0)
        {
            SqlDataSource1.Delete();

            var _Description = string.Format("{0}, {1}", OrganizationName, PersonToContact);
            AuditHelper.Log("Customer", "Delete", Request.QueryString["Id"], _Description);

            Response.Redirect("Default.aspx");
        }
    }

    protected void lnkEdit_Click(object sender, EventArgs e)
    {
        var CId = Request.QueryString["Id"];

        var Contact = DBHelper.QueryAsDataTable("select * from contact where CustomerId=" + CId);
        Session["Contact"] = Contact;

        if (Contact.Rows.Count == 0)
        {
            Contact.Rows.Add(new string[] { CId, "", "", "", "" });
        }

        var Grv = (GridView)FormView2.FindControl("GridViewContact");
        Grv.DataSource = Contact;
        Grv.DataBind();

        ScriptManager.RegisterStartupScript(UpdatePanel2, UpdatePanel2.GetType(), "show", "$(function () { $('#EditDialog').modal('show'); });", true);
    }

    protected void FormView2_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        var Grv = (GridView)FormView2.FindControl("GridViewContact");

        if (Grv.Rows.Count > 0)
        {
            DBHelper.Execute("Delete from Contact Where CustomerId=" + Request.QueryString["Id"]);


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
                    var Sql = string.Format("insert into CONTACT values (" + Request.QueryString["Id"] + ",'{0}','{1}','{2}','{3}')", Vals.ToArray());
                    DBHelper.Execute(Sql);
                }

                if (i == 0)
                {
                    var Sql = string.Format("update customer set PersonToContact='{0}', Email='{1}', Contact01='{2}', Contact02='{3}' where id=" + Request.QueryString["Id"], Vals.ToArray());
                    DBHelper.Execute(Sql);

                }
            }
        }
        
        var _Description = string.Format("{0}", e.NewValues["OrganizationName"].ToString());

        AuditHelper.Log("Customer", "Edit", Request.QueryString["Id"], _Description);

    }


    protected void LinkButtonContactAdd_Click(object sender, EventArgs e)
    {
        var Contact = (System.Data.DataTable)Session["Contact"];
        
        var CId = Request.QueryString["Id"];

        var Grv = (GridView)FormView2.FindControl("GridViewContact");

        for (var i=0; i< Grv.Rows.Count; i++)
        {
            foreach (var TextBox in new string[] { "Person", "Email", "Phone01", "Phone02" })
            {
                var Txt = (TextBox)Grv.Rows[i].FindControl("TextBox" + TextBox);
                Contact.Rows[i]["CustomerId"] = CId;
                Contact.Rows[i][TextBox] = Txt.Text;
            }
        }

        Contact.Rows.Add(new string[] { CId, "", "", "", ""});

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

        var Grv = (GridView)FormView2.FindControl("GridViewContact");
        Grv.DataSource = Contact;
        Grv.DataBind();
    }
}