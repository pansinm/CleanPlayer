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

    //取消当前下载当前下载并清空栈
    Q_INVOKABLE void clearDownload();

signals:
    //成功后发射json数据
    void succeeded(QVariant json);
    //全部下载完成发射该信号
    void allDownloaded();
public slots:

private slots:
    void replyFinished();
    void replyReadied();

private:
    //是否中断下载
    bool isAbort;

    //开始下一个下载
    void startNext();

    //请求指定链接
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

    //已请求次数
    int requestTimes;

    //当前请求链接
    QUrl currentRequestUrl;

    //reply是否占用
    bool isNetRequestBusy;

    QNetworkAccessManager manager;

    //输出
    QFile output;

    //输入栈，保存json数据
    QStack<InputObj> stack;
};

#endif // NETWORK_H
