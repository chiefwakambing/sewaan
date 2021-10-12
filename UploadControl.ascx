<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UploadControl.ascx.cs" Inherits="UploadControl" %>


<div class="row">
    <div class="col-sm-6">
        <h4>UPLOAD</h4>
        <span class="glyphicon glyphicon-chevron-down"></span>

        <asp:UpdateProgress ID="UpdateProgress1" runat="server">
            <ProgressTemplate>
                <img src="/Wait.gif" />
            </ProgressTemplate>
        </asp:UpdateProgress>

    </div>
    <div class="col-sm-6">
        <div style="float: right">
            <asp:LinkButton ID="LinkButtonSave" runat="server" CssClass="btn btn-default" OnClick="LinkButtonSave_Click">Upload</asp:LinkButton>
        </div>
        <div style="float: right">
            <asp:FileUpload ID="FileUpload1" Height="32px" runat="server" />
            
        </div>
    </div>
</div>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>

        <div class="row">
            <div class="col-sm-12">
                <asp:GridView ID="GrvUploadedContent" CssClass="table table-striped" AutoGenerateColumns="false" GridLines="None" runat="server" OnRowDeleting="GrvUploadedContent_RowDeleting">
                    <Columns>
                        <asp:TemplateField HeaderText="FILE">
                            <ItemTemplate>
                                <asp:HyperLink ID="HyperLink1" runat="server" Text="<%#Container.DataItem%>" NavigateUrl='<%#"/Upload/" + this.TargetFolder + "/" + Request.QueryString["Id"] + "/"  + Container.DataItem %>' Target="_blank"></asp:HyperLink>
                            </ItemTemplate>
                            <ItemStyle VerticalAlign="Middle" />
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton ID="LinkDelete" runat="server" CommandName="Delete" CssClass="btn btn-default" OnClientClick="if (!confirm('Are you sure you want delete?')) return false;"><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </ContentTemplate>
    <Triggers>
        <asp:PostBackTrigger ControlID="LinkButtonSave" />
    </Triggers>

</asp:UpdatePanel>

