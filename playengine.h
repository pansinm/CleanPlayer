#ifndef PLAYENGINE_H
#define PLAYENGINE_H

#include <QObject>
#include<QMediaPlayer>
#include<QMediaPlaylist>
#include<QDomDocument>
#include"download.h"
#include"lyric.h"
#include"playlistmodel.h"
#include"lyric.h"

class PlayEngine : public QObject
{
    Q_OBJECT
    //Q_PROPERTY(Lyric lyric READ lyric WRITE setLyric NOTIFY lyricChanged)
public:
    explicit PlayEngine(QObject *parent = 0);
    PlaylistModel listModel;

signals:
    void musicChanged(QString nameStr,QString artistStr);
    void coverChanged(QUrl coverFile);
    void positionChanged(qint64 pos);
    void durationChanged(qint64 du);
    void lyricChanged(QString lyricFile);


public slots:
    void setLyric(QString lyric);
    void setPlayPosition(qint64 pos);
    void downloadFiles();
    void addMusic();
    void play();
    void play(int index);
    void pause();
    void playNext();
    void playPrevious();
    void setCover(QString cover);
private:

    QMediaPlayer player;
    QMediaPlaylist playlist;
    Lyric m_lyric;

};

#endif // PLAYENGINE_H
