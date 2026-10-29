import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_calculator/core/constant/app_auth_state.dart';
import 'package:health_calculator/features/auth/data/models/auth_username_model.dart';
import 'package:health_calculator/features/auth/data/source/auth_local_source.dart';
import 'package:health_calculator/features/auth/data/source/auth_remote_source.dart';
import 'package:health_calculator/features/auth/view/viewmodels/auth_view_models.dart';
import 'package:health_calculator/features/auth/view/widgets/auth_login_form_widget.dart';
import 'package:health_calculator/features/auth/view/widgets/auth_signup_form_widget.dart';

class FakeSuccessAuthRemoteSource extends AuthRemoteSource {
  @override
  Future<String> signInWithUserName(AuthUsernameModel model) async {
    if (model.username == 'mor_2314' && model.password == '83r5^_') {
      return 'fake-jwt-token-12345';
    }
    throw Exception('username or password is incorrect');
  }

  @override
  Future<int> signUpWithUserName({
    required String username,
    required String password,
    String? email,
  }) async {
    if (username == 'new_user' && password == 'password123') {
      return 101;
    }
    throw Exception('Gagal mendaftar user baru');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('AuthLocalSource Unit Tests', () {
    test('saveToken, getToken, and deleteToken work properly', () async {
      final localSource = AuthLocalSource();

      expect(await localSource.hasToken(), isFalse);
      expect(await localSource.getToken(), isNull);

      final saved = await localSource.saveToken('test-token-abc');
      expect(saved, isTrue);
      expect(await localSource.hasToken(), isTrue);
      expect(await localSource.getToken(), 'test-token-abc');

      final savedUsername = await localSource.saveUsername('testuser');
      expect(savedUsername, isTrue);
      expect(await localSource.getUsername(), 'testuser');

      final deleted = await localSource.deleteToken();
      expect(deleted, isTrue);
      expect(await localSource.hasToken(), isFalse);
      expect(await localSource.getToken(), isNull);
      expect(await localSource.getUsername(), isNull);
    });
  });

  group('AuthViewModel signInWithUserName Tests', () {
    test('Successful login sets AppAuthStateSuccess and stores session', () async {
      final localSource = AuthLocalSource();
      final remoteSource = FakeSuccessAuthRemoteSource();
      final vm = AuthViewModel(remoteSource, localSource);

      expect(vm.isAuthenticated, isFalse);

      await vm.signInWithUserName('mor_2314', '83r5^_');

      expect(vm.isAuthenticated, isTrue);
      expect(vm.stateLogin, isA<AppAuthStateSuccess>());
      expect(vm.currentUser?.name, 'mor_2314');
      expect(await localSource.getToken(), 'fake-jwt-token-12345');
      expect(await localSource.getUsername(), 'mor_2314');

      // Test signOut clears token
      await vm.signOut();
      expect(vm.isAuthenticated, isFalse);
      expect(await localSource.getToken(), isNull);
    });

    test('Failed login sets AppAuthStateError', () async {
      final localSource = AuthLocalSource();
      final remoteSource = FakeSuccessAuthRemoteSource();
      final vm = AuthViewModel(remoteSource, localSource);

      await vm.signInWithUserName('wrong_user', 'wrong_pass');

      expect(vm.isAuthenticated, isFalse);
      expect(vm.stateLogin, isA<AppAuthStateError>());
      final errorState = vm.stateLogin as AppAuthStateError;
      expect(errorState.message, contains('username or password is incorrect'));
    });
  });

  group('AuthViewModel signUpWithUserName Tests', () {
    test('Successful signup sets AppAuthStateSuccess and stores session', () async {
      final localSource = AuthLocalSource();
      final remoteSource = FakeSuccessAuthRemoteSource();
      final vm = AuthViewModel(remoteSource, localSource);

      await vm.signUpWithUserName(username: 'new_user', password: 'password123');

      expect(vm.isAuthenticated, isTrue);
      expect(vm.stateLogin, isA<AppAuthStateSuccess>());
      expect(vm.currentUser?.name, 'new_user');
      expect(await localSource.getToken(), 'fakestore-jwt-101-new_user');
      expect(await localSource.getUsername(), 'new_user');
    });

    test('Failed signup sets AppAuthStateError', () async {
      final localSource = AuthLocalSource();
      final remoteSource = FakeSuccessAuthRemoteSource();
      final vm = AuthViewModel(remoteSource, localSource);

      await vm.signUpWithUserName(username: 'bad_user', password: 'bad_password');

      expect(vm.isAuthenticated, isFalse);
      expect(vm.stateLogin, isA<AppAuthStateError>());
      final errorState = vm.stateLogin as AppAuthStateError;
      expect(errorState.message, contains('Gagal mendaftar user baru'));
    });
  });

  group('AuthLoginFormWidget Tests', () {
    testWidgets('Renders username & password fields and triggers onUsernameSubmit', (tester) async {
      String? submittedUsername;
      String? submittedPassword;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AuthLoginFormWidget(
                onUsernameSubmit: (u, p) {
                  submittedUsername = u;
                  submittedPassword = p;
                },
              ),
            ),
          ),
        ),
      );

      // Verify no campus email text appears
      expect(find.text('Email Kampus'), findsNothing);
      expect(find.text('atau masuk dengan username'), findsOneWidget);
      expect(find.text('Masuk dengan Username'), findsOneWidget);

      // Enter username & password
      await tester.enterText(find.byType(TextFormField).at(0), 'mor_2314');
      await tester.enterText(find.byType(TextFormField).at(1), '83r5^_');
      await tester.pump();

      // Tap submit button
      await tester.tap(find.text('Masuk dengan Username'));
      await tester.pumpAndSettle();

      expect(submittedUsername, 'mor_2314');
      expect(submittedPassword, '83r5^_');
    });
  });

  group('AuthSignUpFormWidget Tests', () {
    testWidgets('Renders username, password, confirm password fields and triggers onSubmit', (tester) async {
      String? submittedUsername;
      String? submittedPassword;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AuthSignUpFormWidget(
                onSubmit: ({required username, required password}) {
                  submittedUsername = username;
                  submittedPassword = password;
                },
              ),
            ),
          ),
        ),
      );

      // Verify no campus email text appears
      expect(find.text('Email Kampus'), findsNothing);
      expect(find.text('Daftar dengan Username'), findsOneWidget);

      // Enter username, password, and confirmation
      await tester.enterText(find.byType(TextFormField).at(0), 'new_user');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.pump();

      // Tap submit button
      await tester.tap(find.text('Daftar dengan Username'));
      await tester.pumpAndSettle();

      expect(submittedUsername, 'new_user');
      expect(submittedPassword, 'password123');
    });
  });
}
