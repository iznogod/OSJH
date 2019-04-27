onPlayerConnect()
{
	self disableWASDCallback();
	self.playerRuns_spawnLinker = spawn("script_origin", (0, 0, 0));
}

onPlayerLogin()
{
	self thread _createRunID(false);
}

hasRunID()
{
	return isDefined(self.playerRuns_runID);
}

getRunID()
{
	return self.playerRuns_runID;
}

resetRunID()
{
	if(!self hasRunID())
	{
		self iprintlnbold("Cannot reset run right now");
		return;
	}
	else
	{
		self.playerRuns_runID = undefined;
		self thread _createRunID(true);
	}
}

onRunFinished(cp)
{
	self.playerRuns_runFinished = true;
	if(self OSJH\playerRuns::hasRunID() && self OSJH\checkpoints::checkpointHasID(cp))
	{
		runID = self OSJH\playerRuns::getRunID();
		cpID = self OSJH\checkpoints::getCheckpointID(cp);
		self thread OSJH\mySQL::mysqlAsyncQueryNosave("SELECT runFinished(" + runID + ", " + cpID + ")");
	}
}

isRunFinished()
{
	return (self hasRunID() && self.playerRuns_runFinished);
}

_createRunID(spawn)
{
	if(!self OSJH\login::IsLoggedIn())
		return;

	self endon("disconnect");

	rows = self OSJH\mySQL::mysqlAsyncQuery("SELECT createRunID(" + self OSJH\login::getPlayerID() + ")");

	if(!rows.size || !isDefined(rows[0][0]))
	{
		self iprintlnbold("Could not create runID. Please reconnect");
	}
	else
	{
		self.playerRuns_runID = rows[0][0];
		self OSJH\events\runIDCreated::main(spawn);
	}
}

hasRunStarted()
{
	return (isDefined(self.playerRuns_runStarted) && self.playerRuns_runStarted);
}

onRunIDCreated()
{
	self.playerRuns_runStarted = false;
	self.playerRuns_runFinished = false;
}

onSpawnPlayer()
{
	if(!self.playerRuns_runStarted)
	{
		printf("linking to spawn\n");
		self.playerRuns_spawnLinker.origin = self.origin;
		self linkTo(self.playerRuns_spawnLinker);
		self enableWASDCallback();
	}
	else
		self OSJH\statistics::startTimer();
}

onSpawnSpectator()
{
	self disableWASDCallback();
	self OSJH\statistics::pauseTimer();
}

onWASDPressed()
{
	self disableWASDCallback();
	if(self OSJH\login::isLoggedIn() && self OSJH\playerRuns::hasRunID() && self.sessionState == "playing" && !self.playerRuns_runStarted)
	{
		printf("unlinking from spawn\n");
		self.playerRuns_runStarted = true;
		self unLink();
		self OSJH\statistics::startTimer();
	}
}