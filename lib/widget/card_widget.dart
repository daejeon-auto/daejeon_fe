import 'package:daejeon_fe/model/post/post_model.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

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
              post.created,
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
                      post.description,
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
                Icon(
                  post.isReported
                      ? Icons.report_rounded
                      : Icons.report_gmailerrorred,
                  size: 12,
                ),
                const SizedBox(width: 2),
                const Text(
                  "신고",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 7),
                Icon(
                  post.isLiked
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  size: 12,
                ),
                const SizedBox(width: 2),
                const Text(
                  "좋아요",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
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
