<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Applications_Properties_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script>
        $(document).ready(function () {
            $("#PROPERTY").addClass("active");
        })
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row">
        <div class="col-sm-6">
            <img src="/Logo.jpg" style="width:30px; position:absolute; display:inline-block; top:20px; left:-30px" />
            <h2>PROPERTY</h2>
        </div>
        <div class="col-sm-6" style="text-align: right">
            <%if ((bool)Session["IsContribute"])
                { %>
            <span data-toggle="modal" data-target="#NewDialog">
                <a href="#" data-toggle="tooltip" data-placement="bottom" title="Add New" class="btn btn-default"><span class="glyphicon glyphicon-file"></span></a>
            </span>
            <%} %>
        </div>
    </div>
    <br />
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <asp:DataList ID="DataList1" runat="server" DataSourceID="SqlDataSource1" Width="100%">
                <ItemTemplate>
                    <div class="row">
                        <div class="col-sm-12">
                            <asp:Label ID="lblBuildingOrArea" ForeColor="#706c98" CssClass="h3" runat="server" Text='<%#Eval("BuildingOrArea")%>'></asp:Label>
							<asp:Label ID="lblPercent" runat="server" ForeColor="#706c98" CssClass="h3"  Text='<%# "- (Occupancy: " + Eval("Proportion","{0:F0}") + "%)" %> '></asp:Label>
							<a style="float:right" class="btn btn-sm btn-primary" href='Layout.aspx?Id=<%# Eval("BuildingOrArea")%>'><span class="glyphicon glyphicon-folder-open"></a>
                            <br />
                            <asp:GridView ID="GridView1" runat="server" CssClass="table table-condensed table-hover" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSource2" GridLines="None" ShowFooter="True"  OnDataBound="GridView1_DataBound" FooterStyle-ForeColor="Black">
                                <Columns>
								<asp:TemplateField HeaderText="NO">
                                     <ItemTemplate>
                                         <%# Container.DataItemIndex + 1 %>
                                     </ItemTemplate>
                                    </asp:TemplateField>
									
                                    <asp:TemplateField HeaderText="CODE">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TextBoxCodeNo" Text='<%#Eval("CodeNo")%>'  Width="50px" style="padding:3px" runat="server"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Lot" HeaderText="LOT/SUITE" ItemStyle-Width="300px">
                                        <ItemStyle Font-Size="Small" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="SquareFeet" HeaderText="SIZE (Sq.Ft)" SortExpression="SquareFeet" DataFormatString="{0:#,##0.00}" ItemStyle-Width="110px">
                                        <ItemStyle Font-Size="Small" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Rental" DataFormatString="{0:##,##0.00}" HeaderText="RENTAL (RM)" SortExpression="Rental" ItemStyle-Width="110px">
                                        <ItemStyle Font-Size="Small" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="ENQUIRIES" ItemStyle-Width="110px">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" CssClass="label label-primary" Text='<%# Eval("HotEnquiry") %>' data-toggle="tooltip" title="Hot" ></asp:Label>
                                            <asp:Label ID="Label2" runat="server" CssClass="label label-default" Text='<%# Eval("TotalEnquiry") %>' data-toggle="tooltip" title="Total" ></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-Font-Size="Small" HeaderText="TENANT" ItemStyle-Width="300px">
                                        <ItemTemplate>
                                            <asp:Label ID="Label3" runat="server" Text='<%# Eval("InternalOccupancy").ToString()=="" ? Eval("Tenant") : Eval("InternalOccupancy") %>' Font-Size="12px" ></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="EXPIRING" ItemStyle-Width="120px">
                                        <ItemTemplate>
                                            <asp:Label ID="Label4" runat="server" CssClass='<%# Eval("Expiry").ToString() != "" ? Color(int.Parse(Eval("Expiry").ToString())) : "" %>' Text='<%# Eval("Expiry") %>' data-toggle="tooltip" title="Months" Font-Size="12px"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="LinkButton1" runat="server" data-toggle="tooltip" title="View Details" CausesValidation="False" CssClass="btn btn-default" TabIndex="-1" PostBackUrl='<%#Eval("Id","Detail.aspx?Id={0}")%>'><span class="glyphicon glyphicon-folder-open"></span></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            
                            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
                                InsertCommand="INSERT INTO [Property] ([BuildingOrArea], [Lot], [SquareFeet], [Rental], [Amenity], [Description], [CreatedBy], [CreatedDateTime], [Address]) VALUES (@BuildingOrArea, @Lot, @SquareFeet, @Rental, @Amenity, @Description, @CreatedBy, @CreatedDateTime, @Address)"
                                SelectCommand="Select Id, CodeNo, Lot, SquareFeet, Rental,InternalOccupancy,
	                                                IsNull((Select Top 1 Tenant from vPROPERTY Where Id = P.Id And Terminate<>1  Order By TenancyTo Desc),InternalOccupancy) as Tenant,
	                                                (Select Top 1 Expiry from vPROPERTY Where Id = P.Id And Terminate <> 1 Order By TenancyTo Desc ) as Expiry,
	                                                (Select Top 1 HotEnquiry from vPROPERTY Where Id = P.Id Order By TenancyTo Desc) as HotEnquiry,
	                                                (Select Top 1 TotalEnquiry from vPROPERTY Where Id = P.Id Order By TenancyTo Desc) as TotalEnquiry,
                                                    (Select Top 1 Terminate from vPROPERTY Where Id = P.Id Order By TenancyTo Desc) as Terminate
	                                                From PROPERTY P
	                                                Where BuildingOrArea = @BuildingOrArea And (IsDelete Is Null or IsDelete = 0)
                                                    Order By CodeNo">
                                <InsertParameters>
                                    <asp:Parameter Name="BuildingOrArea" Type="String" />
                                    <asp:Parameter Name="Lot" Type="String" />
                                    <asp:Parameter Name="SquareFeet" Type="Decimal" />
                                    <asp:Parameter Name="Address" Type="String" />
                                    <asp:Parameter Name="Rental" Type="Decimal" />
                                    <asp:Parameter Name="Amenity" Type="String" />
                                    <asp:Parameter Name="Description" Type="String" />
                                    <asp:Parameter Name="CreatedBy" Type="String" />
                                    <asp:Parameter Name="CreatedDateTime" Type="DateTime" />
                                </InsertParameters>
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="lblBuildingOrArea" Name="BuildingOrArea" PropertyName="Text" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:LinkButton ID="ButtonUpdateCode" runat="server" CssClass="btn btn-default" style="position:relative;top:-35px" OnClick="ButtonUpdateCode_Click"><span class="glyphicon glyphicon-arrow-up"></span> Update Code</asp:LinkButton>
                            <br />
                            <br />
                        </div>
                    </div>
                </ItemTemplate>
            </asp:DataList>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>" 
                SelectCommand="SELECT DISTINCT p.BuildingorArea, t.Proportion from dbo.PROPERTY p  
                                inner join dbo.vPercentage t on p.BuildingOrArea = t.BuildingOrArea
                                order by p.BuildingOrArea" 
                InsertCommand="INSERT INTO [Property] ([BuildingOrArea], [Lot], [SquareFeet], [Rental], [Amenity], [Description], [CreatedBy], [CreatedDateTime], [Address]) VALUES (@BuildingOrArea, @Lot, @SquareFeet, @Rental, @Amenity, @Description, @CreatedBy, @CreatedDateTime, @Address)">
                <InsertParameters>
                    <asp:Parameter Name="BuildingOrArea" Type="String" />
                    <asp:Parameter Name="Lot" Type="String" />
                    <asp:Parameter Name="SquareFeet" Type="Decimal" />
                    <asp:Parameter Name="Address" Type="String" />
                    <asp:Parameter Name="Rental" Type="Decimal" />
                    <asp:Parameter Name="Amenity" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="CreatedBy" Type="String" />
                    <asp:Parameter Name="CreatedDateTime" Type="DateTime" />
                </InsertParameters>
            </asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>

    <div id="NewDialog" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header" style="background-color:#a1a1a1; color:#ffffff">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title"><span class="glyphicon glyphicon-comment"></span> ADD NEW PROPERTY</h4>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <asp:FormView ID="FormView1" runat="server" Width="100%" DataKeyNames="Id" DataSourceID="SqlDataSource1" DefaultMode="Insert" OnItemInserting="FormView1_ItemInserting">
                                <InsertItemTemplate>
                                    <div class="form-group">
                                        <label>BUILDING / AREA</label>
                                        <asp:TextBox ID="BuildingOrAreaTextBox" required="required" CssClass="form-control text-capitalize" runat="server" Text='<%# Bind("BuildingOrArea") %>' />
                                    </div>
                                    <div class="form-group">
                                        <label>LOT / SUITE</label>
                                        <asp:TextBox ID="LotTextBox" required="required" CssClass="form-control" runat="server" Text='<%# Bind("Lot") %>' />
                                    </div>
                                    <div class="form-group">
                                        <label>SIZE (Sq ft)</label>
                                        <asp:TextBox ID="SquareFeetTextBox" required="required" CssClass="form-control" TextMode="Number" runat="server" Text='<%# Bind("SquareFeet") %>' />
                                    </div>
                                    <div class="form-group">
                                        <label>ADDRESS</label>
                                        <asp:TextBox ID="AddressTextBox" CssClass="form-control text-capitalize" runat="server" Text='<%# Bind("Address") %>' />
                                    </div>
                                    <div class="form-group">
                                        <label>ADVERTISE RENTAL (RM)</label>
                                        <asp:TextBox ID="RentalTextBox" required="required" CssClass="form-control" TextMode="Number" runat="server" Text='<%# Bind("Rental") %>' />
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
                                        <asp:Label ID="Label3" runat="server" style="float:left" CssClass="text-danger"></asp:Label>
                                        <asp:Button ID="Button1" runat="server" Text="Save" CssClass="btn btn-success" CommandName="Insert"  Width="100px"  />
                                        <button type="button" class="btn btn-default" data-dismiss="modal" style="width:100px" >Close</button>
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

