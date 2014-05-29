#ifndef DOWNLOAD_H
#define DOWNLOAD_H

#include <QObject>
#include<QDomElement>
#include<QDebug>
#include<QNetworkAccessManager>
#include<QNetworkReply>
#include<QFile>

//下载类型，歌曲，歌词，图片
enum DownloadType{SONG,LYRIC,PIC};

//数据请求阶段
//第一阶段：获取歌曲ID
//第二阶段：获取下载链接
//最后阶段：下载
enum RequestPhase{FIRSTPHASE,SECONDPHASE,LASTPHASE};


class Download : public QObject
{
    Q_OBJECT
public:
    explicit Download(QObject *parent = 0);
    void setKeywords(QString song,QString singer,DownloadType fileType);
    void start();
    void start(QString song,QString singer,DownloadType fileType);
    void cancel();
    void setPath(QString path);
    QString getArtist();
signals:
    //下载成功，发射该型号，QString为文件路径
    void downloadSucceeded(QString);
    //停止下载，下载超时或错误时发射
    void downloadStopped();
public slots:
private slots:
    void replyFinished();
    void replyReadyRead();
    //下一个请求
    void requestNext();

private:
    QNetworkAccessManager manager;
    QNetworkReply* reply;

    QString songStr;
    QString singerStr;
    DownloadType downloadType;
    RequestPhase requestPhase;
    //请求链接
    QUrl requestUrl;
    bool isCanceled;
    QFile* file;
    int requestTimes;//同一阶段的请求次数；
    QString songSuffix;
    QString pathStr;
};

#endif // DOWNLOAD_H
