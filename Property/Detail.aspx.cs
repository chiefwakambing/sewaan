using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Applications_Properties_Detail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack==false)
        {
            
            DropDownListInternalOccupancy.Items.Add("");

            using (var Cn = new System.Data.SqlClient.SqlConnection())
            {
                Cn.ConnectionString = Session["ConnectionString"].ToString();
                Cn.Open();

                using (var Cm = Cn.CreateCommand())
                {
                    Cm.CommandText = string.Format("SELECT DISTINCT ORGANIZATIONNAME FROM CUSTOMER");
                    using (var Dr = Cm.ExecuteReader())
                    {
                        while (Dr.Read())
                        {
                            DropDownListInternalOccupancy.Items.Add(Dr.GetValue(0).ToString());
                        }
                    }
                }
            }
        }
    }
    protected void FormView2_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        e.Values["PropertyId"] = Request.QueryString["Id"];
        e.Values["CreatedBy"] = User.Identity.Name;
        e.Values["CreatedDateTime"] = DateTime.Now.ToString("dd/MMM/yy HH:mm");
    }
    

    protected void FormView2_DataBound(object sender, EventArgs e)
    {
        if (FormView2.CurrentMode == FormViewMode.Edit)
        {
            var Ls = (CheckBoxList)FormView2.FindControl("CheckBoxListAmenity");
            var Rw = (System.Data.DataRowView)FormView2.DataItem;

            if (Rw != null)
            {
                var Am = Rw["Amenity"].ToString().Split(',');

                foreach (var A in Am)
                {
                    for (var i = 0; i < Ls.Items.Count; i++)
                    {
                        if (Ls.Items[i].Text == A.Trim())
                        {
                            Ls.Items[i].Selected = true;
                            break;
                        }
                    }
                }
            }
        }
    }

    protected void FormView2_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        var Amenity = new List<string>();
        var ChkList = (CheckBoxList)FormView2.FindControl("CheckBoxListAmenity");

        for (var i = 0; i < ChkList.Items.Count; i++)
        {
            if (ChkList.Items[i].Selected)
            {
                Amenity.Add(ChkList.Items[i].Text);
            }
            e.NewValues["Amenity"] = string.Join(", ", Amenity.ToArray());
            e.NewValues["CreatedBy"] = User.Identity.Name;
            e.NewValues["CreatedDateTime"] = DateTime.Now.ToString("dd/MMM/yy HH:mm");
        }

        var _Description = string.Format("{0}, {1}", e.NewValues["BuildingOrArea"].ToString(), e.NewValues["Lot"].ToString());
        AuditHelper.Log("Property", "Edit", Request.QueryString["Id"], _Description);

    }

    protected void FormView2_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        GridView1.DataBind();
        GridView2.DataBind();

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#EditDialog').modal('hide');</script>", false);
    }

    protected void lnkDelete_Click(object sender, EventArgs e)
    {
        SqlDataSource1.Delete();
        
        var BuildingOrArea = LabelBuildingOrArea.Text;
        var Lot = GridView1.Rows[0].Cells[0].Text;
        var _Description = string.Format("{0}, {1}", BuildingOrArea, Lot);
        AuditHelper.Log("Property", "Delete", Request.QueryString["Id"], _Description);

        Response.Redirect("Default.aspx");
    }
    
    protected void GridView3_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('[data-toggle=\"tooltip\"]').tooltip();</script>", false);
    }

    protected void GridView4_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType==DataControlRowType.DataRow)
        {
            var ROW = (System.Data.DataRowView)e.Row.DataItem;
            
            if (ROW["TERMINATE"].ToString() != "" && (bool)ROW["TERMINATE"] == true)
            {
                var Lbl = (Label)e.Row.FindControl("LblTerminate");
                Lbl.Text = "Terminated On " + DateTime.Parse(ROW["TERMINATEDATETIME"].ToString()).ToString("dd/MMM/yy");
            }
        }
    }

    protected void ButtonSaveInternalOccupancy_Click(object sender, EventArgs e)
    {
        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = Session["ConnectionString"].ToString();
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                Cm.CommandText = string.Format("UPDATE PROPERTY SET InternalOccupancy = '{0}' WHERE Id={1}", DropDownListInternalOccupancy.Text,Request.QueryString["Id"]);
                Cm.ExecuteNonQuery();

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "alertify.success('Updates successfully'); $('[data-toggle=\"tooltip\"]').tooltip();", true);

            }
        }
    }

    protected void GridView1_DataBound(object sender, EventArgs e)
    {

    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType==DataControlRowType.DataRow)
        {
            var Row = (System.Data.DataRowView)e.Row.DataItem;

            DropDownListInternalOccupancy.Text = Row["InternalOccupancy"].ToString();
        }
    }

    protected void lnkEdit_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#EditDialog').modal('show');</script>", false);
    }
}