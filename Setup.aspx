<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Setup.aspx.cs" Inherits="Setup" %>

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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>

            <div class="row">
                <div class="col-sm-8">
                    <h2>USER ACCESS CONTROL</h2>
                </div>
                <div class="col-sm-4">
                    <div style="float:right">
                        <a href="Log.aspx" data-toggle="tooltip" data-placement="bottom" title="View Audit Log" class="btn btn-default"><span class="glyphicon glyphicon-eye-open"></span> </a>
                        <asp:LinkButton ID="btnUser" data-toggle="tooltip" data-placement="bottom" title="Add User" CssClass="btn btn-default" runat="server" OnClick="btnUser_Click"><span class="glyphicon glyphicon-file"></span></asp:LinkButton>
                    </div>
                </div>
            </div>
            <br />
            <br />
            <div class="row">
                <div class="col-lg-12">
                    
                    <asp:GridView ID="GridView1" runat="server" GridLines="None" CssClass="table table-hover" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSource1">
                        <Columns>
                            <asp:BoundField DataField="Module" HeaderText="MODULE" SortExpression="Module" />
                            <asp:BoundField DataField="Username" HeaderText="USER NAME" SortExpression="Username" />
                            <asp:BoundField DataField="Email" HeaderText="EMAIL" SortExpression="Email" />
                            <asp:TemplateField HeaderText="IsCONTRIBUTE" SortExpression="IsContribute">
                                <ItemTemplate>
                                    <label class="switch">
                                        <asp:CheckBox ID="chkIsContribute" runat="server" Checked='<%# Bind("IsContribute") %>' ValidationGroup='<%# Bind("Id") %>' AutoPostBack="true" OnCheckedChanged="chkIsContribute_CheckedChanged" />
                                        <span class="slider round"></span>
                                    </label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="IsNOTIFY" SortExpression="IsNotify">
                                <ItemTemplate>
                                    <label class="switch">
                                        <asp:CheckBox ID="chkIsNotify" runat="server" Checked='<%# Bind("IsNotify") %>' ValidationGroup='<%# Bind("Id") %>' AutoPostBack="true" OnCheckedChanged="chkIsNotify_CheckedChanged" />
                                        <span class="slider round"></span>
                                    </label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CssClass="btn btn-danger" CommandName="Delete"><span class="glyphicon glyphicon-trash"></span> </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            No User(s) Specified.
                        </EmptyDataTemplate>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:AliijarConnectionString %>"
                        DeleteCommand="DELETE FROM [SECURITY] WHERE [Id] = @Id"
                        InsertCommand="INSERT INTO [SECURITY] ([Module], [Username], [Email], [IsContribute], [IsNotify]) VALUES (@Module, @Username, @Email, @IsContribute, @IsNotify)" 
                        SelectCommand="SELECT * FROM [SECURITY] WHERE IsAdmin is Null ORDER BY MODULE ">
                        <DeleteParameters>
                            <asp:Parameter Name="Id" Type="Int32" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Module" Type="String" />
                            <asp:Parameter Name="Username" Type="String" />
                            <asp:Parameter Name="Email" Type="String" />
                            <asp:Parameter Name="IsContribute" Type="Boolean" />
                            <asp:Parameter Name="IsNotify" Type="Boolean" />
                        </InsertParameters>
                    </asp:SqlDataSource>

                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>


    <div id="SecurityDialog" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #a1a1a1; color: #ffffff">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title"><span class="glyphicon glyphicon-comment"></span> ADD NEW USER</h4>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <asp:FormView ID="FormView1" runat="server" Width="100%" DataKeyNames="Id" DataSourceID="SqlDataSource1" DefaultMode="Insert" OnItemInserting="FormView1_ItemInserting">
                                <InsertItemTemplate>
                                    <label>MODULE:</label>
                                    <asp:DropDownList ID="DdlModule" runat="server" CssClass="form-control">
                                        <asp:ListItem>Billing</asp:ListItem>
                                        <asp:ListItem>Customer</asp:ListItem>
                                        <asp:ListItem>Property</asp:ListItem>
                                        <asp:ListItem>Payment</asp:ListItem>
                                        <asp:ListItem>Tenancy</asp:ListItem>
                                    </asp:DropDownList>
                                    <%--<asp:TextBox ID="ModuleTextBox" runat="server" Text='<%# Bind("Module") %>' CssClass="form-control" />--%>
                                    <br />
                                    <label>USERNAME:</label>
                                    <asp:TextBox ID="UsernameTextBox" placeholder="DOMAIN\USERNAME" runat="server" Text='<%# Bind("Username") %>' CssClass="form-control" />
                                    <br />
                                    <label>EMAIL:</label>
                                    <asp:TextBox ID="EmailTextBox" runat="server" Text='<%# Bind("Email") %>' CssClass="form-control" />
                                    <br />
                                    <table>
                                        <tr>
                                            <td style="vertical-align:top; width:100px">Is Contribute</td>
                                            <td>
                                                <label class="switch">
                                                    <asp:CheckBox ID="IsContributeCheckBox" runat="server" Checked='<%# Bind("IsContribute") %>' />
                                                    <span class="slider round"></span>
                                                </label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="vertical-align:top; width:100px">Is Notify</td>
                                            <td>
                                                <label class="switch">
                                                    <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Bind("IsNotify") %>' />
                                                    <span class="slider round"></span>
                                                </label>
                                            </td>
                                        </tr>
                                    </table>
                                    <hr />
                                    <br />
                                    <div style="float: right">
                                        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert" CssClass="btn btn-success" Width="100px" />
                                        <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Close" CssClass="btn btn-default" Width="100px" data-dismiss="modal" />
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

