import QtQuick 2.0

//播放列表上部控件，添加删除等
Rectangle {
    height: 24
    width: 180
    radius: 3
    color:"#b1b7b5"



    Text{
        anchors.centerIn: parent
        color: "#ffffff"
        text:"播放列表"
        font.family: "微软雅黑"
        font.pointSize: 10
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }



    Rectangle{
        id:addMusicBtn
        width: 24
        height: 24
        anchors.top: parent.top
        anchors.left: parent.left
        color: "#00000000"
        radius: 3
        Image {
            id: addImg
            anchors.centerIn: parent
            source: "qrc:/image/image/add.png"
        }


        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                parent.color="#50505080"

            }
            onExited: {
                parent.color="#00000000"
            }
            onPressed: {
                addTxt.color="lightslategrey"
            }
            onReleased: {
                addTxt.color="lightgray"
            }
            onClicked: fileDialog.open()
        }
    }
}
