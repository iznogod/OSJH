main(backwardsCount)
{
	if(!self OSJH\login::isLoggedIn() || !self OSJH\playerRuns::hasRunID())
		return;

	error = self OSJH\savePosition::canLoadError(backwardsCount);
	if(!error)
	{
		save = self OSJH\savePosition::getSavedPosition(backwardsCount);

		if(self OSJH\weapons::isRPG(self getCurrentWeapon()))
			giveRPG = true;
		else
			giveRPG = false;

		self OSJH\statistics::addTimeUntil(getTime() + (int(self getJumpSlowdownTimer() / 50) * 50));

		self spawn(save.origin, save.angles);
		self jumpClearStateExtended();

		self OSJH\statistics::setRPGJumps(save.RPGJumps);
		self OSJH\statistics::setNadeJumps(save.nadeJumps);
		self OSJH\statistics::setDoubleRPGs(save.doubleRPGs);
		self OSJH\checkpoints::setCurrentCheckpointID(save.checkpointID);

		self OSJH\healthRegen::onLoadPosition();
		self OSJH\weapons::onLoadPosition(giveRPG);
		self OSJH\shellShock::onLoadPosition();
		self OSJH\grenadeTimers::onLoadPosition();
		self OSJH\statistics::onLoadPosition();

		self OSJH\playerModels::onLoadPosition();

		if(getCvarInt("codversion") == 2)
			self setContents(256);
		else
			self setPerk("specialty_fastreload");

		self OSJH\savePosition::printLoadSuccess();

		return true;
	}
	else
	{
		self OSJH\savePosition::printCanLoadError(error);
		return false;
	}
}