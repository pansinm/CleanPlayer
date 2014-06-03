
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import MyComponents 1.0
Rectangle {
    color:"#00000000"
    width: parent.width
    height: 190
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

    Rectangle{
        id:volumeControler
        height: 32
        width:140
        x:40
        anchors.top: parent.top
        color:"#00000000"
        Rectangle{
            id:volumeImgResion
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            width: 32
            height: parent.height
            color: "#00000000"
            Image{
                id:volumeImg
                width: 24
                height: 24
                anchors.fill: parent
                source: "qrc:/image/image/volume-medium-icon.png"
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color="#50505080"
                onExited: parent.color="#00000000"
                onClicked: {
                    player.muted=!player.muted
                }
            }
        }

        Slider{
            id:volumeSlider
            anchors.left: volumeImgResion.right
            anchors.leftMargin: 3
            anchors.verticalCenter: volumeImgResion.verticalCenter
            height: 10
            width: 100
            maximumValue:1.0
            minimumValue: 0
            value: 0.7
            stepSize:0.02
            onValueChanged: {
                player.volume=value
                setSource();
                if(player.muted){
                    player.muted=false;
                }
            }

            style: SliderStyle {
                groove: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 2
                    color: "white"
                    radius: 1
                }
                handle: Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color:"white"

                }
            }



            function setSource(){
                if(value>0.8){
                    volumeImg.source="qrc:/image/image/volume-high-icon.png";
                }
                else if(value>0.45){
                    volumeImg.source="qrc:/image/image/volume-medium-icon.png";
                }
                else if(value>0){
                    volumeImg.source="qrc:/image/image/volume-low-icon.png"
                }
                else if(value===0){
                    volumeImg.source="qrc:/image/image/volume-mute-icon.png";
                }
            }



        }

        Connections{
            target: player
            onMutedChanged:{
                if(player.muted){
                    volumeImg.source="qrc:/image/image/volume-mute-icon.png";
                }
                else{
                   volumeSlider.value=player.volume;
                    volumeSlider.setSource();
                }
            }
        }



    }

    //播放按钮
    Rectangle{
        id:playBtn
        x:80
        anchors.top: volumeControler.bottom
        anchors.topMargin: 10
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

    //标题
    Text{
        id: title
        color:"#71addb"
        anchors.bottom: slider.top
        anchors.bottomMargin: 3
        anchors.left: volumeControler.left
        anchors.leftMargin: -10
        text:jsonObj.title
        font.family: "微软雅黑"
        verticalAlignment: Text.AlignVCenter
        styleColor: "#d1cbcb"
        font.pointSize: 10
    }


    Rectangle{
        id:playMode
        width: 80
        height: 24
        radius: 3
        anchors.right: slider.right
        anchors.bottom: slider.top
        anchors.rightMargin: 5
        anchors.bottomMargin:  5
        color: "grey"
        //是否随机播放
        property bool random: false
        states:[State{
            name:"sequenceState"
            PropertyChanges {
                target: handleBtn
                anchors.leftMargin: 0

            }
            },
            State{
            name:"randomState"
            PropertyChanges{
                target:handleBtn
                anchors.leftMargin: 40

            }
            }]

        Image {
            id:sequenceImg
            width: 40
            height: 24
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            source: "qrc:/image/image/sequence.png"
        }


        Image{
            id:randomBtnImg
            width: 40
            height: 24
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            source: "qrc:/image/image/random.png"
        }


        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(playMode.random){
                    playMode.state="sequenceState";
                    playlist.setPlayMode(Playlist.Sequence)
                }
                else{
                    playlist.setPlayMode(Playlist.Random)
                    playMode.state="randomState";
                }
                playMode.random=!playMode.random
            }
        }

        Rectangle{
            id:handleBtn
            width: 40
            height: 24
            radius: 3
            anchors.left: parent.left
            anchors.leftMargin: 0
            GradientStop {
                position: 0.00;
                color: "#ffffff";
            }
            GradientStop {
                position: 1.00;
                color: "#ececec";
            }
        }


    }

    //进度条
    Slider {
        id:slider
        x:15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
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
        anchors.topMargin: 3
        color:"#828282"
        text:"00:00"
    }

    //总时间
    Text{
        id:musicLength_txt
        anchors.right: slider.right
        anchors.top: slider.bottom
        anchors.topMargin: 3
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
