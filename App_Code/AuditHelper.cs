using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for AuditHelper
/// </summary>
public static class AuditHelper
{
    public static void Log(string Module, string Action, string RecordId="", string Description = "")
    {
        using (var Cn = new System.Data.SqlClient.SqlConnection())
        {
            Cn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["AliijarConnectionString"].ConnectionString;
            Cn.Open();

            using (var Cm = Cn.CreateCommand())
            {
                var SqlStatement = string.Format("INSERT INTO AUDITLOG2 (MODULE, ACTION, RECORDID, DESCRIPTION, [USER],LOGDATETIME) VALUES('{0}','{1}','{2}','{3}','{4}','{5}')",
                                                  Module,
                                                  Action,
                                                  RecordId,
                                                  Description,
                                                  System.Web.HttpContext.Current.User.Identity.Name,
                                                  DateTime.Now.ToString("dd/MMM/yy HH:mm"));
                Cm.CommandText = SqlStatement;
                Cm.ExecuteNonQuery();
            }
        }
    }
}