ALTER PROCEDURE sprpBalanceDue
AS
	SELECT 
		c.customer_id,
		RTRIM(LTRIM(ISNULL(c.prefix,'') + ' ' + ISNULL(c.last_name,'') + CASE WHEN ISNULL(c.first_name,'')<>'' THEN ', ' + ISNULL(c.first_name,'') ELSE '' END + ' ' + ISNULL(c.middle_initial,'') + CASE WHEN LEN(ISNULL(c.prefix,'') + ISNULL(c.first_name,'') + ISNULL(c.last_name,'') + ISNULL(c.middle_initial,''))>0 THEN char(13) + char(10) ELSE '' END + ISNULL(c.company_name,''))) AS customer_name,
		MAX(ISNULL(c.starting_balance,0.00)) + ISNULL(SUM(ISNULL(l.amount,0.00)),0.00) AS amount
	FROM
		tbl_customer c LEFT OUTER JOIN tbl_ledger l ON c.customer_id = l.customer_id
	GROUP BY
		c.customer_id,
		c.prefix,
		c.last_name,
		c.first_name,
		c.middle_initial,
		c.company_name
	HAVING
		MAX(ISNULL(c.starting_balance,0.00)) + ISNULL(SUM(ISNULL(l.amount,0.00)),0.00) > 0.00
	ORDER BY
		RTRIM(LTRIM(ISNULL(c.prefix,'') + ' ' + ISNULL(c.last_name,'') + CASE WHEN ISNULL(c.first_name,'')<>'' THEN ', ' + ISNULL(c.first_name,'') ELSE '' END + ' ' + ISNULL(c.middle_initial,'') + CASE WHEN LEN(ISNULL(c.prefix,'') + ISNULL(c.first_name,'') + ISNULL(c.last_name,'') + ISNULL(c.middle_initial,''))>0 THEN char(13) + char(10) ELSE '' END + ISNULL(c.company_name,'')))

