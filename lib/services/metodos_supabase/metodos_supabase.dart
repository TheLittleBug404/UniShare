import 'package:supabase_flutter/supabase_flutter.dart';
class MetodosSupabase {
  void getSession(SupabaseClient supabase) {
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      print('event: $event, session: $session');
      switch (event) {
        case AuthChangeEvent.initialSession:
        print('initial sesion');
        // handle initial session
        case AuthChangeEvent.signedIn:
        print('signed In');
        // handle signed in
        case AuthChangeEvent.signedOut:
        // handle signed out
        case AuthChangeEvent.passwordRecovery:
        // handle password recovery este cambia la contraseña podemos mandar a una nueva pagina 
        case AuthChangeEvent.tokenRefreshed:
        // handle token refreshed
        case AuthChangeEvent.userUpdated:
        // handle user updated
        case AuthChangeEvent.userDeleted:
        // handle user deleted
        case AuthChangeEvent.mfaChallengeVerified:
        print('FMA');
        // handle mfa challenge verified
      }
    });
  }
}
