import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Validation {
  final supabase = Supabase.instance.client;

  Future<bool> validateUser(String email, String password) async {
    try {
      final response = await supabase
          .from('usuarios')
          .select()
          .eq('email', email)
          .single();

      if (response == null) {
        return false;
      }

      final senhaHash = response['senha'];
    
      final isMatch = BCrypt.checkpw(password, senhaHash);

      return isMatch;
    } catch (e) {
      debugPrint('🚨 Erro ao validar usuário: $e');
      return false;
    }
  }
}
