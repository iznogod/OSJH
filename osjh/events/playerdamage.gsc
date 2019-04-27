main(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, hitLoc, psOffsetTime)
{
	if(self.sessionState != "playing")
		return;

	if(!isdefined(vDir))
		flags |= 4; //iDFLAGS_NO_KNOCKBACK;

	if(isDefined(attacker) && isPlayer(attacker) && self != attacker)
		return;

	if(damage < 1)
		damage = 1;

	if(self OSJH\weapons::isRPG(weapon))
		return;

	if(damage >= self.health)
	{
		if(self OSJH\events\loadPosition::main(0))
		{
			self OSJH\statistics::addTimeUntil(getTime() + 5000);
			return;
		}
	}

	self finishPlayerDamage(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, hitLoc, psOffsetTime);

	self OSJH\shellShock::onPlayerDamage(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, hitLoc, psOffsetTime);
	self OSJH\healthRegen::onPlayerDamage(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, hitLoc, psOffsetTime);
	self OSJH\statistics::onPlayerDamage(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, hitLoc, psOffsetTime);
}