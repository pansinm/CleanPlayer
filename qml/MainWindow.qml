import QtQuick 2.2
import QtQuick.Controls 1.1
import MyComponents 1.0
import QtMultimedia 5.0
import QtQuick.Dialogs 1.1


Rectangle {
    id:root
    width: 640
    height: 480
    radius: 3
    //color:"#1d555a"
    //存储当前歌曲信息
    property var jsonObj : new Object
    property color bkgColor: "#20ffffff"
    property color fontColor:"#7bb9e8"

    /*/color:"#00000000"
    gradient: Gradient {
        GradientStop {
            position: 0.00;
            color: "#b4f1d5";
        }
        GradientStop {
            position: 0.47;
            color: "#82c4f7";
        }
        GradientStop {
            position: 1.00;
            color: "#d3f380";
        }
    }
    */


    //渐变背景



    Image{
        id:bakgroundImg
        clip: true
        anchors.fill: parent
        source: "qrc:/image/image/bkgdae.png"
    }



   //拖拽
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

    Playlist{
        id:playlist

        onCurrentItemChanged:{
            jsonObj=JSON.parse(playlist.at(playlist.currentMediaIndex()));
        }

        onCurrentMediaIndexChanged: {
            //如果列表没有项目
            if(currentMediaIndex()<0){
                jsonObj={"url":"","title":"","artist":"未知歌手","lyric":"","cover":""}
                player.source=jsonObj.url;
                player.stop();
            }
            else{
                console.log("currentChanged")
                jsonObj=JSON.parse(playlist.at(playlist.currentMediaIndex()));
                player.source=jsonObj.url;

                network.clearDownload();

                if(!isCoverValid(jsonObj.cover)){
                    network.getPic(JSON.stringify(jsonObj));
                }
                //如果原歌词无效，则重新下载
                if(!isLyricValid(jsonObj.lyric)){
                    network.getLyric(JSON.stringify(jsonObj));
                    lyricView.netStateImgVisible=true
                }
            }

        }

    }

    Network{
        id:network

        onSucceeded: {
            console.log("Network::secceeded:json:"+json);
            playlist.sync(json);
        }
    }

    MediaPlayer{
        id:player
        source: jsonObj.url
        volume: 0.7
        onStatusChanged: {
            if(status===MediaPlayer.EndOfMedia){
                 playlist.next();
                 play();
            }
        }
        onError: {
            playlist.remove(playlist.currentMediaIndex());
            if(playlist.currentMediaIndex()>=0){
                play();
            }
            else{
                stop();
            }
        }
    }


    FileDialog {
        id: fileDialog
        selectMultiple:true
        title: "选择音乐"
        nameFilters: [ "音乐文件 (*.mp3 *.wma)", "所有文件 (*)" ]
        onAccepted:{
            var arrUrls=new Array
            arrUrls=fileUrls

            //判断url是否重复，如果不重复，则添加至musiclist中
            for(var i=0;i<arrUrls.length;i++){
                playlist.append(arrUrls[i])
                console.log(arrUrls[i])
            }

            if(playlist.currentMediaIndex()<0&&playlist.count()>0){
                playlist.setCurrentMediaIndex(0);
                console.log("setCurrentIndex:")<<playlist.currentMediaIndex();
            }
        }
    }

    LyricView{
        id:lyricView
        anchors.top:listShowHideBtn.top
        anchors.topMargin: 35
        anchors.left: displayRegion.right
    }

    //顶栏
    TopBar{
        id:topBar
    }


    //隐藏展开playlistview
    Rectangle{
        id:listShowHideBtn
        width: 18
        height: 350
        radius: 2
        anchors.top: topBar.bottom
        anchors.topMargin: 8
        anchors.right: parent.right
        property bool isHide: false
        color:"#00000000"
        Image{
            id:listShowHideImg
            anchors.centerIn: parent
            source: parent.isHide?"qrc:/image/image/left.png" : "qrc:/image/image/right.png"
            visible: false
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                parent.color=bkgColor
                listShowHideImg.visible=true;
            }
            onExited: {
                parent.color="#00000000"
                listShowHideImg.visible=false;
            }

            onClicked: {
                parent.isHide?expandList.start():scrollList.start();
                parent.isHide=!parent.isHide;
            }
        }
    }

    PlaylistView{
        id:playlistRegion
        anchors.right: listShowHideBtn.left
        anchors.rightMargin: 2
        anchors.top: listShowHideBtn.top
        //anchors.topMargin: 5
    }



    PlayerControler{
        id:playerControler
    }
    DisplayRegion{
        id:displayRegion
    }

    //列表收缩展开动画
    ParallelAnimation{
        id: scrollList
        running: false
        NumberAnimation { target: playlistRegion; property: "width"; to: 0 ; duration: 200}
        //PropertyAnimation { target: playlistRegion; property: "visible"; to: false ; duration: 50}
         NumberAnimation { target: lyricView; property: "width"; to: 380; duration: 200}
         PropertyAnimation { target: lyricView; property: "lineSpace"; to: 20 ; duration: 50}
         PropertyAnimation { target: lyricView; property: "fontSize"; to: 9 ; duration: 50}
    }


    ParallelAnimation{
        id: expandList
        running: false
        NumberAnimation { target: lyricView; property: "width"; to: 220; duration: 200}
        PropertyAnimation { target: lyricView; property: "lineSpace"; to: 25 ; duration: 50}
        PropertyAnimation { target: lyricView; property: "fontSize"; to: 8 ; duration: 50}
        NumberAnimation { target: playlistRegion; property: "width"; to: 180 ; duration: 200}

    }
   Component.onCompleted:{
       playlist.load("playlist.xml")
       //player.stop();
       console.log("completed")
   }
}
