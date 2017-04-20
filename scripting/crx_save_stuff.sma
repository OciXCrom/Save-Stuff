#include <amxmodx>
#include <cstrike>
#include <fun>

#define PLUGIN_VERSION "1.0"

new g_szIP[33][32]
new Trie:g_tStuff

public plugin_init()
{
	register_plugin("Save Stuff", PLUGIN_VERSION, "OciXCrom")
	register_cvar("@CRXSaveStuff", PLUGIN_VERSION, FCVAR_SERVER|FCVAR_SPONLY|FCVAR_UNLOGGED)
	g_tStuff = TrieCreate()
}

public plugin_end()
	TrieDestroy(g_tStuff)
	
public client_putinserver(id)
{
	get_user_ip(id, g_szIP[id], charsmax(g_szIP[]), 0)
	
	if(TrieKeyExists(g_tStuff, g_szIP[id]))
	{
		new szStuff[32], szFrags[4], szDeaths[4], szMoney[10]
		TrieGetString(g_tStuff, g_szIP[id], szStuff, charsmax(szStuff))
		parse(szStuff, szFrags, charsmax(szFrags), szDeaths, charsmax(szDeaths), szMoney, charsmax(szMoney))
		set_user_frags(id, str_to_num(szFrags))
		cs_set_user_deaths(id, str_to_num(szDeaths))
		cs_set_user_money(id, str_to_num(szMoney))
	}
}

public client_disconnect(id)
{
	new szStuff[32]
	formatex(szStuff, charsmax(szStuff), "%i %i %i", get_user_frags(id), cs_get_user_deaths(id), cs_get_user_money(id))
	TrieSetString(g_tStuff, g_szIP[id], szStuff)
}