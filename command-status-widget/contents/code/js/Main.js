/*
 * I would really prefer to break this up into seperate files and simply 
 * import/include them here under a namespace.  Much in the same way that
 * the QML files allow you to do it.  I've even considered creating a QML
 * module that only exists to house the javascript just so I can do 
 * namespacing correctly.
 *
 * Main.js
 * SettingsManager.js
 * NotificationHelper.js
 * Utils.js
 * etc...
 */

function init(){
  plasmoid.globals = {};
  plasmoid.addEventListener('ConfigChanged', readConfig);
  readConfig();
  resetPoller();
  resetToolTip();
  setLastRun("NEVER");
}

function readConfig(){
  var name = String(plasmoid.readConfig("name"));
  var pollingInterval = plasmoid.readConfig("pollingInterval");
  var command = String(plasmoid.readConfig("command"));
  var sendNotifications = asBoolean(plasmoid.readConfig("sendNotifications"));
  var doResetPoller = false;
  var doResetToolTip = false;

  if(command != getCommand() || (pollingInterval * 1000) != getPollingInterval()){
    doResetPoller = true;
  }

  if(name != getName()){
    doResetToolTip = true;
  }

  setGlobal("name", name);
  setGlobal("pollingInterval", pollingInterval);
  setGlobal("command", command);
  setGlobal("sendNotifications", sendNotifications);

  if(doResetPoller){
    resetPoller();
  }

  if(doResetToolTip){
    resetToolTip();
  }
}

function resetToolTip(){
  toolTip.toolTip = getName() + " Last Ran: " + formatDate(getLastRun());
}

function resetPoller(){
  execDataSource.interval = getPollingInterval();
  execDataSource.connectedSources = [getCommand()];
}

function setLastRun(lastRun){
  setGlobal("lastRun", lastRun);
}

function getLastRun(){
  return getGlobal("lastRun");
}

function doNotification(){
  return getGlobal("sendNotifications");
}

function getName(){
  return getGlobal("name");
}

function getPollingInterval(){
  return (getGlobal("pollingInterval") * 1000);
}

function getCommand(){
  return getGlobal("command");
}

function getGlobal(globalName){
  return plasmoid.globals[globalName];
}

function setGlobal(globalName, value){
  plasmoid.globals[globalName] = value;
}

function executionComplete(sourceName, data){
  setLastRun(new Date());
  var result = data["exit code"];
  if(result == 0){
    widgetImage.source = widgetImage.okImage;
    if(doNotification()){
      sendSuccessNotifiaction(getName());
    }
  } else {
    widgetImage.source = widgetImage.errorImage;
    if(doNotification()){
      sendFailureNotifiaction(getName());
    }
  }
  resetToolTip();
}

function sendNotification(summaryText, bodyText, iconFile){
  console.log("Sending notification!");
  console.log("Summary: " + summaryText);
  console.log("Body: " + bodyText);
  var service = dataEngine("notifications").serviceForSource("notification");
  var operation = service.operationDescription("createNotification");
  
  operation["appName"] = "Command-Status-Widget";
  operation["appIcon"] = iconFile;
  operation["summary"] = summaryText;
  operation["body"] = bodyText;
  operation["timeout"] = 3000;

  service.startOperationCall(operation);
}

function sendSuccessNotifiaction(name){
  sendNotification(
    name + " Succeeded!", 
    name + " command ran successfully.",
    plasmoid.file("images", "ok.png")
  );
}

function sendFailureNotifiaction(name){
  sendNotification(
    name + " Failed!", 
    name + " command failed.",
    plasmoid.file("images", "error.png")
  );
}

function asBoolean(input){
  if(input == "false" || input == "0" || input == 0){
    return false;
  } 
  return Boolean(input);
}

function formatDate(someDate){
  if(someDate.getMonth){
    return someDate.getFullYear() + "-" 
            + (someDate.getMonth() + 1) + "-" 
            + someDate.getDate() + " " 
            + someDate.getHours() + ":" 
            + someDate.getMinutes() + ":" 
            + someDate.getSeconds();
  }
  return someDate;
}

