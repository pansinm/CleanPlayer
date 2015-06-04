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
#include"playlist_old.h"
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
    viewer.setTitle("Dae Player");

    //这行不注释掉的话在XP系统无法正常显示
    //viewer.setColor(QColor(Qt::transparent));

    //加载qml
    viewer.setSource(QUrl("qrc:/qml/qml/MainWindow.qml"));

    viewer.rootContext()->setContextProperty("mainwindow",&viewer);

    viewer.show();
    return app.exec();
}
