import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';
import '../Model/FetchmesgsModel.dart';
import '../Model/RoomsDetailsModel.dart';
import '../Providers/ThemeProvider.dart';
import '../Services/UserApi.dart';
import '../utils/CustomAppBar.dart';
import '../utils/Preferances.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import 'UserProfile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'VideoPlayerScreen.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  final String ID;
  ChatPage({required this.roomId, required this.ID});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  late IOWebSocketChannel _socket;
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
  bool _isRecording = false;
  bool _isCancelled = false;
  bool _isPlaying = false;
  int _recordingTime = 0; // in seconds
  Timer? _timer;
  String? _recordedFilePath;
  Uint8List? bytes;

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isPickerVisible = false;

  bool _isConnected = false;
  bool _isLoadingMore = false; // Track loading state for more messages
  String user_id = "";
  String user_type = "";
  int _currentPage = 0;
  String last_msg_id = "";

  String username = "";
  String userimage = "";
  String userID = "";

  bool isLoading = true;
  final spinkits = Spinkits1();

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
    RoomDetailsApi();
    _animationController = AnimationController(
      vsync: this,
      duration:
          Duration(milliseconds: 500), // Total duration of both animations
    );

    // Slide Animation: From right to left
    _slideAnimation = Tween<Offset>(
      begin: Offset(1.5, 0), // Start position: off-screen to the right
      end: Offset(0, 0), // End position: aligned with the text field
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Fade Animation: From invisible to visible
    _fadeAnimation = Tween<double>(
      begin: 0.0, // Start opacity: invisible
      end: 1.0, // End opacity: fully visible
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    await Permission.microphone.request();
    await _audioRecorder.openRecorder();
    await _audioPlayer.openPlayer();
  }
  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';

      await _audioRecorder.startRecorder(toFile: filePath);

      // Update UI state
      setState(() {
        _isRecording = true;
        _recordedFilePath = filePath;
        _recordingTime = 0; // Reset recording time
      });

      // Start the timer
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _recordingTime++;
        });
      });
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    print("Called _stopRecording");
    try {
      final filePath = await _audioRecorder.stopRecorder();
      _timer?.cancel(); // Stop the timer safely

      // Update UI state
      setState(() {
        _isRecording = false;
        _recordedFilePath = filePath;
      });
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }
  // Play recorded audio
  Future<void> _playAudio(String path) async {
    setState(() {
      _isPlaying = true;
    });
    // Play the recorded audio
    await _audioPlayer.startPlayer(
      fromURI: path,
      whenFinished: () {
        setState(() {
          _isPlaying = false;
        });
      },
    );
  }

  List<Messages> _messages = [];

  Future<void> RoomDetailsApi() async {
    var res = await Userapi.getrommsdetailsApi(widget.roomId);
    setState(() {
      if (res != null && res.settings?.success == 1) {
        // Assign the messages and reverse the list
        _messages = (res.data?.messages ?? []).reversed.toList();

        if (_messages.isNotEmpty) {
          last_msg_id = _messages[0].id ?? "";
        }

        // Decode the msg field if necessary (to handle emoji/character encoding issues)
        _messages = _messages.map((msg) {
          msg.msg = decodeEmojiMessage(msg.msg ?? "");
          return msg;
        }).toList();

        username = res.data?.userName ?? "";
        userimage = res.data?.userImage ?? "";
        userID = res.data?.id ?? "";
        user_id = res.data?.userId ?? "";

        print("USERID :${userID}");
        isLoading = false;
        // Scroll to the bottom after messages are loaded
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      } else {
        isLoading = false;
        print('Failed to create room');
      }
    });
  }

  List<XFile> _selectedFiles = [];
  final picker = ImagePicker(); // For Camera functionality

