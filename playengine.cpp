#include "playengine.h"
#include<QFileDialog>
#include<QStringList>
#include<QMediaPlaylist>
PlayEngine::PlayEngine(QObject *parent) :
    QObject(parent)
{
    player.setPlaylist(&playlist);
    connect(&player,SIGNAL(currentMediaChanged(QMediaContent)),this,SLOT(downloadFiles()));
    connect(&player,SIGNAL(positionChanged(qint64)),this,SIGNAL(positionChanged(qint64)));
    connect(&player,SIGNAL(durationChanged(qint64)),this,SIGNAL(durationChanged(qint64)));

}
void PlayEngine::setPlayPosition(qint64 pos){
    player.setPosition(pos);
}

void PlayEngine::downloadFiles(){

    Download* picDownloader=new Download;
    Download* lyricDownloader=new Download;
    QDir dir;
    QString path=dir.currentPath();
    picDownloader->setPath(path+"/cover");
    lyricDownloader->setPath(path+"/lyric");
    QString song;
    QString artist;
    QModelIndex modelIndex;
    modelIndex=listModel.index(playlist.currentIndex());
    song=listModel.data(modelIndex,PlaylistModel::NameRole).toString();
    artist=listModel.data(modelIndex,PlaylistModel::ArtistRole).toString();
    emit musicChanged(song,artist);
    qDebug()<<"PlayEngine:\n\tdownloadFiles():artist"<<artist;
    picDownloader->setKeywords(song,artist,PIC);
    lyricDownloader->setKeywords(song,artist,LYRIC);
    picDownloader->start();
    lyricDownloader->start();
    connect(picDownloader,SIGNAL(downloadSucceeded(QString)),this,SLOT(setCover(QString)));
    connect(picDownloader,SIGNAL(downloadStopped()),picDownloader,SLOT(deleteLater()));
    connect(lyricDownloader,SIGNAL(downloadSucceeded(QString)),this,SLOT(setLyric(QString)));
    connect(lyricDownloader,SIGNAL(downloadStopped()),lyricDownloader,SLOT(deleteLater()));
}

void PlayEngine::setLyric(QString lyric){
    emit lyricChanged(lyric);
    qDebug()<<"setLyric():"<<lyric;
    //m_lyric.loadFile(lyric);
}


void PlayEngine::setCover(QString cover){
    qDebug()<<"setCover():"<<cover;
    QModelIndex modelIndex;
    modelIndex=listModel.index(playlist.currentIndex());
    listModel.setData(modelIndex,cover,PlaylistModel::CoverRole);
    QUrl coverFile=QUrl::fromLocalFile(cover);
    emit coverChanged(coverFile);
}

void PlayEngine::play(){
    player.play();
}
void PlayEngine::play(int index){
    if(index<0||index>=playlist.mediaCount()){
        return;
    }
    playlist.setCurrentIndex(index);
    player.play();
}
void PlayEngine::pause(){
    player.pause();
}

void PlayEngine::playNext(){
     playlist.setCurrentIndex(playlist.nextIndex());
     player.play();
}


void PlayEngine::playPrevious(){
     playlist.setCurrentIndex(playlist.previousIndex());
     player.play();
}

//添加音乐
void PlayEngine::addMusic(){
    qDebug()<<"addMusic:";
    QFileDialog* dialog=new QFileDialog;

    QStringList filelist=dialog->getOpenFileNames(0,
                                                   "选择一首或多首歌曲",
                                                   "",
                                                   "Music (*mp3 *wma)");
    dialog->deleteLater();
    if(filelist.length()<1){
        qDebug()<<"none file";
        return;
    }
    qDebug()<<"playlist.xml";
    QDomDocument listDom("playlist");
    QFile file("playlist.xml");
    if (!file.open(QIODevice::ReadOnly))
        return;
    if (!listDom.setContent(&file)) {
        file.close();
        return;
    }
    file.close();

    qDebug()<<filelist[0];
    qDebug()<<"加载到dom";
    for(int i=0;i<filelist.length();i++){        
        //添加到列表；
        bool isExist=false;
        QDomElement root=listDom.documentElement();
        QDomNodeList nodeList=root.childNodes();

        //判断和列表中歌曲是否相同
        for(int j=0;j<nodeList.length();j++){
            if(filelist.at(i)==nodeList.at(j).firstChildElement().text()){
                isExist=true;
                break;
            }
        }

        if(!isExist){
            //@@@@@@@@@@@@
            playlist.addMedia(QUrl::fromLocalFile(filelist.at(i)));
            MusicInfo* info=new MusicInfo(filelist.at(i));
            qDebug()<<"info: info.name"<<info->name();
            listModel.addMusicInfo(info);
        }

    }

}

