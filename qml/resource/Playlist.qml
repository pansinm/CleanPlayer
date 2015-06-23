import QtQuick 2.4
import QtMultimedia 5.4
import CleanPlayerCore 1.0

Item {
    property int index: 0
    property var playlists: {"默认列表":[]}  //播放列表，默认加载【默认列表】
    property string currentPlaylist: "默认列表"
    property MediaPlayer mediaPlayer
    property BaiduMusic baiduMusic

    function songCount(){
        return items.count
    }

    function currentIndex(){
        return index;
    }

    function addSong(song){
        items.append(song);
    }

    function insertSong(pos,song){
        items.insert(pos,song);
    }

    function move(from,to){
        items.move(from,to,1);
    }

    function setIndex(i){
        index = i;
    }
}

