ALTER   PROCEDURE sprpBalanceDue
AS
	CREATE TABLE #customers(
		customer_id INT,
		amount MONEY)

	CREATE TABLE #customersSum(
		customer_id INT,
		amount MONEY)
	
	INSERT INTO #customers
	SELECT
		l.customer_id,
		SUM(ISNULL(l.amount,0.00))
	FROM
		tbl_ledger l
	GROUP BY
		l.customer_id

	INSERT INTO #customers
	SELECT
		c.customer_id,
		ISNULL(c.starting_balance,0.00)
	FROM
		tbl_customer c

	INSERT INTO #customersSum
	SELECT
		customer_id,
		SUM(ISNULL(amount,0.00))
	FROM
		#customers
	GROUP BY
		customer_id
	
	SELECT
		c.customer_id AS customer_id,
		RTRIM(LTRIM(ISNULL(c.prefix,'') + ' ' + ISNULL(c.last_name,'') + CASE WHEN ISNULL(c.first_name,'')<>'' THEN ', ' + ISNULL(c.first_name,'') ELSE '' END + ' ' + ISNULL(c.middle_initial,'') + CASE WHEN LEN(ISNULL(c.first_name,'') + ISNULL(c.last_name,'') + ISNULL(c.middle_initial,''))>0 THEN char(13) + char(10) ELSE '' END + ISNULL(c.company_name,''))) AS customer_name,
		tc.amount AS amount
	FROM
		tbl_customer c INNER JOIN #customersSum tc ON c.customer_id=tc.customer_id
	WHERE
		tc.amount<>0.00


