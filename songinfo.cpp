#include "songinfo.h"

SongInfo::SongInfo(QObject *parent,QString uuid_) : QObject(parent)
{
    uuid = uuid_;
    init();
}

void SongInfo::init(){
    songId = "";
    songName = "";
    singer = "";
    albumName = "";
    albumPicLink = "";
    albumPicPath = "";
    songLink = "";
    localSongPath = "";
    lyricLink = "";
    localLyricPath = "";
    size = 0;
    time = 0;
}

QString SongInfo::songId() const{
    return songId;
}
void SongInfo::setSongId(const QString &songId_){
    if(songId_ != songId){
        songId = songId_;
        emit songIdChanged();
    }
}

SongInfo::~SongInfo()
{

}

