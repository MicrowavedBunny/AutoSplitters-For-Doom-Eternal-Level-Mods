// Doom Eternal Tormented Earth Autosplitter
// By MicrowavedBunny for 6.66 r2.2 steam only
// HUGE THANKS to Micrologist

state("DOOMEternalx64vk", "6.66 Rev 2.2 (Steam)")
{
    string60 currentCheckpoint : 0x6B07D00, 0x1108;
    int currentCheckpointptr : 0x6B07D00;
    bool isInGame : 0x68E4870;
    string31 levelName : 0x6B07DB0;
    bool is1EncounterActive : 0x6B07D60, 0x2C8, 0x8, 0x28, 0x0, 0x30, 0x640;
    bool is22EncounterActive : 0x6B07D60, 0x2C8, 0x8, 0x28, 0x0, 0xD8, 0x640;
}

startup
{
	vars.gameVersion = 0;
    vars.diedToHellKnights = false;
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
    if(current.currentCheckpoint == "checkpoint_1" && old.currentCheckpoint == "")
        return true;
    if(current.currentCheckpoint == "checkpoint_2" && old.currentCheckpoint == "checkpoint_1")
        return true;
    if(current.currentCheckpoint == "checkpoint_2_2" && old.currentCheckpoint == "checkpoint_2")
        return true;
    if(current.currentCheckpoint == "checkpoint_3" && old.currentCheckpoint == "checkpoint_2_2")
        return true;
    if(current.currentCheckpoint == "cp_02_post_modbot" && old.currentCheckpoint == "checkpoint_3")
        return true;
    if(current.currentCheckpoint == "checkpoint_05" && old.currentCheckpoint == "cp_02_post_modbot")
        return true;
    if(current.currentCheckpoint == "checkpoint_06" && old.currentCheckpoint == "checkpoint_05")
        return true;
    if(current.currentCheckpoint == "checkpoint_07" && old.currentCheckpoint == "checkpoint_06")
        return true;
    if(current.currentCheckpoint == "checkpoint_08" && old.currentCheckpoint == "checkpoint_07")
        return true;
    if(current.currentCheckpoint == "checkpoint_09" && old.currentCheckpoint == "checkpoint_08")
        return true;
    if(current.currentCheckpoint == "checkpoint_10" && old.currentCheckpoint == "checkpoint_09")
        return true;
    if(current.currentCheckpoint == "checkpoint_11" && old.currentCheckpoint == "checkpoint_10")
        return true;
    if(current.currentCheckpoint == "checkpoint_12" && old.currentCheckpoint == "checkpoint_11")
        return true;
    if(current.currentCheckpoint == "checkpoint_13" && old.currentCheckpoint == "checkpoint_12") //
        return true;
    if(current.currentCheckpoint == "checkpoint_14" && old.currentCheckpoint == "checkpoint_13")
        return true;
    if(current.currentCheckpoint == "checkpoint_15" && old.currentCheckpoint == "checkpoint_14")
        return true;
    if(current.currentCheckpoint == "checkpoint_16" && old.currentCheckpoint == "checkpoint_15")
        return true;
    if(current.currentCheckpoint == "checkpoint_16_5" && old.currentCheckpoint == "checkpoint_16")
        return true;
    if(current.currentCheckpoint == "checkpoint_17" && old.currentCheckpoint == "checkpoint_16_5")
        return true;
    if(current.is22EncounterActive == false && current.currentCheckpoint == "checkpoint_18" && old.currentCheckpointptr == 0 && !vars.diedToHellKnights){//if u dont kill dread knights and die
        vars.diedToHellKnights = true;
        return true;
    }
    if(current.currentCheckpoint == "checkpoint_19" && old.currentCheckpoint == "checkpoint_18")// should only split once and only if you beat the dread knights
        return true;    
    if(current.currentCheckpoint == "checkpoint_20" && old.currentCheckpoint == "checkpoint_18") //if you beat the mall encounter without killing dreadknights
        return true;
    if(current.currentCheckpoint == "checkpoint_20" && old.currentCheckpoint == "checkpoint_19") //if you beat the mall encounter after killing dreadknights
        return true;
    if(current.currentCheckpoint == "checkpoint_21" && old.currentCheckpoint == "checkpoint_20")
        return true;
    if(current.currentCheckpoint == "checkpoint_22" && old.currentCheckpoint == "checkpoint_21")
        return true;
    if(current.currentCheckpoint == "checkpoint_23" && old.currentCheckpoint == "checkpoint_22")
        return true;
    if(current.currentCheckpoint == "checkpoint_24" && old.currentCheckpoint == "checkpoint_23")
        return true;
    
}

start
{
    if(current.is1EncounterActive && !old.is1EncounterActive){
    vars.diedToHellKnights = false;
    return true;
    }
}

reset
{

    if(current.currentCheckpoint == "" && old.currentCheckpointptr == 0){
        vars.diedToHellKnights = false;
        return true;
    }

	if(current.levelName.Contains("e1m1_intro") && !old.levelName.Contains("e1m1_intro")){
        vars.diedToHellKnights = false;
        return true;
    }
       

    if(current.isInGame == false){
        vars.diedToHellKnights = false;
        return true;
    }
    
}











































