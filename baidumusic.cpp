#include <QDebug>
#include <QUrl>
#include <QNetworkRequest>
#include <QByteArray>
#include <QStringList>
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include <QRegularExpressionMatchIterator>

#include "baidumusic.h"

//页面大小
const int PAGESIZE = 20;

//音乐搜索API
//参数%1：搜索关键字
//参数%2: 起始位置，为(page-1)*20
const QString ApiOfSearch = "http://music.baidu.com/search?key=%1&start=%2&size=20";

//搜索建议API
//参数%1：歌曲id
const QString ApiOfSuggestion = "http://play.baidu.com/data/music/songinfo?songIds=%1";

//歌曲信息API
//参数%1：歌曲id
const QString ApiOfSongInfo = "http://play.baidu.com/data/music/songinfo?songIds=%1";

//歌曲链接API
//参数%1：歌曲id
const QString ApiOfSongLink = "http://play.baidu.com/data/music/songlink?songIds=%1&type=m4a,mp3";

BaiduMusic::BaiduMusic(QObject *parent) : QObject(parent)
{
    manager.setCookieJar(&cookieJar);
}

BaiduMusic::~BaiduMusic()
{

}

void BaiduMusic::setSearchMode(const QString& mode)
{
    searchMode = mode;
}

void BaiduMusic::search(const QString &keyword, int page)
{

    //起始位置
    int start = (page-1)*PAGESIZE;

    //构造请求链接url
    QUrl url = QUrl(ApiOfSearch.arg(keyword).arg(start));
    searchReply = manager.get(QNetworkRequest(url));
    connect(searchReply,SIGNAL(finished()),this,SLOT(searchReplyFinished()));
}

void BaiduMusic::getSuggestion(QString keyword)
{

}

void BaiduMusic::getSongInfo(int songId)
{

}

void BaiduMusic::getSongLink(int songId)
{

}

void BaiduMusic::searchReplyFinished()
{
    qDebug()<<"finished";

    if(searchReply->error()){
        searchReply->deleteLater();
        return;
    }

    QString html = searchReply->readAll();
    QStringList songList;
    QRegularExpression re("<li data-songitem = '(.+?)'");
    QRegularExpressionMatchIterator i = re.globalMatch(html);
    qDebug()<<i.hasNext()<<"\n"<<html.left(300);
    while (i.hasNext()) {
        QRegularExpressionMatch match = i.next();
        QString songData = match.captured(1);
        songData = songData.replace("&quot;","\"").replace("&lt;em&gt;","").replace("&lt;\\/em&gt;","");
        songList << songData;
        qDebug()<<songData;
    }
}

void BaiduMusic::sugestionReplyFinished()
{

}

void BaiduMusic::songInfoReplyFinished()
{

}

void BaiduMusic::songLinkReplyFinished()
{

}
