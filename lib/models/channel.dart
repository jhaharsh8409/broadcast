class Channel {
  final String channelName;
  final String channelLogo;
  final String liveYoutubeLink;

  Channel({
    required this.channelName,
    required this.channelLogo,
    required this.liveYoutubeLink,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      channelName: json['channel_name'] ?? '',
      channelLogo: json['channel_logo'] ?? '',
      liveYoutubeLink: json['live_youtube_link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_name': channelName,
      'channel_logo': channelLogo,
      'live_youtube_link': liveYoutubeLink,
    };
  }
}


