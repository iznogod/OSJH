main(cp)
{
	if(self OSJH\playerRuns::hasRunID() && self OSJH\checkpoints::checkpointHasID(cp))
	{
		runID = self OSJH\playerRuns::getRunID();
		cpID = self OSJH\checkpoints::getCheckpointID(cp);
		timePlayed = self OSJH\statistics::getTimePlayed();
		self OSJH\checkpoints::storeCheckpointPassed(runID, cpID, timePlayed);
		self thread _notifyFinishedMap(runID, cpID, timePlayed);
	}
	self OSJH\playerRuns::onRunFinished(cp);
	self OSJH\statistics::onRunFinished(cp);
	self OSJH\checkpointPointers::onRunFinished(cp);
	self OSJH\showRecords::onRunFinished(cp);
}

_notifyFinishedMap(runID, cpID, timePlayed)
{
	self endon("disconnect");
	self notify("mapFinishNotify");
	self endon("mapFinishNotify");
	rows = self OSJH\mySQL::mysqlAsyncQuery("SELECT MIN(timePlayed) FROM checkpointStatistics cs INNER JOIN playerRuns pr ON pr.runID = cs.runID WHERE cs.cpID = " + cpID + " AND pr.cpID IS NOT NULL AND pr.runID != " + runID);
	if(rows.size && isDefined(rows[0][0]))
	{
		diff = timePlayed - int(rows[0][0]);
		if(diff > 0)
			self iprintlnbold("You finished the map ^1+" + diff);
		else if( diff < 0)
			self iprintlnbold("You finished the map ^2" + diff);
		else
			self iprintlnbold("You finished the map, no difference");
	}
	else
		self iprintlnbold("You finished the map");
}