#ifndef MUSICINFO_H
#define MUSICINFO_H

#include <QObject>
#include<QUrl>

class MusicInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString artist READ artist WRITE setArtist NOTIFY artistChanged)
    Q_PROPERTY(QUrl cover READ cover WRITE setCover NOTIFY coverChanged)
    Q_PROPERTY(QUrl lyric READ lyric WRITE setLyric NOTIFY lyricChanged)
public:
    MusicInfo(QObject *parent = 0);
    MusicInfo(const MusicInfo& info,QObject* parent=0);

    MusicInfo(const QUrl& url,
              const QString& title=QString(),
              const QString& artist=QString(),
              const QUrl& cover=QUrl(),
              const QUrl& lyric=QUrl(),
              QObject* parent=0);

    QUrl url() const{
        QUrl x=m_url;
        return x;
    }

    QString title() const{
        return m_title;
    }

    QString artist() const{
        return m_artist;
    }

    QUrl cover() const{
        return m_cover;
    }

    QUrl lyric() const{
        return m_lyric;
    }

    void setUrl(QUrl url){
        m_url=url;
        emit urlChanged();
    }

    void setTitle(QString title){
        m_title=title;
        emit titleChanged();
    }

    void setArtist(QString artist){
        m_artist=artist;
        emit artistChanged();
    }

    void setCover(QUrl cover){
        m_cover=cover;
        emit coverChanged();
    }

    void setLyric(QUrl lyric){
        m_lyric=lyric;
        emit lyricChanged();
    }

    MusicInfo& operator =(const MusicInfo& info);

signals:
    void urlChanged();
    void titleChanged();
    void artistChanged();
    void coverChanged();
    void lyricChanged();
public slots:

private:
    QUrl m_url;
    QString m_title;
    QString m_artist;
    QUrl m_cover;
    QUrl m_lyric;

};

#endif // MUSICINFO_H
