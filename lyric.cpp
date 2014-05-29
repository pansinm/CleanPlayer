#include "lyric.h"
#include<QFile>
#include<QRegExp>
#include<QDebug>
Lyric::Lyric(QObject *parent) :
    QObject(parent)
{
}
void Lyric::loadFile(QString lyricFile){

    QFile file(lyricFile);
    if(!file.open(QIODevice::ReadOnly)){
        return;
    }
    //清空歌词
    lyricList.clear();
    QString  line;
    while(!file.atEnd()){
        line=QString(file.readLine());
        line=line.replace(" ","");
        QRegExp rx("\\[(\\d+):(\\d+).(\\d+)\\](.*)");
        int pos=rx.indexIn(line);
        if(pos>-1){
            int min=rx.cap(1).toInt();
            int sec=rx.cap(2).toInt();
            int mse=rx.cap(3).toInt();//实际为1%秒
            QString lyricStr=rx.cap(4);
            qint64 appearTime=(min*60+sec)*1000+mse*10;
            LyricLine* lyricLine=new LyricLine;
            lyricLine->time=appearTime;
            lyricLine->lyric=lyricStr;
            lyricList.append(lyricLine);
            qDebug()<<lyricLine->time<<lyricLine->lyric;
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
        if(queryTime>=lyricList.at(i)->time){
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
