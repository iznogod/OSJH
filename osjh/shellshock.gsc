onInit()
{
	precacheShellShock("default");
}

onRunIDCreated()
{
	self.shellShock_completedTime = undefined;
}

onPlayerDamage(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, hitLoc, psOffsetTime)
{
	if(meansOfDeath == "MOD_EXPLOSIVE" || meansOfDeath == "MOD_GRENADE" || meansOfDeath == "MOD_GRENADE_SPLASH" || meansOfDeath == "MOD_PROJECTILE" || meansOfDeath == "MOD_PROJECTILE_SPLASH")
	{
		if(damage >= 90)
			t = 4;
		else if(damage >= 50)
			t = 3;
		else if(damage >= 25)
			t = 2;
		else if(damage >= 10)
			t = 1;
		else
			return;
		self shellShock("default", t);
		self.shellShock_completedTime = getTime() + t * 1000;
	}
}

onSpawnSpectator()
{
	self stopShellShock();
	self OSJH\statistics::addTimeUntil(self.shellShock_completedTime);
	self.shellShock_completedTime = undefined;
}

onLoadPosition()
{
	self stopShellShock();
	self OSJH\statistics::addTimeUntil(self.shellShock_completedTime);
	self.shellShock_completedTime = undefined;
}

onSpawnPlayer()
{
	self stopShellShock();
	self OSJH\statistics::addTimeUntil(self.shellShock_completedTime);
	self.shellShock_completedTime = undefined;
}