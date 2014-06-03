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

    //存储当前歌曲信息
    property var jsonObj : new Object

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
    gradient:Gradient{
       GradientStop { position: 0.0; color: "#FF3C3C3C"}
       GradientStop { position: 0.889; color: "#FF141414" }
       GradientStop { position: 1; color:  "#FF141414" }
    }

    Image{
        id:bakgroundImg
        anchors.fill: parent
        source: "qrc:/image/image/defaulBkg.png"
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
            console.log("jsonObj");
            jsonObj=JSON.parse(playlist.at(playlist.currentMediaIndex()));
            player.play();
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
        }
    }


    FileDialog {
        id: fileDialog
        selectMultiple:true
        title: "选择音乐"
        onAccepted:{
            var arrUrls=new Array
            arrUrls=fileUrls

            //判断url是否重复，如果不重复，则添加至musiclist中
            for(var i=0;i<arrUrls.length;i++){
                playlist.append(arrUrls[i])
            }
        }
    }

    LyricView{
        id:lyricView
        anchors.centerIn: parent
    }

    //顶栏
    TopBar{
        id:topBar
    }

    //放置添加等按钮
    PlaylistViewHeader{
        id:listViewTopBar
        anchors.top: topBar.bottom
        anchors.right: parent.right
        anchors.topMargin: 15
        anchors.rightMargin: 15
    }

    PlaylistView{
        id:playlistRegion
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.top: listViewTopBar.bottom
        //anchors.topMargin: 5
    }



    PlayerControler{
        id:playerControler
    }
    DisplayRegion{
        id:displayRegion
    }
    /*


    LyricView{
        id:lyricRegion
        x:220
        y:100
    }

    /*
    PlayerControler{
        id:playControler

    }
    */
   Component.onCompleted:{
       playlist.load("playlist.xml")
       player.stop();
       console.log("completed")
   }
}
