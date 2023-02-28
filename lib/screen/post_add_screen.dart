import 'package:daejeon_fe/screen/login_screen.dart';
import 'package:daejeon_fe/service/api_service.dart';
import 'package:flutter/material.dart';

class PostAddScreen extends StatefulWidget {
  const PostAddScreen({Key? key}) : super(key: key);

  @override
  State<PostAddScreen> createState() => _PostAddScreenState();
}

class _PostAddScreenState extends State<PostAddScreen> {
  final descController = TextEditingController();

  @override
  void dispose() {
    descController.dispose();
    super.dispose();
  }

  addPost() async {
    try {
      await ApiService.writePost(description: descController.text);
    } on Exception catch (e) {
      if (e.toString() == "Exception: 401") {
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
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
            TextButton(
              onPressed: addPost,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFE9EFFF),
              ),
              child: const Text("작성"),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text('비속어 쓰지 마삼')
          ],
        ),
      ),
    );
  }
}
