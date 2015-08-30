#include<QApplication>
#include<QQuickView>
#include<QColor>
#include<QQmlContext>
#include<QQmlEngine>
#include<QDebug>
#include<QQuickItem>
#include<QString>
#include<QIcon>
#include "baidumusic.h"
#include "util.h"
int main(int argc,char* argv[])
{
    QApplication app(argc,argv);
    QQuickView viewer;

    qmlRegisterType<BaiduMusic>("CleanPlayerCore",1,0,"BaiduMusic");
    qmlRegisterType<Util>("CleanPlayerCore",1,0,"Util");


    //无边框，背景透明
    //viewer.setFlags(Qt::FramelessWindowHint|Qt::Window|Qt::WindowSystemMenuHint | Qt::WindowMinMaxButtonsHint);
   // viewer.setTitle("Clean Player");

    //这行不注释掉的话在XP系统无法正常显示
    //viewer.setColor(QColor(Qt::transparent));

    //viewer.rootContext()->setContextProperty("mainwindow",&viewer);

    viewer.setSource(QUrl("qrc:/qml/qml/Main.qml"));
    viewer.setIcon(QIcon(":/image/image/logo.png"));
    viewer.show();

    return app.exec();
}
