using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Billings_Default : System.Web.UI.Page
{
    private void CalculateTotalBilled()
    {
        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = Session["ConnectionString"].ToString();
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                Cm.CommandText = string.Format("SELECT Distinct TenancyId, BillingTransaction FROM PAYMENT WHERE BILLMONTH={0} AND BILLYEAR={1}", DropDownList1.Text, DropDownList2.Text);
                var Result = Cm.ExecuteReader();

                var InternalDt = new System.Data.DataTable();
                var Cell = new Dictionary<string, string>();

                //transform delimetered string into data table------------------------------------------------------
                while (Result.Read())
                {
                    var Col = Result.GetValue(1).ToString().Split(';');
                    var TaxTotal = 0.0;

                    foreach (var fld in Col)
                    {
                        var colname = fld.Split('^')[0];
                        var colvalue = fld.Split('^')[1];
                        var coltax = fld.Split('^')[2];

                        if (colname.ToUpper().StartsWith("ELECTRIC"))
                        {
                            colname = "ELECTRIC";
                        }

                        if (InternalDt.Columns.Contains(colname) == false)
                        {
                            InternalDt.Columns.Add(colname, typeof(double));
                        }

                        if (InternalDt.Columns.Contains("TAX") == false)
                        {
                            InternalDt.Columns.Add("TAX", typeof(double));
                        }

                        Cell.Add(colname, colvalue);

                        if (coltax.ToUpper() == "TRUE")
                        {
                            TaxTotal += double.Parse(colvalue) * 0.06;
                        }
                        else
                        {
                            TaxTotal += 0;
                        }
                    }

                    Cell.Add("TAX", TaxTotal.ToString());

                    InternalDt.Rows.Add();
                    foreach (var C in Cell)
                    {
                        InternalDt.Rows[InternalDt.Rows.Count - 1][C.Key] = C.Value;
                    }

                    Cell.Clear();
                }

                if (InternalDt.Rows.Count > 0)
                {
                    //aggregate the column------------------------------------------------------------------------------
                    var SumDt = new System.Data.DataTable();
                    var SumRw = new List<double>();
                    foreach (System.Data.DataColumn Col in InternalDt.Columns)
                    {
                        SumDt.Columns.Add(Col.ColumnName.ToUpper());

                        var Total = InternalDt.Compute("Sum([" + Col.ColumnName + "])", string.Empty).ToString();
                        SumRw.Add(double.Parse(Total == "" ? "0" : Total));
                    }

                    SumDt.Rows.Add(SumRw.Select(V => V.ToString("#,###,##0.00")).ToArray());
                    SumDt.Columns.Add("TOTAL");
                    SumDt.Rows[0]["TOTAL"] = SumRw.Sum().ToString("#,###,##0.00");
                    SumDt.Columns["TAX"].SetOrdinal(SumDt.Columns.Count - 2);
                    GridView1.DataSource = SumDt;
                    GridView1.DataBind();
                }
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            for (int i = -1; i < 5; i++) //i = 0
            {
                DropDownList2.Items.Add(DateTime.Now.AddYears(0 - i).Year.ToString());
            }

            DropDownList1.Text = DateTime.Now.Month.ToString();
            DropDownList2.Text = DateTime.Now.Year.ToString();

            
        }

        LabelBilling.Text = DropDownList1.Text + " / " + DropDownList2.Text;
        CalculateTotalBilled();
    }

    protected void GrvBilling_SelectedIndexChanged(object sender, EventArgs e)
    {
        var GrvBilling = (GridView)sender;
        var Waiver      = int.Parse( GrvBilling.SelectedDataKey["Waiver"].ToString());
        var WaiverUnit  = int.Parse( GrvBilling.SelectedDataKey["WaiverUnit"].ToString());
        var TenancyFrom = DateTime.Parse( GrvBilling.SelectedDataKey["TenancyFrom"].ToString());
        var WaiverDate = TenancyFrom.AddMonths(Waiver-1);

        //------------------------------------------------------------------------------------------------------------
        var BillingTransaction = GrvBilling.SelectedDataKey["BillingTransaction"];
        
        using (var Dt = new System.Data.DataTable())
        {
            Dt.Columns.Add("ITEM");
            Dt.Columns.Add("AMOUNT", typeof(double));
            Dt.Columns.Add("GST", typeof(bool));

            if (BillingTransaction.ToString() == "")
            {
                Session["InsertFlag"] = true;
                TxtBillDate.Text = System.DateTime.Now.ToString("yyyy-MM-dd");
                TxtElecBillDate.Text = System.DateTime.Now.ToString("yyyy-MM-dd");

                if (WaiverDate >= DateTime.Parse("1/" + DropDownList1.Text + "/" + DropDownList2.Text))
                {
                    Dt.Rows.Add("Rental", WaiverUnit == 1 || WaiverUnit == 3 ? "0" : GrvBilling.SelectedDataKey["Amount"].ToString(), false);
                    Dt.Rows.Add("Service Charge", WaiverUnit == 2 || WaiverUnit == 3 ? "0" : GrvBilling.SelectedDataKey["ServiceCharge"].ToString(), false);
                }
                else
                {
                    Dt.Rows.Add("Rental", GrvBilling.SelectedDataKey["Amount"].ToString(), false);
                    Dt.Rows.Add("Service Charge", GrvBilling.SelectedDataKey["ServiceCharge"].ToString(), false);
                }
                
                Dt.Rows.Add("Electric", 1, false);
                Dt.Rows.Add("", 0, false);
                Dt.Rows.Add("", 0, false);
                Dt.Rows.Add("", 0, false);
            }
            else
            {
                Session["InsertFlag"] = false;

                if (GrvBilling.SelectedDataKey["BillDate"].ToString()=="")
                {
                    TxtBillDate.Text = System.DateTime.Now.ToString("yyyy-MM-dd");
                    TxtElecBillDate.Text = System.DateTime.Now.ToString("yyyy-MM-dd");
                }
                else
                {
                    TxtBillDate.Text = DateTime.Parse(GrvBilling.SelectedDataKey["BillDate"].ToString()).ToString("yyyy-MM-dd");

                    if (GrvBilling.SelectedDataKey["ElecBillDate"].ToString() !="")
                        TxtElecBillDate.Text = DateTime.Parse(GrvBilling.SelectedDataKey["ElecBillDate"].ToString()).ToString("yyyy-MM-dd");
                    else
                        TxtElecBillDate.Text = System.DateTime.Now.ToString("yyyy-MM-dd");
                }

                foreach (var Bill in BillingTransaction.ToString().Split(';'))
                {
                    Dt.Rows.Add(Bill.Split('^'));
                }

                for (var i = 0; i < 6 - BillingTransaction.ToString().Split(';').Count(); i++)
                {
                    Dt.Rows.Add("", 0, 0);
                }
            }

            Session["SelectedId"]        = GrvBilling.SelectedDataKey["Id"];
            Session["SelectedPaymentId"] = GrvBilling.SelectedDataKey["PaymentId"];
            Session["SelectedGridViewIndex"]  = ((DataListItem)((Control)sender).Parent).ItemIndex;
            GrvIssueBill.DataSource      = Dt;
            GrvIssueBill.DataBind();
        }


        LblCustomer.Text = ((Label)GrvBilling.SelectedRow.FindControl("LblCustomer")).Text;
        LblBill.Text = LabelBilling.Text;
        
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#IssueBillDialog').modal('show');</script>", false);

    }
    

    protected void BtnIssueBillSave_Click(object sender, EventArgs e)
    {
        var BillContent = new List<string>();
        var TotalAmt = 0.0;
        var TotalGst = 0.0;
        

        foreach (GridViewRow Row in GrvIssueBill.Rows)
        {
            var TxtItem   = (TextBox)Row.FindControl("TxtItem");
            var TxtAmount = (TextBox)Row.FindControl("TxtAmount");
            var ChkGst    = (CheckBox)Row.FindControl("ChkGst");
            if (TxtItem.Text != "")
            {
                TotalAmt += Math.Round(double.Parse(TxtAmount.Text),2);

                if (ChkGst.Checked)
                {
                    TotalGst += Math.Round((double.Parse(TxtAmount.Text) * 0.06),2);
                }

                BillContent.Add(string.Format("{0}^{1}^{2}", TxtItem.Text, TxtAmount.Text, ChkGst.Checked));
            }
        }

        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = Session["ConnectionString"].ToString();
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                //if (GrvBilling.SelectedDataKey["BillingTransaction"].ToString() == "")
                if ((bool)Session["InsertFlag"])
                {
                    Cm.CommandText = string.Format(@"INSERT INTO PAYMENT (TenancyId, BillingTransaction, TotalBill, Status, BillMonth, BillYear, CreatedBy, CreatedDateTime, BillDate, ElecBillDate) 
                                             VALUES({0}, '{1}', {2}, '{3}', {4}, {5}, '{6}', '{7}', '{8}', '{9}')",
                                                 Session["SelectedId"],
                                                 string.Join(";", BillContent.ToArray()),
                                                 TotalAmt + TotalGst,
                                                 "UNPAID",
                                                 DropDownList1.Text,
                                                 DropDownList2.Text,
                                                 User.Identity.Name,
                                                 DateTime.Now.ToString("dd/MMM/yy HH:mm"), 
                                                 TxtBillDate.Text,
                                                 TxtElecBillDate.Text);

                    Session["InsertFlag"] = false;
                    
                }
                else
                {
                    Cm.CommandText = string.Format(@"UPDATE PAYMENT SET BillDate='{4}', ElecBillDate='{5}', BillingTransaction='{0}', CreatedDateTime='{1}', TotalBill={2}, 
                                                    Status=CASE WHEN TotalPaid is Null Or {2} >= Round(TotalPaid,2) THEN 'UNPAID' ELSE 'PAID' END WHERE Id={3}",
                                                string.Join(";", BillContent.ToArray()),
                                                DateTime.Now.ToString("dd/MMM/yy HH:mm"),
                                                TotalAmt+TotalGst,
                                                Session["SelectedPaymentId"],
                                                TxtBillDate.Text,
                                                TxtElecBillDate.Text);

                    AuditHelper.Log("Billing", "Edit", Session["SelectedPaymentId"].ToString(), GetAuditDescription());
                }
                Cm.ExecuteNonQuery();

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#IssueBillDialog').modal('hide');</script>", false);
            }
        }

        ((GridView)DataList1.Items[(int)Session["SelectedGridViewIndex"]].FindControl("GrvBilling")).DataBind();
        CalculateTotalBilled();

        
    }

    private string GetAuditDescription()
    {
        var result = "";

        if (Session["SelectedGridViewIndex"] != null)
        {

            var Building = ((Label)DataList1.Items[(int)Session["SelectedGridViewIndex"]].FindControl("lblBuildingOrArea")).Text;
            var Grv      = (GridView)DataList1.Items[(int)Session["SelectedGridViewIndex"]].FindControl("GrvBilling");

            var Customer = ((Label)Grv.SelectedRow.FindControl("LblCustomer")).Text;
            var Lot      = ((Label)Grv.SelectedRow.FindControl("LblLot")).Text;

            result = string.Format("{0} / {1} ({2})", Customer, Building, Lot);
        }

        return result;
    }

    //protected void GrvBilling_RowCommand(object sender, GridViewCommandEventArgs e)
    //{
    //    var RowId = ((GridViewRow)((Button)e.CommandSource).NamingContainer).RowIndex;
    //    var BillingTransaction = GrvBilling.DataKeys[RowId]["BillingTransaction"];
    //    GrvBilling.SelectedIndex = RowId;
        
    //    using (var Dt = new System.Data.DataTable())
    //    {
    //        Dt.Columns.Add("ITEM");
    //        Dt.Columns.Add("AMOUNT", typeof(double));
    //        Dt.Columns.Add("GST", typeof(bool));

    //        if (BillingTransaction.ToString() == "")
    //        {
    //            Dt.Rows.Add("Rental", GrvBilling.Rows[RowId].Cells[2].Text, true);
    //            Dt.Rows.Add("Service Charge", GrvBilling.Rows[RowId].Cells[3].Text, true);
    //            Dt.Rows.Add("Electric", 0, true);
    //            Dt.Rows.Add("", 0, false);
    //            Dt.Rows.Add("", 0, false);
    //            Dt.Rows.Add("", 0, false);
    //        }
    //        else
    //        {
    //            foreach (var Bill in BillingTransaction.ToString().Split(';'))
    //            {
    //                Dt.Rows.Add(Bill.Split('^'));
    //            }

    //            for (var i=0; i< 6-BillingTransaction.ToString().Split(';').Count(); i++)
    //            {
    //                Dt.Rows.Add("", 0, 0);
    //            }
    //        }

    //        GrvIssueBill.DataSource = Dt;
    //        GrvIssueBill.DataBind();
    //    }


    //    LblCustomer.Text = ((Label)GrvBilling.Rows[RowId].FindControl("LblCustomer")).Text;
    //    LblBill.Text = LabelBilling.Text;

    //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#IssueBillDialog').modal('show');</script>", false);

    //}

    protected void GrvBilling_RowDataBound(object sender, GridViewRowEventArgs e)
    {
       
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            var CurrentRow = (System.Data.DataRowView)e.Row.DataItem;
            

            //------------------------------------------------------------------
            var Btn = (Button)e.Row.FindControl("BtnIssueEdit");

            if (CurrentRow["BillingTransaction"].ToString() == "")
            {
                Btn.Text = "Issue";
            }
            else
            {
                var BillToTable = "<table style='font-size:9pt; width:150px'>";

                foreach (var BillRow in CurrentRow["BillingTransaction"].ToString().Split(';'))
                {
                    var BillCol = BillRow.Split('^');
                    BillToTable += "<tr><td style='padding:2px'>" + BillCol[0] + "</td><td style='text-align:right'>" + (BillCol[2] == "True" ? (double.Parse(BillCol[1]) * 1.06).ToString("#,##0.00") : (double.Parse(BillCol[1])).ToString("#,##0.00")) + "</td></td>";
                }

                BillToTable += "</table>";

                ((Literal)e.Row.Cells[2].FindControl("Literal1")).Text = BillToTable;

                Btn.Text = "View";
                Btn.CssClass = "btn btn-default";
            }
            //------------------------------------------------------------------
        }
    }

    protected void GrvBilling_DataBound(object sender, EventArgs e)
    {
        var GrvBilling = (GridView)sender;
        var Total = 0.0;

        foreach (GridViewRow Row in GrvBilling.Rows)
        {
            var Bill = 0.0;
            double.TryParse(Row.Cells[3].Text, out Bill);
            Total += Bill;

        }

        if (GrvBilling.FooterRow != null)
        {
            GrvBilling.FooterRow.Cells[3].Text = Total.ToString("#,###,##0.00");
            GrvBilling.FooterRow.Cells[3].Font.Bold = true;
            //LabelTotalBill.Text = Total.ToString("#,###,##0.00");
        }
    }


   
}