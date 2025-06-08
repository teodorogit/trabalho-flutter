import 'package:supabase_flutter/supabase_flutter.dart';

class ValidationUserWeb {
  final supabase = Supabase.instance.client;
    //admsecretaria@unicv.com  unicvsecretaria!@#
  Future<bool?> validateUserWeb(String email, String password) async {
    try {
      final trimmedEmail = email.trim(); 
      
      final emailCheck = await supabase
          .from('webUser')
          .select('user_id')
          .eq('email', trimmedEmail) 
          .maybeSingle();

      if (emailCheck == null) {
        print('Email não encontrado com correspondência exata na tabela webUser.');
        return null;
      }
      
      final response = await supabase.auth.signInWithPassword(
        email: trimmedEmail,
        password: password,
      );

      final user = response.user;

      if (user != null && user.id.isNotEmpty) {
        final profileResponse = await supabase
            .from('webUser')
            .select('isAdm')
            .eq('user_id', user.id)
            .eq('email', trimmedEmail) // mantém verificação exata
            .maybeSingle();

        if (profileResponse == null) {
          print('Usuário não encontrado na tabela webUser após login.');
          return null;
        }

        return true;
      } else {
        print('Login falhou: usuário nulo ou sem ID.');
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
