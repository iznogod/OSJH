onCheckpointsChanged()
{
	self thread _getRecords(self OSJH\checkpoints::getCheckpoints(), false);
}

onCheckpointPassed(cp)
{
	cps = [];
	cps[0] = cp;
	self thread _getRecords(cps, 1);
}

onRunFinished(cp)
{
	cps = [];
	cps[0] = cp;
	self thread _getRecords(cps, 2);
}

onPlayerConnect()
{
	self.showRecords_nameString = "";
	self.showRecords_timeString = "";
	self _hideRecords(true);
}

onSpectatorClientChanged(newClient)
{
	if(!isDefined(newClient))
		self _hideRecords(false);
	else
		self _updateRecords(newClient, newClient.showRecords_rows, undefined, true);
}

onPlayerKilled(inflictor, attacker, damage, meansOfDeath, weapon, vDir, hitLoc, psOffsetTime, deathAnimDuration)
{
	self _hideRecords(false);
}

onRunIDCreated()
{
	self _hideRecords(false);
	self.showRecords_rows = [];
	self thread _getRecords(self OSJH\checkpoints::getCheckpoints(), 0);
}

onSpawnPlayer()
{
	specs = self getSpectatorList(true);
	for(i = 0; i < specs.size; i++)
		specs[i] _updateRecords(self, self.showRecords_rows, undefined, false);
}

onSpawnSpectator()
{
	self _hideRecords(false);
}

_hideRecords(force)
{
	if(force || self.showRecords_nameString != "")
		self setClientCvar("osjh_records_names", "");
	if(force || self.showRecords_timeString != "")
		self setClientCvar("osjh_records_times", "");
	self.showRecords_nameString = "";
	self.showRecords_timeString = "";
}

_getRecords(checkpoints, persist)
{
	self endon("disconnect");

	if(persist != 1)
	{
		self notify("writeRecordsRunning");
		self endon("writeRecordsRunning");
	}

	checkpointString = "(NULL";
	for(i = 0; i < checkpoints.size; i++)
	{
		if(self OSJH\checkpoints::checkpointHasID(checkpoints[i]))
			checkpointString += ", " + self OSJH\checkpoints::getCheckpointID(checkpoints[i]);
	}
	checkpointString += ")";

	if(persist != 0)
		timePlayed = self OSJH\statistics::getTimePlayed();
	else
		timePlayed = undefined;
	

	query = "SELECT c.playerName, b.timePlayed FROM (SELECT timePlayed, runID, playerID FROM (SELECT  @prev := '') init JOIN (SELECT playerID != @prev AS first, @prev := playerID, timePlayed, runID, playerID FROM (SELECT cs.timePlayed, pr.runID, pr.playerID FROM checkpointStatistics cs INNER JOIN playerRuns pr ON pr.runID = cs.runID WHERE cs.cpID IN " + checkpointString + " AND pr.cpID IS NOT NULL AND cs.runID != " + self OSJH\playerRuns::getRunID() + ") a ORDER BY playerID, timePlayed ASC) x WHERE first ORDER BY timePlayed ASC LIMIT 10) b INNER JOIN playerInformation c ON c.playerID = b.playerID";

	rows = self OSJH\mySQL::mysqlAsyncQuery(query);

	if(!self OSJH\playerRuns::isRunFinished())
	{
		if(persist == 0)
			self.showRecords_rows = rows;
		else if(persist == 1)
			self.showRecords_persistTime = getTime() + 2000;
		else
			return;
	}
	else if(persist == 2)
		self.showRecords_rows = rows;
	else
		return;

	if(persist)
	{
		specs = self getSpectatorList(true);
		for(i = 0; i < specs.size; i++)
			specs[i] _updateRecords(self, rows, timePlayed, false);
	}
}

_updateRecords(client, rows, overrideTime, force)
{
	if(!force && (!isDefined(overrideTime) && isDefined(client.showRecords_persistTime) && client.showRecords_persistTime > getTime()))
		return;
	if(client.sessionState != "playing")
		return;

	nameString = "";
	timeString = "";

	if(!isDefined(overrideTime))
		timePlayed = client OSJH\statistics::getTimePlayed();
	else
		timePlayed = overrideTime;

	for(i = 0; i < rows.size; i++)
	{
		if(int(rows[i][1]) > timePlayed)
		{
			for(j = rows.size; j > i; j--)
				rows[j] = rows[j - 1];
			break;
		}
	}

	ownNum = i;
	rows[i][0] = client.name;
	rows[i][1] = timePlayed;
			
	for(i = 0; i < rows.size; i++)
	{
		nameString += rows[i][0] + "\n";
		timeString += rows[i][1] + "\n";
	}
	if(self.showRecords_nameString != nameString)
	{
		self setClientCvar("osjh_records_names", nameString);
		self.showRecords_nameString = nameString;
	}
	if(self.showRecords_timeString != timeString)
	{
		self setClientCvar("osjh_records_times", timeString);
		self.showRecords_timeString = timeString;
	}
}

whileAlive()
{
	specs = self getSpectatorList(true);
	for(i = 0; i < specs.size; i++)
		specs[i] _updateRecords(self, self.showRecords_rows, undefined, false);
}