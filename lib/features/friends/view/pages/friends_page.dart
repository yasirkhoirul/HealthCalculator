import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_calculator/router/app_routes.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/mock/mock_data.dart';
import '../viewmodels/friends_provider.dart';

/// Tab 2: Temukan Teman / Explore Study Buddies
class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final friendsProvider = context.watch<FriendsProvider>();
    final requests = friendsProvider.requests;
    final buddies = friendsProvider.buddies;

    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final borderSubtleColor = AppColors.borderSubtleOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final primaryColor = AppColors.primaryOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: Text(
          'Temukan Rekan Belajar',
          style: TextStyle(
            color: textPrimaryColor,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month_rounded, color: primaryColor),
            tooltip: 'Buat Jadwal Belajar',
            onPressed: () => context.pushNamed(AppRoutes.createSchedule),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: borderSubtleColor, height: 1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // 1. Search Bar
          Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              onChanged: friendsProvider.updateSearchQuery,
              style: TextStyle(
                fontSize: 14,
                color: textPrimaryColor,
              ),
              decoration: InputDecoration(
                hintText: 'Cari nama rekan, jurusan, atau mata kuliah...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMutedOf(context),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: primaryColor,
                  size: 22,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 2. Study Requests Section
          if (requests.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  'Permintaan Belajar Bareng',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${requests.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...requests.map(
              (req) => _buildRequestCard(context, req, friendsProvider),
            ),
            const SizedBox(height: 18),
          ],

          // 3. Recommended Buddies Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rekan Belajar Sekitar Kampus',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
              Text(
                '${buddies.length} Mahasiswa Aktif',
                style: TextStyle(
                  fontSize: 12,
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Buddies List
          ...buddies.map(
            (buddy) => _buildBuddyCard(context, buddy, friendsProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(
    BuildContext context,
    StudyRequest request,
    FriendsProvider provider,
  ) {
    final primaryColor = AppColors.primaryOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final textBodyColor = AppColors.textBodyOf(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardSubtleBgOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primaryBorderOf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: primaryColor,
                child: Text(
                  request.sender.avatarInitials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.sender.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textPrimaryColor,
                      ),
                    ),
                    Text(
                      '${request.sender.major} • ${request.sender.campus}',
                      style: TextStyle(
                        fontSize: 12,
                        color: textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '"${request.note}"',
            style: TextStyle(
              fontSize: 12.5,
              color: textBodyColor,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => provider.declineRequest(request.id),
                style: TextButton.styleFrom(
                  foregroundColor: textSecondaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Tolak'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  provider.acceptRequest(request.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Menerima ajakan belajar dari ${request.sender.name}',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.check_rounded, size: 16, color: Colors.white),
                label: const Text(
                  'Terima Ajakan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBuddyCard(
    BuildContext context,
    StudyBuddy buddy,
    FriendsProvider provider,
  ) {
    final isKnocked = provider.isKnocked(buddy.id);
    final primaryColor = AppColors.primaryOf(context);
    final primaryLightColor = AppColors.primaryLightOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderSubtleOf(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            context.pushNamed(
              AppRoutes.chatDetail,
              pathParameters: {'userId': buddy.id},
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: primaryLightColor,
                      child: Text(
                        buddy.avatarInitials,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: buddy.isOnline
                              ? const Color(0xFF22C55E)
                              : AppColors.textMutedOf(context),
                          shape: BoxShape.circle,
                          border: Border.all(color: surfaceColor, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        buddy.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textPrimaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${buddy.major} • ${buddy.campus}',
                        style: TextStyle(
                          fontSize: 12,
                          color: textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryLightColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.menu_book_rounded,
                              size: 13,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                buddy.currentStudyTopic,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isKnocked
                      ? null
                      : () {
                          provider.knockBuddy(buddy.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Mengajak ${buddy.name} belajar bareng!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isKnocked
                        ? AppColors.cardSubtleBgOf(context)
                        : primaryColor,
                    foregroundColor: isKnocked
                        ? textSecondaryColor
                        : Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isKnocked ? 'Terkirim' : 'Knock',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isKnocked ? AppColors.textMutedOf(context) : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
