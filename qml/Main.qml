import QtQuick 2.4
import QtMultimedia 5.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import "./resource"
import CleanPlayerCore 1.0

Rectangle {
    id:root
    width:1000
    height: 600
    color: "#333333"

    MediaPlayer {
         id: mediaplayer

     }

    //工具函数
    Util {
        id:util
    }

    //百度音乐Api
    BaiduMusic {
        id: baiduMusic
    }

    //播放列表
    Playlist{
        id:playlist
        mediaPlayer: mediaplayer
        baiduMusic: baiduMusic
        util:util
    }

    //顶栏
    TopBar{
        id:topBar

        anchors.left: parent.left
        anchors.right: parent.right

        baiduMusic: baiduMusic
        suggestion: suggestion
    }

    //底部栏
    BottomBar {
        id:bottomBar
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: parent.width
        color: "#444444"

        mediaPlayer: mediaplayer
        playlist: playlist
        baiduMusic: baiduMusic
        onLyricHiddenChanged: {
            lyricView.visible = !lyricHidden;
        }
    }

    //边栏
    SideBar{
        id:sideBar

        anchors.left: parent.left
        anchors.top: topBar.bottom
        anchors.bottom: bottomBar.top

        playlist: playlist
        container: container
    }

    //搜索建议
    Suggestion{
        id:suggestion

        anchors.left:sideBar.right
        anchors.leftMargin: 28
        anchors.top: topBar.bottom
        anchors.topMargin: -15

        z:100

        baiduMusic: baiduMusic
        playlist: playlist
    }

    //歌词
    Lyric{
        id:lyricView
        baiduMusic:baiduMusic
        playlist:playlist
        mediaPlayer:mediaplayer
        z:2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: sideBar.top
        anchors.bottom: bottomBar.top
        visible: false
    }

    //内容区域
    Container{
        id:container
        lyric:lyricView
        anchors.left:sideBar.right
        anchors.top: topBar.bottom
        anchors.bottom: bottomBar.top
        anchors.right: parent.right

        baiduMusic: baiduMusic
        playlist: playlist
    }



    MouseArea{
        anchors.fill: parent
        z:-1
        onClicked: {
            suggestion.hide();
        }
    }

   //关闭时
    Component.onDestruction: {
        //保存播放列表
        playlist.saveTo("playlist");
    }

    //加载结束
    Component.onCompleted: {
        //加载播放列表
        playlist.loadFrom("playlist");
        sideBar.update();

        //列表中第一首为默认播放歌曲
        if(playlist.count()>0){
            playlist.index = 0;
        }
    }
}

