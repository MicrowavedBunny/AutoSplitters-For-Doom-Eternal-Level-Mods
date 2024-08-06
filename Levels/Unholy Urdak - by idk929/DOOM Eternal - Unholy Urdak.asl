// Doom Eternal Unholy Urdak Autosplitter
// By MicrowavedBunny for 6.66 r2.2 steam only
// HUGE THANKS to Micrologist

state("DOOMEternalx64vk", "6.66 Rev 2.2 (Steam)")
{
    string60 currentCheckpoint : 0x6B07D00, 0x1108;
    int currentCheckpointptr : 0x6B07D00;
    bool isLoading : 0x51C8398;
	byte isLoading2: 0x6930410;
    bool isInGame : 0x68E4870;
	int cutsceneID: 0x5163A48;
    float playerHealth : 0x6C01A08, 0x0, 0x48, 0x898; //change pointer bc broken idk..... wtf it isnt broken on reset so idk something is borked
    string10 encounterName : 0x6B07D60, 0x2C8, 0x8, 0x28, 0x0, 0x8, 0x48, 0x0;
    string31 levelName : 0x6B07DB0;
    bool is1EncounterActive : 0x6B07D60, 0x2C8, 0x8, 0x28, 0x0, 0x180, 0x640;
    bool isHolt17EncounterActive : 0x6B07D60, 0x2C8, 0x8, 0x28, 0x0, 0x40, 0x640;
    bool isCelestialEncounterActive : 0x6B07D60, 0x2C8, 0x8, 0x28, 0x0, 0x8, 0x640;
    bool isUrdakFinalEncounterActive : 0x6B07D60, 0x2C8, 0x8, 0x28, 0x0, 0x18, 0x640;
    float posX : 0x6446BE0;
	float posY : 0x6446BE4;
    float posZ : 0x6446BE8;
}

