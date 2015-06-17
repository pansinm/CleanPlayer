import QtQuick 2.4
import QtQuick.Controls 1.3

//搜索条
Rectangle {
    width: 300
    height: 30

    signal textCleared()
    signal keywordChanged(string keyword)
    signal beforeSearch(string keyword)
    signal textFocusOut();

    //输入框
    TextInput {
        id:input
        anchors.left: parent.left
        anchors.right: searchButton.left
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize:16
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
    Button {
        id:searchButton
        height: parent.height
        width: 50
        anchors.right: parent.right
        onClicked:  toSearch()
    }

    //点击搜索按钮或按Enter
    function toSearch(){
        if(input.text == ""){
            return;
        }
        beforeSearch(input.text);
    }
}

