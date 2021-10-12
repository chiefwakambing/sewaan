using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

public partial class UploadControl : System.Web.UI.UserControl
{
    public string TargetFolder
    {
        get;set;
    }

    protected void LinkButtonSave_Click(object sender, EventArgs e)
    {
        if (FileUpload1.HasFile)
        {
	    var F = Regex.Replace(FileUpload1.FileName.Trim(), "[^A-Za-z0-9_. ]+", "");
	    F = Regex.Replace(F, @"\s+", " ");

            var AbsolutePath = Server.MapPath("/Upload/" + TargetFolder + "/" + Request.QueryString["Id"]);
            FileUpload1.SaveAs(AbsolutePath + "/" + F);
            GetFiles();
        }

    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false)
        {
            var AbsolutePath = Server.MapPath("/Upload/" + TargetFolder + "/" + Request.QueryString["Id"]);

            if (System.IO.Directory.Exists(AbsolutePath) == false)
            {
                System.IO.Directory.CreateDirectory(AbsolutePath);
            }
        }

        GetFiles();
    }

    private void GetFiles()
    {
        var AbsolutePath = Server.MapPath("/Upload/" + TargetFolder + "/" + Request.QueryString["Id"]);

        if (System.IO.Directory.Exists(AbsolutePath) == true)
        {
            var Files = System.IO.Directory.GetFiles(AbsolutePath).ToList().Select(f => f.Split('\\').Last());
            GrvUploadedContent.DataSource = Files;
            GrvUploadedContent.DataBind();
        }
    }

    protected void GrvUploadedContent_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        var AbsolutePath = Server.MapPath("/Upload/" + TargetFolder + "/" + Request.QueryString["Id"]);

        var FileName = ((HyperLink)GrvUploadedContent.Rows[e.RowIndex].Cells[0].FindControl("HyperLink1")).Text;
        System.IO.File.Delete(AbsolutePath + "/" + FileName );
        GetFiles();
    }
}