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
        color:"#92bee8"
        anchors.bottom: cover.top
        anchors.bottomMargin: 20
        anchors.left: cover.left
        text:jsonObj.artist
        font.family: "微软雅黑"
        font.pointSize: 14
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
        anchors.topMargin: 70
        source:jsonObj.cover

    }

    //标题
    Text{
        id: title
        color:"#71addb"
        anchors.bottom: parent.bottom
        anchors.left: cover.left
        text:jsonObj.title
        font.family: "微软雅黑"
        verticalAlignment: Text.AlignVCenter
        styleColor: "#d1cbcb"
        font.pointSize: 10
    }

    Connections{
        target: playlist
        onCurrentMediaIndexChanged:{

            if(!playlist.isCoverValid(jsonObj.cover)){
                network.getPic(JSON.stringify(jsonObj));
            }
        }
    }


}
