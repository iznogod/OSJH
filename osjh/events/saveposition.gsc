main()
{
	if(!self OSJH\login::isLoggedIn() || !self OSJH\playerRuns::hasRunID())
		return;

	error = self OSJH\savePosition::canSaveError();
	if(!error)
	{
		self OSJH\savePosition::setSavedPosition();
		self OSJH\savePosition::printSaveSuccess();
		self OSJH\statistics::onSavePosition();
	}
	else
		self OSJH\savePosition::printCanSaveError(error);
}