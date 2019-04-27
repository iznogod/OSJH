main()
{
	self iprintlnbold("Login completed");
	printf("login completed\n\n");

	self OSJH\playerRuns::onPlayerLogin();
	self OSJH\commands::onPlayerLogin();
	self OSJH\country::onPlayerLogin();
}