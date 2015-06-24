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
    playlist.cpp \
    cookiejar.cpp \
    util.cpp

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
    playlist.h \
    cookiejar.h \
    util.h

DISTFILES += \
    readme.md \
    qml/Main.qml \
    qml/resource/PlayButton.qml \
    qml/resource/PreviousButton.qml \
    qml/resource/NextButton.qml \
    qml/LeftList.qml \
    qml/resource/SearchBar.qml \
    qml/resource/SearchResult.qml \
    qml/resource/Playlist.qml

