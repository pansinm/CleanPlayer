#include "playlistmodel.h"
#include"id3v1tags.h"
#include<QFileInfo>
#include<QFile>
MusicInfo::MusicInfo(const QString &url){
    ID3V1Tags mp3Tags;

    //id3v1tags用标准C++编写，字符转换。。。
    string fileUrl=string((const char*)url.toLocal8Bit());
    mp3Tags.setFile(fileUrl);
    m_url=url;
    QString musicName=QString::fromLocal8Bit(mp3Tags.getTitle().c_str());
    if(musicName!=""){
        m_name=musicName;
    }
    else
    {
        QFileInfo info(url);
        m_name=info.completeBaseName();
    }
    m_artist=QString::fromLocal8Bit(mp3Tags.getArtist().c_str());
    m_cover="";
    m_lyric="";
}

PlaylistModel::PlaylistModel(QObject *parent) :
    QAbstractListModel(parent)
{
}

void PlaylistModel::addMusicInfo(MusicInfo *musicInfo){
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    musicInfos.append(musicInfo);
    endInsertRows();
}

void PlaylistModel::insertMusicInfo(MusicInfo *musicInfo, int row){
    beginInsertRows(QModelIndex(),row,row);
    musicInfos.insert(row,musicInfo);
    endInsertRows();
}

int PlaylistModel::rowCount(const QModelIndex &parent) const{
    return musicInfos.count();
}

QVariant PlaylistModel::data(const QModelIndex &index, int role) const{
    if(index.row()<0||index.row()>musicInfos.count()){
        return QVariant();
    }

    MusicInfo* msInfo=musicInfos[index.row()];
    if(role==UrlRole){
        return msInfo->url();
    }
    else if(role==NameRole){
        return msInfo->name();
    }
    else if(role==ArtistRole){
        return msInfo->artist();
    }
    else if(role==CoverRole){
        return msInfo->cover();
    }
    else if(role==LyricRole){
        return msInfo->lyric();
    }

    return QVariant();
}

QHash<int,QByteArray> PlaylistModel::roleNames() const{
    QHash<int,QByteArray> roles;
    roles[UrlRole]="url";
    roles[NameRole]="name";
    roles[ArtistRole]="artist";
    roles[CoverRole]="cover";
    roles[LyricRole]="lyric";
    return roles;
}

bool PlaylistModel::setData(const QModelIndex &index, const QVariant &value, int role){
    if(index.row()<0||index.row()>musicInfos.count()){
        return false;
    }
    if(role==UrlRole){
        musicInfos.at(index.row())->setUrl(value.toString());
        emit dataChanged(index,index);
        return true;

    }
    else if(role==NameRole){
         musicInfos.at(index.row())->setName(value.toString());
          emit dataChanged(index,index);
         return true;
    }
    else if(role==ArtistRole){
        musicInfos.at(index.row())->setArist(value.toString());
         emit dataChanged(index,index);
        return true;

    }
    else if(role==CoverRole){
        musicInfos.at(index.row())->setCover(value.toString());
         emit dataChanged(index,index);
        return true;
    }
    else if(role==LyricRole){
        musicInfos.at(index.row())->setLyric(value.toString());
        emit dataChanged(index,index);
        return true;
    }
    return false;
}

QModelIndex PlaylistModel::index(int row, int column, const QModelIndex &parent) const{
    if(row<0||row>musicInfos.count()){
        return QModelIndex();
    }
    return createIndex(row,column);
}
