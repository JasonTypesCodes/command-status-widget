import QtQuick 1.1

Item {  
  
  Image {
    
    property string okImage: "plasmapackage:/images/ok.png"
    property string errorImage: "plasmapackage:/images/error.png"
    property string workingImage: "plasmapackage:/images/gear.png"
    property string nextImage: widgetImage.errorImage
    property int commandInterval: 1000

    id: widgetImage
    source: widgetImage.okImage
    anchors.centerIn: parent
    width: parent.width
    height: parent.height
    fillMode: Image.PreserveAspectFit

    MouseArea {
      anchors.fill: parent
      onClicked: widgetImage.runCommand()
    }

    function switchImages(){
      var nextImage = widgetImage.nextImage;
      widgetImage.nextImage = widgetImage.source;
      widgetImage.source = nextImage;
    }

    function sendNotification(){
      console.log("Clicked!");
      var service = dataEngine("notifications").serviceForSource("notification");
      var operation = service.operationDescription("createNotification");
      operation["appName"] = "Min-Status-Widget";
      operation["appIcon"] = plasmoid.file("images", "ok.png");
      operation["summary"] = "Something Happened!";
      operation["body"] = "I'm assuming that this should be longer...";
      operation["timeout"] = 3000;

      service.startOperationCall(operation);
      console.log(service.serviceReady(service));
    }

    function runCommand(){
      widgetImage.source = widgetImage.workingImage;
      console.log("Running Command...");
      var result = plasmoid.runCommand("/home/jschindler/src/min-status-widget/resources/randomSuccess.sh");
      sendNotification();
      console.log(result);
    }

    Timer {
      id: "myTimer"
      interval: 500; running: true; repeat: true
      onTriggered: widgetImage.switchImages()
    }
  }
}