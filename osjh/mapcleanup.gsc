onInit()
{
	if(getCvarInt("codversion") == 4)
	{
		_removePickups();
		setCvar("clientSideEffects", 0);
	}
}

_removePickups()
{
	pickups = getentarray("oldschool_pickup", "targetname");

	for(i = 0; i < pickups.size; i++)
	{
		if(isdefined(pickups[i].target))
			getent(pickups[i].target, "targetname") delete();

		pickups[i] delete();
	}
}