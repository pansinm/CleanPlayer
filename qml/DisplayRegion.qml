import QtQuick 2.0

Rectangle {
    width: 200
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 65
    color:"#00909090"
    anchors.left: parent.left
    anchors.leftMargin: 15
    anchors.top: topBar.bottom
    anchors.topMargin: 20

    //演唱
    Text{
        id: artist
        color:fontColor
        anchors.bottom: cover.top
        anchors.bottomMargin: 25
        anchors.left: cover.left
        text:jsonObj.artist==="" ? "未知歌手" : jsonObj.artist
        font.family: "微软雅黑"
        font.pointSize: 14
        onTextChanged: {
            if(text.length>10)
                font.pointSize = 10;
            else
                font.pointSize = 14;
        }
    }

    //默认封面
    BorderImage
    {
        id:defaultcover
        width: 160
        height: 160
        clip:true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 60
        source:"qrc:/image/image/defaultCover.png"

    }

    //封面
    BorderImage
    {
        id:cover
        width: 160
        height: 160
        clip:true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 60
        source:jsonObj.cover

    }


}
