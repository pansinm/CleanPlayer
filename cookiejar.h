#ifndef COOKIEJAR_H
#define COOKIEJAR_H

#include <QObject>
#include <QNetworkCookieJar>
#include <QNetworkCookie>

class CookieJar : public QNetworkCookieJar
{
public:
    CookieJar();
    ~CookieJar();

    QList<QNetworkCookie> getCookies();
    void setCookies(const QList<QNetworkCookie>& cookieList);
};

#endif // COOKIEJAR_H
