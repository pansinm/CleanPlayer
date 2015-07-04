QT       += quick qml network multimedia xml

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = CleanPlayer
TEMPLATE = app

SOURCES += \
    main.cpp \
    baidumusic.cpp \
    cookiejar.cpp \
    util.cpp

OTHER_FILES += \
    qml/PlayerControler.qml \
    qml/LyricView.qml \
    updatesummary.txt \
    qml/MainWindow.qml \
    qml/TopBar.qml

RESOURCES += \
    res.qrc \

HEADERS += \
    baidumusic.h \
    cookiejar.h \
    util.h

DISTFILES += \
    readme.md \
    qml/Main.qml \
    qml/resource/PlayButton.qml \
    qml/resource/PreviousButton.qml \
    qml/resource/SearchBar.qml \
    qml/resource/SearchResult.qml \
    qml/resource/Playlist.qml \
    qml/resource/PlaylistView.qml \
    qml/resource/TopBar.qml \
    qml/resource/Suggestion.qml \
    qml/resource/Container.qml \
    qml/resource/func.js \
    qml/resource/BottomBar.qml \
    qml/resource/SideBar.qml
