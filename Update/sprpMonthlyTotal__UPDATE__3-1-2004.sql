ALTER   PROCEDURE sprpMonthlyTotal
	@Statement_Date SMALLDATETIME
AS
	DECLARE @Customer_Balance AS MONEY
	DECLARE @Previous_Balance AS MONEY
	DECLARE @Amount AS Money

	CREATE TABLE #ledger(
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
		ledger_date,
		CASE WHEN type_id=1 THEN amount ELSE NULL END AS taxable,
		CASE WHEN type_id=2 THEN amount ELSE NULL END AS [non-taxable],
		CASE WHEN type_id=3 THEN amount ELSE NULL END AS payment,
		CASE WHEN type_id=4 THEN amount ELSE NULL END AS discount,
		CASE WHEN type_id=5 THEN amount ELSE NULL END AS interest,
		amount,
		ledger_order
	FROM
		tbl_ledger
	WHERE
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)) = CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101))
	

	SELECT @Customer_Balance = SUM(ISNULL(starting_balance,0)) FROM	tbl_Customer
	SELECT @Previous_Balance = SUM(ISNULL(amount,0)) FROM tbl_ledger WHERE CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)) < CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101))
	
	--SELECT TOP 1 @amount=amount + @Customer_Balance + @Previous_Balance FROM #ledger ORDER BY	ledger_order
	SELECT TOP 1 @amount=amount + @Customer_Balance + @Previous_Balance FROM #ledger ORDER BY ledger_date,ledger_order
--	UPDATE #ledger SET 
--		amount = @amount
--	WHERE
--		ledger_order = (SELECT TOP 1 ledger_order FROM #ledger ORDER BY	ledger_order)
/*
	UPDATE #ledger SET 
		amount = @amount
	WHERE
		ledger_order = (SELECT TOP 1 ledger_order FROM #ledger ORDER BY	ledger_date,ledger_order)
*/
	SELECT
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),ledger_date,101)) AS ledger_date,
		SUM(taxable) AS taxable,
		SUM([non-taxable]) AS [non-taxable],
		SUM(payment) AS payment,
		SUM(discount) AS discount,
		SUM(interest) AS interest,
		SUM(amount) AS amount,
		@Customer_Balance + @Previous_Balance AS previous_balance,
		@Statement_Date AS statement_date
	FROM
		#ledger
	GROUP BY
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),ledger_date,101))
	ORDER BY
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),ledger_date,101))
