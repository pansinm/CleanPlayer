#ifndef PLAYERCONTROLLER_H
#define PLAYERCONTROLLER_H

#include <QObject>

class SongInfo{
   public:
    QString songId;
    QString songName;
    QString singer;
    QString albumName;
    QString albumPic;
    QString songLink;
    QString origin;
    QString localSongPath;
    QString lyricLink;
    QString localLyricPath;
    int size;
    int time;
};

/**
 * @brief The PlayerController class
 */
class PlayerController : public QObject
{
    Q_OBJECT
public:
    explicit PlayerController(QObject *parent = 0);
    ~PlayerController();
    void switchTo();
    void next();
    void prev();
    
    /**
     * @brief setVolume 设置音量
     * @param vol 音量0~100
    */
    void setVolume(int vol);
    
    /**
     * @brief querySongInfo 查找歌曲信息，包括下载链接
     * @param songId	
     */
    void querySongInfo(QString songId);
    
    /**
     * @brief querySongId 根据歌曲名查找歌曲的songId
     * @param songName
     * @param singer
     */
    void querySongId(QString songName,QString singer);
    
    /**
     * @brief downloadSong 下载歌曲
     * @param songId
     */
    void downloadSong(QString songId);
private:
    QList<SongInfo> playlist;

signals:

public slots:
};

#endif // PLAYERCONTROLLER_H
