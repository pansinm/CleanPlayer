#include "playlist_old.h"
#include<QDebug>
#include<QJsonDocument>
#include<QJsonObject>
#include<QJsonValue>
#include<QJsonParseError>
#include<QByteArray>
#include<QMap>
#include<QFileInfo>
#include<QByteArray>
#include<QFile>
#include<QDomDocument>
#include<QDomElement>
#include<QDomNode>
#include<QDomNodeList>
#include<QDomText>
#include<QTime>
#include"id3v1tags.h"
Playlist::Playlist(QObject *parent) :
    QObject(parent),m_currentMediaIndex(-1)
{
    m_playMode=Sequence;
    qsrand(QTime(0,0,0).secsTo(QTime::currentTime()));
}

//设置播放模式，随机或顺序
void Playlist::setPlayMode(PlayMode mode){
    m_playMode=mode;
}

//判断歌词是否有效
bool Playlist::isLyricValid(const QUrl& lyricUrl){
    QFileInfo info(lyricUrl.toLocalFile());
    qDebug()<<"isLyricValid:"<<info.fileName();
    if(info.suffix()=="lrc"&&info.exists()&&info.size()>0){
        return true;
    }
    return false;
}

//判断封面图片是否有效
bool Playlist::isCoverValid(const QUrl& coverUrl){
    QFileInfo info(coverUrl.toLocalFile());
    if(info.exists()&&info.size()>0){
        return true;
    }
    return false;
}

//返回播放模式
Playlist::PlayMode Playlist::playMode() const{
    return m_playMode;
}

//返回音乐文件所在位置，-1表示不存在
int Playlist::indexOf(const QUrl& url){
    qDebug()<<"indexOf url:"<<url;

    if(url.isEmpty()){

        return -1;
    }
    //url无效
    if(!url.isValid()){
        qDebug()<<"//url无效";
        return -1;
    }

    for(int i=0;i<count();i++){
        qDebug()<<"m_playlist.at(i)->url()"<<m_playlist.at(i)->url();
        if(url.toString()==m_playlist.at(i)->url().toString()){
            qDebug()<<"indexOf i"<<i;
            return i;
        }
    }
    return -1;
}

//将下一首设置为当前索引
void Playlist::next(){
    qDebug()<<"curentIndex"<<m_currentMediaIndex<<playMode();
    if(m_playMode==Sequence){
        if(m_currentMediaIndex<m_playlist.count()-1){

            setCurrentMediaIndex(++m_currentMediaIndex);

        }
    }
    else if(m_playMode==Random){
        qDebug()<<"random...";
        int i=qrand()%m_playlist.count()+1;
        setCurrentMediaIndex(i);
    }
}

//将上一首设置为当前索引
void Playlist::previous(){
    if(m_playMode==Sequence){
        if(m_currentMediaIndex>0){
            setCurrentMediaIndex(--m_currentMediaIndex);
        }
    }
    else if(m_playMode==Random){
        int i=qrand()%m_playlist.count()+1;
        setCurrentMediaIndex(i);
    }
}

//返回位置i的json数据
QVariant Playlist::at(const int i) const{
    //返回空json
    if(i<0||i>=m_playlist.count()){
        QJsonObject jsonObjEmpty;
        QJsonDocument jsonDocEmpty;
        jsonObjEmpty.insert(QString("url"),QJsonValue(QString()));
        jsonObjEmpty.insert(QString("title"),QJsonValue(QString()));
        jsonObjEmpty.insert(QString("artist"),QJsonValue(QString()));
        jsonObjEmpty.insert(QString("cover"),QJsonValue(QString()));
        jsonObjEmpty.insert(QString("lyric"),QJsonValue(QString()));
        jsonDocEmpty.setObject(jsonObjEmpty);
        return jsonDocEmpty.toJson(QJsonDocument::Compact);
    }

    QJsonObject jsonObj;
    QJsonDocument jsonDoc;
    jsonObj.insert(QString("url"),QJsonValue(m_playlist.at(i)->url().toString()));
    jsonObj.insert(QString("title"),QJsonValue(m_playlist.at(i)->title()));
    jsonObj.insert(QString("artist"),QJsonValue(m_playlist.at(i)->artist()));
    jsonObj.insert(QString("cover"),QJsonValue(m_playlist.at(i)->cover().toString()));
    jsonObj.insert(QString("lyric"),QJsonValue(m_playlist.at(i)->lyric().toString()));
    jsonDoc.setObject(jsonObj);
    return jsonDoc.toJson(QJsonDocument::Compact);
}

