main()
{
	OSJH\mySQL::onInit();
	OSJH\settings::onInit();

	OSJH\mapID::onInit();
	OSJH\checkpoints::onInit();
	OSJH\checkpointPointers::onInit();

	OSJH\commands::onInit();
	OSJH\util::onInit();
	OSJH\shellShock::onInit();
	OSJH\spawnpoints::onInit();
	OSJH\playerModels::onInit();
	OSJH\weapons::onInit();
	OSJH\cvars::onInit();
	OSJH\menus::onInit();
	OSJH\mapCleanup::onInit();

	thread _everyFrame();
}

_everyFrame()
{
	while(true)
	{
		OSJH\events\onFrame::main();
		wait 0.05;
	}
}