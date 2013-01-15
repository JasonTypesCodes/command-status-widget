import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import "plasmapackage:/code/js/NotificationHelper.js" as NotificationHelper
import "plasmapackage:/code/js/SettingsManager.js" as SettingsManager

Item {  
  
  Image {
    id: widgetImage
    
    property string okImage: "plasmapackage:/images/ok.png"
    property string errorImage: "plasmapackage:/images/error.png"
    property string workingImage: "plasmapackage:/images/gear.png"

    source: workingImage
    anchors.centerIn: parent
    width: parent.width
    height: parent.height
    fillMode: Image.PreserveAspectFit

    MouseArea {
      anchors.fill: parent
      onClicked: widgetImage.go()
    }

    PlasmaCore.DataSource {
      id: execDataSource
      engine: "executable"
      interval: 0 //Don't run until everything has loaded...
      onNewData: {
        var result = data["exit code"];
        if(result == 0){
          widgetImage.source = widgetImage.okImage;
          NotificationHelper.sendSuccessNotifiaction(sourceName);
        } else if(result != 0){
          widgetImage.source = widgetImage.errorImage;
          NotificationHelper.sendFailureNotifiaction(sourceName);
        }
      }
    }

    Component.onCompleted: {
      execDataSource.connectSource(
        SettingsManager.getCommandToRun(),
        execDataSource
      );
      execDataSource.interval = 2000;
    }
  }
}