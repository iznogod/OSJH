CodeCallback_StartGameType()
{
	OSJH\events\init::main();
}

CodeCallback_PlayerConnect()
{
	self OSJH\events\playerConnect::main();
}

CodeCallback_PlayerDisconnect()
{
	self OSJH\events\playerDisconnect::main();
}

CodeCallback_PlayerDamage(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, hitLoc, psOffsetTime)
{
	self OSJH\events\playerDamage::main(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, hitLoc, psOffsetTime);
}

CodeCallback_PlayerKilled(inflictor, attacker, damage, meansOfDeath, weapon, vDir, hitLoc, psOffsetTime, deathAnimDuration)
{
	self OSJH\events\playerKilled::main(inflictor, attacker, damage, meansOfDeath, weapon, vDir, hitLoc, psOffsetTime, deathAnimDuration);
}

CodeCallback_PlayerCommand(args)
{
	self OSJH\events\playerCommand::main(args);
}

CodeCallback_PlayerLastStand()
{
}

CodeCallback_RPGFired(rpg, name)
{
	self OSJH\events\rpgFired::main(rpg, name);
}

CodeCallback_FireGrenade(nade, name)
{
	self OSJH\events\grenadeThrow::main(nade, name);
}

AbortLevel()
{
}

CodeCallback_MysqlQueryDone(id, rows)
{
	if(!isDefined(rows))
		rows = [];
	self OSJH\mySQL::onMysqlQueryDone(id, rows);
}

CodeCallback_MeleeButton()
{
	self OSJH\buttonPress::onMeleeButton();
}

CodeCallback_UseButton()
{
	self OSJH\buttonPress::onUseButton();
}

CodeCallback_AttackButton()
{
	self OSJH\buttonPress::onAttackButton();
}

CodeCallback_UserInfoChanged()
{
}

CodeCallback_StartJump()
{
	self OSJH\buttonPress::onJump();
}

CodeCallback_SpectatorClientChanged(newClient)
{
	self OSJH\events\spectatorClientChanged::main(newClient);
}

CodeCallback_WentFreeSpec()
{
	self OSJH\events\spectatorClientChanged::main(undefined);
}

CodeCallback_MoveForward()
{
	self OSJH\events\WASDPressed::main();
}

CodeCallback_MoveRight()
{
	self OSJH\events\WASDPressed::main();
}

CodeCallback_MoveBackward()
{
	self OSJH\events\WASDPressed::main();
}

CodeCallback_MoveLeft()
{
	self OSJH\events\WASDPressed::main();
}
