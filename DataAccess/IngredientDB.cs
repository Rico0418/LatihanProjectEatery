using Common.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SystemFramework;

namespace DataAccess
{
    public class IngredientDB
    {
        public List<IngredientData> GetIngredientList()
        {
            try
            {
                string SpName = "dbo.Ingredient_Get";
                List<IngredientData> ListIngredient = new List<IngredientData>();
                using (SqlConnection SqlConn = new SqlConnection())
                {
                    SqlConn.ConnectionString = SystemConfigurations.EateryConnectionString;
                    SqlConn.Open();
                    SqlCommand SqlCmd = new SqlCommand(SpName, SqlConn);
                    SqlCmd.CommandType = CommandType.StoredProcedure;
                    using (SqlDataReader Reader = SqlCmd.ExecuteReader())
                    {
                        if (Reader.HasRows)
                        {
                            while (Reader.Read())
                            {
                                IngredientData ingredient = new IngredientData();
                                ingredient.IngredientID = Convert.ToInt32(Reader["IngredientID"]);
                                ingredient.IngredientName = Convert.ToString(Reader["IngredientName"]);
                                ingredient.IngredientQuantity = Convert.ToInt32(Reader["IngredientQuantity"]);
                                ingredient.IngredientUnit = Convert.ToString(Reader["IngredientUnit"]);
                                ingredient.RecipeID = Convert.ToInt32(Reader["RecipeID"]);
                            }
                        }
                    }
                    SqlConn.Close();
                }
                return ListIngredient;
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
                string SpName = "dbo.Ingredient_GetByID";
                IngredientData ingredient = null;
                using (SqlConnection SqlConn = new SqlConnection())
                {
                    SqlConn.ConnectionString = SystemConfigurations.EateryConnectionString;
                    SqlConn.Open();
                    SqlCommand SqlCmd = new SqlCommand(SpName, SqlConn);
                    SqlCmd.CommandType = CommandType.StoredProcedure;
                    SqlCmd.Parameters.Add(new SqlParameter("@IngredientID", ingredientID));
                    using (SqlDataReader Reader = SqlCmd.ExecuteReader())
                    {
                        if (Reader.HasRows)
                        {
                            Reader.Read();
                            ingredient = new IngredientData();
                            ingredient.IngredientID = Convert.ToInt32(Reader["IngredientID"]);
                            ingredient.IngredientName = Convert.ToString(Reader["IngredientName"]);
                            ingredient.IngredientQuantity = Convert.ToInt32(Reader["IngredientQuantity"]);
                            ingredient.IngredientUnit = Convert.ToString(Reader["IngredientUnit"]);
                            ingredient.RecipeID = Convert.ToInt32(Reader["RecipeID"]);
                        }
                    }
                    SqlConn.Close();
                }
                return ingredient;
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
                string SpName = "dbo.Ingredient_GetByRecipeID";
                List<IngredientData> listIngredient = new List<IngredientData>();
                using (SqlConnection SqlConn = new SqlConnection())
                {
                    SqlConn.ConnectionString = SystemConfigurations.EateryConnectionString;
                    SqlConn.Open();
                    SqlCommand SqlCmd = new SqlCommand(SpName, SqlConn);
                    SqlCmd.CommandType = CommandType.StoredProcedure;
                    SqlCmd.Parameters.Add(new SqlParameter("@RecipeID", recipeID));
                    using (SqlDataReader Reader = SqlCmd.ExecuteReader())
                    {
                        if (Reader.HasRows)
                        {
                            while (Reader.Read())
                            {
                                IngredientData ingredient = new IngredientData();
                                ingredient.IngredientID = Convert.ToInt32(Reader["IngredientID"]);
                                ingredient.IngredientName = Convert.ToString(Reader["IngredientName"]);
                                ingredient.IngredientQuantity = Convert.ToInt32(Reader["IngredientQuantity"]);
                                ingredient.IngredientUnit = Convert.ToString(Reader["IngredientUnit"]);
                                ingredient.RecipeID = Convert.ToInt32(Reader["RecipeID"]);
                                listIngredient.Add(ingredient);
                            }

                        }
                    }
                    SqlConn.Close();
                }
                return listIngredient;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public int InsertUpdateIngredient(IngredientData ingredient, SqlTransaction SqlTran)
        {
            try
            {
                string SpName = "dbo.Ingredient_InsertUpdate";
                SqlCommand SqlCmd = new SqlCommand(SpName, SqlTran.Connection, SqlTran);
                SqlCmd.CommandType = CommandType.StoredProcedure;

                SqlParameter IngredientId = new SqlParameter("@IngredientID", ingredient.IngredientID);
                IngredientId.Direction = ParameterDirection.InputOutput;
                SqlCmd.Parameters.Add(IngredientId);

                SqlCmd.Parameters.Add(new SqlParameter("@IngredientName", ingredient.IngredientName));
                SqlCmd.Parameters.Add(new SqlParameter("@IngredientQuantity", ingredient.IngredientQuantity));
                SqlCmd.Parameters.Add(new SqlParameter("@IngredientUnit", ingredient.IngredientUnit));
                SqlCmd.Parameters.Add(new SqlParameter("@RecipeID", ingredient.RecipeID));
                return SqlCmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public int DeleteIngredient(string ingredientIDs, SqlTransaction SqlTran)
        {
            try
            {
                string SpName = "dbo.Ingredient_Delete";
                SqlCommand SqlCmd = new SqlCommand(SpName, SqlTran.Connection, SqlTran);
                SqlCmd.CommandType = CommandType.StoredProcedure;
                SqlCmd.Parameters.Add(new SqlParameter("@IngredientIDs", ingredientIDs));
                return SqlCmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public string GetRecipeNameByID(int recipeID)
        {
            try
            {
                string SpName = "dbo.RecipeName_GetByID";
                string recipe = null;
                using (SqlConnection SqlConn = new SqlConnection())
                {
                    SqlConn.ConnectionString = SystemConfigurations.EateryConnectionString;
                    SqlConn.Open();
                    SqlCommand SqlCmd = new SqlCommand(SpName, SqlConn);
                    SqlCmd.CommandType = CommandType.StoredProcedure;
                    SqlCmd.Parameters.Add(new SqlParameter("@RecipeID", recipeID));
                    using (SqlDataReader Reader = SqlCmd.ExecuteReader())
                    {
                        if (Reader.HasRows)
                        {
                            Reader.Read();
                            recipe = Convert.ToString(Reader["RecipeName"]);

                        }
                    }
                    SqlConn.Close();
                }
                return recipe;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public string GetRecipeDescriptionByID(int recipeID)
        {
            try
            {
                string SpName = "dbo.RecipeDescription_GetByID";
                string recipe = null;
                using (SqlConnection SqlConn = new SqlConnection())
                {
                    SqlConn.ConnectionString = SystemConfigurations.EateryConnectionString;
                    SqlConn.Open();
                    SqlCommand SqlCmd = new SqlCommand(SpName, SqlConn);
                    SqlCmd.CommandType = CommandType.StoredProcedure;
                    SqlCmd.Parameters.Add(new SqlParameter("@RecipeID", recipeID));
                    using (SqlDataReader Reader = SqlCmd.ExecuteReader())
                    {
                        if (Reader.HasRows)
                        {
                            Reader.Read();
                            recipe = Convert.ToString(Reader["RecipeDescription"]);

                        }
                    }
                    SqlConn.Close();
                }
                return recipe;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
