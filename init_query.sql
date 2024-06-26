DROP DATABASE EateryDB
CREATE DATABASE EateryDB
SELECT @@SERVERNAME AS 'ServerName';
SELECT DB_NAME() AS 'DatabaseName';
USE [EateryDB]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_General_Split]    Script Date: 20/05/2021 7:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_General_Split]
(
	@list VARCHAR(MAX),
	@delimiter VARCHAR(5)
)
RETURNS @retVal TABLE (Id INT IDENTITY(1,1), Value VARCHAR(MAX))
AS
BEGIN
	WHILE (CHARINDEX(@delimiter, @list) > 0)
	BEGIN
		INSERT INTO @retVal (Value)
		SELECT Value = LTRIM(RTRIM(SUBSTRING(@list, 1, CHARINDEX(@delimiter, @list) - 1)))
		SET @list = SUBSTRING(@list, CHARINDEX(@delimiter, @list) + LEN(@delimiter), LEN(@list))
	END
	INSERT INTO @retVal (Value)
	SELECT Value = LTRIM(RTRIM(@list))
	RETURN 
END
GO
/****** Object:  Table [dbo].[msDish]    Script Date: 20/05/2021 7:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[msDish](
	[DishID] [int] IDENTITY(1,1) NOT NULL,
	[DishTypeID] [int] NOT NULL,
	[DishName] [varchar](200) NOT NULL,
	[DishPrice] [int] NOT NULL,
	[AuditedActivity] [char](1) NOT NULL,
	[AuditedTime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DishID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[msDishType]    Script Date: 20/05/2021 7:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[msDishType](
	[DishTypeID] [int] IDENTITY(1,1) NOT NULL,
	[DishTypeName] [varchar](100) NOT NULL,
	[AuditedActivity] [char](1) NOT NULL,
	[AuditedTime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DishTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[msDish]  WITH CHECK ADD FOREIGN KEY([DishTypeID])
REFERENCES [dbo].[msDishType] ([DishTypeID])
GO
/****** Object:  StoredProcedure [dbo].[Dish_Delete]    Script Date: 20/05/2021 7:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
 * Created by: Jonathan Ibrahim
 * Date: 10 Mar 2021
 * Purpose: Delete dish
 */
CREATE PROCEDURE [dbo].[Dish_Delete]
	@DishIDs VARCHAR(MAX)
AS
BEGIN
	UPDATE msDish
	SET AuditedActivity = 'D',
		AuditedTime = GETDATE()
	WHERE DishID IN (SELECT value FROM fn_General_Split(@DishIDs, ','))
END
GO
/****** Object:  StoredProcedure [dbo].[Dish_Get]    Script Date: 20/05/2021 7:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
 * Created by: Jonathan Ibrahim
 * Date: 10 Mar 2021
 * Purpose: Get semua dish
 */
CREATE PROCEDURE [dbo].[Dish_Get]
AS
BEGIN
	SELECT 
		DishID,
		DishTypeID,
		DishName, 
		DishPrice 
	FROM msDish WITH(NOLOCK)
	WHERE AuditedActivity <> 'D'
END
GO
/****** Object:  StoredProcedure [dbo].[Dish_GetByID]    Script Date: 20/05/2021 7:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
 * Created by: Jonathan Ibrahim
 * Date: 10 Mar 2021
 * Purpose: Get dish tertentu by Id
 */
CREATE PROCEDURE [dbo].[Dish_GetByID]
	@DishId INT
AS
BEGIN
	SELECT 
		DishID,
		DishTypeID,
		DishName, 
		DishPrice 
	FROM msDish WITH(NOLOCK)
	WHERE DishId = @DishId AND AuditedActivity <> 'D'
END
GO
/****** Object:  StoredProcedure [dbo].[Dish_InsertUpdate]    Script Date: 20/05/2021 7:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
 * Created by: Jonathan Ibrahim
 * Date: 10 Mar 2021
 * Purpose: Insert atau update dish
 */
CREATE PROCEDURE [dbo].[Dish_InsertUpdate]
	@DishID INT OUTPUT,
	@DishTypeID INT,
	@DishName VARCHAR(100),
	@DishPrice INT
