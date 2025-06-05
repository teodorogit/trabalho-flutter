import 'package:supabase_flutter/supabase_flutter.dart';

class ValidationUserWeb {
  final supabase = Supabase.instance.client;
  //admsecretaria@unicv.com  unicvsecretaria!@#
  Future<bool?> validateUserWeb(
      String email, String password, bool isAdmin) async {
    print('validateUserWeb: valor parametro is adm: ${isAdmin}');
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      print('validateUserWeb: valor parametro is adm: ${user}');
      
      if (user != null && user.id.isNotEmpty) {
        if (user.email != email) {
          print(
              'Email digitado não corresponde ao email cadastrado.');
          return null;
        }
      }

      if (user != null && user.id.isNotEmpty) {
        final profileResponse = await supabase
            .from('webUser')
            .select('isAdm')
            .eq('user_id', user.id)
            .ilike('email', email)
            .maybeSingle();

          print('validateUserWeb:Usuário padrão: ${user}');
          print(' validateUserWeb: profile: ${profileResponse}');

        if (profileResponse == null) {
          print('Usuário não encontrado na tabela webUser.');
          return null;
        }

        final profileIsAdm = profileResponse['isAdm'] as bool;

        if (profileIsAdm && isAdmin) {
          return true;
        }

        return false;
      } else {
        return null;
      }
    } on AuthException catch (e) {
      print('Erro de autenticação: ${e.message}');
      return null;
    } catch (e) {
      print('Erro inesperado: $e');
      return null;
    }
  }

  Future<bool?> validate(String email, String password, bool isAdmin) async {
    print('validate: valor parametro is adm: ${isAdmin}');
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      print('validate: padrão: ${user}');
      if (user != null && user.id.isNotEmpty) {
        if (user.email != email) {
          print(
              'Email digitado não corresponde ao email cadastrado.');
          return null;
        }
      }

      if (user != null && user.id.isNotEmpty) {
        final profileResponse = await supabase
            .from('webUser')
            .select('isAdm')
            .eq('user_id', user.id)
            .ilike('email', email)
            .maybeSingle();

        if (profileResponse == null) {
          print('Usuário não encontrado na tabela webUser.');
          return null;
        }

        final profileIsAdm = profileResponse['isAdm'] as bool;

        if (!profileIsAdm && !isAdmin) {
          return true;
        }

        return false;
      } else {
        return null;
      }
    } on AuthException catch (e) {
      print('Erro de autenticação: ${e.message}');
      return null;
    } catch (e) {
      print('Erro inesperado: $e');
      return null;
    }
  }
}
