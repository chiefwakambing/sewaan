using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Tenancy_New: System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    private void UpdatePaymentTable()
    {
        //if (GrvPickProperty.SelectedIndex < 0 || GrvPickCustomer.SelectedIndex < 0 || TxtTenancyStart.Text == "") 
        //    return;
        if (LblBuildingOrArea.Text == "" | LblCustomer.Text == "" || TxtTenancyStart.Text == "")
            return;

        var Rent    = 0.0;
        var Service = 100;

        if (TextBoxRental.Text != "")
            Rent = TextBoxRental.Text.Split(';').Sum(x => double.Parse(x));


        //--------------------------------------------------------------------------------------------------------
        var TenancyStart = DateTime.Parse(TxtTenancyStart.Text);

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
        GrvPaymentSchedule.DataSource = Dt;
        GrvPaymentSchedule.DataBind();
    }

    private void UpdateSquareFeetInPaymentTable()
    {
        var TotalSqf = "0";

        if (TextBoxSquareFeet.Text != "")
            TotalSqf = TextBoxSquareFeet.Text.Split(';').Sum(x => double.Parse(x)).ToString();

        var Js = "totalCalc(" + TotalSqf + ")";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "BindJQ", Js, true);

        
        foreach (GridViewRow Row in GrvPaymentSchedule.Rows)
        {
            var Ren = (TextBox)Row.FindControl("RentalTextBox");
            var Sev = (TextBox)Row.FindControl("ServiceTextBox");
            var Sqf1 = (Label)Row.FindControl("PerSqft1Label");
            var Sqf2 = (Label)Row.FindControl("PerSqft2Label");
            Sqf1.Text = (double.Parse(Ren.Text) / double.Parse(TotalSqf)).ToString("0.00");
            Sqf2.Text = (double.Parse(Sev.Text) / double.Parse(TotalSqf)).ToString("0.00");
        }
    }

    protected void GrvPaymentSchedule_DataBound(object sender, EventArgs e)
    {
        UpdateSquareFeetInPaymentTable();
    }

    protected void GrvPickProperty_SelectedIndexChanged(object sender, EventArgs e)
    {
        LblBuildingOrArea.Text = GrvPickProperty.SelectedDataKey["BuildingOrArea"].ToString();
        LblLot.Text = GrvPickProperty.SelectedDataKey["Lot"].ToString();
        UpdatePaymentTable();
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#DlgPickProperty').modal('hide'); ShowDatePicker();</script>", false);
        
    }

    protected void TxtTenancyStart_TextChanged(object sender, EventArgs e)
    {
        UpdatePaymentTable();
    }

    protected void TxtPeriod_TextChanged(object sender, EventArgs e)
    {
        UpdatePaymentTable();
    }

    protected void DdlPeriodUnit_SelectedIndexChanged(object sender, EventArgs e)
    {
        UpdatePaymentTable();
    }

    protected void BtnSaveTenancy_Click(object sender, EventArgs e)
    {
        var TenancyId = "";

        if (GrvPaymentSchedule.Rows.Count < 1)
        {
            return;
        }

        UpdateSquareFeetInPaymentTable();

        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = Session["ConnectionString"].ToString();
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                var SqlStatement = "";
                
                var TenancyFrom = DateTime.Parse(TxtTenancyStart.Text);
                DateTime TenancyTo;
                TenancyTo = DdlPeriodUnit.Text.ToUpper() == "YEAR" ? TenancyFrom.AddYears(int.Parse(TxtPeriod.Text)).AddDays(-1) : TenancyFrom.AddMonths(int.Parse(TxtPeriod.Text)).AddDays(-1);

                //TENANCY-----------------------------------------------------------------------------------------------------------------------------------------------
                SqlStatement = string.Format(@"INSERT INTO TENANCY ([CustomerId],[AccountCode],[TenancyFrom],[TenancyTo],[Deposit01],[Deposit02],[Deposit03],[Deposit04],[Deposit05],[Waiver], [WaiverUnit],[CreatedBy],[CreatedDateTime],[Comment],[Terminate]) 
                                            VALUES({0},'{1}','{2}','{3}',{4},{5},{6},{7},{8},{9},{10},'{11}','{12}','{13}',0); 
                                            SELECT @@IDENTITY",
                                            GrvPickCustomer.SelectedDataKey["Id"].ToString(),
                                            TxtAccountCode.Text,
                                            TenancyFrom.ToString("dd/MMM/yy"),
                                            TenancyTo.ToString("dd/MMM/yy"),
                                            TxtDeposit01.Text,
                                            TxtDeposit02.Text,
                                            TxtDeposit03.Text,
                                            TxtDeposit04.Text,
                                            TxtDeposit05.Text,
                                            TxtWaiver.Text,
                                            DdlWaiverUnit.Text,
                                            User.Identity.Name,
                                            DateTime.Now.ToString("dd/MMM/yy"), 
                                            TxtComment.Text);
                Cm.CommandText = SqlStatement;

                using (var Cursor = Cm.ExecuteReader())
                {
                    Cursor.Read();
                    TenancyId = Cursor.GetValue(0).ToString();
                }

                //TENANCY_PROPERTY-------------------------------------------------------------------------------------------------------------------------------------
                foreach (var Id in TextBoxPropertyId.Text.Split(';'))
                {
                    SqlStatement = string.Format(@"INSERT INTO TENANCY_PROPERTY VALUES ({0},{1})",
                                                   TenancyId,
                                                   Id);
                    Cm.CommandText = SqlStatement;
                    Cm.ExecuteNonQuery();
                }

                //TENANCY_RENTAL-------------------------------------------------------------------------------------------------------------------------------------
                for (var i = 0; i < GrvPaymentSchedule.Rows.Count; i++)
                {

                    var RentalTextBox = (TextBox)GrvPaymentSchedule.Rows[i].Cells[2].FindControl("RentalTextBox");
                    var ServiceTextBox = (TextBox)GrvPaymentSchedule.Rows[i].Cells[2].FindControl("ServiceTextBox");
                    var Period01 = GrvPaymentSchedule.Rows[i].Cells[0].Text;
                    var Period02 = GrvPaymentSchedule.Rows[i].Cells[1].Text;


                    SqlStatement = string.Format(@"INSERT INTO TENANCY_RENTAL VALUES ({0},'{1}','{2}',{3}, {4})",
                                                TenancyId, Period01, Period02, RentalTextBox.Text, ServiceTextBox.Text);
                    Cm.CommandText = SqlStatement;
                    Cm.ExecuteNonQuery();
                }
            }

            
        }

        //Audit Log
        AuditHelper.Log("Tenancy", "Create New");
        NotifyHelper.Notify("Tenancy", TenancyId);

        Response.Redirect("Detail.aspx?Id=" + TenancyId);
    }



    protected void GrvPickCustomer_SelectedIndexChanged(object sender, EventArgs e)
    {
        LblCustomer.Text = GrvPickCustomer.SelectedDataKey["OrganizationName"].ToString();
        UpdatePaymentTable();
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#DlgPickCustomer').modal('hide'); ShowDatePicker();</script>", false);
    }

    protected void ButtonPickPropertyAccept_Click(object sender, EventArgs e)
    {
        //LblBuildingOrArea.Text = GrvPickProperty.SelectedDataKey["BuildingOrArea"].ToString();
        //LblLot.Text = GrvPickProperty.SelectedDataKey["Lot"].ToString();
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#DlgPickProperty').modal('hide'); ShowDatePicker();</script>", false);
        if (!(GrvPickProperty.Rows.Count > 0))
            return;

        var IdList      = new List<string>();
        var BuildingList = new List<string>();
        var LotList      = new List<string>();
        var SqFtList     = new List<string>();
        var RentList     = new List<string>();


        for (var i=0; i < GrvPickProperty.Rows.Count; i++)
        {
            var Chk = (CheckBox)GrvPickProperty.Rows[i].FindControl("CheckBoxPickProperty");


            if (Chk.Checked)
            {
                IdList.Add(GrvPickProperty.DataKeys[i]["Id"].ToString());
                BuildingList.Add(GrvPickProperty.Rows[i].Cells[1].Text);
                LotList.Add(GrvPickProperty.Rows[i].Cells[2].Text);
                RentList.Add(GrvPickProperty.Rows[i].Cells[3].Text);
                SqFtList.Add(GrvPickProperty.Rows[i].Cells[4].Text);
            }
        }

        if (BuildingList.Count > 0)
        {
            TextBoxPropertyId.Text = string.Join(";", IdList.ToArray());
            LblBuildingOrArea.Text = string.Join(";", BuildingList.ToArray());
            LblLot.Text = string.Join(";", LotList.ToArray());
            TextBoxSquareFeet.Text= string.Join(";", SqFtList.ToArray());
            TextBoxRental.Text = string.Join(";", RentList.ToArray());
        }

        UpdatePaymentTable();

    }
}