import 'package:flutter/material.dart';
import 'package:seagull/constants/colors.dart';

/// 댓글 모델 정의
class Comment {
  final String userName;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.userName,
    required this.text,
    required this.timestamp,
  });
}

/// 게시물 상세 페이지
class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final List<Comment> _comments = [];
  final TextEditingController _commentController = TextEditingController();
  bool _showComments = true;
  final DateTime postTime = DateTime(2025, 7, 1, 00, 00);

  void _addComment(String text) {
    setState(() {
      _comments.add(
        Comment(userName: '(댓글작성자닉네임)', text: text, timestamp: DateTime.now()),
      );
      _commentController.clear();
    });
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${time.year}.${time.month.toString().padLeft(2, '0')}.${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 10.0),
            Text(
              '여행을 떠나요',
              style: TextStyle(
                color: Color(0xFF595959),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 사용자 정보 및 시간/좋아요/댓글
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 12.5,
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShHhRlT543jwsNfDiSjMkygzXPBJzMUwEHlg&s',
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(작성자닉네임)',
                  style: TextStyle(
                    color: Color(0xFF595959),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  ' · ${_formatTimeAgo(postTime)}',
                  style: TextStyle(color: Color(0xFF9B9B9B), fontSize: 12),
                ),
              ],
            ),
            Row(
              children: const [
                Icon(Icons.favorite, size: 12, color: Color(0xFF8A8A8A)),
                SizedBox(width: 6),
                Text(
                  '0',
                  style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                ),
                Text(
                  ' | ',
                  style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                ),
                Icon(Icons.chat_bubble, size: 12, color: Color(0xFF8A8A8A)),
                SizedBox(width: 6),
                Text(
                  '0',
                  style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                ),
              ],
            ),
          ],
        ),
        const Divider(height: 28, thickness: 1, color: Color(0xFFF4EBEB)),

        // 본문 텍스트
        Text(
          '화명동은 부산 북구에 위치한 주거 중심지로, 금정산과 낙동강 사이에 자리 잡아 자연과 도시가 조화를 이루는 지역입니다. 2000년대 화명 신시가지 개발로 대규모 아파트 단지가 조성되며 인구가 급증하였고, 현재는 화명1·2·3동으로 나뉘어 있습니다. ',
          style: const TextStyle(fontSize: 16, height: 1.5, color: TextColor),
        ),
        const SizedBox(height: 10),

        // 이미지 + 옆에 텍스트
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShHhRlT543jwsNfDiSjMkygzXPBJzMUwEHlg&s',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                '화명동은 부산 북구에 위치한 주거 중심지로, 금정산과 낙동강 사이에 자리 잡아 자연과 도시가 조화를 이루는 지역입니다. 2000년대 화명 신시가지 개발로 대규모 아파트 단지가 조성되며 인구가 급증하였고,  ',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: TextColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // 이어지는 본문
        Text(
          '화명동은 부산 북구에 위치한 주거 중심지로, 금정산과 낙동강 사이에 자리 잡아 자연과 도시가 조화를 이루는 지역입니다. 2000년대 화명 신시가지 개발로 대규모 아파트 단지가 조성되며 인구가 급증하였고, 현재는 화명1·2·3동으로 나뉘어 있습니다. ',
          style: const TextStyle(fontSize: 16, height: 1.5, color: TextColor),
        ),
        const Divider(height: 28, thickness: 1, color: Color(0xFFF4EBEB)),

        // 댓글 보기 토글
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
                style: const TextStyle(fontSize: 12),
              ),
              Icon(
                _showComments
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
                size: 14,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 댓글 목록
        if (_showComments)
          ..._comments.map(
            (c) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(radius: 10),
                      const SizedBox(width: 7),
                      Text(
                        '${c.userName} · ${_formatTimeAgo(c.timestamp)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF595959),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(c.text, style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),

        Container(
          padding: const EdgeInsets.fromLTRB(10, 7, 10, 5),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 높이 자동 조절
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(radius: 10),
                  const SizedBox(width: 7),
                  const Text(
                    '오야지치',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF595959),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // 입력창
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 14, maxHeight: 40),
                child: TextField(
                  controller: _commentController,
                  maxLines: null, // 줄바꿈 가능
                  decoration: const InputDecoration(
                    hintText: '추천하고 싶은 코스를 글로 남겨보세요 !',
                    hintStyle: TextStyle(
                      color: Color(0xFFCDCDCD),
                      fontSize: 12,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(fontSize: 14, color: TextColor),
                ),
              ),

              // 완료 버튼
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(7), // 패딩 제거
                    minimumSize: Size(0, 0), // 크기 제한도 제거하면 완전 타이트하게 가능
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap, // 터치 영역 최소화
                  ),
                  onPressed: () {
                    if (_commentController.text.trim().isNotEmpty) {
                      _addComment(_commentController.text.trim());
                      _commentController.clear();
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: const Text(
                    '완료',
                    style: TextStyle(fontSize: 12, color: Color(0xFF595959)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
