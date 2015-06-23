.pragma library
.import QtQuick.LocalStorage 2.0 as Sql

/*
  song {
    id:数据库id，
    sid:baidusongid
    sname:歌曲名称
    singer:歌手
    album:专辑
    localPath:本地路径
  }

  //歌单
  category {
    id:歌单id
    name:歌单名称
    add_time:创建时间
    isReady:是否为当前歌单
  }

  */

//当前列表
var currentCategory = "默认列表";

//初始化
function init(){
    var db = Sql.LocalStorage.openDatabaseSync(
        "playlist",
        "1.0",
        "播放列表",
        1000000
    );
    db.transaction(
        function(tx) {
            //如果数据库未创建则创建数据库
            //歌曲
            tx.executeSql('CREATE TABLE IF NOT EXISTS t_song(id INTEGER PRIMARY KEY AUTOINCREMENT, \
                            sid TEXT, sname TEXT, singer TEXT, album TEXT, localPath TEXT)');
            //列表
            tx.executeSql('CREATE TABLE IF NOT EXISTS t_category(id INTEGER PRIMARY KEY AUTOINCREMENT, \
                            name TEXT UNIQUE, add_time DATETIME, isReady SMALLINT)');
            //多对多
            tx.executeSql('CREATE TABLE IF NOT EXISTS t_song_category(id INTEGER PRIMARY KEY AUTOINCREMENT, \
                            song_id INTEGER, category_id INTEGER,isCurrent TINYINT)');
            //插入默认列表
            tx.executeSql('INSERT OR REPLACE INTO t_category(id,name, add_time, isReady) \
                            VALUES(1,"默认列表",datetime("now","local"),1)');

            //选择默认列表
            var results =   tx.executeSql('SELECT name FROM t_category WHERE isReady=1');
            currentCategory = results.rows.item(0).name;
        }
    );
}

//添加song到列表
function addSong(song,categoryName){
    var db = Sql.LocalStorage.openDatabaseSync(
        "playlist",
        "1.0",
        "播放列表",
        1000000
    );
    var catname = categoryName ? categoryName : currentCategory;    //默认插入到当前列表
    //模板
    var songtmp = {
        sid:"",
        sname:"",
        singer:"",
        album:"",
        localPath:""
    }

    //将song的属性赋值给songtmp
    for(var i in song){
        songtmp[i] = song[i];
    }

    db.transaction(
        function(tx) {

           var sql = 'INSERT INTO t_song(sid,sname,singer,album,localPath) values(?,?,?,?,?)'

            //插入歌曲
            var rs = tx.executeSql(sql,[songtmp.sid,songtmp.sname,songtmp.singer,songtmp.album,songtmp.localPath]);
            var insertid = rs.insertId;
            tx.executeSql('INSERT INTO t_song_category(song_id,category_id) SELECT ' + insertid +
                          ' ,id FROM t_category WHERE name="'  + categoryName + '"');

        }
    );
}

function isCurrentSong(sid,func){
    var db = Sql.LocalStorage.openDatabaseSync(
        "playlist",
        "1.0",
        "播放列表",
        1000000
    );

    db.transaction(
        function(tx) {
            //插入歌曲
            var rs = tx.executeSql("SELECT * FROM t_song_category");

        }
    );
}

function getAllPlaylist(eachFunc){
    var db = Sql.LocalStorage.openDatabaseSync(
        "playlist",
        "1.0",
        "播放列表",
        1000000
    );

    db.transaction(
        function(tx) {
            //插入歌曲
            var rs = tx.executeSql("SELECT * FROM t_category");

            for(var i=0;i<rs.rows.length;i++){
                eachFunc(rs.rows.item(i));
            }
        }
    );
}


