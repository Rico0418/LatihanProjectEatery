using BusinessRule;
using Common.Data;
using DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessFacade
{
    public class RecipeSystem
    {
        public List<RecipeData> GetRecipeList()
        {
            try
            {
                return new RecipeDB().GetRecipeList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public RecipeData GetRecipeByID(int recipeID)
        {
            try
            {
                return new RecipeDB().GetRecipeByID(recipeID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<RecipeData> GetRecipeByDishID(int dishID)
        {
            try
            {
                return new RecipeDB().GetRecipeByDishID(dishID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public int InsertUpdateRecipe(RecipeData recipe)
        {
            try
            {
                return new RecipeRule().InsertUpdateRecipe(recipe);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public int DeleteRecipe(IEnumerable<int> recipeIDs)
        {
            try
            {
                return new RecipeRule().DeleteRecipe(recipeIDs);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public int DeleteRecipeAll(IEnumerable<int> recipeIDs)
        {
            try
            {
                return new RecipeRule().DeleteRecipeAll(recipeIDs);
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }
    }
}
