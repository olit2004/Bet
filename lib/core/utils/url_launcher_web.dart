import 'dart:html' as html;

void openUrl(String url) {
  html.window.open(url, '_blank');
}

void downloadFile(String url, String fileName) {
  html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();
}
