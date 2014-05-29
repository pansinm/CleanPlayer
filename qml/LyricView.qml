import QtQuick 2.0
import MyComponents 1.0
Rectangle {
    width: 200
    height: 300
    color:"#00000000"
    property real msec: 0
    ListModel{
        id:lyricModel

    }


    Component{
        id:lyricDelegate
        Rectangle{
            height: 20
            width: 200
            color:"#00000000"
            Text{
                anchors.centerIn: parent
                color: "lightblue"
                text:lyricLine
            }
        }

    }
    ListView{
        id:lyricView
        spacing:5
        width: 200
        height: 300


        highlight: Rectangle{
            color:"#60808080"
        }

        model:lyricModel
        delegate: lyricDelegate

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
            lyricView.currentIndex=lyric.getLyric(msec)
        }
    }

    Connections{
        target: playengine

        onLyricChanged:{
            console.log("onLyricChanged lyricFile:"+lyricFile)
            lyric.loadFile(lyricFile)
            console.log("onLyricChanged loadFile:"+lyricFile)
            lyricModel.clear()

            for(var i=0;i<lyric.lineCount();i++){
                lyricModel.append({"lyricLine":lyric.lyricAt(i)})
            }
        }

        onMusicChanged:{
            msec=0
            timer.restart()
        }
    }
}
