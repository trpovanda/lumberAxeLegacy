ALTER          PROCEDURE sprpStatement
	@Customer_Id 		INT,
	@Statement_Date SMALLDATETIME
AS
	DECLARE @Previous_Balance AS MONEY
	DECLARE @Starting_Balance AS MONEY
	DECLARE @Over120 AS MONEY
	DECLARE @Over60 AS MONEY
	DECLARE @Over90 AS MONEY
	DECLARE @Total_Balance AS MONEY
	DECLARE @FirstRecord AS VARCHAR(12)

	SELECT
		@Starting_Balance = ISNULL(starting_balance,0.00)
	FROM
		tbl_customer
	WHERE 
		customer_id = @Customer_ID
	
	SELECT
		@Previous_Balance = SUM(ISNULL(amount,0.00)) 
	FROM
		tbl_ledger
	WHERE 
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)) < CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101))  AND
		customer_id = @customer_id
	
	SELECT @Over120 = SUM(ISNULL(amount,0.00)) FROM tbl_ledger WHERE customer_id=@Customer_Id AND CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)) < DATEADD(DAY,-120,CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101)))
	SELECT @Over60 = SUM(ISNULL(amount,0.00)) FROM tbl_ledger WHERE customer_id=@Customer_Id AND CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)) < DATEADD(DAY,-60,CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101)))
	SELECT @Over90 = SUM(ISNULL(amount,0.00)) FROM tbl_ledger WHERE customer_id=@Customer_Id AND CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)) < DATEADD(DAY,-90,CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101)))
	SELECT @Total_Balance = SUM(ISNULL(amount,0.00)) FROM tbl_ledger WHERE customer_id=@Customer_Id 

	SELECT
		customer_id,
		RTRIM(LTRIM(ISNULL(prefix,'') + ' ' + ISNULL(first_name,'') + ' ' + ISNULL(last_name,'') + CASE WHEN LEN(ISNULL(prefix,'') + ISNULL(first_name,'') + ISNULL(last_name,'') + ISNULL(middle_initial,''))>0 THEN char(13) + char(10) ELSE '' END + ISNULL(company_name,''))) AS customer_name,
		LTRIM(RTRIM(ISNULL(street1,'') + CASE WHEN ISNULL(street1,'')<>'' THEN char(13) + char(10) ELSE '' END + ISNULL(street2,''))) as street,
		ISNULL(city,'') + ', ' + ISNULL(state,'') + ' ' + ISNULL(zip_code,'') AS city_state_zip,
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101)) as statement_date,
		ISNULL(@Previous_Balance,0.00) + ISNULL(@Starting_Balance,0.00) as previous_balance,
		ISNULL(@Total_Balance + @Starting_Balance,0) AS total_balance
	FROM
		tbl_customer
	WHERE 
		customer_id = @customer_id

	SELECT TOP 1
		@FirstRecord = ledger_id
	FROM 
		tbl_ledger 
	WHERE 
		customer_id = @Customer_id AND
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)) = CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101))
	ORDER BY
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)),
		ledger_order
	
	SELECT 
		ledger_id,
		ledger_date,
		CASE WHEN type_id=1 THEN amount ELSE NULL END AS taxable,
		CASE WHEN type_id=2 THEN amount ELSE NULL END AS [non-taxable],
		CASE WHEN type_id=3 THEN amount ELSE NULL END AS payment,
		CASE WHEN type_id=4 THEN amount ELSE NULL END AS discount,
		CASE WHEN type_id=5 THEN amount ELSE NULL END AS interest,
		reference,
		CASE WHEN ledger_id = @FirstRecord THEN amount + ISNULL(@Previous_Balance,0.00) + ISNULL(@Starting_Balance,0.00) ELSE amount END AS amount
	FROM
		tbl_ledger
	WHERE
		customer_id = @Customer_Id AND
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)) = CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101))
	ORDER BY
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)),
		ledger_order

	SELECT @Over120 = SUM(ISNULL(amount,0.00)) FROM tbl_ledger WHERE customer_id=@Customer_Id AND CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)) < DATEADD(DAY,-120,CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101)))
	SELECT @Over60 = SUM(ISNULL(amount,0.00)) FROM tbl_ledger WHERE customer_id=@Customer_Id AND CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)) < DATEADD(DAY,-60,CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101)))
	SELECT @Over90 = SUM(ISNULL(amount,0.00)) FROM tbl_ledger WHERE customer_id=@Customer_Id AND CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)) < DATEADD(DAY,-90,CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101)))
	SELECT @Total_Balance = SUM(ISNULL(amount,0.00)) FROM tbl_ledger WHERE customer_id=@Customer_Id 
	SELECT
		ISNULL(ISNULL(@Over120,0.00) + @Starting_Balance,0) AS Over120,
		ISNULL(ISNULL(@Over60,0.00) + @Starting_Balance,0) AS Over60,
		ISNULL(ISNULL(@Over90,0.00) + @Starting_Balance,0) AS Over90,
		ISNULL(@Total_Balance + @Starting_Balance,0) AS Total_Balance
