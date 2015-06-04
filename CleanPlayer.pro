QT       += quick qml network multimedia xml

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = CleanPlayer
TEMPLATE = app

SOURCES += \
    main.cpp \
    lyric.cpp \
    id3v1tags.cpp \
    musicinfo.cpp \
    network.cpp \
    baidumusic.cpp \
    playercontroller.cpp \
    playlist_old.cpp \
    playlist.cpp \
    songinfo.cpp

OTHER_FILES += \
    qml/PlayerControler.qml \
    qml/LyricView.qml \
    updatesummary.txt \
    qml/MainWindow.qml \
    qml/TopBar.qml \
    qml/PlaylistView.qml \
    qml/DisplayRegion.qml

RESOURCES += \
    res.qrc \

HEADERS += \
    lyric.h \
    id3v1tags.h \
    id3v1tagsdef.h \
    musicinfo.h \
    network.h \
    baidumusic.h \
    playercontroller.h \
    playlist_old.h \
    playlist.h \
    songinfo.h

DISTFILES += \
    readme.md

