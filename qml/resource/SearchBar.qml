import QtQuick 2.4
import QtQuick.Controls 1.3

//搜索条
Rectangle {
    width: 300
    height: 30
    radius: 15

    signal textCleared()
    signal keywordChanged(string keyword)
    signal beforeSearch(string keyword)
    signal textFocusOut();

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
                textCleared();
                return;
            }

            keywordChanged(text);
        }
        onFocusChanged: {
            if(!focus){
                textFocusOut();
            }
        }

        //编辑完成，按enter键
        onAccepted :toSearch()
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
            onClicked:  toSearch()
        }
    }

    //点击搜索按钮或按Enter
    function toSearch(){
        if(input.text == ""){
            return;
        }
        beforeSearch(input.text);
    }
}

