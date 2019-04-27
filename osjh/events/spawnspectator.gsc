main()
{
	self notify("spawned");

	resetTimeout();

	self.sessionState = "spectator";
	self.sessionTeam = "spectator";
	self.spectatorClient = -1;
	self.archiveTime = 0;
	self.pers["team"] = "spectator";

	spawnpoint = self OSJH\spawnpoints::getSpectatorSpawnpoint();
	self spawn(spawnpoint.origin, (0, 0, 0));

	self OSJH\shellShock::onSpawnSpectator();
	self OSJH\healthRegen::onSpawnSpectator();
	self OSJH\statistics::onSpawnSpectator();
	self OSJH\playerRuns::onSpawnSpectator();
	self OSJH\showRecords::onSpawnSpectator();
	self OSJH\checkpointPointers::onSpawnSpectator();

	self stopFollowingMe();
}