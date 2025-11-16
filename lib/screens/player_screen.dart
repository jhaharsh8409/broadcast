import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/channel.dart';

class PlayerScreen extends StatefulWidget {
  final Channel channel;

  const PlayerScreen({
    super.key,
    required this.channel,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  String? _extractVideoId(String youtubeUrl) {
    String? videoId;
    
    if (youtubeUrl.contains('youtube.com/live/')) {
      videoId = youtubeUrl.split('youtube.com/live/')[1].split('?')[0];
    } else if (youtubeUrl.contains('youtube.com/watch?v=')) {
      videoId = youtubeUrl.split('v=')[1].split('&')[0];
    } else if (youtubeUrl.contains('youtu.be/')) {
      videoId = youtubeUrl.split('youtu.be/')[1].split('?')[0];
    } else if (youtubeUrl.contains('youtube.com/embed/')) {
      videoId = youtubeUrl.split('youtube.com/embed/')[1].split('?')[0];
    }
    
    return videoId;
  }

  String _getMobileUrl(String youtubeUrl) {
    final videoId = _extractVideoId(youtubeUrl);
    
    if (videoId == null) {
      return youtubeUrl; // Fallback to original URL
    }
    
    // Use mobile YouTube URL for live streams
    if (youtubeUrl.contains('youtube.com/live/')) {
      return 'https://m.youtube.com/watch?v=$videoId';
    }
    
    return 'https://m.youtube.com/watch?v=$videoId';
  }

  @override
  void initState() {
    super.initState();
    
    // Lock orientation to landscape and enter fullscreen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    // Use mobile YouTube URL which works better in WebView
    final mobileUrl = _getMobileUrl(widget.channel.liveYoutubeLink);
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            
            // Inject JavaScript to hide everything except the video player
            _controller.runJavaScript('''
              (function() {
                // Hide all unnecessary elements
                var style = document.createElement('style');
                style.innerHTML = `
                  /* Hide header, navigation, comments, suggestions */
                  ytd-app,
                  #header,
                  #masthead,
                  #guide,
                  #secondary,
                  #comments,
                  ytd-watch-next-secondary-results-renderer,
                  ytd-item-section-renderer,
                  #related,
                  .ytp-chrome-top,
                  .ytp-chrome-bottom,
                  ytd-player-microformat-renderer,
                  ytd-video-primary-info-renderer,
                  ytd-video-secondary-info-renderer {
                    display: none !important;
                  }
                  
                  /* Make video player full screen */
                  body {
                    margin: 0 !important;
                    padding: 0 !important;
                    overflow: hidden !important;
                    background-color: #000 !important;
                  }
                  
                  #player,
                  #player-container,
                  #player-container-inner,
                  ytd-player {
                    position: fixed !important;
                    top: 0 !important;
                    left: 0 !important;
                    width: 100% !important;
                    height: 100vh !important;
                    z-index: 9999 !important;
                  }
                  
                  /* Make video element full screen */
                  video {
                    width: 100% !important;
                    height: 100% !important;
                    object-fit: contain !important;
                  }
                  
                  /* Hide scrollbars */
                  ::-webkit-scrollbar {
                    display: none !important;
                  }
                `;
                document.head.appendChild(style);
                
                // Try to find and maximize video player
                function maximizePlayer() {
                  var player = document.querySelector('#player, ytd-player, video');
                  if (player) {
                    player.style.position = 'fixed';
                    player.style.top = '0';
                    player.style.left = '0';
                    player.style.width = '100%';
                    player.style.height = '100vh';
                    player.style.zIndex = '9999';
                  }
                  
                  // Unmute video and enter fullscreen
                  var video = document.querySelector('video');
                  if (video) {
                    video.muted = false;
                    video.volume = 1.0;
                    
                    // Try to enter fullscreen
                    if (video.requestFullscreen) {
                      video.requestFullscreen().catch(function(err) {
                        console.log('Fullscreen error:', err);
                      });
                    } else if (video.webkitRequestFullscreen) {
                      video.webkitRequestFullscreen();
                    } else if (video.mozRequestFullScreen) {
                      video.mozRequestFullScreen();
                    }
                  }
                  
                  // Try to click play button if exists
                  var playButton = document.querySelector('.ytp-large-play-button, .ytp-play-button, [aria-label*="Play"], button[aria-label*="Play"]');
                  if (playButton && playButton.offsetParent !== null) {
                    setTimeout(function() {
                      playButton.click();
                    }, 500);
                  }
                  
                  // Try to unmute using YouTube player controls
                  var muteButton = document.querySelector('.ytp-mute-button, [aria-label*="Mute"], button[aria-label*="Mute"]');
                  if (muteButton) {
                    var isMuted = muteButton.getAttribute('aria-label') && muteButton.getAttribute('aria-label').toLowerCase().includes('unmute');
                    if (isMuted) {
                      setTimeout(function() {
                        muteButton.click();
                      }, 800);
                    }
                  }
                  
                  // Try to enter fullscreen using YouTube player button
                  var fullscreenButton = document.querySelector('.ytp-fullscreen-button, [aria-label*="Full screen"], button[aria-label*="Full screen"]');
                  if (fullscreenButton) {
                    setTimeout(function() {
                      fullscreenButton.click();
                    }, 1000);
                  }
                }
                
                // Run immediately and after delays
                maximizePlayer();
                setTimeout(maximizePlayer, 1000);
                setTimeout(maximizePlayer, 2000);
                setTimeout(maximizePlayer, 3000);
              })();
            ''');
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Allow YouTube navigation but prevent leaving YouTube
            if (request.url.contains('youtube.com') || 
                request.url.contains('youtu.be') ||
                request.url.contains('google.com')) {
              return NavigationDecision.navigate;
            }
            // Block external sites
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(mobileUrl));
  }
  
  @override
  void dispose() {
    // Restore orientation and system UI
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    // Clean up WebView resources
    _controller.loadRequest(Uri.parse('about:blank'));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Remove AppBar for fullscreen experience
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
          ),
        ),
        title: Text(
          widget.channel.channelName,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


