#ifndef NETWORK_H
#define NETWORK_H

#include <QObject>
#include<QDomElement>
#include<QDebug>
#include<QNetworkAccessManager>
#include<QNetworkReply>
#include<QFile>
enum RequestType{MP3,LYRIC,COVER};
class Network : public QObject
{
    Q_OBJECT
public:
    explicit Network(QObject *parent = 0);

    //根据歌曲名，歌手等信息搜索下载MP3,歌词，封面等，返回文件保存完整路径，如果未设定路径，则保存到当前目录。
    QString getFile(QString music,QString singer,RequestType fileType);
    void cancel();
    bool setPath(QString path);


signals:


public slots:


private slots:
        void songIdReplyFinished();
        void urlReplyFinished();
        void downloadFinished();
        void downlaodReadyRead();


private:

    QNetworkAccessManager manager;
    //下载url为downloadUrl,返回下载的文件路径
    void downLoad();
    QNetworkReply* downLoadReply;
    bool isDownloadReplyBusy;

    //返回下载链接
    void getUrl();
    QNetworkReply* urlReply ;
    //存储请求的文件类型
    RequestType requestType;
    bool isUrlReplyBusy;

    void getSongId();
    QNetworkReply* songIdReply ;
    bool isSongIdReplyBusy;

    QString m; //music
    QString s; //singer
    QString songId;
    QString downloadUrl; //歌曲，歌词，封面的下载链接；
    QString p; //path
    QString fn;//file name;完整路径




    //songId请求次数,默认最大50次
    int songIdRequestTimes;

    bool isCanceled;

    bool isUrlGotten;

    bool isDownloaded;

    bool isSongIdGotten;



    QFile* file;


};

#endif // NETWORK_H