//替换所在位置的列表数据
void Playlist::replace(const int index,const QVariant json){

    qDebug()<<"replace:index"<<index<<json.toByteArray();

    if(index<0||index>=m_playlist.count()){

        return;
    }

    QJsonParseError jsonError;
    QJsonDocument jsonDoc=QJsonDocument::fromJson(json.toByteArray(),&jsonError);
    qDebug()<<"errorString:"<<jsonError.errorString();
    if(jsonError.error==QJsonParseError::NoError){
        qDebug()<<"json noerror";
        if(!jsonDoc.isObject()){
            return;
        }
        QJsonObject jsonObj=jsonDoc.object();

        //如果存在且不同的话，替换
        if(jsonObj.contains("url")&&m_playlist[index]->url()!=QUrl(jsonObj.value("url").toString())){
            m_playlist[index]->setUrl(QUrl(jsonObj.value("url").toString()));
        }
        if(jsonObj.contains("title")&&m_playlist[index]->title()!=jsonObj.value("title").toString()){
            m_playlist[index]->setTitle(jsonObj.value("title").toString());
        }
        if(jsonObj.contains("artist")&&m_playlist[index]->artist()!=jsonObj.value("artist").toString()){
            m_playlist[index]->setArtist(jsonObj.value("artist").toString());
        }
        if(jsonObj.contains("cover")&&m_playlist[index]->cover()!=QUrl(jsonObj.value("cover").toString())){
            m_playlist[index]->setCover(QUrl(jsonObj.value("cover").toString()));
        }
        if(jsonObj.contains("lyric")&&m_playlist[index]->lyric()!=QUrl(jsonObj.value("lyric").toString())){
            m_playlist[index]->setLyric(QUrl(jsonObj.value("lyric").toString()));
            qDebug()<<"m_playlist replace url:"<<m_playlist[index]->lyric();

        }   
        //如果替换的是当前位置，则发送信号
        if(index==m_currentMediaIndex){
            emit currentItemChanged();
        }
        emit replaced(index);
        emit changed();
    }

}

//依据json数据所含的url查询条目，并更新
void Playlist::sync(const QVariant json){
    QJsonParseError jsonError;
    QJsonDocument jsonDoc=QJsonDocument::fromJson(json.toByteArray(),&jsonError);
    qDebug()<<"errorString:"<<jsonError.errorString();
    if(jsonError.error==QJsonParseError::NoError){
        qDebug()<<"json noerror";
        if(!jsonDoc.isObject()){
            return;
        }
        QJsonObject jsonObj=jsonDoc.object();
        //不含url，则返回
        if(!jsonObj.contains("url")){
            return;
        }
        QUrl url=QUrl(jsonObj.value("url").toString());

        //如果url为空或者无效
        if(url.isEmpty()||(!url.isValid())){
            return;
        }

        for(int i=0;i<m_playlist.count();i++){
            if(url==m_playlist.at(i)->url()){

                //歌曲名不更新
                //m_playlist[i]->setTitle(jsonObj.value("title").toString());

                m_playlist[i]->setArtist(jsonObj.value("artist").toString());

                //如果lyric和cover为空，则替换
                if(m_playlist.at(i)->cover().isEmpty()){
                    m_playlist[i]->setCover(QUrl(jsonObj.value("cover").toString()));
                }

                if(m_playlist.at(i)->lyric().isEmpty()){
                    m_playlist[i]->setLyric(QUrl(jsonObj.value("lyric").toString()));
                }
                if(i==m_currentMediaIndex){
                    emit currentItemChanged();
                }
                emit synchronized();
                emit changed();
            }
        }

    }
}

//移除指定列表项
void Playlist::remove(const int index){
    qDebug()<<"删除:remove="<<index;
    if(index<0||index>=m_playlist.count()){
        return;
    }
    qDebug()<<"删除:index="<<index;

    m_playlist.removeAt(index);

    if(index<currentMediaIndex()){
        setCurrentMediaIndex(currentMediaIndex()-1);
    }
    if(index==currentMediaIndex()&&count()>0){
        setCurrentMediaIndex(currentMediaIndex());
    }

    if(count()<0){
        setCurrentMediaIndex(-1);
    }

    emit removed(index);
    emit changed();
    emit countChanged();
}

//添加项
void Playlist::append(MusicInfo *info){

    //判断文件是否重复
    for(int i=0;i<m_playlist.count();i++){
        if(info->url()==m_playlist[i]->url()){
            return;
        }
    }

    m_playlist.append(info);
    emit appended();
    emit changed();
}

