using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.DataVisualization.Charting;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{

    protected override void OnPreInit(EventArgs e)
    {
        base.OnPreInit(e);
    }

    

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //for (int i = 0; i < 5; i++)
            //{
            //    DropDownList2.Items.Add(DateTime.Now.AddYears(0 - i).Year.ToString());
            //}

            //DropDownList2.Text = DateTime.Now.AddMonths(-1).Year.ToString();   

            var FirstDayOfThisMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            TextBoxEndDate.Text = FirstDayOfThisMonth.AddMonths(1).AddDays(-1).ToString("yyyy-MM-dd");
            TextBoxStartDate.Text = FirstDayOfThisMonth.ToString("yyyy-MM-dd");
        }
        
    }

    protected void GrvSummary_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        var Rw = (System.Data.DataRowView)e.Row.DataItem;

        if (e.Row.RowType==DataControlRowType.DataRow)
        {
            var A = Double.Parse(Rw["OccupancyCount"].ToString());
            var B = Double.Parse(Rw["PROPERTYCOUNT"].ToString());
            //var C = A / B * 100;
            var QSqft = Double.Parse(Rw["OccupancySquareFeet"].ToString());
            var TSqft = Double.Parse(Rw["TotalSquareFeet"].ToString());

            var Lbl01 = (Label)e.Row.Cells[6].FindControl("LabelOccupancy");
            Lbl01.Text = ((QSqft / TSqft) * 100).ToString("0'%'");

            var Cht01 = (Chart) e.Row.Cells[6].FindControl("ChartOccupancy");
            Cht01.Series[0].Points.AddY(QSqft);
            Cht01.Series[0].Points.AddY(TSqft-QSqft);
            //if (e.Row.RowIndex % 2 == 1) Cht01.ChartAreas[0].BackColor = System.Drawing.ColorTranslator.FromHtml("#f9f9f9");

            if (Rw["TotalPaid"].ToString() != "" && Rw["TotalBill"].ToString() != "")
            {
                var D = Double.Parse(Rw["TotalPaid"].ToString());
                var E = Double.Parse(Rw["TotalBill"].ToString());
                var Cht02 = (Chart)e.Row.Cells[3].FindControl("ChartPaid");
                Cht02.Series[0].Points.AddY(D);
                Cht02.Series[0].Points.AddY(E - D);

                //if (e.Row.RowIndex % 2 == 1) Cht02.ChartAreas[0].BackColor = System.Drawing.ColorTranslator.FromHtml("#ccc");
            }

            
        }
    }

    protected void GrvAnnualSummary_RowDataBound(object sender, GridViewRowEventArgs e)
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
                     
            }
        }
    }

    protected void CalculateAgingSummary(string Month)
    {
        var Year = DateTime.Now.Year;
        using (var Cn = new System.Data.SqlClient.SqlConnection(Sql01.ConnectionString))
        {
            Cn.Open();
            using (var Cm = Cn.CreateCommand())
            {
                Cm.CommandText = string.Format("SELECT TotalBill, PaymentTransaction, BillDate FROM PAYMENT WHERE BILLYEAR={0} AND BILLMONTH={1}", Year, Month);
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
                                        //Dt.Rows[0][1] =( double.Parse(Dt.Rows[0][1].ToString()) + double.Parse(Col[1])).ToString("#,###,##0.00");
                                        Total60 += double.Parse(Col[1]);
                                    }

                                    else if (DateTime.Parse(Col[0]) <= BilledDate.AddDays(90))
                                    {
                                        //Dt.Rows[0][3] = (double.Parse(Dt.Rows[0][2].ToString()) + double.Parse(Col[1])).ToString("#,###,##0.00");
                                        Total90 += double.Parse(Col[1]);
                                    }

                                    else if (DateTime.Parse(Col[0]) <= BilledDate.AddDays(120))
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
                        var Grv =  (GridView) Master.FindControl("ContentPlaceHolder1").FindControl("GrvAging" + Month);
                        var Lbl = (Label)Master.FindControl("ContentPlaceHolder1").FindControl("LblAging" + Month);

                        Grv.DataSource = Dt;
                        Grv.DataBind();

                        var _A = Math.Round((Total30 / TotalBill * 100),0);
                        var _B = Math.Round((Total60 / TotalBill * 100), 0);
                        var _C = Math.Round((Total90 / TotalBill * 100), 0);
                        var _D = Math.Round((Total120 / TotalBill * 100), 0);
                        var _T = _A + _B + _C + _D;

                        Lbl.Text = double.IsNaN(_T) ? "0%" : _T.ToString("(0'%')");


                    }
                }
            }

        }
    }


    protected void CalculateAgingSummary()
    {
        using (var Cn = new System.Data.SqlClient.SqlConnection(Sql01.ConnectionString))
        {
            Cn.Open();
            using (var Cm = Cn.CreateCommand())
            {
                //Cm.CommandText = string.Format("SELECT TotalBill, PaymentTransaction, BillDate FROM PAYMENT WHERE BILLYEAR={0} AND BILLMONTH={1}", DropDownList2.Text, Month);
                Cm.CommandText = string.Format("SELECT TotalBill, PaymentTransaction, BillDate FROM PAYMENT WHERE BILLDATE BETWEEN '{0}' AND '{1}'", TextBoxStartDate.Text, TextBoxEndDate.Text);
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
                                        //Dt.Rows[0][1] =( double.Parse(Dt.Rows[0][1].ToString()) + double.Parse(Col[1])).ToString("#,###,##0.00");
                                        Total60 += double.Parse(Col[1]);
                                    }

                                    else if (DateTime.Parse(Col[0]) <= BilledDate.AddDays(90))
                                    {
                                        //Dt.Rows[0][3] = (double.Parse(Dt.Rows[0][2].ToString()) + double.Parse(Col[1])).ToString("#,###,##0.00");
                                        Total90 += double.Parse(Col[1]);
                                    }

                                    else if (DateTime.Parse(Col[0]) <= BilledDate.AddDays(120))
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
                        //var Grv =  (GridView) Master.FindControl("ContentPlaceHolder1").FindControl("GrvAging" + Month);
                        //Grv.DataSource = Dt;
                        //Grv.DataBind();
                        GrvAging.DataSource = Dt;
                        GrvAging.DataBind();
                        //System.Threading.Thread.Sleep(5000);
                    }
                }
            }

        }
    }

    protected void GrvSummary_DataBound(object sender, EventArgs e)
    {

        for (int M = 1; M <= 12; M++)
        {
            CalculateAgingSummary(M.ToString());
        }

        CalculateAgingSummary();
    }

    protected void LinkButtonRefresh_Click(object sender, EventArgs e)
    {

    }

    protected void SqlDataSource1_DataBinding(object sender, EventArgs e)
    {
        
    }



    protected void GridViewSqFt_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        var Rw = (System.Data.DataRowView)e.Row.DataItem;

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (Rw["OccupancySquareFeet"].ToString() != "" && Rw["TotalSquareFeet"].ToString() != "")
            {
                var D = Double.Parse(Rw["OccupancySquareFeet"].ToString());
                var E = Double.Parse(Rw["TotalSquareFeet"].ToString());

                var Cht02 = (Chart)e.Row.Cells[2].FindControl("ChartSqFt");
                Cht02.Series[0].Points.AddY(D);
                Cht02.Series[0].Points.AddY(E - D);

                var Lbl = (Label)e.Row.Cells[2].FindControl("LabelSqFtPercent");
                Lbl.Text = ((D / E) * 100).ToString("00.0'%'");

            }
        }
    }
}