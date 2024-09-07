enum UriS { http, https, ftp, ws, wss, sftp, ssh }

extension BaseUrlSchemaX on UriS {
  String toUrlSchema() {
    return '$name://';
  }
}
