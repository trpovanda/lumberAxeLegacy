ALTER   PROCEDURE spLedgerDelete
	@Customer_Id INT,
	@Ledger_Id VARCHAR(12)
AS
	DELETE FROM tbl_ledger WHERE customer_id = @Customer_Id AND ledger_id = @Ledger_Id