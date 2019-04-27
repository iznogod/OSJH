onInit()
{
	level.playerModels_models = [];
	level.playerModels_deadBodies = [];

	if(getCvarInt("codversion") == 2)
	{
		_registerModel("default", "xmodel/playerbody_american_normandy01", "xmodel/viewmodel_hands_cloth");
		_registerAttach("default", "xmodel/head_us_ranger_braeburn", "");
	}
	else
	{
		_registerModel("default", "body_mp_usmc_specops", "viewmodel_base_viewhands");
		_registerAttach("default", "head_mp_usmc_tactical_mich_stripes_nomex", "");
	}
}

_registerModel(name, model, viewModel)
{
	modelStruct = spawnStruct();
	modelStruct.model = model;
	modelStruct.viewModel = viewModel;

	precacheModel(model);
	precacheModel(viewModel);

	modelStruct.attach = [];

	level.playerModels_models[name] = modelStruct;
}

_registerAttach(name, model, point)
{
	if(!isDefined(level.playerModels_models[name]))
		return;

	attachStruct = spawnStruct();
	attachStruct.model = model;
	attachStruct.point = point;

	precacheModel(model);

	level.playerModels_models[name].attach[level.playerModels_models[name].attach.size] = attachStruct;
}

onSpawnPlayer()
{
	self detachAll();

	self notify("deleteBody");

	self _setModel("default");
}

onLoadPosition()
{
}

_setModel(name)
{
	if(!isDefined(level.playerModels_models[name]))
		return;

	self setModel(level.playerModels_models[name].model);

	for(i = 0; i < level.playerModels_models[name].attach.size; i++)
		self attach(level.playerModels_models[name].attach[i].model, level.playerModels_models[name].attach[i].point);
}

onPlayerKilled(inflictor, attacker, damage, meansOfDeath, weapon, vDir, hitLoc, psOffsetTime, deathAnimDuration)
{
	body = self clonePlayer(deathAnimDuration);

	body thread _deleteOnEvent(self, "deleteBody");

	body thread _deleteAfterTime(10);

	level.playerModels_deadBodies[level.playerModels_deadBodies.size] = body;
}

_deleteOnEvent(player, event)
{
	self endon("deleted");

	player waittill(event);

	if(isDefined(self))
	{
		self _cleanupBody();
		self delete();
	}
}

_deleteAfterTime(time)
{
	wait time;

	if(isDefined(self))
	{
		self _cleanupBody();
		self notify("deleted");
		self delete();
	}
}

_cleanupBody()
{
	for(i = 0; i < level.playerModels_deadBodies.size; i++)
	{
		if(level.playerModels_deadBodies[i] == self)
		{
			level.playerModels_deadBodies[i] = level.playerModels_deadBodies[level.playerModels_deadBodies.size - 1];
			level.playerModels_deadBodies[level.playerModels_deadBodies.size - 1] = undefined;
			break;
		}
	}
}