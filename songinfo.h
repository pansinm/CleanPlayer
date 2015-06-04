#ifndef SONGINFO_H
#define SONGINFO_H

#include <QObject>

class SongInfo : public QObject
{
  Q_OBJECT
    Q_PROPERTY(QString songId READ songId WRITE setSongId NOTIFY songIdChanged)
    Q_PROPERTY(QString songName READ songName WRITE setSongName NOTIFY songNanmeChanged)
    Q_PROPERTY(QString singer READ singer WRITE setSinger NOTIFY singerChanged)
    Q_PROPERTY(QString albumName READ albumName WRITE setAlbumName NOTIFY albumNameChanged)
    Q_PROPERTY(QString albumPicLink READ albumPicLink WRITE setAlbumPicLink NOTIFY albumPicLinkChanged)
    Q_PROPERTY(QString albumPicPath READ albumPicPath WRITE setAlbumPicPath NOTIFY albumPicPathChanged)
    Q_PROPERTY(QString songLink READ songLink WRITE setSongLink NOTIFY songLinkChanged)
    Q_PROPERTY(QString localSongPath READ localSongPath WRITE setLocalSongPath NOTIFY localSongPathChanged)
    Q_PROPERTY(QString localLyricPath READ localLyricPath WRITE setLocalLyricPath NOTIFY localLyricPathChanged)

    QString songId() const;
    void setSongId(const QString& songId_);

    QString songName() const;
    void setSongName(const QString& songName_);

    QString singer() const;
    void setSinger(const QString& singer_);

    QString albumName() const;
    void setAlbumName(const QString& albumName_);

    QString albumPicLink() const;
    void setAlbumPicLink(const QString& albumPicLink_);

    QString albumPicPath() const;
    void setAlbumPicPath(const QString& albumPicPath_);

    QString songLink() const;
    QString setSongLink(const QString& songLink_);

    QString localSongPath() const;
    void setLocalSongPath(const QString& localSongPath_);

    QString lyricLink() const;
    void setLyricLink(const QString& lyricLink_);

    QString localLyricPath(const QString& localLyricPath_);

    QString size() const;
    void setSize(const QString& size_);

    int time() const;
    void setTime(int ms);

public:
    explicit SongInfo(QObject *parent = 0,QString uuid);
    ~SongInfo();

signals:
    void songIdChanged();
    void songNameChanged();
    void singerChanged();
    void albumNameChanged();
    void albumPicLinkChuanged();
    void albumPicPathChanged();
    void songLinkChanged();
    void localSongPathChanged();
    void lyricLinkChanged();
    void localLyricPathChanged();

public slots:

private:
    QString uuid;
    QString songId;
    QString songName;
    QString singer;
    QString albumName;
    QString albumPicLink;
    QString albumPicPath;
    QString songLink;
    QString localSongPath;
    QString lyricLink;
    QString localLyricPath;
    int size;
    int time;
    void init();
};

#endif // SONGINFO_H
