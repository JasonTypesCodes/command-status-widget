
function sendNotification(summaryText, bodyText){
  
  console.log("Sending notification: " + bodyText);
  var service = dataEngine("notifications").serviceForSource("notification");
  var operation = service.operationDescription("createNotification");
  
  operation["appName"] = "Min-Status-Widget";
  operation["appIcon"] = plasmoid.file("images", "ok.png");
  operation["summary"] = summaryText;
  operation["body"] = bodyText;
  operation["timeout"] = 3000;

  service.startOperationCall(operation);
  console.log(service);
}

function sendSuccessNotifiaction(name){
	sendNotification(
	  name + " Succeeded!", 
	  name + " command ran successfully."
	);
}

function sendFailureNotifiaction(name){
	sendNotification(
	  name + " Failed!", 
	  name + " command failed."
	);
}