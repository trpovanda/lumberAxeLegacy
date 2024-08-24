ALTER  PROCEDURE spCustomerNameLookup
AS
	SELECT
		customer_id AS Value,
		company_name AS Display
	FROM
		tbl_customer
	WHERE 
		ISNULL(LTRIM(RTRIM(company_name)),'')<>''
		
UNION
	
	SELECT
		customer_id AS Value,
		RTRIM(LTRIM(ISNULL(last_name,'') + 
		CASE WHEN ISNULL(last_name,'')<>'' THEN ', ' ELSE '' END + 
		ISNULL(first_name,'') + 
		CASE WHEN ISNULL(first_name,'')<> '' THEN ' ' ELSE '' END + 
		ISNULL(middle_initial,''))) AS Display
	FROM 
		tbl_customer
	WHERE
		RTRIM(LTRIM(ISNULL(last_name,'') + 
		CASE WHEN ISNULL(last_name,'')<>'' THEN ', ' ELSE '' END + 
		ISNULL(first_name,'') + 
		CASE WHEN ISNULL(first_name,'')<> '' THEN ' ' ELSE '' END + 
		ISNULL(middle_initial,''))) <> ''
	ORDER BY 
		Display
