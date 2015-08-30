QT       += quick qml network multimedia xml

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = clean-player
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
    qml/TopBar.qml \
    data/clean-player.desktop \
    data/clean-player.png


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
    qml/resource/SideBar.qml \
    qml/resource/Lyric.qml

# icons
icons.files = data/clean-player.png

# desktop
desktop.files = data/clean-player.desktop

isEmpty(INSTALL_PREFIX) {
    unix: INSTALL_PREFIX = /usr
    else: INSTALL_PREFIX = ..
}

unix: {
    desktop.path = $$INSTALL_PREFIX/share/applications
    icons.path = $$INSTALL_PREFIX/share/icons/hicolor/64x64/apps
    INSTALLS += desktop icons
    QMAKE_STRIP=echo
}

target.path = $$INSTALL_PREFIX/bin

INSTALLS += target
