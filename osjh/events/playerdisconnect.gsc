main()
{
	self stopFollowingMe();
	self player_onDisconnect();
	self notify("disconnect");
}