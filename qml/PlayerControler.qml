import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {
    color:Qt.rgba(0,0,0,0)
    width: parent.width
    height: 430
    anchors.left: parent.left
    anchors.bottom: parent.bottom


    //歌曲标题
    Text {
        id: title
        color:"#FFFFFF"
        anchors.bottom: artist.top
        anchors.bottomMargin: 20
        anchors.left: artist.left
        text: song
        font.pointSize: 24
    }

    //演唱
    Text{
        id: artist
        color:"#828282"
        anchors.bottom: cover.top
        anchors.bottomMargin: 20
        anchors.left: cover.left
        text:singer
        font.pointSize: 14
    }

    //封面
    BorderImage
    {
        id:cover
        width: 150
        height: 150
        clip:true
        anchors.left: parent.left
        anchors.leftMargin: 48
        anchors.top: parent.top
        anchors.topMargin: 110
        source:coverUrl
    }

    //播放
    Rectangle{
        id:playBtn
        anchors.horizontalCenter: cover.horizontalCenter
        anchors.top: cover.bottom
        anchors.topMargin: 30
        width:  66
        height: 66
        radius: 33
        color:"#00000000"

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered:{
                parent.color="#50505080"

            }
            onExited: {
                playBtn.color="#00000000"
            }

            onClicked: {
                if(isPlaying){
                    playengine.pause()
                    playImgUrl="qrc:/image/image/play.png"
                    isPlaying=false
                }
                else{
                    playengine.play()
                    playImgUrl="qrc:/image/image/pause.png"
                    isPlaying=true
                }


            }
        }

        Image{
            id:play_img
            anchors.centerIn: parent
            source: playImgUrl
            }

    }

    Rectangle{
        id:previousBtn
        height: 50
        width: 50
        radius: 25
        color: "#00000000"
        anchors.verticalCenter:playBtn.verticalCenter
        anchors.right: playBtn.left
        anchors.rightMargin: 2
        Image{
            anchors.centerIn: parent
            source: "qrc:/image/image/previous.png"

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
                parent.color="#80808080"
            }
            onReleased: {
                parent.color="#00000000"
            }
            onClicked:{

                playengine.playPrevious()
                playlistView.currentIndex=playlistView.currentIndex-1
                playImgUrl="qrc:/image/image/pause.png"
                isPlaying=true
            }

        }
    }

    Rectangle{
        id:nextBtn
        height: 50
        width: 50
        radius: 25
        color: "#00000000"
        anchors.verticalCenter:playBtn.verticalCenter
        anchors.left: playBtn.right
        anchors.leftMargin: 2
        Image{
            anchors.centerIn: parent
            source: "qrc:/image/image/next.png"

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
                parent.color="#80808080"
            }
            onReleased: {
                parent.color="#00000000"
            }
            onClicked: {
                playengine.playNext()
                playlistView.currentIndex=playlistView.currentIndex+1
                playImgUrl="qrc:/image/image/pause.png"
                isPlaying=true
                }
        }

    }


    Slider {
        id:slider
        x:15
        y:parent.height-55
        maximumValue:mediaLenth
        value: currentPosition
        stepSize:1.0
        style: SliderStyle {
            groove: Rectangle {
                implicitWidth: 610
                implicitHeight: 1.5
                color: "#828282"
                radius: 1
            }
            handle: Rectangle {
                width: 18
                height: 18
                radius: 9
                color:"#00000000"
                //anchors.centerIn:parent.left
                Image {
                    id:slider_point
                    anchors.centerIn: parent
                    source: "qrc:/image/image/slider-point.png"
                }

            }
        }
        onValueChanged: {
            if(pressed){
                currentPosition=value
            }

        }
        onPressedChanged: {
            if(pressed){
                isSliderPessed=true
            }
            else{
                isSliderPessed=false
                playengine.setPlayPosition(value)
            }
        }
    }
    Text{
        id:currentPosition_txt
        anchors.left: slider.left
        anchors.top: slider.bottom
        anchors.topMargin: 8
        color:"#828282"
        text:currentPosition
    }
    Text{
        id:musicLength_txt
        anchors.right: slider.right
        anchors.top: slider.bottom
        anchors.topMargin: 8
        color:"#828282"
        text:mediaLenth
    }




}
