import QtQuick 2.0

Rectangle {
    width: 180
    height: 320
    color:"#00000000"
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
            border.color: "#90909090"

            gradient: Gradient {
                GradientStop {
                    id:topColor
                    position: 0.00;
                    color:"#906d7e79"
                }
                GradientStop {
                    id:bottomColor
                    position: 1.00;
                    color: "#906d7e79"
                }
            }

            Text{
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                color:wraper.ListView.isCurrentItem ? "white":"black"
                text:title
                font.family: "微软雅黑"
                font.pointSize: 8
                styleColor: "black"
                verticalAlignment: Text.AlignVCenter

            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    topColor.color="#ddfbf8";
                    bottomColor.color="#a7f3ec";
                    removeBtn.visible=true;
                }
                onExited: {
                    topColor.color="#906d7e79";
                    bottomColor.color="#906d7e79";
                    removeBtn.visible=false;

                }
                onDoubleClicked:{
                    playlist.setCurrentMediaIndex(index);
                    player.play();
                }
            }

            Rectangle{
                id:removeBtn
                height: 26
                width: 48
                radius:3
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 3
                visible: false
                gradient: Gradient {
                    GradientStop {
                        position: 0.00;
                        color: "#e6b5b6";
                    }
                    GradientStop {
                        position: 1.00;
                        color: "#f55c5c";
                    }
                }
                Text{
                    anchors.fill: parent
                    text:"移除"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    styleColor: "#b59d9d"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        playlist.remove(index)
                    }
                }
            }
            ListView.onAdd: SequentialAnimation {
                PropertyAction { target: wraper; property: "height"; value: 0 }
                NumberAnimation { target: wraper; property: "height"; to: 30; duration: 250; easing.type: Easing.InOutQuad }
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
                    color: "#a9ccf3";
                }
                GradientStop {
                    position: 1.00;
                    color: "#579ff1";
                }
            }

        }
    }

    ListView{
        id:playlistView
        anchors.fill: parent
        clip: true
        focus: true
        model:playlistModel
        delegate: playlistDelegate
        highlight:highlight
        highlightFollowsCurrentItem: true
        highlightMoveDuration:150

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

        onCurrentMediaIndexChanged:{
            playlistView.currentIndex=playlist.currentMediaIndex();
        }
    }

}
