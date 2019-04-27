_checkpointPassed(cp)
{
	if(self OSJH\playerRuns::hasRunID() && self OSJH\checkpoints::checkpointHasID(cp))
	{
		runID = self OSJH\playerRuns::getRunID();
		cpID = self OSJH\checkpoints::getCheckpointID(cp);
		timePlayed = self OSJH\statistics::getTimePlayed();
		self storeCheckpointPassed(runID, cpID, timePlayed);
		self thread _notifyCheckpointPassed(runID, cpID, timePlayed);
	}
}

storeCheckpointPassed(runID, cpID, timePlayed)
{
	saveCount = self OSJH\statistics::getSaveCount();
	loadCount = self OSJH\statistics::getLoadCount();
	nadeJumps = self OSJH\statistics::getNadeJumps();
	nadeThrows = self OSJH\statistics::getNadeThrows();
	RPGJumps = self OSJH\statistics::getRPGJumps();
	RPGShots = self OSJH\statistics::getRPGShots();
	doubleRPGs = self OSJH\statistics::getDoubleRPGs();
	self thread OSJH\mySQL::mysqlAsyncQueryNosave("SELECT checkpointPassed(" + runID + ", " + cpID + ", " + timePlayed + ", " + saveCount + ", " + loadCount + ", " + nadeJumps + ", " + nadeThrows + ", " + RPGJumps + ", " + RPGShots + ", " + doubleRPGs + ")");
}

_notifyCheckpointPassed(runID, cpID, timePlayed)
{
	self endon("disconnect");
	self notify("checkpointNotify");
	self endon("checkpointNotify");
	rows = self OSJH\mySQL::mysqlAsyncQuery("SELECT MIN(timePlayed) FROM checkpointStatistics cs INNER JOIN playerRuns pr ON pr.runID = cs.runID WHERE cs.cpID = " + cpID + " AND pr.cpID IS NOT NULL AND pr.runID != " + runID);
	if(rows.size && isDefined(rows[0][0]))
	{
		diff = timePlayed - int(rows[0][0]);
		if(diff > 0)
			self iprintlnbold("You passed a checkpoint ^1+" + diff);
		else if( diff < 0)
			self iprintlnbold("You passed a checkpoint ^2" + diff);
		else
			self iprintlnbold("You passed a checkpoint, no difference");
	}
	else
		self iprintlnbold("You passed a checkpoint");
}

_makeColorArray(colorString)
{
	colorStrings["0"] = (0, 0, 0);
	colorStrings["1"] = (1, 0, 0);
	colorStrings["2"] = (0, 1, 0);
	colorStrings["3"] = (1, 0.9, 0);
	colorStrings["4"] = (0, 0.1, 01);
	colorStrings["5"] = (0.2, 0.5, 0.6);
	colorStrings["6"] = (0.9, 0.3, 0.5);
	colorStrings["7"] = (1, 1, 1);

	colors = [];

	for(i = 0; i < colorString.size; i++)
	{
		if(isDefined(colorStrings[colorString[i]]))
			colors[colors.size] = colorStrings[colorString[i]];
	}

	if(!colors.size)
		colors[colors.size] = colorStrings["2"]; //green by default\

	return colors;
}

getCheckpointColors(cp)
{
	return cp.colors;
}

