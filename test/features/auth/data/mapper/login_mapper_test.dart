import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/features/auth/auth.dart';
import 'package:use_me/features/auth/data/data.dart';
import 'package:use_me/features/auth/domain/domain.dart';

void main() {
  group('LoginMapper', () {
    final response = LoginResponse.fromJson({
      'id': 1,
      'token': 'abc123',
      '_meta': {
        'powered_by': 'Flutter',
        'docs_url': 'https://docs.com',
        'upgrade_url': 'https://upgrade.com',
        'example_url': 'https://example.com',
        'variant': 'v1',
        'message': 'Welcome',
        'cta': {'label': 'Go', 'url': 'https://example.com'},
        'context': 'login',
      },
    });

    test('maps LoginResponse to LoginEntity', () {
      final entity = response.toEntity();
      expect(entity, isA<LoginEntity>());
      expect(entity.id, 1);
      expect(entity.token, 'abc123');
    });

    test('maps MetaResponse to MetaEntity', () {
      final entity = response.toEntity();
      expect(entity.meta, isA<MetaEntity>());
      expect(entity.meta.poweredBy, 'Flutter');
      expect(entity.meta.message, 'Welcome');
      expect(entity.meta.context, 'login');
    });

    test('maps CtaResponse to CtaEntity', () {
      final entity = response.toEntity();
      expect(entity.meta.cta, isA<CtaEntity>());
      expect(entity.meta.cta.label, 'Go');
      expect(entity.meta.cta.url, 'https://example.com');
    });
  });
}
