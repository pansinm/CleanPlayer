#include "songinfo.h"

SongInfo::SongInfo(QObject *parent,QString uuid) : QObject(parent)
{
    uuid_ = uuid;
    init();
}

void SongInfo::init(){
    songId_ = "";
    songName_ = "";
    singer_ = "";
    albumName_ = "";
    albumPicLink_ = "";
    albumPicPath_ = "";
    songLink_ = "";
    localSongPath_ = "";
    lyricLink_ = "";
    localLyricPath_ = "";
    size_ = 0;
    time_ = 0;
}

QString SongInfo::songId() const{
    return songId_;
}
void SongInfo::setSongId(const QString &songId){
    if(songId_ != songId){
        songId_ = songId;
        emit songIdChanged();
    }
}

SongInfo::~SongInfo()
{

}

