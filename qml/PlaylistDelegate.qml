import QtQuick 2.0

Component {
    id:playlistDelegate
    Rectangle{
        width: 180
        height: 25
        radius: 3
        color: "#00000000"


        Text{
            id:txt
            width:180
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            color:"lightgray"
            text:qsTr(name)
            font.pointSize: 10

        }
        Text {
            id: txt2
            anchors.top: txt.bottom
            anchors.right: parent.right
            anchors.topMargin: 3
            anchors.rightMargin: 3
            visible: false
            color:"lightgray"
            text: qsTr("--"+artist)
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                parent.color="#50505050"
                txt2.visible=true
                parent.height=50

            }
            onExited: {
                parent.color="#00000000"
                txt2.visible=false
                parent.height=25
            }
            onClicked: {
                parent.ListView.view.currentIndex = index
                playengine.play(index)
                playImgUrl="qrc:/image/image/pause.png"
                isPlaying=true
            }

        }
    }


}
