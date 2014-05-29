QT       += quick qml network multimedia xml

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = CleanPlayer
TEMPLATE = app

SOURCES += \
    main.cpp \
    lyric.cpp \
    download.cpp \
    playengine.cpp \
    playlistmodel.cpp \
    id3v1tags.cpp

QTPLUGIN += dsengine qtmedia_audioengine

OTHER_FILES += \
    qml/PlayerControler.qml \
    qml/main.qml \
    qml/PlaylistDelegate.qml \
    qml/LyricView.qml \
    updatesummary.txt

RESOURCES += \
    res.qrc \

HEADERS += \
    lyric.h \
    download.h \
    playengine.h \
    playlistmodel.h \
    id3v1tags.h \
    id3v1tagsdef.h

