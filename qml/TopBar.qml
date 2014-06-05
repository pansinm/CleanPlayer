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
        color: "#999898"
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
        color:"#FF828282"
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
            color: "lightgrey"
            anchors.fill: parent
            text:"×"
            font.pointSize: 16
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.color="#f31414"
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
            color: "lightgrey"
            anchors.fill: parent
            text:"-"
            font.pointSize: 20
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.color="grey"
            onExited: parent.color="#00000000"
            onClicked:
            {
                mainwindow.showMinimized();
            }
        }

    }
}
