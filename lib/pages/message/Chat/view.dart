import '/./pages/message/Chat/widgets/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/values/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'index.dart';

class ChatPage extends GetView<ChatController> {
  // AudioController audioController = Get.put(AudioController());
  // VoiceController voiceController = Get.put(VoiceController());
  // ChatProvider chatProvider = Get.put(ChatProvider(
  //     firebaseFirestore: FirebaseFirestore.instance,
  //     firebaseStorage: FirebaseStorage.instance));
  // AudioPlayer audioPlayer = AudioPlayer();

  @override
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xff9d45c7),
      title: Container(
        padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w, left: 0.w),
        child: Row(
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w, left: 0.w),
              child: InkWell(
                //inkwell is used inorder to make the profile photo clickable
                child: SizedBox(
                  width: 44.w,
                  height: 44.w,
                  child: CachedNetworkImage(
                    imageUrl: controller.state.to_avatar.value,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 44.w,
                      width: 44.w,
                      margin: null,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(44.w)),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                    errorWidget: (context, url, error) => Image(
                      image: AssetImage('assets/images/feature-1.png'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
            Container(
              width: 180.w,
              padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
              child: Row(children: [
                SizedBox(
                  width: 180.w,
                  height: 44.w,
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.state.to_name.value,
                          overflow: TextOverflow
                              .ellipsis, //incase the user has a long name
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBackground,
                              fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Gallery"),
                onTap: () {
                  controller.imgFromGallery();
                  Get.back();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text("Camera"),
                onTap: () {},
              )
            ],
          ));
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ChatList(),
            ),
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 16.0),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 1,
                              controller: controller.textController,
                              autofocus: false,
                              focusNode: controller.contentNode,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Send message...',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(width: 5.0),
                          IconButton(
                            icon: Icon(
                              Icons.photo_outlined,
                              size: 28.0,
                              color: Color(0xff9d45c7),
                            ),
                            onPressed: () {
                              _showPicker(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.send,
                              size: 24.0,
                              color: Color(0xff9d45c7),
                            ),
                            onPressed: () {
                              controller.sendMessage();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff9d45c7),
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.mic_outlined,
                        size: 24.0,
                        color: Colors.white,
                      ),
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
}
