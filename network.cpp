#include "network.h"
#include<QUrl>
#include<QFile>
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
//通过关键字查询,返回匹配的歌曲列表"%1"=关键字,"%2"="json"或"xml"
const QString Api_getSongList="http://mp3.baidu.com/dev/api/?tn=getinfo&ct=0&ie=utf-8&word=%1&format=%2";

//通过song_id获取歌曲/歌词下载地址,"%1"为Api_getSongList返回的"song_id"项
const QString Api_getSong="http://ting.baidu.com/data/music/links?songIds=%1";

const int MaxRequestTimes=20;

 Network::Network(QObject *parent) :
    QObject(parent),requestTimes(0),isNetRequestBusy(false)
{

}
void Network::getLyric(const QVariant& json){
    qDebug()<<"Network::getLyric()"<<json;

    InputObj obj;
    obj.jsonVar=json;
    obj.fileType=Network::Lyric;
    stack.push(obj);
    if(!isNetRequestBusy){
        startNext();
    }
}

void Network::getSong(const QVariant& json){

    InputObj obj;
    obj.jsonVar=json;
    obj.fileType=Network::Song;
    stack.push(obj);
    if(!isNetRequestBusy){
        startNext();
    }
}

void Network::getPic(const QVariant& json){
    qDebug()<<"getPic^";
    InputObj obj;
    obj.jsonVar=json;
    obj.fileType=Network::Pic;
    stack.push(obj);
    if(!isNetRequestBusy){
        startNext();
    }
}

void Network::startNext(){
    qDebug()<<"Network::startNext()";

    //成员重置
    emitJson.empty();
    infoJson.empty();
    linkJson.empty();
    period=Network::RequestInfo;
    currentRequestUrl=QUrl();

    //栈空，返回
    if(stack.isEmpty()){
        isNetRequestBusy=false;
        return;
    }

    isNetRequestBusy=true;

    //出列
    InputObj obj=stack.pop();

    //解析json数据
    QJsonParseError jsonError;
    qDebug()<<"\tobj.jsonVar:"<<obj.jsonVar.toString();
    QJsonDocument jsonDoc=QJsonDocument::fromJson(obj.jsonVar.toByteArray(),&jsonError);
    if(jsonError.error==QJsonParseError::NoError){
        if(jsonDoc.isObject()){
            QJsonObject jsonObj=jsonDoc.object();
            if(jsonObj.contains("url")&&jsonObj.contains("title")){
                //保存原始json
                emitJson=jsonObj;
                fileType=obj.fileType;
                //构造链接url
                QUrl url_getSongList=Api_getSongList.arg(jsonObj.value("title").toString(),"json");
                qDebug()<<"Network:start():url_getSongList:"<<url_getSongList;
                //请求
                currentRequestUrl=url_getSongList;
                request(url_getSongList);
                return;
            }
        }
    }
    qDebug()<<"Network::startNext():satartNext()";
    startNext();

}
void Network::request(const QUrl &url){

    qDebug()<<"Network::request():"<<url;
    //文件名
    if(period==Network::Download){
        QDir  dir=QDir(QDir::currentPath());
        QString fileName;
        if(fileType==Network::Song){
            if(!dir.exists("song")){
                dir.mkdir("song");
            }
            dir.cd("song");
            QString f=infoJson.value("song").toString()+"-"
                    +infoJson.value("singer").toString()
                    +"."+linkJson.value("format").toString()+".tmp";

            fileName=dir.filePath(f);

        }
        else if(fileType==Network::Lyric){
            if(!dir.exists("lyric")){
                dir.mkdir("lyric");
            }
            dir.cd("lyric");
            QString s=url.toString();
            int n=s.lastIndexOf("/");
            int size=s.length();
            //文件名
            QString f=s.right(size-n-1)+".tmp";
            fileName=dir.filePath(f);
        }
        else if(fileType==Network::Pic){
            if(!dir.exists("pic")){
                dir.mkdir("pic");
            }
            dir.cd("pic");
            QString s=url.toString();
            int n=s.lastIndexOf("/");
            int size=s.length();
            //文件名
            QString f=s.right(size-n-1)+".tmp";
            fileName=dir.filePath(f);
        }

        qDebug()<<"\tfileName"<<fileName;
        if(fileName==""){
            startNext();
            return;
        }
        output.setFileName(fileName);
        //如果文件打开失败
        if(!output.open(QIODevice::WriteOnly)){
            startNext();
            return;
        }
    } 
    reply=manager.get(QNetworkRequest(url));
    connect(reply,SIGNAL(finished()),this,SLOT(replyFinished()));
    connect(reply,SIGNAL(readyRead()),this,SLOT(replyReadied()));

    qDebug()<<"Network::request():"<<"request over";

}

