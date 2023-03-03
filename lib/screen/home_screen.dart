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
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const App(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                        (_) => false);
                    setState(() {});
                  },
                  child: FutureBuilder(
                    future: postList,
                    builder: (
                      context,
                      AsyncSnapshot<PostListModel> snapshot,
                    ) {
                      var text = "";
                      if (!snapshot.hasData) {
                        text = "글을 가져오는중 오류 발생";
                      } else if (snapshot.data!.postList == null) {
                        text = '게시글이 없습니다';
                      }
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height - 110,
                              width: MediaQuery.of(context).size.width - 20,
                              child: Center(
                                child: Text(text),
                              ),
                            ),
                          );
                        },
                      );
                      return Expanded(
                        child: ListView.separated(
                          itemCount: snapshot.data!.postList!.length,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemBuilder: (context, index) {
                            return PostCard(
                              post: snapshot.data!.postList![index],
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
