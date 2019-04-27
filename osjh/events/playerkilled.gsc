main(inflictor, attacker, damage, meansOfDeath, weapon, vDir, hitLoc, psOffsetTime, deathAnimDuration)
{
	if(self.sessionTeam == "spectator")
		return;

	obituary(self, attacker, weapon, meansOfDeath);

	self.sessionState = "dead";

	self OSJH\playerModels::onPlayerKilled(inflictor, attacker, damage, meansOfDeath, weapon, vDir, hitLoc, psOffsetTime, deathAnimDuration);
	self OSJH\healthRegen::onPlayerKilled(inflictor, attacker, damage, meansOfDeath, weapon, vDir, hitLoc, psOffsetTime, deathAnimDuration);
	self OSJH\grenadeTimers::onPlayerKilled(inflictor, attacker, damage, meansOfDeath, weapon, vDir, hitLoc, psOffsetTime, deathAnimDuration);
	self OSJH\checkpointPointers::onPlayerKilled(inflictor, attacker, damage, meansOfDeath, weapon, vDir, hitLoc, psOffsetTime, deathAnimDuration);
	self OSJH\showRecords::onPlayerKilled(inflictor, attacker, damage, meansOfDeath, weapon, vDir, hitLoc, psOffsetTime, deathAnimDuration);

	self OSJH\statistics::addTimeUntil(getTime() + 5000);
	self OSJH\statistics::pauseTimer();

	self thread _respawn();
}

_respawn()
{
	wait 2;
	if(isDefined(self) && self.sessionState == "dead")
		self OSJH\events\spawnPlayer::main();
}