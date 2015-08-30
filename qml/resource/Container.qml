import QtQuick 2.4
import CleanPlayerCore 1.0

//内容区域
Rectangle {
    id:containerRoot
    property BaiduMusic baiduMusic
    property Playlist playlist
    property Lyric lyric



    //播放列表
    SearchResult {
        id:searchResult
        anchors.fill: parent
        visible: false
        baiduMusic: parent.baiduMusic
        playlist: parent.playlist
    }
    //播放列表
    PlaylistView{
        id:playlistView

        anchors.fill: parent

        visible: true
        playlist: parent.playlist
    }


    //显示搜索结果
    function showSearchResult(){
        searchResult.visible = true;
        playlistView.visible = false;
        lyric.visible = false;
    }

    //显示播放列表
    function showPlaylist(){
        searchResult.visible = false;
        playlistView.visible = true;
        lyric.visible = false;
    }

    //更新播放列表
    function updatePlaylist(listname){
        playlistView.update(listname);
    }

    Connections{
        target: baiduMusic
        onSearchComplete: {
            try{
                var songlist = JSON.parse(songList);
                //如果错误
                if(songlist.error){
                    //TODO:搜索出错
                }
            }catch(e){
                console.log(e);
                return;
            }
            searchResult.setResultInfo(currentPage,pageCount,keyword,songlist);
            showSearchResult();
        }
    }
}

