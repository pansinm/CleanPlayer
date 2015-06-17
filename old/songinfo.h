#ifndef SONGINFO_H
#define SONGINFO_H

#include <QObject>

class SongInfo : public QObject
{
  Q_OBJECT
    Q_PROPERTY(QString songId READ songId WRITE setSongId NOTIFY songIdChanged)
    Q_PROPERTY(QString songName READ songName WRITE setSongName NOTIFY songNameChanged)
    Q_PROPERTY(QString singer READ singer WRITE setSinger NOTIFY singerChanged)
    Q_PROPERTY(QString albumName READ albumName WRITE setAlbumName NOTIFY albumNameChanged)
    Q_PROPERTY(QString albumPicLink READ albumPicLink WRITE setAlbumPicLink NOTIFY albumPicLinkChanged)
    Q_PROPERTY(QString albumPicPath READ albumPicPath WRITE setAlbumPicPath NOTIFY albumPicPathChanged)
    Q_PROPERTY(QString songLink READ songLink WRITE setSongLink NOTIFY songLinkChanged)
    Q_PROPERTY(QString localSongPath READ localSongPath WRITE setLocalSongPath NOTIFY localSongPathChanged)
    Q_PROPERTY(QString localLyricPath READ localLyricPath WRITE setLocalLyricPath NOTIFY localLyricPathChanged)

    QString songId() const;
    void setSongId(const QString& songId);

    QString songName() const;
    void setSongName(const QString& songName);

    QString singer() const;
    void setSinger(const QString& singer);

    QString albumName() const;
    void setAlbumName(const QString& albumName);

    QString albumPicLink() const;
    void setAlbumPicLink(const QString& albumPicLink);

    QString albumPicPath() const;
    void setAlbumPicPath(const QString& albumPicPath);

    QString songLink() const;
    QString setSongLink(const QString& songLink);

    QString localSongPath() const;
    void setLocalSongPath(const QString& localSongPath);

    QString lyricLink() const;
    void setLyricLink(const QString& lyricLink);

    QString localLyricPath(const QString& localLyricPath);

    QString size() const;
    void setSize(const QString& size);

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
    void albumPicLinkChanged();
    void albumPicPathChanged();
    void songLinkChanged();
    void localSongPathChanged();
    void lyricLinkChanged();
    void localLyricPathChanged();

public slots:

private:
    QString uuid_;
    QString songId_;
    QString songName_;
    QString singer_;
    QString albumName_;
    QString albumPicLink_;
    QString albumPicPath_;
    QString songLink_;
    QString localSongPath_;
    QString lyricLink_;
    QString localLyricPath_;
    int size_;
    int time_;
    void init();
};

#endif // SONGINFO_H
