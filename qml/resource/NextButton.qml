import QtQuick 2.4

Rectangle {
    width: 50
    height: 50
    radius: 25
    color: "#00000000"
    signal next()
    property bool isPlaying: false
    Image {
        id: icon
        source:  "qrc:/image/image/next.png"
        anchors.centerIn: parent
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered:{
            //hover

        }
        onExited: {
           //
        }
        onClicked: {
            next();
        }

    }
}

