import QtQuick 2.0
import MyComponents 1.0
Rectangle {
    width: 220
    height: 300
    color:"#00000000"
    radius: 5
    property real msec: 0

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered:parent.color="#304d6557"
        onExited: parent.color="#00000000"
    }

    ListModel{
        id:lyricModel

    }

    Component{
        id:lyricDelegate
        Rectangle{
            id:lyricLineRect
            height: 20
            width: 200
            color:"#00000000"
            Text{
                anchors.centerIn: parent
                color:lyricLineRect.ListView.isCurrentItem ? "white":"grey"
                text:lyricLine
                font.family: "微软雅黑"
                font.pointSize: 8
            }
        }


    }
    ListView{
        id:lyricView
        anchors.fill: parent
        spacing:5
        model:lyricModel
        delegate: lyricDelegate
        clip: true
        onCurrentItemChanged: NumberAnimation {
                        target: lyricView;
                        property: "contentY";
                        to:lyricView.currentItem.y-50;
                        duration: 200;
                        easing.type: Easing.InOutQuad
                    }
    }
    Lyric{
        id:lyric
    }
    Timer{
        id:timer
        repeat: true
        running: true
        interval: 30
        onTriggered:{
            msec+=30
            var i=lyric.getLyric(player.position);
            if(i>0){
                lyricView.currentIndex=i
            }
        }
    }

    Connections{
        target: playlist
        onCurrentMediaIndexChanged:{
            lyricModel.clear();

            if(!playlist.isLyricValid(jsonObj.lyric)){
                network.getLyric(playlist.at(playlist.currentMediaIndex()));
            }
            lyric.loadFile(jsonObj.lyric);
            for(var i=0;i<lyric.lineCount();i++){
                lyricModel.append({"lyricLine":lyric.lyricAt(i)});
            }
            timer.start()

        }


    }

    Connections{
        target: root
        onJsonObjChanged:{
            lyricModel.clear();
            lyric.loadFile(jsonObj.lyric);
            for(var i=0;i<lyric.lineCount();i++){
                lyricModel.append({"lyricLine":lyric.lyricAt(i)});
            }

        }
    }


}
