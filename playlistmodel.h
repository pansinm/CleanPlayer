#ifndef PLAYLISTMODEL_H
#define PLAYLISTMODEL_H

#include <QAbstractListModel>
#include<QString>
#include<QList>

class MusicInfo{
public:
    MusicInfo(const QString &url);
    QString url(){return m_url;}
    QString name(){return m_name;}
    QString artist(){return m_artist;}
    QString cover(){return m_cover;}
    QString lyric(){return m_lyric;}
    void setUrl(const QString url){m_url=url;}
    void setName(const QString name){m_name=name;}
    void setArist(const QString artist){m_artist=artist;}
    void setCover(const QString cover){m_cover=cover;}
    void setLyric(const QString lyric){m_lyric=lyric;}
private:
    QString m_url;
    QString m_name;
    QString m_artist;
    QString m_cover;
    QString m_lyric;
};

class PlaylistModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum MusicInfoRole{UrlRole=Qt::UserRole+1,
        NameRole,
        ArtistRole,
        CoverRole,
        LyricRole};
    void addMusicInfo(MusicInfo* musicInfo);
    void insertMusicInfo(MusicInfo* musicInfo,int row);
    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    explicit PlaylistModel(QObject *parent = 0);
    bool setData(const QModelIndex & index, const QVariant & value, int role = UrlRole);
    QModelIndex index(int row, int column=0, const QModelIndex & parent = QModelIndex()) const;

signals:

public slots:
private:
    QList<MusicInfo*> musicInfos;
protected:
    QHash<int, QByteArray> roleNames() const;
};
#endif // PLAYLISTMODEL_H
