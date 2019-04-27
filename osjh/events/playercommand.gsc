main(args)
{
	if(isDefined(args[0]))
	{
		if(self OSJH\savePosition::onPlayerCommand(args))
			return;

		if(self OSJH\login::onPlayerCommand(args))
			return;

		if(self OSJH\commands::onPlayerCommand(args))
			return;

		if(args[0] == "spawn")
			self thread _doNextFrame(OSJH\events\spawnPlayer::main);
		else if(args[0] == "spectate")
			self thread _doNextFrame(OSJH\events\spawnSpectator::main);
		else if(args[0] == "kill")
			self _killNextFrame();
		else if(args[0] == "elevate")
		{
			if(isDefined(args[1]) && (args[1] == "on" || args[1] == "off"))
				self allowelevate(args[1] == "on");
		}
		else if(args[0] == "resetrun")
		{
			self OSJH\playerRuns::resetRunId();
		}
		else
			self clientCommand();
	}
}

_doNextFrame(func)
{
	waittillframeend;

	if(isDefined(self))
		self [[func]]();
}

_killNextFrame()
{
	waittillframeend;
	if(isDefined(self))
		self suicide();
}