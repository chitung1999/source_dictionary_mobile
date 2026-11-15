import 'package:english_app/core/constants/supabase_const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static final SupabaseService instance = SupabaseService._();

  late final SupabaseClient _client;

  Future<bool> initialize() async {
    try {
      await Supabase.initialize(
        url: SupabaseConst.url,
        publishableKey: SupabaseConst.publishableKey,
      );
    } catch (e) {
      return false;
    }

    _client = Supabase.instance.client;
    return true;
  }

  Future<List<dynamic>?> getVocabularies() async {
    try {
      return await _client.rpc('get_vocabularies') as List<dynamic>;
    } catch (e) {
      return null;
    }
  }
}