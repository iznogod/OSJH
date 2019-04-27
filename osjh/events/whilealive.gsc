main()
{
	self endon("disconnect");
	self endon("spawned");

	while(self.sessionState == "playing")
	{
		self OSJH\statistics::whileAlive();
		self OSJH\checkpoints::whileAlive();
		self OSJH\showRecords::whileAlive();
		wait 0.05;
	}
}