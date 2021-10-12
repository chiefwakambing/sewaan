<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Applications_Customers_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script>
        $(document).ready(function () {
            $("#CUSTOMER").addClass("active");
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row">
        <div class="col-sm-6">
            <img src="/Logo.jpg" style="width:30px; position:absolute; display:inline-block; top:20px; left:-30px" />
            <h2>CUSTOMER</h2>
        </div>
        <div class="col-sm-6" style="text-align: right">
            <span data-toggle="modal" data-target="#NewDialog">
                <a data-toggle="tooltip" data-placement="bottom" title="Add New" class="btn btn-default"><span class="glyphicon glyphicon-file"></span></a>
            </span>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-12">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    
                    <br />
                    <asp:GridView ID="GridView1" runat="server" CssClass="table table-condensed table-hover" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSource1" GridLines="None" AllowSorting="True">
                        <Columns>
							<asp:TemplateField HeaderText="NO">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="OrganizationName" HeaderText="ORGANIZATION" HeaderStyle-ForeColor="Black" SortExpression="OrganizationName" ItemStyle-Font-Size="Small" ItemStyle-CssClass="text-capitalize" ItemStyle-Width="350px" />
                            <asp:BoundField DataField="PersonToContact" HeaderText="CONTACT PERSON" HeaderStyle-ForeColor="Black" SortExpression="PersonToContact" ItemStyle-Width="250px">
                                <ItemStyle Font-Size="Small" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Email" HeaderText="EMAIL(S)">
                                <ItemStyle Font-Size="Small" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Contact01" HeaderText="PHONE 01">
                                <ItemStyle Font-Size="Small" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Contact02" HeaderText="PHONE 02">
                                <ItemStyle Font-Size="Small" />
                            </asp:BoundField>
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CssClass="btn btn-default" data-toggle="tooltip" title="View Details" PostBackUrl='<%# "Detail.aspx?Id=" + Eval("Id")%>'><span class="glyphicon glyphicon-folder-open"></span></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"  OnInserted="SqlDataSource1_Inserted"
						InsertCommand="INSERT INTO [Customer] ([OrganizationName], [Address], [CreatedBy], [CreatedDateTime]) VALUES (@OrganizationName, @Address, @CreatedBy, @CreatedDateTime);SELECT @NewID=Scope_Identity()" 
						SelectCommand="SELECT *, (select count(*) from TENANCY where CustomerId=C.id) Tenancy FROM [Customer] C ORDER BY [OrganizationName]" DeleteCommand="DELETE FROM [Customer] WHERE [Id] = @Id" 
                        UpdateCommand="UPDATE [Customer] SET [OrganizationName] = @OrganizationName, [Address] = @Address, [CreatedBy] = @CreatedBy, [CreatedDateTime] = @CreatedDateTime WHERE [Id] = @Id">
                        <DeleteParameters>
                            <asp:Parameter Name="Id" Type="Int32" />
                        </DeleteParameters>
                        <InsertParameters>
                             <asp:Parameter Direction="Output" Name="NewID" Type="Int32" />
                            <asp:Parameter Name="OrganizationName" Type="String" />
                            <asp:Parameter Name="Address" Type="String" />
                            <asp:Parameter Name="CreatedBy" Type="String" />
                            <asp:Parameter Name="CreatedDateTime" Type="DateTime" />						
                        </InsertParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="PersonToContact" Type="String" />
                            <asp:Parameter Name="Email" Type="String" />
                            <asp:Parameter Name="Contact01" Type="String" />
                            <asp:Parameter Name="Contact02" Type="String" />
                            <asp:Parameter Name="OrganizationName" Type="String" />
                            <asp:Parameter Name="Address" Type="String" />
                            <asp:Parameter Name="CreatedBy" Type="String" />
                            <asp:Parameter Name="CreatedDateTime" Type="DateTime" />
                            <asp:Parameter Name="Id" Type="Int32" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    

    <div id="NewDialog" class="modal fade" role="dialog">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header" style="background-color:#a1a1a1; color:#ffffff">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title"><span class="glyphicon glyphicon-comment"></span> ADD NEW CUSTOMER</h4>
                </div>
                <div class="modal-body">

                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                            <asp:FormView ID="FormView1" runat="server" Width="100%" DataKeyNames="Id" DataSourceID="SqlDataSource1" DefaultMode="Insert" OnItemInserting="FormView1_ItemInserting">
                                <InsertItemTemplate>
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
                                        <asp:LinkButton ID="InsertButton" runat="server" CssClass="btn btn-success" CommandName="Insert"  Width="100px" >Save</asp:LinkButton>
                                        <asp:LinkButton ID="InsertCancelButton" runat="server" CssClass="btn btn-default" data-dismiss="modal" Width="100px" >Close</asp:LinkButton>
                                    </div>
                                </InsertItemTemplate>
                            </asp:FormView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>

            </div>
        </div>
    </div>

</asp:Content>

