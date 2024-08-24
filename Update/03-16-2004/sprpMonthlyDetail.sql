ALTER    PROCEDURE sprpMonthlyDetail
	@Statement_Date SMALLDATETIME
AS
	DECLARE @Customer_Balance AS MONEY
	DECLARE @Previous_Balance AS MONEY
	DECLARE @Amount AS Money

	CREATE TABLE #ledger(
		ledger_id			VARCHAR(12),
		customer_id   INT,
		customer_name VARCHAR(500),
		ledger_date   SMALLDATETIME,
		taxable 			MONEY,
		[non-taxable] MONEY,
		payment 			MONEY,
		discount 			MONEY,
		interest 			MONEY,
		amount				MONEY,
		ledger_order  INT
	)	

	INSERT INTO #ledger
	SELECT
		l.ledger_id,
		l.customer_id,
		RTRIM(LTRIM(ISNULL(c.prefix,'') + ' ' + ISNULL(c.last_name,'') + CASE WHEN ISNULL(c.first_name,'')<>'' THEN ', ' + ISNULL(c.first_name,'') ELSE '' END + ' ' + ISNULL(c.middle_initial,'') + CASE WHEN LEN(ISNULL(c.first_name,'') + ISNULL(c.last_name,'') + ISNULL(c.middle_initial,''))>0 THEN char(13) + char(10) ELSE '' END + ISNULL(c.company_name,''))) AS customer_name,
		l.ledger_date,
		CASE WHEN l.type_id=1 THEN amount ELSE NULL END AS taxable,
		CASE WHEN l.type_id=2 THEN amount ELSE NULL END AS [non-taxable],
		CASE WHEN l.type_id=3 THEN amount ELSE NULL END AS payment,
		CASE WHEN l.type_id=4 THEN amount ELSE NULL END AS discount,
		CASE WHEN l.type_id=5 THEN amount ELSE NULL END AS interest,
		l.amount,
		l.ledger_order
	FROM
		tbl_ledger l INNER JOIN tbl_customer c ON l.customer_id = c.customer_id
	WHERE
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)) = CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101))

	SELECT @Customer_Balance = SUM(ISNULL(starting_balance,0)) FROM	tbl_Customer
	SELECT @Previous_Balance = SUM(ISNULL(amount,0)) FROM tbl_ledger WHERE CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)) < CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101))
	
	SELECT TOP 1 @amount=amount + @Customer_Balance + @Previous_Balance FROM #ledger ORDER BY ledger_date,ledger_order
	
  SELECT 
		Ledger_id,
		customer_id,
		customer_name,
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),ledger_date,101)) AS ledger_date,
		taxable,
		[non-taxable],
		payment,
		discount,
		interest,
		amount,
		@Customer_Balance + @Previous_Balance AS previous_balance,
		@Statement_Date AS statement_date
	FROM 
		#ledger
	ORDER BY
		ledger_date,
		ledger_order

