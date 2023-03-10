import 'dart:async';

import 'package:daejeon_fe/model/post/post_list_model.dart';
import 'package:daejeon_fe/model/post/post_model.dart';
import 'package:daejeon_fe/screen/NavBar.dart';
import 'package:daejeon_fe/screen/post_add_screen.dart';
import 'package:daejeon_fe/service/api_service.dart';
import 'package:daejeon_fe/widget/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:sticky_footer_scrollview/sticky_footer_scrollview.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int page = 0;
  List<PostModel> postList = [];
  late Stream<PostListModel?> newPostList;
  final scrollController = ScrollController();
  final postListStreamController = StreamController<PostListModel?>();

  @override
  void initState() {
    newPostList = postListStreamController.stream;
    getPostList(page).then((value) => postListStreamController.add(value));
    super.initState();
  }

  @override
  void dispose() {
    postListStreamController.close();
    super.dispose();
  }

  Future<PostListModel> getPostList(int page) async {
    try {
      var postList = await ApiService().getPostList(page: page);
      return postList;
    } on Exception catch (e) {
      if (e.toString() == "Exception: 401") {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      } else if (e.toString().length > 20 &&
          e.toString().substring(0, 20) == "Failed host lookup: ") {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("인터넷 연결 문제 발생"),
            content: Text("인터넷이 연결되지 않았거나 서버와 연결되지 않습니다"),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("글 가져오는중 오류 발생"),
            content: Text("오류코드 - ${e.toString()}"),
          ),
        );
      }
      throw ("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 247, 255),
      endDrawer: const NavMenu(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.white),
              clipBehavior: Clip.hardEdge,
              child: const Image(
                  width: 50,
                  height: 50,
                  image: AssetImage(
                    "assets/logo.png",
                  )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PostAddScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
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
                  child: Column(
                    children: [
                      StreamBuilder<PostListModel?>(
                        stream: newPostList,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data!.postList.isEmpty ||
                              snapshot.hasError) {
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height -
                                        110,
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    child: Center(
                                      child: snapshot.hasError
                                          ? const Text('게시글을 가져오는 동안 에러 발생')
                                          : const Text('게시글이 없습니다'),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          postList.addAll(snapshot.data!.postList);
                          return Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 110,
                                width: MediaQuery.of(context).size.width - 20,
                                child: StickyFooterScrollView(
                                  scrollController: scrollController,
                                  itemCount: postList.length,
                                  itemBuilder: (context, index) {
                                    return PostCard(
                                      post: postList[index],
                                    );
                                  },
                                  footer: snapshot.data!.totalPage - 1 == page
                                      ? const SizedBox()
                                      : Transform.translate(
                                          offset: const Offset(-10, -10),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                10,
                                            height: 50,
                                            child: TextButton(
                                              style: const ButtonStyle(),
                                              onPressed: () {
                                                page++;
                                                getPostList(page).then(
                                                    (value) =>
                                                        postListStreamController
                                                            .add(value));
                                              },
                                              child: const Text('더보기'),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
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
