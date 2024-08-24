CREATE PROCEDURE sprpMonthlyTotal
	@Statement_Date SMALLDATETIME
AS
	CREATE TABLE #ledger(
		ledger_date   SMALLDATETIME,
		taxable 			MONEY,
		[non-taxable] MONEY,
		payment 			MONEY,
		discount 			MONEY,
		interest 			MONEY,
		amount				MONEY
	)

	INSERT INTO #ledger
	SELECT
		ledger_date,
		CASE WHEN type_id=1 THEN amount ELSE NULL END AS taxable,
		CASE WHEN type_id=2 THEN amount ELSE NULL END AS [non-taxable],
		CASE WHEN type_id=3 THEN amount ELSE NULL END AS payment,
		CASE WHEN type_id=4 THEN amount ELSE NULL END AS discount,
		CASE WHEN type_id=5 THEN amount ELSE NULL END AS interest,
		amount
	FROM
		tbl_ledger
	WHERE
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),statement_date,101)) = CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),@statement_date,101))
	
	SELECT
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),ledger_date,101)) AS ledger_date,
		SUM(taxable) AS taxable,
		SUM([non-taxable]) AS [non-taxable],
		SUM(payment) AS payment,
		SUM(discount) AS discount,
		SUM(interest) AS interest,
		SUM(amount) AS amount
	FROM
		#ledger
	GROUP BY
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),ledger_date,101))
	ORDER BY
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(50),ledger_date,101))
