import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
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
            const Text(
              "2022. 11. 05",
              style: TextStyle(
                color: Color(0xFF898888),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Row(
                children: const [
                  Flexible(
                    child: Text(
                      "test description",
                      style: TextStyle(
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
              children: const [
                Icon(
                  Icons.report_gmailerrorred,
                  size: 12,
                ),
                SizedBox(width: 2),
                Text(
                  "신고",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                ),
                SizedBox(width: 7),
                Icon(
                  Icons.favorite_border_outlined,
                  size: 12,
                ),
                SizedBox(width: 2),
                Text(
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