AS
BEGIN
	DECLARE @RetVal INT
	IF EXISTS (SELECT 1 FROM msDish WITH(NOLOCK) WHERE DishID = @DishID AND AuditedActivity <> 'D')
	BEGIN
		UPDATE msDish
		SET DishName = @DishName,
			DishTypeID = @DishTypeID,
			DishPrice = @DishPrice,
			AuditedActivity = 'U',
			AuditedTime = GETDATE()
		WHERE DishID = @DishID AND AuditedActivity <> 'D'
		SET @RetVal = @DishID
	END
	ELSE
	BEGIN
		INSERT INTO msDish 
		(DishName, DishTypeID, DishPrice, AuditedActivity, AuditedTime)
		VALUES
		(@DishName, @DishTypeID, @DishPrice, 'I', GETDATE())
		SET @RetVal = SCOPE_IDENTITY()
	END
	SELECT @DishId = @RetVal
END
GO
/****** Object:  StoredProcedure [dbo].[DishType_Get]    Script Date: 20/05/2021 7:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
 * Created by: Jonathan Ibrahim
 * Date: 10 Mar 2021
 * Purpose: Get semua dish type
 */
CREATE PROCEDURE [dbo].[DishType_Get]
AS
BEGIN
	SELECT DishTypeID, DishTypeName FROM msDishType WITH(NOLOCK) 
	WHERE AuditedActivity <> 'D'
END
GO
/****** Object:  StoredProcedure [dbo].[DishType_GetByID]    Script Date: 20/05/2021 7:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
 * Created by: Jonathan Ibrahim
 * Date: 10 Mar 2021
 * Purpose: Get dish type by ID
 */
CREATE PROCEDURE [dbo].[DishType_GetByID]
	@DishTypeID INT
AS
BEGIN
	SELECT DishTypeID, DishTypeName
	FROM msDishType WITH(NOLOCK)
	WHERE DishTypeID = @DishTypeID AND AuditedActivity <> 'D'
END
GO

/*** tabble for recipe ***/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Table [dbo].[msRecipe](
	[RecipeID] [int] IDENTITY(1,1) NOT NULL,
	[RecipeName] [varchar](100) NOT NULL,
	[RecipeDescription] [varchar](300) NOT NULL, 
	[DishID] [int] NOT NULL,
	[AuditedActivity] [char](1) NOT NULL,
	[AuditedTime][datetime] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[RecipeID] ASC
)WITH(PAD_INDEX=OFF,STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)ON [PRIMARY]
GO




/*** tabble for ingredient ***/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Table [dbo].[msIngredient](
	[IngredientID][int] IDENTITY(1,1) NOT NULL,
	[IngredientName][varchar](100) NOT NULL,
	[IngredientQuantity][int] NOT NULL,
	[IngredientUnit][varchar](10) NOT NULL,
	[RecipeID][int] NOT NULL,
	[AuditedActivity][char](1) NOT NULL,
	[AuditedTime][datetime] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[IngredientID] ASC
)WITH (PAD_INDEX = OFF,STATISTICS_NORECOMPUTE=OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]	
GO

/**ADD FOREIGN KEY**/
ALTER TABLE [dbo].[msRecipe] WITH CHECK ADD FOREIGN KEY([DishID])
REFERENCES [dbo].[msDish] ([DishID])
GO

ALTER TABLE [dbo].[msIngredient] WITH CHECK ADD FOREIGN KEY([RecipeID])
REFERENCES [dbo].[msRecipe] ([RecipeID])
GO

