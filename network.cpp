#include "network.h"
#include<QFile>
#include<QUrl>
#include<QNetworkRequest>
#include<QNetworkAccessManager>
#include<QJsonDocument>
#include<QJsonObject>
#include<QJsonValue>
#include<QJsonParseError>
#include<QJsonArray>
#include<QJsonValue>
#include<QFileInfo>
#include<QTime>
#include<QByteArray>
#include<QEventLoop>
Network::Network(QObject *parent) :
    QObject(parent)
{
    songIdRequestTimes=0;
    isSongIdReplyBusy=false;
    isSongIdGotten=false;
    isCanceled=false;
    isUrlReplyBusy=false;
    isDownloadReplyBusy=false;
    isUrlGotten=false;
    isDownloaded=false;
}

QString Network::getFile(QString music,QString singer,RequestType fileType){
    m=music;
    s=singer;
    requestType=fileType;
    isDownloaded=false;
    isUrlGotten=false;
    isSongIdGotten=false;
    getSongId();
    getUrl();
    downLoad();

    qDebug()<<"fn"<<fn;
    return fn;

}

void Network::downLoad(){
    qDebug()<<"downLoad()";
    if(isDownloadReplyBusy)
        return ;
    isDownloadReplyBusy=true;
    isDownloaded=false;
    file=new QFile;

    QString pathStr=p;

    qDebug()<<"//创建文件";
    if(requestType==MP3){
        file->setFileName(pathStr+m+QTime::currentTime().toString("zzz")+QString(".mp3"));
        if(!file->open(QIODevice::WriteOnly)){
            return;
        }
    }

    else if(requestType==LYRIC){
        int n=downloadUrl.lastIndexOf("/");
        QString s=downloadUrl;
        int size=s.length();
        QString fileName=s.right(size-n+1);
        file->setFileName(pathStr+m+fileName);
        if(!file->open(QIODevice::WriteOnly)){
            return;
        }
    }

    else if(requestType==COVER){
        int n=downloadUrl.lastIndexOf("/");
        QString s=downloadUrl;
        int size=s.length();
        QString fileName=s.right(size-n-1);
        qDebug()<<downloadUrl<<fileName;
        file->setFileName(fileName);
        file->open(QIODevice::WriteOnly);
        qDebug()<<"//COVER";
    }
    qDebug()<<"//下载";
    downLoadReply=manager.get(QNetworkRequest(QUrl(downloadUrl)));

    QEventLoop eventLoop;
    //connect(downLoadReply,SIGNAL(readyRead()),this,SLOT(downlaodReadyRead()));
    connect(downLoadReply, SIGNAL(finished()), &eventLoop, SLOT(quit()));
    eventLoop.exec();
    qDebug()<<"loop";
    downloadFinished();

}

void Network::downlaodReadyRead(){
    qDebug()<<"downloadReadyRead";
    file->write(downLoadReply->readAll());
}

void Network::downloadFinished(){
    qDebug()<<"dowloadFinished()";
    isDownloadReplyBusy=false;
    isDownloaded=true;
    file->write(downLoadReply->readAll());
    QString fileName=file->fileName();
    if(requestType==MP3){
        file->close();
        if(file->open(QIODevice::ReadOnly)){

            //如果文件首行为“<html>”,则说明xcode错误，重新获取链接并下载；
            QString s=file->readLine();
            if(s=="<html>"){
                qDebug()<<"xcode错误，重新下载";
                file->close();
                QFile::remove(fileName);
                delete file;
                file=0;
                delete downLoadReply;
                downLoadReply=0;
                downLoad();
                return;
            }
            file->close();
        }
        file->deleteLater();

    }
    qDebug()<<"下载完毕！";
    fn=fileName;
    downLoadReply->deleteLater();
}

void Network::getUrl(){
    qDebug()<<"下载完毕！";
    //reply是否被占用
    if(isUrlReplyBusy)
        return;
    isUrlReplyBusy=true;
    //API:http://ting.baidu.com/data/music/links?songIds=<song_id>
    QString url=QString("http://ting.baidu.com/data/music/links?songIds=")+songId;
    urlReply=manager.get(QNetworkRequest(QUrl(url)));

    QEventLoop eventLoop;
    connect(urlReply, SIGNAL(finished()), &eventLoop, SLOT(quit()));
    eventLoop.exec();
    urlReplyFinished();

}

