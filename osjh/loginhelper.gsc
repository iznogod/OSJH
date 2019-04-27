requestUID()
{
	self endon("disconnect");
	self OSJH\util::execClientCmd("writeconfig temp.cfg; exec accounts/OSJH.cfg; vstr osjh_login; unbind all; exec temp; login failed");

	self waittill("UIDReceived", uidstring);

	if(!isDefined(uidstring))
		return undefined;

	uidparts = strTok(uidstring, "-");

	if(uidparts.size == 4)
	{
		uid = [];
		for(i = 0; i < 4; i++)
		{
			uid[i] = hexStringToInt(uidparts[i]);
			if(!isDefined(uid[i]))
			{
				return undefined;
			}
		}
		return uid;
	}
	return undefined;
}

storeUID(uid)
{
	self thread _storeUIDContinuous(uid);
}

_storeUIDContinuous(uid)
{
	self endon("UIDStored");
	self endon("disconnect");

	uidstring = intToHexString(uid[0]) + "-" + intToHexString(uid[1]) + "-" + intToHexString(uid[2]) + "-" + intToHexString(uid[3]);

	while(true)
	{
		self OSJH\util::execClientCmd("seta osjh_login login uid " + uidstring + "; writeconfig accounts/OSJH.cfg; login stored");
		wait 0.5;
	}
}

onPlayerCommand(args)
{
	if(isDefined(args[0]) && args[0] == "login")
	{
		if(isDefined(args[1]))
		{
			if(args[1] == "uid")
			{
				self notify("UIDReceived", args[2]);
				return true;
			}
			else if(args[1] == "stored")
			{
				self notify("UIDStored");
				self OSJH\menus::openIngameMenu();
				return true;
			}
			else if(args[1] == "failed")
			{
				self notify("UIDReceived");
				return true;
			}
		}
	}
	return false;
}