onPlayerConnect()
{
	self _hideStatisticsHud(true);
}

onSpectatorClientChanged(newClient)
{
	if(!isDefined(newClient))
		self _hideStatisticsHud(false);
	else
		self _drawStatisticsHUD(newClient);
}

whileAlive()
{
	if(self isOnGround())
		self.statistics_lastJump = undefined;

	if(self.statistics_AFKOrigin != self.origin)
	{
		self.statistics_AFKTimer = getTime() + 5000;
		self.statistics_AFKOrigin = self.origin;
		if(self OSJH\playerRuns::hasRunStarted())
			self OSJH\statistics::startTimer();
	}
	else if(self.statistics_AFKTimer < getTime())
	{
		self OSJH\statistics::pauseTimer();
	}

	
	specs = self getSpectatorList(true);
	for(i = 0; i < specs.size; i++)
		specs[i] _drawStatisticsHud(self);
}

onSpawnPlayer()
{
	self.statistics_AFKOrigin = self.origin;
	self.statistics_AFKTimer = getTime() + 5000;
}

onRunFinished(cp)
{
	self pauseTimer();
}

onRunIDCreated()
{
	self.statistics_startTime = getTime();
	self.statistics_stopTime = getTime();

	self.statistics_saveCount = 0;
	self.statistics_loadCount = 0;
	self.statistics_nadeJumps = 0;
	self.statistics_nadeThrows = 0;
	self.statistics_jumpCount = 0;
	self.statistics_RPGJumps = 0;
	self.statistics_RPGShots = 0;
	self.statistics_doubleRPGs = 0;

	self.statistics_lastRPG = undefined;
	self.statistics_lastJump = undefined;
}

addTimeUntil(newtime)
{
	if(self OSJH\playerRuns::isRunFinished())
		return;

	if(!isDefined(newtime))
		return;

	if(!self OSJH\playerRuns::hasRunStarted())
		return;

	if(!isDefined(self.statistics_addTimeUntil) && newtime > getTime())
	{
		self.statistics_startTime -= newtime - getTime();
		self.statistics_addTimeUntil = newtime;
	}
	else if(isDefined(self.statistics_addTimeUntil) && newtime > self.statistics_addTimeUntil)
	{
		self.statistics_startTime -= newtime - self.statistics_addTimeUntil;
		self.statistics_addTimeUntil = newtime;
	}

	self thread _resetAddTimeUntil();
}

_resetAddTimeUntil()
{
	self endon("disconnect");
	self notify("resetAddTimeUntil");
	self endon("resetAddTimeUntil");
	waittillframeend;
	self.statistics_addTimeUntil = undefined;
}

onSavePosition()
{
	if(self OSJH\playerRuns::isRunFinished())
		return;

	self.statistics_saveCount++;
}

onLoadPosition()
{
	self.statistics_lastJump = undefined;

	if(self OSJH\playerRuns::isRunFinished())
		return;

	self.statistics_loadCount++;
}

onPlayerDamage(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, hitLoc, psOffsetTime)
{
	if(self OSJH\playerRuns::isRunFinished())
		return;

	if(self OSJH\weapons::isGrenade(weapon) && !self isOnGround())
	{
		self.statistics_nadeJumps++;
	}
}

onGrenadeThrow(nade, name)
{
	if(self OSJH\playerRuns::isRunFinished())
		return;

	self.statistics_nadeThrows++;
}

onJump()
{
	if(self OSJH\playerRuns::isRunFinished())
		return;

	self.statistics_jumpCount++;
	self.statistics_lastJump = getTime();
}

onRPGFired(rpg, name)
{
	if(self OSJH\playerRuns::isRunFinished())
		return;

	self.statistics_RPGShots++;

	if(!self isOnGround())
	{
		if(isDefined(self.statistics_lastJump) && isDefined(self.statistics_lastRPG) && self.statistics_lastRPG >= self.statistics_lastJump)
		{
			self.statistics_doubleRPGs++;
			self iprintln("Double rpg detected");
		}
		self.statistics_RPGJumps++;
		self.statistics_lastRPG = getTime();
	}
}

getTimePlayed()
{
	if(isDefined(self.statistics_stopTime))
		return (self.statistics_stopTime - self.statistics_startTime);
	else
		return (getTime() - self.statistics_startTime);
}

getJumpCount()
{
	return self.statistics_jumpCount;
}

getLoadCount()
{
	return self.statistics_loadCount;
}

getSaveCount()
{
	return self.statistics_saveCount;
}

setRPGJumps(amount)
{
	if(self OSJH\playerRuns::isRunFinished())
		return;

	self.statistics_RPGJumps = amount;
}

setNadeJumps(amount)
{
	if(self OSJH\playerRuns::isRunFinished())
		return;

	self.statistics_nadeJumps = amount;
}

setDoubleRPGs(amount)
{
	if(self OSJH\playerRuns::isRunFinished())
		return;

	self.statistics_doubleRPGs = amount;
}

getRPGJumps()
{
	return self.statistics_RPGJumps;
}

getRPGShots()
{
	return self.statistics_RPGShots;
}

getNadeJumps()
{
	return self.statistics_nadeJumps;
}

getNadeThrows()
{
	return self.statistics_nadeThrows;
}

getDoubleRPGs()
{
	return self.statistics_doubleRPGs;
}

_hideStatisticsHud(force)
{
	if(force || self.statistics_lastStatHudString != "")
	{
		self.statistics_lastStatHudString = "";
		self setClientCvar("osjh_statistics", "");
	}
}

_getTimeString(client)
{
	if(isDefined(client.statistics_stopTime))
		time =  client.statistics_stopTime - client.statistics_startTime;
	else
		time = getTime() - client.statistics_startTime;

	minutes = int(time / 60000);

	seconds = int(time / 1000) % 60;

	if(seconds < 10)
		timestring = minutes + ":0" + seconds;
	else
		timestring = minutes + ":" + seconds;

	return timestring;
}

_drawStatisticsHud(client)
{
	//printf("Getting setting timestring for client " + self.name + "\n");
	newstring = self setting_get("timestring") + self _getTimeString(client) + "\n";
	newstring += self setting_get("savesstring") + client getSaveCount() + "\n";
	newstring += self setting_get("loadsstring") + client getLoadCount() + "\n";
	newstring += self setting_get("nadejumpsstring") + client getNadeJumps() + "\n";
	newstring += self setting_get("nadethrowsstring") + client getNadeThrows() + "\n";
	newstring += self setting_get("jumpsstring") + client getJumpCount() + "\n";
	newstring += self setting_get("rpgjumpsstring") + client getRPGJumps() + "\n";
	newstring += self setting_get("rpgshotsstring") + client getRPGShots() + "\n";
	newstring += self setting_get("doublerpgsstring") + client getDoubleRPGs() + "\n";

	if(self.statistics_lastStatHudString != newstring)
	{
		self setClientCvar("osjh_statistics", newstring);
		self.statistics_lastStatHudString = newstring;
	}
}

onSpawnSpectator()
{
	self _hideStatisticsHud(false);
}

startTimer()
{
	if(self OSJH\playerRuns::isRunFinished())
		return;

	if(isDefined(self.statistics_stopTime))
	{
		self.statistics_startTime += getTime() - self.statistics_stopTime;
		self.statistics_stopTime = undefined;
	}
}

pauseTimer()
{
	if(!isDefined(self.statistics_stopTime))
	{
		self.statistics_stopTime = getTime();
	}
}