/**StoredProcedure [dbo].[Recipe_Get]**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Recipe_Get]
AS
BEGIN
	SELECT RecipeID, 
	RecipeName,
	RecipeDescription,
	DishID FROM msRecipe WITH(NOLOCK)
	WHERE AuditedActivity<>'D'
END
GO

/**StoredProcedure [dbo].[Recipe_GetByID]**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Recipe_GetByID]
	@RecipeID INT
AS
BEGIN
	SELECT RecipeID, 
	RecipeName,
	RecipeDescription,
	DishID FROM msRecipe WITH(NOLOCK)
	WHERE RecipeID=@RecipeID AND AuditedActivity<>'D'
END
GO

/**StoredProcedure [dbo].[DishName_GetByID]**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DishName_GetByID]
	@DishID INT
AS
BEGIN
	SELECT DishName FROM msDish WITH(NOLOCK)
	WHERE DishID=@DishID AND AuditedActivity<>'D'
END
GO
/**StoredProcedure [dbo].[RecipeName_GetByID]**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RecipeName_GetByID]
	@RecipeID INT
AS
BEGIN
	SELECT RecipeName FROM msRecipe WITH(NOLOCK)
	WHERE RecipeID=@RecipeID AND AuditedActivity<>'D'
END
GO
/**StoredProcedure [dbo].[RecipeDescription_GetByID]**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RecipeDescription_GetByID]
	@RecipeID INT
AS
BEGIN
	SELECT RecipeDescription FROM msRecipe WITH(NOLOCK)
	WHERE RecipeID=@RecipeID AND AuditedActivity<>'D'
END
GO
/**StoredProcedure [dbo].[Recipe_GetByDishID]**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Recipe_GetByDishID]
	@DishID INT
AS
BEGIN
	SELECT RecipeID, 
	RecipeName,
	RecipeDescription,
	DishID FROM msRecipe WITH(NOLOCK)
	WHERE DishID=@DishID AND AuditedActivity<>'D'
END
GO
/**StoredProcedure [dbo].[Recipe_Delete]**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Recipe_Delete]
	@RecipeIDs VARCHAR(MAX)
AS
BEGIN
	Update msRecipe
	SET AuditedActivity = 'D',
		AuditedTime = GETDATE()
	WHERE RecipeID IN(SELECT value FROM fn_General_Split(@RecipeIDs, ','))
END
GO
/**StoredProcedure [dbo].[Recipe_DeleteAll]**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Recipe_DeleteAll]
	@RecipeIDs VARCHAR(MAX)
AS
BEGIN
	UPDATE msIngredient
        SET AuditedActivity = 'D',
            AuditedTime = GETDATE()
        WHERE RecipeID IN (SELECT value FROM dbo.fn_General_Split(@RecipeIDs, ','));

	Update msRecipe
	SET AuditedActivity = 'D',
		AuditedTime = GETDATE()
	WHERE RecipeID IN(SELECT value FROM fn_General_Split(@RecipeIDs, ','))
END
GO
/**StoredProcedure [dbo].[Dish_DeleteAll]**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Dish_DeleteAll]
	@DishIDs VARCHAR(MAX)
AS
BEGIN
	UPDATE msIngredient
        SET AuditedActivity = 'D',
            AuditedTime = GETDATE()
        WHERE RecipeID IN (SELECT RecipeID FROM msRecipe WHERE DishID IN (SELECT value FROM dbo.fn_General_Split(@DishIDs, ',')));

	Update msRecipe
	SET AuditedActivity = 'D',
		AuditedTime = GETDATE()
	WHERE DishID IN(SELECT value FROM fn_General_Split(@DishIDs, ','))

	UPDATE msDish
	SET AuditedActivity = 'D',
		AuditedTime = GETDATE()
	WHERE DishID IN (SELECT value FROM fn_General_Split(@DishIDs, ','))
END
GO
/**StoredProcedure [dbo].[Recipe_InsertUpdate]**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Recipe_InsertUpdate]
	@RecipeID INT OUTPUT,
	@RecipeName VARCHAR(100),
	@RecipeDescription VARCHAR(300),
	@DishID INT
AS
BEGIN
	DECLARE @RetVal INT
	IF EXISTS (SELECT 1 FROM msRecipe WITH(NOLOCK) WHERE RecipeID = @RecipeID AND AuditedActivity <> 'D')
	BEGIN
	     UPDATE msRecipe
	     SET RecipeName = @RecipeName,
		 RecipeDescription = @RecipeDescription,
		 DishID = @DishID,
		 AuditedActivity = 'U',
	         AuditedTime = GETDATE()
	     WHERE RecipeID = @RecipeID AND AuditedActivity <> 'D'
	     SET @RetVal = @RecipeID
	END
	ELSE
	BEGIN
	     INSERT INTO msRecipe
	     (RecipeName, RecipeDescription, DishID,AuditedActivity,AuditedTime)
	     VALUES
	     (@RecipeName, @RecipeDescription, @DishID, 'I', GETDATE())
	     SET @RetVal = SCOPE_IDENTITY()
	END
	SELECT @RecipeId = @Retval
END
GO



/**StoredProcedure [dbo].[Ingredient_Get]**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Ingredient_Get]
AS
BEGIN
	SELECT IngredientID, 
	IngredientName,
	IngredientQuantity,
	IngredientUnit,
	RecipeID FROM msIngredient WITH(NOLOCK)
	WHERE AuditedActivity<>'D'
END
GO


/**StoredProcedure [dbo].[Ingredient_GetByID]**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Ingredient_GetByID]
	@IngredientID INT 
AS
BEGIN
	SELECT IngredientID, 
	IngredientName,
	IngredientQuantity,
	IngredientUnit,
	RecipeID FROM msIngredient WITH(NOLOCK)
	WHERE IngredientID = @IngredientID AND AuditedActivity<>'D'
END
GO

/**StoredProcedure [dbo].[Ingredient_GetByRecipeID]**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Ingredient_GetByRecipeID]
	@RecipeID INT 
AS
BEGIN
	SELECT IngredientID, 
	IngredientName,
	IngredientQuantity,
	IngredientUnit,
	RecipeID FROM msIngredient WITH(NOLOCK)
	WHERE RecipeID = @RecipeID AND AuditedActivity<>'D'
END
GO

/**StoredProcedure [dbo].[Ingredient_Delete]**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Ingredient_Delete]
	@IngredientIDs VARCHAR(MAX)
AS
BEGIN
	Update msIngredient
	SET AuditedActivity = 'D',
		AuditedTime = GETDATE()
	WHERE IngredientID IN(SELECT value FROM fn_General_Split(@IngredientIDs, ','))
END
GO

/**StoredProcedure [dbo].[Ingredient_InsertUpdate]**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Ingredient_InsertUpdate]
	@IngredientID INT OUTPUT,
	@IngredientName VARCHAR(100),
	@IngredientQuantity INT,
	@IngredientUnit VARCHAR(10),
	@RecipeID INT
AS
BEGIN
	DECLARE @RetVal INT
	IF EXISTS (SELECT 1 FROM msIngredient WITH(NOLOCK) WHERE IngredientID = @IngredientID AND AuditedActivity <> 'D')
	BEGIN
               Update msIngredient
	       SET IngredientName = @IngredientName,
		    IngredientQuantity = @IngredientQuantity,
		    IngredientUnit = @IngredientUnit,
		    RecipeID = @RecipeID,	
		    AuditedActivity ='U',
		    AuditedTime = GETDATE()
               WHERE IngredientID = @IngredientID AND AuditedActivity<> 'D'
               SET @RetVal = @IngredientID
	END
	ELSE
	BEGIN
	       INSERT INTO msIngredient
	       (IngredientName, IngredientQuantity, IngredientUnit, RecipeID, AuditedActivity, AuditedTime)
	       VALUES
	       (@IngredientName, @IngredientQuantity, @IngredientUnit,@RecipeID,'I',GETDATE())
	       SET @RetVal = SCOPE_IDENTITY()
	END
	SELECT @IngredientId = @RetVal 
END
GO

/**Seeding into msDish **/
INSERT INTO msDish (DishTypeID, DishName, DishPrice, AuditedActivity, AuditedTime) VALUES(1,'Nasi Goreng Sapi', 50000, 'I', GETDATE()), (2,'CapCay', 60000, 'I', GETDATE()), (3,'Pasta', 55000, 'I', GETDATE())

