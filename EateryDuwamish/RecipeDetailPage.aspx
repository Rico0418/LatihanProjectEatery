<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RecipeDetailPage.aspx.cs" Inherits="EateryDuwamish.RecipeDetailPage" %>

<%@ Register Src="~/UserControl/NotificationControl.ascx" TagName="NotificationControl" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <link rel="stylesheet" type="text/css" href="assets/css normal/RecipeDetailDesign.css" />
    <script type="text/javascript">
        function ConfigureDatatable() {
            var table = null;
            if ($.fn.dataTable.isDataTable('#htblIngredient')) {
                table = $('#htblIngredient').DataTable();
            }
            else {
                table = $('#htblIngredient').DataTable({
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
            $('#htblIngredient').on('change', '.checkDelete input', function () {
                var parent = $(this).parent();
                var value = $(parent).attr('data-value');
                var deletedList = [];

                if ($('#<%=hdfDeletedIngredient.ClientID%>').val())
                    deletedList = $('#<%=hdfDeletedIngredient.ClientID%>').val().split(',');

                if ($(this).is(':checked')) {
                    deletedList.push(value);
                    $('#<%=hdfDeletedIngredient.ClientID%>').val(deletedList.join(','));
                }
                else {
                    var index = deletedList.indexOf(value);
                    if (index >= 0)
                        deletedList.splice(index, 1);
                    $('#<%=hdfDeletedIngredient.ClientID%>').val(deletedList.join(','));
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
            <uc3:NotificationControl ID="notifRecipeDetail" runat="server" />
            <div class="ContainerPageTitle">
                <div class="page-title">EATERY</div>
                <div class="pageTitle2">
                    <h3 class="page-title2">Your Food Recipe Manager</h3>
                </div>
            </div>
            <div class="ContainerRecipeDish">
                <span class="recipe-name">
                    <asp:Literal ID="LblRecipeName" runat="server"></asp:Literal>
                </span>

            </div>
            <asp:Panel ID="pnlFormRecipeDetail" runat="server" Visible="false">
                <div class="form-slip">
                    <div class="form-slip-header">
                        <div class="form-slip-title">
                            Form Ingredient
                            <asp:Literal ID="litFormType" runat="server"></asp:Literal>
                        </div>
                        <hr style="margin: 0" />
                    </div>
                    <div class="form-slip-main">
                        <asp:HiddenField ID="hdfIngredientId" runat="server" Value="0" />
                        <div class="form">
                            <div class="form-group">
                                <div class="control-label">
                                    Ingredient
                                </div>
                                <div class="control-textbox">
                                    <asp:TextBox ID="txtIngredientName" CssClass="form-control" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvIngredientName" runat="server" ErrorMessage="Tolong isi field ini"
                                        ControlToValidate="txtIngredientName" ForeColor="Red" ValidationGroup="InsertUpdateIngredient" Display="Dynamic">
                                    </asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revIngredientName" runat="server" ErrorMessage="max 100 characters"
                                        ControlToValidate="txtIngredientName" ValidationExpression="^[\s\S]{0,100}$" ForeColor="Red" ValidationGroup="InsertUpdateIngredient" Display="Dynamic">
                                    </asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="control-label">
                                    Quantity
                                </div>
                                <div class="control-textbox">
                                    <asp:TextBox ID="txtIngredientQuantity" CssClass="form-control" runat="server" type="number" min="0" Max="10000" ></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvIngredientPrice" runat="server" ErrorMessage="Tolong isi field ini"
                                        ControlToValidate="txtIngredientQuantity" ForeColor="Red" ValidationGroup="InsertUpdateIngredient" Display="Dynamic">
                                    </asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="control-label">
                                    Unit
                                </div>
                                <div class="control-textbox">
                                    <asp:TextBox ID="txtIngredientUnit" CssClass="form-control" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvIngredientUnit" runat="server" ErrorMessage="Tolong isi field ini"
                                        ControlToValidate="txtIngredientUnit" ForeColor="Red" ValidationGroup="InsertUpdateIngredient" Display="Dynamic">
                                    </asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revIngredientUnit" runat="server" ErrorMessage="max 10 characters"
                                        ControlToValidate="txtIngredientUnit" ValidationExpression="^[\s\S]{0,10}$" ForeColor="Red" ValidationGroup="InsertUpdateIngredient" Display="Dynamic">
                                    </asp:RegularExpressionValidator>
                                </div>
                            </div>
                        </div>
                        <div class="form-bottom">
                            <div></div>
                            <div class="control-button">
                                <asp:Button ID="btnSumbit" runat="server" Text="Submit" OnClick="btnSumbit_Click" ValidationGroup="InsertUpdateIngredient"
                                    Width="100px" CssClass="btn btn-primary"/>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>
            <div class="row">
                <div class="table-header">
                    <div class="table-header-title">
                        INGREDIENTS
                    </div>
                    <div class="table-header-button">
                        <asp:Button ID="btnAdd" runat="server" Text="ADD" CssClass="btn btn-primary" Width="100px" OnClick="btnAdd_Click"/>
                        <asp:Button ID="btnDelete" runat="server" Text="DELETE" CssClass="btn btn-danger" Width="100px" OnClick="btnDelete_Click"/>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="table-main col-sm-12">
                    <asp:HiddenField ID="hdfDeletedIngredient" runat="server" />
                    <asp:Repeater ID="rptIngredient" runat="server" OnItemDataBound="rptIngredient_ItemDataBound" OnItemCommand="rptIngredient_ItemCommand">
                        <HeaderTemplate>
                            <table id="htblIngredient" class="table">
                                <thead>
                                    <tr role="row">
                                        <th aria-sort="ascending" style="" colspan="1" rowspan="1" tabindex="0" class="sorting_asc center"></th>
                                        <th aria-sort="ascending" style="" colspan=
                                            "1" rowspan="1" tabindex="0" class="sorting_asc text-center">Ingredient</th>
                                        <th aria-sort="ascending" style="" colspan="1" rowspan="1" tabindex="0" class="sorting_asc text-center">Quantity</th>
                                        <th aria-sort="ascending" style="" colspan="1" rowspan="1" tabindex="0" class="sorting_asc text-center">Unit</th>
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
                                    <asp:Literal ID="lblIngredientName" runat="server"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="lblIngredientQuantity" runat="server"></asp:Literal>
                                </td>
                                <td>
                                    <asp:Literal ID="lblIngredientUnit" runat="server"></asp:Literal>
                                </td>
                                <td>
                                    <asp:LinkButton ID="EditBtn" runat="server" CommandName="EDIT" CommandArgument='<%# Eval("IngredientID") %>'>Edit</asp:LinkButton>                                    
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
            <div class="RecipeDescription">
                <h3>Recipe Description</h3>
                <span class="recipe-description">
                    <asp:TextBox ID="txtDescription" TextMode="MultiLine" runat="server"  Style="width: 1500px; height: 300px;" ReadOnly="true"></asp:TextBox>
                </span>
                <div class="box-button">
                    <asp:Button ID="BtnEdit" runat="server" Text="EDIT" CssClass="btn bnt-primary" BackColor="Gray" Width="100px" OnClick="BtnEdit_Click"/>  
                    <asp:Button ID="BtnSave" runat="server" Text="SAVE" CssClass="btn btn-primary" Width="100px" OnClick="BtnSave_Click"/>                                 
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
