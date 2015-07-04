import QtQuick 2.4
import CleanPlayerCore 1.0
import "func.js" as Func

//搜索建议弹出框
Rectangle {
    color: "white"
    visible: false

    width: 240
    height: 200

    property Playlist playlist
    property BaiduMusic baiduMusic

    ListModel {
        id: suggestionModel
    }

    Component  {
        id: suggestionDelegate
        Item {
            id: wrapper
            width:200
            height: 20
            Rectangle{
                Text {
                    text: sname + '-' + singer
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    wrapper.ListView.view.currentIndex = index;
                    hide();
                    var song = suggestionModel.get(index);
                    playlist.addSong(Func.objClone(song));
                    var last = playlist.count() - 1;
                    playlist.setIndex(last);
                }
            }
        }
    }

    ListView {
        id:suggestionView
        height: parent.height
        width: parent.width
        model: suggestionModel
        delegate: suggestionDelegate
        clip: true
    }

    //显示搜索建议
    function show(){
        visible = true;
    }

    //隐藏搜索建议
    function hide(){
        visible = false;
    }

    //设置显示的歌曲
    function setDisplaySongs(songs){
        suggestionModel.clear();
        for(var i in songs){
            //转换为字符串
            songs[i].sid = "" + songs[i].sid;
            suggestionModel.append(songs[i]);
        }
    }

    Connections{
        target:baiduMusic
        onGetSuggestionComplete: {
            try{
                var sug = JSON.parse(suggestion);
                var data = sug.data
                var songs = data.song
                setDisplaySongs(songs);
                show();
            }catch(e){
                console.log("Suggestion[onGetSuggestionComplete]:"+e)
            }
        }
    }
}


