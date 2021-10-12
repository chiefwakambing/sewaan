using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Applications_Properties_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false)
        {
            
        }

    }

    protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = SqlDataSource1.ConnectionString;
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                Cm.CommandText = string.Format("SELECT COUNT(*) FROM PROPERTY WHERE BuildingOrArea='{0}' And Lot='{1}'",
                               e.Values["BuildingOrArea"],
                               e.Values["Lot"]);
                var Result = Cm.ExecuteScalar();
                
                if (Result.ToString() != "0")
                {
                    var Message = (Label)FormView1.FindControl("Label3");
                    Message.Text = "Property already exists!";
                    e.Cancel = true;

                    return;
                }
            }
        }            

        var Amenity = new List<string>();
        var ChkList = (CheckBoxList)FormView1.FindControl("CheckBoxListAmenity");

        for (var i = 0; i < ChkList.Items.Count; i++)
        {
            if (ChkList.Items[i].Selected)
            {
                Amenity.Add(ChkList.Items[i].Text);
            }
            e.Values["Amenity"] = string.Join(", ", Amenity.ToArray());
        }

        e.Values["CreatedBy"] = User.Identity.Name;
        e.Values["CreatedDateTime"] = DateTime.Now.ToString("dd/MMM/yy HH:mm");

        var _Description = string.Format("{0}, {1}", e.Values["BuildingOrArea"].ToString(), e.Values["Lot"].ToString());
        AuditHelper.Log("Property", "Create", "", _Description);
    }

    protected void ButtonUpdateCode_Click(object sender, EventArgs e)
    {
        if ((bool)Session["IsContribute"] == false)
            return;


        var Grv = (GridView)((Control)sender).Parent.FindControl("GridView1");

        for (var i=0; i<Grv.Rows.Count; i++)
        {
            var CodeNo = ((TextBox)Grv.Rows[i].FindControl("TextBoxCodeNo")).Text;
            var Id     = Grv.DataKeys[i]["Id"].ToString();

            if (CodeNo != "")
            {
                var Sql = string.Format("UPDATE PROPERTY SET CODENO='{0}' WHERE ID={1}", CodeNo, Id);
                SqlDataSource1.UpdateCommand = Sql;
                SqlDataSource1.Update();

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Js", "alertify.success('Code updated sucessfully');", true);
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
	
	 protected void GridView1_DataBound(object sender, EventArgs e)
    {
		
        var Grv = (GridView)((Control)sender).Parent.FindControl("GridView1");

		double totalSqft = 0;
        double sumRM = 0;

        foreach (GridViewRow row in Grv.Rows)
        {
            totalSqft += double.Parse(row.Cells[3].Text);

            double rental;
            if (double.TryParse(row.Cells[4].Text.Trim(), out rental))
            {
                sumRM += rental;
            }
        }

        Grv.FooterRow.Cells[3].Text = totalSqft.ToString("#,##0.00"); //0:#,##0.00
        Grv.FooterRow.Cells[4].Text = sumRM.ToString("##,##0.00"); //0:##,##0.00
		
    }
}