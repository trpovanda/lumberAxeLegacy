ALTER  PROCEDURE sprpStatement
	@Customer_Id 		INT,
	@Statement_Date SMALLDATETIME
AS
	DECLARE @Previous_Balance AS MONEY
	DECLARE @Starting_Balance AS MONEY
	DECLARE @Over30 AS MONEY
	DECLARE @Over60 AS MONEY
	DECLARE @Over90 AS MONEY
	DECLARE @Total_Balance AS MONEY
	DECLARE @FirstRecord AS INT

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

	SELECT
		customer_id,
		RTRIM(LTRIM(ISNULL(prefix,'') + ' ' + ISNULL(last_name,'') + CASE WHEN ISNULL(first_name,'')<>'' THEN ', ' + ISNULL(first_name,'') ELSE '' END + ' ' + ISNULL(middle_initial,'') + CASE WHEN LEN(ISNULL(prefix,'') + ISNULL(first_name,'') + ISNULL(last_name,'') + ISNULL(middle_initial,''))>0 THEN char(13) + char(10) ELSE '' END + ISNULL(company_name,''))) AS customer_name,
		LTRIM(RTRIM(ISNULL(street1,'') + CASE WHEN ISNULL(street1,'')<>'' THEN char(13) + char(10) ELSE '' END + ISNULL(street2,''))) as street,
		city,
		state,
		zip_code,
		@Statement_Date as statement_date,
		ISNULL(@Previous_Balance,0.00) + ISNULL(@Starting_Balance,0.00) as previous_balance
	FROM
		tbl_customer
	WHERE 
		customer_id = @customer_id

	SELECT TOP 1
		@FirstRecord = ledger_id
	FROM 
		tbl_ledger 
	WHERE 
		customer_id = @Customer_id
	ORDER BY
		Statement_date,
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
		CASE WHEN ledger_id = @FirstRecord THEN amount + @Starting_Balance ELSE amount END AS amount
	FROM
		tbl_ledger
	WHERE
		customer_id = @Customer_Id AND
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)) = CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101))

	SELECT @Over30 = SUM(ISNULL(amount,0.00)) FROM tbl_ledger WHERE customer_id=@Customer_Id AND CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),ledger_date,101)) < DATEADD(DAY,-30,CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101)))
	SELECT @Over60 = SUM(ISNULL(amount,0.00)) FROM tbl_ledger WHERE customer_id=@Customer_Id AND CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),ledger_date,101)) < DATEADD(DAY,-60,CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101)))
	SELECT @Over90 = SUM(ISNULL(amount,0.00)) FROM tbl_ledger WHERE customer_id=@Customer_Id AND CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),ledger_date,101)) < DATEADD(DAY,-90,CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101)))
	SELECT @Total_Balance = SUM(ISNULL(amount,0.00)) FROM tbl_ledger WHERE customer_id=@Customer_Id 
	SELECT
		@Over30 + @Starting_Balance AS Over30,
		@Over60 + @Starting_Balance AS Over60,
		@Over90 + @Starting_Balance AS Over90,
		@Total_Balance + @Starting_Balance AS Total_Balance

