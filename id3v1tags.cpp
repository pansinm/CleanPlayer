#include<fstream>
#include<cstring>
#include<string>
#include<iostream>
#include<sstream>
#include<cstdlib>
#include "id3v1tags.h"
#include "id3v1tagsdef.h"
using namespace std;

ID3V1Tags::ID3V1Tags()
{
    memset(tagsInfo,0,128);
}

ID3V1Tags::~ID3V1Tags()
{

}

ID3V1Tags::ID3V1Tags(const string fileName)
{

    setFile(fileName);
}

bool ID3V1Tags::setFile(const string fileName )
{
    ifstream fin(fileName.c_str(),ios::binary);
    tagsFileName=fileName;
    if(!fin.is_open())
    {
       return false;
    }
    fin.seekg(-128,ios::end);
    fin.read(tagsInfo,sizeof(tagsInfo));
    fin.close();
    return true;

}

bool ID3V1Tags::isID3V1()
{
    if(tagsInfo[0]=='T'&&tagsInfo[1]=='A'&&tagsInfo[2]=='G')
    {
        return true;
    }
    else
        return false;
}

bool ID3V1Tags::save()
{
    char c[3];
    tagsInfo[0]='T';
    tagsInfo[1]='A';
    tagsInfo[2]='G';
    fstream f(tagsFileName.c_str(),ios::in|ios::out);
    if(!f.is_open())
        return false;
    f.seekg(-128,ios::end);
    f.read(c,3);
    if(c[0]=='T'&&c[1]=='A'&&c[2]=='G')
    {
        f.seekp(-128,ios::end);
        f.write(tagsInfo,sizeof(tagsInfo));
    }
    else
    {
        f.seekp(0,ios::end);
        f.write(tagsInfo,128);
    }
    f.close();
    return true;
}
string ID3V1Tags::getTitle()
{
    char tmp[30];
    for(int i=0;i<30;i++)
    {
        tmp[i]=tagsInfo[i+3];
    }

    string s;
    s.clear();
    s.append(tmp,30);
    s=removeEndOfSpace(s);
    return s;
}

string ID3V1Tags::getArtist()
{
    char tmp[30];
    for(int i=0;i<30;i++)
    {
        tmp[i]=tagsInfo[i+33];
    }

    string s;
    s.clear();
    s.append(tmp,30);
    s=removeEndOfSpace(s);
    return s;
}

string ID3V1Tags::getAlbum()
{

    char tmp[30];
    for(int i=0;i<30;i++)
    {
        tmp[i]=tagsInfo[i+33+30];
    }

    string s;
    s.clear();
    s.append(tmp,30);
    s=removeEndOfSpace(s);
    return s;
}

int ID3V1Tags::getYear()
{
    if(isID3V1())
    {
        char tmp[4];
        for(int i=0;i<4;i++)
        {
            tmp[i]=tagsInfo[i+33+30+30];
        }

        string s;
        s.clear();
        s.append(tmp,sizeof(tmp));
        return atoi(s.c_str());
    }
    else
        return -1;
}

string ID3V1Tags::getComment()
{
    char tmp[30];
    for(int i=0;i<30;i++)
    {
        tmp[i]=tagsInfo[i+97];
    }
    string s;
    s.clear();
    if(tmp[28]!=0)
    {
        s.append(tmp,28);
    }
    else
    {
        s.append(tmp,30);
    }
    s=removeEndOfSpace(s);
    return s;
}

unsigned int ID3V1Tags::getTrackID()
{
   unsigned char i=tagsInfo[126];

    if(i>0&&tagsInfo[125]==0)
        return i;
    else
        return 0;
}

string ID3V1Tags::getGenre()
{
    unsigned int i=tagsInfo[127];

    if(i>0&&i<148)
    {
       string s=Genre[i];
       s=removeEndOfSpace(s);
       return s;
    }

    return "NoGenre";
}

unsigned int ID3V1Tags::getGenreId()
{
    if(isID3V1())
    {
        unsigned char i=tagsInfo[127];
        return i;
    }
    else
        return 255;
}

void ID3V1Tags::setTitle(const string title)
{
    initTagInfo(3,30);
    for(unsigned int i=3;i<3+title.length();i++)
    {
         tagsInfo[i]=title[i-3];
         if(i==33)
            break;
    }

}

void ID3V1Tags::setArtist(const string artist)
{
    initTagInfo(33,30);
    for(unsigned int i=33;i<33+artist.length();i++)
    {
         tagsInfo[i]=artist[i-33];
         if(i==33+30)
            break;
    }
}

void ID3V1Tags::setAlbum(const string album)
{
    initTagInfo(63,30);
    for(unsigned int i=63;i<63+album.length();i++)
    {
         tagsInfo[i]=album[i-63];
         if(i==63+30)
            break;
    }
}

void ID3V1Tags::setYear(const int year)
{
    if(year<3000&&year>1000)
    {
        int y=year;
        stringstream ss;
        ss<<y;
        string str;
        ss>>str;
        for(int i=93;i<93+4;i++)
        {
            tagsInfo[i]=str[i-93];
        }
    }

}

void ID3V1Tags::setYear(const string year)
{
    if(year.length()==4)
    {
        for(int i=93;i<93+4;i++)
            tagsInfo[i]=year[i-93];
    }
}

void ID3V1Tags::setComent(const string coment)
{
    initTagInfo(97,28);
    for(unsigned int i=97;i<97+coment.length();i++)
    {
         tagsInfo[i]=coment[i-97];
         if(i==97+28)
            break;
    }
}

void ID3V1Tags::setTrackID(const int id)
{
    tagsInfo[125]=0;
    if(id<256)
        tagsInfo[126]=id;
}

void ID3V1Tags::setGenre(const int genre)
{
    if(genre<256)
        tagsInfo[127]=genre;
}

void ID3V1Tags::setGenre(const string genre)
{
    for(unsigned int i=0;i<sizeof(Genre);i++)
    {
        if(genre==Genre[i])
            tagsInfo[127]=i;
    }
}

string ID3V1Tags::removeEndOfSpace(string str)
{
    string s=str;
    for(int i=s.length();i>-1;i--)
    {
        if(s[i]==0||s[i]==' ')
        {
           s.erase(i);
           //cout<<i;
        }
        else break;
    }

    return s;
}

void ID3V1Tags::initTagInfo(int position ,int length)
{
    if(position>0&&length>0&&length<31&&position+length<128)
    {
        for(int i=position;i<position+length;i++)
            tagsInfo[i]=0;
    }
}

string ID3V1Tags::getFileName()
{
    return tagsFileName;
}
