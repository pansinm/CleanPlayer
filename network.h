/*传入json（QVariant）格式如
 * "{"url":"","title":"","artist":"","cover":"","lyric":""}"
 * url->歌曲路径，cover->图片路径，lyric->歌词路径
 * 下载，如果成功，则发送seccessed(QVariant)信号，将修改后的json数据随信号发射
 */
#ifndef NETWORK_H
#define NETWORK_H

#include <QObject>
#include<QString>
#include<QDebug>
#include<QNetworkAccessManager>
#include<QNetworkReply>
#include<QVariant>
#include<QStack>
#include<QUrl>
#include<QFile>
#include<QJsonObject>
#include<QNetworkReply>

class Network : public QObject
{
    Q_OBJECT
public:


    //下载的文件类型，歌曲，歌词，图片
    enum DownloadType{Song,Lyric,Pic};

    //请求阶段，信息，链接，下载
    enum Period{RequestInfo,RequestLink,Download};

    struct InputObj{
        QVariant jsonVar;
        DownloadType fileType;
    };

    explicit Network(QObject *parent = 0);
    Q_INVOKABLE void getLyric(const QVariant& json);
    Q_INVOKABLE void getSong(const QVariant& json);
    Q_INVOKABLE void getPic(const QVariant& json);

signals:
    void succeeded(QVariant json);
public slots:

private slots:
    void replyFinished();
    void replyReadied();

private:
    void startNext();
    void request(const QUrl& url);

    QNetworkReply* reply;

    DownloadType fileType;

    Period period;

    //储存song_id,singer等信息
    QJsonObject infoJson;

    //储存歌词及歌曲下载链接
    QJsonObject linkJson;

    //存储数据用于成功后发射;
    QJsonObject emitJson;

    int requestTimes;

    QUrl currentRequestUrl;

    bool isNetRequestBusy;

    QNetworkAccessManager manager;

    QFile output;

    QStack<InputObj> stack;
};

#endif // NETWORK_H