/**Seeding into msRecipe **/
INSERT INTO msRecipe(RecipeName, RecipeDescription, DishID, AuditedActivity,AuditedTime) 
VALUES('Nasi Goreng Kambing Jawa', 'tambahkan nasi dan gula jawa','1','I',GETDATE()), 
('Nasi Goreng Kambing Jakarta', 'tambahkan nasi dan kecap','1','I',GETDATE()), 
('Capcay Chinese', 'tambahkan bakso babi','2','I',GETDATE()), 
('Capcay Jawa', 'tambahkan bakso sapi','2','I',GETDATE()), 
('Pasta Keju', 'tambahkan keju','3','I',GETDATE()), ('Pasta Nori', 'tambahkan nori','3','I',GETDATE())

/**Seeding into msIngredient **/
INSERT INTO msIngredient(IngredientName, IngredientQuantity, IngredientUnit, RecipeID, AuditedActivity, AuditedTime) VALUES ('Nasi', 2, 'sdn', 1,'I',GETDATE()), ('Kecap', 5, 'sdm', 1,'I',GETDATE()), ('Bawang putih', 2, 'siung', 1,'I',GETDATE())
-- SEEDING msDishType
INSERT INTO msDishType (DishTypeName,AuditedActivity,AuditedTime)
VALUES ('Rumahan','I',GETDATE()), ('Restoran','I',GETDATE()), ('Pinggiran','I',GETDATE())

SELECT * FROM msDish
SELECT * FROM msDishType
SELECT * FROM msRecipe
SELECT * FROM msIngredient

INSERT INTO msRecipe(RecipeName, RecipeDescription, DishID, AuditedActivity,AuditedTime) 
VALUES('Nasi Goreng Kambing Jawa', 'tambahkan nasi dan gula jawa','2','I',GETDATE()), 
('Nasi Goreng Kambing Jakarta', 'tambahkan nasi dan kecap','2','I',GETDATE())

INSERT INTO msRecipe(RecipeName, RecipeDescription, DishID, AuditedActivity,AuditedTime) 
VALUES('Pasta alonso', 'tambahkan pasta dan kerupuk','4','I',GETDATE()), 
('Pasta Verstapeen', 'tambahkan pasta dan merica','4','I',GETDATE())




