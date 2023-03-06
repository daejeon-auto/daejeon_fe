// ignore_for_file: invalid_return_type_for_catch_error

import 'package:daejeon_fe/model/post/post_model.dart';
import 'package:daejeon_fe/service/api_service.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool isReported, isLiked;
  late int likedCount;
  var reason = TextEditingController();

  void addReport(int postId, BuildContext context) async {
    try {
      await ApiService().report(postId, reason.text);
      isReported = !isReported;
      setState(() {});
    } on Exception catch (e) {
      if (e.toString() == "Exception: 400") {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text("신고 서식 오류"),
                  content: Text("신고사유는 10자 ~ 100자 내로 작성해 주시기 바랍니다."),
                ));
        return;
      }

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("신고중 에러 발생"),
                content: Text("에러 코드 - ${e.toString()}"),
              ));
    }
  }

  void convertLike(int postId, BuildContext context) async {
    try {
      await ApiService().convertLike(postId);
      if (isLiked) {
        likedCount--;
      } else {
        likedCount++;
      }
      isLiked = !isLiked;
      setState(() {});
    } on Exception catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("좋아요 표시중 에러 발생"),
                content: Text("에러 코드 - ${e.toString()}"),
              ));
    }
  }

  @override
  void initState() {
    isReported = widget.post.isReported;
    isLiked = widget.post.isLiked;
    likedCount = widget.post.likedCount;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.created,
              style: const TextStyle(
                color: Color(0xFF898888),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.post.description,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => {
                    isReported
                        ? () => {}
                        : showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("신고 사유"),
                                  content: SizedBox(
                                    height: 220,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          width: 300,
                                          height: 50,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  "신고시 사유는 10자 ~ 100자 내로 작성해 주시기 바랍니다.",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextField(
                                          maxLength: 100,
                                          maxLines: 3,
                                          controller: reason,
                                        ),
                                        TextButton(
                                            onPressed: () => {
                                                  addReport(widget.post.postId,
                                                      context),
                                                  Navigator.pop(context)
                                                },
                                            child: const Text("작성"))
                                      ],
                                    ),
                                  ),
                                ))
                  },
                  child: Row(
                    children: [
                      Icon(
                        isReported
                            ? Icons.report_rounded
                            : Icons.report_gmailerrorred,
                        size: 17,
                        color: Colors.yellow.shade900,
                      ),
                      const SizedBox(width: 2),
                      const Text(
                        "신고",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 7),
                InkWell(
                  onTap: () => convertLike(widget.post.postId, context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isLiked
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        size: 15,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        likedCount.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
