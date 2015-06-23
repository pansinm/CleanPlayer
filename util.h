#ifndef UTIL_H
#define UTIL_H

#include <QObject>
#include <QString>

class Util : public QObject
{
    Q_OBJECT
public:
    explicit Util(QObject *parent = 0);
    ~Util();
    Q_INVOKABLE QString readFile(QString filename);
    Q_INVOKABLE void saveFile(QString filename,QString content);
signals:

public slots:
};

#endif // UTIL_H
