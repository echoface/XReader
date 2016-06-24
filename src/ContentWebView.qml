import QtQuick 2.0
import QtWebEngine 1.2
import QtQuick.Controls 1.4

import "readability.js" as Reader

WebEngineView {
    signal wv_fullview_clicked();
    //signal articleClicked(var model_instance)
    property alias weburl: web_view.url
    property alias zoomfactor: web_view.zoomFactor

    id: web_view
    visible: true
    objectName: "webview"
    anchors.fill: parent
    url: "https://huangong.gitbooks.io/art_as_programer/content/program_project/the_x-th_project_xreader.html"
    zoomFactor: 1
    onLoadProgressChanged: {
        if (loadProgress > 79) {
            busyIndicator.running = false;
            //scheduleZoom();
        }
    }
    onLoadingChanged: {
        console.log("loading changed.....")
        busyIndicator.running = loading;
    }

    Component.onCompleted: {
        web_view.settings.pluginsEnabled = false;
        web_view.settings.javascriptEnabled = false;
        web_view.settings.javascriptCanOpenWindows = false;
        web_view.settings.spatialNavigationEnabled = false;
    }

    BusyIndicator{
        id: busyIndicator
        z: 2; running: true
        anchors.centerIn: parent
    }

    Rectangle {
        property real itemsize: 16

        id: wv_lens; z: 2
        width: itemsize; height: itemsize*4;
        opacity: 0.85; radius: 2; clip: true;
        anchors.top: parent.top; anchors.topMargin: 4;
        anchors.right: parent.right; anchors.rightMargin: 12;

        Column {
            spacing: 1
            Image {
                id: img_view_max;
                width: wv_lens.itemsize; height: width
                source: "qrc:/image/icon/view-fullscreen.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {wv_fullview_clicked();}
                }
            }
            Image {
                id: reader;width: wv_lens.itemsize; height: width
                source: "qrc:/image/icon/ReadMode.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("reader mode fucked")
                        var reader = new Reader.Readability();
                        reader.readabilityGet(web_view.url,
                                              onGetReadabilityData,
                                              onReadabilityGetErr)
                    }
                }
            }
            Image {
                id: zoom_in;
                width: wv_lens.itemsize; height: width
                source: "qrc:/image/icon/smaller.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        web_view.zoomFactor -= 0.1
                    }
                }
            }
            Image {
                id: zoom_out;
                width: wv_lens.itemsize; height: width
                source: "qrc:/image/icon/lager.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        web_view.zoomFactor += 0.1
                        console.log("reader mode fucked")
                    }
                }
            }
        }
    }

    Timer {
        id: timer
        interval: 1000; running: false; repeat: false;
        onTriggered: {
            web_view.runJavaScript("document.body.style.zoom="+zoom_size.value, function(result) { console.log(result); });
        }
    }
    function scheduleZoom() {
        if (timer.running == true) {
            timer.restart();
        } else {
            timer.start();
        }
    }

    function sidebarVisibilityChanged(visible) {
        img_view_max.source = visible ? "qrc:/image/icon/view-fullscreen.png"
                                      : "qrc:/image/icon/view-restore.png"
    }

    function iswebview() {return true;}

    function loadUrl(url) {web_view.url = url;}

    function loadFromHtmlString(html, baseUrl) {web_view.loadHtml(html, baseUrl);}

    function onGetReadabilityData(res, data) {
        console.log("get get get get get ......")
        web_view.loadFromHtmlString(data.content, web_view.url)
    }

    function onReadabilityGetErr(res, status) {
        console.log("readability parse error......")
    }

}
