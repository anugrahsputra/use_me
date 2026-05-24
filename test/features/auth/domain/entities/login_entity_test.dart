import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/features/auth/domain/domain.dart';

void main() {
  group('CtaEntity', () {
    test('creates with required fields', () {
      final e = const CtaEntity(label: 'Go', url: 'https://example.com');
      expect(e.label, 'Go');
      expect(e.url, 'https://example.com');
    });

    test('copyWith updates', () {
      final e = const CtaEntity(label: 'Go', url: 'https://example.com');
      expect(e.copyWith(label: 'Back').label, 'Back');
    });
  });

  group('MetaEntity', () {
    test('creates with required fields', () {
      final e = MetaEntity(
        poweredBy: 'Flutter',
        docsUrl: 'https://docs.com',
        upgradeUrl: 'https://upgrade.com',
        exampleUrl: 'https://example.com',
        variant: 'v1',
        message: 'Welcome',
        cta: const CtaEntity(label: 'Go', url: 'https://example.com'),
        context: 'login',
      );
      expect(e.message, 'Welcome');
      expect(e.cta.label, 'Go');
    });

    test('copyWith updates', () {
      final e = MetaEntity(
        poweredBy: 'Flutter',
        docsUrl: 'https://docs.com',
        upgradeUrl: 'https://upgrade.com',
        exampleUrl: 'https://example.com',
        variant: 'v1',
        message: 'Welcome',
        cta: const CtaEntity(label: 'Go', url: 'https://example.com'),
        context: 'login',
      );
      expect(e.copyWith(message: 'Updated').message, 'Updated');
    });
  });

  group('LoginEntity', () {
    test('creates with required fields', () {
      final e = LoginEntity(
        id: 1,
        token: 'abc',
        meta: MetaEntity(
          poweredBy: 'Flutter',
          docsUrl: 'https://docs.com',
          upgradeUrl: 'https://upgrade.com',
          exampleUrl: 'https://example.com',
          variant: 'v1',
          message: 'Welcome',
          cta: const CtaEntity(label: 'Go', url: 'https://example.com'),
          context: 'login',
        ),
      );
      expect(e.id, 1);
      expect(e.token, 'abc');
      expect(e.meta.variant, 'v1');
    });

    test('copyWith updates', () {
      final e = LoginEntity(
        id: 1,
        token: 'abc',
        meta: MetaEntity(
          poweredBy: 'Flutter',
          docsUrl: 'https://docs.com',
          upgradeUrl: 'https://upgrade.com',
          exampleUrl: 'https://example.com',
          variant: 'v1',
          message: 'Welcome',
          cta: const CtaEntity(label: 'Go', url: 'https://example.com'),
          context: 'login',
        ),
      );
      expect(e.copyWith(token: 'xyz').token, 'xyz');
    });
  });
}
