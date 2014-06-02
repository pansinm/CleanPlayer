
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {
    color:"#00000000"
    width: parent.width
    anchors.top: displayRegion.bottom
    anchors.topMargin: -90
    anchors.left: parent.left
    anchors.bottom: parent.bottom

    //补0
    function pad(num, n) {
        var len = num.toString().length;
        while(len < n) {
            num = "0" + num;
            len++;
        }
        return num;
    }

    //播放按钮
    Rectangle{
        id:playBtn
        x:displayRegion.x+(displayRegion.width-width)/2
        anchors.top: displayRegion.bottom
        anchors.topMargin: 30
        width:  66
        height: 66
        radius: 33
        color:"#00000000"

        property bool isPlaying : false

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered:{
                parent.color="#50505080";

            }
            onExited: {
                playBtn.color="#00000000";
            }

            onClicked: {

                if(playBtn.isPlaying)
                {
                    player.pause();
                }
                else{
                    player.play();
                }
            }

        }

        Image{
            id:play_img
            anchors.centerIn: parent
            //图标切换
            source: playBtn.isPlaying ? "qrc:/image/image/pause.png" : "qrc:/image/image/play.png"
            }

    }

    //上一首按钮
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
                parent.color="#50505080";

            }
            onExited: {
                parent.color="#00000000";
            }
            onPressed: {
                parent.color="#80808080";
            }
            onReleased: {
                parent.color="#00000000";
            }
            onClicked:{
                playlist.previous();
            }

        }
    }

    //下一首按钮
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
                parent.color="#50505080";

            }
            onExited: {
                parent.color="#00000000";
            }
            onPressed: {
                parent.color="#80808080";
            }
            onReleased: {
                parent.color="#00000000";
            }
            onClicked: {
                playlist.next();
            }
        }

    }

    //进度条
    Slider {
        id:slider
        x:15
        y:parent.height-55
        maximumValue:0
        value: 0
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
                Image {
                    id:slider_point
                    anchors.centerIn: parent
                    source: "qrc:/image/image/slider-point.png"
                }

            }
        }
        onValueChanged: {

            //拖动时改变当前时间显示
            if(pressed){
                var pos=value;
                var min=Math.round(pos/1000/60);
                var sec=Math.round(pos/1000%60);
                currentPosition_txt.text=parent.pad(min,2)+":"+parent.pad(sec,2);

            }

        }
        onPressedChanged: {
            if(!pressed){
                player.seek(value)
            }

        }
    }

    //当前时间
    Text{
        id:currentPosition_txt
        anchors.left: slider.left
        anchors.top: slider.bottom
        anchors.topMargin: 8
        color:"#828282"
        text:"00:00"
    }

    //总时间
    Text{
        id:musicLength_txt
        anchors.right: slider.right
        anchors.top: slider.bottom
        anchors.topMargin: 8
        color:"#828282"
        text:"00:00"
    }

    //信号响应
    Connections{
        target: player
        onPlaying:playBtn.isPlaying = true
        onStopped:playBtn.isPlaying = false
        onPaused:playBtn.isPlaying = false

        onDurationChanged: {
            var du=player.duration;
            var min=Math.round(du/1000/60);
            var sec=Math.round(du/1000%60);
            slider.maximumValue=du;
            musicLength_txt.text=pad(min,2)+":"+pad(sec,2);
        }

        onPositionChanged:{
            var du=player.position;
            var min=Math.round(du/1000/60);
            var sec=Math.round(du/1000%60);

            //如果左键按下，则不同步slider.value
            if(!slider.pressed){
                slider.value=du;
                currentPosition_txt.text=pad(min,2)+":"+pad(sec,2);
            }
        }
    }
}
