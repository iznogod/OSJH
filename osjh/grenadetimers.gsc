onPlayerConnect()
{
	self.grenadeTimers_timers = [];
}

onGrenadeThrow(nade, name)
{
	self thread _showNadeTimer();
}

onPlayerKilled(inflictor, attacker, damage, meansOfDeath, weapon, vDir, hitLoc, psOffsetTime, deathAnimDuration)
{
	self _removeNadeTimers();
}

onSpawnPlayer()
{
	self _removeNadeTimers();
}

_showNadeTimer()
{
	self endon("disconnect");
	self endon("stopNadeTimer");

	nadeTimer = newClientHudElem(self);
	nadeTimer.horzAlign = "left";
	nadeTimer.vertAlign = "top";
	nadeTimer.alignX = "left";
	nadeTimer.alignY = "top";
	nadeTimer.x = 20;
	nadeTimer.y = 40 + 10 * self.grenadeTimers_timers.size;
	nadeTimer.fontScale = 1;
	nadeTimer.alpha = 1;
	nadeTimer.archived = true;
	nadeTimer setTenthsTimer(3.45);

	self.grenadeTimers_timers[self.grenadeTimers_timers.size] = nadeTimer;

	for(t = 0; t < 70; t++)
	{
		if(t < 35)
			nadeTimer.color = (t / 35, 1, 0);
		else
			nadeTimer.color = (1, 1 - ((t - 35) / 35), 0);
		wait 0.05;
	}

	ownNum = self.grenadeTimers_timers.size - 1;
	for(i = 0; i < self.grenadeTimers_timers.size; i++)
	{
		if(self.grenadeTimers_timers[i] != nadeTimer)
		{
			if(self.grenadeTimers_timers[i].y > nadeTimer.y)
				self.grenadeTimers_timers[i].y -= 10;
		}
		else
			ownNum = i;
	}
	self.grenadeTimers_timers[ownNum] = self.grenadeTimers_timers[self.grenadeTimers_timers.size - 1];
	self.grenadeTimers_timers[self.grenadeTimers_timers.size - 1] = undefined;
	nadeTimer destroy();
}

onLoadPosition()
{
	self _removeNadeTimers();
}

_removeNadeTimers()
{
	self notify("stopNadeTimer");
	for(i = 0; i < self.grenadeTimers_timers.size; i++)
		self.grenadeTimers_timers[i] destroy();
	for(i = i - 1; i >= 0; i--)
		self.grenadeTimers_timers[i] = undefined;
}