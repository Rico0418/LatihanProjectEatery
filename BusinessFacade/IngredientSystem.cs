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
    public class IngredientSystem
    {
        public List<IngredientData> GetIngredientList()
        {
            try
            {
                return new IngredientDB().GetIngredientList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public IngredientData GetIngredientByID(int ingredientID)
        {
            try
            {
                return new IngredientDB().GetIngredientByID(ingredientID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<IngredientData> GetIngredientByRecipeID(int recipeID)
        {
            try
            {
                return new IngredientDB().GetIngredientByRecipeID(recipeID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public int InsertUpdateIngredient(IngredientData ingredient)
        {
            try
            {
                return new IngredientRule().InsertUpdateIngredient(ingredient);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public int DeleteIngredient(IEnumerable<int> ingredientIDs)
        {
            try
            {
                return new IngredientRule().DeleteIngredient(ingredientIDs);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
