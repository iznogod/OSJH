main(nade, name)
{
	nade hide();
	nade showToPlayer(self);

	if(self OSJH\weapons::isGrenade(name))
	{
		self OSJH\weapons::onGrenadeThrow(nade, name);
		self OSJH\grenadeTimers::onGrenadeThrow(nade, name);
		self OSJH\statistics::onGrenadeThrow(nade, name);
	}
	else
		nade delete();
}