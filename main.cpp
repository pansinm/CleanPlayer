#include<QApplication>
#include<QQuickView>
#include<QColor>
#include<QQmlContext>
#include<QQmlEngine>
#include<QDebug>
#include<QQuickItem>
#include<QString>
#include<lyric.h>
//#include"playengine.h"
#include"playlist.h"
#include"musicinfo.h"
#include"network.h"
int main(int argc,char* argv[])
{
    QApplication app(argc,argv);
    QQuickView viewer;
    qmlRegisterType<Lyric>("MyComponents",1,0,"Lyric");

    qmlRegisterType<Playlist>("MyComponents",1,0,"Playlist");
    qmlRegisterType<MusicInfo>("MyComponents",1,0,"MusicInfo");
    qmlRegisterType<Network>("MyComponents",1,0,"Network");


    //无边框，背景透明
    viewer.setFlags(Qt::FramelessWindowHint|Qt::Window|Qt::WindowSystemMenuHint | Qt::WindowMinMaxButtonsHint);
    //viewer.setFlags();
    viewer.setColor(QColor(Qt::transparent));

    //加载qml
    viewer.setSource(QUrl("qrc:/qml/qml/MainWindow.qml"));

    viewer.rootContext()->setContextProperty("mainwindow",&viewer);

    //PlayEngine engine(&viewer);
    //viewer.rootContext()->setContextProperty("playengine",&engine);
    //viewer.rootContext()->setContextProperty("myModel",&engine.listModel);
    //QObject* qmlObj=dynamic_cast<QObject*>(viewer.rootObject());
    //QObject::connect(qmlObj,SIGNAL(next),&engine,SLOT(playNext()));
    viewer.show();
    return app.exec();
}
