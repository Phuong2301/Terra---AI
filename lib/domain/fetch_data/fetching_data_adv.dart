
class FetchingDataAdv<T, F extends Future<List<T>?>> {
  List<T>? datas;
  late F future;

  bool isFetching = false;

  initFetch() async {
    if (datas != null) return;
    if (isFetching) return;
    isFetching = true;
    final res = await getApiCall();
    if (res == null) return;
    isFetching = false;
    datas = res;
  }

  refresh() async {
    clear();
    await initFetch();
  }

  clear() {
    datas = null;
  }

  Future<List<T>?> getApiCall() async {
    return future;
  }
}