<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Applications_Tenancies_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
	<script>
		$(document).ready(function () {
            		$("#TENANCY").addClass("active");
        	})
	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-sm-6">
            <img src="/Logo.jpg" style="width:30px; position:absolute; display:inline-block; top:20px; left:-30px" />
            <h2>TENANCY</h2>
        </div>
        <%if ((bool)Session["IsContribute"])
            { %>
        <div class="col-sm-6" style="text-align: right">
            <a href="/Tenancy/New.aspx" data-toggle="tooltip" title="Add New" class="btn btn-default"><span class="glyphicon glyphicon-file"></span></a>
        </div>
        <%} %>
    </div>
    <div class="row">
        <div class="col-sm-4">
            <p>Total Deposit: <span style="color: blue">RM<asp:Label ID="LabelTotalDeposit" runat="server" Text="0.00"></asp:Label></span></p>
        </div>
    </div>
    <br />
    <div class="row">
        <div class="col-sm-12">
            <asp:DataList ID="DataList1" Width="100%" runat="server" DataSourceID="SqlDataSource1">
                <ItemTemplate>
                    <asp:Label ID="LblBuildingOrArea" CssClass="h3" ForeColor="#706c98" runat="server" Text='<%#Eval("BuildingOrArea")%>'></asp:Label>

                    <asp:GridView ID="GridView1" runat="server" Font-Size="Small" GridLines="None" AutoGenerateColumns="False" CssClass="table" DataKeyNames="Id" DataSourceID="SqlDataSource2" ShowFooter="true">
                        <Columns>
							<asp:TemplateField HeaderText="NO">
										<ItemTemplate>
											<%# Container.DataItemIndex + 1 %>
										</ItemTemplate>
									</asp:TemplateField>
                            <asp:BoundField DataField="Customer" HeaderText="CUSTOMER" ItemStyle-Font-Size="Small" ItemStyle-Width="350px" />
                            <asp:BoundField DataField="Lot" HeaderText="LOT/SUITE" ItemStyle-Font-Size="Small" ItemStyle-Width="200px" />
                            <asp:TemplateField HeaderText="PERIOD">
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%#Eval("TenancyFrom","{0:dd/MMM-yyy}")%>'></asp:Label>
                                    -
                                    <asp:Label ID="Label2" runat="server" Text='<%#Eval("TenancyTo","{0:dd/MMM-yyy}")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Duration" HeaderText="DURATION" ItemStyle-Font-Size="Small" />
                            <asp:TemplateField HeaderText="EXPIRING">
                                <ItemTemplate>
									<asp:Label ID="Label1" runat="server" CssClass='<%# Eval("Expiry").ToString() != "" ? Color(int.Parse(Eval("Expiry").ToString())) : "" %>' Text='<%# Eval("Expiry") %>' data-toggle="tooltip" title="Months" Font-Size="12px"></asp:Label>
								</ItemTemplate>
							</asp:TemplateField>
                            <asp:BoundField DataField="TotalDeposit" HeaderText="TOTAL DEPOSIT" ItemStyle-Font-Bold="true" DataFormatString="{0:#,##0.00}" ItemStyle-Font-Size="Small" />
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" CssClass="btn btn-default" data-toggle="tooltip" title="View Details" runat="server" PostBackUrl='<%#Eval("Id","Detail.aspx?Id={0}") %>'><span class="glyphicon glyphicon-folder-open"></span></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            No Records Found.
                        </EmptyDataTemplate>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>" 
						SelectCommand="SELECT * FROM vTENANCY2 WHERE BUILDINGORAREA=@BUILDING AND TERMINATE=0 ORDER BY Expiry">
                        <SelectParameters>
                            <asp:ControlParameter Name="BUILDING" ControlID="LblBuildingOrArea" PropertyName="Text" />
                        </SelectParameters>
                    </asp:SqlDataSource>


                </ItemTemplate>
            </asp:DataList>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>" 
				SelectCommand="SELECT DISTINCT [BuildingOrArea] FROM vTENANCY2"></asp:SqlDataSource>
        </div>

    </div>

</asp:Content>
