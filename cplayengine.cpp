#include "cplayengine.h"
#include<QDomDocument>
#include<QDomText>
#include<QDomProcessingInstruction>
#include<QDomProcessingInstruction>
#include<QDomElement>
#include<QFile>
CPlayEngine::CPlayEngine(QObject *parent) :
    QObject(parent)
{

}
CPlayEngine::CPlayEngine(QString listFileName,QObject *parent = 0): QObject(parent)

{

}

bool CPlayEngine::getCover()
{

}

bool CPlayEngine::readDefaultPlayList()
{
    if(!readPlayList("playlist.xml"))
    {
        //如果读取playlist.xml失败，则创建playlist.xml

        QFile file( "playlist.xml" );
           if ( !file.open( QIODevice::WriteOnly | QIODevice::Truncate ) )
                  return false;

           QDomDocument doc;

           QDomProcessingInstruction instruction;

           instruction = doc.createProcessingInstruction( "xml", "version = \'1.0\'" );
           doc.appendChild( instruction );

           QDomElement playlist = doc.createElement( "playlist" );
           doc.appendChild( playlist );

           QDomText empty=doc.createTextNode("");

           QTextStream out( &file );
           doc.save( out, QDomNode::EncodingFromTextStream );



    }
    return true;

}

bool CPlayEngine::readPlayList(QString fileName)
{
    if( NULL == fileName )
           return false;
    QDomDocument doc("playlist");
    QFile file(fileName);
    if (!file.open(QIODevice::ReadOnly| QFile::Text))
        return false;
    if (!doc.setContent(&file)) {
        file.close();
        return false;
    }
    file.close();

    QDomElement playlistElem = doc.documentElement();

    QDomElement musicElement=playlistElem.firstChildElement();
    while(!musicElement.isNull())
    {
        QDomElement info=musicElement.firstChildElement();
        while(!info.isNull())
        {
            if(info.tagName()=="musicFile")
            {
                cplayList.addMedia(QMediaContent(Qurl(info.nodeValue())));
            }
            if(info.tagName()=="lyricFile")
            {
                cplayList.addMedia(QMediaContent(Qurl(info.nodeValue())));
            }
           info=info.nextSiblingElement();
        }

        musicElement=musicElement.nextSiblingElement();

    }


}
