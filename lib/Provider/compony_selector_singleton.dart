class CompanySelector {
  String? pid;
  static final CompanySelector _CompanySelector = CompanySelector._internal();

  CompanySelector._internal();

  factory CompanySelector() {
    return _CompanySelector;
  }

  String getId() {
    return pid!;
  }
}
