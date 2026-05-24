import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/features/auth/data/dto/login_dto.dart';

void main() {
  group('LoginRequest', () {
    test('creates with required fields', () {
      final req = const LoginRequest(email: 'a@b.com', password: 'secret');
      expect(req.email, 'a@b.com');
      expect(req.password, 'secret');
    });

    test('copyWith updates fields', () {
      final req = const LoginRequest(email: 'a@b.com', password: 'secret');
      final copy = req.copyWith(email: 'c@d.com');
      expect(copy.email, 'c@d.com');
      expect(copy.password, 'secret');
    });

    test('fromJson parses correctly', () {
      final req = LoginRequest.fromJson({'email': 'a@b.com', 'password': 'pwd'});
      expect(req.email, 'a@b.com');
      expect(req.password, 'pwd');
    });

    test('toJson serializes correctly', () {
      final req = const LoginRequest(email: 'a@b.com', password: 'pwd');
      expect(req.toJson(), {'email': 'a@b.com', 'password': 'pwd'});
    });
  });

  group('CtaResponse', () {
    test('creates with required fields', () {
      final cta = const CtaResponse(label: 'Go', url: 'https://example.com');
      expect(cta.label, 'Go');
      expect(cta.url, 'https://example.com');
    });

    test('fromJson parses correctly', () {
      final cta = CtaResponse.fromJson({'label': 'Go', 'url': 'https://example.com'});
      expect(cta.label, 'Go');
      expect(cta.url, 'https://example.com');
    });
  });

  group('MetaResponse', () {
    final metaJson = {
      'powered_by': 'Flutter',
      'docs_url': 'https://docs.com',
      'upgrade_url': 'https://upgrade.com',
      'example_url': 'https://example.com',
      'variant': 'v1',
      'message': 'Welcome',
      'cta': {'label': 'Go', 'url': 'https://example.com'},
      'context': 'login',
    };

    test('creates with required fields', () {
      final meta = MetaResponse.fromJson(metaJson);
      expect(meta.poweredBy, 'Flutter');
      expect(meta.cta.label, 'Go');
      expect(meta.context, 'login');
    });

    test('fromJson parses correctly', () {
      final meta = MetaResponse.fromJson(metaJson);
      expect(meta.message, 'Welcome');
      expect(meta.variant, 'v1');
    });
  });

  group('LoginResponse', () {
    final loginJson = {
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
    };

    test('creates from full JSON', () {
      final response = LoginResponse.fromJson(loginJson);
      expect(response.id, 1);
      expect(response.token, 'abc123');
      expect(response.meta.poweredBy, 'Flutter');
    });

    test('toJson serializes correctly', () {
      final response = LoginResponse.fromJson(loginJson);
      final json = response.toJson();
      expect(json['id'], 1);
      expect(json['token'], 'abc123');
      expect(json['_meta'], isA<MetaResponse>());
    });

    test('copyWith updates fields', () {
      final response = LoginResponse.fromJson(loginJson);
      final copy = response.copyWith(token: 'new_token');
      expect(copy.token, 'new_token');
      expect(copy.id, 1);
    });
  });
}
