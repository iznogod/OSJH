main()
{
	self OSJH\settings::onPlayerConnect();
	self OSJH\grenadeTimers::onPlayerConnect();
	self OSJH\statistics::onPlayerConnect();
	self OSJH\playerRuns::onPlayerConnect();
	self OSJH\checkpointPointers::onPlayerConnect();
	self OSJH\showRecords::onPlayerConnect();
	self OSJH\country::onPlayerConnect();

	self thread _dummy();
	self waittill("begin");

	level notify("connected", self);

	self OSJH\events\playerConnected::main();
}

_dummy()
{
	waittillframeend;
	if(isDefined(self))
		level notify("connecting", self);
}