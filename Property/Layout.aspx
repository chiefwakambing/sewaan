<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Layout.aspx.cs" Inherits="Applications_Properties_Layout" %>

<%@ Register Src="~/UploadControl.ascx" TagPrefix="uc1" TagName="UploadControl" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
	<script>
		$(document).ready(function () {
			$("#PROPERTY").addClass("active");
		})
	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<%--    <asp:FormView ID="FormView1" runat="server" DataSourceID="SqlDataSource1" Width="100%">
        <ItemTemplate>--%>
	<asp:UpdatePanel ID="UpdatePanel1" runat="server">
		<ContentTemplate>
			<div class="row">
				<div class="col-sm-6">
					<p>Layout <span class="glyphicon glyphicon-chevron-right"></span></p>
					<h1 style="color: #706c98">
						<%=Request.QueryString["Id"] %>
					</h1>
				</div>
				<div class="col-sm-6" style="text-align: right">
				</div>
			</div>
			<%
				if (System.IO.Directory.Exists(Server.MapPath("/Upload/Layout/" + Request.QueryString["Id"])))
				{
					foreach (var i in System.IO.Directory.GetFiles(Server.MapPath("/Upload/Layout/" + Request.QueryString["Id"])))
					{
			%>
			<div class="row" style="border: 1px solid #808080; margin-bottom: 3px">
				<div class="col-sm-12">
					<img src="/Upload/Layout/<%=Request.QueryString["Id"] %>/<%=i.Split('\\').Last()%>" class="img-responsive" />
					
				</div>
			</div>
			<%
					}
				}
			%>
						<br />
			<br>
			<%  if ((bool)Session["IsContribute"] == true)
				{ %>
			<div class="row">
				<div class="col-sm-12">
					<uc1:UploadControl runat="server" ID="UploadControl" TargetFolder="Layout" />
				</div>
			</div>
			<% }%>
			<br />

		</ContentTemplate>
	</asp:UpdatePanel>


	<br />
	<br />
	<br />

</asp:Content>

