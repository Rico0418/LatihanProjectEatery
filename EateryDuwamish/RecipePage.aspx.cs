using BusinessFacade;
using Common.Data;
using Common.Enum;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EateryDuwamish
{
    public partial class RecipePage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int id = Convert.ToInt32(Request.QueryString["ID"]);
                ShowNotificationsIfExist();
                LoadRecipeTable(id);
                LoadNameDish(id);
            }
        }

        private void ResetForm()
        {
            hdfRecipeId.Value = String.Empty;
            txtRecipeName.Text = String.Empty;
        }
        private RecipeData GetRecipeData()
        {
            RecipeData recipe = new RecipeData();
            recipe.RecipeID = String.IsNullOrEmpty(hdfRecipeId.Value) ? 0 : Convert.ToInt32(hdfRecipeId.Value);
            recipe.RecipeName = txtRecipeName.Text;
            recipe.RecipeDescription = txtRecipeDescription.Text;
            recipe.DishID = Convert.ToInt32(Request.QueryString["ID"]);
            return recipe;
        }
        private void LoadNameDish(int id)
        {
            string dishName = new RecipeSystem().GetDishNameByID(id);
            LblDishName.Text = dishName;
        }
        private void LoadRecipeTable(int id)
        {
            try
            {
                List<RecipeData> ListRecipe = new RecipeSystem().GetRecipeByDishID(id);
                rptRecipe.DataSource = ListRecipe;
                rptRecipe.DataBind();
            }
            catch(Exception ex)
            {
                notifRecipe.Show($"ERROR LOAD TABLE: {ex.Message}", NotificationType.Danger);
            }

        }
        protected void DetailBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/UserControl/RecipeDetailPage.aspx");
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                RecipeData recipe = GetRecipeData();
                int rowAffected = new RecipeSystem().InsertUpdateRecipe(recipe);
                if (rowAffected <= 0)
                    throw new Exception("New Data Recorded");
                Session["save-success"] = 1;
                int id = Convert.ToInt32(Request.QueryString["ID"]);
                Response.Redirect("RecipePage.aspx?ID="+ id);
            }
            catch (Exception ex)
            {
                notifRecipe.Show($"Error submit data: {ex.Message}", NotificationType.Danger);
            } 
        }

        protected void rptRecipe_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                RecipeData recipe = (RecipeData)e.Item.DataItem;
                Literal lblRecipeName = (Literal)e.Item.FindControl("lblRecipeName");
                lblRecipeName.Text = recipe.RecipeName.ToString();
                CheckBox chckChoose = (CheckBox)e.Item.FindControl("chckChoose");
                chckChoose.Attributes.Add("data-value", recipe.RecipeID.ToString());
            }
        }

        protected void rptRecipe_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "TRANSFER")
            {
                string id = Request.QueryString["ID"];
                string recipeID = e.CommandArgument.ToString();
                string redirectUrl = $"RecipeDetailPage.aspx?ID1={recipeID}&ID2={id}";
                Response.Redirect(redirectUrl);
            }
        }

        protected void DetailBtn_Click1(object sender, EventArgs e)
        {

        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            ResetForm();
            litFormType.Text = "ADD";
            pnlFormRecipe.Visible = true;
            txtRecipeName.Focus();
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            try
            {
                string strDeleteIDs = hdfDeletedRecipe.Value;
                IEnumerable<int> deletedIDs = strDeleteIDs.Split(',').Select(Int32.Parse);
                int rowAffected = new RecipeSystem().DeleteRecipeAll(deletedIDs);
                if (rowAffected <= 0)
                    throw new Exception("No data Deleted");
                Session["delete-success"] = 1;
                int id = Convert.ToInt32(Request.QueryString["ID"]);
                Response.Redirect("RecipePage.aspx?ID="+id);
            }
            catch(Exception ex)
            {
                notifRecipe.Show($"ERROR DELETE DATA: No Item Selected", NotificationType.Danger);
            }
        }

        private void ShowNotificationsIfExist()
        {
            if (Session["save-success"] != null)
            {
                notifRecipe.Show("Data sukses disimpan", NotificationType.Success);
                Session.Remove("save-success");
            }
            if (Session["delete-success"] != null)
            {
                notifRecipe.Show("Data sukses dihapus", NotificationType.Success);
                Session.Remove("delete-success");
            }
        }
    }
}