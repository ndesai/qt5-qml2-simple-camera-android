import QtQuick 2.0
import QtMultimedia 5.0 as Multimedia
Rectangle {
    width: 1080
    height: 1920
    color: "#00FEAA"
    Multimedia.Camera {
        id: _Camera
        captureMode: Multimedia.Camera.CaptureStillImage
        imageCapture {
            onImageCaptured: {
                console.log("image captured with preview="+preview);
                _Image_PhotoPreview.source = preview
            }
            onCaptureFailed: {
                console.log("capture failed with error " + message);
            }
            onImageMetadataAvailable: {
                console.log("image metadata available with key = " + key + " & value = " + value);
            }
            onImageSaved: {
                console.log("image saved with path " + path);
                console.log("image saved with resolved path (incorrect, returns asset://) " + Qt.resolvedUrl(path));
                console.log("image saved with forged path " + "file://" + path);
                _Image_PhotoPreview.source = "file://" + path

            }
        }
    }
    Multimedia.VideoOutput {
        id: _VideoOutput // ViewFinder
        visible: true
        width: parent.width
        height: parent.height/2
        source: _Camera
        orientation: 270
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("mousearea clicked")
            _Camera.imageCapture.capture();
        }
    }
    Rectangle {
        width: parent.width
        height: parent.height/2
        anchors.bottom: parent.bottom
        color: "#FF0000"
        clip: true
        Flickable {
            id: _Flickable
            anchors.fill: parent
            contentWidth: _Image_PhotoPreview.sourceSize.width
            contentHeight: _Image_PhotoPreview.sourceSize.height
            Image {
                id: _Image_PhotoPreview
                scale: 0.5
                fillMode: Image.PreserveAspectFit
                PinchArea {
                    anchors.fill: parent
                    pinch.target: _Image_PhotoPreview
                    enabled: true
                    pinch.minimumScale: 0.35
                    pinch.maximumScale: 2.0

                }
            }
        }
    }
}
