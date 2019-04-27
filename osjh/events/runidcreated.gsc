main(spawn)
{
	self OSJH\saveposition::onRunIDCreated();
	self OSJH\weapons::onRunIDCreated();
	self OSJH\playerRuns::onRunIDCreated();
	self OSJH\statistics::onRunIDCreated();
	self OSJH\healthRegen::onRunIDCreated();
	self OSJH\shellShock::onRunIDCreated();
	self OSJH\checkpoints::onRunIDCreated();
	self OSJH\showRecords::onRunIDCreated();
	self OSJH\checkpointPointers::onRunIDCreated();

	if(spawn)
		self OSJH\events\spawnPlayer::main();
}