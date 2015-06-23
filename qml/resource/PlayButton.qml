import QtQuick 2.4

Rectangle {
    width:  66
    height: 66
    radius: 33
    color: "#00000000"
    signal play()   //播放
    signal pause()  //暂停
    property bool isPlaying: false
    Image {
        id: icon
        source: parent.isPlaying ? "qrc:/image/image/pause.png" : "qrc:/image/image/play.png"
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
            parent.isPlaying = !parent.isPlaying;
            if( parent.isPlaying){
                play();
            } else{
                pause();
            }
        }
    }
}

