#include "download.h"
#include<QUrl>
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
#include<QDir>
Download::Download(QObject *parent) :
    QObject(parent)
{
}

void Download::setKeywords(QString song, QString singer, DownloadType fileType){
    songStr=song;
    singerStr=singer;
    downloadType=fileType;
    isCanceled=false;
    requestTimes=0;
    //API:http://mp3.baidu.com/dev/api/?tn=getinfo&ct=0&ie=utf-8&word=<word>&format=<format>
    QString url("http://mp3.baidu.com/dev/api/?tn=getinfo&ct=0&word=");
    QString keyword=songStr+QString("&ie=utf-8&format=json");
    url=url+keyword;
    requestUrl=QUrl(url);
}

void Download::start(){
    if(requestUrl.isEmpty()){
        return;
    }
    requestPhase=FIRSTPHASE;
    requestNext();
}

void Download::start(QString song, QString singer, DownloadType fileType){
    setKeywords(song,singer,fileType);
    requestPhase=FIRSTPHASE;
    requestNext();
}
void Download::cancel(){
    isCanceled=true;
    reply->abort();
}
void Download::setPath(QString path){
    if(path.right(1)=="\\"||path.right(1)=="/"){
        pathStr=path.left(path.length()-1);
        qDebug()<<"Download::pathStr:"<<pathStr;
        return;
    }
    QDir dir;
    if(!dir.exists(path)){
        qDebug()<<"dir.mkpath:"<<dir.mkpath(path);
    }
    pathStr=path;

}

void Download::requestNext(){
    reply=manager.get(QNetworkRequest(requestUrl));
    if(requestPhase==LASTPHASE){
        file=new QFile;
        qDebug()<<"//创建文件";
        if(downloadType==SONG){
           QString fileName=pathStr+"/"+songStr+"."+songSuffix;
           QFileInfo info(fileName);
           int i=1;
            qDebug()<<songSuffix;
           //如果文件存在则不覆盖，文件名后加数字
            QString s=fileName.left(fileName.lastIndexOf("."));
           while(info.exists()){
               fileName=s+QString("%1").arg(i)+"."+songSuffix;
               info.setFile(fileName);
               i++;
           }
           //写入tmp文件;
           file->setFileName(fileName+".tmp");
           if(!file->open(QIODevice::WriteOnly)){
               file->deleteLater();
               return;
           }
        }

        else{
            QString s=requestUrl.toString();
            int n=s.lastIndexOf("/");
            int size=s.length();
            //文件名
            QString fileName=pathStr+"/"+s.right(size-n-1)+".tmp";
            qDebug()<<"fileName:"<<fileName;
            file->setFileName(fileName);
            if(!file->open(QIODevice::WriteOnly)){
                file->deleteLater();
                return;
            }
        }

        connect(reply,SIGNAL(readyRead()),this,SLOT(replyReadyRead()));
    }
    connect(reply,SIGNAL(finished()),this,SLOT(replyFinished()));

}

