onSpawnPlayer()
{
	self notify("stopHealthRegen");

	self OSJH\statistics::addTimeUntil(self.healthRegen_completedTime);
	self.healthRegen_completedTime = undefined;


	self.maxHealth = 100;
	self.health = self.maxHealth;
}

onRunIDCreated()
{
	self.healthRegen_completedTime = undefined;
}

onLoadPosition()
{
	self notify("stopHealthRegen");
	self.health = self.maxHealth;

	self OSJH\statistics::addTimeUntil(self.healthRegen_completedTime);
	self.healthRegen_completedTime = undefined;
}

onSpawnSpectator()
{
	self notify("stopHealthRegen");

	self OSJH\statistics::addTimeUntil(self.healthRegen_completedTime);
	self.healthRegen_completedTime = undefined;
}

onPlayerDamage(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, hitLoc, psOffsetTime)
{
	self thread _startHealthRegen();
}

onPlayerKilled(inflictor, attacker, damage, meansOfDeath, weapon, vDir, hitLoc, psOffsetTime, deathAnimDuration)
{
	self notify("stopHealthRegen");
}

_startHealthRegen()
{
	self notify("stopHealthRegen");
	self endon("stopHealthRegen");

	if(self.health < self.maxHealth * 0.35)
		self.healthRegen_completedTime = getTime() + 5000 + int((self.maxHealth - self.health) / 10)*50;
	else
		self.healthRegen_completedTime = getTime() + 5000;

	wait 5;

	if(self.health < self.maxHealth * 0.35)
	{
		self playLocalSound("breathing_better");
		while(self.health < self.maxHealth)
		{
			self.health += int(0.1 * self.maxHealth);
			if(self.health > self.maxHealth)
				self.health = self.maxHealth;
			self setNormalHealth(self.health / self.maxHealth);
			wait 0.05;
		}
	}
	else
	{
		self.health = self.maxHealth;
		self setNormalHealth(1.0);
		self playLocalSound("breathing_better");
	}
	self.healthRegen_completedTime = undefined;
}