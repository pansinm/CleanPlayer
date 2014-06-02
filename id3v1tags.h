
#ifndef ID3V1Tags_H
#define ID3V1Tags_H
#include<iostream>
#include<string>
using namespace std;

class ID3V1Tags
{
public:
    ID3V1Tags();

    ~ID3V1Tags();
    //普通构造函数

    //如果打开成功并获取TAGS则返回true
    ID3V1Tags(const string fileName);

    //判断是否含有ID3V1 tags信息
    bool isID3V1();

    //如果打开成功并获取TAGS则返回true
    bool setFile(const string fileName);


    //获取信息
    string getTitle();

    string getArtist();

    string getAlbum();

    int getYear();

    string getComment();

    //如果coment占30位则返回-1
    unsigned int getTrackID();

    string getGenre();

    unsigned int getGenreId();

    //设置到tagsInfo
    void setTitle(const string title);

    void setArtist(const string artist);

    void setAlbum(const string album);

    void setYear(const int year);

    void setYear(const string year);

    void setComent(const string coment);

    void setTrackID(const int id);

    void setGenre(const int genre);

    void setGenre(const string genre);

    //保存标签
    bool save();

    string getFileName();

private:

    string tagsFileName;

    //如果过为false则在文件末尾增加设置的tags；

    char tagsInfo[128];

    //移除无效字符；
    string removeEndOfSpace(string str);

    //初始化，制定位置后指定长度设0；
    void initTagInfo(int position,int length);
};

#endif // ID3V1Tags_H
