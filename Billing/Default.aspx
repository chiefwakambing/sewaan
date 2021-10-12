<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Billings_Default" %>

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
            $("#BILLING").addClass("active");
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>

            <div class="row">
                <div class="col-sm-6">
                    <img src="/Logo.jpg" style="width: 30px; position: absolute; display: inline-block; top: 20px; left: -30px" />
                    <h2>BILLING
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
                    <asp:Button ID="BtnOkay" runat="server" Text="Show" CssClass="btn btn-default" Width="100px" />
                </div>
            </div>

            <div class="row">
                <div class="col-sm-6">
                    <%--<p>Total Billed: <span style="color: blue">RM<asp:Label ID="LabelTotalBill" runat="server" Text="0.00"></asp:Label></span></p>--%>
                    <asp:GridView ID="GridView1" runat="server" CssClass="table table-condensed" GridLines="None"></asp:GridView>
                </div>
            </div>
            <br />
            <asp:DataList ID="DataList1" runat="server" DataSourceID="Sql02" Width="100%">
                <ItemTemplate>

                    <div class="row">
                        <div class="col-sm-12">
                            <asp:Label ID="lblBuildingOrArea" ForeColor="#706c98" CssClass="h3" runat="server" Text='<%#Eval("BuildingOrArea")%>'></asp:Label>

                            <asp:GridView ID="GrvBilling" runat="server" ShowFooter="true" CssClass="table table-condensed table-hover" AutoGenerateColumns="False" DataKeyNames="Id, PaymentId, BillingTransaction, Amount, ServiceCharge, Waiver, WaiverUnit, TenancyFrom, BillDate, ElecBillDate" DataSourceID="Sql01" GridLines="None" OnRowDataBound="GrvBilling_RowDataBound" OnSelectedIndexChanged="GrvBilling_SelectedIndexChanged" OnDataBound="GrvBilling_DataBound">
                                <Columns>
                                    <asp:TemplateField HeaderText="CUSTOMER" ItemStyle-Width="450px" ItemStyle-CssClass="VerticallyCentred">
                                        <ItemTemplate>
                                            <asp:Label ID="LblCustomer" runat="server" Text='<%#Eval("Customer")%>' ForeColor="#706c98"></asp:Label>
                                            <br />
                                            <span class="glyphicon glyphicon-calendar small <%# Eval("Expiry").ToString() != "" && int.Parse(Eval("Expiry").ToString()) <= 6 ? "text-danger" : "" %> "></span>
                                            <asp:Label ID="Label1" runat="server" CssClass="small" Text='<%#Eval("TenancyFrom", "{0:dd/MMM/yy}")%>'></asp:Label>
                                            -
                                            <asp:Label ID="Label3" runat="server" CssClass="small" Text='<%#Eval("TenancyTo", "{0:dd/MMM/yy}")%>'></asp:Label>
                                            &nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-home small"></span>
                                            <asp:Label ID="LblLot" runat="server" CssClass="small" Text='<%#Eval("Lot")%>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="AccountCode" HeaderText="ACC CODE" SortExpression="AccountCode" ItemStyle-VerticalAlign="Middle" />
                                    <asp:TemplateField HeaderText="BILLING DETAIL">
                                        <ItemTemplate>
                                            <asp:Literal ID="Literal1" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="TOTALBILL" HeaderText="NET AMOUNT" DataFormatString="{0:#,##0.00}" />
                                    <asp:BoundField DataField="BILLDATE" HeaderText="BILL DATE" DataFormatString="{0: dd/MMM/yy}" />
                                    <asp:BoundField DataField="BILLCREATEDDATE" HeaderText="CREATED ON" DataFormatString="{0: dd/MMM/yy}" />
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:Button ID="BtnIssueEdit" CssClass="btn btn-danger" Enabled='<%#(bool)Session["IsContribute"] %>' runat="server" Text="Issue/Edit" Width="100px" CommandName="Select" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p>No bill(s) to issue.</p>
                                </EmptyDataTemplate>
                                
                            </asp:GridView>
                            <asp:SqlDataSource ID="Sql01" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
                                SelectCommand="pBilling @MonthOfPayment, @YearOfPayment, @BuildingOrArea">
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
            <asp:SqlDataSource ID="Sql02" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
                SelectCommand="SELECT DISTINCT [BuildingOrArea] FROM [PROPERTY] ORDER BY [BuildingOrArea]"></asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>

    <div id="IssueBillDialog" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #a1a1a1; color: #ffffff">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title"><span class="glyphicon glyphicon-check"></span>ISSUE A BILL</h4>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <div class="row">
                                <div class="col-sm-12">
                                    <asp:Label ID="LblCustomer" runat="server" CssClass="h3" Text=""></asp:Label>
                                    <br />
                                    <span>BILLING:<asp:Label ID="LblBill" runat="server" Text=""></asp:Label></span>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-sm-12 small" style="text-align: right">
                                    <div style="padding: 5px; border: 1px solid #808080; border-radius: 5px">
                                        
                                        ELEC. BILL DATE:<asp:TextBox ID="TxtElecBillDate" CssClass="form-control-static" TextMode="Date" runat="server"></asp:TextBox>
                                        BILL DATE:<asp:TextBox ID="TxtBillDate" CssClass="form-control-static" TextMode="Date" runat="server"></asp:TextBox>

                                    </div>
                                </div>
                            </div>
                            <br />

                            <asp:GridView ID="GrvIssueBill" runat="server" AutoGenerateColumns="false" CssClass="table" GridLines="None">
                                <Columns>
                                    <asp:TemplateField HeaderText="ITEM">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TxtItem" runat="server" CssClass="form-control text-capitalize" Text='<%#Bind("ITEM")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="AMOUNT">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TxtAmount" CssClass="form-control" runat="server" Text='<%#Bind("AMOUNT", "{0:#,##0.00}")%>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="GST">
                                        <ItemTemplate>
                                            <label class="switch">
                                                <asp:CheckBox ID="ChkGst" runat="server" Checked='<%# Eval("GST")%>' />
                                                <span class="slider round"></span>
                                            </label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <hr />
                            <div style="text-align: right">
                                <asp:Button ID="BtnIssueBillSave" runat="server" CssClass="btn btn-success" Text="Save" OnClick="BtnIssueBillSave_Click" Width="100px" />
                                <asp:Button ID="BtnClose" runat="server" CssClass="btn btn-default" Text="Close" data-dismiss="modal" Width="100px" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                </div>


            </div>
        </div>
    </div>


</asp:Content>

