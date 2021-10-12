<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Log.aspx.cs" Inherits="_AuditLog" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/dt-1.10.21/datatables.min.css" />

	<script type="text/javascript" src="https://cdn.datatables.net/v/dt/dt-1.10.21/datatables.min.js"></script>

	<style>
		.switch {
			position: relative;
			display: inline-block;
			width: 60px;
			height: 24px;
		}

			.switch input {
				display: none;
			}

		.slider {
			position: absolute;
			cursor: pointer;
			top: 0;
			left: 0;
			right: 0;
			bottom: 0;
			background-color: #ccc;
			-webkit-transition: .4s;
			transition: .4s;
		}

			.slider:before {
				position: absolute;
				content: "";
				height: 20px;
				width: 20px;
				left: 4px;
				bottom: 2px;
				background-color: white;
				-webkit-transition: .4s;
				transition: .4s;
			}

		input:checked + .slider {
			background-color: #2196F3;
		}

		input:focus + .slider {
			box-shadow: 0 0 1px #2196F3;
		}

		input:checked + .slider:before {
			-webkit-transform: translateX(26px);
			-ms-transform: translateX(26px);
			transform: translateX(26px);
		}

		/* Rounded sliders */
		.slider.round {
			border-radius: 34px;
		}

			.slider.round:before {
				border-radius: 50%;
			}

		.VerticallyCentred {
			vertical-align: middle !important;
		}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<asp:UpdatePanel ID="UpdatePanel2" runat="server">
		<ContentTemplate>

			<div class="row">
				<div class="col-sm-6">
					<h2>AUDIT LOG</h2>
				</div>
				<div class="col-sm-6" style="text-align: right">
					<%--<asp:DropDownList ID="DropDownListMonth" runat="server" AutoPostBack="true">
                        <asp:ListItem Value="1">Jan</asp:ListItem>
                        <asp:ListItem Value="2">Feb</asp:ListItem>
                        <asp:ListItem Value="3">Mar</asp:ListItem>
                        <asp:ListItem Value="4">Apr</asp:ListItem>
                        <asp:ListItem Value="5">May</asp:ListItem>
                        <asp:ListItem Value="6">Jun</asp:ListItem>
                        <asp:ListItem Value="7">Jul</asp:ListItem>
                        <asp:ListItem Value="8">Aug</asp:ListItem>
                        <asp:ListItem Value="9">Sep</asp:ListItem>
                        <asp:ListItem Value="10">Oct</asp:ListItem>
                        <asp:ListItem Value="11">Nov</asp:ListItem>
                        <asp:ListItem Value="12">Dec</asp:ListItem>
                    </asp:DropDownList>

                    <asp:TextBox ID="TxtYear" runat="server" TextMode="Number" ></asp:TextBox>--%>
					<div class="form-inline">
						<asp:TextBox ID="TextBoxStartDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
						To
                        <asp:TextBox ID="TextBoxEndDate" CssClass="form-control" runat="server" TextMode="Date"></asp:TextBox>
						<asp:LinkButton ID="LinkButtonRefresh" runat="server" CssClass="btn btn-default" OnClick="LinkButtonRefresh_Click"><span class="glyphicon glyphicon-refresh"></span></asp:LinkButton>
					</div>

				</div>
			</div>
			<br />
			<br />
			<div class="row">
				<div class="col-sm-12">
					<asp:GridView ID="GridView1" runat="server" GridLines="None" CssClass="table table-hover small" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" OnRowDataBound="GridView1_RowDataBound">
						
						<Columns>
							<asp:BoundField DataField="Module" HeaderText="MODULE" />
							<asp:BoundField DataField="Action" HeaderText="ACTION" />
							<asp:BoundField DataField="User" HeaderText="USER" />
							<asp:BoundField DataField="Description" HeaderText="TENANT / PROPERTY" ItemStyle-Width="400px" />
							<asp:BoundField DataField="LogDateTime" HeaderText="DATE TIME" DataFormatString="{0:ddd, dd MMM yyyy HH:mm}" />
							<asp:BoundField DataField="RecordId" HeaderText="ID" ItemStyle-ForeColor="GrayText" />

						</Columns>
						<EmptyDataTemplate>
							No User(s) Specified.
						</EmptyDataTemplate>
					</asp:GridView>
					<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
						SelectCommand="SELECT * FROM [AuditLog2] WHERE LogDatetime between @StartDate and @EndDate Order By LogDateTime Desc">
						<SelectParameters>
							<asp:ControlParameter ControlID="TextBoxStartDate" PropertyName="Text" Name="StartDate" />
							<asp:ControlParameter ControlID="TextBoxEndDate" PropertyName="Text" Name="EndDate" />
						</SelectParameters>
					</asp:SqlDataSource>

				</div>
			</div>
			<br>
			<br>
			<br>
		</ContentTemplate>
	</asp:UpdatePanel>

	<script>
		$(document).ready(function () {
			$('#ContentPlaceHolder1_GridView1').DataTable();
		});
	</script>

</asp:Content>

