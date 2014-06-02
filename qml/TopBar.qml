import QtQuick 2.0

Rectangle {
    anchors.top: parent.top
    anchors.left: parent.left
    width: parent.width
    height: 50
    color:"#00000000"

    //标题
    Image{
        y:10
        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:/image/image/title.png"
    }

    Rectangle{
        id:fineLine
        x:0
        y:48
        width: parent.width
        height: 1
        color:"#FF828282"
    }

    //关闭按钮
    Rectangle {
        id:closeBtn
        x: parent.width-43
        y:10
        height: 30
        width: 30
        radius:8
        color:"#00000000"
        Image {
            anchors.fill: parent
            id: name
            source: "qrc:/image/image/close-normal.png"
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
}
