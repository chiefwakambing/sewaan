<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="New.aspx.cs" Inherits="Tenancy_New" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" href="/Css/jquery-ui.min.css" />
    <script src="/Js/jquery-ui.min.js"></script>


    <script>
        $(document).ready(function () {
            $("#TENANCY").addClass("active");
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


        function ShowDatePicker() {
            $("#<%=TxtTenancyStart.ClientID%>").datepicker();
            $("#<%=TxtTenancyStart.ClientID%>").datepicker("option", "dateFormat", "dd/M/y");

            var Today = new Date();
            if (Today.getDate() > 20) Today.setMonth(Today.getMonth() + 1);
            $("#<%=TxtTenancyStart.ClientID%>").val("01/" + Today.format("MMM/y"));
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <p>TENANCY <span class="glyphicon glyphicon-chevron-right"></span></p>
            <h2>CREATE NEW
            </h2>
            <br />
            <div class="row">
                <div class="col-sm-4">
                    <p><strong>DETAIL</strong> </p>

                    <!--Supporting Controls-->
                    <div style="display: none">
                        <asp:TextBox ID="TextBoxSquareFeet" runat="server"></asp:TextBox>
                        <asp:TextBox ID="TextBoxRental" runat="server"></asp:TextBox>
                        <asp:TextBox ID="TextBoxPropertyId" runat="server"></asp:TextBox>
                    </div>
                    <!----------------------->


                    <table class="table table-condensed">
                        <tr>
                            <td>PROPERTY</td>
                            <td>
                                <div style="float: right">
                                    <asp:LinkButton ID="LinkButton1" href="#" CssClass="btn btn-default" runat="server" data-toggle="modal" data-target="#DlgPickProperty"><span class="glyphicon glyphicon-pencil"></span></asp:LinkButton>
                                </div>
                                <asp:Label ID="LblBuildingOrArea" runat="server" Text='<%#Eval("BuildingOrArea") %>'></asp:Label>
                                <br />
                                <asp:Label ID="LblLot" runat="server" CssClass="small" Text='<%#Eval("Lot") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>CUSTOMER</td>
                            <td>
                                <div style="float: right">
                                    <asp:LinkButton ID="LinkButton2" href="#" CssClass="btn btn-default" runat="server" data-toggle="modal" data-target="#DlgPickCustomer"><span class="glyphicon glyphicon-pencil"></span></asp:LinkButton>
                                </div>

                                <asp:Label ID="LblCustomer" runat="server" Text='<%#Eval("Customer") %>'></asp:Label>

                            </td>
                        </tr>
                        <tr>
                            <td>TENANCY FROM</td>
                            <td>
                                <asp:TextBox ID="TxtTenancyStart" runat="server" OnTextChanged="TxtTenancyStart_TextChanged"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>PERIOD</td>
                            <td>
                                <asp:TextBox ID="TxtPeriod" Width="50px" TextMode="Number" Text="1" runat="server" AutoPostBack="True" OnTextChanged="TxtPeriod_TextChanged"></asp:TextBox>
                                <asp:DropDownList ID="DdlPeriodUnit" runat="server" Height="26px" AutoPostBack="True" OnSelectedIndexChanged="DdlPeriodUnit_SelectedIndexChanged">
                                    <asp:ListItem>Year</asp:ListItem>
                                    <asp:ListItem>Month</asp:ListItem>
                                </asp:DropDownList>

                            </td>
                        </tr>
                        <tr>
                            <td>ACC. CODE</td>
                            <td>
                                <asp:TextBox ID="TxtAccountCode" Width="155px" runat="server" Text='<%#Eval("AccountCode") %>'></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>WAIVER</td>
                            <td>
                                <asp:TextBox ID="TxtWaiver" runat="server" Width="50px" TextMode="Number" Text="0"></asp:TextBox>
                                Month(s)</td>
                        </tr>
                        <tr>
                            <td>WAIVE UNIT</td>
                            <td>

                                <asp:DropDownList ID="DdlWaiverUnit" runat="server" Height="26px">
                                    <asp:ListItem Value="1">Rental</asp:ListItem>
                                    <asp:ListItem Value="2">Sevice</asp:ListItem>
                                    <asp:ListItem Value="3">Rental+Service</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="col-sm-3">
                    <p><strong>DEPOSIT</strong> </p>
                    <table class="table table-condensed">
                        <tr>
                            <td>SECURITY</td>
                            <td>
                                <asp:TextBox ID="TxtDeposit01" Width="65px" TextMode="Number" Text="0" step="any" runat="server"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>UTILITY</td>
                            <td>
                                <asp:TextBox ID="TxtDeposit02" Width="65px" TextMode="Number" Text="0" step="any" runat="server"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>MAILBOX</td>
                            <td>
                                <asp:TextBox ID="TxtDeposit03" Width="65px" TextMode="Number" Text="0" step="any" runat="server"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>RENOVATION</td>
                            <td>
                                <asp:TextBox ID="TxtDeposit04" Width="65px" TextMode="Number" Text="0" step="any" runat="server"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>RESTORATION</td>
                            <td>
                                <asp:TextBox ID="TxtDeposit05" Width="65px" TextMode="Number" Text="0" step="any" runat="server"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <br />
                                <strong>COMMENT / NOTE</strong>
                                <asp:TextBox ID="TxtComment" runat="server" TextMode="MultiLine" Width="100%"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="col-sm-5">
                    <strong>PAYMENT SCHEDULE</strong>
                    <asp:GridView ID="GrvPaymentSchedule" runat="server" AutoGenerateColumns="false" CssClass="table table-condensed" GridLines="None" OnDataBound="GrvPaymentSchedule_DataBound">
                        <Columns>
                            <asp:BoundField DataField="PERIOD1" HeaderText="FROM" DataFormatString="{0:dd/MMM/yy}" />
                            <asp:BoundField DataField="PERIOD2" HeaderText="TO" DataFormatString="{0:dd/MMM/yy}" />
                            <asp:TemplateField HeaderText="RENTAL / SERVICE-CHARGE">
                                <ItemTemplate>
                                    <asp:TextBox ID="RentalTextBox" runat="server" required="required" TextMode="Number" step="any" min="0" Width="65px" Text='<%#Eval("AMOUNT", "{0:0.00}")%>'></asp:TextBox>
                                    <asp:TextBox ID="ServiceTextBox" runat="server" required="required" TextMode="Number" step="any" min="0" Width="65px" Text='<%#Eval("SERVICECHARGE", "{0:0.00}")%>'></asp:TextBox>
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
            <div style="float: right">
                <asp:Button ID="BtnSaveTenancy" runat="server" Text="Save" CssClass="btn btn-success" OnClientClick="return confirm('Are you sure?')" OnClick="BtnSaveTenancy_Click" Width="100px" />
            </div>
            <br />
            <br />
            <br />

            <asp:SqlDataSource ID="Sql01" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
                SelectCommand="select A.*,(select OrganizationName from Customer where Id=A.CustomerId) as Customer,(Select BuildingOrArea from PROPERTY Where Id=B.PropertyId) as BuildingOrArea,(Select Lot from PROPERTY Where Id=B.PropertyId) as Lot, (Select SquareFeet from PROPERTY Where Id=B.PropertyId) as SquareFeet from TENANCY A inner join TENANCY_PROPERTY B on A.Id = B.TenancyId WHERE A.ID=@ID">
                <SelectParameters>
                    <asp:QueryStringParameter Name="ID" QueryStringField="Id" />
                </SelectParameters>
            </asp:SqlDataSource>

        </ContentTemplate>
    </asp:UpdatePanel>

    <div id="DlgPickProperty" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title">Select a Property</h4>
                        </div>
                        <div class="modal-body">

                            <div class="row">
                                <div class="col-sm-12">
                                    <asp:DropDownList ID="DdlPickBuilding" CssClass="form-control" runat="server" DataSourceID="SqlPickBuilding" DataValueField="BuildingOrArea" AutoPostBack="true"></asp:DropDownList>
                                </div>
                            </div>
                            <asp:SqlDataSource ID="SqlPickBuilding" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
                                SelectCommand="SELECT DISTINCT BUILDINGORAREA FROM PROPERTY"></asp:SqlDataSource>
                            <br />

                            <asp:GridView ID="GrvPickProperty" SelectedRowStyle-BackColor="#ccff99" CssClass="table table-condensed table-hover" GridLines="None" runat="server" AutoGenerateColumns="False" DataKeyNames="Id, Rental, SquareFeet, BuildingOrArea, Lot" DataSourceID="SqlPickProperty" OnSelectedIndexChanged="GrvPickProperty_SelectedIndexChanged">
                                <Columns>
                                    <%--<asp:CommandField ShowSelectButton="True" ItemStyle-Width="10px">
                                        <ControlStyle CssClass="btn btn-default" />
                                    </asp:CommandField>--%>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CheckBoxPickProperty" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Building / Area" DataField="BuildingOrArea" />
                                    <asp:BoundField HeaderText="Lot" DataField="Lot" />
                                    <asp:BoundField HeaderText="Advertised Rent" DataField="Rental" DataFormatString="{0:#,###,##0.00}" />
                                    <asp:BoundField HeaderText="SqFt" DataField="SquareFeet" />
                                    <%--<asp:TemplateField HeaderText="PROPERTY">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%#Eval("BuildingOrArea")%>' Font-Size="9pt"></asp:Label>
                                            <br />
                                            <asp:Label ID="Label2" runat="server" Text='<%#Eval("Lot")%>' Font-Size="8pt"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>
                                </Columns>
                            </asp:GridView>
                            <br />

                            <asp:SqlDataSource ID="SqlPickProperty" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>" SelectCommand="SELECT Distinct [Id], [BuildingOrArea], [Lot], [Rental], [SquareFeet] FROM [vPROPERTY] WHERE BuildingOrArea=@BuildingOrArea And (Occupied=0 Or Terminate=1) Order By Lot">
                                <SelectParameters>
                                    <asp:ControlParameter Name="BuildingOrArea" ControlID="DdlPickBuilding" PropertyName="SelectedValue" />
                                </SelectParameters>
                            </asp:SqlDataSource>

                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="ButtonPickPropertyAccept" runat="server" Text="Accept" CssClass="btn btn-primary" OnClick="ButtonPickPropertyAccept_Click" />
                        </div>

                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <div id="DlgPickCustomer" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Select a Customer</h4>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                        <ContentTemplate>
                            <asp:GridView ID="GrvPickCustomer" SelectedRowStyle-BackColor="#ccff99" CssClass="table table-condensed" GridLines="None" runat="server" AutoGenerateColumns="False" DataKeyNames="Id, OrganizationName" DataSourceID="SqlPickCustomer" OnSelectedIndexChanged="GrvPickCustomer_SelectedIndexChanged">
                                <Columns>
                                    <asp:CommandField ShowSelectButton="True" ItemStyle-Width="10px">
                                        <ControlStyle CssClass="btn btn-default" />
                                    </asp:CommandField>
                                    <asp:TemplateField HeaderText="CUSTOMER">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%#Eval("OrganizationName")%>' Font-Size="9pt"></asp:Label>
                                            <br />
                                            <asp:Label ID="Label2" runat="server" Text='<%#Eval("PersonToContact")%>' Font-Size="8pt"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="SqlPickCustomer" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>" SelectCommand="SELECT [Id], [PersonToContact], [OrganizationName] FROM [CUSTOMER] ORDER BY [OrganizationName]"></asp:SqlDataSource>

                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

