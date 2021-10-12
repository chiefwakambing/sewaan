using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.DataVisualization.Charting;
using System.Web.UI.WebControls;

public partial class PAYMENT_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
			/*
            for (int i = 0; i < 5; i++)
            {
                DropDownList2.Items.Add(DateTime.Now.AddYears(0 - i).Year.ToString());
            }

            DropDownList1.Text = DateTime.Now.AddMonths(-1).Month.ToString();
            DropDownList2.Text = DateTime.Now.AddMonths(-1).Year.ToString();
			*/
			for (int i = -1; i < 5; i++) //modified code to add next year & display current month
            {
                DropDownList2.Items.Add(DateTime.Now.AddYears(0 - i).Year.ToString());
            }
            
            DropDownList1.Text = DateTime.Now.Month.ToString();
            DropDownList2.Text = DateTime.Now.Year.ToString();
        }

        LabelBilling.Text = DropDownList1.Text + " / " + DropDownList2.Text;
        CalculateAgingSummary();
    }

    protected void GrvPayment_SelectedIndexChanged(object sender, EventArgs e)
    {
        var GrvPayment = (GridView)sender;

        using (var Dt = new System.Data.DataTable())
        {
            Dt.Columns.Add("ITEM");
            Dt.Columns.Add("AMOUNT", typeof(double));
            Dt.Columns.Add("GST", typeof(double));

            var TotalAmt = 0.0;
            var TotalGst = 0.0;

            foreach (var Bill in GrvPayment.SelectedDataKey["BillingTransaction"].ToString().Split(';'))
            {
                var BillCol = Bill.Split('^');
                BillCol[2] = BillCol[2] == "True" ? Math.Round((double.Parse(BillCol[1]) * 0.06),2).ToString("0.00") : "0";
                Dt.Rows.Add(BillCol);

                TotalAmt += double.Parse(BillCol[1]);
                TotalGst += double.Parse(BillCol[2]);
            }
            Dt.Rows.Add(new object[] { "TOTAL", TotalAmt, TotalGst });
            GrvBill.DataSource = Dt;
            GrvBill.DataBind();

            GrvBill.FooterRow.Cells[0].HorizontalAlign = HorizontalAlign.Left;
            GrvBill.FooterRow.Cells[0].Text = "GRAND TOTAL + GST";
            GrvBill.FooterRow.Cells[1].Text = (TotalAmt + TotalGst).ToString("#,###,##0.00");
            //GrvBill.FooterRow.Cells[2].Text = TotalGst.ToString("#,###,##0.00");
        }

        //------------------------------------------------------------------------------------------------

        var PaymentTransaction = ((GridView)sender).SelectedDataKey["PaymentTransaction"];

        using (var Dt = new System.Data.DataTable())
        {
            Dt.Columns.Add("PAYMENTDATE", typeof(DateTime));
            Dt.Columns.Add("AMOUNT", typeof(double));
            Dt.Columns.Add("REMARK");

            if (PaymentTransaction.ToString() == "")
            {
                Dt.Rows.Add(new string[] { DateTime.Now.ToString("yyyy-MM-dd"), "0.00", "" });
            }
            else
            {
                foreach (var Bill in PaymentTransaction.ToString().Split(';'))
                {
                    Dt.Rows.Add(Bill.Split('^'));
                }

                Dt.Rows.Add(new string[] { DateTime.Now.ToString("yyyy-MM-dd"), "0.00", "" });
            }

            GrvMakePayment.DataSource = Dt;
            GrvMakePayment.DataBind();
        }


        LblCustomer.Text =((Label)((GridView)sender).SelectedRow.FindControl("LblCustomer")).Text;
        LblPayment.Text = LabelBilling.Text;
        LblId.Text = ((GridView)sender).SelectedDataKey["Id"].ToString();

        //var LastControl = GrvMakePayment.Rows[GrvMakePayment.Rows.Count - 1].FindControl("TxtPaymentDate").ClientID;
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#MakePaymentDialog').modal('show')</script>", false);
        Session["SelectedGridViewIndex"] = ((DataListItem)GrvPayment.Parent).ItemIndex;
    }

    //protected void GrvPayment_RowCommand(object sender, GridViewCommandEventArgs e)
    //{
    //    if (e.CommandName == "BillPaymentDetail")
    //    {
    //        using (var Dt = new System.Data.DataTable())
    //        {
    //            Dt.Columns.Add("ITEM");
    //            Dt.Columns.Add("AMOUNT", typeof(double));
    //            Dt.Columns.Add("GST", typeof(double));

    //            var TotalAmt = 0.0;
    //            var TotalGst = 0.0;

    //            foreach (var Bill in e.CommandArgument.ToString().Split(';'))
    //            {
    //                var BillCol = Bill.Split('^');
    //                BillCol[2] = BillCol[2] == "True" ? (double.Parse(BillCol[1]) * 0.06).ToString() : "0";
    //                Dt.Rows.Add(BillCol);

    //                TotalAmt += double.Parse(BillCol[1]);
    //                TotalGst += double.Parse(BillCol[2]);
    //            }

    //            GrvBill.DataSource = Dt;
    //            GrvBill.DataBind();

    //            GrvBill.FooterRow.Cells[0].Text = "TOTAL";
    //            GrvBill.FooterRow.Cells[1].Text = TotalAmt.ToString("#,###,##0.00");
    //            GrvBill.FooterRow.Cells[2].Text = TotalGst.ToString("#,###,##0.00");
    //        }

            
    //        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#BillOrPaymentDialog').modal('show');</script>", false);
    //    }
    //}

    protected void BtnMakePaymentSave_Click(object sender, EventArgs e)
    {
        var PaymentContent = new List<string>();
        var TotalAmt = 0.0;
        
        foreach (GridViewRow Row in GrvMakePayment.Rows)
        {
            var TxtPayDateTxtPaymentDate = (TextBox)Row.FindControl("TxtPaymentDate");
            var TxtAmount = (TextBox)Row.FindControl("TxtAmount");
            var TxtRemark = (TextBox)Row.FindControl("TxtRemark");

            if (TxtAmount.Text != "")
            {
                var Amt = double.Parse(TxtAmount.Text);
                
                if (Amt > 0)
                {
                    TotalAmt += Amt;
                    PaymentContent.Add(string.Format("{0}^{1}^{2}", TxtPayDateTxtPaymentDate.Text, TxtAmount.Text, TxtRemark.Text));
                }
            }
        }

        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = Session["ConnectionString"].ToString();
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
               
                Cm.CommandText = string.Format(@"UPDATE PAYMENT SET PaymentTransaction='{0}', TotalPaid={1}, 
                                                Status=CASE WHEN {1} >= Round(TotalBill,2) THEN 'PAID' ELSE 'UNPAID' END WHERE Id={2}",
                                                string.Join(";", PaymentContent.ToArray()),
                                                TotalAmt.ToString("0.00"),
                                                LblId.Text);
               
                Cm.ExecuteNonQuery();

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#MakePaymentDialog').modal('hide');</script>", false);
            }
        }

        AuditHelper.Log("Payment", "Edit", LblId.Text, GetAuditDescription());

        ((GridView)DataList1.Items[(int)Session["SelectedGridViewIndex"]].FindControl("GrvPayment")).DataBind();
        GrvSummary.DataBind();
        CalculateAgingSummary();
    }


    private string GetAuditDescription()
    {
        var result = "";

        if (Session["SelectedGridViewIndex"] != null)
        {

            var Building = ((Label)DataList1.Items[(int)Session["SelectedGridViewIndex"]].FindControl("lblBuildingOrArea")).Text;
            var Grv = (GridView)DataList1.Items[(int)Session["SelectedGridViewIndex"]].FindControl("GrvPayment");

            var Customer = ((Label)Grv.SelectedRow.FindControl("LblCustomer")).Text;
            var Lot = ((Label)Grv.SelectedRow.FindControl("LblLot")).Text;

            result = string.Format("{0} / {1} ({2})", Customer, Building, Lot);
        }

        return result;
    }

    protected void GrvPayment_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType==DataControlRowType.DataRow)
        {
            var Row = (System.Data.DataRowView)e.Row.DataItem;

            if (Row["TOTALPAID"].ToString() != "")
            {
                var TotalBill = double.Parse(Row["TOTALBILL"].ToString());
                var TotalPaid = double.Parse(Row["TOTALPAID"].ToString());
                var Percent = (TotalPaid / TotalBill) * 100;

                e.Row.Cells[2].Text = e.Row.Cells[2].Text + " <br><span class='small strong'>(" + Percent.ToString("0") + "%)</span>" ;
            }


            if (Row["PaymentTransaction"].ToString() != "")
            {
                var Transact = Row["PaymentTransaction"].ToString().Split(';').Last();
                ((Label)e.Row.Cells[4].FindControl("LblPaymentDate")).Text = DateTime.Parse(Transact.Split('^').First()).ToString("dd/MMM/yy");
            }


            if (Row["STATUS"].ToString() == "UNPAID")
            {
                e.Row.Cells[3].Text = "<span style='padding:3px' class='label label-danger'>UNPAID&nbsp;</span>";
            }
            else
            {
                e.Row.Cells[3].Text = "<span style='padding:3px; display:block; width:50px' class='label label-success'>PAID&nbsp;</span>";
            }

            

        }
    }

    protected void GrvSummary_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        var Rw = (System.Data.DataRowView)e.Row.DataItem;

        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            if (Rw["TotalPaid"].ToString() != "" && Rw["TotalBill"].ToString() != "")
            {
                var D = Double.Parse(Rw["TotalPaid"].ToString());
                var E = Double.Parse(Rw["TotalBill"].ToString());
                var Cht02 = (Chart)e.Row.Cells[2].FindControl("ChartPaid");
                Cht02.Series[0].Points.AddY(D);
                Cht02.Series[0].Points.AddY(E - D);
                Cht02.Series[0].Points[0].Color = System.Drawing.ColorTranslator.FromHtml("#5cb85c");
                Cht02.Series[0].Points[1].Color = System.Drawing.ColorTranslator.FromHtml("#d9534f");
            }
        }
    }

    private void CalculateAgingSummary()
    {
        using (var Cn = new System.Data.SqlClient.SqlConnection(Sql01.ConnectionString))
        {
            Cn.Open();
            using (var Cm = Cn.CreateCommand())
            {
                Cm.CommandText = string.Format("SELECT TotalBill, PaymentTransaction, BillDate FROM PAYMENT WHERE BILLMONTH={0} AND BILLYEAR={1}", DropDownList1.Text, DropDownList2.Text);
                using (var Dr = Cm.ExecuteReader())
                {
                    using (var Dt = new System.Data.DataTable())
                    {
                        Dt.Columns.Add("30");
                        Dt.Columns.Add("60");
                        Dt.Columns.Add("90");
                        Dt.Columns.Add("120");

                        Dt.Rows.Add(new string[] { "0.0", "0.0", "0.0", "0.0" });
                        Dt.Rows.Add(new string[] { "0%", "0%", "0%", "0%" });

                        var TotalBill = 0.0;
                        var Total30 = 0.0;
                        var Total60 = 0.0;
                        var Total90 = 0.0;
                        var Total120 = 0.0;

                        while (Dr.Read())
                        {

                            TotalBill += double.Parse(Dr.GetValue(0).ToString());
                            var BilledDate = DateTime.Parse(Dr.GetValue(2).ToString());

                            if (Dr.GetValue(1).ToString() != "")
                            {
                                var Transaction = Dr.GetValue(1).ToString().Split(';');
                                foreach (var T in Transaction)
                                {
                                    var Col = T.Split('^');
                                    if (DateTime.Parse(Col[0]) <= BilledDate.AddDays(30))
                                    {
                                        //Dt.Rows[0][0] = (double.Parse(Dt.Rows[0][0].ToString()) + double.Parse(Col[1])).ToString("#,###,##0.00");
                                        Total30 += double.Parse(Col[1]);
                                    }

                                    else if (DateTime.Parse(Col[0]) <= BilledDate.AddDays(60))
                                    {
                                        //Dt.Rows[0][1] = (double.Parse(Dt.Rows[0][1].ToString()) + double.Parse(Col[1])).ToString("#,###,##0.00");
                                        Total60 += double.Parse(Col[1]);
                                    }

                                    else if (DateTime.Parse(Col[0]) <= BilledDate.AddDays(90))
                                    {
                                        //Dt.Rows[0][3] = (double.Parse(Dt.Rows[0][2].ToString()) + double.Parse(Col[1])).ToString("#,###,##0.00");
                                        Total90 += double.Parse(Col[1]);
                                    }
									else
                                    //else if (DateTime.Parse(Col[0]) <= BilledDate.AddDays(120))
                                    {
                                        //Dt.Rows[0][3] = (double.Parse(Dt.Rows[0][3].ToString()) + double.Parse(Col[1])).ToString("#,###,##0.00");
                                        Total120 += double.Parse(Col[1]);
                                    }

                                }
                            }
                        }

                        if (TotalBill != 0)
                        {
                            Dt.Rows[0][0] = Total30.ToString("#,###,##0.00");
                            Dt.Rows[0][1] = Total60.ToString("#,###,##0.00");
                            Dt.Rows[0][2] = Total90.ToString("#,###,##0.00");
                            Dt.Rows[0][3] = Total120.ToString("#,###,##0.00");

                            Dt.Rows[1][0] = (Total30 / TotalBill * 100).ToString("(0'%')");
                            Dt.Rows[1][1] = (Total60 / TotalBill * 100).ToString("(0'%')");
                            Dt.Rows[1][2] = (Total90 / TotalBill * 100).ToString("(0'%')");
                            Dt.Rows[1][3] = (Total120 / TotalBill * 100).ToString("(0'%')");
                        }
                        GrvAging.DataSource = Dt;
                        GrvAging.DataBind();
                        GrvAging.Rows[1].CssClass = "small";
                        GrvSummary.DataBind();
                    }
                }
            }

        }
    }



    protected void BtnOkay_Click(object sender, EventArgs e)
    {
        CalculateAgingSummary();
    }
}