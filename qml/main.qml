import QtQuick 2.2
import QtQuick.Controls 1.1
import MyComponents 1.0

Rectangle {
    width: 640
    height: 480
    radius: 3
    id:root
    signal  next()
    property url playImgUrl:"qrc:/image/image/play.png"
    property bool isPlaying: false
    property url coverUrl: ""
    property string song: ""
    property string singer:""
    property real mediaLenth: 0
    property real currentPosition: 0
    property bool isSliderPessed: false

    Connections{
        target: playengine
        onCoverChanged:{
            console.log("signal:coverChanged coverFile:"+coverFile)
            root.coverUrl=coverFile
        }

        onMusicChanged:{
            root.song=nameStr
            root.singer=artistStr
        }
        onPositionChanged:{
            if(!isSliderPessed){
            currentPosition=pos
            }
        }
        onDurationChanged:{
            mediaLenth=du
        }

    }


    gradient:Gradient{
       GradientStop { position: 0.0; color: "#EB3C3C3C"}
       //细线
       GradientStop { position: 0.099; color: "#EB3C3C3C" }
       GradientStop { position: 0.1; color: "#FF828282" }
       GradientStop { position: 0.101; color: "#EB3C3C3C"}

       GradientStop { position: 0.537; color: "#EB3C3C3C" }
       GradientStop { position: 0.889; color: "#EB141414" }
       GradientStop { position: 1; color:  "#EB141414" }
    }

    //拖拽区域
    Rectangle{
        id:dragRect
        radius: parent.radius
        anchors.fill:parent
        color:Qt.rgba(0,0,0,0)
        //标题
        Image{
            y:10
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/image/image/title.png"
        }
        MouseArea {
            id: dragRegion
            anchors.fill: parent
            property point clickPos: "0,0"
            onPressed: {
                clickPos  = Qt.point(mouse.x,mouse.y)
                }

            onPositionChanged: {

            //鼠标偏移量
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)

            //如果mainwindow继承自QWidget,用setPos
            mainwindow.setX(mainwindow.x+delta.x)
            mainwindow.setY(mainwindow.y+delta.y)

            }
        } //mousearea*/

    }

    //关闭按钮
    Rectangle {

        x: parent.width-43
        y:10
        height: 30
        width: 30
        color:"#00000000"
        id:closeBtn
        Image {
            anchors.fill: parent
            id: name
            source: "qrc:/image/image/close-normal.png"
        }

        MouseArea{

            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.color="#80900000"
            onExited: parent.color="#00000000"
            onClicked:
            {
                mainwindow.close()
            }
            }

    }

    Rectangle{
        id:addMusicBtn
        width: 24
        height: 24
        border.width: 1
        border.color: "lightgray"
        color: "#00000000"
        x:440
        y:60
        radius: 3
        Text {
            id:addTxt
            anchors.centerIn: parent
            text: qsTr("+")
            color: "lightgray"
            font.pointSize: 16
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
            onClicked: playengine.addMusic()

        }
    }
    ListView{
        id:playlistView
        width: 200
        height: 320
        y:100
        anchors.right: parent.right
        rightMargin: 30
        clip: true
        focus: true
        spacing:5
        model:myModel
        delegate: PlaylistDelegate{}
        highlight:Rectangle{
            radius:3
            color:"#90909090"
        }

        highlightMoveDuration:500
        onCurrentIndexChanged: {
        }

    }

    LyricView{
        id:lyricRegion
        x:220
        y:100
    }

    PlayerControler{
        id:playControler

    }




}
