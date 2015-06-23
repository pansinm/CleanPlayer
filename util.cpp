#include "util.h"
#include <QFile>

Util::Util(QObject *parent) : QObject(parent)
{

}

Util::~Util()
{

}

QString Util::readFile(QString filename)
{
    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){
        return "";
    }
    return file.readAll();
}

void Util::saveFile(QString filename, QString content)
{
    QFile file(filename);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)){
        return;
    }
    file.write(content.toUtf8());
}

