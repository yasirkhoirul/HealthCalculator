import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Sub-route: /create-room
/// Form pembuatan ruang belajar kampus dengan durasi & kuota knock
class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _roomNameController;
  late final TextEditingController _locationController;
  double _maxParticipants = 6;
  String _selectedCategory = 'Diskusi Santai';
  bool _requireHostApproval = true;

  final List<String> _categories = [
    'Diskusi Santai',
    'Fokus Hening',
    'Coding & Praktikum',
    'Review Skripsi',
  ];

  @override
  void initState() {
    super.initState();
    _roomNameController = TextEditingController(text: 'Room Belajar Flutter & Dart');
    _locationController = TextEditingController(text: 'Main Campus Library - Lantai 2');
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _handleCreateRoom() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ruang belajar berhasil dibuka di peta kampus!'),
          duration: Duration(seconds: 2),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Buat Ruang Belajar',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Nama Ruang Belajar
              const Text(
                'Nama Ruang Belajar Kampus',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              AppTextField(
                controller: _roomNameController,
                hintText: 'Contoh: Sesi Bedah Soal Kalkulus II',
                prefixIcon: const Icon(
                  Icons.meeting_room_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),

              const SizedBox(height: 16),

              // 2. Kategori Suasana
              const Text(
                'Suasana Belajar',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textBody,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 18),

              // 3. Batas Kuota Peserta (Slider)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Batas Maksimal Peserta',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_maxParticipants.toInt()} Orang',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _maxParticipants,
                min: 2,
                max: 15,
                divisions: 13,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.primaryLight,
                onChanged: (val) => setState(() => _maxParticipants = val),
              ),

              const SizedBox(height: 14),

              // 4. Lokasi Ruangan
              const Text(
                'Lokasi Ruangan / Spot',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              AppTextField(
                controller: _locationController,
                hintText: 'Pilih lokasi di peta',
                prefixIcon: const Icon(
                  Icons.pin_drop_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),

              const SizedBox(height: 16),

              // 5. Host Approval Switch
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: SwitchListTile.adaptive(
                  value: _requireHostApproval,
                  onChanged: (val) => setState(() => _requireHostApproval = val),
                  activeTrackColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Izin Knock dari Host',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: const Text(
                    'Peserta baru harus mengetuk (knock) dan disetujui host',
                    style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Submit Button
              AppPrimaryButton(
                text: 'Buka Ruang Belajar di Peta',
                onPressed: _handleCreateRoom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
