class BuildConfig {
  static late final BuildConfig instance;

  final String fakeApiUrl;

  BuildConfig.fakeApi({
    this.fakeApiUrl = 'http://fake-api.tractian.com',
  }) {
    instance = this;
  }
}
