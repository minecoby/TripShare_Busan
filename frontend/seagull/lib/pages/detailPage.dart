import 'package:flutter/material.dart';
import 'package:seagull/api/controller/LoginAndSignup/login_controller.dart';
import 'package:seagull/api/controller/PostPage/post_commentAdd_controller.dart';
import 'package:seagull/api/controller/PostPage/post_summary_controller.dart';
import 'package:seagull/api/model/PostPage/post_commentAdd_model.dart';
import 'package:seagull/api/model/PostPage/post_summary_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class PostDetailPage extends StatefulWidget {
  final PostDetail post;

  const PostDetailPage({super.key, required this.post});
  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentUserWritingController =
      TextEditingController();
  bool _showComments = true;
  final DateTime postTime = DateTime(2025, 7, 1, 00, 00);

  late final PostSummaryController postSummaryController;

  late final CommentController commentController;

  List<Comment> comments = [];

  final isRefreshing = false.obs;

  final loginController = Get.find<LoginController>();

  final errormessage = "".obs;

  String? token;
  String? userName;
  @override
  void initState() {
    super.initState();
    _loadLoginInfo();
    commentController = Get.put(CommentController());
    postSummaryController = Get.find<PostSummaryController>();
    comments = postSummaryController.post?.comments ?? [];
  }

  @override
  void dispose() {
    _commentUserWritingController.dispose();
    super.dispose();
  }

  Future<void> _loadLoginInfo() async {
    token = await loginController.getAccessToken();
    userName = await loginController.getUserName();
    print(token);
    print(userName);
    setState(() {}); // 토큰 로딩 후 UI 갱신
  }

  void _addComment(String text) async {
    final postId = widget.post.id;

    final userIdStr = await loginController.getUserId();
    if (userIdStr == null) {
      commentController.errorMessage.value = '로그인이 필요합니다.';
      return;
    }

    final userId = int.tryParse(userIdStr);
    if (userId == null) {
      commentController.errorMessage.value = '유효하지 않은 사용자 ID입니다.';
      return;
    }
    await commentController.addComment(
      CommentAdd(postId: postId, userId: userId, content: text),
    );

    if (commentController.errorMessage.value.isEmpty) {
      _commentUserWritingController.clear();

      // 최신 댓글 목록 다시 가져오기
      await postSummaryController.fetchPost(postId);
      setState(() {
        comments = postSummaryController.post?.comments ?? [];
      });
    }
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 30) return '${diff.inDays}일 전';
    return '${time.year}.${time.month.toString().padLeft(2, '0')}.${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Padding(
      padding: EdgeInsets.only(top: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Text(
            post.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // 사용자 정보 및 시간/좋아요/댓글
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShHhRlT543jwsNfDiSjMkygzXPBJzMUwEHlg&s',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${post.userName} · ${_formatTimeAgo(postTime)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.favorite_border, size: 16),
                  SizedBox(width: 4),
                  Text('${post.likeCount}'),
                  SizedBox(width: 8),
                  Icon(Icons.comment, size: 16),
                  SizedBox(width: 4),
                  Text('${post.commentCount}'),
                ],
              ),
            ],
          ),
          const Divider(height: 24),

          // 본문 텍스트
          Text(
            post.content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF303030),
            ),
          ),
          // const SizedBox(height: 12),
          //
          // // 이미지 + 옆에 텍스트
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Container(
          //       width: 150,
          //       height: 150,
          //       decoration: BoxDecoration(
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.black.withOpacity(0.25),
          //             blurRadius: 4,
          //             offset: Offset(0, 4),
          //           ),
          //         ],
          //       ),
          //       child: ClipRRect(
          //         child: Image.asset(
          //           'images/oyaji.jpg',
          //           width: 150,
          //           height: 150,
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: Text(
          //         '화명동은 부산 북구에 위치한 주거 중심지로, 금정산과 낙동강 사이에 자리 잡아 자연과 도시가 조화를 이루는 지역입니다. 2000년대 화명 신시가지 개발로 대규모 아파트 단지가 조성되며 인구가 급증하였고,   ',
          //         style: const TextStyle(fontSize: 14, height: 1.6),
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 12),
          //
          // // 이어지는 본문
          // Text(
          //   '화명동은 부산 북구에 위치한 주거 중심지로, 금정산과 낙동강 사이에 자리 잡아 자연과 도시가 조화를 이루는 지역입니다. 2000년대 화명 신시가지 개발로 대규모 아파트 단지가 조성되며 인구가 급증하였고, 현재는 화명1·2·3동으로 나뉘어 있습니다. ',
          //   style: const TextStyle(fontSize: 14, height: 1.6),
          // ),
          const SizedBox(height: 20),

          // 댓글 보기 토글
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showComments = !_showComments;
                  });
                },
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Text(
                      _showComments ? '💬 댓글 숨기기' : '💬 댓글 보기',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Icon(
                      _showComments
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      size: 16,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  isRefreshing.value = true;
                  await postSummaryController.fetchPost(widget.post.id);
                  isRefreshing.value = false;
                },
                child: Obx(
                  () =>
                      isRefreshing.value
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.refresh, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 댓글 목록
          if (_showComments)
            ListView.builder(
                itemCount: comments.length,

                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final c = comments[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.fromLTRB(10, 7, 10, 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage:
                              c.userProfileImage != null
                                  ? NetworkImage(c.userProfileImage!)
                                  : const AssetImage('assets/images/user.png')
                                      as ImageProvider,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${c.userName} ·${_formatTimeAgo(DateTime.parse(c.createdAt))}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(c.content),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (commentController.errorMessage.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    commentController.errorMessage.value,
                    style: const TextStyle(
                      color: Color(0xFFE94F4F),
                      fontSize: 12,
                    ),
                  ),
                ),
              // 댓글 입력창
              if (token != null)
                Container(
                  margin: const EdgeInsets.only(top: 60),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F6FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          'https://i.namu.wiki/i/tKKaPU9zpFhU6mvUDX0TZk5I_X-8i2SuqnSSb8uSS97m3xy-ZWLLxXPvGlz26zGMQg3KTj2W46ZSw9OlBAksOcmhGGpO57X6vobqHxugHKnsxZBkAhh9xqIGZnAty5XxTbgYY5khvAqg9kWnL0LgDg.webp',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName ?? "로그인이 필요합니다",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _commentUserWritingController,
                                    decoration: const InputDecoration(
                                      hintText: '댓글을 남겨보세요 !',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (token == null) {
                                      Get.offAllNamed("/login");
                                    } else {
                                      if (_commentUserWritingController.text
                                          .trim()
                                          .isNotEmpty) {
                                        _addComment(
                                          _commentUserWritingController.text
                                              .trim(),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text(
                                    '완료',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