void Download::replyFinished(){
    //如果取消
    qDebug()<<"replyFinished():";
    if(isCanceled){
        qDebug()<<"请求取消!";
        reply->deleteLater();
        isCanceled=false;
        file->close();
        file->deleteLater();
        emit downloadStopped();
        return;
    }
    //如果大于50次，则终端请求数据
    if(requestTimes>49){
        qDebug()<<"请求次数超过50";
        requestTimes=0;
        reply->deleteLater();
        emit downloadStopped();
        return;
    }
    
    if(requestPhase==FIRSTPHASE)
    {
        qDebug()<<"FIRSTPHASE:获取song_id:";
        
        QJsonParseError jsonError;
    
        //加载json数据
        qDebug()<<"加载json:";
        QJsonDocument parseDoc=QJsonDocument::fromJson(reply->readAll(),&jsonError);
        if(jsonError.error==QJsonParseError::NoError){
            
            //如果json是数组，且请求getSongId次数大于50则判断数组是否为空，如果为空，则重新请求数据
            if(parseDoc.isArray()){
                QJsonArray array=parseDoc.array();
                int size=array.size();
                
                if(size<1){
                    qDebug()<<"无json数据";
                    reply->deleteLater();
                    requestNext();
                    //请求次数自加
                    requestTimes++;
                    return;
                }
    
    
                //匹配歌手,如果匹配成功则写入songId，否则默认第一项
                for(int i=0;i<size;i++){
                    QJsonValue v=array.at(i);
                    QJsonObject obj=v.toObject();
                    if(obj.contains("singer")&&obj.contains("song_id")){
                        QJsonValue value=obj.take("singer").toString();
    
                        QString singer=value.toString();
                        if(singer==singerStr){
                            qDebug()<<"歌手匹配成功:"<<singer;
                            QString songId=QString(obj.take("song_id").toString());
                            QString url=QString("http://ting.baidu.com/data/music/links?songIds=")+songId;
                            //设置url；
                            requestUrl=QUrl(url);
                            //请求设置为第二阶段
                            requestPhase=SECONDPHASE;;
                            //请求次数清零
                            requestTimes=0;
                            reply->deleteLater();
                            requestNext();
                            return;
                        }
                    }
                }
    
                //如果未匹配成功，则默认取第一项
                QJsonObject obj2=array.at(0).toObject();
                if(obj2.contains("song_id")){
                    qDebug()<<"未匹配成功:song_id默认第一项";
                    QJsonValue value2=obj2.take("song_id").toString();
                    QString songId=QString(value2.toString());
                    QString url=QString("http://ting.baidu.com/data/music/links?songIds=")+songId;
                    //设置url；
                    requestUrl=QUrl(url);
                    //请求设置为第二阶段
                    requestPhase=SECONDPHASE;;
                    requestTimes=0;
                    reply->deleteLater();
                    requestNext();
                    return;
                }
            }

        }

        //请求song_id出错

        reply->deleteLater();
        requestNext();
        //请求次数自加
        requestTimes++;
        return;
    }
    else if(requestPhase==SECONDPHASE){
        
        qDebug()<<"SECONDPHASE:加载json数据";
        QJsonParseError jsonError;
        QJsonDocument parseDoc=QJsonDocument::fromJson(reply->readAll(),&jsonError);
        if(jsonError.error==QJsonParseError::NoError){
             qDebug()<<"json无错误";
            if(parseDoc.isObject()){
                QJsonObject obj=parseDoc.object();
                //获取数据
                QJsonObject data=obj.take("data").toObject();
                QJsonArray ar=data.take("songList").toArray();
                QJsonObject lstObj=ar.takeAt(0).toObject();

                //歌曲链接
                QString songUrl=lstObj.take("showLink").toString();
                songUrl.replace("\\","");

                //歌词链接
                QString tag("http://ting.baidu.com");
                QString lrclink=lstObj.take("lrcLink").toString();
                lrclink.replace("\\","");   //删除斜杠
                QString lyricUrl;
                if(!lrclink.isEmpty()){
                    lyricUrl=tag+lrclink;
                }
                qDebug()<<"lyric url:"<<lyricUrl;

                //图片链接
                QString picUrl=lstObj.take("songPicBig").toString();
                picUrl.replace("\\","");

                /*有些图片url以这种形式出现：http://c.hiphotos.baidu.com/ting/pic/item/
                http://qukufile2.qianqian.com/data2/pic/115427899/115427899.jpg.jpg
                有些图片则是：
                http://c.hiphotos.baidu.com/ting/pic/item/574e9258d109b3de2abe3f4fcebf6c81800a4c90.jpg
                需要转换url*/

                qDebug()<<"cover url:"<<picUrl;
                const QString flag="http://c.hiphotos.baidu.com/ting/pic/item/";
                if(picUrl.indexOf(flag)>-1&&picUrl.count("http")>1){
                    int n=picUrl.length();
                    picUrl=picUrl.mid(flag.length(),n-flag.length()-4);
                    qDebug()<<"图片url已转换——cover url:"<<picUrl;
                }

                //歌手
                singerStr=lstObj.take("artistName").toString();

                //歌曲格式
                songSuffix=lstObj.take("format").toString();

                //获取歌曲
                if(downloadType==SONG){
                    requestUrl=QUrl(songUrl);
                    reply->deleteLater();
                    requestPhase=LASTPHASE;
                    requestNext();
                    qDebug()<<"下载歌曲...";
                    return;

                }
                //获取歌词
                else if(downloadType==LYRIC){
                    if(lyricUrl.isEmpty())
                    {
                        requestTimes=0;
                        reply->deleteLater();
                        emit downloadStopped();
                        return;
                    }

                    requestUrl=QUrl(lyricUrl);
                    reply->deleteLater();
                    requestPhase=LASTPHASE;
                    requestNext();
                    qDebug()<<"下载歌词...";
                    return;
                }
    
                //图片
                else if(downloadType==PIC){
                    if(picUrl.isEmpty())
                    {
                        requestTimes=0;
                        reply->deleteLater();
                        emit downloadStopped();
                        return;
                    }
                    requestUrl=QUrl(picUrl);
                    reply->deleteLater();
                    requestPhase=LASTPHASE;
                    requestNext();
                    qDebug()<<"下载封面...";
                    return;
                }
    
            }
        }

        reply->deleteLater();
        emit downloadStopped();

        
    }
    else if(requestPhase==LASTPHASE)
    {
        file->write(reply->readAll());
        QString fileName=file->fileName();

        if(downloadType==SONG){
            file->close();
            if(file->open(QIODevice::ReadOnly)){

                //如果文件首行为“<html>”,则说明xcode错误，重新获取链接并下载；
                QString s=file->readLine();
                if(s=="<html>"){
                    qDebug()<<"xcode错误，重新下载";
                    file->close();
                    QFile::remove(fileName);
                    file->deleteLater();
                    reply->deleteLater();
                    requestTimes++;
                    requestPhase=SECONDPHASE;
                    requestNext();
                    return;
                }

            }

        }

        //
        reply->deleteLater();
        QString newName=fileName.left(fileName.length()-4);
        file->close();
        QFile::remove(newName);
        if(file->rename(newName)){
        qDebug()<<"下载完毕！";
        emit downloadSucceeded(newName);
        emit downloadStopped();
        }
        file->close();
        file->deleteLater();
        return;
        
    }
    reply->deleteLater();
    file->close();
    file->deleteLater();
    emit downloadStopped();
    
    
}
void Download::replyReadyRead(){
    file->write(reply->readAll());
}
QString Download::getArtist(){
    return singerStr;
}
