ALTER   PROCEDURE spLedgerUpdate
	@Customer_Id INT,
	@Ledger_Id VARCHAR(12),
	@Statement_Date SMALLDATETIME,
	@Ledger_Date SMALLDATETIME,
	@Amount MONEY,
	@Type_Id INT,
	@Reference VARCHAR(10)
AS
	UPDATE tbl_ledger SET
		statement_date = @Statement_Date,
		ledger_date = @Ledger_Date,
		amount = @Amount,
		type_id = @Type_Id,
		reference = @Reference
	WHERE
		customer_id = @Customer_Id AND
		ledger_id = @Ledger_Id
