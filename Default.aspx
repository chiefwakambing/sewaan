<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="row">
                <div class="col-sm-6">
                    <img src="Logo.jpg" style="width: 30px; position: absolute; display: inline-block; top: 20px; left: -30px" />
                    <h2>eTenancy System</h2>
                </div>
                <div class="col-sm-6" style="text-align: right">
                    <div class="form-inline">
                        <asp:TextBox ID="TextBoxStartDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        To
                        <asp:TextBox ID="TextBoxEndDate" CssClass="form-control" runat="server" TextMode="Date"></asp:TextBox>
                        <asp:LinkButton ID="LinkButtonRefresh" runat="server" CssClass="btn btn-default" OnClick="LinkButtonRefresh_Click"><span class="glyphicon glyphicon-refresh"></span></asp:LinkButton>
                        <%--<asp:DropDownList ID="DropDownList2" CssClass="form-control-static" runat="server" AutoPostBack="true"></asp:DropDownList>--%>
                    </div>
                </div>
            </div>
            <br />
            <div style="border: 1px solid #dcdcdc; border-radius: 3px; padding: 5px">
                <div class="row">
                    <div class="col-sm-4">
                        <asp:GridView ID="GrvAging" GridLines="None" AutoGenerateColumns="false" runat="server" class="table">
                            <Columns>
                                <asp:BoundField DataField="30" HeaderText="30 DAYS" />
                                <asp:BoundField DataField="60" HeaderText="60 DAYS" />
                                <asp:BoundField DataField="90" HeaderText="90 DAYS" />
                                <asp:BoundField DataField="120" HeaderText="120 DAYS" />
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div class="col-sm-4">
                        <asp:GridView ID="GrvAnnualSummary" CssClass="table" runat="server" AutoGenerateColumns="False" DataSourceID="Sql02" GridLines="None" OnRowDataBound="GrvAnnualSummary_RowDataBound">
                            <Columns>
                                <asp:BoundField DataField="TotalBill" HeaderText="TOTAL BILL" ReadOnly="True" SortExpression="TotalBill" DataFormatString="{0:#,###,##0.00}" ItemStyle-ForeColor="#808080"></asp:BoundField>
                                <asp:BoundField DataField="TotalPaid" HeaderText="TOTAL PAID" ReadOnly="True" SortExpression="TotalPaid" DataFormatString="{0:#,###,##0.00}" ItemStyle-ForeColor="#808080"></asp:BoundField>
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
                        <asp:SqlDataSource ID="Sql02" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
                            SelectCommand="Select Sum(TotalBill) as TotalBill, Sum(TotalPaid) as TotalPaid, Sum(TotalPaid)/Sum(TotalBill)*100 as PercentPaid from Payment Where BillDate Between @StartDate And @EndDate">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="TextBoxStartDate" PropertyName="Text" Name="StartDate" />
                                <asp:ControlParameter ControlID="TextBoxEndDate" PropertyName="Text" Name="EndDate" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                    <div class="col-sm-4">
						
                        <asp:GridView ID="GridViewSqFt" CssClass="table" runat="server" AutoGenerateColumns="False" DataSourceID="SqlSqFt" GridLines="None" OnRowDataBound="GridViewSqFt_RowDataBound">
                            <Columns>
                                <asp:BoundField DataField="OccupancySquareFeet" HeaderText="OCCUPIED SQFT" ReadOnly="True" DataFormatString="{0:#,###,##0.00}"></asp:BoundField>
                                <asp:BoundField DataField="TotalSquareFeet" HeaderText="TOTAL SQFT" ReadOnly="True" DataFormatString="{0:#,###,##0.00}"></asp:BoundField>

                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <div style="position: absolute; display: inline-block; vertical-align: middle; width: 50px; height: 50px; line-height: 50px; text-align: center;">
                                            <asp:Label ID="LabelSqFtPercent" CssClass="text-center" runat="server" ForeColor="White"></asp:Label>

                                        </div>
                                        <asp:Chart ID="ChartSqft" runat="server" Width="50px" Height="50px">
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
						<span class="help-block small">Not inclusive of <i>Ladang,</i> <i>Parking</i> and <i>KHTP Sports Complex</i> </span>
                        <asp:SqlDataSource ID="SqlSqFt" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>" 
							SelectCommand="pSummary4" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <%--<asp:ControlParameter ControlID="DropDownList2" Name="Y" PropertyName="SelectedValue" Type="Int32" />--%>
                                <asp:ControlParameter ControlID="TextBoxStartDate" PropertyName="Text" Name="A" />
                                <asp:ControlParameter ControlID="TextBoxEndDate" PropertyName="Text" Name="B" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </div>
            </div>
            <br />

            <div class="row">
                <div class="col-sm-12">
                    <asp:GridView ID="GrvSummary" CssClass="table table-striped" runat="server" AutoGenerateColumns="False" DataSourceID="Sql01" GridLines="None" OnRowDataBound="GrvSummary_RowDataBound" OnDataBound="GrvSummary_DataBound">
                        <Columns>
                            <asp:BoundField DataField="BuildingOrArea" HeaderText="BUILDING OR AREA" SortExpression="BuildingOrArea" />
                            <asp:BoundField DataField="TotalBill" HeaderText="TOTAL BILL" ReadOnly="True" SortExpression="TotalBill" DataFormatString="{0:#,###,##0.00}" HeaderStyle-CssClass="text-right" ItemStyle-CssClass="text-right">
                                <HeaderStyle CssClass="text-right"></HeaderStyle>
                                <ItemStyle CssClass="text-right"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="TotalPaid" HeaderText="TOTAL PAID" ReadOnly="True" SortExpression="TotalPaid" DataFormatString="{0:#,###,##0.00}" HeaderStyle-CssClass="text-right" ItemStyle-CssClass="text-right">
                                <HeaderStyle CssClass="text-right"></HeaderStyle>
                                <ItemStyle CssClass="text-right"></ItemStyle>
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="PAID" SortExpression="PercentPaid">
                                <ItemTemplate>
                                    <div style="position: absolute; display: inline-block; vertical-align: middle; width: 50px; height: 50px; line-height: 50px; text-align: center;">
                                        <asp:Label ID="Label1" CssClass="text-center" runat="server" Text='<%#Eval("PercentPaid","{0:0\"%\"}")%>' ForeColor="White"></asp:Label>

                                    </div>
                                    <asp:Chart ID="ChartPaid" runat="server" Width="50px" Height="50px" BackColor="Transparent">
                                        <Series>
                                            <asp:Series Name="Series1" ChartType="Pie"></asp:Series>
                                        </Series>
                                        <ChartAreas>
                                            <asp:ChartArea Name="ChartArea1" BackColor="Transparent"></asp:ChartArea>
                                        </ChartAreas>
                                    </asp:Chart>
                                </ItemTemplate>

                            </asp:TemplateField>

                            <%-- <asp:BoundField DataField="OccupancyCount" HeaderText="OCCUPANCY COUNT" ReadOnly="True" SortExpression="TenancyCount" >
                                <HeaderStyle CssClass="text-right"></HeaderStyle>
                                <ItemStyle CssClass="text-right"></ItemStyle>
                            </asp:BoundField>--%>
                            <asp:TemplateField HeaderText="OCCUPANCY">
                                <ItemTemplate>
                                    <asp:Label ID="Label3" runat="server" Text='<%#Eval("OccupancySquareFeet","{0:#,###,##0.00}") %>'></asp:Label>
                                    Sqft.
                                    <br />
                                    <asp:Label ID="Label2" runat="server" ForeColor="#999999" Text='<%#Eval("OccupancyCount") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <%-- <asp:BoundField DataField="PropertyCount" HeaderText="PROPERTY COUNT" ReadOnly="True" SortExpression="PropertyCount" HeaderStyle-CssClass="text-right" ItemStyle-CssClass="text-right">
                                <HeaderStyle CssClass="text-right"></HeaderStyle>
                                <ItemStyle CssClass="text-right"></ItemStyle>
                            </asp:BoundField>--%>
                            <asp:TemplateField HeaderText="PROPERTY">
                                <ItemTemplate>
                                    <asp:Label ID="Label4" runat="server" Text='<%#Eval("TOTALSquareFeet","{0:#,###,##0.00}") %>'></asp:Label>
                                    Sqft.
                                    <br />
                                    <asp:Label ID="Label5" runat="server" ForeColor="#999999" Text='<%#Eval("PropertyCount") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="OCCUPANCY">
                                <ItemTemplate>
                                    <div style="position: absolute; display: inline-block; vertical-align: middle; width: 50px; height: 50px; line-height: 50px; text-align: center;">
                                        <asp:Label ID="LabelOccupancy" runat="server" ForeColor="White"></asp:Label>
                                    </div>
                                    <asp:Chart ID="ChartOccupancy" runat="server" Width="50px" Height="50px" BackColor="Transparent">
                                        <Series>
                                            <asp:Series Name="Series1" ChartType="Pie"></asp:Series>
                                        </Series>
                                        <ChartAreas>
                                            <asp:ChartArea Name="ChartArea1" BackColor="Transparent"></asp:ChartArea>
                                        </ChartAreas>
                                    </asp:Chart>
                                </ItemTemplate>
                                <HeaderStyle CssClass="text-right" />
                                <ItemStyle CssClass="text-right" />
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="Sql01" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>" SelectCommand="pSummary3" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <%--<asp:ControlParameter ControlID="DropDownList2" Name="Y" PropertyName="SelectedValue" Type="Int32" />--%>
                            <asp:ControlParameter ControlID="TextBoxStartDate" PropertyName="Text" Name="A" />
                            <asp:ControlParameter ControlID="TextBoxEndDate" PropertyName="Text" Name="B" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </div>
            <br />

            <h4><%=DateTime.Now.Year%></h4>

            <div class="row">
                <div class="col-sm-4">
                    <div style="border: 1px solid #dcdcdc; padding: 5px">
                        <h4>January <asp:Label ID="LblAging1" runat="server" Text="Label"></asp:Label></h4>
                        <asp:GridView ID="GrvAging1" Width="100%" CssClass="table small" GridLines="None" AutoGenerateColumns="false" runat="server">
                            <Columns>
                                <asp:BoundField DataField="30" HeaderText="30 DAYS" />
                                <asp:BoundField DataField="60" HeaderText="60 DAYS" />
                                <asp:BoundField DataField="90" HeaderText="90 DAYS" />
                                <asp:BoundField DataField="120" HeaderText="120 DAYS" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div style="border: 1px solid #dcdcdc; padding: 5px">
                        <h4>February <asp:Label ID="LblAging2" runat="server" Text="Label"></asp:Label></h4>
                        <asp:GridView ID="GrvAging2" Width="100%" CssClass="table small" GridLines="None" AutoGenerateColumns="false" runat="server">
                            <Columns>
                                <asp:BoundField DataField="30" HeaderText="30 DAYS" />
                                <asp:BoundField DataField="60" HeaderText="60 DAYS" />
                                <asp:BoundField DataField="90" HeaderText="90 DAYS" />
                                <asp:BoundField DataField="120" HeaderText="120 DAYS" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div style="border: 1px solid #dcdcdc; padding: 5px">
                        <h4>March <asp:Label ID="LblAging3" runat="server" Text="Label"></asp:Label></h4>
                        <asp:GridView ID="GrvAging3" Width="100%" CssClass="table small" GridLines="None" AutoGenerateColumns="false" runat="server">
                            <Columns>
                                <asp:BoundField DataField="30" HeaderText="30 DAYS" />
                                <asp:BoundField DataField="60" HeaderText="60 DAYS" />
                                <asp:BoundField DataField="90" HeaderText="90 DAYS" />
                                <asp:BoundField DataField="120" HeaderText="120 DAYS" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <br />
            <div class="row">
                <div class="col-sm-4">
                    <div style="border: 1px solid #dcdcdc; padding: 5px">
                        <h4>April <asp:Label ID="LblAging4" runat="server" Text="Label"></asp:Label></h4>
                        <asp:GridView ID="GrvAging4" Width="100%" CssClass="table small" GridLines="None" AutoGenerateColumns="false" runat="server">
                            <Columns>
                                <asp:BoundField DataField="30" HeaderText="30 DAYS" />
                                <asp:BoundField DataField="60" HeaderText="60 DAYS" />
                                <asp:BoundField DataField="90" HeaderText="90 DAYS" />
                                <asp:BoundField DataField="120" HeaderText="120 DAYS" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div style="border: 1px solid #dcdcdc; padding: 5px">
                        <h4>May <asp:Label ID="LblAging5" runat="server" Text="Label"></asp:Label></h4>
                        <asp:GridView ID="GrvAging5" Width="100%" CssClass="table small" GridLines="None" AutoGenerateColumns="false" runat="server">
                            <Columns>
                                <asp:BoundField DataField="30" HeaderText="30 DAYS" />
                                <asp:BoundField DataField="60" HeaderText="60 DAYS" />
                                <asp:BoundField DataField="90" HeaderText="90 DAYS" />
                                <asp:BoundField DataField="120" HeaderText="120 DAYS" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div style="border: 1px solid #dcdcdc; padding: 5px">
                        <h4>June <asp:Label ID="LblAging6" runat="server" Text="Label"></asp:Label></h4>
                        <asp:GridView ID="GrvAging6" Width="100%" CssClass="table small" GridLines="None" AutoGenerateColumns="false" runat="server">
                            <Columns>
                                <asp:BoundField DataField="30" HeaderText="30 DAYS" />
                                <asp:BoundField DataField="60" HeaderText="60 DAYS" />
                                <asp:BoundField DataField="90" HeaderText="90 DAYS" />
                                <asp:BoundField DataField="120" HeaderText="120 DAYS" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <br />
            <div class="row">
                <div class="col-sm-4">
                    <div style="border: 1px solid #dcdcdc; padding: 5px">
                        <h4>July <asp:Label ID="LblAging7" runat="server" Text="Label"></asp:Label></h4>
                        <asp:GridView ID="GrvAging7" Width="100%" CssClass="table small" GridLines="None" AutoGenerateColumns="false" runat="server">
                            <Columns>
                                <asp:BoundField DataField="30" HeaderText="30 DAYS" />
                                <asp:BoundField DataField="60" HeaderText="60 DAYS" />
                                <asp:BoundField DataField="90" HeaderText="90 DAYS" />
                                <asp:BoundField DataField="120" HeaderText="120 DAYS" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div style="border: 1px solid #dcdcdc; padding: 5px">
                        <h4>August <asp:Label ID="LblAging8" runat="server" Text="Label"></asp:Label></h4>
                        <asp:GridView ID="GrvAging8" Width="100%" CssClass="table small" GridLines="None" AutoGenerateColumns="false" runat="server">
                            <Columns>
                                <asp:BoundField DataField="30" HeaderText="30 DAYS" />
                                <asp:BoundField DataField="60" HeaderText="60 DAYS" />
                                <asp:BoundField DataField="90" HeaderText="90 DAYS" />
                                <asp:BoundField DataField="120" HeaderText="120 DAYS" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div style="border: 1px solid #dcdcdc; padding: 5px">
                        <h4>September <asp:Label ID="LblAging9" runat="server" Text="Label"></asp:Label></h4>
                        <asp:GridView ID="GrvAging9" Width="100%" CssClass="table small" GridLines="None" AutoGenerateColumns="false" runat="server">
                            <Columns>
                                <asp:BoundField DataField="30" HeaderText="30 DAYS" />
                                <asp:BoundField DataField="60" HeaderText="60 DAYS" />
                                <asp:BoundField DataField="90" HeaderText="90 DAYS" />
                                <asp:BoundField DataField="120" HeaderText="120 DAYS" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <br />
            <div class="row">
                <div class="col-sm-4">
                    <div style="border: 1px solid #dcdcdc; padding: 5px">
                        <h4>October <asp:Label ID="LblAging10" runat="server" Text="Label"></asp:Label></h4>
                        <asp:GridView ID="GrvAging10" Width="100%" CssClass="table small" GridLines="None" AutoGenerateColumns="false" runat="server">
                            <Columns>
                                <asp:BoundField DataField="30" HeaderText="30 DAYS" />
                                <asp:BoundField DataField="60" HeaderText="60 DAYS" />
                                <asp:BoundField DataField="90" HeaderText="90 DAYS" />
                                <asp:BoundField DataField="120" HeaderText="120 DAYS" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div style="border: 1px solid #dcdcdc; padding: 5px">
                        <h4>November <asp:Label ID="LblAging11" runat="server" Text="Label"></asp:Label></h4>
                        <asp:GridView ID="GrvAging11" Width="100%" CssClass="table small" GridLines="None" AutoGenerateColumns="false" runat="server">
                            <Columns>
                                <asp:BoundField DataField="30" HeaderText="30 DAYS" />
                                <asp:BoundField DataField="60" HeaderText="60 DAYS" />
                                <asp:BoundField DataField="90" HeaderText="90 DAYS" />
                                <asp:BoundField DataField="120" HeaderText="120 DAYS" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div style="border: 1px solid #dcdcdc; padding: 5px">
                        <h4>December <asp:Label ID="LblAging12" runat="server" Text="Label"></asp:Label></h4>
                        <asp:GridView ID="GrvAging12" Width="100%" CssClass="table small" GridLines="None" AutoGenerateColumns="false" runat="server">
                            <Columns>
                                <asp:BoundField DataField="30" HeaderText="30 DAYS" />
                                <asp:BoundField DataField="60" HeaderText="60 DAYS" />
                                <asp:BoundField DataField="90" HeaderText="90 DAYS" />
                                <asp:BoundField DataField="120" HeaderText="120 DAYS" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <br />

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
