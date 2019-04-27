onInit()
{
	setting_deleteAll();
}

onPlayerConnect()
{
	printf("Clearing settings\n\n\n\n");
	self setting_clear();
}