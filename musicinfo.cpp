#include "musicinfo.h"

MusicInfo::MusicInfo(QObject *parent) :
    QObject(parent)
{
    m_url=QUrl();
    m_title=QString();
    m_artist=QString();
    m_cover=QUrl();
    m_lyric=QUrl();
}
MusicInfo& MusicInfo::operator =(const MusicInfo& info){
    setUrl(info.url());
    setTitle(info.title());
    setArtist(info.artist());
    setCover(info.cover());
    setLyric(info.lyric());
    return *this;

}
MusicInfo::MusicInfo(const MusicInfo& info,QObject* parent):QObject(parent){
    setUrl(info.url());
    setTitle(info.title());
    setArtist(info.artist());
    setCover(info.cover());
    setLyric(info.lyric());
}

MusicInfo::MusicInfo(const QUrl &url,
                     const QString &title,
                     const QString &artist,
                     const QUrl &cover,
                     const QUrl &lyric,
                     QObject* parent):QObject(parent){
    setUrl(url);
    setTitle(title);
    setArtist(artist);
    setCover(cover);
    setLyric(lyric);
}
