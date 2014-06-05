#include "lyric.h"
#include<QFile>
#include<QRegExp>
#include<QDebug>
Lyric::Lyric(QObject *parent) :
    QObject(parent),offset(0)
{
}

void Lyric::loadFile(const QString& lyricFile){

    lyricList.clear();
    offset=0;

    qDebug()<<"lyric file name:"<<lyricFile;
    if(lyricFile.isEmpty()){
        return;
    }
    QString fileName;
    QUrl url(lyricFile);
    //判断是否为本地文件
     fileName = url.isLocalFile() ? url.toLocalFile():lyricFile;

    qDebug()<<"fileName:"<<fileName;

    QFile file(fileName);
    if(!file.open(QIODevice::ReadOnly)){
        return;
    }

    QString  line;
    while(!file.atEnd()){
        line=QString(file.readLine());
        parseLyricLine(line);

    }
    sort();
    file.close();
    qDebug()<<"fileLoaded";
}

//解析歌词，支持单行多时段
void Lyric::parseLyricLine(const QString& line){

    //常规歌词
    QRegExp rx("\\[(\\d+):(\\d+).(\\d+)\\](.*)");
    int pos=rx.indexIn(line);

    //有些歌词只有到秒
    QRegExp specialRx("\\[(\\d+):(\\d+)\\](.*)");
    int specialPos=specialRx.indexIn(line);

    //歌词偏置正则表达式 如[offset:500]
    QRegExp offsetRx("\\[offset(\\d+)\\]");
    int offsetIndex=offsetRx.indexIn(line);

    if(pos>-1){
        int min=rx.cap(1).toInt();
        int sec=rx.cap(2).toInt();
        int mse=rx.cap(3).toInt();//实际为1%秒
        qint64 appearTime=(min*60+sec)*1000+mse*10;
        times.push(appearTime);

        //递归解析
        QString lyricStr=rx.cap(4);
        qDebug()<<"parse lyric:"<<lyricStr;
        parseLyricLine(lyricStr);
    }
    else if(specialPos>-1){
        int min=specialRx.cap(1).toInt();
        int sec=specialRx.cap(2).toInt();
        qDebug()<<"specialRx int"<<min<<":"<<sec;
        qint64 appearTime=(min*60+sec)*1000;
        times.push(appearTime);
        //递归解析
        QString lyricStr=specialRx.cap(3);
        parseLyricLine(lyricStr);
    }
    else if(offsetIndex>-1){
        offset=offsetRx.cap(1).toInt();
        qDebug()<<"offset:"<<offset;
    }

    while(!times.isEmpty()){
        LyricLine* lyricLine=new LyricLine;
        lyricLine->time=times.pop();
        lyricLine->lyric=line;
        qDebug()<<lyricLine->time<<line;
        lyricList.append(lyricLine);
    }
}

//歌词按时间排序
void Lyric::sort(){
    int n=lyricList.count();
    for(int i=0;i<n;i++){
        for(int j=n-1;j>i;j--){
            if(lyricList.at(i)->time>lyricList.at(j)->time){
                lyricList.swap(i,j);
            }
        }
    }
}

QString Lyric::lyricAt(int i){
    if(i>=lyricList.count()||i<0)
        return QString();
    QString s;
    s=lyricList.at(i)->lyric;
    return s;
}

int Lyric::getLyric(qint64 queryTime, QString &lyricStr){
    for(int i=lyricList.length()-1;i>=0;i--){
        if(queryTime>=lyricList.at(i)->time-offset){
            lyricStr=lyricList.at(i)->lyric;
            return i;
        }
    }
    return -1;
}
int Lyric::lineCount(){
    return lyricList.count();
}

int Lyric::getLyric(qint64 queryTime){
    QString s;
    return getLyric(queryTime,s);
}

QList<LyricLine*> Lyric::getLyricList(){
    return lyricList;
}

