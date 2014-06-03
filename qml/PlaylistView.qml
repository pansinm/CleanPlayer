import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
Rectangle {
    width: 180
    height: 320
    color:"#503d5869"
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
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                color:wraper.ListView.isCurrentItem ? "white":"#80a89f"
                text:title
                font.family: "微软雅黑"
                font.pointSize: 8
                styleColor: "#80a89f"
                verticalAlignment: Text.AlignVCenter

            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    topColor.color="#90ddfbf8";
                    bottomColor.color="#90a7f3ec";
                    removeBtn.visible=true;
                }
                onExited: {
                    topColor.color="#00000000";
                    bottomColor.color="#00000000";
                    removeBtn.visible=false;
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
                radius:12
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10
                visible: false
                gradient: Gradient {
                    GradientStop {
                        position: 0.00;
                        color: "#f39a9a";
                    }
                    GradientStop {
                        position: 1.00;
                        color: "#fb7171";
                    }
                }
                Text{
                    anchors.fill: parent
                    text:"x"
                    font.family: "微软雅黑"
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
    ScrollView{

        anchors.fill: parent


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
                        color: "#6995b1";
                    }
                    GradientStop {
                        position: 0.50;
                        color: "#5780a6";
                    }
                    GradientStop {
                        position: 1.00;
                        color: "#6995b1";
                    }
                }

                }
            decrementControl :Rectangle{
                color:"#803d5869"
                implicitWidth: 10
                implicitHeight: 10
            }
            incrementControl :Rectangle{
                color:"#803d5869"
                implicitWidth: 10
                implicitHeight: 0
            }
            scrollBarBackground :Rectangle{
                implicitWidth: 10
                implicitHeight: 150
                color:"#803d5869"
                GradientStop {
                    position: 0.00;
                    color: "#803d5869";
                }
                GradientStop {
                    position: 1.00;
                    color: "#802f4c62";
                }
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

        onCurrentMediaIndexChanged:{
            playlistView.currentIndex=playlist.currentMediaIndex();
        }
    }



}
