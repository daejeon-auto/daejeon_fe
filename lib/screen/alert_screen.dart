import 'package:daejeon_fe/model/punish.dart';
import 'package:flutter/material.dart';

class AlertScreen extends StatefulWidget {
  final List<Punish>? res;

  const AlertScreen({
    Key? key,
    required this.res,
  }) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  @override
  void initState() {
    var res = widget.res;

    if (res != null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Center(child: Text("정지 내역이 존재합니다.")),
          actions: [
            Column(
              children: [
                for (int i = 0; i < res.length; i++)
                  Text(
                      "${res[i].id} / ${res[i].reason} / ${res[i].rating} / ${res[i].expiredDate}"),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (_) => false),
                  child: const Text("닫기"),
                )
              ],
            ),
          ],
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
