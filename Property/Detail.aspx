<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Detail.aspx.cs" Inherits="Applications_Properties_Detail" %>

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
                    <p>PROPERTY <span class="glyphicon glyphicon-chevron-right"></span></p>
                    <h1 style="color: #706c98">
                        <asp:Label ID="LabelBuildingOrArea" runat="server" Text='<%# Eval("BuildingOrArea") %>'></asp:Label>
                    </h1>
                </div>
                <div class="col-sm-6" style="text-align: right">
                    <asp:LinkButton ID="lnkEdit" runat="server" Enabled='<%#(bool)Session["IsContribute"] %>' data-toggle="tooltip" data-placement="bottom" title="Edit" CssClass="btn btn-default" OnClick="lnkEdit_Click"><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>

                    <asp:LinkButton ID="lnkDelete" runat="server" Enabled='<%#(bool)Session["IsContribute"] %>' data-toggle="tooltip" data-placement="bottom" title="Delete" CssClass="btn btn-default" OnClientClick="return confirm('Are you sure?')" OnClick="lnkDelete_Click"><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                </div>
            </div>
            <br />
            <div class="row">
                <div class="col-sm-12">

                    <div style="border: 1px solid #d1d1d1; padding: 5px; border-radius: 5px">
                        <br />
                        <asp:GridView ID="GridView1" runat="server" CssClass="table table-condensed" GridLines="None" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSource1" OnRowDataBound="GridView1_RowDataBound">
                            <Columns>
                                <asp:BoundField DataField="Lot" HeaderText="LOT/SUITE" />
                                <asp:BoundField DataField="SquareFeet" HeaderText="SIZE (Sq Ft)" ItemStyle-Width="100px" DataFormatString="{0:#,##0.00}" />
                                <asp:BoundField DataField="Rental" DataFormatString="{0:#,##0.00}" HeaderText="RENTAL" />
                                <asp:TemplateField HeaderText="ADDRESS">
                                    <ItemTemplate>
                                        <asp:HyperLink ID="HyperLink2" runat="server" Target="_blank" NavigateUrl='<%#Eval("Address","http://maps.google.com?q={0}") %>' data-toggle="tooltip" title="See in Google Maps"><%#Eval("Address")%></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                
                                <asp:BoundField DataField="AMENITY" HeaderText="AMENITES" />

                            </Columns>
                        </asp:GridView>
                        <br />
                        <asp:GridView ID="GridView2" runat="server" CssClass="table table-condensed" GridLines="None" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSource1">
                            <Columns>
                                
                                <asp:BoundField DataField="DESCRIPTION" HeaderText="DESCRIPTION" />
                            </Columns>
                        </asp:GridView>
                        <br />
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
                            DeleteCommand="UPDATE PROPERTY SET ISDELETE=1 WHERE [Id] = @Id"
                            SelectCommand="SELECT * from PROPERTY WHERE ID=@Id"
                            UpdateCommand="UPDATE [Property] SET [BuildingOrArea] = @BuildingOrArea, [Lot] = @Lot, [Address] = @Address, [SquareFeet] = @SquareFeet, [Rental] = @Rental, [Amenity] = @Amenity, [Description] = @Description, [CreatedBy] = @CreatedBy, [CreatedDateTime] = @CreatedDateTime WHERE [Id] = @Id">
                            <DeleteParameters>
                                <asp:QueryStringParameter Name="Id" QueryStringField="Id" Type="Int32" />
                            </DeleteParameters>
                            <SelectParameters>
                                <asp:QueryStringParameter Name="Id" QueryStringField="Id" Type="Int32" />
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="BuildingOrArea" Type="String" />
                                <asp:Parameter Name="Lot" Type="String" />
                                <asp:Parameter Name="Address" Type="String" />
                                <asp:Parameter Name="SquareFeet" Type="Decimal" />
                                <asp:Parameter Name="Rental" Type="Decimal" />
                                <asp:Parameter Name="Amenity" Type="String" />
                                <asp:Parameter Name="Description" Type="String" />
                                <asp:Parameter Name="CreatedBy" Type="String" />
                                <asp:Parameter Name="CreatedDateTime" Type="DateTime" />
                                <asp:Parameter Name="Id" Type="Int32" />
                            </UpdateParameters>
                        </asp:SqlDataSource>
                    </div>
                </div>
            </div>
            <br />
            <div class="row">
                <div class="col-sm-12">
                    <h4>TENANCY HISTORY</h4>
                    <span class="glyphicon glyphicon-chevron-down"></span>
                    <asp:GridView ID="GridView4" runat="server" CssClass="table table-condensed" GridLines="None" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSource3" OnRowDataBound="GridView4_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText="CUSTOMER">
                                <ItemTemplate>
                                    <asp:Label ID="Label6" runat="server" Text='<%#Eval("Customer")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="TENANCY PERIOD" ItemStyle-Width="250px">
                                <ItemTemplate>
                                    <asp:Label ID="Lbl01" Text='<%#Eval("TenancyFrom","{0:dd/MMM/yyy}")%>' runat="server"></asp:Label>
                                    -
                                    <asp:Label ID="Label5" Text='<%#Eval("TenancyTo","{0:dd/MMM/yyy}")%>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:Label ID="LblTerminate" runat="server" CssClass="label label-danger" Font-Size="Small"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <p>No record found.</p>
                        </EmptyDataTemplate>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
                        SelectCommand="select B.PropertyId, (Select OrganizationName from Customer Where Id=A.CustomerId) as Customer,  * from 
                                       TENANCY A inner join TENANCY_PROPERTY B
                                       On A.Id = B.TenancyId
                                       Where PropertyId=@Id">
                        <SelectParameters>
                            <asp:QueryStringParameter Name="Id" QueryStringField="Id" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </div>
            <br />
            <br />
            <hr />
            <div class="row">
                <div class="col-sm-12">
                    <h4>INTERNAL OCCUPANCY</h4>
                    <span class="glyphicon glyphicon-chevron-down"></span>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-8">
                    <asp:DropDownList ID="DropDownListInternalOccupancy" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
                <div class="col-sm-4" style="text-align:right">
                    <asp:LinkButton ID="ButtonSaveInternalOccupancy" runat="server"  Enabled='<%#(bool)Session["IsContribute"] %>' CssClass="btn btn-default" OnClick="ButtonSaveInternalOccupancy_Click"><span class="glyphicon glyphicon-floppy-disk"></span></asp:LinkButton>
                </div>
            </div>
            <br />
            <br />
            <hr />
            <div class="row">
                <div class="col-sm-6">
                    <h4>ENQUIRY / INTEREST</h4>
                    <span class="glyphicon glyphicon-chevron-down"></span>
                </div>
                <div class="col-sm-6" style="text-align: right">

                    <%if ((bool)Session["IsContribute"])
                        { %>
                    <span data-toggle="modal" data-target="#EnquiryDialog">
                        <a class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Add Enquiry / Interest"><span class="glyphicon glyphicon-file"></span></a>
                    </span>
                    <%} %>
                </div>
            </div>
            <br />
            <br />
            <div class="row">
                <div class="col-sm-12">
                    <asp:GridView ID="GridView3" runat="server" CssClass="table table-hover table-condensed" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSource2" GridLines="None" OnRowCommand="GridView3_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="CreatedDateTime" HeaderText="DATE" DataFormatString="{0: dd/MMM/yy}" ReadOnly="true">
                                <ItemStyle Width="85px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Customer" HeaderText="PERSON" SortExpression="Customer" ReadOnly="true" />
                            <asp:TemplateField HeaderText="PHONE" SortExpression="Contact01">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" Text='<%# Bind("Contact01") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("Contact01") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle Width="120px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="EMAIL" SortExpression="Contact02">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox2" runat="server" CssClass="form-control" Text='<%# Bind("Contact02") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("Contact02") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle Width="120px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="REMARK" SortExpression="Description">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox3" runat="server" CssClass="form-control" Rows="3" Text='<%# Bind("Description") %>' TextMode="MultiLine"></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="INTEREST/STATUS" SortExpression="Status">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-control" SelectedValue='<%# Bind("Status") %>'>
                                        <asp:ListItem>Cold</asp:ListItem>
                                        <asp:ListItem>Hot</asp:ListItem>
                                        <asp:ListItem>Negotiation</asp:ListItem>
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Status") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle Width="80px" />
                            </asp:TemplateField>
                            <asp:TemplateField ShowHeader="False">
                                <EditItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CssClass="btn btn-default" data-toggle="tooltip" title="Save" CommandName="Update"><span class="glyphicon glyphicon-floppy-disk"></span> </asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CssClass="btn btn-default" data-toggle="tooltip" title="Cancel" CommandName="Cancel"><span class="glyphicon glyphicon-remove-sign"></span></asp:LinkButton>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CssClass="btn btn-default" data-toggle="tooltip" Title="Edit" CommandName="Edit"><span class="glyphicon glyphicon-pencil"></span></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CssClass="btn btn-default" data-toggle="tooltip" Title="Delete" CommandName="Delete" Text="Delete"><span class="glyphicon glyphicon-trash"></span> </asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle Width="110px" />
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <p>No enquiry found.</p>
                        </EmptyDataTemplate>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>" InsertCommand="INSERT INTO [ENQUIRY] ([Customer], [Contact01], [Contact02], [PropertyId], [Status], [Description], [CreatedBy], [CreatedDateTime]) VALUES (@Customer, @Contact01, @Contact02, @PropertyId, @Status, @Description, @CreatedBy, @CreatedDateTime)" DeleteCommand="DELETE FROM [ENQUIRY] WHERE [Id] = @Id" SelectCommand="SELECT * FROM [ENQUIRY] WHERE ([PropertyId] = @PropertyId)" UpdateCommand="UPDATE [ENQUIRY] SET [Contact01] = @Contact01, [Contact02] = @Contact02, [Status] = @Status, [Description] = @Description, [CreatedBy] = @CreatedBy WHERE [Id] = @Id">
                        <DeleteParameters>
                            <asp:Parameter Name="Id" Type="Int32" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Customer" Type="String" />
                            <asp:Parameter Name="Contact01" Type="String" />
                            <asp:Parameter Name="Contact02" Type="String" />
                            <asp:Parameter Name="PropertyId" Type="Int32" />
                            <asp:Parameter Name="Status" Type="String" />
                            <asp:Parameter Name="Description" Type="String" />
                            <asp:Parameter Name="CreatedBy" Type="String" />
                            <asp:Parameter Name="CreatedDateTime" Type="DateTime" />
                        </InsertParameters>
                        <SelectParameters>
                            <asp:QueryStringParameter Name="PropertyId" QueryStringField="Id" Type="Int32" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="Customer" Type="String" />
                            <asp:Parameter Name="Contact01" Type="String" />
                            <asp:Parameter Name="Contact02" Type="String" />
                            <asp:Parameter Name="PropertyId" Type="Int32" />
                            <asp:Parameter Name="Status" Type="String" />
                            <asp:Parameter Name="Description" Type="String" />
                            <asp:Parameter Name="CreatedBy" Type="String" />
                            <asp:Parameter Name="CreatedDateTime" Type="DateTime" />
                            <asp:Parameter Name="Id" Type="Int32" />
                        </UpdateParameters>
                    </asp:SqlDataSource>

                </div>
            </div>
            <br />
            <br />
            <hr />
            <div class="row">
                <div class="col-sm-12">
                    <uc1:UploadControl runat="server" ID="UploadControl" TargetFolder="Property" />
                </div>
            </div>
            <br />
        </ContentTemplate>
    </asp:UpdatePanel>

    <div id="EnquiryDialog" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #a1a1a1; color: #ffffff">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title"><span class="glyphicon glyphicon-comment"></span>ADD NEW ENQUIRY / INTEREST</h4>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                        <ContentTemplate>
                            <asp:FormView ID="FormView1_EnquiryDialog" runat="server" DefaultMode="Insert" DataKeyNames="Id" DataSourceID="SqlDataSource2" Width="100%" OnItemInserting="FormView2_ItemInserting">
                                <InsertItemTemplate>
                                    <div class="form-group">
                                        <label>PERSON NAME:</label>
                                        <asp:TextBox ID="CustomerNameTextBox" runat="server" CssClass="form-control text-capitalize" Text='<%# Bind("Customer") %>' />
                                    </div>
                                    <div class="form-group">
                                        <label>PHONE 01:</label>
                                        <asp:TextBox ID="CustomerContact01TextBox" runat="server" CssClass="form-control" Text='<%# Bind("Contact01") %>' />
                                    </div>
                                    <div class="form-group">
                                        <label>EMAIL:</label>
                                        <asp:TextBox ID="CustomerContact02TextBox" runat="server" CssClass="form-control" Text='<%# Bind("Contact02") %>' />
                                    </div>
                                    <div class="form-group">
                                        <label>INTEREST:</label>
                                        <asp:DropDownList ID="StatusTextBox" runat="server" CssClass="form-control" Text='<%# Bind("Status") %>'>
                                            <asp:ListItem>Cold</asp:ListItem>
                                            <asp:ListItem>Hot</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="form-group">
                                        <label>REMARK:</label>
                                        <asp:TextBox ID="DescriptionTextBox" runat="server" CssClass="form-control" Text='<%# Bind("Description") %>' />
                                    </div>
                                    <div class="modal-footer">
                                        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="btn btn-success" Width="100px">Save</asp:LinkButton>
                                        <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" Text="Close" CssClass="btn btn-default" data-dismiss="modal" Width="100px" />
                                    </div>
                                </InsertItemTemplate>
                            </asp:FormView>

                        </ContentTemplate>
                    </asp:UpdatePanel>

                </div>
            </div>
        </div>
    </div>

    <div id="EditDialog" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #a1a1a1; color: #ffffff">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title"><span class="glyphicon glyphicon-comment"></span>EDIT PROPERTY</h4>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:FormView ID="FormView2" runat="server" Width="100%" DataKeyNames="Id" DataSourceID="SqlDataSource1" DefaultMode="Edit" OnDataBound="FormView2_DataBound" OnItemUpdating="FormView2_ItemUpdating" OnItemUpdated="FormView2_ItemUpdated">
                                <EditItemTemplate>
                                    <div class="form-group">
                                        <label>BUILDING / AREA</label>
                                        <asp:TextBox ID="BuildingOrAreaTextBox" CssClass="form-control" runat="server" Text='<%# Bind("BuildingOrArea") %>' />
                                    </div>
                                    <div class="form-group">
                                        <label>LOT / SUITE</label>
                                        <asp:TextBox ID="LotTextBox" CssClass="form-control" runat="server" Text='<%# Bind("Lot") %>' />
                                    </div>
                                    <div class="form-group">
                                        <label>SIZE (Sq ft)</label>
                                        <asp:TextBox ID="SquareFeetTextBox" CssClass="form-control" runat="server" Text='<%# Bind("SquareFeet","{0:#,##0.00}") %>' />
                                    </div>
                                    <div class="form-group">
                                        <label>MAILING ADDRESS</label>
                                        <asp:TextBox ID="AddressTextBox" CssClass="form-control text-capitalize" runat="server" Text='<%# Bind("Address") %>' />
                                    </div>
                                    <div class="form-group">
                                        <label>ADVERTISE RENTAL (RM)</label>
                                        <asp:TextBox ID="RentalTextBox" CssClass="form-control" runat="server" Text='<%# Bind("Rental", "{0:#,##0.00}") %>' />
                                    </div>
                                    <div class="form-group">
                                        <label>AMEINITES</label>
                                        <asp:CheckBoxList ID="CheckBoxListAmenity" runat="server" RepeatDirection="Horizontal" Width="100%">
                                            <asp:ListItem>Toilet</asp:ListItem>
                                            <asp:ListItem>Air-Cond</asp:ListItem>
                                            <asp:ListItem>Parking</asp:ListItem>
                                            <asp:ListItem>Gym</asp:ListItem>
                                            <asp:ListItem>Surau</asp:ListItem>
                                            <asp:ListItem>Cafeteria</asp:ListItem>
                                        </asp:CheckBoxList>
                                    </div>
                                    <div class="form-group">
                                        <label>DESCRIPTION / BRIEF WRITE UP</label>
                                        <asp:TextBox ID="DescriptionTextBox" CssClass="form-control" runat="server" Rows="3" Text='<%# Bind("Description") %>' TextMode="MultiLine" Width="100%" />
                                    </div>
                                    <div class="modal-footer">
                                        <asp:Button ID="Button1" runat="server" Text="Save" CssClass="btn btn-success" CommandName="Update" Width="100px" />
                                        <button type="button" class="btn btn-default" data-dismiss="modal" style="width: 100px">Close</button>
                                    </div>
                                </EditItemTemplate>
                            </asp:FormView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>

            </div>
        </div>
    </div>

    <br />
    <br />
    <br />

</asp:Content>

