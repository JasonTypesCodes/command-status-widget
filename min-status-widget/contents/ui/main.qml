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

    function switchImages(){
      var nextImage = widgetImage.nextImage;
      widgetImage.nextImage = widgetImage.source;
      widgetImage.source = nextImage;
    }

    Timer {
      id: "myTimer"
      interval: 500; running: true; repeat: true
      onTriggered: widgetImage.switchImages()
    }
  }
}