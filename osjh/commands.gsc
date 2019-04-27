onInit()
{
	level.commands_commands = [];
	_registerCommandInt("fov", 13, 160, 90, "Set your field-of-view\nUsage: !fov [value between 13 and 160]", ::_setFOV);
	_registerCommandBool("hidecollidingplayers", true, "Hide colliding players\nUsage: !hidecollidingplayers [on/off]", ::_void);
	_registerCommandBool("fullbright", false, "Enable/disable fullbright\nUsage: !fullbright [on/off]", ::_setFullBright);
	_registerCommand("help", "Shows how to use a function\nUsage: !help [function]", ::_showHelp);

	_registerCommandString("timestring", 0, 128, "Time: ", "Set the time string used in the statistics hud\nUsage: !timestring [newstring]", ::_void);
	_registerCommandString("savesstring", 0, 128, "Saves: ", "Set the saves string used in the statistics hud\nUsage: !savesstring [newstring]", ::_void);
	_registerCommandString("loadsstring", 0, 128, "Loads: ", "Set the loads string used in the statistics hud\nUsage: !loadsstring [newstring]", ::_void);
	_registerCommandString("nadejumpsstring", 0, 128, "Nadejumps: ", "Set the nadejumps string used in the statistics hud\nUsage: !nadejumpsstring [newstring]", ::_void);
	_registerCommandString("nadethrowsstring", 0, 128, "Nadethrows: ", "Set the nadethrows string used in the statistics hud\nUsage: !nadethrowsstring [newstring]", ::_void);
	_registerCommandString("jumpsstring", 0, 128, "Jumps: ", "Set the jumps string used in the statistics hud\nUsage: !jumpsstring [newstring]", ::_void);
	_registerCommandString("rpgjumpsstring", 0, 128, "RPG Jumps: ", "Set the RPGJumps string used in the statistics hud\nUsage: !rpgjumpsstring [newstring]", ::_void);
	_registerCommandString("rpgshotsstring", 0, 128, "RPG Shots: ", "Set the RPGShots string used in the statistics hud\nUsage: !rpgshotsstring [newstring]", ::_void);
	_registerCommandString("doublerpgsstring", 0, 128, "Double RPGs: ", "Set the double RPGs string used in the statistics hud\nUsage: !doublerpgsstring [newstring]", ::_void);
}

onPlayerLogin()
{
	//self _setFOV(self setting_get("fov"));
	//self _setFullBright(self setting_get("fullbright"));
}

_void(value)
{
}

_registerCommandString(name, minlength, maxlength, defaultVal, help, func)
{
	printf("registering command: " + name + "\n\n\n");
	cmd = spawnStruct();
	cmd.setting = true;
	cmd.help = help;
	cmd.func = func;
	level.commands_commands["!" + name] = cmd;
	printf("name: " + setting_createNew(name, "string", minlength, maxlength, defaultVal) + "\n");
}

_registerCommandInt(name, min, max, defaultVal, help, func)
{
	cmd = spawnStruct();
	cmd.setting = true;
	cmd.help = help;
	cmd.func = func;
	level.commands_commands["!" + name] = cmd;
	setting_createNew(name, "int", min, max, defaultVal);
}

_registerCommandBool(name, defaultVal, help, func)
{
	cmd = spawnStruct();
	cmd.setting = true;
	cmd.help = help;
	cmd.func = func;
	level.commands_commands["!" + name] = cmd;
	setting_createNew(name, "bool", defaultVal);
}

_registerCommand(name, help, func)
{
	cmd = spawnStruct();
	cmd.setting = false;
	cmd.help = help;
	cmd.func = func;
	level.commands_commands["!" + name] = cmd;
}

onPlayerCommand(args)
{
	for(i = 0; i < args.size; i++)
		printf("arg[" + i + "]: " + args[i] + "\n");
	if(args[0] == "say" || args[0] == "say_team")
	{
		if(isDefined(args[1]) && isDefined(level.commands_commands[args[1]]))
		{
			if(isDefined(args[2]))
			{
				if(level.commands_commands[args[1]].setting)
				{
					settingName = getSubStr(args[1], 1);
					settingValue = args[2];
					printf("Param 1: " + settingName + " param 2: " + settingValue + "\n");
					result = self setting_set(settingName, settingValue);
					if(!isDefined(result))
						self iprintln(level.commands_commands[args[1]].help);
					else
						self [[level.commands_commands[args[1]].func]](result);
				}
				else
					self [[level.commands_commands[args[1]].func]](args[2]);
			}
			else
				self iprintln(level.commands_commands[args[1]].help);
			return true;
		}
	}
	return false;
}

_showHelp(value)
{
	if(isDefined(level.commands_commands[value]))
		self iprintln(level.commands_commands[value].help);
	else if(isDefined(level.commands_commands["!" + value]))
		self iprintln(level.commands_commands["!" + value].help);
}

_setFullBright(value)
{
	self setClientCvar("r_fullbright", value);
}

_setFOV(value)
{
	if(value > 80)
	{
		self setClientCvar("cg_fovscale", (value / 80));
		self setclientcvar("cg_fov", 80);
	}
	else if(value < 65)
	{
		self setClientCvar("cg_fovscale", (value / 65));
		self setclientcvar("cg_fov", 65);
	}
	else
	{
		self setclientcvar("cg_fovscale", 1);
		self setclientcvar("cg_fov", value);
	}
}