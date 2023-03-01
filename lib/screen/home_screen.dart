import 'package:daejeon_fe/model/post/post_list_model.dart';
import 'package:daejeon_fe/service/api_service.dart';
import 'package:daejeon_fe/widget/card_widget.dart';
import 'package:flutter/material.dart';

import 'post_add_screen.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int page = 0;
  late Future<PostListModel> postList;

  @override
  void initState() {
    setState(() {
      postList = getPostList(page);
    });
    super.initState();
  }

  Future<PostListModel> getPostList(int page) async {
    try {
      var postList = await ApiService.getPostList(page: page);
      return postList;
    } on Exception catch (e) {
      if (e.toString() == "Exception: 401") {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      }
      throw ("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.circle,
              size: 50,
            ),
            GestureDetector(
              child: const Icon(
                Icons.post_add_outlined,
                size: 30,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PostAddScreen(),
                ),
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RefreshIndicator(
                  onRefresh: () async {},
                  child: FutureBuilder(
                    future: postList,
                    builder: (
                      context,
                      AsyncSnapshot<PostListModel> snapshot,
                    ) {
                      if (!snapshot.hasData)
                        return const Text("글을 가져오는중 오류 발생");
                      return Expanded(
                        child: ListView.separated(
                          itemCount: snapshot.data!.postList.length,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemBuilder: (context, index) {
                            return PostCard(
                              post: snapshot.data!.postList[index],
                            );
                          },
                          separatorBuilder: (
                            BuildContext context,
                            int index,
                          ) =>
                              const SizedBox(width: 40),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
