#ifndef PLAYLIST_H
#define PLAYLIST_H
#include<QObject>
#include<QList>
#include<QUrl>
#include<QVariant>
#include<QString>
#include"musicinfo.h"


class Playlist:public QObject
{
    Q_OBJECT
public:
    Playlist(QObject* parent=0);
    enum PlayMode{Sequence,Random};
    Q_INVOKABLE void setPlayMode(PlayMode mode);

    Q_INVOKABLE PlayMode playMode() const;

    //currentMediaIndex设置为下一个
    Q_INVOKABLE void next();
    Q_INVOKABLE void previous();
    //返回json数据
    Q_INVOKABLE QVariant at(int i) const;

    //添加歌曲
    Q_INVOKABLE void append(MusicInfo* info);

    //添加歌曲
    Q_INVOKABLE void append(const QUrl& fileUrl);

    //清空列表
    Q_INVOKABLE void clear(){
        m_playlist.clear();
        emit cleared();
        emit changed();
        emit countChanged();
    }

    //移除一项
    Q_INVOKABLE void remove(const int index);

    //将m_playlist.at[index]信息完全替换
    Q_INVOKABLE void replace(const int index,const QVariant json);

    //更新信息
    Q_INVOKABLE void sync(const QVariant json);

    //加载列表文件
    Q_INVOKABLE void load(const QString& xmlFile);

    //保存列表文件
    Q_INVOKABLE void save(const QString& xmlFile) const;

    //列表含歌曲总数
    Q_INVOKABLE inline int count() const{
        return m_playlist.count();
    }

    //返回当前索引
    Q_INVOKABLE inline int currentMediaIndex() const{
        return m_currentMediaIndex;
    }

    //查询url所在位置，如果未匹配则返回-1
    Q_INVOKABLE int indexOf(const QUrl& url);
    //设置当前索引
    Q_INVOKABLE void setCurrentMediaIndex(const int index){
        if(index<0||index>=m_playlist.count()){
            return;
        }
        m_currentMediaIndex=index;
        emit changed();
        emit currentMediaIndexChanged();
    }

    //判断文件是否有效
    Q_INVOKABLE bool isLyricValid(const QUrl& lyricUrl);
    Q_INVOKABLE bool isCoverValid(const QUrl& coverUrl);

signals:
    void changed();
    void cleared();
    void inserted(int index);
    void removed(int index);
    void replaced(int index);
    void synchronized();
    void appended();
    void countChanged();
    void currentMediaIndexChanged();
private:
    QList<MusicInfo*> m_playlist;
    int m_currentMediaIndex;
    PlayMode m_playMode;
};

#endif // PLAYLIST_H
