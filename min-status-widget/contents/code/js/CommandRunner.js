
var lastRun = "Never";

function runCommand(commandString){
	lastRun = new Date();
	console.log("Running Command..." + commandString);
	return plasmoid.runCommand(commandString);
}

function getLastRunTime(){
	return lastRun;
}