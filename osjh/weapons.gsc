onInit()
{
	level.weapons_loadouts = [];
	level.weapons_grenades = [];
	level.weapons_rpgs = [];

	if(getCvarInt("codversion") == 2)
	{
		_registerLoadout("default", "tt30_mp");
		_registerGrenade("default", "frag_grenade_american_mp");
	}
	else
	{
		_registerLoadout("default", "deserteagle_mp");
		_registerRPG("default", "rpg_mp");
	}
}

onSpawnPlayer()
{
	self _giveWeapons(false);
	self _deleteGrenades();
}

onLoadPosition(giveRPG)
{
	self _giveWeapons(giveRPG);
	self _deleteGrenades();
}

onRunIDCreated()
{
	self _deleteGrenades();
}

_deleteGrenades()
{
	nade = self.weapons_prevNade;
	while(isDefined(nade))
	{
		tmp = nade.prevNade;
		if(!nade isThinking())
			nade delete();
		nade = tmp;
	}
	self.weapons_prevNade = undefined;
}

_giveWeapons(rpgDefault)
{
	self takeAllWeapons();
	self _giveLoadout("default", !rpgDefault);
	self _giveGrenades("default", false);
	self _giveRPG("default", rpgDefault);
}

_registerLoadout(name, weapon)
{
	level.weapons_loadouts[name] = weapon;
	precacheItem(weapon);
}

_registerGrenade(name, weapon)
{
	level.weapons_grenades[name] = weapon;
	precacheItem(weapon);
}

_registerRPG(name, weapon)
{
	level.weapons_rpgs[name] = weapon;
	precacheItem(weapon);
}

_giveLoadout(name, spawnWeapon)
{
	if(!isDefined(level.weapons_loadouts[name]))
		return;

	self giveWeapon(level.weapons_loadouts[name]);
	self giveMaxAmmo(level.weapons_loadouts[name]);
	if(spawnWeapon)
		self setSpawnWeapon(level.weapons_loadouts[name]);
}

_giveGrenades(name, spawnWeapon)
{
	if(!isDefined(level.weapons_grenades[name]))
		return;

	self giveWeapon(level.weapons_grenades[name]);
	self giveMaxAmmo(level.weapons_grenades[name]);
}

_giveRPG(name, spawnWeapon)
{
	if(!isDefined(level.weapons_rpgs[name]))
		return;

	self giveWeapon(level.weapons_rpgs[name]);
	self giveMaxAmmo(level.weapons_rpgs[name]);
	self setactionslot(4, "weapon", level.weapons_rpgs[name]);
	if(spawnWeapon)
		self setSpawnWeapon(level.weapons_rpgs[name]);
}

onRPGFired(rpg, name)
{
	self giveMaxAmmo(name);
}

onGrenadeThrow(nade, name)
{
	nade.prevNade = self.weapons_prevNade;
	self.weapons_prevNade = nade;
	self giveMaxAmmo(name);
}

isRPG(weapon)
{
	if(!isDefined(weapon))
		return false;

	if(level.weapons_rpgs.size)
	{
		keys = getArrayKeys(level.weapons_rpgs);
		for(i = 0; i < keys.size; i++)
		{
			if(level.weapons_rpgs[keys[i]] == weapon)
				return true;
		}
	}
	return false;
}

isGrenade(weapon)
{
	if(!isDefined(weapon))
		return false;

	if(level.weapons_grenades.size)
	{
		keys = getArrayKeys(level.weapons_grenades);
		for(i = 0; i < keys.size; i++)
		{
			if(level.weapons_grenades[keys[i]] == weapon)
				return true;
		}
	}
	return false;
}