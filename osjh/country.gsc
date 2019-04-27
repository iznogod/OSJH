onPlayerConnect()
{
	self.country_country = undefined;
	self.country_connectMessageShown = false;
	self thread _countryQuery();
}

_countryQuery()
{
	self endon("disconnect");
	rows = self OSJH\mySQL::mysqlAsyncQuery("SELECT getCountry(INET_ATON('" + OSJH\mySQL::escapeString(self getIP()) + "'))");
	if(rows.size && isDefined(rows[0][0]))
		self.country_country = rows[0][0];
	else
		self.country_country = "??";
	if(self OSJH\login::isLoggedIn())
		self _doConnectMessage();
}

onPlayerLogin()
{
	self _doConnectMessage();
}

_doConnectMessage()
{
	if(self.country_connectMessageShown)
		return;

	iprintln(self.name + "^7 connected from " + getLongCountryName(self getCountry()));
}

getCountry()
{
	if(!isDefined(self.country_country))
		return "??";
	else
		return self.country_country;
}

getLongCountryName(shortCountryName)
{
	switch(shortCountryName)
	{
		case "NL":
			return "The Netherlands";
		default:
			return shortCountryName;
	}
}

getIP()
{
	return "188.165.211.75";
}