import QtQuick 2.0
import CleanPlayerCore 1.0
import QtMultimedia 5.4

Rectangle {
    color: '#333'
    property Playlist playlist
    property BaiduMusic baiduMusic
    property MediaPlayer mediaPlayer
    property string currentLyricUrl
    property int fontSize: 8
    property int lineSpace: 20

    //顺序插入
    function insertLyric(time,content){
        var count = lyricModel.count;
        if(count==0){
            lyricModel.append({time:time,content:content});
            return;
        }
        if(time<lyricModel.get(0).time){
            lyricModel.insert(0,{time:time,content:content});
            return;
        }
        if(time>lyricModel.get(count-1).time){
            lyricModel.append({time:time,content:content});
            return;
        }

        for(var i=0;i<count;++i){
            if(lyricModel.get(i).time<time && time<lyricModel.get(i+1).time){
                lyricModel.insert(i+1,{time:time,content:content});
            }
        }
    }

    //给定时间显示的歌词
    function getLyricIndex(time){
         var count = lyricModel.count;
        if(count==0){
            return -1;
        }

        if(time<lyricModel.get(0).time){
            return 0;
        }

        for(var i=0;i<count;++i){
            if(lyricModel.get(i).time<=time && time<lyricModel.get(i+1).time){
                return i;
            }
        }
        return count-1;
    }


     ListModel{
         id:lyricModel
     }

     Component{
         id:lyricDelegate
         Rectangle{
             id:lyricLineRect
             height: lineSpace
             width: parent.parent.width
             color:"#00000000"
             Text{
                 id:lyricTxt
                 anchors.centerIn: parent
                 color:lyricLineRect.ListView.isCurrentItem ? "white":"#80ffffff"
                 text:content
                 font.family: "微软雅黑"
                 font.pointSize:lyricLineRect.ListView.isCurrentItem ? fontSize+2 : fontSize
             }
         }

     }
     //歌词显示列表
     ListView{
         id:lyricView
         anchors.fill: parent
         spacing:5
         model:lyricModel
         delegate: lyricDelegate
         clip: true
         onCurrentItemChanged: NumberAnimation {
                         target: lyricView;
                         property: "contentY";
                         to:lyricView.currentItem.y-65;
                         duration: 500;
                         easing.type: Easing.OutSine
                     }

     }



    Connections{
        target:mediaPlayer
        onPositionChanged:{
            //给0.1s补偿
            var i=getLyricIndex(mediaPlayer.position+100);
            if(i>=0){
                lyricView.currentIndex=i
            }
        }
    }

    Connections{
        target: baiduMusic
        //歌曲播放地址获取完毕
        onGetSongLinkComplete:{
            try{
                var link = JSON.parse(songLink);

                //如果还是当前播放歌曲，则立即播放，否则不处理
                if(playlist.currentSid == link.data.songList[0].sid){
                    if(link.data.songList[0].lrcLink === ''){
                        return;
                    }

                    var lrcLink = link.data.songList[0].lrcLink;

                    if (!/^http/.test(lrcLink)) {
                        lrcLink = 'http://play.baidu.com' + link.data.songList[0].lrcLink
                    }

                    currentLyricUrl = lrcLink;
                    baiduMusic.getLyric(lrcLink);
                }
            }catch(e){
                console.log("getLink:"+e);
            }
        }
        onGetLyricComplete:{
            if(currentLyricUrl==url){
                //解析歌词，允许单行多时间
                var lines = lyricContent.split('\n');
                lines.forEach(function(line,index){
                    var rex=/^((\[\d+:\d+\.\d+\])+)(.*)/;
                    var result = line.match(rex);
                    if(result){
                        var content = result[3];//歌词
                        var times = result[1].split(/\[|\]/);   //时间
                        times.forEach(function(str){
                            var re =/^(\d+):(\d+)\.(\d+)$/;;
                            var rs = str.match(re);

                            if(rs){
                                var min = parseInt(rs[1]);
                                var sec = parseInt(rs[2]);
                                var ms = parseInt(rs[3])*10; //点后面每单位代表10ms
                                var time = min*60*1000+sec*1000+ms;
                                insertLyric(time,content);
                            }
                        });

                    }
                });

            }
        }
    }
    Connections{
        target: playlist
        onIndexChanged:{
            lyricModel.clear();
        }
    }

}

