import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import "plasmapackage:/code/js/Main.js" as JS

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
    smooth: true

    ToolTip {
      id: toolTip
    }

    PlasmaCore.DataSource {
      id: execDataSource
      engine: "executable"
      onNewData: { JS.executionComplete(sourceName, data) }
    }

    Component.onCompleted: {
      JS.init();
    }
  }
}
