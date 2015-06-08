#include "cookiejar.h"

CookieJar::CookieJar()
{

}

CookieJar::~CookieJar()
{

}

QList<QNetworkCookie> CookieJar::getCookies()
{
    return allCookies();
}

void CookieJar::setCookies(const QList<QNetworkCookie> &cookieList)
{
    setAllCookies(cookieList);
}

