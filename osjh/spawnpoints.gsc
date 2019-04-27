onInit()
{
	level.spawnpoints_player = _initSpawnpoints("mp_dm_spawn");
	level.spawnpoints_spectator = _initSpawnpoints("mp_global_intermission");

	for(i = 0; i < level.spawnpoints_player.size; i++)
		level.spawnpoints_player[i] placeSpawnpoint();
}

_initSpawnpoints(className)
{
	spawnpoints = getEntArray(className, "classname");
	if(!isDefined(spawnpoints) || !spawnpoints.size)
	{
		printf("Using a fake spawnpoint for " + className + "\n");
		spawnpoint = spawn("script_origin", (0, 0, 0));
		spawnpoints[0] = spawnpoint;
	}
	return spawnpoints;
}

getSpectatorSpawnpoint()
{
	return level.spawnpoints_spectator[randomint(level.spawnpoints_spectator.size)];
}

getPlayerSpawnpoint()
{
	return level.spawnpoints_player[randomint(level.spawnpoints_player.size)];
}