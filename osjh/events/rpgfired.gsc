main(rpg, name)
{
	rpg hide();
	rpg showToPlayer(self);
	
	if(self OSJH\weapons::isRPG(name))
	{
		self OSJH\weapons::onRPGFired(rpg, name);
		self OSJH\statistics::onRPGFired(rpg, name);
	}
	else
	{
		rpg delete();
	}
}