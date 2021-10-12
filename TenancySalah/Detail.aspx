<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Detail.aspx.cs" Inherits="Tenancy_Detail" %>

<%@ Register Src="~/UploadControl.ascx" TagPrefix="uc1" TagName="UploadControl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script>
	$(document).ready(function () {
            $("TENANCY").addClass("active");
        })

        function totalCalc(Sqft) {

            $("[id*=RentalTextBox]").on("keyup change click", function () {
                var row = $(this).closest("tr");
                $("[id*=PerSqft1Label]", row).html(($(this).val() / Sqft).toFixed(2));
            });

            $("[id*=ServiceTextBox]").on("keyup change click", function () {
                var row = $(this).closest("tr");
                $("[id*=PerSqft2Label]", row).html(($(this).val() / Sqft).toFixed(2));
            });
        };

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:FormView ID="frmTenancy" runat="server" Width="100%" DataSourceID="Sql01">
                <ItemTemplate>
                    <p>TENANCY <span class="glyphicon glyphicon-chevron-right"></span></p>
                    <h2>
                        <asp:Label ID="Label3" runat="server" Text='<%#Eval("Customer")%>' ForeColor="#706c98"></asp:Label>
                    </h2>
                    <br />
                    <div class="row">
                        <div class="col-sm-4">
                            <p><strong>DETAIL</strong>&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-down"></span></p>

                            <table class="table table-condensed">
                                <tr>
                                    <td style="width: 125px">PROPERTY</td>
                                    <td>

                                        <%--<asp:Label ID="LblBuildingOrArea" ForeColor="#706c98" runat="server" Text='<%#Eval("BuildingOrArea") %>'></asp:Label>
                                        <br />
                                        <span class="glyphicon glyphicon-home small"></span>
                                        <asp:Label ID="LblLot" runat="server" CssClass="small" Text='<%#Eval("Lot") %>'></asp:Label>--%>

                                        <asp:GridView ID="GridViewDisplayProperties" ShowHeader="false" CssClass="small" Width="100%" AutoGenerateColumns="false"  GridLines="None" runat="server" DataSourceID="SqlDataSourceDisplayProperties">
                                            <Columns>
                                                <asp:BoundField DataField="RowNo" ItemStyle-Font-Bold="true" />
                                                <asp:BoundField DataField="BuildingOrArea" />
                                                <asp:BoundField DataField="Lot" />
                                            </Columns>
                                        </asp:GridView>
                                        <asp:SqlDataSource ID="SqlDataSourceDisplayProperties" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>" 
                                            SelectCommand="select row_number() over (order by Id) as RowNo, (Select BuildingOrArea from PROPERTY Where Id=B.PropertyId) as BuildingOrArea,(Select Lot from PROPERTY Where Id=B.PropertyId) as Lot from TENANCY A inner join TENANCY_PROPERTY B on A.Id = B.TenancyId WHERE A.ID=@Id">
                                            <SelectParameters>
                                                <asp:QueryStringParameter Name="Id" QueryStringField="Id" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>



                                    </td>
                                </tr>
                                <tr>
                                    <td>SIZE
                                    </td>
                                    <td>
                                        <asp:Label ID="LblSqft" runat="server" Text='<%#Eval("SquareFeet","{0:0.00}") %>'></asp:Label>
                                        Sqft.
                                        
                                    </td>
                                </tr>
                                <tr>
                                    <td>TENANT</td>
                                    <td>
                                        <asp:Label ID="LblCustomer" runat="server" Text='<%#Eval("Customer") %>' Font-Size="Small"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>FROM</td>
                                    <td>
                                        <asp:Label ID="TxtTenancyFrom" runat="server" Text='<%#Eval("TenancyFrom","{0:dd-MMM-yyyy}") %>'></asp:Label></td>
                                </tr>
                                <tr>
                                    <td>TO</td>
                                    <td>
                                        <asp:Label ID="TxtTenancyTo" runat="server" Text='<%#Eval("TenancyTo","{0:dd-MMM-yyyy}") %>'></asp:Label></td>
                                </tr>
                                <tr>
                                    <td>ACC. CODE</td>
                                    <td>
                                        <asp:TextBox ID="TxtAccountCode" Width="155px" runat="server" Text='<%#Eval("AccountCode") %>'></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>WAIVER</td>
                                    <td>
                                        <asp:TextBox ID="TxtWaiver" runat="server" Width="50px" TextMode="Number" Text='<%#Eval("Waiver") %>'></asp:TextBox>
                                        Month(s)</td>
                                </tr>
                                <tr>
                                    <td>W. UNIT</td>
                                    <td>

                                        <asp:DropDownList ID="DdlWaiverUnit" runat="server" Height="26px" SelectedValue='<%# Eval("WaiverUnit") %>'>
                                            <asp:ListItem Value="1">Rental</asp:ListItem>
                                            <asp:ListItem Value="2">Sevice</asp:ListItem>
                                            <asp:ListItem Value="3">Rental+Service</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>CREATED</td>
                                    <td>
                                        <asp:Label ID="LblCreatedDateTime" runat="server" CssClass="small" Text='<%#Eval("CreatedDateTime","{0:dd/MMM/yyy}") %>'></asp:Label>
                                        <br />
                                        <asp:Label ID="LblCreatedBy" runat="server" CssClass="small" Text='<%#Eval("CreatedBy") %>'></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-sm-3">
                            <p><strong>DEPOSIT</strong>&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-down"></span> </p>
                            <table class="table table-condensed">
                                <tr>
                                    <td>SECURITY</td>
                                    <td>
                                        <asp:TextBox ID="TxtDeposit01" Width="75px" TextMode="Number" step="any" Text='<%#Eval("Deposit01","{0:0.00}") %>' runat="server"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>UTILITY</td>
                                    <td>
                                        <asp:TextBox ID="TxtDeposit02" Width="75px" TextMode="Number" step="any" Text='<%#Eval("Deposit02","{0:0.00}") %>' runat="server"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>MAILBOX</td>
                                    <td>
                                        <asp:TextBox ID="TxtDeposit03" Width="75px" TextMode="Number" step="any" Text='<%#Eval("Deposit03","{0:0.00}") %>' runat="server"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>RENOVATION</td>
                                    <td>
                                        <asp:TextBox ID="TxtDeposit04" Width="75px" TextMode="Number" step="any" Text='<%#Eval("Deposit04","{0:0.00}") %>' runat="server"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>RESTORATION</td>
                                    <td>
                                        <asp:TextBox ID="TxtDeposit05" Width="75px" TextMode="Number" step="any" Text='<%#Eval("Deposit05","{0:0.00}") %>' runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <br />
                                        <strong>COMMENT</strong>&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-down"></span>
                                        <asp:TextBox ID="TxtComment" runat="server" TextMode="MultiLine" Width="100%" Text='<%#Eval("Comment") %>'></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-sm-5">
                            <p><strong>PAYMENT SCHEDULE</strong>&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-down"></span></p>
                            <asp:GridView ID="GrvPaymentSchedule" runat="server" AutoGenerateColumns="false" CssClass="table table-condensed" GridLines="None" DataSourceID="Sql02" OnDataBound="GrvPaymentSchedule_DataBound">
                                <Columns>
                                    <asp:BoundField DataField="PERIOD1" HeaderText="FROM" DataFormatString="{0:dd/MMM/yy}" />
                                    <asp:BoundField DataField="PERIOD2" HeaderText="TO" DataFormatString="{0:dd/MMM/yy}" />
                                    <asp:TemplateField HeaderText="RENTAL / SERVICE CHARGE">
                                        <ItemTemplate>
                                            <asp:TextBox ID="RentalTextBox" runat="server" required="required" TextMode="Number" step="any" min="0" Width="80px" Text='<%#Bind("AMOUNT", "{0:0.00}")%>'></asp:TextBox>
                                            <asp:TextBox ID="ServiceTextBox" runat="server" required="required" TextMode="Number" step="any" min="0" Width="80px" Text='<%#Bind("SERVICECHARGE", "{0:0.00}")%>'></asp:TextBox>
                                            <span class="small">
                                                <asp:Label ID="PerSqft1Label" runat="server" Text="0"></asp:Label>
                                                |
                                                <asp:Label ID="PerSqft2Label" runat="server" Text="0"></asp:Label>
                                                Per Sqft
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                    <hr />
                    <div style="float: left">
                        <asp:Button ID="BtnMasterDelete" runat="server" Enabled='<%#(bool)Session["IsContribute"]%>' Text="Force Delete!" CssClass="btn btn-danger" OnClientClick="if (confirm('You cannot undo this operation. Are you sure to force delete this TENANCY and related BILLING and PAYMENT?')) return confirm('This will delete related BILLING and PAYMENT records. Are you sure?')" OnClick="BtnMasterDelete_Click" />
                        
                        <asp:LinkButton ID="BtnDelete" runat="server" Enabled='<%#(bool)Session["IsContribute"]%>' CssClass="btn btn-danger" data-toggle="tooltip" title="Delete" OnClientClick="return confirm('You cannot undo once deleted. Are you sure to delete?')" OnClick="BtnDelete_Click"><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                        &nbsp;
                        <asp:Button ID="BtnTerminate" runat="server" Text="Terminate" Enabled='<%#(bool)Session["IsContribute"]%>' CssClass="btn btn-danger" data-toggle="modal" data-target="#DlgTerminate" Width="100px" />
                    </div>
                    <div style="float: right">
                        <asp:Button ID="BtnExtend" runat="server" Enabled='<%#(bool)Session["IsContribute"]%>' Text="Extend" CssClass="btn btn-default" data-toggle="modal" data-target="#DlgExtend" Width="100px" />
                        <asp:Button ID="BtnSaveTenancy" runat="server" Enabled='<%#(bool)Session["IsContribute"]%>' Text="Save" CssClass="btn btn-default" OnClientClick="return confirm('Are you sure?')" OnClick="BtnSaveTenancy_Click" Width="100px" />
                    </div>
                    <br />
                    <br />
                    <br />
                </ItemTemplate>
            </asp:FormView>
            <%--<asp:SqlDataSource ID="Sql01" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
                SelectCommand="select A.*,(select OrganizationName from Customer where Id=A.CustomerId) as Customer,(Select BuildingOrArea from PROPERTY Where Id=B.PropertyId) as BuildingOrArea,(Select Lot from PROPERTY Where Id=B.PropertyId) as Lot, (Select SquareFeet from PROPERTY Where Id=B.PropertyId) as SquareFeet from TENANCY A inner join TENANCY_PROPERTY B on A.Id = B.TenancyId WHERE A.ID=@ID">
                <SelectParameters>
                    <asp:QueryStringParameter Name="ID" QueryStringField="Id" />
                </SelectParameters>
            </asp:SqlDataSource>--%>
			<asp:SqlDataSource ID="Sql01" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
                SelectCommand="select A.*,
								(select OrganizationName from Customer where Id=A.CustomerId) as Customer,
								(Select sum(SquareFeet) from PROPERTY Where Id in (Select PropertyId from TENANCY_PROPERTY Where TenancyId=@ID)) as SquareFeet 
								from TENANCY A WHERE A.ID=@ID">
                <SelectParameters>
                    <asp:QueryStringParameter Name="ID" QueryStringField="Id" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="Sql02" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
                SelectCommand="select * FROM TENANCY_RENTAL WHERE TenancyId=@ID">
                <SelectParameters>
                    <asp:QueryStringParameter Name="ID" QueryStringField="Id" />
                </SelectParameters>
            </asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>

    <br />
    <br />
    <br />
    <div class="row">
        <div class="col-sm-12">
            <uc1:UploadControl runat="server" ID="UploadControl" TargetFolder="Tenancy" />
        </div>
    </div>
    <br />
    <br />
    <br />

    <div id="DlgTerminate" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #a1a1a1; color: #ffffff">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title"><span class="glyphicon glyphicon-comment"></span>TERMINATE TENANCY</h4>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                            <div class="form-group">
                                <label>LAST BILLING MONTH:</label>
                                <div class="form-inline">
                                    <asp:DropDownList ID="DdlLastBillMonth" runat="server" required="required" CssClass="form-control">
                                        <asp:ListItem>Jan</asp:ListItem>
                                        <asp:ListItem>Feb</asp:ListItem>
                                        <asp:ListItem>Mar</asp:ListItem>
                                        <asp:ListItem>Apr</asp:ListItem>
                                        <asp:ListItem>May</asp:ListItem>
                                        <asp:ListItem>Jun</asp:ListItem>
                                        <asp:ListItem>Jul</asp:ListItem>
                                        <asp:ListItem>Aug</asp:ListItem>
                                        <asp:ListItem>Sep</asp:ListItem>
                                        <asp:ListItem>Oct</asp:ListItem>
                                        <asp:ListItem>Nov</asp:ListItem>
                                        <asp:ListItem>Dec</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="DdlLastBillYear" runat="server" required="required" CssClass="form-control">
                                    </asp:DropDownList>
                                </div>


                            </div>
                            <div class="form-group">
                                <label>COMMENT:</label>
                                <asp:TextBox ID="TxtTerminateComment" runat="server" TextMode="MultiLine" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="btnTerminateSave" runat="server" Text="Save" CssClass="btn btn-success" Width="100px" OnClientClick="return confirm('You cannot undo once terminated. Are you sure to terminate?')" OnClick="btnTerminateSave_Click" />
                                <button type="button" class="btn btn-default" data-dismiss="modal" style="width: 100px">Close</button>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

    <div id="DlgExtend" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #a1a1a1; color: #ffffff">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">EXTEND TENANCY</h4>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                        <ContentTemplate>
                            <table>
                                <tr>
                                    <td style="padding: 10px">PERIOD</td>
                                    <td style="padding: 10px">
                                        <asp:TextBox ID="TxtPeriod" Width="50px" TextMode="Number" Text="0" runat="server" AutoPostBack="True" OnTextChanged="TxtPeriod_TextChanged"></asp:TextBox>
                                        <asp:DropDownList ID="DdlPeriodUnit" runat="server" Height="26px" AutoPostBack="True" OnSelectedIndexChanged="DdlPeriodUnit_SelectedIndexChanged">
                                            <asp:ListItem>Year</asp:ListItem>
                                            <asp:ListItem>Month</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <asp:GridView ID="GrvExtendSchedule" runat="server" AutoGenerateColumns="false" CssClass="table table-condensed" GridLines="None" OnDataBound="GrvExtendSchedule_DataBound">
                                <Columns>
                                    <asp:BoundField DataField="PERIOD1" HeaderText="FROM" DataFormatString="{0:dd/MMM/yy}" />
                                    <asp:BoundField DataField="PERIOD2" HeaderText="TO" DataFormatString="{0:dd/MMM/yy}" />
                                    <asp:TemplateField HeaderText="RENTAL / SERVICE-CHARGE">
                                        <ItemTemplate>
                                            <asp:TextBox ID="RentalTextBox" runat="server" required="required" TextMode="Number" step="any" min="1" Width="65px" Text='<%#Bind("AMOUNT", "{0:0.00}")%>'></asp:TextBox>
                                            <asp:TextBox ID="ServiceTextBox" runat="server" required="required" TextMode="Number" step="any" min="1" Width="65px" Text='<%#Bind("SERVICECHARGE", "{0:0.00}")%>'></asp:TextBox>
                                            <span class="small">
                                                <asp:Label ID="PerSqft1Label" runat="server" Text="0"></asp:Label>
                                                |
                                                <asp:Label ID="PerSqft2Label" runat="server" Text="0"></asp:Label>
                                                Per Sqft
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <div class="modal-footer">
                                <asp:Button ID="BtnExtendSave" runat="server" Text="Save" CssClass="btn btn-success" OnClick="BtnExtendSave_Click" OnClientClick="return confirm('Are you sure?')" Width="100px" />
                                <button type="button" class="btn btn-default" data-dismiss="modal" style="width: 100px">Close</button>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

