import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/common/app_primary_button.dart';
import '../../../../core/common/app_text_field.dart';

/// Sub-route: /create-schedule
/// Form pembuatan jadwal belajar bersama rekan kampus
class CreateSchedulePage extends StatefulWidget {
  const CreateSchedulePage({super.key});

  @override
  State<CreateSchedulePage> createState() => _CreateSchedulePageState();
}

class _CreateSchedulePageState extends State<CreateSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _subjectController;
  late final TextEditingController _locationController;
  late final TextEditingController _timeController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: 'Sprint Belajar Bareng');
    _subjectController = TextEditingController(text: 'Algoritma & Pemrograman');
    _locationController = TextEditingController(text: 'Main Campus Library - Lt. 2');
    _timeController = TextEditingController(text: '15:30 - 17:30 WIB');
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jadwal belajar berhasil dibuat dan dibagikan!'),
          duration: Duration(seconds: 2),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textPrimaryColor),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Buat Jadwal Belajar',
          style: TextStyle(
            color: textPrimaryColor,
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
              // 1. Judul
              Text(
                'Nama Sesi Belajar',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 6),
              AppTextField(
                controller: _titleController,
                hintText: 'Contoh: Persiapan Ujian Tengah Semester',
                prefixIcon: Icon(
                  Icons.menu_book_rounded,
                  color: textSecondaryColor,
                  size: 20,
                ),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),

              const SizedBox(height: 16),

              // 2. Mata Kuliah
              Text(
                'Mata Kuliah / Topik',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 6),
              AppTextField(
                controller: _subjectController,
                hintText: 'Contoh: Rekayasa Perangkat Lunak',
                prefixIcon: Icon(
                  Icons.category_rounded,
                  color: textSecondaryColor,
                  size: 20,
                ),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),

              const SizedBox(height: 16),

              // 3. Waktu & Jam
              Text(
                'Jam Pelaksanaan',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 6),
              AppTextField(
                controller: _timeController,
                hintText: '15:30 - 17:30 WIB',
                prefixIcon: Icon(
                  Icons.access_time_rounded,
                  color: textSecondaryColor,
                  size: 20,
                ),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),

              const SizedBox(height: 16),

              // 4. Lokasi
              Text(
                'Lokasi Spot Kampus',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 6),
              AppTextField(
                controller: _locationController,
                hintText: 'Pilih perpustakaan atau coworking',
                prefixIcon: Icon(
                  Icons.location_on_rounded,
                  color: textSecondaryColor,
                  size: 20,
                ),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),

              const SizedBox(height: 16),

              // 5. Catatan
              Text(
                'Catatan Tambahan (Opsional)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 6),
              AppTextField(
                controller: _noteController,
                hintText: 'Contoh: Bawa laptop dan materi modul bab 3',
                prefixIcon: Icon(
                  Icons.notes_rounded,
                  color: textSecondaryColor,
                  size: 20,
                ),
              ),

              const SizedBox(height: 28),

              // Submit Button
              AppPrimaryButton(
                text: 'Simpan Jadwal & Ajak Teman',
                onPressed: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
