onInit()
{
	host = "127.0.0.1";
	user = "osjh";
	pass = "ospassword";
	db = "osdb";
	port = 3306;
	mysql_real_connect(host, user, pass, db, port);

	mysqla_initializer(host, user, pass, db, port, 10, maps\mp\gametypes\_callbacksetup::CodeCallback_MysqlQueryDone);
}

mysqlSyncQuery(query)
{
	rows = mysql_query(query, true);
	return rows;
}

mysqlAsyncQuery(query)
{
	if(isPlayer(self))
		self endon("disconnect");
	id = self mysqla_create_query(query, true);
	self waittill("mysqlQueryDone" + id, rows);
	if(!isDefined(rows))
		return [];
	return rows;
}

mysqlAsyncQueryNosave(query)
{
	if(isPlayer(self))
		self endon("disconnect");
	id = self mysqla_create_query(query, false);
	self waittill("mysqlQueryDone" + id);
}

onMysqlQueryDone(id, rows)
{
	self notify("mysqlQueryDone" + id, rows);
}

escapeString(str)
{
	return mysql_real_escape_string(str);
}