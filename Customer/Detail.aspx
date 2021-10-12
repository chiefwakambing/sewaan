<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Detail.aspx.cs" Inherits="Applications_Customers_Detail" %>

<%@ Register Src="~/UploadControl.ascx" TagPrefix="uc1" TagName="UploadControl" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script>
        $(document).ready(function () {
            $("#CUSTOMER").addClass("active");
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:FormView ID="FormView1" runat="server" DataSourceID="SqlDataSource1" Width="100%">
        <ItemTemplate>
            <div class="row">
                <div class="col-sm-10">
                    <p>CUSTOMER <span class="glyphicon glyphicon-chevron-right"></span></p>
                    <h1 style="color: #706c98">
                        <asp:Label ID="LabelOrganizationName" runat="server" Text='<%# Eval("OrganizationName") %>'></asp:Label></h1>
                    <asp:HyperLink ID="HyperLink2" runat="server" CssClass="small" Target="_blank" NavigateUrl='<%#Eval("Address","http://maps.google.com?q={0}") %>' data-toggle="tooltip" title="See in Google Maps"><%#Eval("Address")%></asp:HyperLink>
                </div>
                <div class="col-sm-2" style="text-align: right">
                    <asp:LinkButton ID="lnkEdit" runat="server" Enabled='<%#(bool)Session["IsContribute"] %>' data-toggle="tooltip" title="Edit" CssClass="btn btn-default" OnClick="lnkEdit_Click"><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>
                    <asp:LinkButton ID="lnkDelete" runat="server" Enabled='<%#(bool)Session["IsContribute"] %>' data-toggle="tooltip" title="Delete" CssClass="btn btn-default" OnClientClick="return confirm('Are you sure?');" OnClick="lnkDelete_Click"><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    <div style="border: 1px solid #d1d1d1; padding: 5px; border-radius: 5px">
                        <br />

                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <asp:GridView ID="GridView1" runat="server" GridLines="None" AutoGenerateColumns="False" CssClass="table" DataSourceID="SqlDataSource3">
                                    <Columns>
                                        <asp:BoundField DataField="Person" HeaderText="CONTACT PERSON" ItemStyle-Font-Size="Small" />
                                        <asp:BoundField DataField="Email" HeaderText="EMAIL(S)" ItemStyle-Font-Size="Small" />
                                        <asp:BoundField DataField="Phone01" HeaderText="PHONE 01" ItemStyle-Font-Size="Small" />
                                        <asp:BoundField DataField="Phone02" HeaderText="PHONE 02" ItemStyle-Font-Size="Small" />
                                        
                                    </Columns>
                                </asp:GridView>
                            </ContentTemplate>
                        </asp:UpdatePanel>

                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>" DeleteCommand="DELETE FROM [CUSTOMER] WHERE [Id] = @Id" InsertCommand="INSERT INTO [CUSTOMER] ([OrganizationName], [Address], [CreatedBy], [CreatedDateTime]) VALUES (@OrganizationName, @Address, @CreatedBy, @CreatedDateTime)" SelectCommand="SELECT * FROM [CUSTOMER] WHERE ([Id] = @Id)" UpdateCommand="UPDATE [CUSTOMER] SET [OrganizationName] = @OrganizationName, [Address] = @Address, [CreatedBy] = @CreatedBy, [CreatedDateTime] = @CreatedDateTime WHERE [Id] = @Id">
        <DeleteParameters>
            <asp:QueryStringParameter Name="Id" QueryStringField="Id" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="OrganizationName" Type="String" />
            <asp:Parameter Name="Address" Type="String" />
            <asp:Parameter Name="CreatedBy" Type="String" />
            <asp:Parameter Name="CreatedDateTime" Type="DateTime" />
        </InsertParameters>
        <SelectParameters>
            <asp:QueryStringParameter Name="Id" QueryStringField="Id" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="OrganizationName" Type="String" />
            <asp:Parameter Name="Address" Type="String" />
            <asp:Parameter Name="CreatedBy" Type="String" />
            <asp:Parameter Name="CreatedDateTime" Type="DateTime" />
            <asp:Parameter Name="Id" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>" SelectCommand="SELECT * FROM [Contact] WHERE ([CustomerId] = @Id)">
        <SelectParameters>
            <asp:QueryStringParameter Name="Id" QueryStringField="Id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <br />
    <br />
    <br />
    <div class="row">
        <div class="col-sm-12">
            <h4>TENANCY</h4>
            <span class="glyphicon glyphicon-chevron-down"></span>
            <asp:GridView ID="GridView3" runat="server" GridLines="None" CssClass="table table-condensed table-hover" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSource2">
                <Columns>
                    <asp:BoundField DataField="AccountCode" HeaderText="ACC CODE" SortExpression="AccountCode" />
                    <asp:BoundField DataField="TenancyFrom" HeaderText="FROM" SortExpression="TenancyFrom" DataFormatString="{0:dd/MMM/yy}" />
                    <asp:BoundField DataField="TenancyTo" HeaderText="TO" SortExpression="TenancyTo" DataFormatString="{0:dd/MMM/yy}" />
                    <asp:BoundField DataField="DURATION" HeaderText="DURATION" SortExpression="DURATION" DataFormatString="{0} MONTH(S)" />
                    <asp:BoundField DataField="EXPIRY" HeaderText="EXPIRY" SortExpression="EXPIRY" DataFormatString="{0} MONTH(S)" />
                    <asp:BoundField DataField="TotalDeposit" HeaderText="TOTAL DEPOSIT" SortExpression="TotalDeposit" DataFormatString="{0:#,##0.00}" />

                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CssClass="btn btn-default" PostBackUrl='<%#Eval("Id","/Tenancy/Detail.aspx?Id={0}")%>' data-toggle="tooltip" title="View Tenancy"><span class="glyphicon glyphicon-list-alt"></span></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <p>No tenancy found.</p>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
        SelectCommand="SELECT * FROM [vTENANCY] WHERE ([CustomerId] = @Id)">
        <SelectParameters>
            <asp:QueryStringParameter Name="Id" QueryStringField="Id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <br />
    <br />
    <br />
    <div class="row">
        <div class="col-sm-12">
            <uc1:UploadControl runat="server" ID="UploadControl" TargetFolder="Customer" />
        </div>
    </div>
    <br />
    <br />
    <br />
    <div id="EditDialog" class="modal fade" role="dialog">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #a1a1a1; color: #ffffff">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title"><span class="glyphicon glyphicon-comment"></span>EDIT CUSTOMER</h4>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:FormView ID="FormView2" runat="server" Width="100%" DataKeyNames="Id" DataSourceID="SqlDataSource1" DefaultMode="Edit" OnItemUpdated="FormView2_ItemUpdated" OnItemUpdating="FormView2_ItemUpdating">
                                <EditItemTemplate>
                                    <div class="form-group">
                                        <label>ORGANIZATION / COMPANY:</label>
                                        <asp:TextBox ID="OrganizationNameTextBox" required runat="server" Text='<%# Bind("OrganizationName") %>' CssClass="form-control text-capitalize" />
                                    </div>

                                    <div class="form-group">
                                        <label>MAILING ADDRESS:</label>
                                        <asp:TextBox ID="AddressTextBox" runat="server" Text='<%# Bind("Address") %>' CssClass="form-control text-capitalize" />
                                    </div>

                                    <div class="small">
                                        <div class="row">
                                            <div class="col-12 text-right">
                                                <asp:LinkButton ID="LinkButtonContactAdd" style="margin-right:13px" runat="server" CssClass="btn btn-sm btn-default" OnClick="LinkButtonContactAdd_Click"><span class="glyphicon glyphicon-plus"></span></asp:LinkButton>
                                            </div>
                                        </div>

                                        <asp:GridView ID="GridViewContact" runat="server" AutoGenerateColumns="false" GridLines="None" CssClass="table table-condensed small" OnRowDeleting="GridViewContact_RowDeleting">
                                            <Columns>
                                                <asp:TemplateField HeaderText="PERSON">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="TextBoxPerson" runat="server" Text='<%# Bind("Person")%>'></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="EMAIL">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="TextBoxEmail" runat="server" Text='<%# Bind("Email")%>'></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="PHONE 01">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="TextBoxPhone01" runat="server" Text='<%# Bind("Phone01")%>'></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="PHONE 02">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="TextBoxPhone02" runat="server" Text='<%# Bind("Phone02")%>'></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="LinkButton2" runat="server" CssClass="btn btn-sm" CommandName="Delete" ><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>

                                    <div class="modal-footer">
                                        <asp:Button ID="InsertButton" runat="server" CssClass="btn btn-success" CausesValidation="True" CommandName="Update" Text="Save" Width="100px" />
                                        <asp:LinkButton ID="InsertCancelButton" runat="server" CssClass="btn btn-default" CausesValidation="False" data-dismiss="modal" Width="100px">Close</asp:LinkButton>
                                    </div>
                                </EditItemTemplate>
                            </asp:FormView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

