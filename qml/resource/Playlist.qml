import QtQuick 2.4
import QtMultimedia 5.4
import CleanPlayerCore 1.0

Item {
    property int index: -1
    property var playlists: {"默认列表":[]}  //播放列表，默认加载【默认列表】
    property string currentList: "默认列表"
    property MediaPlayer mediaPlayer
    property BaiduMusic baiduMusic
    property Util util
    property string currentSid
    //列表中的歌曲数目
    function count(list){
        var listname = list ? list : currentList;
        console.log("listname:"+listname);
        if(typeof playlists[listname] == 'undefined'){
            playlists[listname] = [];
        }
        return playlists[listname].length;
    }

    function getSong(i,list){
        var listname = list ? list : currentList;
        return playlists[listname][i];
    }

    //返回指定列表的歌曲
    function getSongList(list){
        var listname = list ? list : currentList;
        return playlists[listname];
    }

    //当前播放位置
    function currentIndex(){
        return index;
    }

    //添加歌曲到列表
    function addSong(song,list){
        var listname = list ? list : currentList;
        if(typeof playlists[listname] == 'undefined'){
            playlists[listname] = [];
        }
         playlists[listname].push(song);
    }

    //插入到指定位置
    function insertSong(pos,song,list){
        playlists[list].splice(pos,0,song);
    }

    //替换列表中的歌曲
    function replace(pos,song,list){
         playlists[list].splice(pos,1,song);
    }

    //播放指定位置歌曲
    function setIndex(i){
        console.log("setIndex:"+i + "  length:" + playlists[currentList].length);
        if(i<0 || i>(playlists[currentList].length - 1)){
            return;
        }

        mediaPlayer.pause();

        index = i;

        //如果是本地音乐，则直接播放
        if(playlists[currentList][index].localpath){
            mediaPlayer.source =  playlists[currentList][index].localpath;
            mediaPlayer.play();
            return;
        }
        var curSid = playlists[currentList][index].sid;
        currentSid = curSid;
        //如果不是本地音乐，则获取歌曲链接
        baiduMusic.getSongLink(curSid);
        //获取专辑图片
        baiduMusic.getSongInfo(curSid);
    }

    //下一首
    function next(){
        setIndex(index + 1);
    }

    //上一首
    function previous(){
        setIndex(index - 1);
    }

    //播放当前歌曲
    function play(){
        if(mediaPlayer.source==""){
            setIndex(index);
            return;
        }
        mediaPlayer.play();

    }

    //暂停播放
    function pause(){
        mediaPlayer.pause();
    }

    //从文件加载列表
    function loadFrom(filename){
        try{
            var savedList = JSON.parse(util.readFile(filename));
            for(var i in savedList){
                playlists[i] = savedList[i];
            }
            index = 0;
        }catch(e){
            console.log("Playlist[loadFrom]:"+e);
        }
    }

    //保存文件
    function saveTo(filename){
        util.saveFile(filename,JSON.stringify(playlist.playlists));
    }

    Connections{
        target: baiduMusic
        //歌曲播放地址获取完毕
        onGetSongLinkComplete:{
            try{
                var link = JSON.parse(songLink);
                //如果还是当前播放歌曲，则立即播放，否则不处理
                if(playlists[currentList][index].sid == link.data.songList[0].sid){
                    var mp3link = link.data.songList[0].songLink;
                    mediaPlayer.source = mp3link;
                    mediaPlayer.play();
                }
            }catch(e){
                console.log("getLink:"+e);
            }
        }
    }

    Connections{
        target: mediaPlayer
        onStopped: {
            if(mediaplayer.status == MediaPlayer.EndOfMedia){
                next();
            }
        }
    }

}

