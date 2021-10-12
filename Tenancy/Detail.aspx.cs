using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Tenancy_Detail: System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

       

        if (IsPostBack == false)
        {
            for (int i = -1; i < 3; i++)
            {
                DdlLastBillYear.Items.Add(System.DateTime.Now.AddYears(i).ToString("yyyy"));
            }

            DdlLastBillYear.Text = DateTime.Now.Year.ToString();
            DdlLastBillMonth.Text = DateTime.Now.Month.ToString();
                
        }

        //DISPLAY MASTER DELETE BUTTON----------------------------------------------------
        var Btn = (Button)frmTenancy.FindControl("BtnMasterDelete");
        Btn.Visible = (bool)Session["IsAdmin"];
        //--------------------------------------------------------------------------------
    }

    private void UpdatePaymentTable()
    {
        var GrvPayment = (GridView)frmTenancy.FindControl("GrvPaymentSchedule");
        var Rent = double.Parse(((TextBox)GrvPayment.Rows[GrvPayment.Rows.Count-1].Cells[2].FindControl("RentalTextBox")).Text);
        var Service = double.Parse(((TextBox)GrvPayment.Rows[GrvPayment.Rows.Count - 1].Cells[2].FindControl("ServiceTextBox")).Text);

        //--------------------------------------------------------------------------------------------------------
        var TenancyStart = DateTime.Parse(((Label)frmTenancy.FindControl("TxtTenancyTo")).Text).AddDays(1);

        var Dt = new System.Data.DataTable();
        Dt.Columns.Add("PERIOD1");
        Dt.Columns.Add("PERIOD2");
        Dt.Columns.Add("AMOUNT");
        Dt.Columns.Add("SERVICECHARGE");


        for (var i = 0; i < int.Parse(TxtPeriod.Text); i++)
        {
            var MaxPeriod = int.Parse(TxtPeriod.Text);
            var Period01 = i;
            var Period02 = Period01 + 1;

            if (DdlPeriodUnit.Text.ToUpper() == "YEAR")
            {

                if (TenancyStart.AddYears(MaxPeriod) >= TenancyStart.AddYears(Period02))
                {
                    Dt.Rows.Add(TenancyStart.AddYears(Period01).ToString("dd/MMM/yy"), TenancyStart.AddYears(Period02).AddDays(-1).ToString("dd/MMM/yy"), Rent, Service);
                }
                else
                {
                    Dt.Rows.Add(TenancyStart.AddYears(Period01).ToString("dd/MMM/yy"), TenancyStart.AddYears(MaxPeriod).AddDays(-1).ToString("dd/MMM/yy"), Rent, Service);
                }
            }
            else
            {
                if (TenancyStart.AddMonths(MaxPeriod) >= TenancyStart.AddMonths(Period02))
                {
                    Dt.Rows.Add(TenancyStart.AddMonths(Period01).ToString("dd/MMM/yy"), TenancyStart.AddMonths(Period02).AddDays(-1).ToString("dd/MMM/yy"), Rent, Service);
                }
            }

        }
        GrvExtendSchedule.DataSource = Dt;
        GrvExtendSchedule.DataBind();
    }

   
    protected void GrvExtendSchedule_DataBound(object sender, EventArgs e)
    {
        var TotalSqf = (Label)frmTenancy.FindControl("LblSqft");
        var Js = "totalCalc(" + TotalSqf.Text + ")";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "BindJQ", Js, true);

        foreach (GridViewRow Row in GrvExtendSchedule.Rows)
        {
            var Ren = (TextBox)Row.FindControl("RentalTextBox");
            var Sev = (TextBox)Row.FindControl("ServiceTextBox");
            var Sqf1 = (Label)Row.FindControl("PerSqft1Label");
            var Sqf2 = (Label)Row.FindControl("PerSqft2Label");
            Sqf1.Text = (double.Parse(Ren.Text) / double.Parse(TotalSqf.Text)).ToString("0.00");
            Sqf2.Text = (double.Parse(Sev.Text) / double.Parse(TotalSqf.Text)).ToString("0.00");
        }
    }

    protected void TxtPeriod_TextChanged(object sender, EventArgs e)
    {
        UpdatePaymentTable();
    }

    protected void DdlPeriodUnit_SelectedIndexChanged(object sender, EventArgs e)
    {
        UpdatePaymentTable();
    }

    //protected void BtnSaveTenancy_Click(object sender, EventArgs e)
    //{
    //    if (GrvPaymentSchedule.Rows.Count < 1)
    //    {
    //        return;
    //    }

    //    UpdateSquareFeetInPaymentTable();

    //    using (var Cn = new System.Data.SqlClient.SqlConnection())
    //    {
    //        Cn.ConnectionString = Sql01.ConnectionString;
    //        Cn.Open();

    //        using (var Cm = Cn.CreateCommand())
    //        {
    //            var SqlStatement = "";
    //            var TenancyId = "";
    //            var TenancyFrom = DateTime.Parse(TxtTenancyStart.Text);
    //            DateTime TenancyTo;
    //            TenancyTo = DdlPeriodUnit.Text.ToUpper() == "YEAR" ? TenancyFrom.AddYears(int.Parse(TxtPeriod.Text)).AddDays(-1) : TenancyFrom.AddMonths(int.Parse(TxtPeriod.Text)).AddDays(-1);

    //            //TENANCY-----------------------------------------------------------------------------------------------------------------------------------------------
    //            SqlStatement = string.Format(@"INSERT INTO TENANCY ([CustomerId],[AccountCode],[TenancyFrom],[TenancyTo],[Deposit01],[Deposit02],[Deposit03],[Deposit04],[Deposit05],[Waiver], [WaiverUnit],[CreatedBy],[CreatedDateTime]) 
    //                                        VALUES({0},'{1}','{2}','{3}',{4},{5},{6},{7},{8},{9},{10},'{11}','{12}'); SELECT @@IDENTITY",
    //                                        GrvCustomer.SelectedDataKey["Id"].ToString(),
    //                                        TxtAccountCode.Text,
    //                                        TenancyFrom.ToString("dd/MMM/yy"),
    //                                        TenancyTo.ToString("dd/MMM/yy"),
    //                                        TxtDeposit01.Text,
    //                                        TxtDeposit02.Text,
    //                                        TxtDeposit03.Text,
    //                                        TxtDeposit04.Text,
    //                                        TxtDeposit05.Text,
    //                                        TxtWaiver.Text,
    //                                        DdlWaiverUnit.Text,
    //                                        User.Identity.Name, 
    //                                        DateTime.Now.ToString("dd/MMM/yy"));
    //            Cm.CommandText = SqlStatement;

    //            using (var Cursor = Cm.ExecuteReader())
    //            {
    //                Cursor.Read();
    //                TenancyId = Cursor.GetValue(0).ToString();
    //            }

    //            //TENANCY_PROPERTY-------------------------------------------------------------------------------------------------------------------------------------
    //            SqlStatement = string.Format(@"INSERT INTO TENANCY_PROPERTY VALUES ({0},{1})",
    //                                           TenancyId, 
    //                                           GrvProperty.SelectedDataKey["Id"].ToString());
    //            Cm.CommandText = SqlStatement;
    //            Cm.ExecuteNonQuery();


    //            //TENANCY_RENTAL-------------------------------------------------------------------------------------------------------------------------------------
    //            for (var i = 0; i < GrvPaymentSchedule.Rows.Count; i++)
    //            {

    //                var RentalTextBox  = (TextBox)GrvPaymentSchedule.Rows[i].Cells[2].FindControl("RentalTextBox");
    //                var ServiceTextBox = (TextBox)GrvPaymentSchedule.Rows[i].Cells[2].FindControl("ServiceTextBox");
    //                var Period01 = GrvPaymentSchedule.Rows[i].Cells[0].Text;
    //                var Period02 = GrvPaymentSchedule.Rows[i].Cells[1].Text;


    //                SqlStatement = string.Format(@"INSERT INTO TENANCY_RENTAL VALUES ({0},'{1}','{2}',{3}, {4})",
    //                                            TenancyId, Period01, Period02, RentalTextBox.Text, ServiceTextBox.Text);
    //                Cm.CommandText = SqlStatement;
    //                Cm.ExecuteNonQuery();
    //            }
    //        }
    //    }

    //}

    protected void GrvPaymentSchedule_DataBound(object sender, EventArgs e)
    {
        var TotalSqf = (Label)frmTenancy.FindControl("LblSqft");
        var Grv =      (GridView)frmTenancy.FindControl("GrvPaymentSchedule");
        
        foreach (GridViewRow Row in Grv.Rows)
        {
            var Ren = (TextBox)Row.FindControl("RentalTextBox");
            var Sev = (TextBox)Row.FindControl("ServiceTextBox");
            var Sqf1 = (Label)Row.FindControl("PerSqft1Label");
            var Sqf2 = (Label)Row.FindControl("PerSqft2Label");
            Sqf1.Text = (double.Parse(Ren.Text) / double.Parse(TotalSqf.Text)).ToString("0.00");
            Sqf2.Text = (double.Parse(Sev.Text) / double.Parse(TotalSqf.Text)).ToString("0.00");
        }
        var Js = "totalCalc(" + TotalSqf.Text + ");$('[data-toggle=\"tooltip\"]').tooltip();";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "BindJQ", Js, true);


    }

    protected void BtnExtendSave_Click(object sender, EventArgs e)
    {
        if (GrvExtendSchedule.Rows.Count < 1)
        {
            return;
        }
        
        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = Session["ConnectionString"].ToString();
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                //TENANCY--------------------------------------------------------------------------------------------------------------------------------------------
                Cm.CommandText = string.Format("UPDATE TENANCY SET TENANCYTO='{0}' WHERE ID={1}",
                                 GrvExtendSchedule.Rows[GrvExtendSchedule.Rows.Count - 1].Cells[1].Text,
                                 Request.QueryString["Id"]);
                Cm.ExecuteNonQuery();

                //TENANCY_RENTAL-------------------------------------------------------------------------------------------------------------------------------------
                for (var i = 0; i < GrvExtendSchedule.Rows.Count; i++)
                {

                    var RentalTextBox = (TextBox)GrvExtendSchedule.Rows[i].Cells[2].FindControl("RentalTextBox");
                    var ServiceTextBox = (TextBox)GrvExtendSchedule.Rows[i].Cells[2].FindControl("ServiceTextBox");
                    var Period01 = GrvExtendSchedule.Rows[i].Cells[0].Text;
                    var Period02 = GrvExtendSchedule.Rows[i].Cells[1].Text;


                    var SqlStatement = string.Format(@"INSERT INTO TENANCY_RENTAL VALUES ({0},'{1}','{2}',{3}, {4})",
                                                Request.QueryString["Id"], Period01, Period02, RentalTextBox.Text, ServiceTextBox.Text);
                    Cm.CommandText = SqlStatement;
                    Cm.ExecuteNonQuery();
                }
            }
        }

        frmTenancy.DataBind();
        GrvExtendSchedule.DataBind();
        TxtPeriod.Text = "0";

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#DlgExtend').modal('hide');</script>", false);
    }

    protected void BtnSaveTenancy_Click(object sender, EventArgs e)
    {
        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = Session["ConnectionString"].ToString();
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                var A = ((TextBox)frmTenancy.FindControl("TxtAccountCode")).Text;
                var B = ((TextBox)frmTenancy.FindControl("TxtWaiver")).Text;
                var C = ((DropDownList)frmTenancy.FindControl("DdlWaiverUnit")).SelectedItem.Value;
                var D = ((TextBox)frmTenancy.FindControl("TxtDeposit01")).Text;
                var E = ((TextBox)frmTenancy.FindControl("TxtDeposit02")).Text;
                var F = ((TextBox)frmTenancy.FindControl("TxtDeposit03")).Text;
                var G = ((TextBox)frmTenancy.FindControl("TxtDeposit04")).Text;
                var H = ((TextBox)frmTenancy.FindControl("TxtDeposit05")).Text;
                var I = ((TextBox)frmTenancy.FindControl("TxtComment")).Text;


                //TENANCY--------------------------------------------------------------------------------------------------------------------------------------------
                Cm.CommandText = string.Format("UPDATE TENANCY SET ACCOUNTCODE='{0}', WAIVER={1}, WAIVERUNIT={2}, DEPOSIT01={3}, DEPOSIT02={4}, DEPOSIT03={5}, DEPOSIT04={6}, DEPOSIT05={7}, COMMENT='{8}' WHERE ID={9}",
                                 A,B,C,D,E,F,G,H,I,
                                 Request.QueryString["Id"]);
                Cm.ExecuteNonQuery();

                var Grv = (GridView)frmTenancy.FindControl("GrvPaymentSchedule");

                for (var i = 0; i < Grv.Rows.Count; i++)
                {

                    var RentalTextBox =  (TextBox)Grv.Rows[i].Cells[2].FindControl("RentalTextBox");
                    var ServiceTextBox = (TextBox)Grv.Rows[i].Cells[2].FindControl("ServiceTextBox");
                    var Period01 = Grv.Rows[i].Cells[0].Text;
                    var Period02 = Grv.Rows[i].Cells[1].Text;
                    
                    
                    Cm.CommandText = string.Format(@"UPDATE TENANCY_RENTAL SET AMOUNT={0}, SERVICECHARGE={1} WHERE PERIOD1='{2}' AND PERIOD2='{3}' AND TENANCYID={4}",
                                                    RentalTextBox.Text, ServiceTextBox.Text, Period01, Period02, Request.QueryString["Id"]); ;
                    Cm.ExecuteNonQuery();
                }

                //Grv.DataBind();
                AuditHelper.Log("Tenancy", "Edit", Request.QueryString["Id"], GetAuditDescription());
                NotifyHelper.Notify("Tenancy", Request.QueryString["Id"]);

                Response.Redirect("Default.aspx");

            }
        }


        
    }

    protected void BtnDelete_Click(object sender, EventArgs e)
    {
        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = Session["ConnectionString"].ToString();
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                Cm.CommandText = string.Format(@"IF not EXISTS (select tenancyid from PAYMENT WHERE TenancyId={0}) 
                                               BEGIN
                                               DELETE FROM TENANCY_RENTAL where TenancyId={0}
                                               DELETE FROM TENANCY_PROPERTY where TenancyId={0}
                                               DELETE FROM TENANCY where Id={0}
                                               SELECT 1
                                               END
                                               ELSE
                                               SELECT 0", Request.QueryString["Id"]);
                var Dr = Cm.ExecuteScalar();

                
                if (Dr.ToString() == "1") //Delete Success
                {
                    AuditHelper.Log("Tenancy", "Delete", Request.QueryString["Id"], GetAuditDescription());
                    Response.Redirect("Default.aspx");
                }   
                else //Delete Fail
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "BindJQ", "alert('Unable to delete because there are payment records for this tenancy.');", true);
                }
            }
        }

        //Audit Log
        

    }
    
    protected void btnTerminateSave_Click(object sender, EventArgs e)
    {
        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = Session["ConnectionString"].ToString();
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                Cm.CommandText = string.Format(@"UPDATE TENANCY SET Deposit01=0, Deposit02=0, Deposit03=0, Deposit04=0, Deposit05=0, TERMINATE=1, TERMINATEBY='{0}', TERMINATEDATETIME='{1}', TERMINATELASTBILL='{2}', TERMINATECOMMENT='{3}' WHERE ID={4}",
                                               User.Identity.Name,
                                               DateTime.Now.ToString("dd/MMM/yy HH:mm"),
                                               "16/"+DdlLastBillMonth.Text + "/" + DdlLastBillYear.Text,
                                               TxtTerminateComment.Text,
                                               Request.QueryString["Id"]);
                Cm.ExecuteNonQuery();
            }
        }

        AuditHelper.Log("Tenancy", "Terminate", Request.QueryString["Id"], GetAuditDescription());

        Response.Redirect("Default.aspx");
    }
    
    private string GetAuditDescription()
    {
        var LblCustomer = (Label)frmTenancy.FindControl("LblCustomer");
        var Grv = (GridView)frmTenancy.FindControl("GridViewDisplayProperties");
        var _property = new List<string>();

        for (var i = 0; i < Grv.Rows.Count; i++)
        {
            _property.Add(string.Format("{0} ({1})", Grv.Rows[i].Cells[1].Text, Grv.Rows[i].Cells[2].Text));
        }

        return LblCustomer != null ? string.Format("{0} / {1}",LblCustomer.Text, string.Join(", ",_property)) : "";
    }

    protected void BtnMasterDelete_Click(object sender, EventArgs e)
    {
        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = Session["ConnectionString"].ToString();
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                Cm.CommandText = string.Format(@"BEGIN
                                               DELETE FROM TENANCY_RENTAL where TenancyId={0}
                                               DELETE FROM TENANCY_PROPERTY where TenancyId={0}
                                               DELETE FROM TENANCY where Id={0}
                                               DELETE FROM PAYMENT where TenancyId={0}
                                               END
                                               ", Request.QueryString["Id"]);
                Cm.ExecuteNonQuery();
                Response.Redirect("Default.aspx");
            }

            AuditHelper.Log("Tenancy", "Master Delete", Request.QueryString["Id"], GetAuditDescription());
        }
    }
}