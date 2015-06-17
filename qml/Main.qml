import QtQuick 2.4
import QtQuick.Controls 1.2
import QtMultimedia 5.4
import "./resource"
import CleanPlayerCore 1.0

Rectangle {
    width:1000
    height: 600
    color: "#333333"

    MediaPlayer {
         id: mediaplayer
     }

    BaiduMusic {
        id: baiduMusic

        onSearchComplete: showSearchResult(currentPage,pageCount,keyword,songList)
        onGetSuggestionComplete: showSug(suggestion)
        onGetSongLinkComplete:playMusic(songLink)

        //播放音乐
        function playMusic(songlink){
            console.log(songlink);
            var link = JSON.parse(songlink);
            var mp3link = link.data.songList[0].songLink
            mediaplayer.source = mp3link;
            mediaplayer.play();
        }


        //处理搜索建议
        function showSug(sug){
            try{
                var suggestion = JSON.parse(sug);
                var data = suggestion.data
                var songs = data.song
                suggestionModel.clear();

                for(var i in songs){

                    suggestionModel.append(songs[i]);
                     console.log(JSON.stringify(suggestionModel.get(i)));
                }
                suggestionTips.visible = true

            } catch(e){
                console.log(e);
            }

        }

        //显示搜索结果
        function showSearchResult(cur,count,keyword,songlist){
            searchResult.showResult(cur,count,keyword,songlist)
        }
    }

    //底部栏
    Rectangle {
        id:bottomBar
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: parent.width
        height: 80
        color: "#444444"

        //播放、上一首、下一首
        Rectangle {
            width: 180
            height: parent.height
            color: "#00000000"
            anchors.leftMargin: 20
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            PreviousButton {
                id:previousButton
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                onPrevious: {
                    //上一首
                }
            }
            PlayButton {
                id:playButton
                anchors.centerIn:parent
                onPause: {
                    //暂停
                }
                onPlay: {
                    //播放
                }
            }
            NextButton {
                id:nextButton
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                onNext: {
                    //下一首
                }
            }
        }

    }


    //顶部栏
    Rectangle {
        id:topBar
        width: parent.width
        height: 60
        color: "#444444"
        anchors.left: parent.left
        anchors.top: parent.top

        //左上角
        Rectangle {
            id: brand
            width: 200
            height: parent.height
            anchors.top: parent.top
            anchors.left: parent.left
            Text {
                id: brandText
                font.pixelSize:28
                text: qsTr("CleanPlayer")
                anchors.centerIn: parent
            }
        }

        //搜索条
        SearchBar {
            anchors.left: brand.right
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter

            onTextCleared: {
                suggestionTips.visible = false;
            }
            onKeywordChanged: baiduMusic.getSuggestion(keyword)
            onBeforeSearch: {
                baiduMusic.search(keyword,1);
                suggestionTips.visible = false;
            }
            onTextFocusOut: {
                suggestionTips.visible = false;
            }
        }


        //边条
        Rectangle {
            width: parent.width
            height: 2
            color: "#E61E16"
            anchors.bottom: parent.bottom
        }
    }

    //左侧栏
    LeftList {
        id: leftList
        anchors.left: parent.left
        anchors.top: topBar.bottom
        anchors.bottom: bottomBar.top
    }

    //内容区域
    Rectangle {
        id:container
        anchors.top: topBar.bottom
        anchors.left: leftList.right
        anchors.bottom: bottomBar.top
        anchors.right: parent.right
        SearchResult {
            id:searchResult
            anchors.fill: parent
            onItemDoubleClicked: {
                baiduMusic.getSongLink(sid);
            }
        }

    }

    //搜索建议弹出框
    Rectangle {
        id: suggestionTips
        anchors.top: topBar.bottom
        anchors.topMargin: -5
        anchors.left: topBar.left
        anchors.leftMargin: 220
        z:300
        height: 400
        width: 200
        color: "white"
        visible: false

        ListModel {
            id: suggestionModel
        }

        Component {
            id: highlightBar
            Rectangle {
                width: 200; height: 50
                color: "#FFFF88"
                y: suggestionView.currentItem.y;
            }

        }

        Component  {
            id: suggestionDelegate
            Item {
                id: wrapper
                width:200
                height: 20
                Rectangle{
                    Text {
                        text: songname + '-' + artistname
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        wrapper.ListView.view.currentIndex = index;
                        baiduMusic.getSongLink(suggestionModel.get(index).songid);
                        suggestionTips.visible = false;
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
            highlight: highlightBar
        }
    }

    MouseArea{
        anchors.fill: parent
        z:-1
        onClicked: {
            suggestionTips.visible = false;
        }
    }
}

