ALTER  PROCEDURE spCustomerUpdate
	@Customer_id      INT,
  @Company_Name     VARCHAR(255),
  @Prefix           VARCHAR(5),
  @First_Name				VARCHAR(255),
	@Last_Name				VARCHAR(255),
	@Middle_Initial		CHAR(1),
	@Home_Phone				CHAR(12),
	@Work_Phone				CHAR(12),
	@Cell_Phone				CHAR(12),
	@Beeper_Phone			CHAR(12),
	@Partner_Phone		CHAR(12),
	@Fax_Phone				CHAR(12),
	@cc_Number				VARCHAR(255),
	@cc_date					SMALLDATETIME,
	@Starting_Balance	MONEY,
	@Street1					VARCHAR(255),
	@Street2					VARCHAR(255),
	@City							VARCHAR(255),
	@State						CHAR(2),
	@Zip_Code					CHAR(5),
	@cc_Street1				VARCHAR(255),
	@cc_Street2				VARCHAR(255),
	@cc_City					VARCHAR(255),
	@cc_State					CHAR(2),
	@cc_Zip_Code			CHAR(5),
	@cc_type					INT
AS
	UPDATE tbl_customer SET
		company_name=@company_name,
		prefix=@prefix,
		first_name=@first_name,
		last_name=@last_name,
		middle_initial=@middle_initial,
		home_phone=@home_phone,
		work_phone=@work_phone,
		cell_phone=@cell_phone,
		beeper_phone=@beeper_phone,
		partner_phone=@partner_phone,
		fax_phone = @fax_phone,	
		cc_number=@cc_number,
		cc_date=@cc_date,
		starting_balance=@starting_balance,
		street1=@street1,
		street2=@street2,
		city=@city,
		state=@state,
		zip_code=@zip_code,
		cc_street1=@cc_street1,
		cc_street2=@cc_street2,
		cc_city=@cc_city,
		cc_state=@cc_state,
		cc_zip_code=@cc_zip_code,
		cc_type=@cc_type
	WHERE
		customer_id=@customer_id

