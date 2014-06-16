import QtQuick 2.0

Rectangle {
    anchors.top: parent.top
    anchors.left: parent.left
    width: parent.width
    height: 40
    color:"#00000000"

    //程序标题
    Text{
        anchors.centerIn: parent
        color: "#fff061"
        text:"Clean Player"
        font.family: "微软雅黑"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 12
    }

    Rectangle{
        id:fineLine
        x:0
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color:"#e0ffffff"
    }

    //关闭按钮
    Rectangle {
        id:closeBtn
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        height: 25
        width: 25
        radius:8
        color:"#00000000"
        Text {
            color: "white"
            anchors.fill: parent
            text:"×"
            font.pointSize: 16
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.color="#90ff0000"
            onExited: parent.color="#00000000"
            onClicked:
            {
                playlist.save("playlist.xml")
                mainwindow.close()
            }
            }

    }

    Rectangle {
        id:minBtn
        anchors.right: closeBtn.left
        anchors.rightMargin: 3
        anchors.verticalCenter: parent.verticalCenter
        height: 25
        width: 25
        radius:8
        color:"#00000000"
        Text {
            color: "white"
            anchors.fill: parent
            text:"-"
            font.pointSize: 20
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.color="#40ffffff"
            onExited: parent.color="#00000000"
            onClicked:
            {
                mainwindow.showMinimized();
            }
        }

    }
}
