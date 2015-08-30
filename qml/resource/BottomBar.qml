import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtMultimedia 5.4

import CleanPlayerCore 1.0

Rectangle {
    height: 60
    color: "#444444"

    property bool isPlaying: false
    property MediaPlayer mediaPlayer
    property Playlist playlist
    property BaiduMusic baiduMusic
    property bool lyricHidden:true

    Rectangle{
        id: songPicWrapper
        width: parent.height - 10
        height: parent.height - 10

        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5

        Image{
            id:songPic
            anchors.fill: parent
        }
        MouseArea{
            anchors.fill: parent
            onClicked:{
                lyricHidden=!lyricHidden;
            }
        }
    }

    //播放、上一首、下一首
    Rectangle {
        id: playController
        width: 150
        height: parent.height
        color: "#00000000"
        anchors.leftMargin: 20
        anchors.left: songPicWrapper.right
        anchors.bottom: parent.bottom

        Rectangle {
            id:previousButton
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: 40
            radius: 20
            color: "#00000000"
            Image {
                source:  "qrc:/image/image/previous.png"
                width: 50
                height: 50
                anchors.centerIn: parent
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color= "#33ffffff"
                onExited: parent.color="#00000000"
                onClicked: {
                    playlist.previous();
                }
            }
        }

        Rectangle {
            id:playButton
            anchors.centerIn:parent
            width:  44
            height: 44
            radius: 22
            color: "#00000000"

            Image {
                source: isPlaying ? "qrc:/image/image/pause.png" : "qrc:/image/image/play.png"
                width:  56
                height: 56
                anchors.centerIn: parent
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color= "#33ffffff"
                onExited: parent.color="#00000000"

                onClicked: {
                    isPlaying = !isPlaying;
                    if(isPlaying){
                        playlist.play();
                    } else {
                        playlist.pause();
                    }
                }
            }
        }
        Rectangle {
            id:nextButton
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: 40
            radius: 20
            color: "#00000000"

            Image {
                source:  "qrc:/image/image/next.png"
                width: 50
                height: 50
                anchors.centerIn: parent
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color= "#33ffffff"
                onExited: parent.color="#00000000"
                onClicked: {
                    playlist.next();
                }

            }
        }
    }

    Rectangle{
        id:currentSongInfo
        height: 45
        width: 120
        color: "#00000000"
        clip: true
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: playController.right
        anchors.leftMargin: 15

        Text{
            id: sname
            height: 15
            color: "white"
            anchors.left: parent.left
            anchors.top: parent.top
            text: ""
        }
        Text {
            id: singer
            height: 15
            color: "white"
            anchors.left: parent.left
            anchors.top: sname.bottom
            text:"歌手:"
        }
        Text {
            id: album
            height: 15
            color: "white"
            anchors.left: parent.left
            anchors.top: singer.bottom
            text:"专辑:"
        }

        function setSongName(name){
            sname.text = name;
        }

        function setSinger(singername){
            singer.text = "歌手:" + singername;
        }

        function setAlbum(albumname){
            album.text = "专辑:" + albumname;
        }

        //清空信息
        function clear(){
            sname.text = "";
            singer.text = "歌手:";
            album.text = "专辑:";
        }

    }

    Rectangle{
        anchors.left: currentSongInfo.right
        anchors.leftMargin: 15
        anchors.right: volumeControler.left
        anchors.rightMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        Text{
            id:currentTime
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            color:"white"
            text:"00:00"
        }

        Text{
            id:totalTime
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            color:"white"
            text:"00:00"
        }

        //进度条
        Slider {
            id:slider
            anchors.left: currentTime.right
            anchors.leftMargin: 5
            anchors.right: totalTime.left
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            maximumValue:0
            value: 0
            stepSize:0.5
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
            onValueChanged: {
                currentTime.text = formatTime(value);
                totalTime.text = formatTime(maximumValue);
            }

            //释放鼠标的时候
            onPressedChanged: {
                if(!pressed){
                    mediaPlayer.seek(value);
                }
            }

            //格式化时间
            function formatTime(ms){
                //补0
                function pad(num, n) {
                    var len = num.toString().length;
                    while(len < n) {
                        num = "0" + num;
                        len++;
                    }
                    return num;
                }

                var min=Math.floor(ms/1000/60);
                var sec=Math.floor(ms/1000%60);
                return pad(min,2)+":"+pad(sec,2);
            }
        }

    }

    Rectangle{
       id:volumeControler
       height: 32
       width:140
       x:40
       anchors.right: parent.right
       anchors.verticalCenter: parent.verticalCenter
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
               width: 22
               height: 22
               anchors.centerIn: parent
               source: "qrc:/image/image/volume-medium-icon.png"
           }
           MouseArea{
               anchors.fill: parent
               hoverEnabled: true
               onEntered: parent.color= "#33ffffff"
               onExited: parent.color="#00000000"
               onClicked: {
                   mediaPlayer.muted = !mediaPlayer.muted
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
               mediaPlayer.volume = volumeSlider.value
               setVolumeIcon();
               if(mediaPlayer.muted){
                   mediaPlayer.muted=false;
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


            //设置音量图标
           function setVolumeIcon(){
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
   }

    //计时器，定时更新进度条
    Timer {
        interval: 500;
        running: true;
        repeat: true
        onTriggered: {
            //正在拖拽的时候不更新位置
            if(!slider.pressed){
                 slider.value = mediaPlayer.position;
            }
        }
    }

    Connections{
        target: mediaPlayer
        onStopped: {
            slider.maximumValue = 0;
            slider.value = 0;
            isPlaying = false;
        }

        onPaused:{
            isPlaying = false;
        }

        onPlaying:{
            slider.maximumValue = mediaPlayer.duration
            slider.value = mediaPlayer.position;
            isPlaying = true;
        }

        onDurationChanged:{
            slider.maximumValue = mediaPlayer.duration
        }

        onMutedChanged:{
            if(mediaPlayer.muted){
                volumeImg.source="qrc:/image/image/volume-mute-icon.png";
            }
            else{
               volumeSlider.value=mediaPlayer.volume;
               volumeSlider.setVolumeIcon();
            }
        }
    }

    Connections{
        target: baiduMusic
        onGetSongInfoComplete: {
            try{
                var songinfo = JSON.parse(songInfo);
                var  currentSong = songinfo.data.songList[0]
                var picLink = currentSong.songPicSmall;
                var queryId = currentSong.queryId;
                if(playlist.getSong(playlist.currentIndex()).sid == queryId){
                    //设置歌曲图片
                    songPic.source = picLink;
                    //设置专辑名称
                    currentSongInfo.setAlbum(currentSong.albumName);
                }
            }catch(e){
                console.log("BottomBar[onGetSongInfoComplete]:"+e);
            }
        }
    }

    Connections{
        target: playlist
        onIndexChanged: {
            currentSongInfo.clear();
            var song = playlist.getSong(playlist.index);
            currentSongInfo.setSongName(song.sname);
            currentSongInfo.setSinger(song.singer);
        }
    }
}
