import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_base_state.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../router/app_routes.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../widgets/chat_app_bar_header_widget.dart';
import '../widgets/chat_bubble_widget.dart';
import '../widgets/chat_follow_banner_widget.dart';
import '../widgets/chat_input_bar_widget.dart';

/// Halaman Obrolan Langsung / Chat Room (`ChatDetailPage`) dengan referensi UX/UI TikTok Direct Message (DM).
/// Dilengkapi header profil TikTok DM, banner pertemanan atas, alur kartu ajakan "Knock",
/// serta integrasi navigasi ke UserDetailPage.
class ChatDetailPage extends StatelessWidget {
  final String userId;

  const ChatDetailPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatViewModel>(
      create: (_) => locator<ChatViewModel>()..loadMessages(userId),
      child: _ChatDetailContentView(userId: userId),
    );
  }
}

class _ChatDetailContentView extends StatefulWidget {
  final String userId;

  const _ChatDetailContentView({required this.userId});

  @override
  State<_ChatDetailContentView> createState() => _ChatDetailContentViewState();
}

class _ChatDetailContentViewState extends State<_ChatDetailContentView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _navigateToUserDetail() {
    context.pushNamed(
      AppRoutes.userDetail,
      pathParameters: {'userId': widget.userId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = context.watch<ChatViewModel>();
    final messageState = chatViewModel.messageState;
    final textSecondaryColor = AppColors.textSecondaryOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: ChatAppBarHeaderWidget(
        userName: chatViewModel.targetUserName,
        userStatus: chatViewModel.targetUserStatus,
        userInitials: chatViewModel.targetUserInitials,
        isOnline: chatViewModel.isTargetOnline,
        onBack: () => context.pop(),
        onProfileTap: _navigateToUserDetail,
        onBlockUser: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${chatViewModel.targetUserName} berhasil diblokir.'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        onReportUser: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Laporan Anda telah dikirimkan ke tim moderasi StudyMap.'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
      body: Column(
        children: [
          // 1. Follow / Friendship Banner gaya TikTok DM (Muncul bila belum saling berteman)
          if (!chatViewModel.isFriend)
            ChatFollowBannerWidget(
              userName: chatViewModel.targetUserName,
              isPending: chatViewModel.isPendingFriend,
              onAddFriendPressed: () {
                chatViewModel.addFriend(widget.userId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Sekarang Anda berteman dengan ${chatViewModel.targetUserName}!',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),

          // 2. Chat Stream List (Teks Bubble & Interactive Knock Cards)
          Expanded(
            child: switch (messageState) {
              AppStateLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              AppStateError(:final message) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 40,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textSecondaryColor,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () =>
                              chatViewModel.loadMessages(widget.userId),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                ),
              AppStateSuccess(:final data) => (data == null || data.isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 44,
                            color: textSecondaryColor.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Kirim pesan atau ajak belajar bareng',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final msg = data[index];
                        final isMe = msg.senderId == 'user-farhan';
                        return ChatBubbleWidget(
                          message: msg,
                          isMe: isMe,
                          onRespondKnock: (isAccepted) {
                            if (msg.knockPayload != null) {
                              chatViewModel.respondToKnock(
                                msg.knockPayload!.knockId,
                                isAccepted,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isAccepted
                                        ? 'Ajakan belajar bareng diterima! Sesi telah dijadwalkan.'
                                        : 'Ajakan belajar bareng ditolak.',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
              _ => const SizedBox.shrink(),
            },
          ),

          // 3. Bottom Message Bar (TikTok DM style dengan tombol Knock dan Send)
          ChatInputBarWidget(
            onSendMessage: (text) {
              chatViewModel.sendMessage(text, widget.userId);
              _scrollToBottom();
            },
            onSendKnock: (spotName, durationMinutes) {
              chatViewModel.sendKnockInvitation(
                targetUserId: widget.userId,
                spotName: spotName,
                durationMinutes: durationMinutes,
              );
              _scrollToBottom();
            },
            onShareSpotPressed: () {
              chatViewModel.sendMessage(
                'Aku lagi fokus di Main Campus Library Floor 2. Yuk gabung kalau senggang!',
                widget.userId,
              );
              _scrollToBottom();
            },
          ),
        ],
      ),
    );
  }
}
