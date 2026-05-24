import 'package:use_me/features/auth/data/data.dart';
import 'package:use_me/features/auth/domain/domain.dart';

extension LoginMapper on LoginResponse {
  LoginEntity toEntity() {
    return LoginEntity(id: id ?? 0, token: token, meta: meta.toEntity());
  }
}

extension MetaMapper on MetaResponse {
  MetaEntity toEntity() {
    return MetaEntity(
      poweredBy: poweredBy,
      docsUrl: docsUrl,
      upgradeUrl: upgradeUrl,
      exampleUrl: exampleUrl,
      variant: variant,
      message: message,
      cta: cta.toEntity(),
      context: context,
    );
  }
}

extension CtaMapper on CtaResponse {
  CtaEntity toEntity() {
    return CtaEntity(label: label, url: url);
  }
}
