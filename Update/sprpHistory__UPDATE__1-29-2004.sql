ALTER  PROCEDURE sprpHistory
	@Customer_Id INT
AS
	DECLARE @Starting_Balance AS MONEY
	DECLARE @Total_Balance AS MONEY
	DECLARE @FirstRecord AS INT

	SELECT
		@Starting_Balance = ISNULL(starting_balance,0.00),
		@Total_Balance = (SELECT SUM(ISNULL(amount,0.00)) FROM tbl_ledger WHERE customer_id=@customer_id)
	FROM
		tbl_customer
	WHERE 
		customer_id = @Customer_ID

	SELECT
		customer_id,
		RTRIM(LTRIM(ISNULL(prefix,'') + ' ' + ISNULL(first_name,'') + ' ' + ISNULL(last_name,'') + CASE WHEN LEN(ISNULL(prefix,'') + ISNULL(first_name,'') + ISNULL(last_name,'') + ISNULL(middle_initial,''))>0 THEN char(13) + char(10) ELSE '' END + ISNULL(company_name,''))) AS customer_name,
		LTRIM(RTRIM(ISNULL(street1,'') + CASE WHEN ISNULL(street1,'')<>'' THEN char(13) + char(10) ELSE '' END + ISNULL(street2,''))) as street,
		ISNULL(city,'') + ', ' + ISNULL(state,'') + ' ' + ISNULL(zip_code,'') AS city_state_zip,
		@Starting_Balance AS starting_balance,
		@Starting_Balance + @Total_Balance AS total_balance,
		home_phone,
		work_phone,
		cell_phone,
		beeper_phone,
		partner_phone,
		fax_phone
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
		customer_id = @Customer_Id
	ORDER BY
		Statement_date,
		ledger_order