requestUID()
{
	uid = [];
	for(i = 0; i < 4; i++)
		uid[i] = self getStat(3232 + i);
	return uid;
}

storeUID(uid)
{
	for(i = 0; i < 4; i++)
		self setStat(3232 + i, uid[i]);
	self OSJH\menus::openIngameMenu();
}

onPlayerCommand(args)
{
	return false;
}