import 'package:daejeon_fe/screen/login_screen.dart';
import 'package:daejeon_fe/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:webviewx/webviewx.dart';

class PostAddScreen extends StatefulWidget {
  const PostAddScreen({Key? key, required this.schoolId}) : super(key: key);

  final int schoolId;

  @override
  State<PostAddScreen> createState() => _PostAddScreenState();
}

class _PostAddScreenState extends State<PostAddScreen> {
  final descController = TextEditingController();
  var time = 10;
  bool isLoading = false;
  String errorMsg = "";

  @override
  void dispose() {
    descController.dispose();
    super.dispose();
  }

  addPost() async {
    try {
      setState(() {
        isLoading = true;
      });

      await ApiService().writePost(
        description: descController.text,
        schoolId: widget.schoolId,
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on Exception catch (e) {
      isLoading = false;
      if (e.toString() == "Exception: 400") {
        errorMsg = "글은 10자 이상, 100자 이하여야 합니다.";
      }
      if (e.toString() == "Exception: 403") {
        errorMsg = e.toString();
      }
      setState(() {});
      if (e.toString() == "Exception: 401") {
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    } catch (e) {
      errorMsg = e.toString();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (errorMsg.isNotEmpty)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 10),
                  color: Colors.red.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMsg,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              TextField(
                controller: descController,
                keyboardType: TextInputType.multiline,
                maxLength: 100,
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: "글 내용",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              isLoading
                  ? LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.blueAccent,
                      size: 50,
                    )
                  : TextButton(
                      onPressed: addPost,
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFE9EFFF),
                      ),
                      child: const Text("작성"),
                    ),
              const SizedBox(
                height: 40,
              ),
              WebViewX(
                initialContent: '''
            <ins class="kakao_ad_area" style="display:none;"
data-ad-unit = "DAN-xzrZdEWsRO2UHhAe"
data-ad-width = "300"
data-ad-height = "250"></ins>
<script type="text/javascript" src="//t1.daumcdn.net/kas/static/ba.min.js" async></script>
            ''',
                initialSourceType: SourceType.html,
                javascriptMode: JavascriptMode.unrestricted,
                height: 270,
                width: MediaQuery.of(context).size.width - 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
