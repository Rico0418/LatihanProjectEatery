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
    public partial class RecipeDetailPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int id = Convert.ToInt32(Request.QueryString["ID1"]);
                int dishId = Convert.ToInt32(Request.QueryString["ID2"]);
                ShowNotificationIfExists();
                LoadIngredientTable(id);
                LoadNameRecipe(id);
                LoadDescriptionRecipe(id);
                txtDescription.BackColor = System.Drawing.Color.LightGray;
            }

        }
        private void LoadIngredientTable(int id)
        {
            try
            {
                List<IngredientData> ListIngredient = new IngredientSystem().GetIngredientByRecipeID(id);
                rptIngredient.DataSource = ListIngredient;
                rptIngredient.DataBind();
            }
            catch(Exception ex)
            {
                notifRecipeDetail.Show($"ERROR LOAD TABLE:{ex.Message}", NotificationType.Danger);
            }
        }
        private void LoadNameRecipe(int id)
        {
            string recipeName = new IngredientSystem().GetRecipeNameByID(id);
            LblRecipeName.Text = recipeName;
        }
        private void LoadDescriptionRecipe(int id)
        {
            string recipeDescription = new IngredientSystem().GetRecipeDescriptionByID(id);
            txtDescription.Text = recipeDescription;
        }
        private void FillForm(IngredientData ingredient)
        {
            hdfIngredientId.Value = ingredient.IngredientID.ToString();
            txtIngredientName.Text = ingredient.IngredientName;
            txtIngredientQuantity.Text = ingredient.IngredientQuantity.ToString();
            txtIngredientUnit.Text = ingredient.IngredientUnit;
        }
        private void ResetForm()
        {
            hdfIngredientId.Value = String.Empty;
            txtIngredientName.Text = String.Empty;
            txtIngredientQuantity.Text = String.Empty;
            txtIngredientUnit.Text = String.Empty;
        }
        private RecipeData GetRecipeData()
        {
            RecipeData recipe = new RecipeData();
            recipe.RecipeID = Convert.ToInt32(Request.QueryString["ID1"]);
            recipe.RecipeName = LblRecipeName.Text;
            recipe.RecipeDescription = txtDescription.Text;
            recipe.DishID = Convert.ToInt32(Request.QueryString["ID2"]);
            return recipe;
        }
        private IngredientData GetFormData()
        {
            IngredientData ingredient = new IngredientData();
            ingredient.IngredientID = String.IsNullOrEmpty(hdfIngredientId.Value) ? 0 : Convert.ToInt32(hdfIngredientId.Value);
            ingredient.IngredientName = txtIngredientName.Text;
            ingredient.IngredientQuantity = Convert.ToInt32(txtIngredientQuantity.Text);
            ingredient.IngredientUnit = txtIngredientUnit.Text;
            ingredient.RecipeID = Convert.ToInt32(Request.QueryString["ID1"]);
            return ingredient;

        }
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            ResetForm();
            litFormType.Text = "ADD";
            pnlFormRecipeDetail.Visible = true;
            txtIngredientName.Focus();
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            try
            {
                string strDeleteIDs = hdfDeletedIngredient.Value;
                IEnumerable<int> deleteIDs = strDeleteIDs.Split(',').Select(Int32.Parse);
                int rowAffected = new IngredientSystem().DeleteIngredient(deleteIDs);
                if (rowAffected <= 0)
                    throw new Exception("No data Deleted");
                Session["delete-success"] = 1;
                int id = Convert.ToInt32(Request.QueryString["ID1"]);
                int dishId = Convert.ToInt32(Request.QueryString["ID2"]);
                string redirectUrl = $"RecipeDetailPage.aspx?ID1={id}&ID2={dishId}";
                Response.Redirect(redirectUrl);
            }
            catch(Exception ex)
            {
                notifRecipeDetail.Show($"ERROR DELETE DATA: No Item Selected", NotificationType.Danger);
            }
        }

        protected void btnSumbit_Click(object sender, EventArgs e)
        {
            try
            {
                IngredientData ingredient = GetFormData();
                int rowAffected = new IngredientSystem().InsertUpdateIngredient(ingredient);
                if (rowAffected <= 0)
                    throw new Exception("New Data Recorded");
                Session["save-success"] = 1;
                int id = Convert.ToInt32(Request.QueryString["ID1"]);
                int dishId = Convert.ToInt32(Request.QueryString["ID2"]);
                string redirectUrl = $"RecipeDetailPage.aspx?ID1={id}&ID2={dishId}";
                Response.Redirect(redirectUrl);
            }
            catch(Exception ex)
            {
                notifRecipeDetail.Show($"Error submit data: {ex.Message}", NotificationType.Danger);
            }
        }

        protected void rptIngredient_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if(e.Item.ItemType==ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                IngredientData ingredient = (IngredientData)e.Item.DataItem;
                Literal lblIngredientName = (Literal)e.Item.FindControl("lblIngredientName");
                lblIngredientName.Text = ingredient.IngredientName.ToString();
                Literal lblIngredientQuantity = (Literal)e.Item.FindControl("lblIngredientQuantity");
                lblIngredientQuantity.Text = ingredient.IngredientQuantity.ToString();
                Literal lblIngredientUnit = (Literal)e.Item.FindControl("lblIngredientUnit");
                lblIngredientUnit.Text = ingredient.IngredientUnit.ToString();
                CheckBox chckChoose = (CheckBox)e.Item.FindControl("chckChoose");
                chckChoose.Attributes.Add("data-value", ingredient.IngredientID.ToString());
            }
        }

        protected void rptIngredient_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if(e.CommandName == "EDIT")
            {
                Literal lblIngredientName = (Literal)e.Item.FindControl("lblIngredientName");
                Literal lblIngredientquantity = (Literal)e.Item.FindControl("lblIngredientQuantity");
                Literal lblIngredientUnit = (Literal)e.Item.FindControl("lblIngredientUnit");

                int ingredientID = Convert.ToInt32(e.CommandArgument.ToString());
                IngredientData ingredient =new IngredientSystem().GetIngredientByID(ingredientID);
                FillForm(new IngredientData
                {
                    IngredientID = ingredient.IngredientID,
                    IngredientName = ingredient.IngredientName,
                    IngredientQuantity = ingredient.IngredientQuantity,
                    IngredientUnit = ingredient.IngredientUnit
                });
                litFormType.Text = $"UBAH: {lblIngredientName.Text}";
                pnlFormRecipeDetail.Visible = true;
                txtIngredientName.Focus();
            }
        }
        private void ShowNotificationIfExists()
        {
            if (Session["save-success"] != null)
            {
                notifRecipeDetail.Show("Data sukses disimpan", NotificationType.Success);
                Session.Remove("save-success");
            }
            if (Session["delete-success"] != null)
            {
                notifRecipeDetail.Show("Data sukses dihapus", NotificationType.Success);
                Session.Remove("delete-succes");
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            txtDescription.ReadOnly = true;
            txtDescription.BackColor = System.Drawing.Color.LightGray;
            try
            {
                RecipeData recipe = GetRecipeData();
                int Affected = new RecipeSystem().InsertUpdateRecipe(recipe);
                Session["save-success"] = 1;
                int id = Convert.ToInt32(Request.QueryString["ID1"]);
                int dishId = Convert.ToInt32(Request.QueryString["ID2"]);
                string redirectUrl = $"RecipeDetailPage.aspx?ID1={id}&ID2={dishId}";
                Response.Redirect(redirectUrl);
            }
            catch(Exception ex)
            {
                notifRecipeDetail.Show($"Error Save data: {ex.Message}", NotificationType.Danger);
            }
        }

        protected void BtnEdit_Click(object sender, EventArgs e)
        {
            txtDescription.ReadOnly = false;
            txtDescription.BackColor = System.Drawing.Color.White;
        }
    }
}