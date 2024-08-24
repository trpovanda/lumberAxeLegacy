<?php
session_start();
require_once('include/config.inc');

$conn = mssql_connect($server,$mssql_user,$mssql_pass) or die("Error connecting to DB");
mssql_select_db($database,$conn) or die("Error selecting database");
$sql = mssql_init("dbo.spCustomerIdLookup",$conn);
$ids=mssql_execute($sql);
unset($sql);
?>

<html>
<head>
<title>Lumber Aid v 2.0</title>
<link rel="stylesheet" type="text/css" href="lumber.css">
</head>

<body>
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
	<tr>
		<td valign="top">
		<table border="0" cellpadding="0" style="background-color:#ffffff;" class="allBorder" cellspacing="0" width="75%">
			<tr>
				<td class="bottomBorder" colspan="3" bgcolor="#7294dd">
					<div style="margin:3px;" class="mediumFont"><b>Customer Lookup</b></div>
				</td>
			</tr>
			<tr>
				<td>
					<div style="margin:3px;">Customer Number<br>
					<select name="customer_number" id="customer_number">
					<?php
					while ($row = mssql_fetch_assoc($ids)) {
					?>
						<option value="<?php echo $row['Value'] ?>"><?php echo $row['Display'] ?></option>
					<?php
					}
					?>
					</select>
					</div>
				</td>
				<td>
					<div style="margin:3px;">Customer Name<br>
					<select name="customer_name" id="customer_name">
					<?php
					$sql =  mssql_init("dbo.spCustomerNameLookup",$conn);
					$names = mssql_execute($sql);
					unset($sql);
					mssql_close ( $conn );
					while ($row = mssql_fetch_assoc($names)) {
					?>
						<option value="<?php echo $row['Value'] ?>"><?php echo $row['Display'] ?></option>
					<?php
					}
					?>
					</select>
					</div>
				</td>
				<td>
					<input type="submit" value="Load">
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</body>
</html>