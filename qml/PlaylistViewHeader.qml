import QtQuick 2.0

//播放列表上部控件，添加删除等
Rectangle {
    height: 24
    width: 180
    radius: 3
    color:"#90b1b7b5"
    property bool isScrolled: false
    //列表和歌词区域切换
    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered: parent.color="#80d9d9d9"
        onExited: parent.color="#90b1b7b5"
        onClicked: {
            if(isScrolled){
                expandList.start()
            }
            else{
                scrollList.start()
            }
            isScrolled=!isScrolled
        }
    }

    Image{
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        source: parent.isScrolled ? "qrc:/image/image/down.png" : "qrc:/image/image/up.png"
    }

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

    SequentialAnimation {
           id: scrollList
           running: false
           NumberAnimation { target: playlistRegion; property: "height"; to: 10 ; duration: 200}
           PropertyAnimation { target: playlistRegion; property: "visible"; to: false ; duration: 50}
           NumberAnimation { target: lyricView; property: "width"; to: 380; duration: 200}
       }
    SequentialAnimation {
           id: expandList
           running: false
           NumberAnimation { target: lyricView; property: "width"; to: 220; duration: 200}
           PropertyAnimation { target: playlistRegion; property: "visible"; to: true ; duration: 50}
           NumberAnimation { target: playlistRegion; property: "height"; to: 320 ; duration: 200}

       }
}
