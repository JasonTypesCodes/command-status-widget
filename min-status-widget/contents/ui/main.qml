import QtQuick 1.1
import "../code/js/NotificationHelper.js" as NotificationHelper
import "../code/js/CommandRunner.js" as CommandRunner
import "../code/js/SettingsManager.js" as SettingsManager

Item {  
  
  Image {
    id: widgetImage
    
    property string okImage: "plasmapackage:/images/ok.png"
    property string errorImage: "plasmapackage:/images/error.png"
    property string workingImage: "plasmapackage:/images/gear.png"
    property bool isRunning: false

    source: widgetImage.workingImage
    anchors.centerIn: parent
    width: parent.width
    height: parent.height
    fillMode: Image.PreserveAspectFit

    MouseArea {
      anchors.fill: parent
      onClicked: widgetImage.go()
    }

    Timer {
      id: myTimer
      interval: 3000; running: false; repeat: true
      onTriggered: widgetImage.go()
    }

    Component.onCompleted: myTimer.running = true

    function go(){
      if(!isRunning){
        isRunning = true;
        source = workingImage;
        var result = CommandRunner.runCommand(SettingsManager.getCommandToRun());
        if(result){
          NotificationHelper.sendSuccessNotifiaction("MyCommand");
          source = okImage;
        } else {
          NotificationHelper.sendFailureNotifiaction("MyCommand");
          source = errorImage;
        }
        isRunning = false
      }
    }
  }
}