import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ValidationUserWeb {
  final supabase = Supabase.instance.client;

  Future<bool> validateUserWeb(String email, String password) async {
    try {
      final response = await supabase
          .from('webUser')
          .select()
          .ilike('email', email)
          .maybeSingle();

      if (response == null) {
        debugPrint('🚨 Usuário não encontrado');
        return false;
      }

      final senhaHash = response['password'];
      final isMatch = BCrypt.checkpw(password, senhaHash);

      return isMatch;
    } catch (e) {
      debugPrint('🚨 Erro ao validar usuário: $e');
      return false;
    }
  }
}

class ValidationWebUserAdm {
  final supabase = Supabase.instance.client;

  // admsecretaria@unicv.com unicvsecretaria!@#

  Future<(bool, bool)> validateAdm(String email, String password) async {
    try {
      final response = await supabase
          .from('webUser')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (response == null) {
        debugPrint('🚨 Usuário não encontrado');
        return (false, false);
      }

      final senhaHash = response['password'];
      final isAdm = (response['isAdm'] ?? false) as bool;

      final isMatch = BCrypt.checkpw(password, senhaHash);

      return (isMatch, isAdm);
    } catch (e) {
      debugPrint('🚨 Erro ao validar usuário: $e');
      return (false, false);
    }
  }
}