onInit()
{
	level.checkpoints_startCheckpoint = spawnStruct();
	level.checkpoints_startCheckpoint.childs = [];

	level.checkpoints_checkpoints = [];

	if(OSJH\mapid::hasMapID())
	{
		rows = mysql_query("SELECT a.cpID, a.x, a.y, a.z, a.radius, a.onGround, GROUP_CONCAT(b.childCpID), a.color FROM checkpoints a LEFT JOIN checkpointConnections b ON a.cpID = b.cpID WHERE a.mapID = " + OSJH\mapid::getMapID() + " GROUP BY a.cpID", true);

		checkpoints = [];
		for(i = 0; i < rows.size; i++)
		{
			checkpoint = spawnStruct();
			checkpoint.id = int(rows[i][0]);
			checkpoint.origin = (int(rows[i][1]), int(rows[i][2]), int(rows[i][3]));
			checkpoint.radius = int(rows[i][4]);
			checkpoint.onGround = (int(rows[i][5]) != 0);
			if(!isDefined(rows[i][6]))
				checkpoint.childIDs = [];
			else
				checkpoint.childIDs = strTok(rows[i][6], ",");
			checkpoint.colors = _makeColorArray(rows[i][7]);
			checkpoint.hasParent = false;
			checkpoints[checkpoints.size] = checkpoint;

		}

		for(i = 0; i < checkpoints.size; i++)
		{
			checkpoints[i].childs = [];
			for(j = 0; j < checkpoints[i].childIDs.size; j++)
			{
				found = false;
				for(k = 0; k < checkpoints.size; k++)
				{
					if(k == i)
						continue;
					if(checkpoints[k].id == int(checkpoints[i].childIDs[j]))
					{
						checkpoints[i].childs[checkpoints[i].childs.size] = checkpoints[k];
						checkpoints[k].hasParent = true;
						printf("connecting checkpoint " + checkpoints[i].id + " to child cp " + checkpoints[k].id + "\n");
						found = true;
						break;
					}
				}
				if(!found)
					printf("WARNING: Could not find child " + checkpoints[i].childIDS[j] + " for checkpoint " + checkpoints[i].id + "\n");
			}
			checkpoints[i].childIDs = undefined;
		}


		for(i = 0; i < checkpoints.size; i++)
		{
			if(!checkpoints[i].hasParent)
				level.checkpoints_startCheckpoint.childs[level.checkpoints_startCheckpoint.childs.size] = checkpoints[i];
		}
		level.checkpoints_checkpoints = checkpoints;
	}
}

checkpointHasID(cp)
{
	return (isDefined(cp) && isDefined(cp.id));
}

getCheckpointID(cp)
{
	return cp.id;
}

getCurrentCheckpointID()
{
	return self.checkpoints_checkpoint.id;
}

setCurrentCheckpointID(id)
{
	if(self OSJH\playerRuns::isRunFinished())
		return;

	oldcheckpoint = self.checkpoints_checkpoint;
	if(!isDefined(id))
		self.checkpoints_checkpoint = level.checkpoints_startCheckpoint;
	else
	{
		for(i = 0; i < level.checkpoints_checkpoints.size; i++)
		{
			if(level.checkpoints_checkpoints[i].id == id)
			{
				self.checkpoints_checkpoint = level.checkpoints_checkpoints[i];
				break;
			}
		}
	}
	if(self.checkpoints_checkpoint != oldcheckpoint)
		self OSJH\events\checkpointsChanged::main();
}

getCheckpoints()
{
	return self.checkpoints_checkpoint.childs;
}

onRunIDCreated()
{
	self.checkpoints_checkpoint = level.checkpoints_startCheckpoint;
}

whileAlive()
{
	for(i = 0; i < self.checkpoints_checkpoint.childs.size; i++)
	{
		if(distanceSquared(self.origin, self.checkpoints_checkpoint.childs[i].origin) < self.checkpoints_checkpoint.childs[i].radius * self.checkpoints_checkpoint.childs[i].radius)
		{
			if(!self.checkpoints_checkpoint.childs[i].onGround || self isOnGround())
			{
				//self iprintlnbold("You passed checkpoint with ID " + self.checkpoints_checkpoint.childs[i].id);
				cp = self.checkpoints_checkpoint.childs[i];
				self.checkpoints_checkpoint = self.checkpoints_checkpoint.childs[i];
				if(cp.childs.size == 0)
				{
					self OSJH\events\runFinished::main(cp);
				}
				else
				{
					self _checkpointPassed(cp);
					self OSJH\showRecords::onCheckpointPassed(cp);
					self OSJH\events\checkpointsChanged::main();
				}
				break;
			}
		}
	}
}