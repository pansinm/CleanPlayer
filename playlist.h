#ifndef PLAYLIST_H
#define PLAYLIST_H

#include <QObject>

class Playlist : public QObject
{
    Q_OBJECT
public:
    explicit Playlist(QObject *parent = 0);
    ~Playlist();

signals:

public slots:
};

#endif // PLAYLIST_H
