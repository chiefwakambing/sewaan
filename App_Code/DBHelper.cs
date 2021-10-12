using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for AuditHelper
/// </summary>
public static class DBHelper
{
    public static System.Data.DataTable QueryAsDataTable(string sql)
    {
        var Dt = new System.Data.DataTable();

        using (var Da = new System.Data.SqlClient.SqlDataAdapter(sql, System.Configuration.ConfigurationManager.ConnectionStrings["AliijarConnectionString"].ConnectionString))
        {
            Da.Fill(Dt);
        }

        return Dt;
    }

    public static void Execute(string sql)
    {
        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["AliijarConnectionString"].ConnectionString;
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                Cm.CommandText = sql;
                Cm.ExecuteNonQuery();
            }
        }
    }
}