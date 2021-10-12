using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using System.Web;

/// <summary>
/// Summary description for AuditHelper
/// </summary>
public static class NotifyHelper
{
    public static void Notify(string module, string Id)
    {
        Task t = Task.Run(async () =>
        {

            var to = "";

            try
            {
                var server = System.Configuration.ConfigurationManager.AppSettings["SmtpServer"];
                var port = int.Parse(System.Configuration.ConfigurationManager.AppSettings["SmtpPort"]);
                var user = System.Configuration.ConfigurationManager.AppSettings["SmtpUser"];
                var password = System.Configuration.ConfigurationManager.AppSettings["SmtpPassword"];
                var ssl = System.Configuration.ConfigurationManager.AppSettings["SmtpSSL"] == "1" ? true : false;
                var from = System.Configuration.ConfigurationManager.AppSettings["SmtpFrom"];

                System.Data.DataRow[] result = DBHelper.QueryAsDataTable("select email from security where (IsNotify=1 or IsAdmin=1) and module='" + module + "'").Select();
                //to = string.Join(",", result.Select(x => x[0].ToString()).Distinct().Take(10).ToArray());
                to = string.Join(",", result.Select(x => x[0].ToString()).Distinct().ToArray());

                var msg = new MailMessage(from,to);
                msg.Subject = "Tenancy Notification";
                msg.Body = string.Format("A tenancy has been created or modified. Click <a href='https://etenancy.khtp.com.my/Tenancy/Detail.aspx?Id={0}'>here</a> to view.", Id);
                msg.IsBodyHtml = true;

            
                using (var client = new System.Net.Mail.SmtpClient(server)
                {
                    Port = port,
                    Credentials = new NetworkCredential(user, password),
                    EnableSsl = ssl,
                })
                {
                    await client.SendMailAsync(msg);
                }
            }
            catch (Exception Ex)
            {
                using (var File = new System.IO.StreamWriter("C:/Temp/NotifyHelperErrorLog.txt",true))
                {
                    File.WriteLine(string.Format("{0}\t{1}\t{2}", DateTime.Now.ToString("f"), Ex.Message, to));
                }
            }
        });
    }
           

}