void Network::urlReplyFinished(){
    qDebug()<<"urlReplyFinished()";
    isUrlReplyBusy=false;
    isUrlGotten=true;
    //取消响应；
    if(isCanceled){
        delete urlReply;
        urlReply=NULL;
        isCanceled=false;
        return;
    }

    QJsonParseError jsonError;
    qDebug()<<"//加载json数据";
    QByteArray byteArray=urlReply->readAll();
    QJsonDocument parseDoc=QJsonDocument::fromJson(byteArray,&jsonError);
    qDebug()<<"//加载json数据完毕";
    if(jsonError.error==QJsonParseError::NoError){
         qDebug()<<"json无错误";
        if(parseDoc.isObject()){
            qDebug()<<"json is object";
            QJsonObject obj=parseDoc.object();

            //获取数据
            QJsonObject data=obj.take("data").toObject();
            QJsonArray ar=data.take("songList").toArray();
            QJsonObject lstObj=ar.takeAt(0).toObject();

            //获取歌曲
            if(lstObj.contains("showLink")&&requestType==MP3){
                if(lstObj.contains("format")&&lstObj.take("format").toString()=="mp3"){
                    QString url=lstObj.take("showLink").toString();

                    url.replace("\\","");
                    downloadUrl=url;
                    urlReply->deleteLater();
                    urlReply=NULL;
                    return;
                }
            }
            //获取歌词
            else if(lstObj.contains("lrcLink")&&requestType==LYRIC){
                QString tag("http://ting.baidu.com");
                QString url=lstObj.take("lrcLink").toString();
                qDebug()<<"getUrl:"<<url;
                url.replace("\\","");   //删除斜杠
                downloadUrl=tag+url;
                urlReply->deleteLater();
                urlReply=NULL;
                return;
            }


            else if(lstObj.contains("songPicSmall")&&requestType==COVER){
                qDebug()<<"//获取封面";
                QString url=lstObj.take("songPicSmall").toString();
                url.replace("\\","");
                downloadUrl=url;
                delete urlReply;
                urlReply->deleteLater();
                return;
            }

        }
    }

    urlReply->deleteLater();

}

//设置路径
bool Network::setPath(QString path){
    QFileInfo info(path);
    if(info.isDir()){
        p=path;
        return true;
    }
    return false;
}

//获取song_id;
void Network::getSongId(){
    isSongIdGotten=false;
    //判断reply是否被占用
    if(isSongIdReplyBusy){
        return;
    }
    isSongIdReplyBusy=true;

    //API:http://mp3.baidu.com/dev/api/?tn=getinfo&ct=0&ie=utf-8&word=<word>&format=<format>
    QString url("http://mp3.baidu.com/dev/api/?tn=getinfo&ct=0&word=");
    QString keyword=m+QString("&ie=utf-8&format=json");
    url=url+keyword;
    qDebug()<<"getSongId() url:"<<url;
    songIdReply=manager.get(QNetworkRequest(QUrl(url)));

    QEventLoop eventLoop;
    connect(songIdReply, SIGNAL(finished()), &eventLoop, SLOT(quit()));
    eventLoop.exec();
    songIdReplyFinished();
    qDebug()<<"loop.quit()"<<url;

}

void Network::songIdReplyFinished(){
    qDebug()<<"songIdReplyFinished()";


    isSongIdReplyBusy=false;
    isSongIdGotten=true;

    //取消响应；
    if(isCanceled){
        delete songIdReply;
        songIdReply=NULL;
        songIdRequestTimes=0;
        isCanceled=false;
        return;
    }

    //该接口经常得不到数据，所以设定多请求几次；
    //如果请求次数大于50，则songIdRequestTimes设为0，并返回
    if(songIdRequestTimes>49){
        delete songIdReply;
        songIdReply=NULL;
        songIdRequestTimes=0;
        qDebug()<<"请求次数大于50";
        return;

    }

    qDebug()<<"begin Load Json";
    QJsonParseError jsonError;

    //加载json数据
    QJsonDocument parseDoc=QJsonDocument::fromJson(songIdReply->readAll(),&jsonError);
    if(jsonError.error==QJsonParseError::NoError){

        //如果json是数组，且请求getSongId次数大于50则判断数组是否为空，如果为空，则重新请求数据
        if(parseDoc.isArray()){
            QJsonArray array=parseDoc.array();
            int size=array.size();
            if(size<1){
                delete songIdReply;
                songIdReply=NULL;
                getSongId();
                //请求次数自加
                songIdRequestTimes++;
                return;
            }


            //匹配歌手,如果匹配成功则写入songId，否则默认第一项
            for(int i=0;i<size;i++){
                QJsonValue v=array.at(i);
                QJsonObject obj=v.toObject();
                if(obj.contains("singer")&&obj.contains("song_id")){
                    QJsonValue value=obj.take("singer").toString();

                    QString singer=value.toString();
                    qDebug()<<"singer:"<<singer;
                    if(singer==s&&singer!=""){
                        songId=QString(obj.take("song_id").toString());
                        //请求次数清零
                        songIdRequestTimes=0;
                        delete songIdReply;
                        songIdReply=0;
                        return;
                    }
                }
            }

            //默认第一项
            QJsonObject obj2=array.at(0).toObject();
            if(obj2.contains("song_id")){
                QJsonValue value2=obj2.take("song_id").toString();
                songId=QString(value2.toString());
                songIdRequestTimes=0;
                songIdReply->deleteLater();
                return;
            }
        }
    }
    songIdReply->deleteLater();

}


void Network::cancel(){
    isCanceled=true;
    songIdReply->abort();
    urlReply->abort();

}
