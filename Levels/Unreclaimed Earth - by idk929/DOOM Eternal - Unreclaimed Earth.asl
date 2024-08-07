// Doom Eternal Unreclaimed Earth Autosplitter
// By MicrowavedBunny for 6.66 r2.2 steam only
// HUGE THANKS to Micrologist

state("DOOMEternalx64vk", "6.66 Rev 2.2 (Steam)")
{
    string60 currentCheckpoint : 0x6B07D00, 0x1108;
    int currentCheckpointptr : 0x6B07D00;
    bool isLoading : 0x51C8398;
	byte isLoading2: 0x6930410;
    bool isInGame : 0x68E4870;
    string31 levelName : 0x6B07DB0;
    string10 encounterName : 0x6B07D60, 0x2C8, 0x8, 0x28, 0x0, 0x8, 0x48, 0x0;
    bool is1EncounterActive : 0x6B07D60, 0x2C8, 0x8, 0x28, 0x0, 0x60, 0x640;
    bool isLastEncounterActive : 0x6B07D60, 0x2C8, 0x8, 0x28, 0x0, 0x90, 0x640;
    bool is3_5EncounterActive : 0x6B07D60, 0x2C8, 0x8, 0x28, 0x0, 0xE8, 0x640;
    byte canMove: 0x6B52321;
}

startup
{
	vars.gameVersion = 0;
    vars.is3_5EncounterComplete = false;
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
    if(current.currentCheckpoint == "cp_03_firstbuilding_post" && old.currentCheckpoint == "")
        return true;
    if(current.currentCheckpoint == "cp_02_firstbuilding_pre" && old.currentCheckpoint == "cp_03_firstbuilding_post")
        return true;
    if(current.currentCheckpoint == "cp_04_trainstation_pre" && old.currentCheckpoint == "cp_02_firstbuilding_pre")
        return true;
    if(current.currentCheckpoint == "checkpoint_9" && old.currentCheckpoint == "checkpoint_4")
        return true;
    if(current.currentCheckpoint == "cp_07b_Escalation 1" && old.currentCheckpoint == "cp_07_rooftop_pre")
        return true;
    if(current.currentCheckpoint == "cp_09_floodedsubway_pre" && old.currentCheckpoint == "cp_07b_Escalation 1")
        return true;    
    if(current.currentCheckpoint == "cp_10_floodedsubway_mid" && old.currentCheckpoint == "cp_09_floodedsubway_pre")
        return true;
    if(current.currentCheckpoint == "cp_11_floodedsubway_post" && old.currentCheckpoint == "cp_10_floodedsubway_mid")
        return true;
    if(current.currentCheckpoint == "cp_12_skyscraper_arena_pre" && old.currentCheckpoint == "cp_11_floodedsubway_post")
        return true;
    if(current.currentCheckpoint == "cp_13_skyscraper_arena_post" && old.currentCheckpoint == "cp_12_skyscraper_arena_pre")
        return true;
    if(current.currentCheckpoint == "cp_14_skyscraper_top" && old.currentCheckpoint == "cp_13_skyscraper_arena_post")
        return true;
    if(current.currentCheckpoint == "cp_14b_skyscraper_last" && old.currentCheckpoint == "cp_14_skyscraper_top")
        return true;
    if(current.currentCheckpoint == "cp_15_uacfacility_arena_pre" && old.currentCheckpoint == "cp_14b_skyscraper_last")
        return true;
    if(current.currentCheckpoint == "cp_15b_uacfacility_arena_pre" && old.currentCheckpoint == "cp_15_uacfacility_arena_pre")
        return true;
    if(current.currentCheckpoint == "cp_16_uacfacility_arena_post" && old.currentCheckpoint == "cp_15b_uacfacility_arena_pre")
        return true;
    if(!current.isLastEncounterActive && old.isLastEncounterActive && current.encounterName != null)
        return true;



    //optional encounters
    if(current.currentCheckpoint == "checkpoint_3" && old.currentCheckpoint == "checkpoint_1")
        return true;
    if(current.currentCheckpoint == "cp_04_trainstation_pre" && old.currentCheckpoint == "checkpoint_3")
        return true;
    // is when actiavte gore nest....(3.5)      "checkpoint_2" ---> "checkpoint_4"    > weird split <..... use encounter
    if(!current.is3_5EncounterActive && old.is3_5EncounterActive && current.encounterName != null && !vars.is3_5EncounterComplete){
        vars.is3_5EncounterComplete = true;
        return true;
    }
    if(current.currentCheckpoint == "cp_06_trainstation_post" && old.currentCheckpoint == "cp_05_chaingunner")
        return true;
    if(current.currentCheckpoint == "cp_07c_Escalation 2" && old.currentCheckpoint == "cp_07b_Escalation 1")
        return true;
    if(current.currentCheckpoint == "cp_09_floodedsubway_pre" && old.currentCheckpoint == "cp_07c_Escalation 2")
        return true;
    if(current.currentCheckpoint == "checkpoint_6" && old.currentCheckpoint == "checkpoint_5")
        return true;
    if(current.currentCheckpoint == "cp_14_skyscraper_top" && old.currentCheckpoint == "checkpoint_6")
        return true;
    if(current.currentCheckpoint == "checkpoint_8" && old.currentCheckpoint == "checkpoint_7")
        return true;
}

start
{
    if(!current.isLoading && current.is1EncounterActive && current.canMove == 255){
        vars.is3_5EncounterComplete = false;
        return true;
    }
}

reset
{

    if(current.currentCheckpoint == "" && old.currentCheckpointptr == 0){
        return true;
    }
       
    if(current.levelName == "game/shell/shell"){
       return true;
    }
    
}











































