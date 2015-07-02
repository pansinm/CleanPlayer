##Clean Player
因为工作的原因，好久没有更新了。
从今天开始，将调整项目结构，完善注释，定期更新。

### dev分支
	
	git clone https://github.com/pansinm/CleanPlayer.git
	git checkout dev

###功能
1. 常规的播放和列表功能；
2. 自动在线匹配歌词和专辑封面；
3. 解析歌词.

***
###界面
![](http://img1.ph.126.net/sLleMK4sypQLGrVt3IO8xg==/755478837591581743.png)

![](http://img2.ph.126.net/a7R7jeCD7mFn80y_vD356Q==/1462262504112166748.png)

***
###百度音乐API
+ 搜索建议

        http://sug.music.baidu.com/info/suggestion?format=json&word=关键字&version=2&from=0&callback=函数名
+ 搜索（需要从html中截取有效信息）
    
        http://music.baidu.com/search?key=关键字&start=起始位置&size=20
        起始位置 =（当前页面数-1）× 20
+ 歌曲信息

        http://play.baidu.com/data/music/songinfo?songIds=歌曲id 或
        http://play.baidu.com/data/music/songinfo?songIds=id1,id2,id3
+ 歌曲链接

        http://play.baidu.com/data/music/songlink?songIds=歌曲id&type=m4a,mp3
***
###TODO
重构整个播放器，
现代的UI
在线播放
v1.0 Beta comming son!

***

###其他
1. 基于[QT5.2.1](http://qt-project.org/downloads)，遵守[LGPL协议](http://www.gnu.org/licenses/lgpl.html)；
2. 软件由QML结合C++编写而成，QML编写界面，C++编写网络、歌词解析、列表等模块；
3. 软件运行后会生成playlist.xml文件保存列表，cover文件夹保存下载的封面，lyric文件夹保存下载的歌词；
4. Clean Player[下载地址](http://pan.baidu.com/s/1bns3lld).
