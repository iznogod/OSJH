main()
{
	if(!self OSJH\login::isLoggedIn() || !self OSJH\playerRuns::hasRunID())
		return;

	printf("trying to spawn\n");
	self notify("spawned");

	resetTimeout();

	self.sessionTeam = "allies";
	self.sessionState = "playing";
	self.spectatorClient = -1;
	self.archiveTime = 0;
	self.psOffsetTime = 0;
	self.pers["team"] = "allies";

	error = self OSJH\savePosition::canLoadError(0);
	
	if(!error)
	{
		save = self OSJH\savePosition::getSavedPosition(0);
		self spawn(save.origin, save.angles);

		self OSJH\statistics::setRPGJumps(save.RPGJumps);
		self OSJH\statistics::setNadeJumps(save.nadeJumps);
		self OSJH\statistics::setDoubleRPGs(save.doubleRPGs);
		self OSJH\checkpoints::setCurrentCheckpointID(save.checkpointID);

		self OSJH\statistics::onLoadPosition();
	}
	else
	{
		spawnpoint = self OSJH\spawnpoints::getPlayerSpawnpoint();
		self spawn(spawnpoint.origin, spawnpoint.angles);
		self OSJH\checkpoints::setCurrentCheckpointID(undefined);
	}

	self OSJH\healthRegen::onSpawnPlayer();
	self OSJH\weapons::onSpawnPlayer();
	self OSJH\shellShocK::onSpawnPlayer();
	self OSJH\grenadeTimers::onSpawnPlayer();
	self OSJH\buttonPress::onSpawnPlayer();
	self OSJH\savePosition::onSpawnPlayer();
	self OSJH\playerModels::onSpawnPlayer();
	self OSJH\playerRuns::onSpawnPlayer();
	self OSJH\statistics::onSpawnPlayer();
	self OSJH\showRecords::onSpawnPlayer();
	self OSJH\checkpointPointers::onSpawnPlayer();

	if(getCvarInt("codversion") == 2)
		self setContents(256);
	else
	{
		self setPerk("specialty_fastreload");
		self setPerk("specialty_longersprint");
	}

	self thread OSJH\events\whileAlive::main();

	self thread _dummy();
}

_dummy()
{
	waittillframeend;
	if(isDefined(self))
		self notify("spawned_player");
}