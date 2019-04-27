onInit()
{
	precacheMenu("clientcmd");
}

execClientCmd(cmd)
{
	self setClientCvar("clientcmd", cmd);
	self openMenu("clientcmd");
	self closeMenu();
}