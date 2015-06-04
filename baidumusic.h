#ifndef BAIDUMUSIC_H
#define BAIDUMUSIC_H

#include <QObject>

class BaiduMusic : public QObject
{
    Q_OBJECT
public:
    explicit BaiduMusic(QObject *parent = 0);
    ~BaiduMusic();

signals:

public slots:
};

#endif // BAIDUMUSIC_H
