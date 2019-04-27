onInit()
{
	rows = mysql_query("SELECT getMapID('" + OSJH\mySQL::escapeString(getCvar("mapname")) + "')", true);
	if(rows.size && isDefined(rows[0][0]))
		level.mapid_mapID = rows[0][0];
}

hasMapID()
{
	return isDefined(level.mapid_mapID);
}

getMapID()
{
	return level.mapid_mapID;
}