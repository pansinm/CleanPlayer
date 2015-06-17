import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
Rectangle {
    width: 180
    height: 350
    color:bkgColor

    //列表头，添加删除等
    Rectangle {
        id:listViewHeader
        height: 24
        width: parent.width
        radius: 3
        clip:true
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        color:"#80d9d9d9"
        property bool isScrolled: false

        Rectangle{
            id:clearListBtn
            width: 24
            height: 24
            radius: 3
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            color:"#00000000"
            Image{
                anchors.centerIn: parent
                //播放列表展开和收缩时绑定不同的图标
                source:"qrc:/image/image/clear.png"
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.color="#50d6c2b9"

                }
                onExited: {
                    parent.color="#00000000"
                }

                onClicked: playlist.clear()
            }

        }

        Text{
            anchors.centerIn: parent
            color: "#ffffff"
            text:"播放列表"
            font.family: "微软雅黑"
            font.pointSize: 10
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }



        Rectangle{
            id:addMusicBtn
            width: 24
            height: 24
            anchors.top: parent.top
            anchors.left: parent.left
            color: "#00000000"
            radius: 3
            Image {
                id: addImg
                anchors.centerIn: parent
                source: "qrc:/image/image/add.png"
            }


            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.color="#50d6c2b9"

                }
                onExited: {
                    parent.color="#00000000"
                }

                onClicked: fileDialog.open()
            }
        }



    }

    ListModel{
        id:playlistModel
    }

    Component{
        id:playlistDelegate
        Rectangle{
            id:wraper
            width:180
            height:30
            radius:3

            //border.color: "#90909090"
            property bool isEntered: false

            gradient: Gradient {
                GradientStop {
                    id:topColor
                    position: 0.00;
                    color:"#00000000"
                }
                GradientStop {
                    id:bottomColor
                    position: 1.00;
                    color: "#00000000"
                }
            }

            Text{
                id:titleTxt
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                color:wraper.ListView.isCurrentItem? "white":"#90ffffff"
                text:title
                font.family: "微软雅黑"
                font.pointSize: 8
                styleColor: "#80a89f"
                verticalAlignment: Text.AlignVCenter

            }

            MouseArea{
                id:mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    topColor.color= "#20ffffff";;
                    bottomColor.color="#30ffffff";
                    removeBtn.visible=true;
                    wraper.isEntered=true
                }
                onExited: {
                    topColor.color="#00000000";
                    bottomColor.color="#00000000";
                    removeBtn.visible=false;
                    wraper.isEntered=false
                }
                onClicked:{
                    playlist.setCurrentMediaIndex(index);
                    player.play();
                }
            }

            Rectangle{
                id:removeBtn
                height: 24
                width: 24
                radius:3
                border.width: 1
                border.color: "#20202020"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10
                visible: false
                gradient: Gradient {
                    GradientStop {
                        position: 0.00;
                        color: "#80ff0000";
                    }
                    GradientStop {
                        position: 1.00;
                        color: "#90ff0000";
                    }
                }
                Text{
                    anchors.fill: parent
                    text:"×"
                    font.family: "微软雅黑"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        playlist.remove(index)
                    }
                }
            }

            ListView.onRemove: SequentialAnimation {
                PropertyAction { target: wraper; property: "ListView.delayRemove"; value: true }
                NumberAnimation { target: wraper; property: "height"; to: 0; duration: 250; easing.type: Easing.InOutQuad }

                // Make sure delayRemove is set back to false so that the item can be destroyed
                PropertyAction { target: wraper; property: "ListView.delayRemove"; value: false }
            }

        }

    }

    Component{
        id:highlight
        Rectangle{
            radius:3
            gradient: Gradient {
                GradientStop {
                    position: 0.00;
                    color: "#80a9ccf3";
                }
                GradientStop {
                    position: 1.00;
                    color: "#808abae6";
                }
            }

        }
    }
    ScrollView{
        width: parent.width
        height: parent.height-listViewHeader.height
        anchors.top:listViewHeader.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        clip:true
        ListView{
            id:playlistView
            width: parent.width
            height: parent.height-listViewHeader.height
            anchors.centerIn: parent
            clip: true
            focus: true
            model:playlistModel
            delegate: playlistDelegate
            highlight:highlight
            highlightFollowsCurrentItem: true
            highlightMoveDuration:150

        }

        style: ScrollViewStyle{
            handleOverlap:0
            minimumHandleLength : 20
            handle : Rectangle{
                //color: "#f08080"
                implicitWidth: 10
                //implicitHeight: 20
                radius:2
                gradient: Gradient {
                    GradientStop {
                        position: 0.00;
                        color: "#40000000";
                    }
                    GradientStop {
                        position: 1.0;
                        color: "#50000000";
                    }

                }

                }
            decrementControl :Rectangle{
                color:"#303d5869"
                implicitWidth: 10
                implicitHeight: 0
            }
            incrementControl :Rectangle{
                color:"#303d5869"
                implicitWidth: 10
                implicitHeight: 0
            }
            scrollBarBackground :Rectangle{
                implicitWidth: 10
                implicitHeight: 150
                color:"#20ffffff"
            }
        }
    }
    Connections{
        target: playlist
        onCleared:{
            playlistModel.clear();
        }

        onAppended:{
            var obj = JSON.parse(playlist.at(playlist.count()-1));
            playlistModel.append(obj);
            console.log("playlistView:appended"+obj.url);
        }

        onRemoved:{
            playlistModel.remove(index);
        }

        onReplaced:{
            var obj = JSON.parse(playlist.at(index));
            playlistModel.set(index,obj);
        }

        onLoaded:{
            for(var i=0;i<playlist.count();i++){
                var obj = JSON.parse(playlist.at(i));
                playlistModel.append(obj);
            }
            playlistView.currentIndex=playlist.currentMediaIndex();
        }

        onCurrentMediaIndexChanged:{
            console.log("currentchanged");
            playlistView.currentIndex=playlist.currentMediaIndex();
        }
    }



}