void Network::replyReadied(){
    if(period==Network::Download||output.isOpen()){
        output.write(reply->readAll());
    }
}

void Network::replyFinished(){

    qDebug()<<"Network::replyFinished():";
    if(period==Network::RequestInfo){

        QJsonParseError jsonError;
        //加载json数据
        QJsonDocument parseDoc=QJsonDocument::fromJson(reply->readAll(),&jsonError);
        if(jsonError.error==QJsonParseError::NoError){

            //如果json是数组，且请求getSongId次数大于50则判断数组是否为空，如果为空，则重新请求数据
            if(parseDoc.isArray()){
                QJsonArray array=parseDoc.array();
                int size=array.size();
                /*
                if(size<1){
                    qDebug()<<"Network:replyFinished():无json数据,重新请求";
                    if((++requestTimes)<=MaxRequestTimes){

                        qDebug()<<"requestTimes"<<requestTimes;
                        reply->deleteLater();
                        request(currentRequestUrl);
                        return;
                    }
                    else{
                        reply->deleteLater();
                        startNext();
                        return;
                    }

                }
                */
                if(size>0){
                    qDebug()<<"size:>0";
                    //第一项写入infoJson
                    QJsonValue value=array.at(0);
                    infoJson=value.toObject();

                    //匹配歌手,如果匹配成功则覆盖infoJson
                    for(int i=0;i<size;i++){
                        QJsonValue v=array.at(i);
                        QJsonObject obj=v.toObject();
                        if(obj.contains("singer")&&obj.contains("song_id")){
                            QString singerStr=emitJson.value("artist").toString();
                            QString singer=obj.value("singer").toString();
                            if(singer==singerStr){
                                qDebug()<<"Network:replyFinished():歌手匹配成功:"<<singer;
                                infoJson=obj;
                            }
                        }
                    }

                    //判断文件类型，如果是图片，直接返回下载链接
                    /*返回的图片路径有问题
                    if(fileType==Network::Pic){

                        QString s=infoJson.value("singerPicLarge").toString();
                        if(s==""){
                            s=infoJson.value("albumPicLarge").toString();
                        }

                        s.replace("//","");
                        currentRequestUrl=QUrl(s);
                        period=Network::Download;
                        request(currentRequestUrl);
                        requestTimes=0;
                        reply->deleteLater();
                        return;

                    }

                    else{
                    */
                    period=Network::RequestLink;
                    QString url=Api_getSong.arg(infoJson.value("song_id").toString());
                    requestTimes=0;
                    currentRequestUrl=QUrl(url);
                    delete reply;
                    reply=0;
                    request(currentRequestUrl);
                    return;
                    //}
                }
            }
        }

       //请求次数自加,超出范围则返回
        if(requestTimes<MaxRequestTimes){
            qDebug()<<"/t请求次数"<<requestTimes<<"<"<<MaxRequestTimes;
            requestTimes++;
            delete reply;
            reply=0;
            request(currentRequestUrl);
            return;
        }

        //如果有误且requeTimes超过规定值，进行下一个下载
        requestTimes=0;
        delete reply;
        reply=0;
        startNext();
        return;

    }

    else if(period==Network::RequestLink){
        qDebug()<<"Network:replayFinished():Network::RequestLink:加载json数据";
        QByteArray jsonArr=reply->readAll();
        qDebug()<<"parseDoc:readAll"<<jsonArr;
        QJsonParseError jsonError;
        QJsonDocument parseDoc=QJsonDocument::fromJson(jsonArr,&jsonError);
        qDebug()<<"parseDoc:";
        if(jsonError.error==QJsonParseError::NoError){
             qDebug()<<"\tNoError";
            if(parseDoc.isObject()){
                QJsonObject obj=parseDoc.object();
                //获取数据
                QJsonObject data=obj.value("data").toObject();
                QJsonArray ar=data.value("songList").toArray();
                QJsonObject lstObj=ar.at(0).toObject();

                linkJson=lstObj;

                QString url;

                //歌曲链接
                if(fileType==Network::Song){
                    url=lstObj.value("showLink").toString();
                    url.replace("\\","");
                }
                //歌词链接
                else if(fileType==Network::Lyric){
                    QString tag("http://ting.baidu.com");
                    QString lrclink=lstObj.value("lrcLink").toString();
                    lrclink.replace("\\","");   //删除斜杠
                    //如果歌词不为空
                    if(!lrclink.isEmpty()){
                        url=tag+lrclink;
                    }
                }
                else if(fileType==Network::Pic){
                    //图片链接
                    url=lstObj.value("songPicBig").toString();
                    url.replace("\\","");

                    /*
                     * 有些图片url以这种形式出现：http://c.hiphotos.baidu.com/ting/pic/item/
                     *http://qukufile2.qianqian.com/data2/pic/115427899/115427899.jpg.jpg
                     *有些图片则是：
                     *http://c.hiphotos.baidu.com/ting/pic/item/574e9258d109b3de2abe3f4fcebf6c81800a4c90.jpg
                     *所以需要转换url
                    */

                    const QString flag="http://c.hiphotos.baidu.com/ting/pic/item/";
                    if(url.indexOf(flag)>-1&&url.count("http")>1){
                        int n=url.length();
                        url=url.mid(flag.length(),n-flag.length()-4);
                        qDebug()<<"图片url已转换——cover url:"<<url;
                    }
                }

                qDebug()<<("\tNetwork::Download,开始下载……");
                currentRequestUrl=QUrl(url);
                period=Network::Download;
                requestTimes=0;
                delete reply;
                reply=0;
                request(currentRequestUrl);
                return;
            }

        }

        if(requestTimes<MaxRequestTimes){
            qDebug()<<"/tReplyLink请求次数"<<requestTimes<<"<"<<MaxRequestTimes;
            requestTimes++;
            delete reply;
            reply=0;
            request(currentRequestUrl);
            return;
        }

        requestTimes=0;
        delete reply;
        reply=0;
        startNext();
        return;
    }


    else if(period==Network::Download){
        //qDebug()<<"reply.readAll"<<reply->readAll();

        //如果文件未打开，则返回，下载下一个
        if(!output.isOpen()){
            requestTimes=0;
            delete reply;
            reply=0;
            startNext();
            return;
        }

        qDebug()<<"\tNetwork::Download,写入文件……";
        output.close();
        QString oldName=output.fileName();
        QString newName=oldName.left(oldName.length()-4);
        qDebug()<<"oldName"<<oldName;

        //如果重复，则删除
        QFile::remove(newName);
        QFile::rename(oldName,newName);

        //检查下载文件
        output.setFileName(newName);
        if(output.open(QIODevice::ReadOnly)){

            //如果文件首行为“<html>”或空行，则重新下载；
            QString s=output.readLine();

            if(s=="<html>"&&requestTimes<MaxRequestTimes){
                qDebug()<<"\t下载错误，重新下载";
                output.close();
                QFile::remove(newName);
                if((++requestTimes)>MaxRequestTimes){
                    requestTimes=0;
                    delete reply;
                    reply=0;
                    startNext();
                    return;
                }

                period=Network::RequestLink;
                delete reply;
                reply=0;
                currentRequestUrl=QUrl(Api_getSong.arg(infoJson.value("song_id").toString()));
                request(currentRequestUrl);
                return;
            }
            output.close();
        }

        emitJson.insert("artist",infoJson.value("singer"));
        if(fileType==Network::Lyric){
            emitJson.insert("lyric",QJsonValue(QUrl::fromLocalFile(newName).toString()));
        }
        else if(fileType==Network::Pic){
            emitJson.insert("cover",QJsonValue(QUrl::fromLocalFile(newName).toString()));
        }

        QJsonDocument doc;
        doc.setObject(emitJson);
        QVariant var=doc.toJson(QJsonDocument::Compact);
        if(!var.isNull()){
            emit succeeded(var);
        }

    }
    requestTimes=0;
    delete reply;
    reply=0;
    startNext();
}

