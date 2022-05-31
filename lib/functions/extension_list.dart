List<String> imageExtensions = [".apng", ".avif", ".gif", ".jpeg", ".jpg", ".png", ".svg", ".webp"];
List<String> videoExtensions = [".mp4", ".mov", ".avi", ".wmv", ".mkv", ".webm"];
List<String> audioExtensions = [".mp3", ".aac", ".ogg", ".flac", ".alac", ".wav", ".aiff", ".dsd", ".pcm"];
List<String> pdfExtensions = [".pdf"];
List<String> docExtension = [".doc", ".docx"];
List<String> pptExtension = [".ppt", ".pptx"];

String getFileType (String extension) {
  if (imageExtensions.contains(extension.toLowerCase())) {
    return "image";
  }
  else if (videoExtensions.contains(extension.toLowerCase())) {
    return "video";
  }
  else if (audioExtensions.contains(extension.toLowerCase())) {
    return "audio";
  }
  else if (pdfExtensions.contains(extension.toLowerCase())) {
    return "pdf";
  }
  else if (docExtension.contains(extension.toLowerCase())) {
    return "doc";
  }
  else if (pptExtension.contains(extension.toLowerCase())) {
    return "ppt";
  }
  else {
    return "unknown";
  }
}