// Unified media picker function for Camera and Gallery
  Future<void> _pickMedia({bool isCamera = false}) async {
    try {
      if (isCamera) {
        // Camera - Single Image Capture
        final XFile? capturedFile =
            await picker.pickImage(source: ImageSource.camera);
        if (capturedFile != null) {
          setState(() {
            _selectedFiles = [capturedFile]; // Single captured file
          });
          uploadFiles(); // Pass to upload function
        } else {
          print("No image captured.");
        }
        return;
      }

      // Gallery - Pick both images and videos
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.media, // Allow both images and videos
        allowMultiple: true, // Allow selecting multiple files
      );

      if (result != null) {
        setState(() {
          _selectedFiles =
              result.files.map((file) => XFile(file.path!)).toList();
        });
        uploadFiles(); // Pass to upload function
      } else {
        print("No media selected.");
      }
    } catch (e) {
      print("Error picking media: $e");
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.isNotEmpty) {
      // Process the selected document
      _selectedFiles = result.files.map((file) => XFile(file.path!)).toList();
      uploadFiles(); // Pass to upload function
      print("Selected Document Path: ${result.files.first.path}");
    }
  }

  // Call the API to upload files
  Future<void> uploadFiles() async {
    try {
      var res = await Userapi.uploadFilesAsMultipart(userID, _selectedFiles);
      if (res.statusCode == 200) {
        // Success
        setState(() {
          _selectedFiles = [];
        });
        print("Files uploaded successfully!");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Files uploaded successfully!')));
      } else {
        // // Failure
        setState(() {
          _selectedFiles = [];
        });
        print("Failed to upload files");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload files')));
      }
    } catch (e) {
      // print('Error uploading files: $e');
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
    }
  }

  String decodeEmojiMessage(String message) {
    try {
      // Manually decode the incorrectly encoded emojis (if necessary)
      return utf8.decode(message.codeUnits);
    } catch (e) {
      // If decoding fails, return the original message
      return message;
    }
  }

  Future<void> _fetchMessages() async {
    print('Fetching messages for page $_currentPage...');
    var res = await Userapi.fetchroommessages(widget.roomId, last_msg_id);

    if (res != null && res.settings?.success == 1) {
      print('Messages fetched successfully');
      // Assuming res.data is List<Message>
      List<Message> fetchedMessages =
          res.data ?? []; // Ensure it's a List<Message>
      setState(() {
        // Convert List<Message> to List<Messages>
        List<Messages> convertedMessages = fetchedMessages.map((msg) {
          return Messages(
            id: msg.id,
            sentUser: msg.sentUser,
            msg: msg.msg,
            lastUpdated: msg.lastUpdated,
            unixTimestamp: msg.unixTimestamp,
            isRead: msg.isRead,
          );
        }).toList();

        _messages.insertAll(0, convertedMessages); // Prepend new messages

        if (_messages.isNotEmpty) {
          last_msg_id =
              _messages[0].id ?? ""; // Update last_msg_id if messages exist
        }
      });
    } else {
      print('Failed to fetch messages');
    }
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels == 0 &&
        !_isLoadingMore) {
      _loadMoreMessages(); // Load more messages when scrolled to top
    }
  }

  Future<void> _loadMoreMessages() async {
    setState(() {
      _isLoadingMore = true;
    });

    await _fetchMessages(); // Fetch next page of messages

    setState(() {
      _isLoadingMore = false; // Reset loading state
    });
  }

  @override
  void dispose() {
    print('Disposing WebSocket and cleaning up resources...');
    _socket.sink.close();
    _messageController.dispose();
    _scrollController.dispose();
    _timer?.cancel();
    _audioRecorder.closeRecorder();
    _audioPlayer.closePlayer();
    super.dispose();
  }

  void _initializeWebSocket() async {
    final token = await PreferenceService().getString("token");
    print('Attempting to connect to WebSocket...');
    _socket = IOWebSocketChannel.connect(Uri.parse(
        'wss://stage.skil.in/ws/chat/${widget.roomId}?token=${token}'));
    print(
        'Connected to WebSocket at: wss://stage.skil.in/ws/chat/${widget.roomId}?token=${token}');
    setState(() {
      _isConnected = true;
    });

    _socket.stream.listen(
      (message) {
        print('Message received: $message');
        try {
          final decodedMessage = jsonDecode(message);
          print('Decoded message: $decodedMessage');
          Messages newMessage = Messages.fromJson(decodedMessage['data']);
          // Reset message count for the specific room
          setState(() {
            _messages.add(newMessage);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom(); // Keep scrolling down to latest message
            });
          });
        } catch (e) {
          print('Error processing message: $e');
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
        setState(() {
          _isConnected = false;
        });
      },
      onDone: () {
        print('WebSocket connection closed. Trying to reconnect...');
        setState(() {
          _isConnected = false;
        });
        _reconnectWebSocket();
      },
    );
  }

  // void _scrollToBottom() {
  //   if (_scrollController.hasClients) {
  //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  //   }
  // }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      // Get the maximum scroll extent to check if it's scrollable
      double maxScroll = _scrollController.position.maxScrollExtent;

      // Only scroll if there's content to scroll to
      if (maxScroll > 0) {
        _scrollController.animateTo(
          maxScroll,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _reconnectWebSocket() {
    Future.delayed(Duration(seconds: 5), () {
      print('Reconnecting to WebSocket...');
      _initializeWebSocket();
    });
  }

  void _sendMessage() {
    String message = _messageController.text;
    if (message.isNotEmpty && _isConnected) {
      print('Sending message: $message');

      try {
        final payload = jsonEncode(
            {'command': 'new_message', 'message': message, 'user': widget.ID});
        print("Payload :${payload}");
        _socket.sink.add(payload);
      } catch (e) {
        print('Error sending message: $e');
      }
      _messageController.clear();
    } else {
      print('Socket not connected or message is empty');
    }
  }

  void _togglePickerVisibility() {
    setState(() {
      _isPickerVisible = !_isPickerVisible;
    });

    if (_isPickerVisible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _openImageViewer(
      BuildContext context, List<Media> media, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewGallery.builder(
          itemCount: media.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(media[index].file ?? ''),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered,
            );
          },
          scrollPhysics: BouncingScrollPhysics(),
          backgroundDecoration: BoxDecoration(
            color: Colors.black,
          ),
          pageController: PageController(
              initialPage: initialIndex), // Start from the selected index
        ),
      ),
    );
  }

  Future<void> _openDocument(BuildContext context, Media mediaItem) async {
    final filePath = mediaItem.file;
    if (filePath == null || filePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid file path')),
      );
      return;
    }

    final Uri fileUri = Uri.parse(filePath);
    if (await canLaunchUrl(fileUri)) {
      await launchUrl(fileUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No application found to open the PDF')),
      );
    }
  }

  // Helper function to get the file extension
  String getFileExtension(String? url) {
    if (url != null) {
      return url.split('.').last.toLowerCase();
    }
    return '';
  }

  String? _getFileNameWithExtension(String? filePath) {
    if (filePath == null || filePath.isEmpty) return null;

    // Extract the file name with extension
    final segments = Uri.parse(filePath).pathSegments;
    return segments.isNotEmpty ? segments.last : null;
  }

  Widget _buildMessageBubble(
      String message, String sender, String datetime, List<Media>? media) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isMe = sender == 'you';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: ClipOval(
                  child: Image.network(
                    userimage,
                    width: 35,
                    height: 35,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(width: 8),

            // Message Container
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe
                    ? themeProvider.themeData == lightTheme
                        ? Color(0xffEAE1FF)
                        : themeProvider.containerColor
                    : themeProvider.themeData == lightTheme
                        ? Color(0xffffffff)
                        : themeProvider.containerColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: isMe ? Radius.circular(15) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Display the message text
                  if (message.isNotEmpty)
                    Text(
                      message,
                      style: TextStyle(
                          color: themeProvider.textColor, fontFamily: "Inter"),
                    ),

                  // Handle media
                  // Your existing media rendering logic
                  if (media != null && media.isNotEmpty) ...[
                    // Single Media Item
                    if (media.length == 1) ...[
                      // Check for images
                      if (getFileExtension(media[0].file) == 'jpg' ||
                          getFileExtension(media[0].file) == 'jpeg' ||
                          getFileExtension(media[0].file) == 'png' ||
                          getFileExtension(media[0].file) == 'gif') ...[
                        // Render Image (including GIF)
                        GestureDetector(
                          onTap: () => _openImageViewer(context, media, 0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              imageUrl: media[0].file ?? "",
                              width: 150,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (BuildContext context, String url) {
                                return Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: spinkits.getSpinningLinespinkit(), // Maintain consistency
                                  ),
                                );
                              },
                              errorWidget: (BuildContext context, String url, dynamic error) {
                                return Container(
                                  width: 48, // Matches image size
                                  height: 48, // Matches image size
                                  color: Colors.grey.shade300, // Placeholder background
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.red.shade700, // Error icon styling
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ]

                      // Check for videos
                      else if (getFileExtension(media[0].file) == 'mp4' ||
                          getFileExtension(media[0].file) == 'mov' ||
                          getFileExtension(media[0].file) == 'avi') ...[
                        GestureDetector(
                          onTap: () {
                            // Navigate to the Video Player Screen when tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                  videoUrl:
                                      media[0].file ?? '', // Pass the video URL
                                ),
                              ),
                            );
                          },
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              clipBehavior: Clip.hardEdge,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: media[0].file ?? "",
                                    width: 150,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    placeholder: (BuildContext context, String url) {
                                      return Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: spinkits.getSpinningLinespinkit(), // Maintain consistency
                                        ),
                                      );
                                    },
                                    errorWidget: (BuildContext context, String url, dynamic error) {
                                      return Container(
                                        width: 48, // Matches image size
                                        height: 48, // Matches image size
                                        color: Colors.grey.shade300, // Placeholder background
                                        child: Icon(
                                          Icons.error_outline,
                                          color: Colors.red.shade700, // Error icon styling
                                        ),
                                      );
                                    },
                                  ),
                                  Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ],
                              )),
                        )
                      ]

                      // Check for PDFs
                      else if (getFileExtension(media[0].file) == 'pdf') ...[
                        // Render PDF with Icon
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: media
                                .where((mediaItem) =>
                                    getFileExtension(mediaItem.file) == 'pdf')
                                .map(
                                  (mediaItem) => GestureDetector(
                                    onTap: () =>
                                        _openDocument(context, mediaItem),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 4,
                                      clipBehavior: Clip.hardEdge,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Placeholder for the first page thumbnail
                                          Container(
                                            color: Colors.grey[200],
                                            width: 150,
                                            height: 150,
                                            child: Icon(
                                              Icons.picture_as_pdf,
                                              color: Colors.red,
                                              size: 100,
                                            ),
                                          ),
                                          // File name below the thumbnail
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              _getFileNameWithExtension(
                                                      mediaItem.file) ??
                                                  'Untitled Document',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      ]

                      // Handle fallback if file type is not recognized
                      else ...[
                        // Handle unsupported or unknown file types (if needed)
                        GestureDetector(
                          onTap: () => _openDocument(context, media[0]),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                            clipBehavior: Clip.hardEdge,
                            child: Icon(
                              Icons.file_present,
                              color: Colors.grey,
                              size: 50,
                            ),
                          ),
                        ),
                      ]
                    ]

                    // Multiple Media Items
                    else if (media.length > 1) ...[
                      // Render Multiple Media Items
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                        ),
                        itemCount: media.length > 3 ? 4 : media.length,
                        itemBuilder: (context, index) {
                          if (index == 3 && media.length > 3) {
                            return GestureDetector(
                              onTap: () =>
                                  _openImageViewer(context, media, index),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                clipBehavior: Clip.hardEdge,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: CachedNetworkImage(
                                        imageUrl:  media[0].file ?? '',
                                        fit: BoxFit.cover,
                                        placeholder: (BuildContext context, String url) {
                                          return Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: spinkits.getSpinningLinespinkit(), // Maintain consistency
                                            ),
                                          );
                                        },
                                        errorWidget: (BuildContext context, String url, dynamic error) {
                                          return Container(
                                            width: 48, // Matches image size
                                            height: 48, // Matches image size
                                            color: Colors.grey.shade300, // Placeholder background
                                            child: Icon(
                                              Icons.error_outline,
                                              color: Colors.red.shade700, // Error icon styling
                                            ),
                                          );
                                        },
                                      ),
                                      // Image.network(
                                      //   media[0].file ?? '',
                                      //   fit: BoxFit.cover,
                                      //   color: Colors.black.withOpacity(0.4),
                                      //   colorBlendMode: BlendMode.darken,
                                      // ),
                                    ),
                                    Center(
                                      child: Text(
                                        '+${media.length - 3}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            final mediaItem = media[index];
                            return GestureDetector(
                              onTap: () =>
                                  _openImageViewer(context, media, index),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                clipBehavior: Clip.hardEdge,
                                child: getMediaWidget(mediaItem),
                              ),
                            );
                          }
                        },
                      ),
                    ]
                  ],

                  // Message timestamp
                  SizedBox(height: 5),
                  Text(
                    datetime,
                    style: TextStyle(
                      color: themeProvider.textColor.withOpacity(0.7),
                      fontFamily: "Inter",
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// A helper function to return the appropriate widget for each media type
  Widget getMediaWidget(Media mediaItem) {
    // if (mediaItem.contentType?.startsWith('image') ?? false) {
    return Image.network(
      mediaItem.file ?? '',
      fit: BoxFit.cover,
    );
    // } else if (mediaItem.contentType?.startsWith('video') ?? false) {
    //   return Stack(
    //     alignment: Alignment.center,
    //     children: [
    //       Image.network(
    //         mediaItem.file ?? '',
    //         fit: BoxFit.cover,
    //       ),
    //       Icon(
    //         Icons.play_circle_fill,
    //         color: Colors.white,
    //         size: 50,
    //       ),
    //     ],
    //   );
    // } else if (mediaItem.contentType?.startsWith('application/pdf') ?? false) {
    //   return Icon(
    //     Icons.insert_drive_file,
    //     color: Colors.blue,
    //     size: 50,
    //   );
    // } else {
    //   return Icon(
    //     Icons.help_outline,
    //     color: Colors.grey,
    //     size: 50,
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.themeData == lightTheme
            ? AppColors.primaryColor
            : Color(0xff000000),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context, true),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfile(userID: userID)));
                if (res == true) {
                  _initializeWebSocket();
                  RoomDetailsApi();
                }
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(userimage),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InkResponse(
                onTap: () async {
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfile(userID: userID)));
                  if (res == true) {
                    _initializeWebSocket();
                    RoomDetailsApi();
                  }
                },
                child: Text(
                  username,
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: Image(
        //         image: AssetImage("assets/video.png"),
        //         color: Colors.white,
        //         width: 22,
        //         height: 20),
        //     onPressed: () {
        //       // Handle video call action
        //     },
        //   ),
        //   IconButton(
        //     icon: Image(
        //         image: AssetImage("assets/call.png"), width: 22, height: 20),
        //     onPressed: () {
        //       // Handle phone call action
        //     },
        //   ),
        //   IconButton(
        //     icon: Image(
        //         image: AssetImage("assets/more.png"), width: 22, height: 20),
        //     onPressed: () {
        //       // Handle more actions
        //     },
        //   ),
        // ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length +
                        (_isLoadingMore ? 1 : 0), // Add 1 for the loader
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isLoadingMore) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final message = _messages[index];
                      final messageText = message.msg;
                      final sender =
                          message.sentUser == widget.ID ? "you" : "remote";
                      final datetime = message.lastUpdated ?? "";
                      final media = message.media;

                      return _buildMessageBubble(
                          messageText ?? "", sender, datetime, media);
                    },
                  ),
                ),
                // Animated file picker dialog
                if (_isPickerVisible)
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.only(top: 10, right: 20),
                              width: 250,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Color(0xffEAE0FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Camera
                                  GestureDetector(
                                    onTap: () async {
                                      _togglePickerVisibility();
                                      _pickMedia(
                                          isCamera:
                                              true); // Trigger camera mode
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                        color: Color(0xff8856F4),
                                      ),
                                    ),
                                  ),

                                  // Gallery
                                  GestureDetector(
                                    onTap: () async {
                                      _togglePickerVisibility();
                                      _pickMedia(
                                          isCamera:
                                              false); // Trigger gallery mode
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.photo,
                                        size: 40,
                                        color: Color(0xff8856F4),
                                      ),
                                    ),
                                  ),

                                  // Document Picker
                                  GestureDetector(
                                    onTap: () async {
                                      _togglePickerVisibility();
                                      await _pickDocument();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.insert_drive_file,
                                        size: 40,
                                        color: Color(0xff8856F4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeProvider.themeData == lightTheme
                          ? Color(0xffffffff)
                          : themeProvider.containerColor,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child:TextFormField(
                            controller: _messageController,
                            keyboardType: TextInputType.multiline,
                            contentInsertionConfiguration: ContentInsertionConfiguration(
                              allowedMimeTypes: const <String>[
                                'image/png',
                                'image/gif',
                                'image/webp',
                                'application/x-sticker',
                              ],
                              onContentInserted: (KeyboardInsertedContent data) async {
                                if (data.data != null) {
                                  // Successfully received binary data for content (image/gif)
                                  setState(() {
                                    bytes = data.data; // Store the binary data for display or further use
                                  });

                                  print("Data received with MIME type: ${data.mimeType}");

                                  // Save bytes as a temporary file
                                  final tempDir = await getTemporaryDirectory(); // Get the device temporary directory
                                  final fileName = '${DateTime.now().millisecondsSinceEpoch}.${data.mimeType.split('/').last}';

                                  final tempFile = File('${tempDir.path}/$fileName');

                                  // Write the received bytes to the temporary file
                                  await tempFile.writeAsBytes(data.data!.cast<int>());

                                  // Add to _selectedFiles
                                  setState(() {
                                    _selectedFiles.add(XFile(tempFile.path)); // Add the temp file to the list
                                  });

                                  // Trigger file upload
                                  await uploadFiles();
                                } else {
                                  // Handle the case where no binary data is received from the keyboard
                                  print("No binary data received from the keyboard.");
                                }
                              },
                            ),
                            decoration: InputDecoration(
                              hintText: 'Type message here...',
                              hintStyle: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                          ),

                        ),
                        IconButton(
                          icon: Icon(
                            Icons.attach_file_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _togglePickerVisibility();
                          },
                        ),
                        Material(
                          elevation: _isRecording ? 6 : 2,
                          shape: CircleBorder(),
                          child: InkWell(
                            customBorder: CircleBorder(),
                            onTap: () {
                              _toggleRecording();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                _isRecording ? Icons.stop : Icons.mic,
                                color: _isRecording ? Colors.red : Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        _isRecording
                            ? Column(
                                children: [
                                  Text("Recording: ${_recordingTime}s",style: TextStyle(
                                    color: Colors.white
                                  ),),
                                  // Placeholder for audio frequency visualizer (like waveform)
                                  LinearProgressIndicator(
                                      value: _recordingTime /
                                          60,
                                    color: Colors.white,
                                  ), // Example for 60s limit
                                ],
                              )
                            : Container(),
                        InkResponse(
                          onTap: () {
                            _sendMessage();
                          },
                          child: Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Image(
                                image: AssetImage(
                                  "assets/container.png",
                                ),
                                height: 36,
                                width: 36,
                              )),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
