main(newClient)
{
	self OSJH\statistics::onSpectatorClientChanged(newClient);
	self OSJH\showRecords::onSpectatorClientChanged(newClient);
}