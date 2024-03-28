<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RecipePage.aspx.cs" Inherits="EateryDuwamish.RecipePage" %>

<%@ Register Src="~/UserControl/NotificationControl.ascx" TagName="NotificationControl" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <link rel="stylesheet" type="text/css" href="assets/css normal/RecipeDesign.css" />
    <script type="text/javascript">
        function ConfigureDatatable() {
            var table = null;
            if ($.fn.dataTable.isDataTable('#htblRecipe')) {
                table = $('#htblRecipe').DataTable();
            }
            else {
                table = $('#htblRecipe').DataTable({
                    stateSave: false,
                    order: [[1, "asc"]],
                    columnDefs: [{ orderable: false, targets: [0] }]
                });
            }
            return table;
        }
    </script>
    <script type="text/javascript">
        function ConfigureCheckboxEvent() {
            $('#htblRecipe').on('change', '.checkDelete input', function () {
                var parent = $(this).parent();
                var value = $(parent).attr('data-value');
                var deletedList = [];

                if ($('#<%=hdfDeletedRecipe.ClientID%>').val())
                    deletedList = $('#<%=hdfDeletedRecipe.ClientID%>').val().split(',');

                if ($(this).is(':checked')) {
                    deletedList.push(value);
                    $('#<%=hdfDeletedRecipe.ClientID%>').val(deletedList.join(','));
                }
                else {
                    var index = deletedList.indexOf(value);
                    if (index >= 0)
                        deletedList.splice(index, 1);
                    $('#<%=hdfDeletedRecipe.ClientID%>').val(deletedList.join(','));
                }
            });
        }
    </script>
    <script type="text/javascript">
        function ConfigureElements() {
            ConfigureDatatable();
            ConfigureCheckboxEvent();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <script type="text/javascript">
                $(document).ready(function () {
                    ConfigureElements();
                });
                <%--On Partial Postback Callback Function--%>
                var prm = Sys.WebForms.PageRequestManager.getInstance();
                prm.add_endRequest(function () {
                    ConfigureElements();
                });
            </script>
            <uc2:NotificationControl ID="notifRecipe" runat="server" />
            <div class="ContainerPageTitle">
                <div class="page-title">EATERY</div>
                <div class="pageTitle2">
                    <h3 class="page-title2">Your Food Recipe Manager</h3>
                </div>
            </div>
            <div class="ContainerNameDish">
                <span class="dish-name">
                    <asp:Literal ID="LblDishName" runat="server"></asp:Literal>
                </span>
            </div>
            <asp:Panel ID="pnlFormRecipe" runat="server" Visible="false">
                <div class="form-slip">
                    <div class="form-slip-header">
                        <div class="form-slip-title">
                            Form Recipe
                    <asp:Literal ID="litFormType" runat="server"></asp:Literal>
                        </div>
                        <hr style="margin: 0" />
                    </div>
                    <div class="form-slip-main">
                        <asp:HiddenField ID="hdfRecipeId" runat="server" Value="0" />
                        <div>
                            <div class="col-lg-6 form-group">
                                <div class="col-lg-4 control-label">
                                    Recipe Name*
                                </div>
                                <div class="col-lg-6">
                                    <asp:TextBox ID="txtRecipeName" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvRecipeName" runat="server" ErrorMessage="Tolong isi field ini"
                                        ControlToValidate="txtRecipeName" ForeColor="Red"
                                        ValidationGroup="InsertUpdateRecipe" Display="Dynamic">
                                    </asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revRecipeName" runat="server" ErrorMessage="max 100 characters"
                                        ControlToValidate="txtRecipeName" ValidationExpression="^[\s\S]{0,100}$" ForeColor="Red"
                                        ValidationGroup="InsertUpdateRecipe" Display="Dynamic">
                                    </asp:RegularExpressionValidator>

                                </div>
                            </div>
                            <div class="col-lg-6 form-group">
                                <div class="col-lg-4 control-label">
                                    Recipe Description*
                                </div>
                                <div class="col-lg-6">
                                    <asp:TextBox ID="txtRecipeDescription" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvRecipeDescription" runat="server" ErrorMessage="Tolong isi field ini"
                                        ControlToValidate="txtRecipeDescription" ForeColor="Red"
                                        ValidationGroup="InsertUpdateRecipe" Display="Dynamic">
                                    </asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revRecipeDescription" runat="server" ErrorMessage="max 300 characters"
                                        ControlToValidate="txtRecipeDescription" ValidationExpression="^[\s\S]{0,300}$" ForeColor="Red"
                                        ValidationGroup="InsertUpdateRecipe" Display="Dynamic">
                                    </asp:RegularExpressionValidator>

                                </div>
                            </div>
                        </div>
                        <div class="col-lg-12">
                            <div class="col-lg-2"></div>
                            <div class="col-lg-2">
                                <asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" ValidationGroup="InsertUpdateRecipe"
                                    Width="100px" CssClass="btn btn-primary"/>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>
            <div class="row">
                <div class="table-header">
                    <div class="table-header-title">
                        RECIPES
                    </div>
                    <div class="table-header-button">
                        <asp:Button ID="btnAdd" runat="server" Text="ADD" CssClass="btn btn-primary" Width="100px" OnClick="btnAdd_Click" />
                        <asp:Button ID="btnDelete" runat="server" Text="DELETE" CssClass="btn btn-danger" width="100px" OnClick="btnDelete_Click"/>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="table-main col-sm-12">
                    <asp:HiddenField ID="hdfDeletedRecipe" runat="server" />
                    <asp:Repeater ID="rptRecipe" runat="server" OnItemDataBound="rptRecipe_ItemDataBound" OnItemCommand="rptRecipe_ItemCommand">
                        <HeaderTemplate>
                            <table id="htblRecipe" class="table">
                                <thead>
                                    <tr role="row">
                                        <th aria-sort="ascending" style="" colspan="1" rowspan="1" tabindex="0" class="sorting_asc center"></th>
                                        <th aria-sort="ascending" style="" colspan="1" rowspan="1" tabindex="0" class="sorting_asc text-center">Recipe Name</th>
                                        <th aria-sort="ascending" style="" colspan="1" rowspan="1" tabindex="0" class="sorting_asc text-center">Toogle</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr class="odd" role="row" runat="server" onclick="">
                                <td>
                                    <div style="text-align:center;">
                                        <asp:CheckBox ID="chckChoose" CssClass="checkDelete" runat="server" />
                                    </div>
                                </td>
                                <td>
                                    <asp:Literal ID="lblRecipeName" runat="server"></asp:Literal>
                                </td>
                                <td>
                                    <asp:LinkButton ID="DetailBtn" runat="server" OnClick="DetailBtn_Click1" CommandName="TRANSFER" CommandArgument='<%# Eval("RecipeID") %>'>Detail</asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
