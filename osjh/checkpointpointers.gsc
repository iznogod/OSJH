onInit()
{
	level.checkpointPointers_pointerMaterial = "waypoint_down";
	precacheShader(level.checkpointPointers_pointerMaterial);
}

onPlayerConnect()
{
	self.checkpointPointers_huds = [];
}

onSpawnPlayer()
{
	self _showCheckpointPointers();
}

onRunIDCreated()
{
	self _hideCheckpointPointers();
}

onSpawnSpectator()
{
	self _hideCheckpointPointers();
}

onPlayerKilled(inflictor, attacker, damage, meansOfDeath, weapon, vDir, hitLoc, psOffsetTime, deathAnimDuration)
{
	self _hideCheckpointPointers();
}

onCheckpointsChanged(cp)
{
	self _showCheckpointPointers();
}

onRunFinished(cp)
{
	self _hideCheckpointPointers();
}

_showCheckpointPointers()
{
	if(self.sessionState != "playing")
		return;

	checkpoints = self OSJH\checkpoints::getCheckpoints();

	for(i = 0; i < checkpoints.size; i++)
	{
		if(i >= self.checkpointPointers_huds.size)
			self.checkpointPointers_huds[self.checkpointPointers_huds.size] = self _createNewCheckpointPointerHud();

		self.checkpointPointers_huds[i].x = checkpoints[i].origin[0];
		self.checkpointPointers_huds[i].y = checkpoints[i].origin[1];
		self.checkpointPointers_huds[i].z = checkpoints[i].origin[2] + 10;
		self.checkpointPointers_huds[i] thread _doGlow(self, checkpoints[i].colors);

	}
	for(i = self.checkpointPointers_huds.size - 1; i >= checkpoints.size; i--)
	{
		self.checkpointPointers_huds[i] notify("stopGlow");
		self.checkpointPointers_huds[i] destroy();
		self.checkpointPointers_huds[i] = undefined;
	}
}

_doGlow(player, colors)
{
	player endon("disconnect");
	self notify("stopGlow");
	self endon("stopGlow");
	if(colors.size == 1)
	{
		self.color = colors[0];
		return;
	}
	frames = 10;
	while(true)
	{
		for(i = 0; i < colors.size; i++)
		{
			curColor = colors[i];
			nextColor = colors[(i + 1) % colors.size];
			diff = nextColor - curColor;
			for(j = 0; j < frames; j++)
			{
				self.color = curColor + vectorScale(diff, (1 / frames) * j);
				wait 0.05;
			}
			wait 1;
		}
	}
}

_doJump(player)
{
	player endon("disconnect");
	self endon("stopGlow");
	offset[0] = (0, 0, 0) + (self.x, self.y, self.z);
	offset[1] = (0, 0, 20) + (self.x, self.y, self.z);
	frames = 20;
	while(true)
	{
		for(i = 0; i < offset.size; i++)
		{
			curOffset = offset[i];
			nextOffset = offset[(i + 1) % offset.size];
			diff = nextOffset - curOffset;
			for(j = 0; j < frames; j++)
			{
				self.x = curOffset[0] + diff[0] * (1 / frames) * j;
				self.y = curOffset[1] + diff[1] * (1 / frames) * j;
				self.z = curOffset[2] + diff[2] * (1 / frames) * j;
				wait 0.05;
			}
		}
	}
}


_hideCheckpointPointers()
{
	for(i = self.checkpointPointers_huds.size - 1; i >= 0; i--)
	{
		self.checkpointPointers_huds[i] notify("stopGlow");
		self.checkpointPointers_huds[i] destroy();
		self.checkpointPointers_huds[i] = undefined;
	}
}

_createNewCheckpointPointerHud()
{
	hud = newClientHudElem(self);
	hud.alpha = 1;
	hud.foreground = true;
	hud.aligny = "top";
	hud.alignx = "center";
	hud setShader(level.checkpointPointers_pointerMaterial, 8, 8);
	hud.color = (1, 0, 0);
	hud setwaypoint(true);
	return hud;
}