startup
{
	vars.gameVersion = 0;
    vars.isCelestialEncounterComplete = false; //to ensure people dont die and redo the encounter causing another split due to using encounter instead of checkpoint to check for a split
    vars.isHolt17EncounterComplete = false; //to ensure people dont die and redo the encounter causing another split due to using encounter instead of checkpoint to check for a split
    vars.skipPreventionMessage = false; // to ensure only one pop up.
    vars.endSplitPos = false; //check end trigger in update
    vars.startPosCheck = false; // used after last checkpoint to limit the amount of time/resources the PosCheck is running/using.
    
    //for removing load times
	vars.newSplitMethod = true;
    vars.ebs = false;
    vars.injectEBS = false;
    vars.loadscreen = false;
    vars.timeToRemove = 0;
	vars.setGameTime = false;

    if (timer.CurrentTimingMethod == TimingMethod.RealTime) {        
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "Doom Eternal | LiveSplit",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
    
        if (timingMessage == DialogResult.Yes) {
        timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
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
        
    if(current.levelName == "game/shell/shell"){
        vars.skipPreventionMessage = false; 
    }

    if(vars.startPosCheck){ //so it only checks Pos when at last encounter
        if(current.posX >= 60.5 && current.posX <= 158 && current.posY >= 713.50 && current.posY <= 752 && current.posZ >= -154.589 && current.posZ <= -54.6){
            vars.endSplitPos = true;
        }else{
            vars.endSplitPos = false;
        }
    }

    if(timer.CurrentPhase == TimerPhase.NotRunning) //make it stop checking Pos after timer stops/resets
        vars.startPosCheck = false;
}

exit
{
	timer.IsGameTimePaused = true;
}

isLoading
{
	// Blackscreen detection
	// 	Current Real Time is saved upon the start and end of a blackscreen, then the diff is injected back into Game Time in the gameTime() Action
    var loading2 = false;
    if(vars.gameVersion >= 30) loading2 = current.isLoading2 > 0;
    else loading2 = current.isLoading2;
    
    if(vars.ebs)
    {
		// This condition checks if the blackscreen ends or if a new level is loaded during a blackscreen
        if(!current.isLoading || (current.isLoading && current.isLoading2 != old.isLoading2))
        {
            vars.ebs = false;
            vars.timeAfterEBS = timer.CurrentTime.RealTime;
            vars.injectEBS = true;
        }
    }
    if(current.isLoading && !loading2 && current.isInGame && !vars.ebs)
    {
        vars.ebs = true;
        vars.timeBeforeEBS = timer.CurrentTime.RealTime;
    }
    
	if(vars.gameVersion >= 30)
	{
		// 3.0 - isLoading2 now has a value of 2 if loading into a new level for the first time
		vars.loadscreen = (current.isLoading || current.isLoading2 > 0 || !current.isInGame);
		return vars.loadscreen;
	}
	vars.loadscreen = (current.isLoading || current.isLoading2 || !current.isInGame);
	return vars.loadscreen;
}

split
{
    //The Holt
    if(current.currentCheckpoint == "checkpoint_1" && old.currentCheckpoint == "")
        return true;
    if(current.currentCheckpoint == "checkpoint_2" && old.currentCheckpoint == "checkpoint_1")
        return true;
    if(current.currentCheckpoint == "checkpoint_3" && old.currentCheckpoint == "checkpoint_2")
        return true;
    if(current.currentCheckpoint == "checkpoint_4" && old.currentCheckpoint == "checkpoint_3")
        return true;
    if(current.currentCheckpoint == "checkpoint_5_1" && old.currentCheckpoint == "checkpoint_4")
        return true;
    if(current.currentCheckpoint == "checkpoint_5_2" && old.currentCheckpoint == "checkpoint_5_1")
        return true;
    if(current.currentCheckpoint == "checkpoint_6" && old.currentCheckpoint == "checkpoint_5_2")
        return true;
    if(current.currentCheckpoint == "checkpoint_7" && old.currentCheckpoint == "checkpoint_6")
        return true;
    if(current.currentCheckpoint == "checkpoint_8" && old.currentCheckpoint == "checkpoint_7")
        return true;
    if(current.currentCheckpoint == "checkpoint_9" && old.currentCheckpoint == "checkpoint_8")
        return true;
    if(current.currentCheckpoint == "checkpoint_10" && old.currentCheckpoint == "checkpoint_9")
        return true;
    if(current.currentCheckpoint == "checkpoint_11" && old.currentCheckpoint == "checkpoint_10")
        return true;
    if(current.currentCheckpoint == "checkpoint_12" && old.currentCheckpoint == "checkpoint_11")
        return true;
    if(current.currentCheckpoint == "checkpoint_13" && old.currentCheckpoint == "checkpoint_12")
        return true;
    if(current.currentCheckpoint == "checkpoint_14" && old.currentCheckpoint == "checkpoint_13")
        return true;
    if(current.currentCheckpoint == "checkpoint_15" && old.currentCheckpoint == "checkpoint_14")
        return true;
    if(current.currentCheckpoint == "checkpoint_16" && old.currentCheckpoint == "checkpoint_15")
        return true;
    if(current.currentCheckpoint == "checkpoint_17" && old.currentCheckpoint == "checkpoint_16")
        return true;
    if(!current.isHolt17EncounterActive && old.isHolt17EncounterActive && current.levelName.Contains("e4m3_mcity") && current.encounterName != null && !vars.isHolt17EncounterComplete){//might work migh tneed to check encountername pointer instead
        vars.isHolt17EncounterComplete= true;
        return true;
    }

    //Celestial
    if(!current.isCelestialEncounterActive && old.isCelestialEncounterActive && current.levelName.Contains("pvp_bronco") && current.encounterName != null && !vars.isCelestialEncounterComplete){ //might work migh tneed to check encountername pointer instead
        vars.isCelestialEncounterComplete = true;
        return true;
    }
    

    //Urdak
    if(current.currentCheckpoint == "checkpoint_2" && old.currentCheckpoint == "")
        return true;
    if(current.currentCheckpoint == "checkpoint_5" && old.currentCheckpoint == "checkpoint_4")
        return true;
    if(current.currentCheckpoint == "checkpoint_6" && old.currentCheckpoint == "checkpoint_5")
        return true;
    if(current.currentCheckpoint == "checkpoint_18" && old.currentCheckpoint == "checkpoint_17")
        return true;
    if(current.currentCheckpoint == "checkpoint_19" && old.currentCheckpoint == "checkpoint_18")
    {
        vars.startPosCheck = true;
        return true;
    }
    if(vars.endSplitPos) //checks position to the end of level trigger for final split. Only after previous split.
        return true;
}

gameTime
{
	if(vars.setGameTime)
	{
		vars.setGameTime = false;
		return TimeSpan.FromSeconds(-vars.timeToRemove);
	}

    // Injects EBS time, minus one second, back into Game Timer if the EBS time is greater than two seconds.
	// 	If a blackscreen's duration is greater than two seconds, this guarantees that it is an EBS.
	// 	Subtracting a second is to account for the normal blackscreen length that always happens upon reloads/quitouts.
    if(vars.injectEBS)
    {
        vars.injectEBS = false;
        var diff = vars.timeAfterEBS - vars.timeBeforeEBS;
        var newGameTime = timer.CurrentTime.GameTime + diff - TimeSpan.FromSeconds(1);
        return (diff >= TimeSpan.FromSeconds(2)) ? newGameTime : timer.CurrentTime.GameTime;
    }
}

start
{
    if(current.is1EncounterActive && !old.is1EncounterActive && current.levelName.Contains("e4m3_mcity")){ //level name check is probably not needed but just in case
    vars.isCelestialEncounterComplete = false;
    vars.isHolt17EncounterComplete = false;
    vars.startPosCheck = false;
    return true;
    }

    if(current.levelName.Contains("pvp_bronco") | current.levelName.Contains("e3m3_maykr")){
        if (!vars.skipPreventionMessage){
            MessageBox.Show("If you are starting in Celestial or Urdak, you need to start from the beginning in The Holt");
        }
    vars.skipPreventionMessage = true; 
    return false;
    }

}

reset
{

    if(current.currentCheckpoint == "" && old.currentCheckpointptr == 0 && current.levelName.Contains("e4m3_mcity")){
        return true;
    }

	//if(current.levelName.Contains("e4m3_mcity") && !old.levelName.Contains("")){
    //     return true;
    //}
       

    if(current.levelName == "game/shell/shell"){
       return true;
    }
    
}











































