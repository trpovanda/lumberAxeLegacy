ALTER  PROCEDURE spCustomerInsert
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
	@cc_Type					INT
AS
	INSERT INTO tbl_customer 
		(customer_id,company_name,prefix,first_name,last_name,middle_initial,home_phone,work_phone,cell_phone,beeper_phone,partner_phone,fax_phone,cc_number,cc_date,starting_balance,street1,street2,city,state,zip_code,cc_street1,cc_street2,cc_city,cc_state,cc_zip_code,cc_type)
	VALUES
		(@Customer_Id,@Company_Name,@Prefix,@First_Name,@Last_Name,@Middle_Initial,@Home_Phone,@Work_Phone,@Cell_Phone,@Beeper_Phone,@Partner_Phone,@fax_phone,@cc_Number,@cc_Date,@Starting_Balance,@Street1,@Street2,@City,@State,@Zip_Code,@cc_Street1,@cc_Street2,@cc_City,@cc_State,@cc_Zip_Code,@cc_Type)

