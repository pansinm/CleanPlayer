import QtQuick 2.4
import CleanPlayerCore 1.0

//左侧栏
Rectangle {
    id: leftList
    width: 200
    color: "#555555"

    property Playlist playlist
    property Container container

    Component {
        id:leftListViewDelegate
        Item {
            width: 200
            height: 20
            Rectangle{
                anchors.fill: parent
                color:"gray"
                Text {
                    anchors.centerIn: parent
                    text:listname
                }

                MouseArea{
                    id:mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        leftListView.currentIndex = index;
                        container.updatePlaylist(listname);
                        container.showPlaylist();
                    }
                }
            }
        }
    }

    ListModel {
        id:leftListModel
    }

    ListView {
        id:leftListView
        anchors.fill: parent
        delegate: leftListViewDelegate
        model: leftListModel
        clip: true
        focus: true

        highlight:Component{
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

        header: Component {
            Item {
                width: 200
                height: 30
                Rectangle{
                    anchors.fill: parent
                    color:"white"
                    Text {
                        anchors.centerIn: parent
                        font.pixelSize:16
                        text:"播放列表"
                    }
                }
            }
        }
    }

    function update(){
        for(var i in playlist.playlists){
           leftListModel.append({"listname":i});
        }
        container.updatePlaylist("默认列表");
        container.showPlaylist();
    }
}


