#ifndef CPLISTMODEL_H
#define CPLISTMODEL_H

#include <QAbstractListModel>
#include <QStringList>
class MusicInfo
{
public:
    MusicInfo(const QString &type, const QString &size);
//![0]

    QString type() const;
    QString size() const;

private:
    QString m_url;
    QString m_fileName;
    QString m_singer;

//![1]
};
class PlaylistModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum PlaylistRoles {
        UrlRole = Qt::UserRole + 1,
        FileNameRole,
        SingerRole
    };

    PlaylistModel(QObject *parent = 0);
//![1]

    void addMusciInfo(const MusicInfo &musicInfo);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

protected:
    QHash<int, QByteArray> roleNames() const;
private:
    QList<MusicInfo> m_musicInfos;

};

#endif // CPLISTMODEL_H