//以url形式添加，根据文件解析歌词名和歌手，写入
void Playlist::append(const QUrl& fileUrl){

    //判断文件是否重复
    for(int i=0;i<m_playlist.count();i++){
        if(fileUrl==m_playlist[i]->url()){
            return;
        }
    }

    MusicInfo* info=new MusicInfo;
    //id3v1tags用标准C++编写，所以字符转换。。。
    QString fileStr=fileUrl.toLocalFile();
    ID3V1Tags mp3Tags;
    string musicFile=string((const char*)fileStr.toLocal8Bit());

    if(mp3Tags.setFile(musicFile)){
        info->setUrl(fileUrl);
        QFileInfo fileInfo(fileStr);
        //判断音乐文件Tag是否为ID3V1版本
        if(mp3Tags.isID3V1()){
            QString title=QString::fromLocal8Bit(mp3Tags.getTitle().c_str());

            //如果标题为空则文件名作为标题
            if(title!=""){
                info->setTitle(title);
            }
            else
            {
                info->setTitle(fileInfo.completeBaseName());
            }

            QString artist=QString::fromLocal8Bit(mp3Tags.getArtist().c_str());
            info->setArtist(artist);
        }
        else{
            info->setTitle(fileInfo.completeBaseName());
            info->setArtist(QString());
            info->setCover(QUrl());
            info->setLyric(QUrl());
        }

        append(info);

        //如果当前索引为-1，则更改为0
    }  
}

//保存列表为xml格式
void Playlist::save(const QString& xmlFile) const{
    QDomDocument domDoc("playlist");
    QDomElement root=domDoc.createElement("playlist");
    root.setAttribute("currentMediaIndex",currentMediaIndex());
    domDoc.appendChild(root);

    //读取playlist，转换为xml doc
    for(int i=0;i<m_playlist.count();i++){
        QDomElement file=domDoc.createElement("file");

        QDomElement url=domDoc.createElement("url");
        QDomElement title=domDoc.createElement("title");
        QDomElement artist=domDoc.createElement("artist");
        QDomElement cover=domDoc.createElement("cover");
        QDomElement lyric=domDoc.createElement("lyric");

        QDomText urlTxt=domDoc.createTextNode(m_playlist.at(i)->url().toString());
        QDomText titleTxt=domDoc.createTextNode(m_playlist.at(i)->title());
        QDomText artistTxt=domDoc.createTextNode(m_playlist.at(i)->artist());
        QDomText coverTxt=domDoc.createTextNode(m_playlist.at(i)->cover().toString());
        QDomText lyricTxt=domDoc.createTextNode(m_playlist.at(i)->lyric().toString());

        url.appendChild(urlTxt);
        title.appendChild(titleTxt);
        artist.appendChild(artistTxt);
        cover.appendChild(coverTxt);
        lyric.appendChild(lyricTxt);

        file.appendChild(url);
        file.appendChild(title);
        file.appendChild(artist);
        file.appendChild(cover);
        file.appendChild(lyric);

        root.appendChild(file);
    }

    //写入xml
    QFile out(xmlFile);
    if(!out.open(QIODevice::WriteOnly)){

        return;
    }
    out.write(domDoc.toByteArray());
    out.close();
}

//加载列表写入m_playlist
void Playlist::load(const QString& xmlFile){
    qDebug()<<"load playlist.xml";
    QDomDocument doc("playlsit");

    QFile file(xmlFile);
    if (!file.open(QIODevice::ReadOnly))
        return;
    if (!doc.setContent(&file)) {
        file.close();
        return;
    }
    file.close();

    QDomElement root = doc.documentElement();
    QDomNode node = root.firstChild();

    while(!node.isNull()){

        MusicInfo* info=new MusicInfo;
        QDomElement element=node.firstChildElement();
        while(!element.isNull()){

            if(element.tagName() == "url"){
                info->setUrl(QUrl(element.text()));
                qDebug()<<"element.text"<<element.text();
            }
            else if(element.tagName() == "title"){
                info->setTitle(element.text());
            }
            else if(element.tagName() == "artist"){
                info->setArtist(element.text());
            }
            else if(element.tagName() == "cover"){
                info->setCover(QUrl(element.text()));
            }
            else if(element.tagName() == "lyric"){
                info->setLyric(QUrl(element.text()));
            }
            element = element.nextSiblingElement();
        }

        m_playlist.append(info);
        node = node.nextSibling();
    }
    //读入currentMediaIndex
    int i=root.attribute("currentMediaIndex","0").toInt();
    if(m_playlist.count()>-1){
        setCurrentMediaIndex(i);
        emit loaded();
        emit changed();
        emit countChanged();
    }
}
