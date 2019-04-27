onInit()
{
	precacheMenu("ingame");
	precacheMenu("osjh_settings");
}

openIngameMenu()
{
	printf("opening menu...\n\n");
	self setClientCvar("g_scriptMainMenu", "ingame");
	self openMenu("ingame");
}