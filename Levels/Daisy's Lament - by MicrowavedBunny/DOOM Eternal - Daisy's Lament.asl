// Doom Eternal Daisy's Lament Autosplitter
// By MicrowavedBunny for 6.66 r2.2 steam only
// HUGE THANKS to Micrologist

state("DOOMEternalx64vk", "6.66 Rev 2.2 (Steam)")
{
	byte isLoading2: 0x6930410;
	bool isFirstEncounterActive : 0x6B07D60, 0x2C8, 0x8, 0x28, 0x0, 0x8, 0x640;
    float playerHealth : 0x6C01A08, 0x0, 0x48, 0x898;
    string10 encounterName : 0x6B07D60, 0x2C8, 0x8, 0x28, 0x0, 0x8, 0x48, 0x0;
}

startup
{
	vars.gameVersion = 0;
}

init
{
	int moduleSize = modules.First().ModuleMemorySize;
	print("Main Module Size: " + moduleSize.ToString());
	switch(moduleSize)
	{
		case 121769984:
			version = "6.66 Rev 2.2 (Steam)";
			vars.gameVersion = 70;
			break;
		default:
			version = "Unsupported: " + moduleSize.ToString();
			// Display popup if version is incorrect
    		MessageBox.Show("This game version is currently not supported.", "LiveSplit Auto Splitter - Unsupported Game Version");
			break;
    }
}

update
{
	// Disable the autosplitter if the version is incorrect
	if (version.Contains("Unsupported"))
		return false;
}

exit
{
	timer.IsGameTimePaused = true;
}

split
{
    if(current.isFirstEncounterActive == false && old.isFirstEncounterActive == true && current.encounterName != null)
    {
    return true;
    }
}

start
{
    return current.isFirstEncounterActive && !old.isFirstEncounterActive;
}

reset
{
	if(current.isLoading2 == 01 || current.playerHealth <= 0)
	{
		return true;
	}
}