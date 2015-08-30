import QtQuick 2.4
import CleanPlayerCore 1.0

//顶部栏
Rectangle {
    width: parent.width
    height: 60
    color: "#444"
    property Suggestion suggestion
    property BaiduMusic baiduMusic
    //左上角
    Rectangle {
        id: brand
        width: 200
        height: parent.height
        anchors.top: parent.top
        anchors.left: parent.left
        color:"#333"
        Text {
            id: brandText
            font.pixelSize:28
            color: "#eee"
            text: qsTr("CleanPlayer")
            anchors.centerIn: parent
        }
    }
    //搜索条
    Rectangle {
        width: 300
        height: 28
        radius: 14

        anchors.left: brand.right
        anchors.leftMargin: 15
        anchors.verticalCenter: parent.verticalCenter


        //输入框
        TextInput {
            id:input
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.right: searchButton.left
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize:15
            clip: true

            //输入改变
            onTextChanged:{
                if(text === ""){
                    suggestion.hide();
                    return;
                }
               baiduMusic.getSuggestion(text)
            }

            onFocusChanged: {
                if(!focus){
                    suggestion.hide();
                }
            }

            //编辑完成，按enter键
            onAccepted :{
                search();
            }
        }

        //搜索按钮
        Rectangle {
            id:searchButton
            height: 20
            width: 20
            anchors.right: parent.right
            anchors.rightMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            Image {
                id: searchIcon
                anchors.fill: parent
                source: "qrc:/image/image/search.png"
            }
            MouseArea{
                anchors.fill: parent
                onClicked:  search()
            }
        }
    }

    //边条
    Rectangle {
        width: parent.width
        height: 2
        color: "#E61E16"
        anchors.bottom: parent.bottom
    }

    //点击搜索按钮或按Enter
    function search(){
        if(input.text == ""){
            return;
        }
        baiduMusic.search(input.text,1);
        suggestion.hide();
    }
}


