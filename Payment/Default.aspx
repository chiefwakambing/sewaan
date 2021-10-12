<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="PAYMENT_Default" %>
<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
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

    <script>
        $(document).ready(function () {
            $("#PAYMENT").addClass("active");
        })
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <div class="row">
                <div class="col-sm-6">
                    <img src="/Logo.jpg" style="width: 30px; position: absolute; display: inline-block; top: 20px; left: -30px" />
                    <h2>PAYMENT
                        <asp:Label ID="LabelBilling" runat="server" Text=""></asp:Label></h2>
                </div>
                <div class="form-inline col-sm-6" style="text-align: right">
                    <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-control">
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
                    <asp:DropDownList ID="DropDownList2" runat="server" CssClass="form-control"></asp:DropDownList>
                    <asp:Button ID="BtnOkay" runat="server" Text="Show" CssClass="btn btn-default" OnClick="BtnOkay_Click" Width="100px" />
                </div>
            </div>
            <br />
            <div class="row">
                <div class="col-sm-4">
                    <asp:GridView ID="GrvAging" Width="100%" GridLines="None" AutoGenerateColumns="false" runat="server" CssClass="table">
                        <Columns>
                            <asp:BoundField DataField="30" HeaderText="30 DAYS" />
                            <asp:BoundField DataField="60" HeaderText="60 DAYS" />
                            <asp:BoundField DataField="90" HeaderText="90 DAYS" />
                            <asp:BoundField DataField="120" HeaderText="120 DAYS" />
                        </Columns>
                    </asp:GridView>
                </div>
                <div class="col-sm-4">
                    <asp:GridView ID="GrvSummary" Width="100%" runat="server" AutoGenerateColumns="False" DataSourceID="Sql01" GridLines="None" OnRowDataBound="GrvSummary_RowDataBound" CssClass="table">
                        <Columns>
                            <asp:BoundField DataField="TotalBill" HeaderText="TOTAL BILL" ReadOnly="True" SortExpression="TotalBill" DataFormatString="{0:#,###,##0.00}"></asp:BoundField>
                            <asp:BoundField DataField="TotalPaid" HeaderText="TOTAL PAID" ReadOnly="True" SortExpression="TotalPaid" DataFormatString="{0:#,###,##0.00}" ItemStyle-ForeColor="Blue"></asp:BoundField>
                            <asp:BoundField DataField="BALANCE" HeaderText="BALANCE" ReadOnly="True" SortExpression="BALANCE" DataFormatString="{0:#,###,##0.00}" ItemStyle-ForeColor="Red"></asp:BoundField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <div style="position: absolute; display: inline-block; vertical-align: middle; width: 50px; height: 50px; line-height: 50px; text-align: center;">
                                        <asp:Label ID="Label1" CssClass="text-center" runat="server" Text='<%#Eval("PercentPaid","{0:0\"%\"}")%>' ForeColor="White"></asp:Label>

                                    </div>
                                    <asp:Chart ID="ChartPaid" runat="server" Width="50px" Height="50px">
                                        <Series>
                                            <asp:Series Name="Series1" ChartType="Pie"></asp:Series>
                                        </Series>
                                        <ChartAreas>
                                            <asp:ChartArea Name="ChartArea1"></asp:ChartArea>
                                        </ChartAreas>
                                    </asp:Chart>
                                </ItemTemplate>

                            </asp:TemplateField>
                        </Columns>

                    </asp:GridView>
                    <asp:SqlDataSource ID="Sql01" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>" SelectCommand="Select Sum(TotalBill) as TotalBill, Sum(TotalPaid) as TotalPaid, Sum(TotalPaid)/Sum(TotalBill)*100 as PercentPaid, Sum(TotalBill)-Sum(TotalPaid) as Balance from Payment Where BillMonth=@MonthOfPayment and BillYear=@YearOfPayment ">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="DropDownList1" Type="Int32" Name="MonthOfPayment" />
                            <asp:ControlParameter ControlID="DropDownList2" Type="Int32" Name="YearOfPayment" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>

            </div>

            <br />
            <asp:DataList ID="DataList1" runat="server" DataSourceID="Sql03" Width="100%">
                <ItemTemplate>

                    <div class="row">
                        <div class="col-sm-12">
                            <asp:Label ID="lblBuildingOrArea" ForeColor="#706c98" CssClass="h3" runat="server" Text='<%#Eval("BuildingOrArea")%>'></asp:Label>

                            <asp:GridView ID="GrvPayment" runat="server" DataSourceID="Sql02" GridLines="None" AutoGenerateColumns="false" CssClass="table table-condensed table-hover" DataKeyNames="Id, PaymentTransaction, BillingTransaction" OnSelectedIndexChanged="GrvPayment_SelectedIndexChanged" OnRowDataBound="GrvPayment_RowDataBound">
                                <Columns>
                                    <asp:TemplateField HeaderText="CUSTOMER" ItemStyle-Width="500px">
                                        <ItemTemplate>
                                            <asp:Label ID="LblCustomer" runat="server" ForeColor="#706c98" Text='<%#Eval("Customer")%>'></asp:Label>
                                            <br />
                                            &nbsp<span class="small glyphicon glyphicon-home"></span>
                                            <asp:Label ID="Label2" runat="server" CssClass="small" Text='<%#Eval("BuildingOrArea")%>'></asp:Label>,<asp:Label ID="LblLot" runat="server" CssClass="small" Text='<%#Eval("Lot")%>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="TotalBill" HeaderText="BILL AMOUNT" DataFormatString="{0:#,###,##0.00}" ItemStyle-CssClass="VerticallyCentred" ItemStyle-Width="200px" />
                                    <asp:BoundField DataField="TotalPaid" HeaderText="PAID AMOUNT" DataFormatString="{0:#,###,##0.00}" />
                                    <asp:BoundField DataField="Status" HeaderText="STATUS" ItemStyle-CssClass="VerticallyCentred" />
                                    <asp:TemplateField HeaderText="PAID DATE" ItemStyle-CssClass="VerticallyCentred">
                                        <ItemTemplate>
                                            <asp:Label ID="LblPaymentDate" runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:Button ID="Button1" runat="server" Text="Payment" Enabled='<%#(bool)Session["IsContribute"] %>' CommandName="Select" CssClass="btn btn-default" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p>No payment(s) to issue.</p>
                                </EmptyDataTemplate>
                            </asp:GridView>
                            <asp:SqlDataSource ID="Sql02" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
                                SelectCommand="Select Lot, BuildingOrArea, Customer, P.* from Payment P inner join vTenancy2 T on T.Id = P.TenancyId where BillMonth=@MonthOfPayment and BillYear=@YearOfPayment And BuildingOrArea=@BuildingOrArea order by Status Desc, Customer">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="DropDownList1" Type="Int32" Name="MonthOfPayment" />
                                    <asp:ControlParameter ControlID="DropDownList2" Type="Int32" Name="YearOfPayment" />
                                    <asp:ControlParameter ControlID="lblBuildingOrArea" Name="BuildingOrArea" PropertyName="Text" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>
                    </div>
                    <br />
                    <br />
                </ItemTemplate>
            </asp:DataList>
            <asp:SqlDataSource ID="Sql03" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
                SelectCommand="SELECT DISTINCT [BuildingOrArea] FROM [PROPERTY] ORDER BY [BuildingOrArea]"></asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>

    <div id="MakePaymentDialog" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #a1a1a1; color: #ffffff">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title"><span class="glyphicon glyphicon-comment"></span>MAKE PAYMENT</h4>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                        <ContentTemplate>
                            <asp:Label ID="LblCustomer" runat="server" CssClass="h3" Text=""></asp:Label>
                            <br />
                            <asp:Label ID="LblPayment" runat="server" Text=""></asp:Label>
                            <asp:Label ID="LblId" runat="server" Text="" Visible="false"></asp:Label>
                            <br />
                            <br />
                            <p style="color: #706c98">Billing Info:</p>
                            <asp:GridView ID="GrvBill" runat="server" FooterStyle-Font-Bold="true" AutoGenerateColumns="false" CssClass="table table-condensed table-striped small" GridLines="None" ShowFooter="true" FooterStyle-HorizontalAlign="Right">
                                <Columns>
                                    <asp:BoundField DataField="ITEM" HeaderText="ITEM" />
                                    <asp:BoundField DataField="AMOUNT" HeaderText="AMOUNT" DataFormatString="{0:#,###,##0.00}" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="text-right" />
                                    <asp:BoundField DataField="GST" HeaderText="GST" DataFormatString="{0:#,###,##0.00}" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="text-right" />
                                </Columns>
                            </asp:GridView>

                            <p style="color: #706c98">Payment Info:</p>
                            <asp:GridView ID="GrvMakePayment" runat="server" AutoGenerateColumns="false" CssClass="table" GridLines="None">
                                <Columns>
                                    <asp:TemplateField HeaderText="DATE">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TxtPaymentDate" runat="server" Width="150px" Text='<%#Bind("PAYMENTDATE","{0:yyyy-MM-dd}")%>' TextMode="Date"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="AMOUNT">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TxtAmount" runat="server" Width="100px" TextMode="Number" step="any" Text='<%#Bind("AMOUNT", "{0:0.00}")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="REMARK">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TxtRemark" runat="server" Text='<%#Bind("REMARK")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <hr />
                            <div style="text-align: right">
                                <asp:Button ID="BtnMakePaymentSave" runat="server" CssClass="btn btn-success" Text="Save" OnClick="BtnMakePaymentSave_Click" Width="100px" />
                                <asp:Button ID="BtnClose" runat="server" CssClass="btn btn-default" Text="Close" data-dismiss="modal" Width="100px" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                </div>


            </div>
        </div>
    </div>

</asp:Content>

