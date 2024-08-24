ALTER   PROCEDURE spLedgerInsert
	@Customer_Id INT,
	@Ledger_Id VARCHAR(12),
	@Statement_Date SMALLDATETIME,
	@Ledger_Date SMALLDATETIME,
	@Amount MONEY,
	@Type_Id INT,
	@Reference VARCHAR(10)
AS
	INSERT INTO tbl_Ledger
		(ledger_id,customer_id,statement_date,ledger_date,amount,type_id,reference)
	VALUES
		(@Ledger_Id,@Customer_Id,@Statement_Date,@Ledger_Date,@Amount,@Type_Id,@Reference)

