QT       += quick qml network multimedia xml

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = CleanPlayer
TEMPLATE = app

SOURCES += \
    main.cpp \
    lyric.cpp \
    id3v1tags.cpp \
    playlist.cpp \
    musicinfo.cpp \
    network.cpp

QTPLUGIN += dsengine qtmedia_audioengine

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
    playlist.h \
    musicinfo.h \
    network.h

